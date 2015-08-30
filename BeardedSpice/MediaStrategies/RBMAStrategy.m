//
//  RBMAStrategy.m
//  BeardedSpice
//
//  Created by Jeremy Miller on 8/29/15.
//  Copyright (c) 2015 BeardedSpice. All rights reserved.
//

#import "RBMAStrategy.h"

@implementation RBMAStrategy

-(id) init
{
    self = [super init];
    if (self) {
        predicate = [NSPredicate predicateWithFormat:@"SELF LIKE[c] '*rbmaradio.com*'"];
    }
    return self;
}

-(BOOL) accepts:(TabAdapter *)tab
{
    return [predicate evaluateWithObject:[tab URL]];
}

- (BOOL)isPlaying:(TabAdapter *)tab {

    NSNumber *value =
        [tab executeJavascript:@"(function()"
                               @"{return $('.controls').attr('data-state') == 'playing';})()"];


    return [value boolValue];
}

-(NSString *) toggle {
    return @"(function(){$('.play-button').trigger('click')})()";
}

-(NSString *) pause
{
    return @"(function(){\
    if($('.controls').attr('data-state') == 'playing'){$('.play-button').trigger('click')}})()";
}

-(NSString *) displayName
{
    return @"RBMA Radio";
}

-(Track *) trackInfo:(TabAdapter *)tab
{
    NSDictionary *song = [tab executeJavascript:@"(function(){return { \
                          'track':  $('.now-playing > .title').text(), \
                          'artist': $('.now-playing > .host').text()} \
                          })()"];

    Track *track = [[Track alloc] init];
    track.track = [song objectForKey:@"track"];
    track.artist = [song objectForKey:@"artist"];

    return track;
}

@end
