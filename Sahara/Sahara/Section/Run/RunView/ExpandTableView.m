
//
//  ExpandTableView.m
//  Sahara
//
//  Created by huangcan on 15/12/21.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "ExpandTableView.h"
#import "FMDB_Help.h"

@implementation ExpandTableView


- (void)loadTableViewData {
    
    //数据加入这个里面就可以的
    NSMutableArray * arr = [NSMutableArray array];
    
    [_dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary * dic = [obj mutableCopy];
        [dic setObject:@"MainCell" forKey:@"Cell"];
        [dic setObject:@(NO) forKey:@"isAttached"];
        [arr addObject:dic];
    }];
    _dataArray = arr;
    self.delegate =self;
    self.dataSource =self;
    
    self.tableFooterView = [[UITableViewHeaderFooterView alloc] init];
    [self reloadData];
}

#pragma mark -- Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[_dataArray [indexPath. row ] objectForKey:@"Cell" ] isEqualToString : @"MainCell" ]) {
        return tableView.rowHeight;
    } else {
        return 36;
    }
}
// 添加每行显示的内容
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[ _dataArray[indexPath.row ]objectForKey:@"Cell" ]isEqualToString:@"MainCell" ]){
        
        static NSString *CellIdentifier = @"SongSaveCell";
        SongSaveCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            UINib * nib = [UINib nibWithNibName:@"SongSaveCell" bundle:[NSBundle mainBundle]];
            [tableView registerNib:nib forCellReuseIdentifier:@"SongSaveCell"];
            cell        = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
        cell.cellNumLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
        //每行数据
        [cell loadCellData:_dataArray[indexPath.row]];
        
        //下拉加载工具栏
//        UIButton * btn = [cell viewWithTag:1000];
//        objc_setAssociatedObject(btn,"indexPath",indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        return cell;
    } else if ([[_dataArray[indexPath.row ]objectForKey:@"Cell"] isEqualToString:@"AttachedCell"]){
        
        static NSString *CellIdentifier = @"SongToolCell" ;
        SongToolCell *cell = [tableView dequeueReusableCellWithIdentifier :CellIdentifier];
        if (cell == nil ) {
            UINib * nib = [UINib nibWithNibName:@"SongToolCell" bundle:[NSBundle mainBundle]];
            [tableView registerNib:nib forCellReuseIdentifier:@"SongToolCell"];
            cell        = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        cell.delegate = self;
        cell.songId = _dataArray[indexPath.row][@"songId"];
        [cell loadCellDic:_dataArray[indexPath.row]];
        
        objc_setAssociatedObject(cell.collectionBtn,"indexPath",indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        return cell;
    }
    return nil;
}

#pragma mark -- Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSIndexPath *path = nil;
    
    if ([[_dataArray[indexPath.row] objectForKey:@"Cell" ] isEqualToString : @"MainCell" ]) {
        
        path = [NSIndexPath indexPathForItem:(indexPath.row + 1) inSection:indexPath.section];
    } else {
        
        path = indexPath;
    }
    
    if ([[_dataArray [indexPath. row ] objectForKey : @"isAttached" ] boolValue ]) {
        
        // 关闭附加 cell
        _dataArray [(path. row - 1)][@"isAttached"] = @( NO );
        [_dataArray removeObjectAtIndex :path. row ];
        [self beginUpdates ];
        [self deleteRowsAtIndexPaths: @[path] withRowAnimation: UITableViewRowAnimationMiddle];
        [self endUpdates];
        
    } else {
        
        // 打开附加 cell
        _dataArray[(path. row - 1)][@"isAttached"] = @( YES );
        NSDictionary * addDic = @{ @"Cell" : @"AttachedCell" ,
                                   @"isAttached" :@( YES ),
                                   @"songId":_dataArray[indexPath.row][@"musicId"],
                                   @"like":_dataArray[indexPath.row][@"like"]} ;
        [_dataArray insertObject:addDic atIndex:path.row ];
        [self beginUpdates ];
        [self insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationMiddle];
        [self endUpdates];
    }
    
    SongSaveCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.stateBtn.selected = [_dataArray[indexPath.row][@"isAttached"] boolValue];
}


#pragma mark  -- SongSaveCellDelegate SongToolCellDelegate

- (void)toolCellCollection:(UIButton *)sender {
    
    NSIndexPath * indexPath = objc_getAssociatedObject(sender,"indexPath");
    
    NSString * select = [NSString stringWithFormat:@"%hhd",(char)sender.selected];
    NSMutableDictionary * dic  = [_dataArray[indexPath.row - 1] mutableCopy];
    [dic setObject:select forKey:@"like"];
    [_dataArray replaceObjectAtIndex:indexPath.row - 1 withObject:dic];
}

/*
- (void)insertRowDelegate:(UIButton *)sender {
    NSIndexPath * indexPath = objc_getAssociatedObject(sender,"indexPath");
    NSIndexPath *path = nil;
    
    if ([[_dataArray[indexPath.row] objectForKey:@"Cell" ] isEqualToString : @"MainCell" ]) {
        
        path = [NSIndexPath indexPathForItem:(indexPath.row + 1) inSection:indexPath.section];
    } else {
        path = indexPath;
    }
    
    if ([[_dataArray [indexPath. row ] objectForKey : @"isAttached" ] boolValue ]) {
        // 关闭附加 cell
        NSDictionary * dic = @{ @"Cell" : @"MainCell" , @"isAttached" : @( NO )} ;
        _dataArray [(path. row - 1)] = dic;
        [_dataArray removeObjectAtIndex :path. row ];
        [self beginUpdates ];
        [self deleteRowsAtIndexPaths: @[path] withRowAnimation: UITableViewRowAnimationMiddle];
        [self endUpdates];
        
        sender.selected = NO;
    } else {
        // 打开附加 cell
        NSDictionary * dic = @{ @"Cell" : @"MainCell" , @"isAttached" : @( YES )} ;
        _dataArray[(path. row - 1)] = dic;
        NSDictionary * addDic = @{ @"Cell" : @"AttachedCell" , @"isAttached" : @( YES )} ;
        [_dataArray insertObject:addDic atIndex:path.row ];
        [self beginUpdates ];
        [self insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationMiddle];
        [self endUpdates];

        sender.selected = YES;
    }
}
*/

@end
