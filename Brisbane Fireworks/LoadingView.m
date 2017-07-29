//
//  LoadingView.m
//
//  Created by Phil Greenway on 16/04/12.
//  Copyright (c) 2012 Code Army. All rights reserved.
//

#import "LoadingView.h"

#import "LoadingView.h"

@implementation LoadingView {
    IBOutlet UIActivityIndicatorView *_activityIndicatorz;
}
@synthesize title;

- (void)dealloc
{
    //    [self.title release];
    
    //[super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 5.0;
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

