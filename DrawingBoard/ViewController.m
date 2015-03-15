//
//  ViewController.m
//  DrawingBoard
//
//  Created by Matthew on 3/13/15.
//  Copyright (c) 2015 Matthew. All rights reserved.
//

#import "ViewController.h"
#import <CoreGraphics/CoreGraphics.h>


enum {
    Red_Color = 0,
    Green_Color = 1,
    Blue_Color = 2
};

enum {
    small_size = 0,
    middle_size = 1,
    large_size = 2
};


@interface ViewController ()
@property (nonatomic,assign) CGPoint previousPoint1;
@property (nonatomic,assign) CGPoint previousPoint2;
@property (nonatomic,assign) CGPoint currentPoint;

-(CGPoint)midPoint:(CGPoint)p1 secondPoint:(CGPoint)p2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ColorSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *StrokeSegment;

@end

@implementation ViewController
@synthesize previousPoint1;
@synthesize previousPoint2;
@synthesize currentPoint;

//
//-(UIColor *)currentColor
//{
//    if(!_currentColor)
//    {
//        _currentColor = [UIColor blackColor];
//    }
//    return _currentColor;
//}
- (IBAction)clearView:(UIButton *)sender {
    self.imageView.image = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (IBAction)changeColor:(UIButton *)sender {
//    self.currentColor = sender.backgroundColor;
//}


-(CGPoint)midPoint:(CGPoint)p1 secondPoint:(CGPoint)p2
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    
    previousPoint1 = [touch previousLocationInView:self.view];
    previousPoint2 = [touch previousLocationInView:self.view];
    currentPoint = [touch locationInView:self.view];
    
    //touch and draw circle , for feel real drawing
    [self touchesMoved:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    
    previousPoint2 = previousPoint1;
    previousPoint1 = [touch previousLocationInView:self.view];
    currentPoint = [touch locationInView:self.view];
    
    
    // calculate mid point
    CGPoint mid1 = [self midPoint:previousPoint1 secondPoint:previousPoint2];
    CGPoint mid2 = [self midPoint:currentPoint secondPoint:previousPoint1];
    
    UIGraphicsBeginImageContext(self.imageView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    [self.imageView.image drawInRect:CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height)];
    
    
    CGContextMoveToPoint(context, mid1.x, mid1.y);
    
    // Use QuadCurve is the key
    CGContextAddQuadCurveToPoint(context, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y);
    
    CGContextSetLineCap(context, kCGLineCapRound);

    
    // color of stroke
    if([self.ColorSegment selectedSegmentIndex] == Red_Color)
    {
        CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    }
    else if([self.ColorSegment selectedSegmentIndex] == Green_Color)
    {
        CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 1.0);
    }
    else if ([self.ColorSegment selectedSegmentIndex] == Blue_Color)
    {
        CGContextSetRGBStrokeColor(context, 0.0, 0.0, 1.0, 1.0);
    }
    

    //size of stroke
    if([self.StrokeSegment selectedSegmentIndex] == small_size)
    {
        CGContextSetLineWidth(context, 2.0);
    }
    else if ([self.StrokeSegment selectedSegmentIndex] == middle_size)
    {
        CGContextSetLineWidth(context, 5.0);
    }
    else if ([self.StrokeSegment selectedSegmentIndex] == large_size)
    {
        CGContextSetLineWidth(context, 10.0);
    }

    
    
    
    CGContextStrokePath(context);
    
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}


@end
