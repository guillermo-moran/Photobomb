//
//  PBViewController.h
//  Photobomb
//
//  Created by Guillermo Moran on 6/15/14.
//  Copyright (c) 2014 Fr0st Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "GBFlatButton/GBFlatButton.h"

@interface PBViewController : UIViewController <UIActionSheetDelegate ,UINavigationControllerDelegate ,UIImagePickerControllerDelegate> {
    //IBOutlet GBFlatButton* _selectBGButton;
   
    
    
    IBOutlet UIImageView* iconView;
    UIImage* _selectedImage;
}

-(IBAction)selectBackground:(id)sender;

@property(nonatomic, strong)UIImage* selectedImage;

@end
