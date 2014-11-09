//
//  ALTWeatherViewController.m
//  WeatherForecast
//
//  Created by Alexey Titov on 08/11/14.
//  Copyright (c) 2014 Alexey Titov. All rights reserved.
//

#import "ALTWeatherViewController.h"
#import "ALTWeatherCell.h"
#import "ALTForecast.h"
#import "ALTWeatherLoader.h"

static NSString *const kCityID = @"918981"; //Dnepropetrovsk

@interface ALTWeatherViewController ()

@property (nonatomic, strong) NSArray *forecasts;
@property (nonatomic, strong) ALTWeatherLoader *loader;

@end

@implementation ALTWeatherViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        NSManagedObjectContext *context = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ForecastStore"];
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
        fetchRequest.sortDescriptors = @[sd];
        _forecasts = [context executeFetchRequest:fetchRequest error:nil];
        NSString *url = [NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w=%@&u=c", kCityID];
        _loader = [[ALTWeatherLoader alloc] initWithURLString:url];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Dnepropetrovsk Weather";
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    self.navigationItem.rightBarButtonItem = bbi;
    
    UINib *nib = [UINib nibWithNibName:@"ALTWeatherCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"ALTWeatherCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateTableViewForDynamicTypeSize];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self updateData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateTableViewForDynamicTypeSize
{
    [self.tableView setRowHeight:100];
    [self.tableView reloadData];
}

- (void)refresh
{
    [self updateData];
}

- (void)updateData
{
    [self.loader loadWithSuccessBlock:^(NSArray *forecasts) {
        self.forecasts = forecasts;
        [self clearCoreData];
        [self save];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        });
    }];
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)save
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    int order = 1;
    
    for (ALTForecast *forecast in self.forecasts) {
        NSManagedObject *newForecast = [NSEntityDescription insertNewObjectForEntityForName:@"ForecastStore" inManagedObjectContext:context];
        [newForecast setValue:forecast.day forKey:@"day"];
        [newForecast setValue:forecast.date forKey:@"date"];
        [newForecast setValue:forecast.low forKey:@"low"];
        [newForecast setValue:forecast.high forKey:@"high"];
        [newForecast setValue:forecast.text forKey:@"text"];
        [newForecast setValue:forecast.code forKey:@"code"];
        [newForecast setValue:[NSNumber numberWithInt:order] forKey:@"order"];
        order++;
    }
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

- (void)clearCoreData
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ForecastStore"];
    NSArray *fetchedObjects = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    for (NSManagedObject *currentObject in fetchedObjects) {
        [context deleteObject:currentObject];
    }
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.forecasts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALTWeatherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ALTWeatherCell" forIndexPath:indexPath];
    ALTForecast *forecast = self.forecasts[indexPath.row];
    NSString *imageName = [NSString stringWithFormat:@"%@.gif", forecast.code];
    cell.image.image = [UIImage imageNamed:imageName];
    cell.date.text = [NSString stringWithFormat:@"%@ %@", forecast.day, forecast.date];
    cell.text.text = forecast.text;
    cell.temp.text = [NSString stringWithFormat:@"%@ ... %@", forecast.low, forecast.high];
    return cell;
}

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

@end
