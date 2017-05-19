//
//  ConverterViewController.m
//  Convertor
//
//  Created by Artem Zabludovsky on 15.05.17.
//  Copyright © 2017 Artem Zabludovsky. All rights reserved.
//

#import "ConverterViewController.h"
#import "Calc.h"
#import "ChangeCurrenciesViewController.h"

#define DOT @"."//symbol on dot button on calc keybord
#define DEL @"C"//symbol on delete button on calc keybord
#define USD @"USD"//3-symbol name of US dollar currency
#define RUB @"RUB"//3-symbol name of RF rubbles currency
#define ANIMATION_DURATION_OF_SHOWING_CHILDVC 0.5 //time of animation in sec
#define ANIMATION_DURATION_OF_DELETING 0.3 //time of animation in sec

@interface ConverterViewController ()

@property (weak, nonatomic) IBOutlet UILabel *inputNumberLabel; //label of number which need to convert
@property (weak, nonatomic) IBOutlet UILabel *targetNumberLabel;//label of number which have been converted to target currency

@property (weak, nonatomic) IBOutlet UIButton *baseButton;//button to change currency of input number
@property (weak, nonatomic) IBOutlet UIButton *neededButton;//button to change currency of output number

@property (weak, nonatomic) IBOutlet UIView *container;//containerView with childVC(changeVC)

@property (nonatomic, strong) ChangeCurrenciesViewController *changeVC;//(childVC) presenting view to changing currencies value
@property (strong, readonly)Calc *calc;//translate one currency in another


@end

@implementation ConverterViewController
@synthesize baseCurrency;
@synthesize neededCurrency;

- (void)viewDidLoad {
    [super viewDidLoad];
    //defaults values of currency
    self.baseCurrency = USD;
    self.neededCurrency = RUB;
    
    //init childVC
    [self changeVC];
    //set childVC is invisible
    self.container.alpha = 0;
    
    _calc = [[Calc alloc] init];
    
    [self updateView];
}
-(ChangeCurrenciesViewController *)changeVC{
    if (_changeVC == nil) {
        //take reference of childVC which has been init with storybord
        _changeVC = [self.childViewControllers lastObject];
        _changeVC.CVC = self;
    }
    return _changeVC;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//swapping of input currency and target currency
//input param:
//              button of swapping currency
- (IBAction)changePlacesOfCurreciece:(id)sender {
    NSString *base = baseCurrency;
    baseCurrency=neededCurrency;
    neededCurrency=base;
    [self updateView];
}

//calc keybord button pressed
//input param:
//              button of calc keybord
- (IBAction)keyPressed:(UIButton *)sender {
    //title of a button = symbol which need to write
    NSString *btnMessage = sender.titleLabel.text;
    if ([btnMessage isEqualToString:DEL]) {
        //delete input number to 0
        [self.inputNumberLabel setText:@"0"];
        [self updateOutputLbl];
    }
    else {
        [self handleInput:btnMessage];
    }
    [self updateView];
}

//handle input symbol, write it to input lable
//input param:
//              NSString symbol which need to handle
-(void)handleInput:(NSString *)key{
    NSString *lblText = [self.inputNumberLabel text];
    //if current input text in lable is 0, we must:
    //      1)if new symbol is dot - simple write dot
    //      2)if new symbol isnt dot - delete 0 and write symbol
    if ([lblText isEqualToString:@"0"]) {
        if (![key isEqualToString:DOT]) {
            self.inputNumberLabel.text = key;
        }
        else{
            self.inputNumberLabel.text=[lblText stringByAppendingString:key];
        }
    }else{
        //if current input text in lable has dot we must:
        //      1)if new symbol is dot - dont write new dot
        //      2)if new symbol isnt dot - write symbol
        NSRange range = [lblText rangeOfString:DOT];
        if (([key isEqualToString:DOT])&&(range.length>0)) {
            // cant to write dot because its already is
        }
        else{
            self.inputNumberLabel.text=[lblText stringByAppendingString:key];
        }
    }
    [self updateOutputLbl];
}

//function which tranclate input number into target currency and write it to outputLabel
-(void)updateOutputLbl{
    NSString *inputText = [[self inputNumberLabel]text];
    NSNumber *inputNumber = [NSNumber numberWithDouble: [inputText doubleValue]];
    
    //formater need to write number with only to symbols after dot
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    NSNumber *outputNumber = [[self calc] calculate:inputNumber];

    self.targetNumberLabel.text = [fmt stringFromNumber:outputNumber];

}

//this function called by button which change input number currency
//function is showing chaldVC which provider choose of new currency
- (IBAction)changeBaseCurrence:(id)sender {
    //set which currency is changing
    self.changeVC.isNeeded=NO;
    self.changeVC.isBase=YES;
    
    //current value of currency which need to change
    self.changeVC.currentCurrence=[self baseCurrency];
    
    [self.changeVC updateView];
    [self showChildVC];
}
//this function called by button which change target currency
//function is showing chaldVC which provider choose of new currency
- (IBAction)changeNedeedCurrence:(id)sender {
    //set which currency is changing
    self.changeVC.isNeeded=YES;
    self.changeVC.isBase=NO;
    
    //current value of currency which need to change
    self.changeVC.currentCurrence=[self neededCurrency];
    
    [self.changeVC updateView];
    [self showChildVC];
}

//showing childVC:
//      1)is simple change its alpha
//      2)set all view(not including conteinerView(with childVC)) alpha to 0.3  - make "blur" effect
//      3)set gesture
//change it with animation
-(void)showChildVC{
    //is simple change its alpha
    [UIView animateWithDuration:ANIMATION_DURATION_OF_SHOWING_CHILDVC animations:^() {
        self.container.alpha = 1;
    }];
    //set all view(not including conteinerView(with childVC)) alpha to 0.3  - make "blur" effect
    for (UIView *v in self.view.subviews)
    {
        if (![v isEqual:[self container]]) {
            [UIView animateWithDuration:ANIMATION_DURATION_OF_DELETING animations:^() {
                [v setAlpha:0.3];
            }];
        }
    }
    //set gesture
    //tapGesture for disappearing of childVC when did tap
    //on space which is not belongs to childVC
    UIGestureRecognizer *gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteChildVC:)];
    [self.view addGestureRecognizer:gest];
}

//fuct init by tap gesture which has been inited in showChildVC
-(void)deleteChildVC:(UITapGestureRecognizer *)recognizer{
    [self deleteChildVC];
}

//deleting VC:
//      1)change its alpha to 0
//      2)set all view(not including conteinerView(with childVC)) alpha to 1  - delete "blur" effect
//      3)delete gesture
//change it with animation
-(void)deleteChildVC{
    // change its alpha to 0
    [UIView animateWithDuration:ANIMATION_DURATION_OF_DELETING animations:^() {
        self.container.alpha = 0;
    }];
    //set all view(not including conteinerView(with childVC)) alpha to 1  - delete "blur" effect
    for (UIView *view in self.view.subviews)
    {
        if (![view isEqual:[self container]]) {
            [UIView animateWithDuration:ANIMATION_DURATION_OF_DELETING animations:^() {
                [view setAlpha:1];
            }];
        }
    }
    //delete gesture recognizer which has been inited in showChildVC
    [self.view removeGestureRecognizer:[[self.view gestureRecognizers]lastObject]];
}

//update all views which may change
//update currencies in Calc class
-(void)updateView{
    [self.neededButton setTitle:[self neededCurrency] forState:UIControlStateNormal];
    [self.baseButton setTitle:[self baseCurrency] forState:UIControlStateNormal];
    self.calc.baseCurr = [self baseCurrency];
    self.calc.neededCurr = [self neededCurrency];
    [self updateOutputLbl];
    [self deleteChildVC];
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
