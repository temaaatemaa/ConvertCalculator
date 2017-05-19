//
//  e.h
//  Convertor
//
//  Created by Artem Zabludovsky on 15.05.17.
//  Copyright © 2017 Artem Zabludovsky. All rights reserved.
//

#import <UIKit/UIKit.h>

//Doc for ConverterViewController class
//
//ViewController of Main screen

//              baseCurr - NSString of 3 letter of currency of inputNumber (RUB - example)
//              neededCurr - NSString of 3 letter of needed currency (RUB - example)

@interface ConverterViewController : UIViewController

@property (nonatomic,strong) NSString *baseCurrency;//NSString of 3 letter of currency of inputNumber (RUB - example)
@property (nonatomic,strong) NSString *neededCurrency;//neededCurr - NSString of 3 letter of needed currency (RUB - example)

//update view of screen
-(void)updateView;

@end
