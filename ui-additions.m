//
//  ui-additions.m
//  debug-logging-ios
//
//  Created by Adrian Kemp on 2013-03-01.
//  Copyright (c) 2013 Adrian Kemp. All rights reserved.
//

#import "ui-additions.h"
#import <QuartzCore/QuartzCore.h>

void UIViewUpdateFrameIfNeeded(UIView *view, CGRect frame) {
    frame = CGRectApplyAffineTransform(frame, view.transform);
    NSLog(@"frame: %@, view frame: %@", NSStringFromCGRect(frame), NSStringFromCGRect(view.frame));
    if(CGRectEqualToRect(frame, view.frame)) {
        return;
    } else {
        view.frame = frame;
    }
}

UIImage *UIImageFromUIView(UIView *view) {
    if (CGRectIsEmpty(view.bounds)) {
        return nil;
    }
    
    CGFloat scaleFactor = [UIScreen mainScreen].scale;
    view.layer.rasterizationScale = scaleFactor;
    CGAffineTransform screenScaleTransform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
    CGSize actualViewSize = CGSizeApplyAffineTransform(view.bounds.size, screenScaleTransform);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    
    CGContextRef context = CGBitmapContextCreate(nil, actualViewSize.width, actualViewSize.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextScaleCTM(context, scaleFactor, -scaleFactor);
    CGContextTranslateCTM(context, 0.0f, -view.bounds.size.height);
    
    [view.layer renderInContext:context];
    return [UIImage imageWithCGImage:CGBitmapContextCreateImage(context) scale:scaleFactor orientation:UIImageOrientationUp];
}