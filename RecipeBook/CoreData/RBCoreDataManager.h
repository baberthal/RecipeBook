//
//  RBCoreDataStack.h
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/6/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@class RBFavorite, RBItem;

@interface RBCoreDataManager : NSObject

@property(readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property(readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (instancetype)sharedManager;

@property(readonly) IBOutlet NSArray<RBFavorite *> *favorites;

@end
