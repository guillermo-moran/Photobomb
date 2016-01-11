//
//  PBLayerEditor.h
//  Photobomb
//
//  Created by Guillermo Moran on 6/18/14.
//  Copyright (c) 2014 Fr0st Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBLayerImageView.h"

@interface PBLayerEditor : UIViewController {
    
    IBOutlet UIBarButtonItem* cancelButton;
    
    PBLayerImageView* _layerView;
    UIImage* _layer;
}

@property(nonatomic, strong) IBOutlet PBLayerImageView* layerView;
@property(nonatomic, strong) UIImage* layer;

-(IBAction)cancelEditing:(id)sender;
-(IBAction)doneEditing:(id)sender;

@end
