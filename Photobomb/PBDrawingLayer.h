//
//  PBDrawingLayer.h
//  Photobomb
//
//  Created by Guillermo Moran on 6/18/14.
//  Copyright (c) 2014 Fr0st Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBDrawingLayer : UIImageView {
    bool fingerSwiped;
    CGPoint lastPoint;
    CGPoint currentPoint;
}

@property(nonatomic, assign, getter= isEraserEnabled, setter = setEraserEnabled:) BOOL drawingEnabled;

@end
