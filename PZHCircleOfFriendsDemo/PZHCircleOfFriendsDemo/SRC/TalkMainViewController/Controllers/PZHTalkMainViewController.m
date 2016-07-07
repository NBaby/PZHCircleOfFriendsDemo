//
//  MCTalkMainViewController.m
//  eCook
//
//  Created by apple on 15/12/9.
//
//

#import "PZHTalkMainViewController.h"
#import "MJRefresh.h"
#import "PZHTalkAboutMeCell.h"
#import "PZHTalkDataModel.h"
#import "MCTalkMainViewCell.h"
#import "PZHGrowingTextView.h"
#import "MCTlakLookMoreCell.h"
#import "MCTalkCommentCell.h"
@interface PZHTalkMainViewController ()<UITableViewDataSource,UITableViewDelegate,PZHGrowingTextViewDelegate,UIActionSheetDelegate>{
    NSMutableArray <PZHListItemModel *>* dataArray;
    NSString * lastTalkid;
    UIView * bottomTextView;
    PZHGrowingTextView * inputTextView;
    NSString * targetUserId;
    UIButton * navFavBtn;
    NSString * currentCommentId;
    float tableViewHeaderHeight ;
    BOOL needShowNewMessage;
    BOOL isDeleteMode;
    ///高度缓存
    NSMutableArray * listHeightCache;
    NSMutableArray * commentHeightCache;///二维数组
}

@end

@implementation PZHTalkMainViewController
#pragma mark   - lifeCycle


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildNav];
    if (self.type == TalkTypeNomal) {
        self.bottomConstraint.constant = 44;
    }
    else {
        self.bottomConstraint.constant = 0;
    }
    //初始化
    dataArray = [[NSMutableArray alloc]init];
    lastTalkid = @"0";
    //键盘高度监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    //监听登入登出信息
    if (self.type != TalkDetail) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(logout)
                                                     name:@"AccountDidLogoutNotification"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(talkReloadData)
                                                     name:@"AccountDidLoginNotification"
                                                   object:nil];
    }
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    if (self.type == TalkDetail) {
        self.mainTableView.backgroundColor = [UIColor whiteColor];
    }
    else{
        self.mainTableView.backgroundColor = [UIColor colorWithWhite:244.0 / 255.0 alpha:1];
    }
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    commentHeightCache = [[NSMutableArray alloc]init];
    listHeightCache = [[NSMutableArray alloc]init];
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(talkReloadData)];
    
    if (self.type != TalkDetail) {
        self.mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    }
    [self buildBottomTextView];
    self.mainTableView.backgroundColor = [UIColor whiteColor];
    [self loadData];
    
}
- (void)setNavigation{
    
}
- (void)dealloc{
    self.mainTableView.delegate = nil;
    self.mainTableView = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
//    tableHeaderView.frame = CGRectMake(0, 0, screenWidth, tableViewHeaderHeight);
    return [dataArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    PZHListItemModel * model  =  dataArray[section];
    if (self.type == TalkDetail) {
         return model.commentPoList.count + 1;
    }
    else{
        if (model.commentPoList.count >5) {
            return 7;
        }
         return model.commentPoList.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0){
        UILongPressGestureRecognizer * recognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(judgeIfCanDelete:)];
        MCTalkMainViewCell * cell = [tableView MCTalkMainViewCell];
        cell.fatherController = self;
        cell.tag = indexPath.section;
        [cell addGestureRecognizer:recognizer];
        return cell;
    }
    else {
        if((self.type == TalkTypeNomal || self.type == TalkTopic) && indexPath.row == 6){
            MCTlakLookMoreCell * cell = [tableView MCTlakLookMoreCell];
            [cell setInfo:dataArray[indexPath.section]];
            cell.fatherViewController = self;
            return cell;
        }
        MCTalkCommentCell * cell = [tableView MCTalkCommentCell];
        cell.fatherController = self;
        return cell;
        
    }

    
    return nil;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    PZHListItemModel * listModel = dataArray[indexPath.section];
    if (indexPath.row == 0) {
      [(MCTalkMainViewCell *)cell setInfo:dataArray[indexPath.section]];
        if (listModel.commentPoList.count == 0  ){
            ((MCTalkMainViewCell *)cell).line.hidden = NO;
        }
        else {
           ((MCTalkMainViewCell *)cell).line.hidden = YES;
        }
    }
    else{
        if((self.type == TalkTypeNomal || self.type == TalkTopic) && indexPath.row == 6){
            return;
        }
        TalkCommentModel * commentModel = listModel.commentPoList[indexPath.row -1];
        ((MCTalkCommentCell *)cell).type = self.type;
        [(MCTalkCommentCell *)cell setInfo:@{@"listModel":listModel,@"commentModel":commentModel}];
        if (listModel.commentPoList.count -1 != indexPath.row -1) {
            ((MCTalkCommentCell *)cell).line.hidden = YES;
            ((MCTalkCommentCell *)cell).bottomConstraint.constant = 0;
        }
        else {
             ((MCTalkCommentCell *)cell).line.hidden = NO;
            ((MCTalkCommentCell *)cell).bottomConstraint.constant = 21;
        }
    }
    
   
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [inputTextView resignFirstResponder];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    MSLog(@"%ld %ld",(long)indexPath.section,(long)indexPath.row);
    if((self.type == TalkTypeNomal || self.type == TalkTopic) && indexPath.row == 6){
        return 50;
    }
    if (indexPath.row == 0) {
        float height;
        if (indexPath.section +1 > listHeightCache.count  ) {
            MCTalkMainViewCell * cell = [tableView MCTalkMainViewCell];
             MSLog(@"%ld",(long)indexPath.section);
           height = [cell getHeightWidthInfo:dataArray[indexPath.section]] ;
            listHeightCache[indexPath.section] = @(height);
            return height;
        }
        else if ([listHeightCache[indexPath.section] isEqual:@(0)]){
            MCTalkMainViewCell * cell = [tableView MCTalkMainViewCell];
            
            height = [cell getHeightWidthInfo:dataArray[indexPath.section]] ;
            listHeightCache[indexPath.section] = @(height);
            return height;
        }
        else {
            return [listHeightCache[indexPath.section] floatValue];
        }
        
    }
    else {
      
        float height;
        MCTalkCommentCell * cell = [tableView MCTalkCommentCell];
        cell.type = self.type;
        NSMutableArray * tmpArray = [commentHeightCache validObjectAtIndex:indexPath.section];
        NSMutableArray * tmpArray2 = [tmpArray validObjectAtIndex:indexPath.row-1];
        
        PZHListItemModel * listModel = dataArray[indexPath.section];
        TalkCommentModel * commentModel = listModel.commentPoList[indexPath.row -1];
        
        if (tmpArray == nil || tmpArray2 == nil ) {
            height =  [(MCTalkCommentCell *)cell getHeightWidthInfo:@{@"listModel":listModel,@"commentModel":commentModel}];
            return height;

        }
        
            
        if ([commentHeightCache[indexPath.section][indexPath.row-1] isEqual:@(0)]) {
           
           
            
            if (listModel.commentPoList.count -1 != indexPath.row -1) {
                ((MCTalkCommentCell *)cell).line.hidden = YES;
                ((MCTalkCommentCell *)cell).bottomConstraint.constant = 0;
            }
            else {
                ((MCTalkCommentCell *)cell).line.hidden = NO;
                ((MCTalkCommentCell *)cell).bottomConstraint.constant = 21;
            }
            height =  [(MCTalkCommentCell *)cell getHeightWidthInfo:@{@"listModel":listModel,@"commentModel":commentModel}];
            commentHeightCache[indexPath.section][indexPath.row-1] = @(height);
            return height;
            
        }
        else {
            return [commentHeightCache[indexPath.section][indexPath.row -1] floatValue];
        }
    }
    return 0.1;
}
#pragma mark - MCTalkPhotoPicViewDelegate

- (void)showEditViewControllerWithAssets:(id)assetsFetchResults andSelectedArray:(NSMutableArray *)selectedArray{

}
- (void)getCameraPicImage:(UIImage *)image ImageId:(NSString *)imageid{

}
#pragma mark - PZHGrowingTextViewDelegate
- (void)didTextViewHeightChange:(NSInteger )height{
    
    [UIView animateWithDuration:0.1 animations:^{
        self.commentHeight.constant = height+18;
        [self.view layoutIfNeeded];
    }];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [inputTextView resignFirstResponder];
        
        [self sendComment:inputTextView.text];
        inputTextView.text = @"";
        return NO;
    }
    return YES;
}

#pragma mark - keyBoardObser
-(void)keyboardWillAppear:(NSNotification *)notification
{
    CGFloat curkeyBoardHeight = [[[notification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    CGRect begin = [[[notification userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect end = [[[notification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    // 第三方键盘回调三次问题，监听仅执行最后一次
    if(begin.size.height>0 && (begin.origin.y-end.origin.y>0)){
        float keyBoardHeight = curkeyBoardHeight;
        //        MSLog(@"%f",keyBoardHeight);
        self.commentTextView.hidden = NO;
        [UIView animateWithDuration:0.64 animations:^{
            self.commentBottomHeight.constant =keyBoardHeight;
            [self.view layoutIfNeeded];
        }];
    }
}
-(void)keyboardWillDisappear:(NSNotification *)notification
{
    self.commentTextView.hidden = YES;
    [UIView animateWithDuration:0.64 animations:^{
        self.commentBottomHeight.constant =0;
        [self.view layoutIfNeeded];
    }];
}
#pragma mark - event response
///与我相关
- (void)aboutMyself {

}
///点击进入选择照片界面
- (IBAction)addTalkBtn:(id)sender {

}
#pragma mark 点击了分享
- (void)share:(id)sender {

}
- (void)tapTitleFav:(UIButton *)sender{

}
#pragma mark - UIActionSheetDelegate


#pragma mark - netWork methods
#pragma mark 查看是否有新消息
#pragma mark 删除厨说

- (void)didDeleteTalk:(NSNotification *)notification{
    NSString * talkId = [notification.userInfo validObjectForKey:@"talkId"];
    NSInteger num = -1;
    for (int i = 0; i< [dataArray count]; i++) {
        PZHListItemModel * model = dataArray[i];
        if ([model.talkId isEqualToString:talkId]) {
            num = i;
            break;
        }
    }
    if (num != -1) {
        [dataArray removeObjectAtIndex:num];
        //清除缓存
        [listHeightCache removeObjectAtIndex:num];
        [commentHeightCache removeObjectAtIndex:num];
        [self.mainTableView deleteSections:[NSIndexSet indexSetWithIndex:num] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.mainTableView reloadData];

    }
}
- (void)loadData{
    [self.commentTextView resignFirstResponder];
    //模拟数据
    NSString * dataStr = @"{\"state\": \"200\",     \"list\": [         {             \"talkLikeWebPo\": {                 \"userList\": [],                 \"isLike\": \"0\",                 \"likenum\": \"1\"             },             \"contentId\": \"224195623\",             \"contentText\": \"\",             \"atuserids\": \"\",             \"userid\": \"26030887\",             \"contentName\": \"\",             \"displaytime\": \"刚刚\",             \"commentPoList\": [],             \"userimageid\": \"223374341\",             \"addtime\": \"2016-07-07 10:01:49.0\",             \"atUserList\": [],             \"id\": \"224195623\",             \"state\": 1,             \"text\": \"前几天太阳大就没有晒我家番薯，今天天气阴天都拿出来晒晒。。。。。\",             \"contentType\": \"normal\",             \"imageids\": \"224195608,224195612,224195619,224195621\",             \"splitText\": \"说\",             \"commentnum\": \"0\",             \"username\": \"皮园\"         },         {             \"talkLikeWebPo\": {                 \"userList\": [],                 \"isLike\": \"0\",                 \"likenum\": \"4\"             },             \"contentId\": \"224195577\",             \"contentText\": \"\",             \"atuserids\": \"\",             \"userid\": \"2809583\",             \"contentName\": \"\",             \"displaytime\": \"刚刚\",             \"commentPoList\": [],             \"userimageid\": \"2809584\",             \"addtime\": \"2016-07-07 09:59:23.0\",             \"atUserList\": [],             \"id\": \"224195577\",             \"state\": 1,             \"text\": \"好几天没做饭，三天来做的第一餐！\",             \"contentType\": \"normal\",             \"imageids\": \"224195567,224195568,224195570,224195571,224195575\",             \"splitText\": \"说\",             \"commentnum\": \"0\",             \"username\": \"·小家厨\"         },         {             \"talkLikeWebPo\": {                 \"userList\": [],                 \"isLike\": \"0\",                 \"likenum\": \"2\"             },             \"contentId\": \"224195543\",             \"contentText\": \"\",             \"atuserids\": \"\",             \"userid\": \"12095072\",             \"contentName\": \"\",             \"displaytime\": \"刚刚\",             \"commentPoList\": [],             \"userimageid\": \"11998015\",             \"addtime\": \"2016-07-07 09:58:13.0\",             \"atUserList\": [],             \"id\": \"224195543\",             \"state\": 1,             \"text\": \"吃早饭了\",             \"contentType\": \"normal\",             \"imageids\": \"224195541\",             \"splitText\": \"说\",             \"commentnum\": \"0\",             \"username\": \"雪儿\"         },         {             \"talkLikeWebPo\": {                 \"userList\": [],                 \"isLike\": \"0\",                 \"likenum\": \"6\"             },             \"contentId\": \"224195464\",             \"contentText\": \"\",             \"atuserids\": \"\",             \"userid\": \"32647341\",             \"contentName\": \"糖醋排骨\",             \"displaytime\": \"刚刚\",             \"commentPoList\": [                 {                     \"contentid\": \"224195464\",                     \"type\": \"recipe\",                     \"userid\": \"32647341\",                     \"targetusername\": \"\",                     \"targetuserid\": \"\",                     \"displaytime\": \"刚刚\",                     \"userimageid\": \"224195118\",                     \"addtime\": \"2016-07-07 09:57:58.0\",                     \"targetUserImageid\": \"\",                     \"id\": \"224195538\",                     \"text\": \"不错\",                     \"talkid\": \"224195525\",                     \"username\": \"弃泪〒_〒\"                 }             ],             \"userimageid\": \"224195118\",             \"addtime\": \"2016-07-07 09:57:47.0\",             \"atUserList\": [],             \"id\": \"224195525\",             \"state\": 1,             \"text\": \"#糖醋排骨#这个也是夏天必备单品西点\",             \"contentType\": \"homework\",             \"imageids\": \"224195523\",             \"splitText\": \"交了 作业\",             \"commentnum\": \"1\",             \"username\": \"弃泪〒_〒\"         },         {             \"talkLikeWebPo\": {                 \"userList\": [],                 \"isLike\": \"0\",                 \"likenum\": \"7\"             },             \"contentId\": \"224195496\",             \"contentText\": \"\",             \"atuserids\": \"\",             \"userid\": \"28911714\",             \"contentName\": \"\",             \"displaytime\": \"6分钟前\",             \"commentPoList\": [                 {                     \"contentid\": \"224195496\",                     \"type\": \"normal\",                     \"userid\": \"23509919\",                     \"targetusername\": \"\",                     \"targetuserid\": \"\",                     \"displaytime\": \"刚刚\",                     \"userimageid\": \"223994881\",                     \"addtime\": \"2016-07-07 09:58:24.0\",                     \"targetUserImageid\": \"\",                     \"id\": \"224195544\",                     \"text\": \"好极了\",                     \"talkid\": \"224195496\",                     \"username\": \"小女人\"                 }             ],             \"userimageid\": \"11998015\",             \"addtime\": \"2016-07-07 09:55:33.0\",             \"atUserList\": [],             \"id\": \"224195496\",             \"state\": 1,             \"text\": \"\",             \"contentType\": \"normal\",             \"imageids\": \"224195492,224195493\",             \"splitText\": \"说\",             \"commentnum\": \"1\",             \"username\": \"jessie\"         },         {             \"talkLikeWebPo\": {                 \"userList\": [],                 \"isLike\": \"0\",                 \"likenum\": \"11\"             },             \"contentId\": \"224195452\",             \"contentText\": \"\",             \"atuserids\": \"\",             \"userid\": \"29829553\",             \"contentName\": \"\",             \"displaytime\": \"9分钟前\",             \"commentPoList\": [                 {                     \"contentid\": \"224195452\",                     \"type\": \"normal\",                     \"userid\": \"7156300\",                     \"targetusername\": \"\",                     \"targetuserid\": \"\",                     \"displaytime\": \"刚刚\",                     \"userimageid\": \"7156301\",                     \"addtime\": \"2016-07-07 10:01:47.0\",                     \"targetUserImageid\": \"\",                     \"id\": \"224195615\",                     \"text\": \"真不错呢\",                     \"talkid\": \"224195452\",                     \"username\": \"窗边的小豆豆_qq_1413290191\"                 },                 {                     \"contentid\": \"224195452\",                     \"type\": \"normal\",                     \"userid\": \"2809583\",                     \"targetusername\": \"\",                     \"targetuserid\": \"\",                     \"displaytime\": \"刚刚\",                     \"userimageid\": \"2809584\",                     \"addtime\": \"2016-07-07 09:59:55.0\",                     \"targetUserImageid\": \"\",                     \"id\": \"224195581\",                     \"text\": \"油条怎么弄\",                     \"talkid\": \"224195452\",                     \"username\": \"·小家厨\"                 },                 {                     \"contentid\": \"224195452\",                     \"type\": \"normal\",                     \"userid\": \"7416037\",                     \"targetusername\": \"\",                     \"targetuserid\": \"\",                     \"displaytime\": \"刚刚\",                     \"userimageid\": \"8112226\",                     \"addtime\": \"2016-07-07 09:57:21.0\",                     \"targetUserImageid\": \"\",                     \"id\": \"224195522\",                     \"text\": \"好犀利\",                     \"talkid\": \"224195452\",                     \"username\": \"我系靓师奶\"                 }             ],             \"userimageid\": \"223728633\",             \"addtime\": \"2016-07-07 09:52:33.0\",             \"atUserList\": [],             \"id\": \"224195452\",             \"state\": 1,             \"text\": \"早餐早餐\",             \"contentType\": \"normal\",             \"imageids\": \"224195434,224195433,224195441,224195444,224195428,224195446,224195432,224195448,224195449\",             \"splitText\": \"说\",             \"commentnum\": \"3\",             \"username\": \"辰宝贝\"         },         {             \"talkLikeWebPo\": {                 \"userList\": [],                 \"isLike\": \"0\",                 \"likenum\": \"9\"             },             \"contentId\": \"24015395\",             \"contentText\": \"\",             \"atuserids\": \"\",             \"userid\": \"30130102\",             \"contentName\": \"藍莓芝士馬芬\",             \"displaytime\": \"14分钟前\",             \"commentPoList\": [],             \"userimageid\": \"224077831\",             \"addtime\": \"2016-07-07 09:48:06.0\",             \"atUserList\": [],             \"id\": \"224195382\",             \"state\": 1,             \"text\": \"#藍莓芝士馬芬#因家人和朋友喜歡吃，今天又做了，不過今天的加了巧克力粒！\",             \"contentType\": \"homework\",             \"imageids\": \"224195359,224195350,224195352,224195379\",             \"splitText\": \"交了 作业\",             \"commentnum\": \"0\",             \"username\": \"艾曦晨\"         },         {             \"talkLikeWebPo\": {                 \"userList\": [],                 \"isLike\": \"0\",                 \"likenum\": \"10\"             },             \"contentId\": \"224195346\",             \"contentText\": \"\",             \"atuserids\": \"\",             \"userid\": \"7268301\",             \"contentName\": \"\",             \"displaytime\": \"14分钟前\",             \"commentPoList\": [],             \"userimageid\": \"223805133\",             \"addtime\": \"2016-07-07 09:47:21.0\",             \"atUserList\": [],             \"id\": \"224195346\",             \"state\": 1,             \"text\": \"\",             \"contentType\": \"normal\",             \"imageids\": \"224195336,224195337,224195340,224195339\",             \"splitText\": \"说\",             \"commentnum\": \"0\",             \"username\": \"摩登平民\"         }     ],     \"message\": \"获取成功！\" }";
    
       NSData *jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
       NSError *err;
       NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    //将数据转模型
    PZHTalkDataModel * dataModel = [PZHTalkDataModel yy_modelWithJSON:dic];
    [dataArray addObjectsFromArray:dataModel.list];
    [_mainTableView reloadData];
    
  }

- (void)talkReloadData{
    
    lastTalkid = @"0";
    
    [self loadData];
    
}
///发送评论
- (void)sendComment:(NSString *)content{
//    if (content.length == 0 ){
//        [[MessageView getInstance]showMessage:@"评论内容不能为空"];
//        return ;
//    }
//    [[MCMessageView getInstance]showText:@"发送中..."];
//    
//    NSString * talkId = currentTalkListDataModel.talkId;
//    [HttpRequest talkSendCommentWithText:content talkId:talkId commentid:currentCommentId targetUserId:targetUserId type:nil andBlock:^(NSDictionary *result, NSError *error) {
//        [[MCMessageView getInstance]hide];
////        long rowNum = [dataArray indexOfObject:currentTalkListDataModel];
//        if (error == nil) {
//            if ([result[@"state"]isEqualToString:@"200"]) {
//                
//                [[MCMessageView getInstance]showMessage:result[@"message"]];
//                NSDictionary *jsonDic = result[@"obj"];
//                TalkCommentModel * model = [[TalkCommentModel alloc]initWithJSONDict:jsonDic];
//                NSMutableArray * tmpMArray = [[NSMutableArray alloc]initWithArray:currentTalkListDataModel.commentPoList];
//                [tmpMArray insertObject:model atIndex:0];
//                
//                NSInteger sessionNum = [dataArray indexOfObject:currentTalkListDataModel];
//                //增加缓存
//                [commentHeightCache[sessionNum] insertObject:@(0) atIndex:0];
//                
//                currentTalkListDataModel.commentPoList = [tmpMArray copy];
//                currentTalkListDataModel.commentnum = [NSString stringWithFormat:@"%lld",[currentTalkListDataModel.commentnum longLongValue]+1];
////                [self.mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:rowNum inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//                [self.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:sessionNum] withRowAnimation:UITableViewRowAnimationAutomatic];
//            }
//            else {
//                [[MCMessageView getInstance]showMessage:result[@"message"]];
//            }
//        }
//    }];
//    currentCommentId = nil;
    
    
}
/////点击了专辑或者菜谱
//- (void)tapCollectionOrRecipeWithModel:(MCTalkListDataModel *)model{
//    
//    if ([model.contentType isEqualToString:@"collectionsort"] || [model.contentType isEqualToString:@"collectionsort_like"]) {
//        MCAlbumViewController *mCAlbumViewController = [[MCAlbumViewController alloc] init];
//        mCAlbumViewController.sortId = model.contentId;
//        [self.navigationController pushViewController:mCAlbumViewController animated:YES];
//    } else if ([model.contentType isEqualToString:@"recipe"] || [model.contentType isEqualToString:@"recipe_like"]) {
//        MCCookDetailViewController *mCCookDetailViewController = [[MCCookDetailViewController alloc] init];
//        mCCookDetailViewController.cookID = model.contentId;
//        [self.navigationController pushViewController:mCCookDetailViewController animated:YES];
//    }
//    
//}
///删除评论
- (void)deleteComment{
//    [[MCMessageView getInstance] showText:@"删除中..."];
//    [HttpRequest deleteCommentWithTalkId:currentDeleteModel.talkid CommentId:currentDeleteModel.commentId andBlock:^(NSDictionary *result, NSError *error) {
//        [[MCMessageView getInstance] hide];
//        if (error == nil){
//            if ([result[@"state"] isEqualToString:@"200"]) {
//                
//                NSMutableArray * tmpMutableArray = [[NSMutableArray alloc]initWithArray: currentTalkListDataModel.commentPoList];
//                NSInteger sessionNum = [dataArray indexOfObject:currentTalkListDataModel];
//                NSInteger rowNum = [tmpMutableArray indexOfObject:currentDeleteModel];
//                [tmpMutableArray removeObject:currentDeleteModel];
//                //清除缓存
//                [commentHeightCache[sessionNum] removeObjectAtIndex:rowNum];
//                
//                currentTalkListDataModel.commentPoList  = [tmpMutableArray copy];
//            
//                currentTalkListDataModel.commentnum = [NSString stringWithFormat:@"%d",currentTalkListDataModel.commentnum.intValue -1];
//                [self.mainTableView reloadData];
//                [[MCMessageView getInstance]showMessage:@"删除成功"];
//            }
//            else{
//                [[MCMessageView getInstance]showMessage:result[@"message"]];
//            }
//        }else{
//            MSLog(@"%@",error);
//            [[MCMessageView getInstance]showMessage:@"与服务器连接出错，请稍后再试"];
//        }
//        
//    }];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [inputTextView resignFirstResponder];
}
#pragma mark - PZHGrowingTextView
- (void)buildBottomTextView{
    inputTextView = [[PZHGrowingTextView alloc]initWithFrame:CGRectMake(15, 9, screenWidth-30, 32)];
    [self.commentTextView addSubview:inputTextView];
    inputTextView.delegate = self;
    [bottomTextView addSubview:inputTextView];
    inputTextView.maxHeight = 94;
    [inputTextView.layer setMasksToBounds:YES];
    [inputTextView.layer setCornerRadius:3];
    [inputTextView.layer setBorderWidth:1];
}
- (void)hideKeyBoard{
    inputTextView.text = nil;
    [inputTextView resignFirstResponder];
}
#pragma mark - buildNav
- (void)buildNav{
    self.navigationController.navigationBar.tintColor =[UIColor blackColor];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    if (self.type == TalkTopic) {
        self.navigationItem.title = [NSString stringWithFormat:@"#%@#",self.topicStr] ;
        self.navigationItem.rightBarButtonItem = barButtonItem;
    }
    if (self.type == TalkDetail) {

        UIButton *rightButton = [[UIButton alloc] init];
        rightButton.frame = CGRectMake(0, 0, 44, 44);
        [rightButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        if (DeviceSystemVersion >= 7.0) {
            rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightItem;
        
    }
}
#pragma mark - private methods
#pragma mark 判断是否能删除

- (void)judgeIfCanDelete:(UILongPressGestureRecognizer *)longPressGestureRecognizer{

}
- (void)tapTopic:(NSString *)topic{
    
    if (self.type == TalkTopic) {
        if ([topic isEqualToString:self.topicStr]) {
            return ;
        }
    }
    PZHTalkMainViewController * topicViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"PZHTalkMainViewController"];
    topicViewController.type = TalkTopic;
    topicViewController.topicStr = topic;
    [self.navigationController pushViewController:topicViewController animated:YES];
}


#pragma mark 清除缓存
- (void)clearCache{
   
    
    [commentHeightCache removeAllObjects];
    [listHeightCache removeAllObjects];
}

#pragma mark 初始化缓存
- (void)initCache{
    for (long i = [listHeightCache count] ; i < dataArray.count; i++) {
        [listHeightCache addObject:@(0)];
        PZHListItemModel * model = dataArray[i];
        NSMutableArray * tmpArray = [[NSMutableArray alloc]init];
        for (int k = 0;  k < model.commentPoList.count ; k++) {
            [tmpArray addObject:@(0)];
        }
        [commentHeightCache addObject:tmpArray];
    }
}


#pragma mark 登出
- (void)logout{
    tableViewHeaderHeight = 0;
//    [self.mainTableView setTableHeaderView: [self createHeader]];
    [self talkReloadData];
}
#pragma mark - getter and setter



@end
