//
//  PBImageEditController.m
//  Photobomb
//
//  Created by Guillermo Moran on 6/16/14.
//  Copyright (c) 2014 Fr0st Development. All rights reserved.
//

#import "PBImageEditController.h"
#import "PBViewController.h"
#import "PBLayerEditor.h"

#import "UIImage+PBTools.h"
#import "OLGhostAlertView.h"

#import "QBPopupMenu.h"


#import <MobileCoreServices/MobileCoreServices.h>

@interface PBImageEditController () {
//Private Shit
    
}


@end

@implementation PBImageEditController
@synthesize backgroundImageView = _backgroundImageView;
@synthesize selectedLayer = _selectedLayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)selectStrokeColor:(id)sender {
    
}

/*
-(void)setupToolbox {
    toolsView = [[PullableView alloc] initWithFrame:CGRectMake(0, 200, 200, 300)];
    toolsView.backgroundColor = [UIColor lightGrayColor];
    toolsView.openedCenter = CGPointMake(100, 200);
    toolsView.closedCenter = CGPointMake(-70, 200);
    toolsView.center = toolsView.closedCenter;
    toolsView.animate = YES;
    
    toolsView.handleView.backgroundColor = [UIColor darkGrayColor];
    toolsView.handleView.frame = CGRectMake(170, 0, 30, 300);
    
    [self.view addSubview:toolsView];
}
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.backgroundImageView.image = self.backgroundImage;
    
    self.overlayImageView = [[UIImageView alloc] init];
    self.overlayImageView.frame = self.backgroundImageView.frame;
    self.overlayImageView.userInteractionEnabled = YES;
    self.overlayImageView.multipleTouchEnabled = YES;
    [self.backgroundImageView addSubview:self.overlayImageView];
    
    //[self setupToolbox];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Image Shit

- (UIImage*)imageFromView:(UIView *)view
{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize imageSize = [view bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // -renderInContext: renders in the coordinate space of the layer,
    // so we must first apply the layer's geometry to the graphics context
    CGContextSaveGState(context);
    // Center the context around the view's anchor point
    CGContextTranslateCTM(context, [view center].x, [view center].y);
    // Apply the view's transform about the anchor point
    CGContextConcatCTM(context, [view transform]);
    // Offset by the portion of the bounds left of and above the anchor point
    CGContextTranslateCTM(context,
                          -[view bounds].size.width * [[view layer] anchorPoint].x,
                          -[view bounds].size.height * [[view layer] anchorPoint].y);
    
    // Render the layer hierarchy to the current context
    [[view layer] renderInContext:context];
    
    // Restore the context
    CGContextRestoreGState(context);
    
    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

-(IBAction)saveToCameraRoll:(id)sender {
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Save Image"
                                                      message:@"Would you like to save your masterpiece to your library?"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Save", nil];
    [message show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Save"])
    {
        UIImage* imageToSave = [self imageFromView:self.backgroundImageView];
        
        UIImageWriteToSavedPhotosAlbum(imageToSave, self,
                                       @selector(image:finishedSavingWithError:contextInfo:),
                                       nil);
   
    }
}

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *) error contextInfo:(void *)contextInfo {
    if (error) {
        OLGhostAlertView *saveFailed = [[OLGhostAlertView alloc] initWithTitle:@"Failure!" message:@"Photobomb! was unable to save your image. Please try again."];
        saveFailed.position = OLGhostAlertViewPositionBottom;
        saveFailed.style = OLGhostAlertViewStyleDark;
        saveFailed.timeout = 1;
        [saveFailed showInView:self.overlayImageView];
        //saveFailed.completionBlock = ^(void) {};
    }
    else {
        OLGhostAlertView *saveSucceed = [[OLGhostAlertView alloc] initWithTitle:@"Saved!" message:@"Your image has been saved to the camera roll."];
        saveSucceed.position = OLGhostAlertViewPositionBottom;
        saveSucceed.style = OLGhostAlertViewStyleDark;
        saveSucceed.timeout = 1;
        [saveSucceed showInView:self.overlayImageView];
    }
}

//Add Layers

-(IBAction)addLayer:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
        
    {
        [self showImagePicker];
        return;
    }
    
    UIActionSheet *popupQuery = [[UIActionSheet alloc]
                                 initWithTitle:@"New Layer From..."
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

-(void)imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Code here to work with media
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    PBLayerImageView* newImageView = [[PBLayerImageView alloc] initWithImage:image];
    newImageView.userInteractionEnabled = YES;
    newImageView.contentMode = UIViewContentModeScaleAspectFit;
    newImageView.eraserEnabled = NO;
    
    newImageView.frame = CGRectMake(0, 0, image.size.width/2, image.size.height/2);
    newImageView.tag = [layers count];
    [layers addObject:newImageView];
    
    [self.overlayImageView addSubview:newImageView];
    
    [self addGesturesToLayer:newImageView];
    [self addTapGesturesToLayer:newImageView];
    self.selectedLayer = newImageView;
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel: (UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

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

//Drawing






#pragma mark - GestureRecognizers

-(void)removeGesturesFromLayer:(PBLayerImageView*)layer {
    for (UIGestureRecognizer *gr in layer.gestureRecognizers) {
        [layer removeGestureRecognizer:gr];
    }
    
    [self addTapGesturesToLayer:layer];
}

-(void)addTapGesturesToLayer:(PBLayerImageView*)layer {
    UITapGestureRecognizer *tapProfileImageRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
	[tapProfileImageRecognizer setNumberOfTapsRequired:1];
	[tapProfileImageRecognizer setDelegate:self];
	[layer addGestureRecognizer:tapProfileImageRecognizer];
}

-(void)addGesturesToLayer:(PBLayerImageView*)layer {
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
	[pinchRecognizer setDelegate:self];
	[self.overlayImageView addGestureRecognizer:pinchRecognizer];
    
	UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
	[rotationRecognizer setDelegate:self];
	[self.overlayImageView addGestureRecognizer:rotationRecognizer];
    
	UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
	[panRecognizer setMinimumNumberOfTouches:1];
	[panRecognizer setMaximumNumberOfTouches:1];
	[panRecognizer setDelegate:self];
	[layer addGestureRecognizer:panRecognizer];
    
}

-(void)scale:(id)sender {
    
    
    
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _lastScale = 1.0;
    }
    
    CGFloat scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    
    CGAffineTransform currentTransform = self.selectedLayer.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [self.selectedLayer setTransform:newTransform];
    
    _lastScale = [(UIPinchGestureRecognizer*)sender scale];
    //[self showOverlayWithFrame:self.selectedLayer.frame];
}

-(void)rotate:(id)sender {
    
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        _lastRotation = 0.0;
        return;
    }
    
    CGFloat rotation = 0.0 - (_lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
    
    CGAffineTransform currentTransform = self.selectedLayer.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [self.selectedLayer setTransform:newTransform];
    
    _lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
    //[self showOverlayWithFrame:self.selectedLayer.frame];
}


-(void)move:(id)sender {
    
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.overlayImageView];
        
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
            _firstX = [self.selectedLayer center].x;
            _firstY = [self.selectedLayer center].y;
    }
        
    translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY+translatedPoint.y);
        
    [self.selectedLayer setCenter:translatedPoint];
    
    
    
}



-(void)tapped:(UIGestureRecognizer*)recognizer {
    NSLog(@"Tap");
    
   
    QBPopupMenuItem *editItem = [QBPopupMenuItem itemWithTitle:@"Edit" target:self action:@selector(editLayer)];
    QBPopupMenuItem *alphaItem = [QBPopupMenuItem itemWithTitle:@"Remove Whites" target:self action:@selector(whiteToAlpha)];
    QBPopupMenuItem *btfItem = [QBPopupMenuItem itemWithTitle:@"🔝" target:self action:@selector(bringLayerToFront)];
    QBPopupMenuItem *deleteItem = [QBPopupMenuItem itemWithTitle:@"❌" target:self action:@selector(deleteLayer)];
   
    //QBPopupMenuItem *item6 = [QBPopupMenuItem itemWithTitle:@"Delete" image:[UIImage imageNamed:@"trash"] target:self action:@selector(action)];
    NSArray *items = @[editItem, alphaItem, btfItem, deleteItem];
    
    QBPopupMenu *popupMenu = [[QBPopupMenu alloc] initWithItems:items];
    popupMenu.highlightedColor = [[UIColor colorWithRed:0 green:0.478 blue:1.0 alpha:1.0] colorWithAlphaComponent:0.8];
    
    [popupMenu showInView:self.view targetRect:recognizer.view.frame animated:YES];
    
    self.selectedLayer = (PBLayerImageView*)recognizer.view;
    
    [self showOverlayWithFrame:self.selectedLayer.frame];
    
}



-(void)showOverlayWithFrame:(CGRect)frame {
    
}

// UIMenuController Methods

// Default copy method
-(void)bringLayerToFront {
    
    [self.overlayImageView bringSubviewToFront:self.selectedLayer];
    
}
-(void)editLayer {
    
    [self performSegueWithIdentifier:@"PresentLayerEditor" sender:self];
    
    //self.selectedLayer.eraserEnabled = YES;
    //[self removeGesturesFromLayer:self.selectedLayer];
    
    
}
-(void)deleteLayer {
    
    for (UIGestureRecognizer *gr in self.selectedLayer.gestureRecognizers) {
        [self.selectedLayer removeGestureRecognizer:gr];
    }
    
    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
        // Animate the alpha value of your imageView from 1.0 to 0.0 here
        self.selectedLayer.alpha = 0.0f;
    } completion:^(BOOL finished) {
        // Once the animation is completed and the alpha has gone to 0.0, hide the view for good
        [self.selectedLayer removeFromSuperview];
        self.selectedLayer = nil;
    }];
}

-(void)whiteToAlpha {
    self.selectedLayer.image = [UIImage whiteToAlpha:self.selectedLayer.image];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"PresentLayerEditor"]){
        PBLayerEditor* layerEditor = (PBLayerEditor *)[segue destinationViewController];
        
        NSLog(@"%@", self.selectedLayer.image);
        layerEditor.layer = self.selectedLayer.image;
    }
}


@end
