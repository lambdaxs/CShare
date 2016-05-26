//
//  XSTitleModel.m
//  CShare
//
//  Created by xiaos on 16/3/21.
//  Copyright © 2016年 com.xsdota. All rights reserved.
//

#import "XSTitleModel.h"

@implementation XSTitleModel

- (BOOL)isPraised {
    if ([self.praises containsObject:@"101"]) {
        return YES;
    }
    return NO;
}

- (NSNumber *)praisesNumber {
    return [NSNumber numberWithInteger:self.praises.count];
}

- (NSString *)commentStr {
    if ([self.comments isEqual:@0]) {
        return @"";
    }
    return [self.comments stringValue];
}

- (NSString *)praisesStr {
    if ([self.praisesNumber isEqual:@0]) {
        return @"";
    }
    return [self.praisesNumber stringValue];
}

@end
@implementation XSUserModel

@end


