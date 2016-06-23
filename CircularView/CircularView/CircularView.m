//
//  CircularView.m
//  ReusableComponents
//
//  Created by Adrian Kemp on 2015-12-13.
//

#import "CircularView.h"

@interface CircularView ()

@property (nonatomic, weak) CAShapeLayer *shapeLayer;

@end

@implementation CircularView

- (void)prepareForInterfaceBuilder {
    [self updatePath];
}

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        [self.layer addSublayer:(_shapeLayer = (CAShapeLayer *)[CAShapeLayer new])];
    }
    return _shapeLayer;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self updatePath];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    
    self.shapeLayer.frame = bounds;
    
    [self updatePath];
}

- (void)updatePath {
    CGMutablePathRef circlePath = CGPathCreateMutable();
    CGPathAddArc(circlePath, NULL, self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0, self.bounds.size.width / 2.0f - self.strokeWidth, - M_PI_2, M_PI * 2 - M_PI_2, NO);
    self.shapeLayer.path = circlePath;
    CGPathRelease(circlePath);
    
}

- (void)setFillImage:(UIImage *)fillImage {
    _fillImage = fillImage;
    self.shapeLayer.fillColor = [UIColor colorWithPatternImage:fillImage].CGColor;
}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    self.shapeLayer.fillColor = fillColor.CGColor;
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    self.shapeLayer.strokeColor = strokeColor.CGColor;
}

- (void)setStrokeImage:(UIImage *)strokeImage {
    _strokeImage = strokeImage;
    self.shapeLayer.strokeColor = [UIColor colorWithPatternImage:strokeImage].CGColor;
}

- (void)setStrokeWidth:(CGFloat)strokeWidth {
    _strokeWidth = strokeWidth;
    self.shapeLayer.lineWidth = strokeWidth;
}

@end
