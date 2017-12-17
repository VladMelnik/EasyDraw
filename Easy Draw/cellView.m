//
//  cellView.m
//  Easy Draw
//
//  Created by Vlad Melnyk on 23.06.17.
//  Copyright © 2017 VM. All rights reserved.
//

#import "cellView.h"

@implementation cellView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray* viewArray = [[NSBundle mainBundle] loadNibNamed:@"cellView" owner:self options:nil];
        
        if (viewArray){
            _myViewFromNib = [viewArray objectAtIndex:0];
            _myViewFromNib.frame = frame;
            
            
            
            _icon       = [_myViewFromNib viewWithTag:1];
            _name       = [_myViewFromNib viewWithTag:2];
            _steps      = [_myViewFromNib viewWithTag:3];
            _rate       = [_myViewFromNib viewWithTag:4];
            _difficult  = [_myViewFromNib viewWithTag:5];
            _lockView   = [_myViewFromNib viewWithTag:6];
        }
    }
    return self;
}

@end
