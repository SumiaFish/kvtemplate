//
//  KVTableViewAdapter.m
//  KVTableView
//
//  Created by kevin on 2020/5/12.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "KVTableViewAdapter.h"
#import "KVTableView.h"

@interface KVTableViewAdapter ()

@property (strong, nonatomic) NSArray *data;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) BOOL hasMore;
@property (assign, nonatomic) NSInteger rows;

@end

@implementation KVTableViewAdapter

@synthesize rows = _rows;

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.data = @[];
    self.page = 1;
    self.hasMore = NO;
}

- (void)updateWithData:(NSArray *)data page:(NSInteger)page hasMore:(BOOL)hasMore {
    self.data = data;
    if (hasMore) {
        self.page = page;
    }
    self.hasMore = hasMore;
}

- (NSInteger)getOffsetPageWithIsRefresh:(BOOL)isRefresh {
    if (isRefresh) {
        return 1;
    }
    return self.page+1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.renderCellBlock? self.renderCellBlock((KVTableView *)tableView, indexPath): UITableViewCell.new;
}

@end
