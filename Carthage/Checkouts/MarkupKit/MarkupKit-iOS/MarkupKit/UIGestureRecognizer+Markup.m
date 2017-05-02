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

#import "UIGestureRecognizer+Markup.h"
#import "NSObject+Markup.h"

static NSDictionary *pressTypeValues;
static NSDictionary *touchTypeValues;

@implementation UIGestureRecognizer (Markup)

+ (void)initialize
{
    pressTypeValues = @{
        @"upArrow": @(UIPressTypeUpArrow),
        @"downArrow": @(UIPressTypeDownArrow),
        @"leftArrow": @(UIPressTypeLeftArrow),
        @"rightArrow": @(UIPressTypeRightArrow),
        @"select": @(UIPressTypeSelect),
        @"menu": @(UIPressTypeMenu),
        @"playPause": @(UIPressTypePlayPause)
    };

    touchTypeValues = @{
        @"direct": @(UITouchTypeDirect),
        @"indirect": @(UITouchTypeIndirect),
        @"stylus": @(UITouchTypeStylus)
    };
}

- (void)applyMarkupPropertyValue:(id)value forKey:(NSString *)key
{
    if ([key isEqual:@"allowedPressTypes"]) {
        NSArray *components = [value componentsSeparatedByString:@","];

        NSMutableArray *allowedPressTypes = [[NSMutableArray alloc] initWithCapacity:[components count]];

        for (NSString *component in components) {
            [allowedPressTypes addObject:[pressTypeValues objectForKey:[component stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]];
        }

        value = allowedPressTypes;
    } else if ([key isEqual:@"allowedTouchTypes"]) {
        NSArray *components = [value componentsSeparatedByString:@","];

        NSMutableArray *allowedTouchTypes = [[NSMutableArray alloc] initWithCapacity:[components count]];

        for (NSString *component in components) {
            [allowedTouchTypes addObject:[touchTypeValues objectForKey:[component stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]];
        }

        value = allowedTouchTypes;
    }

    [super applyMarkupPropertyValue:value forKey:key];
}

@end
