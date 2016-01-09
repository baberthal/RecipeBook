//
//  MainViewController.h
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/6/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import "RBRecipeCreateController.h"
#import "RBWelcomeViewController.h"
#import <Cocoa/Cocoa.h>

@class RBCoreDataManager, RBFavorite;
@class RBWelcomeViewController;

@interface MainViewController : NSViewController <NSOutlineViewDataSource, NSOutlineViewDelegate,
                                                  RBWelcomeViewControllerDelegate>

@property(readonly) IBOutlet RBCoreDataManager *coreDataManager;

@property(readonly, strong) IBOutlet NSMutableArray<RBFavorite *> *favorites;

@property(weak) IBOutlet NSView *recipeContentView;
@property(weak) IBOutlet NSButton *addButton;
@property(weak) IBOutlet NSMenu *addMenu;
@property(weak) IBOutlet NSOutlineView *sidebarView;

- (IBAction)addNewGroup:(NSMenuItem *)sender;
- (IBAction)addNewRecipe:(id)sender;

- (void)setNeedsResetHeaderItems;

@end
