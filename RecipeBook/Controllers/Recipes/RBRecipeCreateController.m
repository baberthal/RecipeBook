//
//  NewRecipeViewController.m
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/7/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import "RBRecipe.h"
#import "RBCoreDataManager.h"
#import "RBRecipeCreateController.h"
#import "RBRecipeStep.h"
#import "RBRecipeStepCreateController.h"
#import "RBTableLineNumberRulerView.h"

@interface RBRecipeCreateController ()

@property(nonatomic, assign, getter=isEditing) BOOL editing;

@end

@implementation RBRecipeCreateController

#pragma mark - Properties

@synthesize currentRecipe = _currentRecipe;
@synthesize newRecipe = _hasNewRecipe;
@synthesize editing = _isEditing;

- (RBCoreDataManager *)coreDataManager
{
    return [RBCoreDataManager sharedManager];
}

- (BOOL)isEditing
{
    return _isEditing;
}

- (void)setEditing:(BOOL)editing
{
    [self internalSetEditing:editing];
    _isEditing = editing;
}

- (void)internalSetEditing:(BOOL)flag
{
    BOOL buttonsHidden = !flag;
    BOOL textFieldsBorderedAndEditable = flag;

    self.saveButton.hidden = buttonsHidden;
    self.cancelButton.hidden = buttonsHidden;
    self.recipeNameField.bordered = textFieldsBorderedAndEditable;
    self.recipeNameField.editable = textFieldsBorderedAndEditable;
    self.recipeDescriptionField.bordered = textFieldsBorderedAndEditable;
    self.recipeDescriptionField.editable = textFieldsBorderedAndEditable;
    self.addStepButton.enabled = textFieldsBorderedAndEditable;
    self.recipeRatingIndicator.enabled = textFieldsBorderedAndEditable;
}

- (BOOL)isNewRecipe
{
    return _hasNewRecipe;
}

- (void)setNewRecipe:(BOOL)newRecipe
{
    if (newRecipe) {
        [self setEditing:YES];
    }

    _hasNewRecipe = newRecipe;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addObserver:self forKeyPath:keypath(currentRecipe) options:0 context:nil];
    [self addObserver:self forKeyPath:keypath(isEditing) options:0 context:nil];
    [self addObserver:self forKeyPath:keypath(isNewRecipe) options:0 context:nil];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:keypath(currentRecipe)];
    [self removeObserver:self forKeyPath:keypath(isEditing)];
    [self removeObserver:self forKeyPath:keypath(isNewRecipe)];
}

- (void)viewDidAppear
{
    [self.recipeNameField becomeFirstResponder];
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

    if ([keyPath isEqualToString:keypath(currentRecipe)]) {
        [self.recipeStepCreateController setCurrentRecipe:self.currentRecipe];
    }
    else if ([keyPath isEqualToString:keypath(isEditing)]) {
    }
    else if ([keyPath isEqualToString:keypath(isNewRecipe)]) {
    }
}

@end
