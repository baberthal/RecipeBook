//
//  RBRecipe+CoreDataProperties.m
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/8/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RBRecipe+CoreDataProperties.h"

@implementation RBRecipe (CoreDataProperties)

@dynamic recipeDescription;
@dynamic stars;
@dynamic ingredientAmounts;
@dynamic recipeGroup;
@dynamic steps;
@dynamic recipeBook;

@end
