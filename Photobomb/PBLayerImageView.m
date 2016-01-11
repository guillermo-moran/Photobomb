//
//  PBLayerImageView.m
//  Photobomb
//
//  Created by Guillermo Moran on 6/16/14.
//  Copyright (c) 2014 Fr0st Development. All rights reserved.
//

#import "PBLayerImageView.h"

@implementation PBLayerImageView
@synthesize eraserEnabled = _eraserEnabled;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_eraserEnabled) {
        fingerSwiped = NO;
        
        UITouch *touch = [touches anyObject];
        if ([touch tapCount] == 3) {
            //self.image = nil;
            return;
        }
        
        lastPoint = [touch locationInView:self];
    }
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_eraserEnabled) {
        fingerSwiped = YES;
        
        UITouch *touch = [touches anyObject];
        currentPoint = [touch locationInView:self];
        
        [self drawLineFrom:lastPoint to:currentPoint];
        
        lastPoint = currentPoint;
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_eraserEnabled) {
        UITouch *touch = [touches anyObject];
        if ([touch tapCount] == 3) {
            self.image = nil;
            return;
        }
        
        if (fingerSwiped == NO) {
            [self drawLineFrom:lastPoint to:lastPoint];
        }
    }
}

- (void)drawLineFrom:(CGPoint)aStartPoint to:(CGPoint)aEndPoint {
    /*
     UIGraphicsBeginImageContext(self.frame.size);
     [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
     
     CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
     CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 10);
     
     //Stroke Color
     CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [UIColor blackColor].CGColor);
     CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
     
     CGContextBeginPath(UIGraphicsGetCurrentContext());
     CGContextMoveToPoint(UIGraphicsGetCurrentContext(), aStartPoint.x, aStartPoint.y);
     CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), aEndPoint.x, aEndPoint.y);
     CGContextStrokePath(UIGraphicsGetCurrentContext());
     
     self.image = UIGraphicsGetImageFromCurrentImageContext();
     
     UIGraphicsEndImageContext();
     */
    
    if (_eraserEnabled) {
        UIGraphicsBeginImageContext(self.frame.size);
        
        [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        CGContextSaveGState(UIGraphicsGetCurrentContext());
        CGContextSetShouldAntialias(UIGraphicsGetCurrentContext(), YES);
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 20.0);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.25, 0.25, 0.25, 1.0);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, nil, lastPoint.x, lastPoint.y);
        CGPathAddLineToPoint(path, nil, currentPoint.x, currentPoint.y);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
        CGContextAddPath(UIGraphicsGetCurrentContext(), path);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        self.image = UIGraphicsGetImageFromCurrentImageContext();
        CGContextRestoreGState(UIGraphicsGetCurrentContext());
        UIGraphicsEndImageContext();
        lastPoint = currentPoint;
    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
