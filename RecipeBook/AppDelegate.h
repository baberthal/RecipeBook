//
//  AppDelegate.h
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/6/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RBCoreDataManager;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property(readonly, strong) RBCoreDataManager *coreDataStack;

@end
