//
//  ui-additions.m
//  debug-logging-ios
//
//  Created by Adrian Kemp on 2013-03-01.
//  Copyright (c) 2013 Adrian Kemp. All rights reserved.
//

#import "ui-additions.h"

void UIViewUpdateFrameIfNeeded(UIView *view, CGRect frame) {
    frame = CGRectApplyAffineTransform(frame, view.transform);
    if(CGRectEqualToRect(frame, view.frame)) {
        return;
    } else {
        view.frame = frame;
    }
}