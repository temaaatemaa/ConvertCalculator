//
//  Calc.m
//  Converter
//
//  Created by Artem Zabludovsky on 15.05.17.
//  Copyright © 2017 Artem Zabludovsky. All rights reserved.
//

#import "Calc.h"

#define KEY_FOR_RATES @"ratesKey" //obj for dict in NSUserDefaults

@implementation Calc
@synthesize neededCurr;
@synthesize baseCurr;
@synthesize dictOfRates;

//tranclate number of certain currancy in target currency

//input param:
//              inputNumber - NSNumber of number of baseCurr currency
//outout params:
//              NSNumber - number of needed currency
-(NSNumber *)calculate:(NSNumber *) inputNumber{
    [self setDictOfRates];
    
    
    if (self.dictOfRates) {
        NSNumber *rate = [self calcExchangeRate];
        return [NSNumber numberWithDouble:[rate doubleValue]*[inputNumber doubleValue]];
    }
    return @0;
}
-(void)setDictOfRates{
    if (!dictOfRates) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        dictOfRates = [userDefaults objectForKey:KEY_FOR_RATES];
    }
}

//We have exchange rates for USD, so we should calculate exchange rates for
//          preset currencies(baseCurr and neededCurr)

-(NSNumber *)calcExchangeRate{
    //take exchange rate from USD to baseCurr
    NSString *from;
    from = [self.dictOfRates objectForKey:self.baseCurr];
    
    //take exchange rate from USD to neededCurr
    NSString *to;
    to = [self.dictOfRates objectForKey:self.neededCurr];
    
    //calc rate (light formula)
    double rate = [to doubleValue]/[from doubleValue];
    
    return [NSNumber numberWithDouble:rate];
}
@end
