//
//  RBIngredient+CoreDataProperties.h
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/8/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RBIngredient.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBIngredient (CoreDataProperties)

@property(nullable, nonatomic, retain) NSNumber *ingredientType;
@property(nullable, nonatomic, retain) NSSet<RBIngredientAmount *> *recipeAmounts;

@end

@interface RBIngredient (CoreDataGeneratedAccessors)

- (void)addRecipeAmountsObject:(RBIngredientAmount *)value;
- (void)removeRecipeAmountsObject:(RBIngredientAmount *)value;
- (void)addRecipeAmounts:(NSSet<RBIngredientAmount *> *)values;
- (void)removeRecipeAmounts:(NSSet<RBIngredientAmount *> *)values;

@end

NS_ASSUME_NONNULL_END
