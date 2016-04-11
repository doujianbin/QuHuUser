//
//  GCPlaceholderTextView.m
//  HCC2014
//
//  Created by 窦建斌 on 14-7-11.
//  Copyright (c) 2014年 张修的Air. All rights reserved.
//

#import "GCPlaceholderTextView.h"

@interface GCPlaceholderTextView ()

@property (nonatomic, retain) UIColor* realTextColor;
@property (nonatomic, readonly) NSString* realText;

- (void) beginEditing:(NSNotification*) notification;
- (void) endEditing:(NSNotification*) notification;

@end

@implementation GCPlaceholderTextView

@synthesize realTextColor;
@synthesize placeholder;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.isUnderLine = NO;
        [self awakeFromNib];
        
        
    }
    return self;
}

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditing:) name:UITextViewTextDidEndEditingNotification object:self];
    
    self.realTextColor = [UIColor blackColor];
}

- (void)drawRect:(CGRect)rect {
	if (self.isUnderLine) {
        //Get the current drawing context
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //Set the line color and width
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.2f].CGColor);
        CGContextSetLineWidth(context, 1.0f);
        
        
        //Start a new Path
        CGContextBeginPath(context);
        
        //Find the number of lines in our textView + add a bit more height to draw lines in the empty part of the view
        NSUInteger numberOfLines = (self.contentSize.height + self.bounds.size.height) / self.font.leading;
        
        //Set the line offset from the baseline. (I'm sure there's a concrete way to calculate this.)
        CGFloat baselineOffset = 10.0f;
        
        //iterate over numberOfLines and draw each line
        for (int x = 1; x < numberOfLines; x++) {
            
            //0.5f offset lines up line with pixel boundary
            CGContextMoveToPoint(context, self.bounds.origin.x+10, self.font.leading*x + 0.5f + baselineOffset);
            CGContextAddLineToPoint(context, self.bounds.size.width-10, self.font.leading*x + 0.5f + baselineOffset);
        }
        
        //Close our Path and Stroke (draw) it
        CGContextClosePath(context);
        CGContextStrokePath(context);
    }
}

#pragma mark -
#pragma mark Setter/Getters

- (void) setPlaceholder:(NSString *)aPlaceholder {
    if ([self.realText isEqualToString:placeholder]) {
        self.text = aPlaceholder;
    }
    
    [placeholder release];
    placeholder = [aPlaceholder retain];
    
    [self endEditing:nil];
}

- (NSString *) text {
    NSString* text = [super text];
    if ([text isEqualToString:self.placeholder]) return @"";
    return text;
}

- (void) setText:(NSString *)text {
    if ([text isEqualToString:@""] || text == nil) {
        super.text = self.placeholder;
    }
    else {
        super.text = text;
    }
    
    if ([text isEqualToString:self.placeholder]) {
        self.textColor = [UIColor colorWithHexString:@"#c8c8ca"];
    }
    else {
        self.textColor = self.realTextColor;
    }
}

- (NSString *) realText {
    
    return [super text];
}

- (void) beginEditing:(NSNotification*) notification {
    if ([self.realText isEqualToString:self.placeholder]) {
        super.text = nil;
        self.textColor = self.realTextColor;
    }
}

- (void) endEditing:(NSNotification*) notification {
    if ([self.realText isEqualToString:@""] || self.realText == nil) {
        super.text = self.placeholder;
        self.textColor = [UIColor colorWithHexString:@"#c8c8ca"];
    }
}

- (void) setTextColor:(UIColor *)textColor {
    if ([self.realText isEqualToString:self.placeholder]) {
        if ([textColor isEqual:[UIColor colorWithHexString:@"#c8c8ca"]]) [super setTextColor:textColor];
        else self.realTextColor = textColor;
    }
    else {
        self.realTextColor = textColor;
        [super setTextColor:textColor];
    }
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    [realTextColor release];
    [placeholder release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end

