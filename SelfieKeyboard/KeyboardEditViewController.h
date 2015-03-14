//
//  KeyboardEditViewController.h
//  SelfieKeyboard
//
//  Created by umut on 13/03/15.
//  Copyright (c) 2015 Umut Afacan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyboardEditViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) NSString *textNameOfKeyboard;
@property int keyboardID;

@end
