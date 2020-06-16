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

@end

@implementation KVTableViewAdapter

@synthesize context = _context;
@synthesize tableView = _tableView;
@synthesize onRenderSectionsBlock = _onRenderSectionsBlock;
@synthesize onRenderRowsBlock = _onRenderRowsBlock;
@synthesize onRenderHeaderBlock = _onRenderHeaderBlock;
@synthesize onRenderCellBlock = _onRenderCellBlock;
@synthesize onRenderRowHeightBlock = _onRenderRowHeightBlock;
@synthesize onRenderHeaderHeightBlock = _onRenderHeaderHeightBlock;
@synthesize onSelecteItemBlock = _onSelecteItemBlock;

- (instancetype)init {
    return [[self.class alloc] initWithContext:nil];
}

- (instancetype)initWithContext:(id _Nullable)context {
    if (self = [super init]) {
        self.context = context;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.data = @[];
    self.page = 1;
    self.hasMore = NO;
}

- (void)update:(KVListAdapterInfo *)info {
    [self updateWithData:info.data page:info.page hasMore:info.hasMore];
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
    return _onRenderSectionsBlock ? _onRenderSectionsBlock(_tableView) : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _onRenderRowsBlock ? _onRenderRowsBlock(_tableView, section) : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _onRenderCellBlock ? _onRenderCellBlock(_tableView, indexPath) :UITableViewCell.new;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return _onRenderHeaderBlock? _onRenderHeaderBlock(_tableView, section): nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _onRenderRowHeightBlock ? _onRenderRowHeightBlock(_tableView, indexPath) : UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _onRenderHeaderHeightBlock? _onRenderHeaderHeightBlock(_tableView, section): 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _onSelecteItemBlock? _onSelecteItemBlock(_tableView, indexPath): nil;
}

@end
