//
//  ExchangeAPI.h
//  Converter
//
//  Created by Artem Zabludovsky on 15.05.17.
//  Copyright © 2017 Artem Zabludovsky. All rights reserved.
//

#import <Foundation/Foundation.h>

//Doc for ExchangeAPI class
//
//Target of this class is downloading avalible list of currencies
//     and exchange rates for USD


@interface ExchangeAPI : NSObject<NSURLSessionDownloadDelegate>

//downloads avalible list of currencies and save it into NSUserDefaults
-(void)downloadListOfCurrencies;

//downloads exchange rates for USD and save it into NSUserDefaults
-(void)downloadRates;

@end
