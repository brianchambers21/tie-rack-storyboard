//
//  TRViewController.m
//  tie-rack-storyboard
//
//  Created by Brian Chambers on 7/30/13.
//  Copyright (c) 2013 Brian Chambers. All rights reserved.
//

#import "TRViewController.h"

@interface TRViewController ()

@end

@implementation TRViewController

@synthesize tieImageView;
@synthesize scrollView;
//@synthesize nextView;

//create a method that sets up an array of ties, either using the standards that are already set up and also
//allowing the user to import a tie image that becomes part of the array.

#define SWIPE_FADE_DURATION 1.5//0.33f
#define SWIPE_FADE_DELAY 0.0f


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.


    //set array of images
    NSMutableArray *rackOfTies = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"tie2.png"], [UIImage imageNamed:@"tie2.png"], [UIImage imageNamed:@"tie2.png"],nil];
    
    //create the scroll view
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scroll.pagingEnabled = YES;
    
    //set up the x number of UI Image views to be scrolled through
    for (int i = 0; i < [rackOfTies count]; i++) {
        CGFloat xOrigin = i * self.view.frame.size.width;
        NSLog(@"%f",xOrigin);
        UIView *awesomeView = [[UIView alloc] initWithFrame:CGRectMake(xOrigin, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [awesomeView setCenter:self.view.center];
        
        //dynamically create the UI Image within each super view
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[rackOfTies objectAtIndex:i]];
        
        //xOrigin is the starting point on whatever view we see.  Use that plus the size of the current view (awesomeView)
        //which is divided by 4 to get to the middle point on the screen (regardless of size, should work on ipad too)
        //The y coordinate is divided by 3 so that it starts the image 1/3 of the way down the screen.  Image scale is
        //also set relative to the awesome view it lives in (its super) so that it can scale dynamically.  BAM!
        [imageView setFrame:CGRectMake(xOrigin + awesomeView.frame.size.width/4, awesomeView.frame.size.height/3, awesomeView.frame.size.width/2, awesomeView.frame.size.height/2)];
        [imageView setBackgroundColor:[UIColor clearColor]];
        
        //awesomeView.backgroundColor = [UIColor colorWithRed:0.5/i green:0.5 blue:0.5 alpha:1];
        [scroll addSubview:awesomeView];
        [awesomeView addSubview:imageView];
    }
    scroll.contentSize = CGSizeMake(self.view.frame.size.width * [rackOfTies count], self.view.frame.size.height);
    [self.view addSubview:scroll];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
