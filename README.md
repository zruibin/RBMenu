# RBMenu

###参考：[kxmenu](https://github.com/kolyvan/kxmenu/)

###使用

```
NSArray *items = @[
     [RBMenuItem menuItem:@"1111" image:[UIImage imageNamed:@"rateDark"] hltImage:[UIImage imageNamed:@"rateLight"] titleAlignment:0],
     [RBMenuItem menuItem:@"22222222" image:[UIImage imageNamed:@"rateDark"] hltImage:nil titleAlignment:0],
     [RBMenuItem menuItem:@"433333" image:nil hltImage:nil titleAlignment:NSTextAlignmentCenter],
     [RBMenuItem menuItem:@"44444" image:[UIImage imageNamed:@"rateDark"] hltImage:[UIImage imageNamed:@"rateLight"] titleAlignment:0]
		];
    
[RBMenu showMenuInView:self.view 
    	fromRect:rect 
    	menuItems:items 
    	arrowDirection:arrowDirect];
    
    
[RBMenu makeOnTouchBlock:^(NSInteger touchIndex, NSString *touchTitle) {
    NSLog(@"index:%ld, title:%@", (long)touchIndex, touchTitle);
}];
```

###要求

iOS7.0及以上