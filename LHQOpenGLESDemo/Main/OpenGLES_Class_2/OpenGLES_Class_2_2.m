//
//  OpenGLES_Class_2_2.m
//  LHQOpenGLESDemo
//
//  Created by Xhorse_iOS3 on 2020/4/15.
//  Copyright © 2020 LHQ. All rights reserved.
//

#import "OpenGLES_Class_2_2.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "AGLKContext.h"

@interface OpenGLES_Class_2_2 ()

@property (nonatomic, strong) EAGLContext   *mContext;
@property (nonatomic, strong) GLKView       *mView;

@end

@implementation OpenGLES_Class_2_2

@synthesize baseEffect;
@synthesize vertexBuffer;
@synthesize shouldUseLinearFilter;
@synthesize shouldAnimate;
@synthesize shouldRepeatTexture;
@synthesize sCoordinateOffset;

typedef struct {
   GLKVector3  positionCoords;
   GLKVector2  textureCoords;
}
SceneVertex;

static SceneVertex vertices[] =
{
   {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}}, // lower left corner
   {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}}, // lower right corner
   {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}}, // upper left corner
};

static const SceneVertex defaultVertices[] =
{
   {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}},
   {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}},
   {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}},
};

static GLKVector3 movementVectors[3] = {
   {-0.02f,  -0.01f, 0.0f},
   {0.01f,  -0.005f, 0.0f},
   {-0.01f,   0.01f, 0.0f},
};

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupConfig];
    [self uploadVertexArray];
    [self uploadTexture];
    [self setupViews];
    
}

#pragma mark - Set Up

- (void)setupConfig
{
    self.mView  = (GLKView *)self.view;
    self.mContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    self.mView.context = self.mContext;
    [EAGLContext setCurrentContext:self.mContext];
    
    self.preferredFramesPerSecond = 60; // 更新视图的速率 默认值为30每秒帧数
    self.shouldAnimate = YES;
    self.shouldRepeatTexture = YES;
}

- (void)setupViews
{
    NSArray *array = @[@"Linear Filter", @"Animation", @"Repeat Texture"];
    
    UIView *tempView;
    for (NSInteger index = 0; index < 3; index ++) {
        UISwitch *sw = [[UISwitch alloc] init];
        sw.frame = CGRectMake(20, 88 + index * (40+10), 50, 40);
        sw.tag = index;
        [sw addTarget:self action:@selector(takeShouldUseFrom:) forControlEvents:UIControlEventValueChanged];
        [self.mView addSubview:sw];
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(CGRectGetMaxX(sw.frame), 88 + index * (40+10), 120, 40);
        label.text = array[index];
        [self.mView addSubview:label];
        tempView = sw;
    }
    
    UISlider *slider = [[UISlider alloc] init];
    slider.frame = CGRectMake(CGRectGetMidX(tempView.frame), CGRectGetMaxY(tempView.frame) + 5, 150, 40);
    [self.mView addSubview:slider];
    slider.minimumValue = -1;
    slider.maximumValue = 1;
    [slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)uploadVertexArray
{
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc]
    initWithAttribStride:sizeof(SceneVertex)
    numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)
    bytes:vertices
    usage:GL_DYNAMIC_DRAW];
    
    // 渲染纹理坐标做好准备
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
       numberOfCoordinates:3
       attribOffset:offsetof(SceneVertex, positionCoords)
       shouldEnable:YES];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0
       numberOfCoordinates:2
       attribOffset:offsetof(SceneVertex, textureCoords)
       shouldEnable:YES];
}

- (void)uploadTexture
{
    // 着色器
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(
       0.4f, // Red
       1.0f, // Green
       1.0f, // Blue
       1.0f);// Alpha
    
    // 创建纹理
    CGImageRef imageRef = [[UIImage imageNamed:@"grid.png"] CGImage];
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:imageRef options:nil error:NULL];
    
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
}




- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // 背景色
    glClearColor(198/255.0, 164/255.0, 249/255.0, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // 启动着色器
   [self.baseEffect prepareToDraw];
      
    // 开始渲染
   [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
      startVertexIndex:0
      numberOfVertices:3];
}

#pragma mark - Update Method

- (void)updateTextureParameters
{
    // 配置每个绑定的纹理
    glBindTexture(self.baseEffect.texture2d0.target,
                  self.baseEffect.texture2d0.name);
    glTexParameteri(self.baseEffect.texture2d0.target,
                    GL_TEXTURE_WRAP_T,
                    (self.shouldRepeatTexture ?GL_REPEAT : GL_CLAMP_TO_EDGE));
    
    glBindTexture(self.baseEffect.texture2d0.target, // GLKTextureTarget2D
                  self.baseEffect.texture2d0.name);
    glTexParameteri(self.baseEffect.texture2d0.target,
                    GL_TEXTURE_MAG_FILTER,
                    (self.shouldUseLinearFilter ? GL_LINEAR : GL_NEAREST));
    
    /**
     《TextureParameterName》
     GL_TEXTURE_MAG_FILTER 用于在没有足够的可用纹素来唯一性的映射一个或者多个纹素到每个片元上时配置取样
     GL_TEXTURE_MIN_FILTER
     GL_TEXTURE_WRAP_S
     GL_TEXTURE_WRAP_T
     
    《TextureWrapMode》
     GL_REPEAT
     GL_CLAMP_TO_EDGE
     GL_MIRRORED_REPEAT
     
    《TextureMagFilter》
     GL_LINEAR  放大纹理效果，模糊出现在渲染的三角形上
     GL_NEAREST 拾取与片元的U、V位置接近的纹素的颜色
     */
}

- (void)updateAnimatedVertexPositions
{
    // 开启动画
   if(shouldAnimate)
   {
      int i;
      
      for(i = 0; i < 3; i++)
      {
         vertices[i].positionCoords.x += movementVectors[i].x;
         if(vertices[i].positionCoords.x >= 1.0f ||
            vertices[i].positionCoords.x <= -1.0f)
         {
            movementVectors[i].x = -movementVectors[i].x;
         }
         vertices[i].positionCoords.y += movementVectors[i].y;
         if(vertices[i].positionCoords.y >= 1.0f ||
            vertices[i].positionCoords.y <= -1.0f)
         {
            movementVectors[i].y = -movementVectors[i].y;
         }
         vertices[i].positionCoords.z += movementVectors[i].z;
         if(vertices[i].positionCoords.z >= 1.0f ||
            vertices[i].positionCoords.z <= -1.0f)
         {
            movementVectors[i].z = -movementVectors[i].z;
         }
      }
   }
    // 关闭动画 （回到初始位置）
   else
   {
      int i;
      
      for(i = 0; i < 3; i++)
      {
         vertices[i].positionCoords.x = defaultVertices[i].positionCoords.x;
         vertices[i].positionCoords.y = defaultVertices[i].positionCoords.y;
         vertices[i].positionCoords.z = defaultVertices[i].positionCoords.z;
            
      }
   }
   
   
   {
      int i;
      
      for(i = 0; i < 3; i++)
      {
         vertices[i].textureCoords.t = (defaultVertices[i].textureCoords.t + sCoordinateOffset);
      }
   }
}

- (void)update
{
   [self updateAnimatedVertexPositions];
   [self updateTextureParameters];
   
   [vertexBuffer reinitWithAttribStride:sizeof(SceneVertex)
      numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)
      bytes:vertices];
}

#pragma mark - Actions Method

- (void)takeShouldUseFrom:(UISwitch *)sender
{
    switch (sender.tag) {
        case 0:
        {
            self.shouldUseLinearFilter = [sender isOn];
        }
            break;
        case 1:
        {
          self.shouldAnimate = [sender isOn];
        }
            break;
        case 2:
        {
            self.shouldRepeatTexture = [sender isOn];
        }
            break;
            
        default:
            break;
    }
}

- (void)sliderChange:(UISlider *)sender
{
    self.sCoordinateOffset = [sender value];
}



@end
