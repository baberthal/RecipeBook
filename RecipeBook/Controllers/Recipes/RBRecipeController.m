//
//  NewRecipeViewController.m
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/7/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import "RBRecipe.h"
#import "RBCoreDataManager.h"
#import "RBRecipeController.h"
#import "RBRecipeStep.h"
#import "RBRecipeStepController.h"
#import "RBTableLineNumberRulerView.h"

@interface RBRecipeController ()

@end

@implementation RBRecipeController

#pragma mark - Properties

@synthesize currentRecipe = _currentRecipe;
@synthesize editing = _editing;

- (RBCoreDataManager *)coreDataManager
{
    return [RBCoreDataManager sharedManager];
}

- (void)internalSetEditing:(BOOL)flag
{
    BOOL buttonsHidden = !flag;
    BOOL textFieldsBorderedAndEditable = flag;

    self.saveButton.hidden = buttonsHidden;
    self.cancelButton.hidden = buttonsHidden;
    self.recipeNameField.bordered = textFieldsBorderedAndEditable;
    self.recipeNameField.editable = textFieldsBorderedAndEditable;
    self.recipeNameField.enabled = textFieldsBorderedAndEditable;
    self.recipeDescriptionField.bordered = textFieldsBorderedAndEditable;
    self.recipeDescriptionField.editable = textFieldsBorderedAndEditable;
    self.addStepButton.enabled = textFieldsBorderedAndEditable;
    self.recipeRatingIndicator.enabled = textFieldsBorderedAndEditable;
}

#pragma mark - IBActions

- (IBAction)cancelButtonPressed:(id)sender
{
    [self dismissSelf];
}

- (IBAction)saveButtonPressed:(id)sender
{
    [self insertRecipe];
    [self dismissSelf];
}

- (void)insertRecipe
{
    self.currentRecipe.name = self.recipeNameField.stringValue;
    self.currentRecipe.recipeDescription = self.recipeDescriptionField.stringValue;
    self.currentRecipe.stars = self.recipeRatingIndicator.integerValue;
    self.currentRecipe.recipeBook = self.coreDataManager.recipeBook;

    NSOrderedSet<RBRecipeStep *> *steps = self.recipeStepCreateController.recipeSteps;
    [self.currentRecipe setSteps:steps];
    [self.coreDataManager saveAction:self];
}

- (void)insertStepForRecipe:(RBRecipe *)recipe
{
}

- (void)addNewStep:(id)sender
{
}

#pragma mark - View Lifecycle Events
- (void)awakeFromNib
{
    [self addObserver:self forKeyPath:@keypath(self, currentRecipe) options:0 context:nil];
    [self addObserver:self forKeyPath:@keypath(self, isEditing) options:0 context:nil];
    DDLogFunction();
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    DDLogFunction();
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@keypath(self, currentRecipe)];
    [self removeObserver:self forKeyPath:@keypath(self, isEditing)];
}

- (void)viewDidAppear
{
    if (self.editing) {
        [self.recipeNameField becomeFirstResponder];
    }
    else {
        [self.recipeNameField setEditable:NO];
        [self.recipeNameField setBordered:NO];
        [self.recipeNameField setDrawsBackground:NO];

        [self.recipeDescriptionField setEditable:NO];
        [self.recipeDescriptionField setBordered:NO];
        [self.recipeDescriptionField setDrawsBackground:NO];

        [self.saveButton setHidden:YES];
        [self.cancelButton setHidden:YES];
    }
}

- (void)dismissSelf
{
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:2.0];
    [[self.view animator] removeFromSuperview];
    [NSAnimationContext endGrouping];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *, id> *)change
                       context:(void *)context
{
    DDLogDebug(@"%@ changed.", keyPath);

    if ([keyPath isEqualToString:@keypath(self, currentRecipe)]) {
        [self.recipeStepCreateController setCurrentRecipe:self.currentRecipe];
    }
    else if ([keyPath isEqualToString:@keypath(self, isEditing)]) {
        [self internalSetEditing:NO];
        DDLogFunction();
    }
}

@end
