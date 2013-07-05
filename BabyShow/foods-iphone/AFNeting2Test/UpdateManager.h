//
//  UpdateManager.h
//  Animol
//
//  Copyright (c) 2011 Sammy NetWorks Co., Ltd. All rights reserved.
//

#import "AFHTTPClient.h"

typedef enum {
    UpdateStatesNotStarted,
    UpdateStatesStarted,
    UpdateStatesDownloadProgress,
    UpdateStatesInstallProgress,
    UpdateStatesUpdateCompleted,
    UpdateStatesUpdateFailed,
    UpdateStatesFinished
} UpdateStates;

@class UpdateResource;

typedef void(^UpdateProgressBlock)(UpdateResource *resource);
typedef void(^AllUpdatedBlock)(void);

#define kUpdateManagerNotification  @"kUpdateManagerNotification"

#define kUpdateManagerStatesKey     @"kUpdateManagerStatesKey"
#define kUpdateManagerMessageKey    @"kUpdateManagerMessageKey"
#define kUpdateManagerProgressKey    @"kUpdateManagerProgressKey"

//------------------------------------------------------------------------------
@interface UpdateManager : NSObject
{
    BOOL _isUpdating;
}

@property (nonatomic, retain) NSOperationQueue *operationQueue;
@property (nonatomic, copy) UpdateProgressBlock updateProgressBlock;
@property (nonatomic, copy) AllUpdatedBlock allUpdatedBlock;
@property (nonatomic, retain) NSMutableArray *updateResources;
@property (nonatomic, assign) NSUInteger totalUpdatesCount;

+ (UpdateManager *)defaultManager;

- (void)addUpdateResourceWithName:(NSString *)name 
                              key:(NSString *)key
                       identifier:(NSString *)identifier 
                              url:(NSString *)urlString;

- (void)startUpdatingOnProgress:(void(^)(UpdateResource *resource))progress 
                     allUpdated:(void(^)())allUpdated;

- (BOOL)needsUpdate;

@end

//------------------------------------------------------------------------------
@interface UpdateResource : NSObject

@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSNumber *number;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, assign) UpdateStates states;
@property (nonatomic, assign) float progress;

- (BOOL)needsUpdate;
- (void)saveAsSuccess;

- (NSString *)tmpSaveFilePath;
- (NSString *)stampFilePath;
+ (NSString *)resourceLocationPath;

@end