//
//  OpenGLES_Class_2_2.h
//  LHQOpenGLESDemo
//
//  Created by Xhorse_iOS3 on 2020/4/15.
//  Copyright © 2020 LHQ. All rights reserved.
//

#import <GLKit/GLKit.h>


NS_ASSUME_NONNULL_BEGIN

@class AGLKVertexAttribArrayBuffer;

@interface OpenGLES_Class_2_2 : GLKViewController

@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer *vertexBuffer;
@property (nonatomic) BOOL shouldUseLinearFilter;
@property (nonatomic) BOOL shouldAnimate;
@property (nonatomic) BOOL shouldRepeatTexture;
@property (nonatomic) GLfloat sCoordinateOffset;

@end

NS_ASSUME_NONNULL_END
