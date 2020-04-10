//
//  OpenGLES_Class_1.h
//  LHQOpenGLESDemo
//
//  Created by Xhorse_iOS3 on 2020/4/10.
//  Copyright © 2020 LHQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenGLES_Class_1 : GLKViewController

{
    // 保存了用于盛放用到的顶点数据缓存的标识符
    GLuint vertexBufferID;
}

@property (strong, nonatomic) GLKBaseEffect *baseEffect;


@end

NS_ASSUME_NONNULL_END
