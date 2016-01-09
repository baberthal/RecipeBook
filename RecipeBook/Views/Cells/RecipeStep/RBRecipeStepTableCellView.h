//
//  RBRecipeStepTableCellView.h
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/8/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RBRecipe, RBRecipeStep;

@interface RBRecipeStepTableCellView : NSTableCellView

@property(assign) IBOutlet NSTextField *stepNumberField;
@property(assign) IBOutlet NSButton *stepActionButton;

@end
