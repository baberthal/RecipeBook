//
//  RBRecipe+CoreDataProperties.h
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/8/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RBRecipe.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBRecipe (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *recipeDescription;
@property (nonatomic) int16_t stars;
@property (nonatomic) NSTimeInterval createdAt;
@property (nonatomic) NSTimeInterval updatedAt;
@property (nullable, nonatomic, retain) NSSet<RBIngredientAmount *> *ingredientAmounts;
@property (nullable, nonatomic, retain) RBRecipeBook *recipeBook;
@property (nullable, nonatomic, retain) RBRecipeGroup *recipeGroup;
@property (nullable, nonatomic, retain) NSOrderedSet<RBRecipeStep *> *steps;

@end

@interface RBRecipe (CoreDataGeneratedAccessors)

- (void)addIngredientAmountsObject:(RBIngredientAmount *)value;
- (void)removeIngredientAmountsObject:(RBIngredientAmount *)value;
- (void)addIngredientAmounts:(NSSet<RBIngredientAmount *> *)values;
- (void)removeIngredientAmounts:(NSSet<RBIngredientAmount *> *)values;

- (void)insertObject:(RBRecipeStep *)value inStepsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromStepsAtIndex:(NSUInteger)idx;
- (void)insertSteps:(NSArray<RBRecipeStep *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeStepsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInStepsAtIndex:(NSUInteger)idx withObject:(RBRecipeStep *)value;
- (void)replaceStepsAtIndexes:(NSIndexSet *)indexes withSteps:(NSArray<RBRecipeStep *> *)values;
- (void)addStepsObject:(RBRecipeStep *)value;
- (void)removeStepsObject:(RBRecipeStep *)value;
- (void)addSteps:(NSOrderedSet<RBRecipeStep *> *)values;
- (void)removeSteps:(NSOrderedSet<RBRecipeStep *> *)values;

@end

NS_ASSUME_NONNULL_END
