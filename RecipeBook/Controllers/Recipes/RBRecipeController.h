//
//  NewRecipeViewController.h
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/7/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

@class RBCoreDataManager;
@class RBRecipeStepController;
@class RBWelcomeViewController;
@class RBRecipe;

@interface RBRecipeController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property(readonly) RBCoreDataManager *coreDataManager;

@property(strong) IBOutlet RBRecipeStepController *recipeStepCreateController;

@property(weak) IBOutlet NSButton *saveButton;
@property(weak) IBOutlet NSButton *cancelButton;

@property(weak) IBOutlet NSTextField *recipeNameField;
@property(weak) IBOutlet NSTextField *recipeDescriptionField;
@property(weak) IBOutlet NSLevelIndicator *recipeRatingIndicator;

@property(weak) IBOutlet NSButton *addStepButton;
@property(weak) IBOutlet NSBox *recipeStepsBox;

@property(strong) RBRecipe *currentRecipe;

@property(nonatomic, assign, getter=isNewRecipe) BOOL newRecipe;
@property(nonatomic, assign, getter=isEditing) BOOL editing;

@end
