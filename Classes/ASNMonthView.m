//
//  ASNMonthView.m
//  ASNCalendarDemo
//
//  Created by AsanoYuki on 2014/07/09.
//  Copyright (c) 2014年 AsanoYuki. All rights reserved.
//

#import "ASNMonthView.h"
#import "ASNDayView.h"

static NSInteger const kMonthDayViewNumber = 42;

@interface ASNMonthView ()
{
    NSCalendar *_calendar;
    NSDateComponents *_monthComponents;
    
    NSMutableArray *_dayViews;
    
    NSArray *_previousMonthDays;
    NSArray *_currentMonthDays;
    NSArray *_nextMonthDays;
}

@end

@implementation ASNMonthView

- (void)awakeFromNib
{
    _dayViews = [NSMutableArray new];
    
    _previousMonthDays = [NSArray new];
    _currentMonthDays  = [NSArray new];
    _nextMonthDays     = [NSArray new];
    
    _calendar = [NSCalendar currentCalendar];
    [_calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    for (int i=0; i < kMonthDayViewNumber; i++) {
        NSInteger col = i % 7;
        NSInteger row = i / 7;
        ASNDayView *dayView = [[ASNDayView alloc] initWithFrame:CGRectMake(col * (44 + 2), 26 + row * (40 + 2), 44, 40)];
        dayView.delegate = self;
        [self addSubview:dayView];
        [_dayViews addObject:dayView];
    }
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

#pragma mark - Accessor

@dynamic monthComponents;

- (NSDateComponents *)monthComponents
{
    return _monthComponents;
}

- (void)setMonthComponents:(NSDateComponents *)monthComponents
{
    _monthComponents = monthComponents;
    
    _previousMonthDays = [self p_previousMonthDays:_monthComponents];
    _currentMonthDays = [self p_currentMonthDays:_monthComponents];
    _nextMonthDays = [self p_nextYearMonth:_monthComponents];
    
    __block NSInteger index = 0;
    [_previousMonthDays enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ASNDayView *previousDayView = [_dayViews objectAtIndex:index];
        previousDayView.date = (NSDate *)obj;
        previousDayView.tense = ASNDayTensePreviousMonthDay;
        index++;
    }];
    [_currentMonthDays enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ASNDayView *currentDayView = [_dayViews objectAtIndex:index];
        currentDayView.date = (NSDate *)obj;
        currentDayView.tense = ASNDayTenseCurrentMonthDay;
        index++;
    }];
    [_nextMonthDays enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ASNDayView *nextDayView = [_dayViews objectAtIndex:index];
        nextDayView.date = (NSDate *)obj;
        nextDayView.tense = ASNDayTenseNextMonthDay;
        index++;
    }];
}

#pragma mark - Private

// yearMonthを2014年7月まででいい.
- (NSArray *)p_previousMonthDays:(NSDateComponents *)monthComponents
{
    NSInteger previousMonthDaysCount = [self p_previoutMonthDaysCount:monthComponents];
    NSMutableArray *previousMonthDays = [NSMutableArray new];
    
    // 7月1日00:00とか月初めの0時になってるはず
    NSDate *firstDate = [monthComponents date];
    for (int i = (int)previousMonthDaysCount; i > 0; i--) {
        NSData *previousMonthDay = [firstDate dateByAddingTimeInterval:-3600 * 24 * i];
        [previousMonthDays addObject:previousMonthDay];
    }
    
    return [previousMonthDays copy];
}

- (NSArray *)p_currentMonthDays:(NSDateComponents *)monthComponents
{
    NSUInteger currentMonthDaysCount = [self p_currentMonthDaysCount:monthComponents];
    NSDate *firstDay = [monthComponents date];
    NSMutableArray *currentMonthDays = [NSMutableArray new];
    
    for (int i = 0; i < currentMonthDaysCount; i++) {
        NSDate *currentMonthDay = [firstDay dateByAddingTimeInterval:3600*24*i];
        [currentMonthDays addObject:currentMonthDay];
    }
    
    return [currentMonthDays copy];
}

- (NSArray *)p_nextYearMonth:(NSDateComponents *)monthComponents
{
    NSUInteger currentMonthDaysCount = [self p_currentMonthDaysCount:monthComponents];
    NSUInteger nextMonthDaysCount = [self p_nextMonthDaysCount:monthComponents];
    
    NSDate *nextMonthFirstDay = [[monthComponents date] dateByAddingTimeInterval:24*3600*currentMonthDaysCount];
    NSMutableArray *nextMonthDays = [NSMutableArray new];
    
    for (int i = 0; i < nextMonthDaysCount; i++) {
        NSDate *nextMonthDay = [nextMonthFirstDay dateByAddingTimeInterval:3600*24*i];
        [nextMonthDays addObject:nextMonthDay];
    }
    
    return [nextMonthDays copy];
}

// yearMonthを元に表示する前の月の日の数を返す
- (NSUInteger)p_previoutMonthDaysCount:(NSDateComponents *)monthComponents
{
    NSDate *firstDate = [monthComponents date];
    NSDateComponents *firstDateComponents = [_calendar components:NSCalendarUnitWeekday fromDate:firstDate];
    
    NSUInteger previousMonthDaysNumber;
    if (firstDateComponents.weekday == 7) {
        previousMonthDaysNumber = 6;
    } else {
        previousMonthDaysNumber = firstDateComponents.weekday - 1;
    }
    
    return previousMonthDaysNumber;
}

// yaerMonthを元に表示する今の月の日の数を返す
- (NSUInteger)p_currentMonthDaysCount:(NSDateComponents *)monthComponents
{
    NSDate *firstDay = [monthComponents date];
    NSRange range = [_calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:firstDay];
    return range.length;
}

// yearMonthを元に表示する次の月の日の数を返す
- (NSUInteger)p_nextMonthDaysCount:(NSDateComponents *)monthComponents
{
    NSUInteger nextMonthDaysCount = kMonthDayViewNumber - [self p_previoutMonthDaysCount:monthComponents] - [self p_currentMonthDaysCount:monthComponents];
    
    return nextMonthDaysCount;
}

#pragma mark - ASNDayViewDelegate

- (void)didSelectedDay:(ASNDayView *)tappedDay
{
    [self.delegate month:self didSelectedDay:tappedDay];
}

@end
