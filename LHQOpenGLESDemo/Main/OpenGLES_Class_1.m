//
//  OpenGLES_Class_1.m
//  LHQOpenGLESDemo
//
//  Created by Xhorse_iOS3 on 2020/4/10.
//  Copyright © 2020 LHQ. All rights reserved.
//

#import "OpenGLES_Class_1.h"

@implementation OpenGLES_Class_1


typedef struct {
    // 矢量保存坐标 {x,y,z}
   GLKVector3  positionCoords;
}
SceneVertex;

// 三个顶点坐标数组
static const SceneVertex vertices[] =
{
   {{-0.5f, -0.5f, 0.0}}, // lower left corner
   {{ 0.5f, -0.5f, 0.0}}, // lower right corner
   {{-0.5f,  0.5f, 0.0}}  // upper left corner
};

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]],
       @"View controller's view is not a GLKView");
    
    // 创建上下文 EAGL “Embedded Apple GL”
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    // 设置当前内容上下文
    [EAGLContext setCurrentContext:view.context];
    
    // 创建渲染类
    self.baseEffect = [[GLKBaseEffect alloc] init];
    // 使用恒定不变的颜色，即白色
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(
       1.0f, // Red
       1.0f, // Green
       1.0f, // Blue
       1.0f);// Alpha
    
    
    // “清除颜色” like 背景色
    // 用于上下帧被清除时初始化每个像素的值
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    // 为缓存生成独一无的标识符
    // @param n 指定要生成的标识符数量
    // @param GLuint 是一个指针，指向生成的标识符内存保存位置
    glGenBuffers(1,&vertexBufferID);
    
    // 为接下来的运算绑定缓存
    // @param GLenum 常量，指定要绑定的哪一种缓存 （GL_ARRAY_BUFFER 指定一个顶点属性数组）
    // @param GLuint 要绑定缓存的标识符
    glBindBuffer(GL_ARRAY_BUFFER,vertexBufferID);
    
    // 复制数据到缓存中
    // @param GLenum 常量，指定要绑定的哪一种缓存 （GL_ARRAY_BUFFER 指定一个顶点属性数组）
    // @param GLsizeiptr 指定要复制进这个缓存的字节的数量
    // @param GLvoid 要复制的字节的地址
    // @param GLenum 提示缓存在未来的运算可能被怎样运用
    //  GL_STATIC_DRAW 告诉上下文，缓存内容适合复制到GPU控制的内存
    //  GL_DYNAMIC_DRAW 告诉上下文，缓存内的数据会频繁的改变
    glBufferData(GL_ARRAY_BUFFER,
                 sizeof(vertices),
                 vertices,
                 GL_STATIC_DRAW);
}

// 
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
   [self.baseEffect prepareToDraw];
   
   // Clear Frame Buffer (erase previous drawing)
   glClear(GL_COLOR_BUFFER_BIT);
   
   // Enable use of positions from bound vertex buffer
   glEnableVertexAttribArray(      // STEP 4
      GLKVertexAttribPosition);
      
   glVertexAttribPointer(          // STEP 5
      GLKVertexAttribPosition,
      3,                   // three components per vertex
      GL_FLOAT,            // data is floating point
      GL_FALSE,            // no fixed point scaling
      sizeof(SceneVertex), // no gaps in data
      NULL);               // NULL tells GPU to start at
                           // beginning of bound buffer
                                   
   // Draw triangles using the first three vertices in the
   // currently bound vertex buffer
   glDrawArrays(GL_TRIANGLES,      // STEP 6
      0,  // Start with first vertex in currently bound buffer
      3); // Use three vertices from currently bound buffer
}


/////////////////////////////////////////////////////////////////
// Called when the view controller's view has been unloaded
// Perform clean-up that is possible when you know the view
// controller's view won't be asked to draw again soon.
- (void)viewDidUnload
{
   [super viewDidUnload];
   
   // Make the view's context current
   GLKView *view = (GLKView *)self.view;
   [EAGLContext setCurrentContext:view.context];
    
   // Delete buffers that aren't needed when view is unloaded
   if (0 != vertexBufferID)
   {
      glDeleteBuffers (1,          // STEP 7
                       &vertexBufferID);
      vertexBufferID = 0;
   }
   
   // Stop using the context created in -viewDidLoad
   ((GLKView *)self.view).context = nil;
   [EAGLContext setCurrentContext:nil];
}

@end
