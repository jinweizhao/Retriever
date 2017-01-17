//
//  HOCodeView.h
//  HighlightObjC
//
//  Created by cyan on 30/12/2016.
//  Copyright © 2016 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HOCodeView : UITextView

- (void)render:(NSString *)code language:(NSString *)language;

@end
