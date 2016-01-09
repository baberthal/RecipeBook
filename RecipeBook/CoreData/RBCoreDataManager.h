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

@class RBFavorite, RBItem, RBRecipeGroup, RBRecipe;
@class RBRecipeBook;

@interface RBCoreDataManager : NSObject

@property(readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property(readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (instancetype)sharedManager;

- (void)saveAction:(id)sender;

@property(readonly, strong, nonatomic) RBRecipeBook *recipeBook;
@property(readonly) IBOutlet NSArray<RBFavorite *> *favorites;
@property(readonly) NSArray<RBRecipeGroup *> *groups;
@property(readonly) NSArray<RBRecipe *> *ungroupedRecipes;
@property(readonly) NSArray<RBRecipe *> *allRecipes;

@end
