//
//  PBDrawingLayer.m
//  Photobomb
//
//  Created by Guillermo Moran on 6/18/14.
//  Copyright (c) 2014 Fr0st Development. All rights reserved.
//

#import "PBDrawingLayer.h"

@implementation PBDrawingLayer
@synthesize drawingEnabled = _drawingEnabled;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_drawingEnabled) {
        fingerSwiped = NO;
        
        UITouch *touch = [touches anyObject];
        if ([touch tapCount] == 3) {
            self.image = nil;
            return;
        }
        
        lastPoint = [touch locationInView:self];
    }
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_drawingEnabled) {
        fingerSwiped = YES;
        
        UITouch *touch = [touches anyObject];
        currentPoint = [touch locationInView:self];
        
        [self drawLineFrom:lastPoint to:currentPoint];
        
        lastPoint = currentPoint;
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_drawingEnabled) {
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
