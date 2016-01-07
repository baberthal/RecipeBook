//
//  RBIngredientAmount+CoreDataProperties.h
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/6/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RBIngredientAmount.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBIngredientAmount (CoreDataProperties)

@property (nonatomic) float quantity;
@property (nonatomic) int64_t unit;
@property (nullable, nonatomic, retain) RBRecipe *recipe;
@property (nullable, nonatomic, retain) RBIngredient *ingredient;

@end

NS_ASSUME_NONNULL_END
