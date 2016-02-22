//
//  MyCollectionTableView.m
//  Sahara
//
//  Created by heng on 16/1/5.
//  Copyright © 2016年 bode. All rights reserved.
//

#import "MyCollectionTableView.h"
#import "SongingController.h"
#import "Track+Provider.h"

@implementation MyCollectionTableView

- (void)loadTableViewData {
    
    //数据加入这个里面就可以的
    NSMutableArray * arr = [NSMutableArray array];
    [_dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary * dic = [obj mutableCopy];
        [dic setObject:@"MainCell" forKey:@"Cell"];
        [dic setObject:@(NO) forKey:@"isAttached"];
        [dic setObject:@(idx) forKey:@"indexPath"];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
        
        static NSString *CellIdentifier = @"CollectionSaveCell";
        CollectionSaveCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            UINib * nib = [UINib nibWithNibName:@"CollectionSaveCell" bundle:[NSBundle mainBundle]];
            [tableView registerNib:nib forCellReuseIdentifier:@"CollectionSaveCell"];
            cell        = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        [cell.cellNumLabel setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row + 1] forState:UIControlStateNormal];
        cell.delegate =self;
        //每行数据
        [cell loadCellData:_dataArray[indexPath.row]];
        //下拉加载工具栏
        cell.stateBtn.tag = indexPath.row + 300;
//        objc_setAssociatedObject(btn,"indexPath",indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        return cell;
    } else if ([[_dataArray[indexPath.row ]objectForKey:@"Cell"] isEqualToString:@"AttachedCell"]){
        
        static NSString *CellIdentifier = @"CollectionToolCell" ;
        CollectionToolCell *cell = [tableView dequeueReusableCellWithIdentifier :CellIdentifier];
        if (cell == nil ) {
            UINib * nib = [UINib nibWithNibName:@"CollectionToolCell" bundle:[NSBundle mainBundle]];
            [tableView registerNib:nib forCellReuseIdentifier:@"CollectionToolCell"];
            cell        = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        cell.songId = _dataArray[indexPath.row][@"songId"];
        
        //下拉加载工具栏
        UIButton * btn = [cell viewWithTag:1000];
        objc_setAssociatedObject(btn,"indexPath",indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return cell;
    }
    return nil;
}

#pragma mark -- Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SongingController * songingVC = [[SongingController alloc]initWithNibName:@"SongingController" bundle:[NSBundle mainBundle]];
    //数据加入这个里面就可以的
    NSMutableArray * arr = [NSMutableArray array];
    [_dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary * dic = [obj mutableCopy];
        if ([[dic objectForKey:@"Cell" ]isEqualToString:@"MainCell" ]) {
            [arr addObject:obj];
        }
    }];
    
    if ([[_dataArray[indexPath.row] objectForKey:@"Cell" ] isEqualToString : @"MainCell" ]) {
        
        //歌曲
        songingVC.tracks = [Track remoteTracks:arr];
        songingVC.currentTrackIndex = [_dataArray[indexPath.row][@"indexPath"] integerValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[self myViewController].navigationController pushViewController:songingVC animated:YES];
        });
        
    }
    

    
//    NSIndexPath *path = nil;
//    
//    if ([[_dataArray[indexPath.row] objectForKey:@"Cell" ] isEqualToString : @"MainCell" ]) {
//        
//        path = [NSIndexPath indexPathForItem:(indexPath.row + 1) inSection:indexPath.section];
//        
//    } else {
//        path = indexPath;
//    }
//    
//    if ([[_dataArray [indexPath. row ] objectForKey : @"isAttached" ] boolValue ]) {
//        // 关闭附加 cell
//        //        NSDictionary * dic = @{ @"Cell" : @"MainCell" , @"isAttached" : @( NO )} ;
//        _dataArray [(path. row - 1)][@"isAttached"] = @( NO );
//        [_dataArray removeObjectAtIndex :path. row ];
//        [self beginUpdates ];
//        [self deleteRowsAtIndexPaths: @[path] withRowAnimation: UITableViewRowAnimationMiddle];
//        [self endUpdates];
//        
//    } else {
//        
//        // 打开附加 cell
//        //        NSDictionary * dic = @{ @"Cell" : @"MainCell" , @"isAttached" : @( YES )} ;
//        _dataArray[(path. row - 1)][@"isAttached"] = @( YES );
//        NSDictionary * addDic = @{ @"Cell" : @"AttachedCell" , @"isAttached" :@( YES ),@"songId":_dataArray[indexPath.row][@"ContentId"]} ;
//        [_dataArray insertObject:addDic atIndex:path.row ];
//        [self beginUpdates ];
//        [self insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationMiddle];
//        [self endUpdates];
//    }
//    
//    CollectionSaveCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.stateBtn.selected = [_dataArray[indexPath.row][@"isAttached"] boolValue];
}


- (void)insertRowDelegate:(UIButton *)sender {
//    NSIndexPath * indexPath = objc_getAssociatedObject(sender,"indexPath");
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:sender.tag - 300 inSection:0];
    
    NSIndexPath *path = nil;
    
    if ([[_dataArray[indexPath.row] objectForKey:@"Cell" ] isEqualToString : @"MainCell" ]) {
        
        path = [NSIndexPath indexPathForItem:(indexPath.row + 1) inSection:indexPath.section];
        
    } else {
        path = indexPath;
    }
    
    if ([[_dataArray [indexPath. row ] objectForKey : @"isAttached" ] boolValue ]) {
        // 关闭附加 cell
        
        _dataArray [(path. row - 1)][@"isAttached"] = @( NO );
        [_dataArray removeObjectAtIndex :path. row];
        [self beginUpdates ];
        [self deleteRowsAtIndexPaths: @[path] withRowAnimation: UITableViewRowAnimationMiddle];
        [self endUpdates];
        
    } else {
        
        // 打开附加 cell

        _dataArray[(path. row - 1)][@"isAttached"] = @( YES );
        NSDictionary * addDic = @{ @"Cell" : @"AttachedCell" ,
                                   @"isAttached" :@( YES ),
                                   @"songId":_dataArray[indexPath.row][@"ContentId"]} ;
        [_dataArray insertObject:addDic atIndex:path.row ];
        [self beginUpdates ];
        [self insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationMiddle];
        [self endUpdates];
    }
    
    
    sender.selected = [_dataArray[indexPath.row][@"isAttached"] boolValue];
    
    [self reloadData];
}

//获取父控制器
- (UIViewController*)myViewController {
    id target = self;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            return target;
        }
    }
    return nil;
}

@end
