//
//  GLMainViewController.m
//  LHQOpenGLESDemo
//
//  Created by Xhorse_iOS3 on 2020/4/9.
//  Copyright © 2020 LHQ. All rights reserved.
//

#import "GLMainViewController.h"
#import "OpenGLES_Class_1_1.h"
#import "OpenGLES_Class_1_2.h"
#import "OpenGLES_Class_2_1.h"

@interface GLMainViewController ()<UITableViewDataSource , UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSouce;

@end

@implementation GLMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    self.dataSouce = [NSMutableArray arrayWithObjects:
                      @"OpenGLES_Class_1_1",
                      @"OpenGLES_Class_1_2",
                      @"OpenGLES_Class_2_1",nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSouce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableView"];
    cell.textLabel.text = self.dataSouce[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    UIViewController *view;
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:self.dataSouce[indexPath.row] bundle:nil];
//    if (storyboard) {
//        view = (UIViewController *)[storyboard instantiateViewControllerWithIdentifier:self.dataSouce[indexPath.row]];
//    } else {
//        view = (UIViewController *)NSClassFromString(self.dataSouce[indexPath.row]);
//    }
//    UIViewController *temp = (UIViewController *)[storyboard instantiateViewControllerWithIdentifier:self.dataSouce[indexPath.row]];
     Class class = NSClassFromString(self.dataSouce[indexPath.row]);
    [self.navigationController pushViewController:[class new] animated:YES];
     
}

#pragma mark - Lazy Load

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableView"];
    }
    return _tableView;
}


@end
