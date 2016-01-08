//
//  RBItem+CoreDataProperties.h
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/8/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RBItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBItem (CoreDataProperties)

@property(nullable, nonatomic, retain) NSData *imageData;
@property(nullable, nonatomic, retain) NSString *imageName;
@property(nullable, nonatomic, retain) NSString *name;
@property(nullable, nonatomic, retain) NSSet<RBFavorite *> *favorites;

@end

@interface RBItem (CoreDataGeneratedAccessors)

- (void)addFavoritesObject:(RBFavorite *)value;
- (void)removeFavoritesObject:(RBFavorite *)value;
- (void)addFavorites:(NSSet<RBFavorite *> *)values;
- (void)removeFavorites:(NSSet<RBFavorite *> *)values;

@end

NS_ASSUME_NONNULL_END
