//
//  MainViewController.h
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/6/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import "RBRecipeCreateController.h"
#import <Cocoa/Cocoa.h>

@class RBCoreDataManager, RBFavorite;

@interface MainViewController : NSViewController <NSOutlineViewDataSource, NSOutlineViewDelegate,
                                                  NewRecipeViewControllerDelegate>

@property(readonly) IBOutlet RBCoreDataManager *coreDataManager;

@property(readonly, strong) IBOutlet NSMutableArray<RBFavorite *> *favorites;

@property(weak) IBOutlet NSView *recipeContentView;
@property(weak) IBOutlet NSButton *addButton;
@property(weak) IBOutlet NSMenu *addMenu;
@property(weak) IBOutlet NSOutlineView *sidebarView;

- (IBAction)addNewGroup:(NSMenuItem *)sender;
- (IBAction)addNewRecipe:(NSMenuItem *)sender;

- (void)setNeedsResetHeaderItems;

@end
