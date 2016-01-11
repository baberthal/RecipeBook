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
#import "RBSaveOrEditButton.h"
#import "RBTableLineNumberRulerView.h"
#import "RBTextField.h"

@interface RBRecipeController ()

@end

@implementation RBRecipeController

#pragma mark - Initialization

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (!self) {
        return nil;
    }

    [self registerAsObserverForSelf];
    _editing = NO;
    if (self.recipeNameField) {
        NSLog(@"Recipe Name Field: %@", self.recipeNameField);
    }

    return self;
}

- (instancetype)init
{
    return [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

#pragma mark - Properties

@synthesize currentRecipe = _currentRecipe;
@synthesize editing = _editing;
@synthesize recipeStepController = _recipeStepController;

- (RBCoreDataManager *)coreDataManager
{
    return [RBCoreDataManager sharedManager];
}

- (void)internalSetEditing:(BOOL)wantsToEdit
{
    [self.saveButton setParentViewIsEditing:wantsToEdit];

    [self.cancelButton setHidden:!wantsToEdit];

    [self.recipeNameField setShouldBeEditing:wantsToEdit];
    [self.recipeNameField setNeedsDisplay];

    [self.recipeDescriptionField setShouldBeEditing:wantsToEdit];
    [self.recipeDescriptionField setNeedsDisplay];

    self.recipeRatingIndicator.enabled = wantsToEdit;

    if (wantsToEdit) {
        [self.view.window makeFirstResponder:self.recipeNameField];
    }
}

#pragma mark - IBActions

- (IBAction)cancelButtonPressed:(id)sender
{
    [self setEditing:NO];
}

- (IBAction)saveButtonPressed:(id)sender
{
    [self insertRecipe];
    [self setEditing:NO];
}

- (void)editButtonPressed:(id)sender
{
    [self setEditing:YES];
}

- (void)insertRecipe
{
    self.currentRecipe.name = self.recipeNameField.stringValue;
    self.currentRecipe.recipeDescription = self.recipeDescriptionField.stringValue;
    self.currentRecipe.stars = @(self.recipeRatingIndicator.integerValue);
    self.currentRecipe.recipeBook = self.coreDataManager.recipeBook;

    NSOrderedSet<RBRecipeStep *> *steps = self.recipeStepController.recipeSteps;
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
    [self.saveButton setTarget:self];
    [self.saveButton setActionWhenEditing:@selector(saveButtonPressed:)];
    [self.saveButton setActionWhenNotEditing:@selector(editButtonPressed:)];

    [self.saveButton setKeyEquivWhenEditing:@"\r"];
    [self.saveButton setKeyEquivWhenNotEditing:@"e"];
    [self.saveButton setKeyEquivModifierMaskWhenNotEditing:NSCommandKeyMask];

    [self.saveButton setParentViewIsEditing:self.editing];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@keypath(self, currentRecipe)];
    [self removeObserver:self forKeyPath:@keypath(self, editing)];
}

- (void)viewDidAppear
{
    if (self.editing) {
        [self.view.window makeFirstResponder:self.recipeNameField];
    }
    else {
        [self setEditing:NO];
        [self.recipeDescriptionField setShouldBeEditing:NO];
        [self.recipeNameField setShouldBeEditing:NO];
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
    if ([keyPath isEqualToString:@keypath(self, currentRecipe)]) {
        DDLogDebug(@"Current recipe changed");
        //        [self.recipeStepController setCurrentRecipe:self.currentRecipe];
    }
    else if ([keyPath isEqualToString:@keypath(self, editing)]) {
        NSNumber *wantsToEdit = [change objectForKey:NSKeyValueChangeNewKey];
        [self internalSetEditing:wantsToEdit.boolValue];
    }
}

- (void)registerAsObserverForSelf
{
    [self addObserver:self forKeyPath:@keypath(self, currentRecipe) options:0 context:nil];
    [self addObserver:self
           forKeyPath:@keypath(self, editing)
              options:NSKeyValueObservingOptionNew
              context:nil];
}

@end
