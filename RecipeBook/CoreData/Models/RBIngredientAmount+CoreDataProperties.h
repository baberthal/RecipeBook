//
//  RBIngredientAmount+CoreDataProperties.h
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/8/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RBIngredientAmount.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBIngredientAmount (CoreDataProperties)

@property(nullable, nonatomic, retain) NSNumber *quantity;
@property(nullable, nonatomic, retain) NSNumber *unit;
@property(nullable, nonatomic, retain) RBIngredient *ingredient;
@property(nullable, nonatomic, retain) RBRecipe *recipe;

@end

NS_ASSUME_NONNULL_END
