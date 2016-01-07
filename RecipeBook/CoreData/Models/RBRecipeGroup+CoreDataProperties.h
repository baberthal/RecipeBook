//
//  RBRecipeGroup+CoreDataProperties.h
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/6/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RBRecipeGroup.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBRecipeGroup (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *groupName;
@property (nullable, nonatomic, retain) NSSet<RBRecipe *> *recipes;

@end

@interface RBRecipeGroup (CoreDataGeneratedAccessors)

- (void)addRecipesObject:(RBRecipe *)value;
- (void)removeRecipesObject:(RBRecipe *)value;
- (void)addRecipes:(NSSet<RBRecipe *> *)values;
- (void)removeRecipes:(NSSet<RBRecipe *> *)values;

@end

NS_ASSUME_NONNULL_END
