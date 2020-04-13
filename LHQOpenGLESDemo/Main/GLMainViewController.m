//
//  GLMainViewController.m
//  LHQOpenGLESDemo
//
//  Created by Xhorse_iOS3 on 2020/4/9.
//  Copyright © 2020 LHQ. All rights reserved.
//

#import "GLMainViewController.h"
#import "OpenGLES_Class_1.h"
#import "OpenGLES_Class_2.h"

@interface GLMainViewController ()<UITableViewDataSource , UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSouce;

@end

@implementation GLMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    self.dataSouce = [NSMutableArray arrayWithObjects:@"OpenGLES_Class_1",@"OpenGLES_Class_2", nil];
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
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[NSString stringWithFormat:@"Storyboard_%ld",indexPath.row+1] bundle:nil];

    UIViewController *temp = (UIViewController *)[storyboard instantiateViewControllerWithIdentifier:[NSString stringWithFormat:@"OpenGLES_Class_%ld",indexPath.row+1]];
    [self.navigationController pushViewController:temp animated:YES];
     
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
