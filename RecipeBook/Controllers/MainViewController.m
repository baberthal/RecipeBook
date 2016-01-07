//
//  MainViewController.m
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/6/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import "MainViewController.h"
#import "RBCoreDataManager.h"

@interface MainViewController ()
@property(readonly) NSArray *headerItems;
@end

@implementation MainViewController

#pragma mark - Properties

@synthesize favorites = _favorites;
@synthesize headerItems = _headerItems;

- (RBCoreDataManager *)coreDataManager
{
    return [RBCoreDataManager sharedManager];
}

- (NSMutableArray<RBFavorite *> *)favorites
{
    if (_favorites) {
        return _favorites;
    }

    _favorites = [self.coreDataManager.favorites copy];

    return _favorites;
}

- (NSArray *)headerItems
{
    if (_headerItems) {
        return _headerItems;
    }

    _headerItems = @[ @"Favorites" ];

    return _headerItems;
}

#pragma mark - IBActions

- (void)openAddMenu:(id)sender
{
    [NSMenu popUpContextMenu:self.addMenu withEvent:nil forView:(NSView *)sender];
}

#pragma mark - View Lifecycle Events

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - NSOutlineViewDataSource

- (NSArray *)_childrenForItem:(id)item
{
    NSArray *children;
    if (item == nil) {
        children = self.headerItems;
    }
    else {
        if ([item isEqualToString:@"Favorites"]) {
            children = self.favorites;
        }
    }

    return children;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    return [[self _childrenForItem:item] objectAtIndex:index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    return [self.headerItems containsObject:item];
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    return [[self _childrenForItem:item] count];
}

- (NSView *)outlineView:(NSOutlineView *)outlineView
     viewForTableColumn:(NSTableColumn *)tableColumn
                   item:(id)item
{
    NSTableCellView *result;

    if ([self.headerItems containsObject:item]) {
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

@end
