//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "LMPlayerView.h"

#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetTrack.h>
#import <AVFoundation/AVMediaFormat.h>

static NSString * const kReadyForDisplayProperty = @"readyForDisplay";

@implementation LMPlayerView

+ (Class)layerClass {
    return [AVPlayerLayer self];
}

@dynamic layer;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        [[self layer] addObserver:self forKeyPath:kReadyForDisplayProperty options:0 context:nil];
    }

    return self;
}

- (void)dealloc
{
    [[self layer] removeObserver:self forKeyPath:kReadyForDisplayProperty];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:kReadyForDisplayProperty]) {
        [self invalidateIntrinsicContentSize];

        if ([_delegate respondsToSelector:@selector(playerView:isReadyForDisplay:)]) {
            [_delegate playerView:self isReadyForDisplay:[[self layer] isReadyForDisplay]];
        }
    }
}

- (CGSize)intrinsicContentSize {
    AVPlayerLayer *layer = [self layer];

    CGSize size;
    if ([layer isReadyForDisplay]) {
        NSArray *videoTracks = [[[[[self layer] player] currentItem] asset] tracksWithMediaType:AVMediaTypeVideo];

        if ([videoTracks count] > 0) {
            size = [[videoTracks objectAtIndex:0] naturalSize];
        } else {
            size = [super intrinsicContentSize];
        }
    } else {
        size = [super intrinsicContentSize];
    }

    return size;
}

@end
