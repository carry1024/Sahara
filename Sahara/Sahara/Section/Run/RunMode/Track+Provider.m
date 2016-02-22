/* vim: set ft=objc fenc=utf-8 sw=2 ts=2 et: */
/*
 *  DOUAudioStreamer - A Core Audio based streaming audio player for iOS/Mac:
 *
 *      https://github.com/douban/DOUAudioStreamer
 *
 *  Copyright 2013-2014 Douban Inc.  All rights reserved.
 *
 *  Use and distribution licensed under the BSD license.  See
 *  the LICENSE file for full text.
 *
 *  Authors:
 *      Chongyu Zhu <i@lembacon.com>
 *
 */

#import "Track+Provider.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation Track (Provider)

+ (NSArray *)remoteTracks:(NSArray * )songArr
{
    static NSArray *tracks = nil;
    NSMutableArray *allTracks = [NSMutableArray array];
    for (NSDictionary *song in songArr) {
        Track *track = [[Track alloc] init];
        [track setPicture:[song objectForKey:@"SongPic"]];
        [track setArtist:[song objectForKey:@"SingerName"]];
        [track setTitle:[song objectForKey:@"SongName"]];
        [track setSongId:[song objectForKey:@"ContentId"]];
        [track setAudioFileURL:[NSURL URLWithString:[song objectForKey:@"PlayPath"]]];
        [track setLike:[[song objectForKey:@"Like"] boolValue]];
        [allTracks addObject:track];
    }
    tracks = [allTracks copy];
    return tracks;
}

+ (NSArray *)musicLibraryTracks
{
    static NSArray *tracks = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *allTracks = [NSMutableArray array];
        for (MPMediaItem *item in [[MPMediaQuery songsQuery] items]) {
            if ([[item valueForProperty:MPMediaItemPropertyIsCloudItem] boolValue]) {
                continue;
            }
            
            Track *track = [[Track alloc] init];
            [track setArtist:[item valueForProperty:MPMediaItemPropertyArtist]];
            [track setTitle:[item valueForProperty:MPMediaItemPropertyTitle]];
            [track setAudioFileURL:[item valueForProperty:MPMediaItemPropertyAssetURL]];
            [allTracks addObject:track];
        }
        
        for (NSUInteger i = 0; i < [allTracks count]; ++i) {
            NSUInteger j = arc4random_uniform((u_int32_t)[allTracks count]);
            [allTracks exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
        
        tracks = [allTracks copy];
    });
    
    return tracks;
}

@end
