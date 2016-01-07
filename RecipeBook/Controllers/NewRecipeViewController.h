//
//  NewRecipeViewController.h
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/7/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NewRecipeViewController : NSViewController

@property(weak) IBOutlet NSButton *saveButton;
@property(weak) IBOutlet NSButton *cancelButton;
@property(weak) IBOutlet NSTextField *recipeNameField;
@property(weak) IBOutlet NSLevelIndicator *recipeRatingIndicator;
@property(weak) IBOutlet NSTextField *recipeDescriptionField;

@end
