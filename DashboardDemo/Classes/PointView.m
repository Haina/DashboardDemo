//
//  PointView.m
//  DashboardDemo
//
//  Created by 四川 wwgps on 2020/11/26.
//

#import "PointView.h"

@interface PointView ()

@property (nonatomic, strong) CAShapeLayer *valueLayer;
@property (nonatomic, strong) CALayer *cursorLayer;
@property (nonatomic, strong) UIBezierPath *valuePath;
@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;
@property (nonatomic, assign) CGFloat currenAngle;
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, assign) NSInteger oldValue;
@property (nonatomic, assign) NSInteger value;

@end

@implementation PointView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _startAngle = M_PI*15.2/18;
        _endAngle = M_PI*2.8/18;
        
        [self setupViews];
    }
    return self;
}

- (void)dealloc {
    [self.link invalidate];
    self.link = nil;
}

/**
 p1********************************************p6
 *                                             *
 *                                             *
 *                                             *
 *                                             *
 p2******************p3   p4******************p5
                   p3.1 *  p4.1
 */

- (void)setupViews {
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat radius = 15;
    
    CGFloat gain_originY = 44;
    
    CGPoint p1 = CGPointMake(x, y);
    CGPoint p2 = CGPointMake(x, height-radius);
    CGPoint p3 = CGPointMake(width/2-radius, height-radius);
    CGPoint p3_1 = CGPointMake(width/2-radius, height);
    CGPoint p4 = CGPointMake(width/2+radius, height-radius);
    CGPoint p4_1 = CGPointMake(width/2+radius, height);
    CGPoint p5 = CGPointMake(width, height-radius);
    CGPoint p6 = CGPointMake(width, y);
    
    NSLog(@" \np1:%@ \np2:%@ \np3:%@ \np3_1:%@ \np4:%@ \np4_1:%@ \np5:%@ \np6:%@",NSStringFromCGPoint(p1),NSStringFromCGPoint(p2),NSStringFromCGPoint(p3),NSStringFromCGPoint(p3_1),NSStringFromCGPoint(p4),NSStringFromCGPoint(p4_1),NSStringFromCGPoint(p5),NSStringFromCGPoint(p6));
    
    ///  渐变背景
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    
    UIColor *startColor = [UIColor colorWithRed:225/255.0 green:187/255.0 blue:118/255.0 alpha:1];
    UIColor *endColor = [UIColor colorWithRed:209/255.0 green:162/255.0 blue:92/255.0 alpha:1];
    
    gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    gradientLayer.frame = self.bounds;
    [self.layer addSublayer:gradientLayer];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:p1];
    [bezierPath addLineToPoint:p2];
    [bezierPath addLineToPoint:p3];
    [bezierPath addArcWithCenter:p3_1 radius:radius startAngle:1.5*M_PI endAngle:0 clockwise:YES];
    [bezierPath addArcWithCenter:p4_1 radius:radius startAngle:-1*M_PI endAngle:-0.5*M_PI clockwise:YES];
    [bezierPath moveToPoint:p4];
    [bezierPath addLineToPoint:p5];
    [bezierPath addLineToPoint:p6];
    [bezierPath addLineToPoint:p1];
    
    shapeLayer.path = bezierPath.CGPath;
    self.layer.mask = shapeLayer;
    
//    shapeLayer.fillColor = [UIColor colorWithRed:0.92 green:0.27 blue:0.49 alpha:1.0].CGColor;
//    shapeLayer.strokeColor = [UIColor colorWithRed:1.0 green:0.69 blue:0.33 alpha:1.0].CGColor;
//    shapeLayer.lineWidth = 3;
//    [self.layer addSublayer:shapeLayer];
    
    // inner circle
    CAShapeLayer *innerLayer = [CAShapeLayer layer];
    CGFloat innerWidth = 170;
    CGFloat innerHeight = 135;
    innerLayer.frame = CGRectMake(width/2-innerWidth/2, 54 + gain_originY, innerWidth, innerHeight);
    
    UIBezierPath *innerPath = [UIBezierPath bezierPath];
    [innerPath addArcWithCenter:CGPointMake(innerWidth/2, innerWidth/2) radius:innerWidth/2 startAngle:M_PI*14.4/18 endAngle:M_PI*3.6/18 clockwise:YES];

    innerLayer.path = innerPath.CGPath;
    innerLayer.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4].CGColor;
    innerLayer.fillColor = [UIColor clearColor].CGColor;
    innerLayer.lineDashPattern = @[@4, @3];
    [self.layer addSublayer:innerLayer];
    
    // middle circle
    CAShapeLayer *middleLayer = [CAShapeLayer layer];
    CGFloat middleWidth = 199;
    CGFloat middleHeight = 158;
    middleLayer.frame = CGRectMake(width/2-middleWidth/2, 37 + gain_originY, middleWidth, middleHeight);
    
    UIBezierPath *middlePath = [UIBezierPath bezierPath];
    [middlePath addArcWithCenter:CGPointMake(middleWidth/2, middleWidth/2) radius:middleWidth/2 startAngle:M_PI*15/18 endAngle:M_PI*3/18 clockwise:YES];
    
    middleLayer.path = middlePath.CGPath;
    middleLayer.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4].CGColor;
    middleLayer.fillColor = [UIColor clearColor].CGColor;
    middleLayer.lineWidth = 10;
    middleLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:middleLayer];
    
    // outer circle
    CAShapeLayer *outerLayer = [CAShapeLayer layer];
    CGFloat outerWidth = 226;
    CGFloat outerHeight = 165;
    outerLayer.frame = CGRectMake(width/2-outerWidth/2, 24 + gain_originY, outerWidth, outerHeight);
    
    UIBezierPath *outerPath = [UIBezierPath bezierPath];
    [outerPath addArcWithCenter:CGPointMake(outerWidth/2, outerWidth/2) radius:outerWidth/2 startAngle:M_PI*15.2/18 endAngle:M_PI*2.8/18 clockwise:YES];
    
    outerLayer.path = outerPath.CGPath;
    outerLayer.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4].CGColor;
    outerLayer.fillColor = [UIColor clearColor].CGColor;
    outerLayer.lineWidth = 3;
    outerLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:outerLayer];
    
    // value circle
    CAShapeLayer *valueLayer = [CAShapeLayer layer];
    valueLayer.frame = CGRectMake(width/2-outerWidth/2, 24 + gain_originY, outerWidth, outerHeight);
    
    self.valuePath = [UIBezierPath bezierPath];
    [self.valuePath addArcWithCenter:CGPointMake(outerWidth/2, outerWidth/2) radius:outerWidth/2 startAngle:self.startAngle endAngle:self.endAngle clockwise:YES];
    
    valueLayer.path = self.valuePath.CGPath;
    valueLayer.strokeColor = [UIColor whiteColor].CGColor;
    valueLayer.fillColor = [UIColor clearColor].CGColor;
    valueLayer.lineWidth = 3;
    valueLayer.lineCap = kCALineCapRound;
    
    self.cursorLayer = [CALayer layer];
    self.cursorLayer.backgroundColor = [UIColor whiteColor].CGColor;
    self.cursorLayer.cornerRadius = 4;
    self.cursorLayer.masksToBounds = YES;
    CGPoint startPoint = [[self pointsFromBezierPath:self.valuePath].firstObject CGPointValue];
    self.cursorLayer.frame = CGRectMake(startPoint.x, startPoint.y, 8, 8);
    [valueLayer addSublayer:self.cursorLayer];
    
    
    [self.layer addSublayer:valueLayer];
    self.valueLayer = valueLayer;
    self.valueLayer.strokeEnd = 0;
    self.value = 0;
    
    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(width/2-100/2, 102 + gain_originY, 100, 63)];
    self.numberLabel.textColor = [UIColor whiteColor];
    self.numberLabel.font = [UIFont systemFontOfSize:45];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.text = @"0";
    [self addSubview:self.numberLabel];
    
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayNumber)];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    self.link.paused = YES;
}

- (void)displayNumber {
    NSLog(@"display link变化");
    NSInteger currentNumber = [self.numberLabel.text integerValue];
    if (self.value < currentNumber) {
        currentNumber -= 1;
    } else if (self.value > currentNumber) {
        currentNumber += 1;
    }
    if (currentNumber == self.value) {
        self.link.paused = YES;
    }
    self.numberLabel.text = [NSString stringWithFormat:@"%ld", currentNumber];
}

- (void)setValue:(NSInteger)value {
    NSInteger oldValue = _value;
    _oldValue = oldValue;
    _value = value;
    
    NSLog(@"旧值：%f | 新值：%f", oldValue/100.0, value/100.0);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 1;
    animation.fromValue = @(oldValue/100.0);
    animation.toValue = @(value/100.0);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.valueLayer addAnimation:animation forKey:@"valueProgress"];
//    self.valueLayer.strokeEnd = value/100.0;
    self.link.paused = NO;
    
//    [CATransaction begin];
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    CGFloat outerWidth = 226;
    if (oldValue > value) { // <-
        CGFloat valueAngle = value/100.0 * (2*M_PI - (self.startAngle - self.endAngle)) + self.startAngle;
        CGFloat oldAngle = oldValue/100.0 * (2*M_PI - (self.startAngle - self.endAngle)) + self.startAngle;
        
        valueAngle = valueAngle - 2*M_PI;
        oldAngle = oldAngle - 2*M_PI;
        
        [bezierPath addArcWithCenter:CGPointMake(outerWidth/2, outerWidth/2) radius:outerWidth/2 startAngle:oldAngle endAngle:valueAngle clockwise:NO];
    } else if (oldValue < value) { // ->
        CGFloat valueAngle = value/100.0 * (2*M_PI - (self.startAngle - self.endAngle)) + self.startAngle;
        CGFloat oldAngle = oldValue/100.0 * (2*M_PI - (self.startAngle - self.endAngle)) + self.startAngle;
        [bezierPath addArcWithCenter:CGPointMake(outerWidth/2, outerWidth/2) radius:outerWidth/2 startAngle:oldAngle endAngle:valueAngle clockwise:YES];
    } else {
        return;
    }
    
    CAKeyframeAnimation *positionKF = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionKF.duration = 1;
    positionKF.path = bezierPath.CGPath;
    positionKF.calculationMode = kCAAnimationPaced;
    positionKF.removedOnCompletion = NO;
    positionKF.fillMode = kCAFillModeForwards;

    [self.cursorLayer addAnimation:positionKF forKey:@"rotateCursorAnimated"];
}

void getPointsFromBezier(void *info, const CGPathElement *element) {
    NSMutableArray *bezierPoints = (__bridge NSMutableArray *)info;
    CGPathElementType type = element->type;
    CGPoint *points = element->points;
    
    if (type != kCGPathElementCloseSubpath) {
        [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
        if (type != kCGPathElementAddLineToPoint && type != kCGPathElementMoveToPoint) {
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[1]]];
        }
    }
    
    if (type == kCGPathElementAddCurveToPoint) {
        [bezierPoints addObject:[NSValue valueWithCGPoint:points[2]]];
    }
}

- (NSArray *)pointsFromBezierPath:(UIBezierPath *)path {
    NSMutableArray *points = [NSMutableArray array];
    CGPathApply(path.CGPath, (__bridge void *)points, getPointsFromBezier);
    return points;
}

@end
