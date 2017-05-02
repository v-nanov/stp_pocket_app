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

#import "UITableView+Markup.h"
#import "UITableViewCell+Markup.h"
#import "NSObject+Markup.h"

static NSDictionary *tableViewCellSeparatorStyleValues;

@implementation UITableView (Markup)

+ (void)initialize
{
    tableViewCellSeparatorStyleValues = @{
        #if TARGET_OS_IOS
        @"none": @(UITableViewCellSeparatorStyleNone),
        @"singleLine": @(UITableViewCellSeparatorStyleSingleLine),
        @"singleLineEtched": @(UITableViewCellSeparatorStyleSingleLineEtched)
        #endif
    };
}

- (NSString *)nameForSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)sectionWithName:(NSString *)name
{
    NSInteger section = 0, n = [self numberOfSections];

    while (section < n) {
        if ([[self nameForSection:section] isEqual:name]) {
            break;
        }

        section++;
    }

    return (section < n) ? section : NSNotFound;
}

- (NSInteger)rowForCellWithValue:(id)value inSection:(NSInteger)section
{
    NSInteger row = 0, n = [self numberOfRowsInSection:section];

    while (row < n) {
        UITableViewCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];

        if ([[cell value] isEqual:value]) {
            break;
        }

        row++;
    }

    return (row < n) ? row : NSNotFound;
}

- (NSInteger)rowForCheckedCellInSection:(NSInteger)section
{
    NSInteger row = 0, n = [self numberOfRowsInSection:section];

    while (row < n) {
        UITableViewCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];

        if ([cell checked]) {
            break;
        }

        row++;
    }

    return (row < n) ? row : NSNotFound;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [NSException raise:NSInternalInconsistencyException format:@"Unexpected request for table view cell."];

    return nil;
}

- (void)applyMarkupPropertyValue:(id)value forKey:(NSString *)key
{
    if ([key isEqual:@"separatorStyle"]) {
        value = [tableViewCellSeparatorStyleValues objectForKey:value];
    }

    [super applyMarkupPropertyValue:value forKey:key];
}

@end
