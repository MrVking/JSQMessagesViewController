//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "JSQMessagesCellTextView.h"

@implementation JSQMessagesCellTextView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.textColor = [UIColor whiteColor];
    self.editable = NO;
    self.selectable = YES;
    self.userInteractionEnabled = YES;
    self.dataDetectorTypes = UIDataDetectorTypeNone;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.scrollEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    self.contentInset = UIEdgeInsetsZero;
    self.scrollIndicatorInsets = UIEdgeInsetsZero;
    self.contentOffset = CGPointZero;
    self.textContainerInset = UIEdgeInsetsZero;
    self.textContainer.lineFragmentPadding = 0;
    self.linkTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor],
                                 NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    self.layoutManager.delegate = self;
    
    self.textContainer.lineFragmentPadding = 0;
}

// TODO: Refactor custom code here to an SPMessagesCellTextView

- (void)setTextColor:(UIColor *)textColor {
    [super setTextColor:textColor];
    
    // force color of Marked as abusive to be set back to orange
    if ([self.text hasPrefix:NSLocalizedString(@"marked_as_abusive",)]) {
        [self setText:self.text];
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    if (text) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = self.font.pointSize * self.lineHeightFactor;
        NSDictionary *attrsDictionary = @{ NSFontAttributeName: self.font, NSParagraphStyleAttributeName: paragraphStyle};
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        
        
        if ([text hasPrefix:NSLocalizedString(@"marked_as_abusive",)]) {
            NSRange markAsAbusiveRange = NSMakeRange(0, NSLocalizedString(@"marked_as_abusive",).length);
            NSRange outsideRange = NSMakeRange(markAsAbusiveRange.length + 1, text.length - markAsAbusiveRange.length - 1);

            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:self.font.fontName size:10.0] range:markAsAbusiveRange];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:markAsAbusiveRange];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[self.textColor colorWithAlphaComponent:0.3] range:outsideRange];
            [attributedString addAttribute:NSFontAttributeName value:self.font range:outsideRange];
        }
        else {
            [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, text.length)];
        }
        
        self.attributedText = attributedString;
    }
}

- (void)setSelectedRange:(NSRange)selectedRange
{
    //  attempt to prevent selecting text
    [super setSelectedRange:NSMakeRange(NSNotFound, 0)];
}

- (NSRange)selectedRange
{
    //  attempt to prevent selecting text
    return NSMakeRange(NSNotFound, NSNotFound);
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //  ignore double-tap to prevent copy/define/etc. menu from showing
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer *tap = (UITapGestureRecognizer *)gestureRecognizer;
        if (tap.numberOfTapsRequired == 2) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //  ignore double-tap to prevent copy/define/etc. menu from showing
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer *tap = (UITapGestureRecognizer *)gestureRecognizer;
        if (tap.numberOfTapsRequired == 2) {
            return NO;
        }
    }
    
    return YES;
}

@end
