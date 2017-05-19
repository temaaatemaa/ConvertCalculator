//
//  CurrenciesTVC.m
//  Converter
//
//  Created by Artem Zabludovsky on 15.05.17.
//  Copyright © 2017 Artem Zabludovsky. All rights reserved.
//

#import "CurrenciesTVC.h"
#import "SerchResultViewController.h"

@interface CurrenciesTVC ()<UISearchResultsUpdating, UISearchControllerDelegate>

@property NSMutableArray *arrOfCurr;//full array of currencies like "XXX | xxxxxxxx"
@property NSMutableArray *result;//list of currencies which show in table view

@property (strong, nonatomic) UISearchController *searchController;//provided search in table view

@property BOOL isSearching;//YES when text is changing in search bar

@end

@implementation CurrenciesTVC
@synthesize CVC;
@synthesize isBase;
@synthesize isNeeded;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupPresentingData];
    [self setupSearchController];
    [self setupNavigationBar];
    
}

-(void)setupPresentingData{
    //get list from userdefaults
    NSUserDefaults *uD=[NSUserDefaults standardUserDefaults];
    NSDictionary *dictOfAvalibleCurrenciece = [uD objectForKey:@"listKey"];
    
    NSArray *arrOfKeys = [dictOfAvalibleCurrenciece allKeys];
    
    //get array of currenciec like "XXX | XXXXX XXXX XXXX" - "USD | United states dollar"
    self.arrOfCurr = [[NSMutableArray alloc]init];
    arrOfKeys = [arrOfKeys sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *key in arrOfKeys) {
        NSString *currencyShort = [NSString stringWithFormat:@"%@ | ",key];
        [self.arrOfCurr addObject:[currencyShort stringByAppendingString:[dictOfAvalibleCurrenciece objectForKey:key]]];
    }
    
    //now will be show all currencies without searchfilter
    self.result = [NSMutableArray arrayWithArray:self.arrOfCurr];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)setupSearchController{
    //self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);//if use search bar without navigBar
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.definesPresentationContext = YES;

}
-(void)setupNavigationBar{
    [self.navigationController setHidesBarsOnTap:NO];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:178.0/255.0
                                                                                green:219.0/255.0
                                                                                 blue:239.0/255.0 alpha:1]];
    //self.tableView.tableHeaderView = self.searchController.searchBar;//search bar under navigBar
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Back"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(goBack)];
    self.navigationItem.titleView = self.searchController.searchBar;//search bar in navigBar
}

//init with back button in navigbar
-(void)goBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //count of rows
    return [self.result count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(nil == cell){
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellID];
    }
    NSString *titleForCell = [self.result objectAtIndex:indexPath.row];
    cell.textLabel.text = titleForCell;
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //get short name of selected currency(first 3 symbols of string from result array)
    NSString *currencyShort = [[self.result objectAtIndex:indexPath.row] substringToIndex:3];
    [self setCurrencyInRootVC:currencyShort];
}

//param:
//       currencyShort - NSString - short name of selected currency
-(void)setCurrencyInRootVC:(NSString *)currencyShort{
    if (isNeeded) {
        self.CVC.neededCurrency = currencyShort;
        isNeeded = false;
    }
    if (isBase) {
        self.CVC.baseCurrency = currencyShort;
        isBase = false;
    }
    
    [self.CVC updateView];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self searchTableList];
    [self.tableView reloadData];
}


- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.searchController];
}

//filter for search string
- (void)searchTableList {
    if (self.searchController.searchBar.text.length>0)
    {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [cd] %@", self.searchController.searchBar.text];
    self.result = [NSMutableArray arrayWithArray:[self.arrOfCurr filteredArrayUsingPredicate:predicate]];
    }
    else
    {
        self.result = [NSMutableArray arrayWithArray:self.arrOfCurr];
    }

}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.isSearching = YES;
    
    //with this taprecogniser we resolve problem wich conclude in need to tap twice to select
    //  row in tableview when we search
    UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap:)];
    [self.view addGestureRecognizer:gest];
}

-(void)didTap:(UITapGestureRecognizer *)gest{
    //processing tap first
    [self.searchController.searchBar resignFirstResponder];
    
    //get cell was touched
    CGPoint touch = [gest locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:touch];
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    
    //selecting cell by touch
    [cell setSelected:YES animated:YES];
    
    //get short name of selected currency
    NSString *currencyShort = [[self.result objectAtIndex:indexPath.row] substringToIndex:3];
    
    //set new currency in mainviewcontroller
    
    [self setCurrencyInRootVC:currencyShort];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//called when search string did change
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //remove all objects first
    [self.result removeAllObjects];
    
    if([searchText length] != 0) {
        self.isSearching = YES;
        [self searchTableList];
    }
    else {
        self.isSearching = NO;
    }
}

//search is cancled
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //show all list of currencies
    self.result = [NSMutableArray arrayWithArray:self.arrOfCurr];
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //filter for seaarch text
    [self searchTableList];
    [self.tableView reloadData];
}

-(void)dealloc {
    [self.searchController.view removeFromSuperview]; // Bug with searchBar
    [self.view removeGestureRecognizer:[[self.view gestureRecognizers]lastObject]];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


