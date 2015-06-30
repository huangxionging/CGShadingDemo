//
//  ShadingView.m
//  CGShadingDemo
//
//  Created by huangxiong on 15/6/26.
//  Copyright (c) 2015年 New_Life. All rights reserved.
//

#import "ShadingView.h"

@implementation ShadingView

- (void) setBackgroundImage {
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, 375, 400)];
        [self addSubview: _imageView];
    }
    
    _imageView.image = [self imageByShadingWith: [UIColor cyanColor] andWith: CGRectMake(0, 0, 375, 266)];
    _imageView.backgroundColor = [UIColor brownColor];
}


- (UIImage *) imageByShadingWith:(UIColor *) color andWith:(CGRect) rect {
    
    // 颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // 设备环境
    CGContextRef ctx = CGBitmapContextCreate(nil, rect.size.width, rect.size.height, 8, rect.size.width * 4, colorSpace, (CGBitmapInfo) kCGImageAlphaPremultipliedFirst);
    
//    CGPoint     startPoint,
//    endPoint;
//    CGFunctionRef myFunctionObject;
//    CGShadingRef myShading;
//    
//    startPoint = CGPointMake(0,100.5);
//    endPoint = CGPointMake(1,100.5);
//    myFunctionObject = myGetFunction (colorSpace);
//    
//    myShading = CGShadingCreateAxial (colorSpace,
//                                      startPoint, endPoint,
//                                      myFunctionObject,
//                                      false, false);
//    CGContextDrawShading (ctx, myShading);
    
    myPaintAxialShading(ctx, rect);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    
    
    return [UIImage imageWithCGImage: imageRef];
}

static void myCalculateShadingValues (void *info,
                                      const CGFloat *in,
                                      CGFloat *out)
{
    CGFloat v;
    size_t k, components;
    static const CGFloat c[] = {0.0, 1.0, .0, 1};
    
    components = (size_t)info;
    
    v = *in;
    for (k = 0; k < components -1; k++)
        *out++ = c[k] * v;
    *out++ = 1;
}

static CGFunctionRef myGetFunction (CGColorSpaceRef colorspace)
{
    size_t numComponents;
    static const CGFloat input_value_range [2] = { 0, 1 };
    static const CGFloat output_value_ranges [8] = { 0, 1, 0, 1, 0, 1, 0, 1 };
    static const CGFunctionCallbacks callbacks = { 0,
        &myCalculateShadingValues,
        NULL };
    
    numComponents = 1 + CGColorSpaceGetNumberOfComponents (colorspace);
    return CGFunctionCreate ((void *) numComponents,
                             1,
                             input_value_range,
                             numComponents,
                             output_value_ranges, 
                             &callbacks);
}

void myPaintAxialShading (CGContextRef myContext,
                          CGRect bounds)
{
    CGPoint	 startPoint,
    endPoint;
    CGAffineTransform myTransform;
    CGFloat width = bounds.size.width;
    CGFloat height = bounds.size.height;
    
    
    startPoint = CGPointMake(0,0.5);
    endPoint = CGPointMake(1,0.5);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFunctionRef myShadingFunction = myGetFunction(colorspace);
    
    CGShadingRef shading = CGShadingCreateAxial (colorspace,
                                    startPoint, endPoint,
                                    myShadingFunction,
                                    true, true);
    
    myTransform = CGAffineTransformMakeScale (width, height);
    CGContextConcatCTM (myContext, myTransform);
    CGContextSaveGState (myContext);
    
    CGContextClipToRect (myContext, CGRectMake(0, 0, 100, 100));
    CGContextSetRGBFillColor (myContext, 1, 1, 1, 1);
    CGContextFillRect (myContext, CGRectMake(0, 0, 100, 100));
    
    CGContextBeginPath (myContext);
    CGContextAddArc (myContext, .5, .5, 1, 0, 10.9, 0);
    CGContextClosePath (myContext);
    CGContextClip (myContext);
    
    CGContextDrawShading (myContext, shading);
    CGColorSpaceRelease (colorspace);
    CGShadingRelease (shading);
    CGFunctionRelease (myShadingFunction);
    
    CGContextRestoreGState (myContext); 
}

@end
