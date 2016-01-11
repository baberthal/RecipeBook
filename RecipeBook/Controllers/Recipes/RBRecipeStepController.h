//
//  RecipeStepCreateController.h
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/8/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

@class RBCoreDataManager;
@class RBRecipe, RBRecipeStep;

@protocol RBRecipeStepControllerDelegate <NSObject>

@property RBRecipe *currentRecipe;
@property(nonatomic, assign, getter=isEditing) BOOL editing;

@end

@interface RBRecipeStepController : NSObject <NSTableViewDataSource, NSTableViewDelegate>

@property(readonly) RBCoreDataManager *coreDataManager;

@property(readonly) RBRecipe *currentRecipe;
@property(readonly) NSMutableOrderedSet<RBRecipeStep *> *recipeSteps;

@property(weak) IBOutlet NSTableView *tableView;

@property(weak) IBOutlet id<RBRecipeStepControllerDelegate> delegate;

@property(atomic, assign) NSDragOperation currentItemDragOperation;

- (instancetype)initWithRecipe:(RBRecipe *)recipe;

- (IBAction)btnRemoveSelectedStep:(id)sender;
- (IBAction)btnInsertNewStep:(id)sender;

@end
