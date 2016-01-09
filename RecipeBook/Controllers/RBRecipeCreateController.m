//
//  NewRecipeViewController.m
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/7/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import "RBRecipe.h"
#import "NewStepTableCellView.h"
#import "RBCoreDataManager.h"
#import "RBRecipeCreateController.h"
#import "RBRecipeStep.h"
#import "RBRecipeStepCreateController.h"
#import "RBTableLineNumberRulerView.h"

@interface RBRecipeCreateController ()
{
    RBRecipe *newRecipe;
}
@end

@implementation RBRecipeCreateController

- (void)viewDidLoad
{
    [super viewDidLoad];
    newRecipe = [NSEntityDescription
          insertNewObjectForEntityForName:@"Recipe"
                   inManagedObjectContext:self.coreDataManager.managedObjectContext];

    [self.recipeStepCreateController setCurrentRecipe:newRecipe];
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
}

- (RBCoreDataManager *)coreDataManager
{
    return [RBCoreDataManager sharedManager];
}

- (IBAction)cancelButtonPressed:(id)sender
{
    [self dismissSelf];
}

- (IBAction)saveButtonPressed:(id)sender
{
    [self insertRecipe];
    [self dismissSelf];
}

- (void)dismissSelf
{
    [self.view removeFromSuperview];
}

- (void)insertRecipe
{
    newRecipe.name = self.recipeNameField.stringValue;
    newRecipe.recipeDescription = self.recipeDescriptionField.stringValue;
    newRecipe.stars = self.recipeRatingIndicator.integerValue;

    NSArray<RBRecipeStep *> *steps = self.recipeStepsArrayCtrl.arrangedObjects;
    NSMutableOrderedSet<RBRecipeStep *> *finalSteps;

    for (RBRecipeStep *step in steps) {
        step.recipe = newRecipe;
        [finalSteps addObject:step];
    }

    [newRecipe addSteps:finalSteps];

    [self.coreDataManager saveAction:self];
}

- (void)insertStepForRecipe:(RBRecipe *)recipe
{
}

- (void)addNewStep:(id)sender
{
}

- (void)newRecipeStepAdded:(RBRecipeStep *)newStep
{
    newStep.recipe = newRecipe;
}

@end
