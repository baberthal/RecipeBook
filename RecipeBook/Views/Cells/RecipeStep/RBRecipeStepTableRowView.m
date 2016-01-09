//
//  RBRecipeStepTableRowView.m
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/8/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import "RBRecipeStepTableRowView.h"

@implementation RBRecipeStepTableRowView

@synthesize objectValue = _objectValue;

- (void)dealloc
{
    self.objectValue = nil;
}

@end
