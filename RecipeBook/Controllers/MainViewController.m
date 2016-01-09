//
//  MainViewController.m
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/6/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import "MainViewController.h"
#import "RBCoreDataManager.h"
#import "RBRecipe.h"
#import "RBRecipeCreateController.h"
#import "RBRecipeGroup.h"

@interface MainViewController ()

@property(readonly) NSArray *sidebarItems;
@property(readonly) NSArray *topLevelItems;
@property(readonly) NSDictionary *sidebarDict;

- (NSArray *)childrenForSidebarItem:(id)item;

@end

@implementation MainViewController

#pragma mark - Properties

@synthesize favorites = _favorites;
@synthesize sidebarItems = _sidebarItems;
@synthesize topLevelItems = _topLevelItems;
@synthesize sidebarDict = _sidebarDict;

- (RBCoreDataManager *)coreDataManager
{
    return [RBCoreDataManager sharedManager];
}

- (NSArray *)sidebarItems
{
    if (_sidebarItems) {
        return _sidebarItems;
    }

    NSMutableArray *items = [NSMutableArray array];
    [items addObject:@"Favorites"];

    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Favorite"];
    NSError *error;

    NSArray *favorites =
          [self.coreDataManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    if (error) {
        DDLogError(@"Error fetching favorites: %@", error.localizedDescription);
    }

    if (favorites) {
        [items addObjectsFromArray:favorites];
    }

    for (RBRecipeGroup *group in self.coreDataManager.groups) {
        NSArray *recipes = [group.recipes array];
        if (recipes) {
            [items addObject:group.groupName];
            [items addObjectsFromArray:recipes];
        }
    }

    _sidebarItems = items;

    return _sidebarItems;
}

- (NSArray *)topLevelItems
{
    if (_topLevelItems) {
        return _topLevelItems;
    }

    NSMutableArray *items = [NSMutableArray array];
    [items addObject:@"Favorites"];

    NSArray *groups = self.coreDataManager.groups;

    for (RBRecipeGroup *group in groups) {
        [items addObject:group.groupName];
    }

    [items addObject:@"Ungrouped Recipes"];

    _topLevelItems = items;

    return _topLevelItems;
}

- (NSDictionary *)sidebarDict
{
    if (_sidebarDict) {
        return _sidebarDict;
    }

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *itemName in self.topLevelItems) {
        if ([itemName isEqualToString:@"Favorites"]) {
            [dict setObject:self.coreDataManager.favorites forKey:@"Favorites"];
        }
        else if ([itemName isEqualToString:@"Ungrouped Recipes"]) {
            [dict setObject:self.coreDataManager.ungroupedRecipes forKey:itemName];
        }
        else {
            NSFetchRequest *fetchReq = [NSFetchRequest fetchRequestWithEntityName:@"RecipeGroup"];
            [fetchReq setPredicate:[NSPredicate predicateWithFormat:@"groupName == %@", itemName]];

            NSError *error;

            NSArray<RBRecipeGroup *> *foundGroup =
                  [self.coreDataManager.managedObjectContext executeFetchRequest:fetchReq
                                                                           error:&error];

            NSArray<RBRecipe *> *groupRecipes;

            if (foundGroup && foundGroup.count) {
                groupRecipes = [foundGroup.firstObject.recipes array];
            }

            if (error) {
                DDLogError(@"Error fetching recipes for group %@: %@\n%@", itemName,
                           error.localizedDescription, error.userInfo);
            }

            if (groupRecipes) {
                [dict setObject:groupRecipes forKey:itemName];
            }
        }
    }

    _sidebarDict = dict;

    return _sidebarDict;
}

- (void)setNeedsResetHeaderItems
{
    _topLevelItems = nil;
}

#pragma mark - Helper Methods

- (NSArray *)childrenForSidebarItem:(id)item
{
    NSArray *children;
    if (item == nil) {
        children = self.topLevelItems;
    }
    else {
        children = [self.sidebarDict objectForKey:item];
    }

    return children;
}

#pragma mark - IBActions

- (void)addNewGroup:(NSMenuItem *)sender
{
}

- (void)addNewRecipe:(NSMenuItem *)sender
{
    RBRecipeCreateController *newVC = [[RBRecipeCreateController alloc]
          initWithNibName:NSStringFromClass([RBRecipeCreateController class])
                   bundle:nil];
    newVC.delegate = self;
    [self addChildViewController:newVC];
    [self.recipeContentView addSubview:newVC.view];
}

#pragma mark - View Lifecycle Events

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.sidebarView sizeLastColumnToFit];
    [self.sidebarView reloadData];
    [self.sidebarView setFloatsGroupRows:NO];

    [self.sidebarView setRowSizeStyle:NSTableViewRowSizeStyleDefault];

    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0];
    [NSAnimationContext endGrouping];

    if (!self.coreDataManager.allRecipes || !self.coreDataManager.allRecipes.count) {
    }
}

#pragma mark - NSOutlineViewDataSource

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    return [[self childrenForSidebarItem:item] objectAtIndex:index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if ([outlineView parentForItem:item] == nil) {
        return YES;
    }

    return NO;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    return [[self childrenForSidebarItem:item] count];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    return [self.topLevelItems containsObject:item];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldShowOutlineCellForItem:(id)item
{
    if ([item isEqualToString:@"Favorites"]) {
        return NO;
    }

    return YES;
}

- (NSView *)outlineView:(NSOutlineView *)outlineView
     viewForTableColumn:(NSTableColumn *)tableColumn
                   item:(id)item
{
    NSTableCellView *result;

    if ([self.topLevelItems containsObject:item]) {
        result = [outlineView makeViewWithIdentifier:@"HeaderCell" owner:self];
        NSString *value = [item uppercaseString];
        [result.textField setStringValue:value];
    }
    else {
        result = [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
        [result.textField setStringValue:item];
        result.imageView.image = [NSImage imageNamed:NSImageNameActionTemplate];
    }

    return result;
}

#pragma mark - NewRecipeViewControllerDelegate
- (void)shouldDismissController:(id)sender
{
}

@end
