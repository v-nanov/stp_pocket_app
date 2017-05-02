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

#import "CALayer+Markup.h"
#import "NSObject+Markup.h"
#import "LMViewBuilder.h"

#import <UIKit/UIColor.h>

@implementation CALayer (Markup)

- (CGFloat)shadowOffsetWidth
{
    return self.shadowOffset.width;
}

- (void)setShadowOffsetWidth:(CGFloat)width
{
    self.shadowOffset = CGSizeMake(width, self.shadowOffset.height);
}

- (CGFloat)shadowOffsetHeight
{
    return self.shadowOffset.height;
}

- (void)setShadowOffsetHeight:(CGFloat)height
{
    self.shadowOffset = CGSizeMake(self.shadowOffset.width, height);
}

- (void)applyMarkupPropertyValue:(id)value forKey:(NSString *)key
{
    if ([value isKindOfClass:[UIColor self]]) {
        value = (id)[value CGColor];
    }

    [super applyMarkupPropertyValue:value forKey:key];
}

@end
