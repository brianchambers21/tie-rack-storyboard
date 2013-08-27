//
//  TRTieImageView.m
//  tie-rack-storyboard
//
//  Created by Brian Chambers on 8/26/13.
//  Copyright (c) 2013 Brian Chambers. All rights reserved.
//

#import "TRTieImageScrollView.h"

@implementation TRTieImageScrollView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//override the touch events here

- (BOOL)isOpaque {
    return YES;
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"DEBUG: Touches began" );
    UITouch* touch = [touches anyObject];
    NSUInteger numTaps = [touch tapCount];
    if (numTaps < 2) {
        [self.nextResponder touchesBegan:touches withEvent:event];
    } else {
        [self handleDoubleTap:touch];
    }
}

- (IBAction)handleDoubleTap:(UITouch *)recognizer {
    
    //see if user is in moving model
    NSLog(@"Double tap, BAM!");
    
    //tell the view that was sent to me to turn itself blue via public method in View Controller
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touches Ended");
    
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touches Moved");
    [super touchesMoved:touches withEvent:event];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
