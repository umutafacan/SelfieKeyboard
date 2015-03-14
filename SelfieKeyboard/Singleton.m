//
//  Singleton.m
//  SelfieKeyboard
//
//  Created by umut on 12/03/15.
//  Copyright (c) 2015 Umut Afacan. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton


+(Singleton *)sharedInstance
{
    static dispatch_once_t once;
    static Singleton *instance;
    dispatch_once(&once, ^{
        instance = [[Singleton alloc] init];
    });
    return instance;

}


- (id)init {
    if (self = [super init]) {
        _arrayKeyboardList = [[NSMutableArray alloc]init];
        _imageDict = [[NSMutableDictionary alloc]init];
    }
    return self;
}


@end
