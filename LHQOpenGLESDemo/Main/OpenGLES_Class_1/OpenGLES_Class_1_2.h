//
//  OpenGLES_Class_2.h
//  LHQOpenGLESDemo
//
//  Created by hq.Lin on 2020/4/13.
//  Copyright © 2020 LHQ. All rights reserved.
//

#import "AGLKViewController.h"
#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenGLES_Class_1_2 : GLKViewController

{
   GLuint vertexBufferID;
}

@property (strong, nonatomic) GLKBaseEffect *baseEffect;

@end

NS_ASSUME_NONNULL_END
