//
//  RecipeStepCreateController.m
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/8/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import "RBRecipeStepCreateController.h"
#import "RBCoreDataManager.h"
#import "RBRecipe.h"
#import "RBRecipeStep.h"
#import "RBRecipeStepTableCellView.h"

@implementation RBRecipeStepCreateController

#pragma mark - Properties

@synthesize currentRecipe = _currentRecipe;
@synthesize recipeSteps = _recipeSteps;
@synthesize delegate = _delegate;

- (RBCoreDataManager *)coreDataManager
{
    return [RBCoreDataManager sharedManager];
}

#pragma mark - Initializers

- (instancetype)initWithRecipe:(RBRecipe *)recipe
{
    self = [super init];
    if (!self) {
        return nil;
    }

    _currentRecipe = recipe;
    _recipeSteps = [NSMutableOrderedSet orderedSet];

    return self;
}

- (void)awakeFromNib
{
    if (!_recipeSteps) {
        _recipeSteps = [NSMutableOrderedSet orderedSet];
    }
}

#pragma mark - NSTableView DataSource / Delegate Methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.recipeSteps.count;
}

- (id)tableView:(NSTableView *)tableView
      objectValueForTableColumn:(NSTableColumn *)tableColumn
                            row:(NSInteger)row
{
    return [self.recipeSteps objectAtIndex:row];
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row
{
    RBRecipeStepTableCellView *view = [tableView makeViewWithIdentifier:@"StepView" owner:self];

    NSString *stepNumber = [NSString stringWithFormat:@"%ld. ", (row + 1)];
    [view.stepNumberField setStringValue:stepNumber];

    [view.textField setStringValue:[[self.recipeSteps objectAtIndex:row] stepText]];
    return view;
}

- (IBAction)btnInsertNewStep:(id)sender
{
    RBRecipeStep *newStep = [NSEntityDescription
          insertNewObjectForEntityForName:@"RecipeStep"
                   inManagedObjectContext:self.coreDataManager.managedObjectContext];
    newStep.recipe = self.currentRecipe;

    if (self.delegate && [self.delegate respondsToSelector:@selector(didInsertNewStep:)]) {
        [self.delegate didInsertNewStep:newStep];
    }

    NSInteger idx = self.tableView.selectedRow;
    if (idx == -1) {
        idx = self.tableView.numberOfRows;
    }

    [self.recipeSteps insertObject:newStep atIndex:idx];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:idx]
                          withAnimation:NSTableViewAnimationEffectFade];

    [self moveFocusToViewForRow:idx];
    [self.tableView endUpdates];
}

- (void)moveFocusToViewForRow:(NSInteger)row
{
    [self.tableView scrollRowToVisible:row];

    RBRecipeStepTableCellView *view =
          [self.tableView viewAtColumn:[self.tableView.tableColumns count] - 1
                                   row:row
                       makeIfNecessary:NO];

    if (!view) {
        return;
    }

    [view.textField becomeFirstResponder];
}

- (IBAction)btnRemoveSelectedStep:(id)sender
{
}

@end
