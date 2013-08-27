//
//  TRViewController.m
//  tie-rack-storyboard
//
//  Created by Brian Chambers on 7/30/13.
//  Copyright (c) 2013 Brian Chambers. All rights reserved.
//

#import "TRViewController.h"
#import "TRTieImageScrollView.h"

@interface TRViewController ()
@property (strong,nonatomic) UIButton *captureImageButton;
@property (nonatomic) BOOL userIsRepositioningTie;
@property (nonatomic, strong) IBOutlet UITapGestureRecognizer *doubleTapGestureRecognizer;

@end

@implementation TRViewController

@synthesize tieImageView;
@synthesize scrollView;
@synthesize captureSession;
@synthesize previewLayer;

#define SWIPE_FADE_DURATION 1.5
#define SWIPE_FADE_DELAY 0.0f


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.userIsRepositioningTie=NO;
    
    //set array of images
    NSMutableArray *rackOfTies = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"leadercast.png"], [UIImage imageNamed:@"usa.png"], [UIImage imageNamed:@"leadercast.png"], [UIImage imageNamed:@"usa.png"],nil];
    
    //create the scroll view
    //******  OVERRIDE THE UIScrollView alloc init with my custom scroll view subclass *********
    //UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    UIScrollView *scroll = [[TRTieImageScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    scroll.pagingEnabled = YES;
    
    //sets the background color on the view to clear so that you do not see white scaling in and out, prepares for camera.
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    //set up the x number of UI Image views to be scrolled through
    for (int i = 0; i < [rackOfTies count]; i++) {
        CGFloat xOrigin = i * self.view.frame.size.width;

        UIView *awesomeView = [[UIView alloc] initWithFrame:CGRectMake(xOrigin, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [awesomeView setCenter:self.view.center];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[rackOfTies objectAtIndex:i]];
        
        [imageView setFrame:CGRectMake(xOrigin + awesomeView.frame.size.width/4, awesomeView.frame.size.height/3, awesomeView.frame.size.width/2, awesomeView.frame.size.height/2)];
        [imageView setBackgroundColor:[UIColor clearColor]];
        
        [awesomeView addSubview:imageView];
        [scroll addSubview:awesomeView];
        
        }
    
    scroll.contentSize = CGSizeMake(self.view.frame.size.width * [rackOfTies count], self.view.frame.size.height);
    [self.view addSubview:scroll];
    [scroll setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1]];
    
    //ensure that the scroll view does not start showing scroll bars on zoom
    [scroll setShowsHorizontalScrollIndicator:NO];
    [scroll setShowsVerticalScrollIndicator:NO];
        

    /*
    //create button to capture the image
    UIButton *captureImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    captureImageButton.frame = CGRectMake(self.view.frame.size.width*.333,0,100,50);
    //[captureImageButton addTarget:self action:@selector(captureAndSaveImage) forControlEvents:UIControlEventAllTouchEvents];
    [captureImageButton addTarget:self action:@selector(captureAndSaveImage) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:captureImageButton];
    [self.view bringSubviewToFront:captureImageButton];
    [self.view setUserInteractionEnabled:YES];
    */
    
    //create a pinch gesture recognizer on the scroll view
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    pinchRecognizer.delegate = self;
    [scroll addGestureRecognizer:pinchRecognizer];
    
    //create a rotate gesture recognizer
    UIRotationGestureRecognizer *rotateRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
    rotateRecognizer.delegate = self;
    [scroll addGestureRecognizer:rotateRecognizer];
    
    /*//create a double tap gesture recognizer to allow repositioning the tie
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [scroll addGestureRecognizer:doubleTapGestureRecognizer];
     */
    
    /*UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    //singleTapGestureRecognizer.cancelsTouchesInView = NO;
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [scroll addGestureRecognizer:singleTapGestureRecognizer];*/

    [scroll becomeFirstResponder];
    
    [self fireUpCamera];
}


/*
- (void)highlightImage:(UIColor *)color withBorder:(NSInteger)border {
    imageView.layer.borderColor = [UIColor redColor].CGColor;
    view.layer.borderWidth = 3.0f;
}
*/

- (IBAction)captureAndSaveImage {
    NSLog(@"Button Pressed");
    
    //remove the button from being visible, add back at the end
    
    
    // Capture screen here... and cut the appropriate size for saving and uploading
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // crop the area you want
    CGRect rect;
    rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);    // whatever you want
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *capturedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    UIImageWriteToSavedPhotosAlbum(capturedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    //imageView.image = img; // show cropped image on the ImageView
    
    //put the button back
    
}

// this is option to alert the image saving status
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
    // Unable to save the image
    if (error)
        alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                           message:@"Unable to save image to Photo Album."
                                          delegate:self cancelButtonTitle:@"Dismiss"
                                 otherButtonTitles:nil];
    else // All is well
        alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                           message:@"Image saved to Photo Album."
                                          delegate:self cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
    [alert show];
}


- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}

- (IBAction)handleRotate:(UIRotationGestureRecognizer *)recognizer {
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    recognizer.rotation = 0;
}


/*- (IBAction)handleDoubleTap:(UITapGestureRecognizer *)recognizer {
    
    
    //see if user is in moving model
    NSLog(@"Resetting tie to new position");
    
}
*/


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)fireUpCamera {
    
    /* =======================  Camera Stuff ============================== */
    
    //Probably will not work (will error) unless its run in sim mode on a device.
    
    [self setCaptureSession:[[AVCaptureSession alloc] init]];
    
    //add video input
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    AVCaptureDeviceInput *videoIn = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    
    if (!error)
    {
        [[self captureSession] addInput:videoIn];
    }
    //add video preview layer
    [self setPreviewLayer:[[AVCaptureVideoPreviewLayer alloc] initWithSession:[self captureSession]]];
	[[self previewLayer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //starting to set up the preview layer as a view
    CGRect layerRect = [[[self view] layer] bounds];
	[[self previewLayer] setBounds:layerRect];
	[[self previewLayer] setPosition:CGPointMake(CGRectGetMidX(layerRect),
                                                 CGRectGetMidY(layerRect))];
	//[[[self view] layer] addSublayer:[self previewLayer]];
    [[[self view] layer] insertSublayer:[self previewLayer] atIndex:0];
    
    //start the capture session
    [captureSession startRunning];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
