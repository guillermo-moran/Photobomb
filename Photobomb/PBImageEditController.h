//
//  PBImageEditController.h
//  Photobomb
//
//  Created by Guillermo Moran on 6/16/14.
//  Copyright (c) 2014 Fr0st Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBLayerImageView.h"


@interface PBImageEditController : UIViewController <UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate> {
    
    //Gesture Recognizers
    CAShapeLayer *_marque;
    CGFloat _lastScale;
	CGFloat _lastRotation;
	CGFloat _firstX;
	CGFloat _firstY;
    
    UIImageView* _backgroundImageView;
    UIImageView* _overlayImageView;
    
    PBLayerImageView* _selectedLayer;
    
    NSMutableArray* layers;
    
    
}

-(IBAction)saveToCameraRoll:(id)sender;
-(IBAction)addLayer:(id)sender;
-(IBAction)selectStrokeColor:(id)sender;

-(void)moveLayer;
-(void)bringLayerToFront;
-(void)editLayer;
-(void)deleteLayer;
-(void)whiteToAlpha;



//-(void)setBackgroundImage:(UIImage*)image;

@property(nonatomic, strong) IBOutlet UIImageView* backgroundImageView;
@property(nonatomic, strong) IBOutlet UIImageView* overlayImageView;
@property(nonatomic, strong) PBLayerImageView* selectedLayer;

@property(nonatomic, strong) UIImage* backgroundImage;

@end
