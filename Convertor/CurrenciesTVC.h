//
//  CurrenciesTVC.h
//  Converter
//
//  Created by Artem Zabludovsky on 15.05.17.
//  Copyright © 2017 Artem Zabludovsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangeCurrenciesViewController.h"

//Doc for CurrenciesTVC class
//
//Target of this class is show list of avalible currencies with fuction "search"

//input params:
//              isBase - BOOL - if changing currency is currency of input number set YES
//              isNeeded - BOOL - if changing currency is target currency set YES
//              ChangeCurrenciesViewController - reference to ChangeCurrenciesViewController(to set changed currency)
//
//output:
//              new currency name setted in ChangeCurrenciesViewController


@interface CurrenciesTVC : UITableViewController <UISearchControllerDelegate,UISearchResultsUpdating,UISearchBarDelegate>

@property ChangeCurrenciesViewController *changeVC;


@end
