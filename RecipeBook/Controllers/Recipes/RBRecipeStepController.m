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

- (NSMutableOrderedSet<RBRecipeStep *> *)recipeSteps
{
    if (_recipeSteps) {
        return _recipeSteps;
    }

    if (self.currentRecipe) {
        if (self.currentRecipe.steps) {
            _recipeSteps = [self.currentRecipe.steps mutableCopy];
            return _recipeSteps;
        }
        DDLogDebug(@"%s - I have a recipe, but it steps was nil", __PRETTY_FUNCTION__);
    }

    _recipeSteps = [NSMutableOrderedSet orderedSet];
    DDLogDebug(@"%s - I do not have a recipe", __PRETTY_FUNCTION__);

    return _recipeSteps;
}

- (RBRecipe *)currentRecipe
{
    if (_currentRecipe && _currentRecipe == [self.delegate currentRecipe]) {
        return _currentRecipe;
    }

    if (self.delegate) {
        _currentRecipe = [self.delegate currentRecipe];
    }

    return _currentRecipe;
}

#pragma mark - Initializers

- (instancetype)initWithRecipe:(RBRecipe *)recipe
{
    self = [super init];
    if (!self) {
        return nil;
    }

    _currentRecipe = recipe;
    _recipeSteps = [recipe.steps mutableCopy];
    [self registerAsObserverForSelf];

    return self;
}

- (void)awakeFromNib
{
    [self registerAsObserverForSelf];
}

- (void)registerAsObserverForSelf
{
    [self addObserver:self forKeyPath:@keypath(self, currentRecipe) options:0 context:nil];
    [self.tableView setDraggingSourceOperationMask:NSDragOperationMove | NSDragOperationDelete
                                          forLocal:YES];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@keypath(self, currentRecipe)];
}

#pragma mark - Events

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *, id> *)change
                       context:(void *)context
{
    DDLogDebug(@"Change: %@", keyPath);
    if ([keyPath isEqualToString:@keypath(self, currentRecipe)]) {
        [self didChangeCurrentRecipe];
    }
    else if ([keyPath isEqualToString:@keypath(self, recipeSteps)]) {
        [self.tableView reloadData];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)didChangeCurrentRecipe
{
    NSOrderedSet *steps = self.currentRecipe.steps;
    if (steps && steps.count) {
        _recipeSteps = [steps mutableCopy];
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

    //    [view.textField setStringValue:[[self.recipeSteps objectAtIndex:row] stepText]];
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

- (void)tableView:(NSTableView *)tableView
 didRemoveRowView:(NSTableRowView *)rowView
           forRow:(NSInteger)row
{
}

#pragma mark - Actions

- (IBAction)btnInsertNewStep:(id)sender
{
    RBRecipeStep *newStep = [NSEntityDescription
          insertNewObjectForEntityForName:@"RecipeStep"
                   inManagedObjectContext:self.coreDataManager.managedObjectContext];
    newStep.recipe = self.currentRecipe;

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
    if ([self.delegate isEditing]) {
        [view.window makeFirstResponder:view];
    }
}

- (IBAction)btnRemoveSelectedStep:(id)sender
{
    [self.recipeSteps removeObjectsAtIndexes:self.tableView.selectedRowIndexes];
    [self.tableView removeRowsAtIndexes:self.tableView.selectedRowIndexes
                          withAnimation:NSTableViewAnimationSlideUp];
}

@end
