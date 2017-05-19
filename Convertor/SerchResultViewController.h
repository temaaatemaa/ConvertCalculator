//
//  SerchResultViewController.h
//  Converter
//
//  Created by Artem Zabludovsky on 16.05.17.
//  Copyright © 2017 Artem Zabludovsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConverterViewController.h"

@interface SerchResultViewController : UITableViewController

@property ConverterViewController *CVC;
@property BOOL isBase;
@property BOOL isNeeded;

@end
