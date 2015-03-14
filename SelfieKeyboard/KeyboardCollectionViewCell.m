//
//  KeyboardCollectionViewCell.m
//  SelfieKeyboard
//
//  Created by umut on 13/03/15.
//  Copyright (c) 2015 Umut Afacan. All rights reserved.
//

#import "KeyboardCollectionViewCell.h"

@implementation KeyboardCollectionViewCell


- (IBAction)pushToEditPage:(id)sender
{

    [self.delegate  pushToDetail:self];
    
}

-(void)viewDidApper
{
    UIImage *buttonImage = [UIImage imageNamed:[NSString stringWithFormat:@"image%d",_photoID]];
    [_buttonKeyboard setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
}


@end
