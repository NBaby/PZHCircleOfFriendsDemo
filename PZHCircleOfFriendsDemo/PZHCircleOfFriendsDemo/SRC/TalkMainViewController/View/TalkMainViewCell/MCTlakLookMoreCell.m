//
//  MCTlakLookMoreCell.m
//  eCook
//
//  Created by apple on 16/2/2.
//
//

#import "MCTlakLookMoreCell.h"
//#import "MCTalkMainListModel.h"
@interface MCTlakLookMoreCell(){
//    MCTalkListDataModel * dataModel;
}
@end
@implementation MCTlakLookMoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIView * line = [[UIView alloc]init];
    [self.contentView addSubview:line];
    line.backgroundColor = ColorNewLine;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.leading.equalTo(self.contentView).offset(68);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(0.5);
    }];
    UIView * line2 = [[UIView alloc]init];
    line2.backgroundColor = ColorNewLine;
    [self.contentView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
        make.leading.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(0);
    }];
}

- (void)setInfo:(id)info{
//    dataModel = info;
}
- (IBAction)lookMore:(id)sender {
//    [self.fatherViewController tapDetailBtn:dataModel];
}

@end
@implementation  UITableView(MCTlakLookMoreCell)

- (MCTlakLookMoreCell *)MCTlakLookMoreCell {
    static NSString *CellIdentifier = @"MCTlakLookMoreCell";
    MCTlakLookMoreCell *Cell=(MCTlakLookMoreCell *)[self dequeueReusableCellWithIdentifier:CellIdentifier];
    if(nil==Cell) {
        UINib *nib = [UINib nibWithNibName:CellIdentifier bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:CellIdentifier];
        Cell = (MCTlakLookMoreCell *)[self dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    Cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return Cell;
}

@end