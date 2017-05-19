//
//  Calc.h
//  Converter
//
//  Created by Artem Zabludovsky on 15.05.17.
//  Copyright © 2017 Artem Zabludovsky. All rights reserved.
//

#import <Foundation/Foundation.h>


//Doc for Calc class
//
//Target of this class is translate inputNumber of baseCurr currency into
//     number of neededCurr currency

//input params:
//              baseCurr - NSString of 3 letter of currency of inputNumber (RUB - example)
//              neededCurr - NSString of 3 letter of needed currency (RUB - example)
//
//output params:
//              NSNumber - number of needed currency

@interface Calc : NSObject

@property (strong, nonatomic) NSString *baseCurr;//currency of inputNumber
@property (strong, nonatomic) NSString *neededCurr;//needed currency
@property (strong, nonatomic, readonly)NSDictionary *dictOfRates;//dict of exchange rate for USD currency

//tranclate number of certain currancy in target currency

//input param:
//              inputNumber - NSNumber of number of baseCurr currency
//outout params:
//              NSNumber - number of needed currency
-(NSNumber *)calculate:(NSNumber *) inputNumber;

@end
