//
//  IB_DESIGN_Label.m
//  differennt
//
//  Created by apple on 15/12/11.
//  Copyright © 2015年 bodecn. All rights reserved.
//

#import "IB_DESIGN_Label.h"

IB_DESIGNABLE

@implementation IB_DESIGN_Label

-(void)awakeFromNib{
    [super awakeFromNib];

}
- (void)setAttrString:(NSString *)AttrString {
    
    _AttrString         = AttrString;
    self.attributedText = [self attString:AttrString];
}
- (NSAttributedString *)attString:(NSString *)string {
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange contentRange               = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    return content;
}
@end
