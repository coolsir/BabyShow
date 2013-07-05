//
//  UpdateManager.m
//  Animol
//
//  Copyright (c) 2011 Sammy NetWorks Co., Ltd. All rights reserved.
//

#import "UpdateManager.h"
#import "ZipArchive.h"
#import "SNConstants.h"

static UpdateManager *_instance;

//------------------------------------------------------------------------------
@interface UpdateManager (Private)
- (void)doUpdateResource;
- (void)saveResource:(UpdateResource *)resource data:(NSData *)data;
- (void)installResource:(UpdateResource *)resource;
@end

@implementation UpdateManager

@synthesize updateProgressBlock = _updateProgressBlock;
@synthesize allUpdatedBlock = _allUpdatedBlock;
@synthesize updateResources = _updateResources;
@synthesize operationQueue = _operationQueue;
@synthesize totalUpdatesCount = _totalUpdatesCount;

+ (UpdateManager *)defaultManager
{
    if(_instance == nil)
    {
        _instance = [[UpdateManager alloc] init];
    }
    return _instance;
}

- (id)init
{
    self = [super init];
    if(self) {
        self.updateResources = [NSMutableArray array];
        self.operationQueue = [[[NSOperationQueue alloc] init] autorelease];
        [self.operationQueue setMaxConcurrentOperationCount:1];
    }
    return self;
}

- (void)dealloc
{
    self.operationQueue = nil;
    self.updateProgressBlock = nil;
    self.allUpdatedBlock = nil;
    self.updateResources = nil;
    [super dealloc];
}

- (void)addUpdateResourceWithName:(NSString *)name 
                              key:(NSString *)key
                       identifier:(NSString *)identifier 
                              url:(NSString *)urlString
{
    UpdateResource *resource = [[UpdateResource alloc] init];
    resource.key = key;
    resource.name = name;
    resource.identifier = identifier;
    resource.url = [NSURL URLWithString:urlString];
    if([resource needsUpdate]) {
        [self.updateResources addObject:resource];
        resource.number = [NSNumber numberWithInt:[self.updateResources count]];
    }
    [resource release];
    // 合計数を更新する
    self.totalUpdatesCount = [self.updateResources count];
}

- (void)startUpdatingOnProgress:(void(^)(UpdateResource *resource))progress 
                     allUpdated:(void(^)())allUpdated
{
    if(_isUpdating) {
        LOG(@"[WARN] Already start updating");
        return;
    }
    
    _isUpdating = YES;
    
    self.updateProgressBlock = progress;
    self.allUpdatedBlock = allUpdated;
    
    [self doUpdateResource];
}

- (void)doUpdateResource
{
    if (self.updateResources && [self.updateResources count] > 0) 
    {
        UpdateResource *resource = [self.updateResources objectAtIndex:0];

        resource.states = UpdateStatesStarted;
        
        LOG(@"test: %@", resource.url);
        // リクエスト開始
        NSURLRequest *request = [NSURLRequest requestWithURL:resource.url];
        AFHTTPRequestOperation *operation = [AFHTTPRequestOperation operationWithRequest:request completion:^(NSURLRequest *request, NSHTTPURLResponse *response, NSData *data, NSError *error) 
                                             {
                                                 if(error) {
                                                     LOG(@"Update resource download error : %@", error);
                                                     resource.states = UpdateStatesUpdateFailed;
                                                     resource.progress = 1.0f;
                                                     self.updateProgressBlock(resource);
                                                 } else {
                                                     // ダウンロード完了、インストール
                                                     [self saveResource:resource data:data];
                                                 }
                                                 
                                                 // 次のリソースを読み込む
                                                 LOG(@"Resource completed : %@", resource.name);
                                                 [self.updateResources removeObject:resource];
                                                 [self doUpdateResource];//回调--------------------
                                             }];
        
        [operation setDownloadProgressBlock:^(NSInteger bytesRead, 
                                              NSInteger totalBytesRead, 
                                              NSInteger totalBytesExpectedToRead) 
        {
            // ダウンロード進捗通知
            resource.states = UpdateStatesDownloadProgress;
            resource.progress = ((float)totalBytesRead / (float)totalBytesExpectedToRead);
            self.updateProgressBlock(resource);
        }];
        
        [self.operationQueue addOperation:operation];
    }
    else 
    {
        // アップデート対象リソースがない場合
        self.allUpdatedBlock();
        // リソース解放
        self.updateProgressBlock = nil;
        self.allUpdatedBlock = nil;
        self.updateResources = nil;
        self.totalUpdatesCount = 0;
        self->_isUpdating = NO;
    }
}


- (void)saveResource:(UpdateResource *)resource data:(NSData *)data
{
    resource.states = UpdateStatesInstallProgress;
    resource.progress = 0.0f;
    self.updateProgressBlock(resource);
    
    NSError *error = nil;
    
    // zipデータの保存前に過去のものがあれば削除しておく
    if([[NSFileManager defaultManager] fileExistsAtPath:resource.tmpSaveFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:resource.tmpSaveFilePath error:&error];
        if(error) {
            LOG(@"Remove tmp file error before save : %@", error );
            error = nil;
        }
    }
    
    // zipデータをローカルに保存する
    NSURL *url = [NSURL fileURLWithPath:resource.tmpSaveFilePath];
    [data writeToURL:url options:NSDataWritingAtomic error:&error];
    
    if(error) {
        LOG(@"Updated Resource failed to save : %@", error);
        resource.states = UpdateStatesUpdateFailed;
        resource.progress = 1.0f;
        self.updateProgressBlock(resource);
        return;
    }
    
    // インストール処理を行う
    [self installResource:resource];
    
    // zipを削除する
    [[NSFileManager defaultManager] removeItemAtPath:resource.tmpSaveFilePath error:&error];
    if(error) {
        LOG(@"Remove tmp file error after installation : %@", error );
    }
    
    // stampファイルを保存する
    [[NSFileManager defaultManager] createFileAtPath:[resource stampFilePath] 
                                            contents:[@"SAVED" dataUsingEncoding:NSUTF8StringEncoding] 
                                          attributes:nil];
}

- (void)installResource:(UpdateResource *)resource
{
    // unzip
    BOOL unzipSuccess = NO;
	ZipArchive *za = [[ZipArchive alloc] init];
	if ([za UnzipOpenFile:resource.tmpSaveFilePath]) 
    {
        resource.progress = 0.5f;
        
		unzipSuccess = [za UnzipFileTo:[UpdateResource resourceLocationPath] overWrite:YES];
        resource.progress = 0.9f;

		if (unzipSuccess == NO) {
            // Zipの解凍に失敗した場合
            LOG(@"[ERROR] Unzip failed");
        }
        [za UnzipCloseFile];
	}
	[za release];

    if (unzipSuccess) 
    {
        // finalize resource
        [resource saveAsSuccess];
        resource.states = UpdateStatesUpdateCompleted;
    }
    else 
    {
        resource.states = UpdateStatesUpdateFailed;
    }
    
    resource.progress = 1.0f;
    self.updateProgressBlock(resource);
}

- (BOOL)needsUpdate
{
    if (self.updateResources && [self.updateResources count] > 0) 
    {
        for (UpdateResource *resource in self.updateResources)
        {
            if([resource needsUpdate]) return YES;
        }
    }
    return NO;
}

@end

//------------------------------------------------------------------------------
@implementation UpdateResource

@synthesize key = _key;
@synthesize number = _number;
@synthesize name = _name;
@synthesize identifier = _identifier;
@synthesize url = _url;
@synthesize states = _states;
@synthesize progress = _progress;

- (void)dealloc
{
    self.key = nil;
    self.number = nil;
    self.name = nil;
    self.identifier = nil;
    self.url = nil;
    [super dealloc];
}

- (BOOL)needsUpdate
{
    // サーバのリソースがローカルに同期されていない場合
    NSString *currentIdentifier = [[NSUserDefaults standardUserDefaults] stringForKey:self.key];
    if ([currentIdentifier isEqualToString:self.identifier] == NO) {
        return YES;
    }
    
    // ローカルに指定されたリソースが保存されていない場合
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self stampFilePath]] == NO) {
        return YES;
    }
    
    return NO;
}

- (void)saveAsSuccess
{
    [[NSUserDefaults standardUserDefaults] setObject:self.identifier 
                                              forKey:self.key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)tmpSaveFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); 
    NSString *cacheDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"_%@.zip", self.key];
    return [cacheDirectory stringByAppendingPathComponent:fileName];
}

- (NSString *)stampFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); 
    NSString *cacheDirectory = [paths objectAtIndex:0];
    NSString *path = [cacheDirectory stringByAppendingPathComponent:SNImageCacheDirectoryName];
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.txt", self.key, self.identifier];
    return [path stringByAppendingPathComponent:fileName];
}

+ (NSString *)resourceLocationPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); 
    NSString *cacheDirectory = [paths objectAtIndex:0];
    NSString *path = [cacheDirectory stringByAppendingPathComponent:SNImageCacheDirectoryName];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path] == NO) {
        // ディレクトリが存在しない場合は作る
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:path 
                                  withIntermediateDirectories:NO 
                                                   attributes:nil 
                                                        error:&error];
    }
    
    return path;
}

@end