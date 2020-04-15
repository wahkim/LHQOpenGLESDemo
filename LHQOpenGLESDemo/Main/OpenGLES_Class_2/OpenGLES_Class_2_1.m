//
//  OpenGLES_Class_2_1.m
//  LHQOpenGLESDemo
//
//  Created by Xhorse_iOS3 on 2020/4/14.
//  Copyright © 2020 LHQ. All rights reserved.
//

#import "OpenGLES_Class_2_1.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "AGLKContext.h"

@interface OpenGLES_Class_2_1 ()



@end

@implementation OpenGLES_Class_2_1

@synthesize baseEffect;
@synthesize vertexBuffer;

typedef struct {
   GLKVector3  positionCoords;
   GLKVector2  textureCoords;
}
SceneVertex;

static const SceneVertex vertices[] =
{
   {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}}, // 左下
   {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}}, // 右下
   {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}}, // 左上
    
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}}, // 左上
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}}, // 右下
    {{ 0.5f, 0.5f, 0.0f}, {1.0f, 1.0f}}, // 右下
};

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    GLKView *view = [[GLKView alloc]init];
    self.view = view;

    view.context = [[AGLKContext alloc]
       initWithAPI:kEAGLRenderingAPIOpenGLES2];
    

    [AGLKContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(
       0.4f, // Red
       1.0f, // Green
       1.0f, // Blue
       1.0f);// Alpha
    
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(
       198/255.0, 164/255.0, 249/255.0, 1.0f);// Alpha
    
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                         initWithAttribStride:sizeof(SceneVertex)
                         numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)
                         bytes:vertices
                         usage:GL_STATIC_DRAW];
    
    // Setup texture
    CGImageRef imageRef =
       [[UIImage imageNamed:@"leaves.gif"] CGImage];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@(1), GLKTextureLoaderOriginBottomLeft, nil];

    GLKTextureInfo *textureInfo = [GLKTextureLoader
       textureWithCGImage:imageRef
       options:options
       error:NULL];

    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
   [self.baseEffect prepareToDraw];
      
   // Clear back frame buffer (erase previous drawing)
   [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT];
   
   [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
      numberOfCoordinates:3
      attribOffset:offsetof(SceneVertex, positionCoords)
      shouldEnable:YES];
    
   [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0
      numberOfCoordinates:2
      attribOffset:offsetof(SceneVertex, textureCoords)
      shouldEnable:YES];
      
   // Draw triangles using the first three vertices in the
   // currently bound vertex buffer
   [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
      startVertexIndex:0
      numberOfVertices:6];
}

- (void)viewDidUnload
{
   [super viewDidUnload];
   
   // Make the view's context current
   GLKView *view = (GLKView *)self.view;
   [AGLKContext setCurrentContext:view.context];
    
   // Delete buffers that aren't needed when view is unloaded
   self.vertexBuffer = nil;
   
   // Stop using the context created in -viewDidLoad
   ((GLKView *)self.view).context = nil;
   [EAGLContext setCurrentContext:nil];
}



@end
