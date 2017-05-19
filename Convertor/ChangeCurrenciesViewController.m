//
//  ChangeCurrenciesViewController.m
//  Converter
//
//  Created by Artem Zabludovsky on 17.05.17.
//  Copyright © 2017 Artem Zabludovsky. All rights reserved.
//

#import "ChangeCurrenciesViewController.h"
#import "CurrenciesTVC.h"

@interface ChangeCurrenciesViewController ()
@property (weak, nonatomic) IBOutlet UIButton *currentCurrencyButton;//button with current name of changing currency
@property (weak, nonatomic) IBOutlet UIButton *fastCurrOne;//first fast access button to most used currency
@property (weak, nonatomic) IBOutlet UIButton *fastCurrTwo;//second fast access button to most used currency
                                                //this buttons are needed to set nonreapeatable currencies

@end

@implementation ChangeCurrenciesViewController
@synthesize CVC;
@synthesize currentCurrence;
@synthesize isBase;
@synthesize isNeeded;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//update current view
-(void)updateView{
    //set standart values of fast acccess buttons
    [self.fastCurrOne setTitle:@"RUB" forState:UIControlStateNormal];
    [self.fastCurrTwo setTitle:@"USD" forState:UIControlStateNormal];
    
    //set currentcurrency to currentbutton
    [self.currentCurrencyButton setTitle:currentCurrence forState:UIControlStateNormal];
    
    //make this 3 button to nonreapeatable
    [self changeReapeatedFastCurrOnButton:self.fastCurrOne];
    [self changeReapeatedFastCurrOnButton:self.fastCurrTwo];
}

//change fast access button to make 3 non-reapeating buttons
//
//param:
//      fast access button
//
//if this button is similar to another - set this button how EUR
-(void)changeReapeatedFastCurrOnButton:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:self.currentCurrence]) {
        [btn setTitle:@"EUR" forState:UIControlStateNormal];
    }
}

//this fuct init by fast access buttons
//
//param:
//       button with selected currency
//
//fuct setted this selected currency to mainVC - CVC
- (IBAction)setFastCurrence:(id)sender {
    if (isNeeded) {
        self.CVC.neededCurrency=[[sender titleLabel]text];
    }
    if (isBase) {
        self.CVC.baseCurrency=[[sender titleLabel]text];
    }
    [self.CVC updateView];
}

//this fuct init by button which show list of other currencies
//
//
//fuct setupping and show CurrenciesTVC
- (IBAction)setOtherCurrence:(id)sender {
    CurrenciesTVC *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"listOfCurr"];
    tvc.CVC=[self CVC];
    tvc.isBase=isBase;
    tvc.isNeeded=isNeeded;
    
    //we need navContr to set searchbar in it, and also to solve problem with transparent statusbar
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tvc];
    [self presentViewController:navController animated:YES completion:^{[self.CVC updateView];}];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
