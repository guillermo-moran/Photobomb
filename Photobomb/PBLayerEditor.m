//
//  PBLayerEditor.m
//  Photobomb
//
//  Created by Guillermo Moran on 6/18/14.
//  Copyright (c) 2014 Fr0st Development. All rights reserved.
//

#import "PBLayerEditor.h"
#import "PBImageEditController.h"

@interface PBLayerEditor ()

@end

@implementation PBLayerEditor
@synthesize layer = _layer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    NSLog(@"%@", _layer);
    self.layerView.image = self.layer;
    self.layerView.eraserEnabled = YES;
    
    //self.layerView.frame = CGRectMake(0, 0, self.layer.size.width, self.layer.size.height);
    
    [[self navigationItem] setBackBarButtonItem:cancelButton];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)cancelEditing:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)doneEditing:(id)sender {
    
    // get the index of the visible VC on the stack
    NSUInteger currentVCIndex = [self.navigationController.viewControllers indexOfObject:self.navigationController.topViewController];
    // get a reference to the previous VC
    UIViewController *prevVC = (UIViewController *)[self.navigationController.viewControllers objectAtIndex:currentVCIndex - 1];
    // get the VC shown by the previous VC
    
    PBImageEditController* editor = (PBImageEditController*)prevVC;
    
    editor.selectedLayer.image = self.layerView.image;
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
