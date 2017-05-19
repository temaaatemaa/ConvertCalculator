//
//  ChangeCurrenciesViewController.h
//  Converter
//
//  Created by Artem Zabludovsky on 17.05.17.
//  Copyright © 2017 Artem Zabludovsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConverterViewController.h"

//Doc for ChangeCurrenciesViewController class
//
//Target of this class is show little screen with choose
//     of most used currencies and button to show all list of ones

//input params:
//              isBase - BOOL - if changing currency is currency of input number set YES
//              isNeeded - BOOL - if changing currency is target currency set YES
//              currentCurrence - NSString - short 3-symbols  current name of currency which we want to change
//              CVC - reference to main view controller(to set changed currency)
//
//output:
//              new currency name setted in CVC

@interface ChangeCurrenciesViewController : UIViewController

@property  ConverterViewController *CVC;
@property NSString *currentCurrence;

@property BOOL isBase;
@property BOOL isNeeded;

-(void)updateView;

//fuct setted this selected currency to mainVC - CVC
//
//param:
//          NSString - currencyShortName - short name of new currency
-(void)setNewCurrencyInCVC:(NSString *)currencyShortName;

@end
