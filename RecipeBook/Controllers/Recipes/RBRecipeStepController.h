//
//  RecipeStepCreateController.h
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/8/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RBCoreDataManager;
@class RBRecipe, RBRecipeStep;

@protocol RBRecipeStepCreateControllerDelegate <NSObject>

- (void)didInsertNewStep:(RBRecipeStep *)newStep;

@end

@interface RBRecipeStepController : NSObject <NSTableViewDataSource, NSTableViewDelegate>

@property(readonly) RBCoreDataManager *coreDataManager;
@property RBRecipe *currentRecipe;
@property NSMutableOrderedSet<RBRecipeStep *> *recipeSteps;
@property(weak) IBOutlet NSTableView *tableView;

@property(weak) IBOutlet id<RBRecipeStepCreateControllerDelegate> delegate;

- (instancetype)initWithRecipe:(RBRecipe *)recipe;

@end
