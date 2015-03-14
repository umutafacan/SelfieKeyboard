//
//  KeyboardModel.h
//  SelfieKeyboard
//
//  Created by umut on 14/03/15.
//  Copyright (c) 2015 Umut Afacan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+RMArchivable.h"

@interface KeyboardModel : NSObject

@property (nonatomic,strong) NSString *keyboardName;
@property (nonatomic) int keyboardID;

-(void)setKeyboardName:(NSString *)name andID:(int)ID;


@end
