//
//  AudioManager.h
//  Animol
//
//  Copyright (c) 2011 Sammy NetWorks Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>


@interface AudioManager : NSObject {
@private
	AVAudioPlayer *bgmPlayer1;
	AVAudioPlayer *bgmPlayer2;
	AVAudioPlayer *bgmPlayer3;
//	AVAudioPlayer *bgmPlayer4;
	
	ALCcontext* context; // Stores the context
	ALCdevice* device; // Stores the device
	NSMutableArray * bufferStorageArray; // Stores the buffer ids from openAL
	NSMutableDictionary * soundDictionary; // Stores our soundkeys	
}

+(AudioManager*)sharedInstance;

-(void)initSoundWithKeys:(NSArray *)keys;
-(void)playSoundWithKey:(NSString *)soundKey; // Play a sound by name
-(void)stopSoundWithKey:(NSString *)soundKey; // Stop a sound by name

// if you want to access directly the buffers or our sound dictionary
@property(nonatomic, retain) NSMutableArray *bufferStorageArray;
@property(nonatomic, retain) NSMutableDictionary *soundDictionary;
@property(nonatomic, assign) NSInteger replayMusicBg;

-(void)playBGMOpShop;
-(void)playBGMRoom;
-(void)playBGMPark;
-(void)stopBGM;
-(void)reloadBGM;
//kaiqing sound
-(void)muteSound;
-(void)retainSound;

@end
