//
//  MainViewController.h
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/6/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RBCoreDataManager, RBFavorite;

@interface MainViewController : NSViewController <NSOutlineViewDataSource, NSOutlineViewDelegate>

@property(readonly) IBOutlet RBCoreDataManager *coreDataManager;

@property(readonly, strong) IBOutlet NSMutableArray<RBFavorite *> *favorites;

@property(weak) IBOutlet NSView *recipeContentView;
@property(weak) IBOutlet NSButton *addButton;
@property(weak) IBOutlet NSMenu *addMenu;

- (IBAction)openAddMenu:(id)sender;

@end
