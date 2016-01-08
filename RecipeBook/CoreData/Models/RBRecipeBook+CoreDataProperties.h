//
//  RBRecipeBook+CoreDataProperties.h
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/8/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RBRecipeBook.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBRecipeBook (CoreDataProperties)

@property(nullable, nonatomic, retain) NSNumber *displayMetricUnits;
@property(nullable, nonatomic, retain) NSString *bookName;
@property(nullable, nonatomic, retain) NSOrderedSet<RBFavorite *> *favorites;
@property(nullable, nonatomic, retain) NSOrderedSet<RBRecipeGroup *> *recipeGroups;
@property(nullable, nonatomic, retain) NSOrderedSet<RBRecipe *> *recipes;

@end

@interface RBRecipeBook (CoreDataGeneratedAccessors)

- (void)insertObject:(RBFavorite *)value inFavoritesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFavoritesAtIndex:(NSUInteger)idx;
- (void)insertFavorites:(NSArray<RBFavorite *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFavoritesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFavoritesAtIndex:(NSUInteger)idx withObject:(RBFavorite *)value;
- (void)replaceFavoritesAtIndexes:(NSIndexSet *)indexes
                    withFavorites:(NSArray<RBFavorite *> *)values;
- (void)addFavoritesObject:(RBFavorite *)value;
- (void)removeFavoritesObject:(RBFavorite *)value;
- (void)addFavorites:(NSOrderedSet<RBFavorite *> *)values;
- (void)removeFavorites:(NSOrderedSet<RBFavorite *> *)values;

- (void)insertObject:(RBRecipeGroup *)value inRecipeGroupsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRecipeGroupsAtIndex:(NSUInteger)idx;
- (void)insertRecipeGroups:(NSArray<RBRecipeGroup *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRecipeGroupsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRecipeGroupsAtIndex:(NSUInteger)idx withObject:(RBRecipeGroup *)value;
- (void)replaceRecipeGroupsAtIndexes:(NSIndexSet *)indexes
                    withRecipeGroups:(NSArray<RBRecipeGroup *> *)values;
- (void)addRecipeGroupsObject:(RBRecipeGroup *)value;
- (void)removeRecipeGroupsObject:(RBRecipeGroup *)value;
- (void)addRecipeGroups:(NSOrderedSet<RBRecipeGroup *> *)values;
- (void)removeRecipeGroups:(NSOrderedSet<RBRecipeGroup *> *)values;

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
