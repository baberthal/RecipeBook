//
//  RBRecipeBook.h
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/8/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@class RBFavorite, RBRecipe, RBRecipeGroup;

NS_ASSUME_NONNULL_BEGIN

@interface RBRecipeBook : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "RBRecipeBook+CoreDataProperties.h"
