//
//  PBLayerImageView.h
//  Photobomb
//
//  Created by Guillermo Moran on 6/16/14.
//  Copyright (c) 2014 Fr0st Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBLayerImageView : UIImageView {

    //Finger Painting
    bool fingerSwiped;
    CGPoint lastPoint;
    CGPoint currentPoint;

}

@property(nonatomic, assign, getter= isEraserEnabled, setter = setEraserEnabled:) BOOL eraserEnabled;


@end
