//
//  MyGLView.m
//  OpenGL
//
//  Created by Yifan on 2017/4/12.
//  Copyright © 2017年 Yifan. All rights reserved.
//

#import "MyGLView.h"

@interface MyGLView(){
    EAGLContext *context;
}

@end
@implementation MyGLView

+(Class)layerClass {
    return [CAEAGLLayer class];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setupGL];
}

- (void)setupGL {
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!context) {
        NSLog(@"create EAGLContext failed.");
        return;
    }
    if (![EAGLContext setCurrentContext:context]) {
        NSLog(@"set EAGLContext failed.");
        return;
    }
    
    CAEAGLLayer *layer = (CAEAGLLayer *)self.layer;
    layer.opaque = YES;
    layer.contentsScale = [UIScreen mainScreen].scale;
    
    GLuint renderbuffer;
    glGenRenderbuffers(1, &renderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, renderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:layer];
    
    GLint renderbufferWidth, renderbufferHeight;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &renderbufferWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &renderbufferHeight);
    
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderbuffer);
    
    NSLog(@"Width %d, height %d ,", renderbufferWidth, renderbufferHeight);
    
    char vShaderStr[] =
    "#version 300 es                          \n"
    "layout(location = 0) in vec4 vPosition;  \n"
    "void main()                              \n"
    "{                                        \n"
    "   gl_Position = vPosition;              \n"
    "}                                        \n";
    
    
    char fShaderStr[] =
    "#version 300 es                              \n"
    "precision mediump float;                     \n"
    "out vec4 fragColor;                          \n"
    "void main()                                  \n"
    "{                                            \n"
    "   fragColor = vec4 ( 1.0, 0.0, 0.0, 1.0 );  \n"
    "}                                            \n";
    
    GLuint vertexShader;
    GLuint fragmentShader;
    GLuint programObject;
    GLint linked;
    
    vertexShader = LoadShader(GL_VERTEX_SHADER, vShaderStr);
    fragmentShader = LoadShader(GL_FRAGMENT_SHADER, fShaderStr);
    
    // Create the program object
    programObject = glCreateProgram ();
    if ( programObject == 0 )
    {
        NSLog(@"Error");
    }
    
    glAttachShader ( programObject, vertexShader );
    glAttachShader ( programObject, fragmentShader );
    
    glLinkProgram ( programObject );
    
    // Check the link status
    glGetProgramiv ( programObject, GL_LINK_STATUS, &linked );

    if (!linked) {
        NSLog(@"link error");
        GLint infoLength;
        glGetProgramiv(programObject, GL_INFO_LOG_LENGTH, &infoLength);
        if (infoLength > 0) {
            GLchar *infoLog = malloc(sizeof(GLchar) * infoLength);
            glGetProgramInfoLog(programObject, infoLength, NULL, infoLog);
            printf("Error linking program %s\n", infoLog);
            free(infoLog);
        }
        glDeleteProgram ( programObject );
    }
    
    glClearColor(1.0f, 0.0f, 1.0f, 1.0f);
    
    GLfloat vVertices[] = {  0.0f,  0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f,
        0.5f, -0.5f, 0.0f
    };
    
    // Set the viewport
    glViewport ( 0, 0, 480, 480 );
    
    // Clear the color buffer
    glClear ( GL_COLOR_BUFFER_BIT );
    
    // Use the program object
    glUseProgram (programObject);
    
    // Load the vertex data
    glVertexAttribPointer ( 0, 3, GL_FLOAT, GL_FALSE, 0, vVertices );
    glEnableVertexAttribArray ( 0 );
    
    glDrawArrays ( GL_TRIANGLES, 0, 3 );
    
    [context presentRenderbuffer:GL_RENDERBUFFER];
}

GLuint LoadShader ( GLenum type, const char *shaderSrc )
{
    GLuint shader;
    GLint compiled;
    
    // Create the shader object
    shader = glCreateShader ( type );
    
    if ( shader == 0 )
    {
        return 0;
    }
    
    // Load the shader source
    glShaderSource ( shader, 1, &shaderSrc, NULL );
    
    // Compile the shader
    glCompileShader ( shader );
    
    // Check the compile status
    glGetShaderiv ( shader, GL_COMPILE_STATUS, &compiled );
    
    if ( !compiled )
    {
        GLint infoLen = 0;
        
        glGetShaderiv ( shader, GL_INFO_LOG_LENGTH, &infoLen );
        
        if ( infoLen > 1 )
        {
            char *infoLog = malloc ( sizeof ( char ) * infoLen );
            
            glGetShaderInfoLog ( shader, infoLen, NULL, infoLog );
            NSLog(@"Error compiling shader:\n%s\n", infoLog );
            
            free ( infoLog );
        }
        
        glDeleteShader ( shader );
        return 0;
    }
    
    return shader;
    
}
- (void)dealloc {
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext: nil];
    }
}
@end
