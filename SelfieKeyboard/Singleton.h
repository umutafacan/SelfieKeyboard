//
//  Singleton.h
//  SelfieKeyboard
//
//  Created by umut on 12/03/15.
//  Copyright (c) 2015 Umut Afacan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject

+(Singleton *)sharedInstance;


@property NSMutableArray *arrayKeyboardList;
@property NSMutableDictionary *imageDict;

@end
