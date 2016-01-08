//
//  RBCoreDataStack.m
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/6/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import "RBCoreDataManager.h"
#import "RBFavorite.h"
#import "RBRecipe.h"
#import "RBRecipeBook.h"
#import "RBRecipeGroup.h"

@interface RBCoreDataManager ()

@property(readonly) NSDictionary *coreDataOptions;

@end

@implementation RBCoreDataManager

#pragma mark - Singleton

+ (instancetype)sharedManager
{
    static RBCoreDataManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[RBCoreDataManager alloc] init];
    });

    return _sharedManager;
}

#pragma mark - Properties
@synthesize coreDataOptions = _coreDataOptions;

- (NSDictionary *)coreDataOptions
{
    if (_coreDataOptions) {
        return _coreDataOptions;
    }

    _coreDataOptions = @{
        NSMigratePersistentStoresAutomaticallyOption : @YES,
        NSInferMappingModelAutomaticallyOption : @YES
    };

    return _coreDataOptions;
}

#pragma mark - Core Data stack

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

- (NSURL *)applicationDocumentsDirectory
{
    // The directory the application uses to store the Core Data store file. This code uses a
    // directory named "org.jmorgan.RecipeBook" in the user's Application Support directory.
    NSURL *appSupportURL =
          [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory
                                                  inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"org.jmorgan.RecipeBook"];
}

- (NSManagedObjectModel *)managedObjectModel
{
    // The managed object model for the application. It is a fatal error for the application not to
    // be able to find and load its model.
    if (_managedObjectModel) {
        return _managedObjectModel;
    }

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RecipeBook" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    // The persistent store coordinator for the application. This implementation creates and returns
    // a coordinator, having added the store for the application to it. (The directory for the store
    // is created, if necessary.)
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationDocumentsDirectory = [self applicationDocumentsDirectory];
    BOOL shouldFail = NO;
    NSError *error = nil;
    NSString *failureReason =
          @"There was an error creating or loading the application's saved data.";

    // Make sure the application files directory is there
    NSDictionary *properties =
          [applicationDocumentsDirectory resourceValuesForKeys:@[ NSURLIsDirectoryKey ]
                                                         error:&error];
    if (properties) {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            failureReason = [NSString
                  stringWithFormat:
                        @"Expected a folder to store application data, found a file (%@).",
                        [applicationDocumentsDirectory path]];
            shouldFail = YES;
        }
    }
    else if ([error code] == NSFileReadNoSuchFileError) {
        error = nil;
        [fileManager createDirectoryAtPath:[applicationDocumentsDirectory path]
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:&error];
    }

    if (!shouldFail && !error) {
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc]
              initWithManagedObjectModel:[self managedObjectModel]];
        NSURL *url = [applicationDocumentsDirectory
              URLByAppendingPathComponent:@"OSXCoreDataObjC.storedata"];
        if (![coordinator addPersistentStoreWithType:NSXMLStoreType
                                       configuration:nil
                                                 URL:url
                                             options:self.coreDataOptions
                                               error:&error]) {
            coordinator = nil;
        }
        _persistentStoreCoordinator = coordinator;
    }

    if (shouldFail || error) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        if (error) {
            dict[NSUnderlyingErrorKey] = error;
        }
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
    // Returns the managed object context for the application (which is already bound to the
    // persistent store coordinator for the application.)
    if (_managedObjectContext) {
        return _managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext =
          [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
}

- (IBAction)saveAction:(id)sender
{
    // Performs the save action for the application, which is to send the save: message to the
    // application's managed object context. Any encountered errors are presented to the user.
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class],
              NSStringFromSelector(_cmd));
    }

    NSError *error = nil;
    if ([[self managedObjectContext] hasChanges] && ![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

#pragma mark - Properties
@synthesize favorites = _favorites;
@synthesize groups = _groups;
@synthesize ungroupedRecipes = _ungroupedRecipes;
@synthesize recipeBook = _recipeBook;

- (RBRecipeBook *)recipeBook
{
    if (_recipeBook) {
        return _recipeBook;
    }

    // Create or Load the Recipe Book Entity
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"RecipeBook"];
    NSError *error;

    _recipeBook =
          [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] lastObject];

    if (error) {
        DDLogError(@"Failed to fetch the recipe book: %@\n%@", error.localizedDescription,
                   error.userInfo);
    }

    if (!_recipeBook) {
        // The book doesn't exist, so we have to create it
        _recipeBook =
              [NSEntityDescription insertNewObjectForEntityForName:@"RecipeBook"
                                            inManagedObjectContext:self.managedObjectContext];
    }

    return _recipeBook;
}

- (NSArray<RBFavorite *> *)favorites
{
    if (_favorites) {
        return _favorites;
    }

    @synchronized(self)
    {
        NSMutableArray<RBFavorite *> *items = [NSMutableArray array];

        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Favorite"];
        NSError *error;

        NSArray<RBFavorite *> *results =
              [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

        if (error) {
            DDLogError(@"Error fetching favorites: %@\n%@", error.localizedDescription,
                       error.userInfo);
        }
        else {
            NSSortDescriptor *sortDescriptor =
                  [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
            [items addObjectsFromArray:[results sortedArrayUsingDescriptors:@[ sortDescriptor ]]];
        }

        _favorites = items;
    }

    return _favorites;
}

- (NSArray<RBRecipeGroup *> *)groups
{
    if (_groups) {
        return _groups;
    }

    NSArray<RBRecipeGroup *> *groups;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"RecipeGroup"];
    NSError *error;

    groups = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    if (error) {
        DDLogError(@"Error fetching RecipeGroups: %@\n%@", error.localizedDescription,
                   error.userInfo);
    }

    if (groups && groups.count) {
        _groups = [NSArray arrayWithArray:groups];
    }

    return _groups;
}

- (NSArray<RBRecipe *> *)ungroupedRecipes
{
    if (_ungroupedRecipes) {
        return _ungroupedRecipes;
    }

    NSMutableArray<RBRecipe *> *recipes = [NSMutableArray array];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
    [fetchRequest
          setPredicate:[NSPredicate
                             predicateWithFormat:@"recipeGroup == NIL OR recipeGroup == NULL"]];
    NSError *error;

    NSArray *fetchedObjects =
          [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    if (fetchedObjects == nil) {
        DDLogWarn(@"Fetched objects was nil when fetching ungrouped recipes");
    }

    if (error) {
        DDLogError(@"Error fetching ungrouped recipes: %@\n%@", error.localizedDescription,
                   error.userInfo);
    }

    if (fetchedObjects) {
        [recipes addObjectsFromArray:fetchedObjects];
    }

    _ungroupedRecipes = recipes;

    return _ungroupedRecipes;
}

@end
