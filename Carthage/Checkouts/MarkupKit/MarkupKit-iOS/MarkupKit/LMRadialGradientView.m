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

#import "LMRadialGradientView.h"

@implementation LMRadialGradientView

- (instancetype)init
{
    self = [super init];

    if (self) {
        _centerPoint = CGPointMake(0.5, 0.5);
        _radius = 0.5;
    }

    return self;
}

- (CGFloat)centerX
{
    return _centerPoint.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    [self setCenterPoint:CGPointMake(centerX, _centerPoint.y)];
}

- (CGFloat)centerY
{
    return _centerPoint.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    [self setCenterPoint:CGPointMake(_centerPoint.x, centerY)];
}

- (void)setCenterPoint:(CGPoint)centerPoint
{
    _centerPoint = centerPoint;

    [self setNeedsDisplay];
}

- (void)setRadius:(CGFloat)radius
{
    _radius = radius;

    [self setNeedsDisplay];
}

- (void)drawGradient:(CGGradientRef)gradient withContext:(CGContextRef)context {
    CGSize size = [self frame].size;

    CGPoint centerPoint = CGPointMake(_centerPoint.x * size.width, _centerPoint.y * size.height);
    CGFloat radius = _radius * MIN(size.width, size.height);

    CGContextDrawRadialGradient(context, gradient, centerPoint, 0, centerPoint, radius,
        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
}

@end
