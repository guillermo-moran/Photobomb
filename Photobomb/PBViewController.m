//
//  PBViewController.m
//  Photobomb
//
//  Created by Guillermo Moran on 6/15/14.
//  Copyright (c) 2014 Fr0st Development. All rights reserved.
//

#import "PBViewController.h"
#import "PBImageEditController.h"

#import <MobileCoreServices/MobileCoreServices.h>


@interface PBViewController ()

@end

@implementation PBViewController
@synthesize selectedImage = _selectedImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Home"
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    
    //_selectBGButton.selected = NO;
    iconView.layer.cornerRadius = iconView.frame.size.width / 2;
    iconView.clipsToBounds = YES;
    iconView.layer.borderWidth = 5.0f;
    iconView.layer.borderColor = [UIColor whiteColor].CGColor;

	
    
}


//Image Picker

-(void)showImagePicker {
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];
    
    imagePicker.navigationBar.tintColor = [UIColor whiteColor];
    imagePicker.navigationBar.barStyle = UIBarStyleBlack;
    imagePicker.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
    
    imagePicker.delegate = self;
    
    imagePicker.sourceType =
    UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePicker.mediaTypes =
    @[(NSString *) kUTTypeImage];
    
    imagePicker.allowsEditing = NO;
    [self presentViewController:imagePicker
                       animated:YES completion:nil];
}

-(void)showCamera {
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    imagePicker.sourceType =
    UIImagePickerControllerSourceTypeCamera;
    
    imagePicker.mediaTypes =
    @[(NSString *) kUTTypeImage];
    
    imagePicker.allowsEditing = NO;
    [self presentViewController:imagePicker
                       animated:YES completion:nil];
}

-(void)imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Code here to work with media
    NSLog(@"YOLO");
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.selectedImage = image;
    
    [self performSegueWithIdentifier:@"PushEditViewController" sender:self];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel: (UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//App Stuff

-(IBAction)selectBackground:(id)sender {
    
    if (![UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
        
    {
        [self showImagePicker];
        return;
    }
    
    UIActionSheet *popupQuery = [[UIActionSheet alloc]
                                 initWithTitle:@"New Background From..."
                                 delegate:self cancelButtonTitle:@"Cancel"
                                 destructiveButtonTitle:nil
                                 otherButtonTitles:@"Photo Library", @"Camera", nil];
    
    [popupQuery showInView:self.view];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
   
     switch (buttonIndex) {
         case 0:
             [self showImagePicker];
             break;
         case 1:
             [self showCamera];
             break;
    
    break;
     }
}


 #pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"PushEditViewController"]){
        PBImageEditController* imageEditor = (PBImageEditController *)[segue destinationViewController];
        NSLog(@"dsh");
        imageEditor.backgroundImage = self.selectedImage;
    }
}

 

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
