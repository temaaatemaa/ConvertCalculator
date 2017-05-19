//
//  ExchangeAPI.m
//  Converter
//
//  Created by Artem Zabludovsky on 15.05.17.
//  Copyright © 2017 Artem Zabludovsky. All rights reserved.
//

#import "ExchangeAPI.h"

#define APP_ID @"56977989cdec4295a9a057ef9dffdfcc"//app id for api

#define KEY_FOR_LIST @"listKey"//this key is used to save list of currencies to NSUserDef for this key
#define KEY_FOR_RATES @"ratesKey"//this key is used to save exchange rates for usd to NSUserDef for this key

@implementation ExchangeAPI

//downloads avalible list of currencies and save it into NSUserDefaults
-(void)downloadListOfCurrencies{
    //url for avalible list of currencies
    NSString *urlOfList = @"https://openexchangerates.org/api/currencies.json";
    [self httpRequestWithURL:urlOfList];
}

//delegate for NSURLsession
//calls when data from url did download
- (void) URLSession:(NSURLSession *)session
       downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSData *data = [NSData dataWithContentsOfURL:location];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    NSString *urlString = [NSString stringWithFormat:@"%@",downloadTask.originalRequest.URL];
    
    //if respond is list of currencies - save in NSUserDef for key KEY_FOR_LIST
    //if respond is exchange rates - save in NSUserDef for key KEY_FOR_RATES
    if ([urlString hasSuffix:@"currencies.json"]) {
        [self saveInUserDefWithDict:dict forKey:KEY_FOR_LIST];
    }
    else{
        NSDictionary *dict_rates = [dict objectForKey:@"rates"];
        [self saveInUserDefWithDict:dict_rates forKey:KEY_FOR_RATES];
    }
}

//downloads exchange rates for USD and save it into NSUserDefaults
-(void)downloadRates{
    NSString *urlOfRates = @"https://openexchangerates.org/api/latest.json?app_id=";
    [self httpRequestWithURL:[urlOfRates stringByAppendingString:[NSString stringWithFormat:@"%@",APP_ID]]];
    
}

//make http request
//input param:
//              NSSTRING - URL
-(void)httpRequestWithURL:(NSString *)urlString{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:conf delegate:self delegateQueue:nil];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
    
    [task resume];
}

//save dict in NSUserdefaults
//
//param:
//          NSDictionary - dict - dictionary with data which we wont to save
//          NSString - key - save this data in NSUserDef for this key
-(void)saveInUserDefWithDict:(NSDictionary*)dict forKey:(NSString *)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dict forKey:key];
}
@end
