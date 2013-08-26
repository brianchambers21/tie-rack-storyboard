//
//  TRViewController.h
//  tie-rack-storyboard
//
//  Created by Brian Chambers on 7/30/13.
//  Copyright (c) 2013 Brian Chambers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

@interface TRViewController : UIViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) AVCaptureSession *captureSession;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *tieImageView;

@property (strong, nonatomic) NSMutableArray *tiesToDisplay;

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer;
- (IBAction)handleRotate:(UIRotationGestureRecognizer *)recognizer;

@end
