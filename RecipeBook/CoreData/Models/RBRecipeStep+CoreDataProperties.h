//
//  RBRecipeStep+CoreDataProperties.h
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/6/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RBRecipeStep.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBRecipeStep (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *stepText;
@property (nullable, nonatomic, retain) RBRecipe *recipe;

@end

NS_ASSUME_NONNULL_END
