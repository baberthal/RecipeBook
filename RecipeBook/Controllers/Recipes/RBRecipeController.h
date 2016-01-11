//
//  NewRecipeViewController.h
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/7/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import "RBRecipeStepController.h"
#import "RBTextField.h"

@class RBCoreDataManager;
@class RBRecipeStepController;
@class RBWelcomeViewController;
@class RBRecipe;
@class RBSaveOrEditButton;

@interface RBRecipeController : NSViewController <RBRecipeStepControllerDelegate>

@property(readonly) RBCoreDataManager *coreDataManager;

@property(strong) IBOutlet RBRecipeStepController *recipeStepController;

@property(weak) IBOutlet RBSaveOrEditButton *saveButton;
@property(weak) IBOutlet NSButton *cancelButton;

@property(weak) IBOutlet RBTextField *recipeNameField;
@property(weak) IBOutlet RBTextField *recipeDescriptionField;
@property(weak) IBOutlet NSLevelIndicator *recipeRatingIndicator;

@property(weak) IBOutlet NSButton *addStepButton;
@property(weak) IBOutlet NSButton *removeStepButton;
@property(weak) IBOutlet NSBox *recipeStepsBox;

@property(strong) RBRecipe *currentRecipe;

@property(nonatomic, assign, getter=isNewRecipe) BOOL newRecipe;
@property(nonatomic, assign, getter=isEditing) BOOL editing;

@end
