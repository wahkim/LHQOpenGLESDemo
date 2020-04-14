//
//  OpenGLES_Class_2_1.h
//  LHQOpenGLESDemo
//
//  Created by Xhorse_iOS3 on 2020/4/14.
//  Copyright © 2020 LHQ. All rights reserved.
//

#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AGLKVertexAttribArrayBuffer;


@interface OpenGLES_Class_2_1 : GLKViewController

@property (nonatomic, strong) GLKBaseEffect *baseEffect;
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *vertexBuffer;

@end

NS_ASSUME_NONNULL_END
