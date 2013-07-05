//
//  AudioManager.m
//  Animol
//
//  Copyright (c) 2011 Sammy NetWorks Co., Ltd. All rights reserved.
//

#import "AudioManager.h"
#import "MyOpenALSupport.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SNConstants.h"

#define GLOBAL_GAIN 0.8f

@interface AudioManager()
-(BOOL)initOpenAL;
-(UInt32)audioFileSize:(AudioFileID)fileDescriptor;
-(BOOL)loadSoundWithKey:(NSString *)soundKey file:(NSString*)file;
-(BOOL)loadSoundWithKey:(NSString *)soundKey file:(NSString*)file loop:(BOOL)loops;
-(AVAudioPlayer *)prepareBGMPlayerWithPath:(NSString *)path;
@end

@implementation AudioManager

@synthesize bufferStorageArray;
@synthesize soundDictionary;
@synthesize replayMusicBg;

static AudioManager *instance = NULL;

/*
 * Initialies the shared session. Not intended to 
 * be called directly. Use sharedInstance instead. 
 */
-(id)init {
	if(self = [super init]) {
        self.replayMusicBg = 0;
		if ([self initOpenAL]) {
			self.bufferStorageArray = [[[NSMutableArray alloc] init] autorelease];
			self.soundDictionary = [[[NSMutableDictionary alloc] init] autorelease];
		}
		return self;
	}
	[self release];
	return nil;
}

// Start up openAL
-(BOOL)initOpenAL {
	// Initialization
	device = alcOpenDevice(NULL); // select the "preferred device"
	if(device) {
		// Use the device to make a context
		context=alcCreateContext(device, NULL);
		// Set my context to the currently active one
		alcMakeContextCurrent(context);
		return YES;
	}
	return NO;
}

-(void)initSoundWithKeys:(NSArray *)keys 
{
	NSDate *methodStart = [NSDate date];
	
	// Sound Effects
    for(NSString *key in keys)
    {
        // keyは拡張子.cafを除いたファイル名（tap.cafであれば、@"tap"）
        [self loadSoundWithKey:key file:key];
    }
	NSDate *methodFinish = [NSDate date];
	NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
	LOG(@"Audio files successfully loaded... (%.4fsecs)", executionTime);
}

-(void)dealloc {
	// Delete the sources
	for (NSNumber *sourceNumber in [soundDictionary allValues]) {
		NSUInteger sourceID = [sourceNumber unsignedIntegerValue];
		alDeleteSources(1, &sourceID);
	}
	
	self.soundDictionary = nil;
	
	// Delete the buffers
	for (NSNumber *bufferNumber in bufferStorageArray) {
		NSUInteger bufferID = [bufferNumber unsignedIntegerValue];
		alDeleteBuffers(1, &bufferID);
	}
	self.bufferStorageArray = nil;
	
	// Destroy the context
	alcDestroyContext(context);
	// Close the device
	alcCloseDevice(device);
	
	[super dealloc];
}

//------------------------------------------------------------------------------
#pragma mark -
#pragma mark Public methods

/*
 * Returns a singleton reference for all uses of this class. 
 */
+(AudioManager*)sharedInstance {
	@synchronized(self){
		if(instance == NULL) {
			instance = [[AudioManager alloc] init];
		}
	}
	return instance;
}

//------------------------------------------------------------------------------
#pragma mark -
#pragma mark Public methods

// The main method: grab the sound ID from the library and start the source playing
-(void)playSoundWithKey:(NSString *)soundKey 
{
    //kaiqing sound
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kSoundSetting] == NO) {
        return;
    }
    
#if !TARGET_IPHONE_SIMULATOR
    if ([[MPMusicPlayerController iPodMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying) {
        return;
    }
#endif
	NSNumber * numVal = [soundDictionary objectForKey:soundKey];
	if (numVal == nil) return;
	NSUInteger sourceID = [numVal unsignedIntValue];
	alSourcePlay(sourceID);
}

-(void)stopSoundWithKey:(NSString *)soundKey {
	NSNumber * numVal = [soundDictionary objectForKey:soundKey];
	if (numVal == nil) return;
	NSUInteger sourceID = [numVal unsignedIntValue];
	alSourceStop(sourceID);
}

//------------------------------------------------------------------------------
#pragma mark -
#pragma mark BGM methods

-(void)playBGMOpShop
{
    self.replayMusicBg = 1;
#if !TARGET_IPHONE_SIMULATOR
    if ([[MPMusicPlayerController iPodMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying) {
        return;
    }
#endif
    if(bgmPlayer1 == nil)
    {
        bgmPlayer1 = [[self prepareBGMPlayerWithPath:@"bgm_op_shop"] retain];
    }
    [bgmPlayer1 setCurrentTime:0];
    [bgmPlayer1 play];
}

-(void)playBGMRoom
{
    self.replayMusicBg = 2;
#if !TARGET_IPHONE_SIMULATOR
    if ([[MPMusicPlayerController iPodMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying) {
        return;
    }
#endif
    if(bgmPlayer2 == nil)
    {
        bgmPlayer2 = [[self prepareBGMPlayerWithPath:@"bgm_room"] retain];
    }
    [bgmPlayer2 setCurrentTime:0];
    [bgmPlayer2 play];
}

-(void)playBGMPark
{
    self.replayMusicBg = 3;
#if !TARGET_IPHONE_SIMULATOR
    if ([[MPMusicPlayerController iPodMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying) {
        return;
    }
#endif
    if(bgmPlayer3 == nil)
    {
        bgmPlayer3 = [[self prepareBGMPlayerWithPath:@"bgm_park"] retain];
    }
    [bgmPlayer3 setCurrentTime:0];
    [bgmPlayer3 play];
}

-(void)stopBGM 
{
	if(bgmPlayer1) [bgmPlayer1 stop];
    if(bgmPlayer2) [bgmPlayer2 stop];
    if(bgmPlayer3) [bgmPlayer3 stop];
}

-(void)reloadBGM {
    if ([[MPMusicPlayerController iPodMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying) {
        LOG(@"Ipod playing music");
    }
    else {
        if(self.replayMusicBg == 1) {
            [self playBGMOpShop];
        }
        else if(self.replayMusicBg == 2) {
            [self playBGMRoom];
        }
        else if(self.replayMusicBg == 3) {
            [self playBGMPark];
        }
    }
}

//------------------------------------------------------------------------------
#pragma mark -
#pragma mark Sound effect methods

//------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private methods

// Seek in audio file for the property 'size' and return the size in bytes
-(UInt32)audioFileSize:(AudioFileID)fileDescriptor {
	UInt64 outDataSize = 0;
	UInt32 thePropSize = sizeof(UInt64);
	OSStatus result = AudioFileGetProperty(fileDescriptor, kAudioFilePropertyAudioDataByteCount, &thePropSize, &outDataSize);
	if(result != 0) {
		LOG(@"Cannot find file size");
	}
	return (UInt32)outDataSize;
}

-(AVAudioPlayer *)prepareBGMPlayerWithPath:(NSString *)path 
{
	AVAudioPlayer *player = nil;
    
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	LOG(@"Start loading opening BGM...");
	NSDate *methodStart = [NSDate date];
	@synchronized(self){
		// Lazy Load
		// Load the array with the sample file
		NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource:path ofType:@"caf"]];
		
		NSError *error = nil;
		player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];				
		[player setNumberOfLoops:-1];
		[player setVolume:0.65];
		[player prepareToPlay];
		
        if(error) {
            LOG(@"Sound load error : %@", error);
        }
        
		[fileURL release];
	}
	NSDate *methodFinish = [NSDate date];
	NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
	LOG(@"End loading BGM... (%fsecs)", executionTime);
	
	[pool release];
	
	return [player autorelease];
}

-(BOOL)loadSoundWithKey:(NSString *)soundKey file:(NSString*)file {
	return [self loadSoundWithKey:soundKey file:file loop:NO];
}

-(BOOL)loadSoundWithKey:(NSString *)soundKey file:(NSString*)file loop:(BOOL)loops {
	
	ALvoid *outData;
	ALenum  format, error = AL_NO_ERROR;
	ALsizei size, freq;
	
	// Get some audio data from a file
	CFURLRef fileURL = (CFURLRef)[[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:file ofType:@"caf"]] retain];
	if (!fileURL) {
		return NO;
	}
	
	outData = MyGetOpenALAudioData(fileURL, &size, &format, &freq);
	
	CFRelease(fileURL);
	
	if((error = alGetError()) != AL_NO_ERROR) {
		LOG(@"Error loading sound: %d\n", error);
		return NO;
	}
	
	// Grab a buffer ID from openAL
	NSUInteger bufferID;
	alGenBuffers(1, &bufferID);
	
	// Load the awaiting data blob into the openAL buffer.
	alBufferData(bufferID, format, outData, size, freq); 
	
	// Save the buffer so we can release it later
	[bufferStorageArray addObject:[NSNumber numberWithUnsignedInteger:bufferID]];
	
	NSUInteger sourceID;
	// Grab a source ID from openAL
	alGenSources(1, &sourceID); 
	
	// Attach the buffer to the source
	alSourcei(sourceID, AL_BUFFER, bufferID);
	// Set some basic source prefs
	alSourcef(sourceID, AL_PITCH, 1.0f);
	alSourcef(sourceID, AL_GAIN, GLOBAL_GAIN);
	//if (loops) alSourcei(sourceID, AL_LOOPING, AL_TRUE);
	
	// Store this for future use
	[soundDictionary setObject:[NSNumber numberWithUnsignedInt:sourceID] forKey:soundKey];	
	
	// Clean up the buffer
	if (outData) {
		free(outData);
		outData = NULL;
	}

	return YES;
}

//kaiqing sound
-(void)muteSound{
    bgmPlayer1.volume = 0.0;
    bgmPlayer2.volume = 0.0;
    bgmPlayer3.volume = 0.0;
}

-(void)retainSound{
    bgmPlayer1.volume = 0.65;
    bgmPlayer2.volume = 0.65;
    bgmPlayer3.volume = 0.65;
}

@end
