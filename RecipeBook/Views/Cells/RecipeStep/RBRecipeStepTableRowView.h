//
//  RBRecipeStepTableRowView.h
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/8/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RBRecipeStepTableRowView : NSTableRowView
{
@private
    id _objectValue;
}

@property(retain) id objectValue;

@end
