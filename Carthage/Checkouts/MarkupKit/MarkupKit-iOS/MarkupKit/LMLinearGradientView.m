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

#import "LMLinearGradientView.h"

@implementation LMLinearGradientView

- (instancetype)init
{
    self = [super init];

    if (self) {
        _startPoint = CGPointMake(0.5, 0.0);
        _endPoint = CGPointMake(0.5, 1.0);
    }

    return self;
}

- (CGFloat)startX
{
    return _startPoint.x;
}

- (void)setStartX:(CGFloat)startX
{
    [self setStartPoint:CGPointMake(startX, _startPoint.y)];
}

- (CGFloat)startY
{
    return _startPoint.y;
}

- (void)setStartY:(CGFloat)startY
{
    [self setStartPoint:CGPointMake(_startPoint.x, startY)];
}

- (void)setStartPoint:(CGPoint)startPoint
{
    _startPoint = startPoint;

    [self setNeedsDisplay];
}

- (CGFloat)endX
{
    return _endPoint.x;
}

- (void)setEndX:(CGFloat)endX
{
    [self setEndPoint:CGPointMake(endX, _endPoint.y)];
}

- (CGFloat)endY
{
    return _endPoint.y;
}

- (void)setEndY:(CGFloat)endY
{
    [self setEndPoint:CGPointMake(_endPoint.x, endY)];
}

- (void)setEndPoint:(CGPoint)endPoint
{
    _endPoint = endPoint;

    [self setNeedsDisplay];
}

- (void)drawGradient:(CGGradientRef)gradient withContext:(CGContextRef)context {
    CGSize size = [self frame].size;

    CGPoint startPoint = CGPointMake(_startPoint.x * size.width, _startPoint.y * size.height);
    CGPoint endPoint = CGPointMake(_endPoint.x * size.width, _endPoint.y * size.height);

    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
}

@end
