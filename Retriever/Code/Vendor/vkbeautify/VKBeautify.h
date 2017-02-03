//
//  VKBeautify.h
//  Retriever
//
//  Created by cyan on 2/3/17.
//  Copyright © 2017 cyan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, VKBeautifySourceType) {
    VKBeautifySourceTypeJSON,
    VKBeautifySourceTypeXML
};

@interface VKBeautify : NSObject

+ (NSString *)beautified:(NSString *)code type:(VKBeautifySourceType)type;

@end
