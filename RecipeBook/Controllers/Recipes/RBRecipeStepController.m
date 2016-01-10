//
//  RecipeStepCreateController.m
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/8/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import "RBRecipe.h"
#import "RBCoreDataManager.h"
#import "RBRecipeStep.h"
#import "RBRecipeStepController.h"
#import "RBRecipeStepTableCellView.h"
#import "RBRecipeStepTableRowView.h"

@implementation RBRecipeStepController

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

- (RBRecipeStep *)recipeStepForRow:(NSInteger)row
{
    return [self.recipeSteps objectAtIndex:row];
}

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

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row
{
    NSRect rowFrame = CGRectMake(0, 0, self.tableView.frame.size.width, 28);

    RBRecipeStepTableRowView *rowView = [[RBRecipeStepTableRowView alloc] initWithFrame:rowFrame];
    [rowView setObjectValue:[self recipeStepForRow:row]];
    return rowView;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSIndexSet *selectedRows = self.tableView.selectedRowIndexes;
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
    DDLogDebug(@"Selected Rows: %@", selectedRows);
}

- (void)tableView:(NSTableView *)tableView
    didAddRowView:(NSTableRowView *)rowView
           forRow:(NSInteger)row
{
    DDLogDebug(@"%s - Row: %ld", __PRETTY_FUNCTION__, row);
    [self moveFocusToViewForRow:row];
}

#pragma mark - Actions

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

    [self.tableView scrollRowToVisible:idx];
    [self.tableView endUpdates];
}

- (void)moveFocusToViewForRow:(NSInteger)row
{
    RBRecipeStepTableCellView *view = [self.tableView viewAtColumn:0 row:row makeIfNecessary:NO];
    [view.textField becomeFirstResponder];
}

- (IBAction)btnRemoveSelectedStep:(id)sender
{
}

@end
