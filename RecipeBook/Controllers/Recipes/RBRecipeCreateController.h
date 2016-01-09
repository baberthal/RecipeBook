//
//  NewRecipeViewController.h
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/7/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import "RBRecipeStepTableController.h"

@class RBCoreDataManager;
@class RBRecipeStepTableController, RBIngredientTableController;
@class RBRecipeStepCreateController;

@protocol NewRecipeViewControllerDelegate <NSObject>

- (void)shouldDismissController:(id)sender;

@end

@interface RBRecipeCreateController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property(strong) IBOutlet NSArrayController *recipeStepsArrayCtrl;
@property(readonly) RBCoreDataManager *coreDataManager;
@property(strong) IBOutlet RBRecipeStepCreateController *recipeStepCreateController;

@property(weak) IBOutlet NSButton *saveButton;
@property(weak) IBOutlet NSButton *cancelButton;

@property(weak) IBOutlet NSTextField *recipeNameField;
@property(weak) IBOutlet NSTextField *recipeDescriptionField;
@property(weak) IBOutlet NSLevelIndicator *recipeRatingIndicator;

@property(weak) IBOutlet NSButton *addStepButton;
@property(weak) IBOutlet RBRecipeStepTableController *recipeStepTableCtrl;
@property(weak) IBOutlet NSTableView *stepTableView;
@property(weak) IBOutlet NSBox *recipeStepsBox;

@property(assign) IBOutlet id<NewRecipeViewControllerDelegate> delegate;

@property IBOutlet RBRecipeStepTableController *stepTableController;
@property IBOutlet RBIngredientTableController *ingredientTableController;

- (IBAction)addNewStep:(id)sender;

@end
