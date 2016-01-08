//
//  RBRecipeGroup+CoreDataProperties.h
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/8/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RBRecipeGroup.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBRecipeGroup (CoreDataProperties)

@property(nullable, nonatomic, retain) NSString *groupName;
@property(nullable, nonatomic, retain) NSOrderedSet<RBRecipe *> *recipes;
@property(nullable, nonatomic, retain) RBRecipeBook *recipeBook;

@end

@interface RBRecipeGroup (CoreDataGeneratedAccessors)

- (void)insertObject:(RBRecipe *)value inRecipesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRecipesAtIndex:(NSUInteger)idx;
- (void)insertRecipes:(NSArray<RBRecipe *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRecipesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRecipesAtIndex:(NSUInteger)idx withObject:(RBRecipe *)value;
- (void)replaceRecipesAtIndexes:(NSIndexSet *)indexes withRecipes:(NSArray<RBRecipe *> *)values;
- (void)addRecipesObject:(RBRecipe *)value;
- (void)removeRecipesObject:(RBRecipe *)value;
- (void)addRecipes:(NSOrderedSet<RBRecipe *> *)values;
- (void)removeRecipes:(NSOrderedSet<RBRecipe *> *)values;

@end

NS_ASSUME_NONNULL_END
