//
//  ASNCalendar.m
//  ASNCalendarDemo
//
//  Created by AsanoYuki on 2014/07/09.
//  Copyright (c) 2014年 AsanoYuki. All rights reserved.
//

#import "ASNCalendar.h"
#import "ASNMonthView.h"

static NSInteger const kMonthViewNumber = 5;
static NSInteger const kCalendarOffsetPageNumber = 2;

static NSInteger const kScrollViewMarginY = 27;
static NSInteger const kScrollViewWidth = 320;
static NSInteger const kScrollViewHeight = 276;

@interface ASNCalendar ()
{
    NSCalendar *_calendar;
    
    UIScrollView *_scrollView;
    NSMutableArray *_monthViews;
    
    UILabel *_monthLabel;
}

@end

@implementation ASNCalendar

// width: 320 height: 345に指定されることを想定
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _monthViews = [NSMutableArray new];
        self.backgroundColor = [UIColor whiteColor];
        
        _calendar = [NSCalendar currentCalendar];
        [_calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        _monthLabel = [[UILabel alloc] init];
        _monthLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:17];
        _monthLabel.textColor = [UIColor blackColor];
        [self addSubview:_monthLabel];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kScrollViewMarginY, kScrollViewWidth, kScrollViewHeight)];
        _scrollView.contentSize = CGSizeMake(kMonthViewNumber * kScrollViewWidth, kScrollViewHeight);
        _scrollView.bounces = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentOffset = CGPointMake(kScrollViewWidth * kCalendarOffsetPageNumber, 0);
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        NSArray *initMonthComponents = [self p_initMonthComponents];
        NSBundle *mainBundle = [NSBundle mainBundle];
        for (int i=0; i < kMonthViewNumber; i++) {
            ASNMonthView *monthView = [[mainBundle loadNibNamed:@"ASNMonthView" owner:self options:nil] objectAtIndex:0];
            monthView.frame = CGRectMake(i*kScrollViewWidth, 0, kScrollViewWidth, kScrollViewHeight);
            monthView.monthComponents = initMonthComponents[i];
            monthView.delegate = self;
            [_scrollView addSubview:monthView];
            [_monthViews addObject:monthView];
        }
        
        NSDateComponents *visibleMonthComponents = initMonthComponents[kCalendarOffsetPageNumber];
        _monthLabel.text = [NSString stringWithFormat:@"%d年%d月", visibleMonthComponents.year, visibleMonthComponents.month];
        [_monthLabel sizeToFit];
        _monthLabel.frame = CGRectMake((kScrollViewWidth - CGRectGetWidth(_monthLabel.frame)) / 2, 6, CGRectGetWidth(_monthLabel.frame), CGRectGetHeight(_monthLabel.frame));
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

#pragma mark - Private

- (void)p_scrollToDirection:(NSInteger)moveDirection animated:(BOOL)animated
{
    CGRect adjustScrollRect = CGRectMake(_scrollView.contentOffset.x - _scrollView.frame.size.width * moveDirection, _scrollView.contentOffset.y, _scrollView.frame.size.width, _scrollView.frame.size.height);
    
    // 表示されてるクリップビューをcgrectにする.
    [_scrollView scrollRectToVisible:adjustScrollRect animated:animated];
}

- (NSArray *)p_initMonthComponents
{
    NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:9*3600];
    
    NSDateComponents *thirdComponents = [_calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday fromDate:now];
    [thirdComponents setCalendar:_calendar];
    
    NSDateComponents *secondComponents = [self p_previousMonthComponents:thirdComponents];
    NSDateComponents *firstComponents = [self p_previousMonthComponents:secondComponents];
    NSDateComponents *fourthComponents = [self p_nextMonthComponents:thirdComponents];
    NSDateComponents *fifthComponents = [self p_nextMonthComponents:fourthComponents];
    
    NSMutableArray *initMonthComponents = [NSMutableArray new];
    [initMonthComponents addObject:firstComponents];
    [initMonthComponents addObject:secondComponents];
    [initMonthComponents addObject:thirdComponents];
    [initMonthComponents addObject:fourthComponents];
    [initMonthComponents addObject:fifthComponents];
    
    return [initMonthComponents copy];
}

- (NSDateComponents *)p_previousMonthComponents:(NSDateComponents *)monthComponents
{
    NSDate *firstDate = [monthComponents date];
    NSDate *previousMonthLastDate = [firstDate dateByAddingTimeInterval:-3600*24];
    
    NSDateComponents *previousMonthComponents = [_calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday fromDate:previousMonthLastDate];
    [previousMonthComponents setCalendar:_calendar];
    return previousMonthComponents;
}

- (NSDateComponents *)p_nextMonthComponents:(NSDateComponents *)monthComponents
{
    NSDate *firstDate = [monthComponents date];
    NSDate *nextMonthDate = [firstDate dateByAddingTimeInterval:3600*24*31];
    
    NSDateComponents *nextMonthComponents = [_calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday fromDate:nextMonthDate];
    [nextMonthComponents setCalendar:_calendar];
    return nextMonthComponents;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int pageIndex = _scrollView.contentOffset.x / CGRectGetWidth(_scrollView.frame);
    int moveDirection = pageIndex - kCalendarOffsetPageNumber;
    
    switch (moveDirection) {
        case 0:
            break;
        case 1: {
            ASNMonthView* leftView = [_monthViews objectAtIndex:0];
            ASNMonthView* lastView = [_monthViews lastObject];
            
            leftView.monthComponents = [self p_nextMonthComponents:lastView.monthComponents];
            
            [_monthViews removeObjectAtIndex:0];
            [_monthViews insertObject:leftView atIndex:[_monthViews count]];
            pageIndex -= moveDirection;
            break;
        }
        case -1: {
            ASNMonthView *rightView = [_monthViews lastObject];
            ASNMonthView *firstView = [_monthViews objectAtIndex:0];
            
            rightView.monthComponents = [self p_previousMonthComponents:firstView.monthComponents];
            
            [_monthViews removeLastObject];
            [_monthViews insertObject:rightView atIndex:0];
            pageIndex -= moveDirection;
            break;
        }
        default:
            break;
    }
    
    ASNMonthView *visibleMonthView = (ASNMonthView *)_monthViews[kCalendarOffsetPageNumber];
    NSDateComponents *visibleMonthComponents = visibleMonthView.monthComponents;
    _monthLabel.text = [NSString stringWithFormat:@"%d年%d月", visibleMonthComponents.year, visibleMonthComponents.month];
    [_monthLabel sizeToFit];
    _monthLabel.frame = CGRectMake((kScrollViewWidth - CGRectGetWidth(_monthLabel.frame)) / 2, 6, CGRectGetWidth(_monthLabel.frame), CGRectGetHeight(_monthLabel.frame));
    
    NSInteger index = 0;
    for (UIView *pageView in _monthViews) {
        pageView.center = CGPointMake(index * CGRectGetWidth(_scrollView.frame) + CGRectGetWidth(_scrollView.frame) / 2, _scrollView.contentSize.height / 2);
        index++;
    }
    
    [self p_scrollToDirection:moveDirection animated:NO];
}

#pragma mark - ASNMonthViewDelegate

- (void)month:(ASNMonthView *)month didSelectedDay:(ASNDayView *)tappedDay
{
    [self.delegate calendar:self didSelectedDay:tappedDay];
}

@end
