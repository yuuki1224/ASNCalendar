//
//  ASNDayView.m
//  ASNCalendarDemo
//
//  Created by AsanoYuki on 2014/07/09.
//  Copyright (c) 2014年 AsanoYuki. All rights reserved.
//

#import "ASNDayView.h"

@interface ASNDayView ()
{
    NSDate *_date;
    ASNDayTense _tense;
    
    UILabel *_dayLabel;
    UITapGestureRecognizer *_recognizer;
}

@end

@implementation ASNDayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _dayLabel = [[UILabel alloc] init];
        [self addSubview:_dayLabel];
        
        self.userInteractionEnabled = YES;
        
        _recognizer = [[UITapGestureRecognizer alloc] init];
        [_recognizer addTarget:self action:@selector(tappedDayView:)];
        [self addGestureRecognizer:_recognizer];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [self removeGestureRecognizer:_recognizer];
}

#pragma mark - Accessor

@dynamic date;

- (NSDate *)date
{
    return _date;
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    _dayLabel.text = [formatter stringFromDate:date];
}

@dynamic tense;

- (ASNDayTense)tense
{
    return _tense;
}

- (void)setTense:(ASNDayTense)tense
{
    _tense = tense;
    
    switch (_tense) {
        case ASNDayTensePreviousMonthDay:
        case ASNDayTenseNextMonthDay:
            _dayLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:17];
            _dayLabel.textColor = [UIColor colorWithRed:0.478 green:0.467 blue:0.478 alpha:1.0];
            [_dayLabel sizeToFit];
            CGFloat dayViewWidth = CGRectGetWidth(self.frame);
            CGFloat dayViewHeight = CGRectGetHeight(self.frame);
            CGFloat dayLabelWidth = CGRectGetWidth(_dayLabel.frame);
            CGFloat dayLabelHeight = CGRectGetHeight(_dayLabel.frame);
            _dayLabel.frame = CGRectMake((dayViewWidth - dayLabelWidth) / 2, (dayViewHeight - dayLabelHeight) / 2, dayLabelWidth, dayLabelHeight);
            
            self.backgroundColor = [UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1.0];
            break;
        case ASNDayTenseCurrentMonthDay:
            _dayLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12];
            _dayLabel.textColor = [UIColor colorWithRed:0.690 green:0.690 blue:0.690 alpha:1.0];
            [_dayLabel sizeToFit];
            _dayLabel.frame = CGRectMake(0, 2, CGRectGetWidth(_dayLabel.frame), CGRectGetHeight(_dayLabel.frame));
            
            self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
            break;
    }
}

#pragma mark - UITapGestureRecognizer

- (void)tappedDayView:(UITapGestureRecognizer *)sender
{
    [self.delegate didSelectedDay:self];
}

@end
