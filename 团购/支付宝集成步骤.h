1.生成订单信息
AlixPayOrder *order = [[AlixPayOrder alloc] init];
order.partner = PartnerID;
order.seller = SellerID;
order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
order.productName = product.subject; //商品标题
order.productDescription = product.body; //商品描述
order.amount = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
order.notifyURL =  @"http%3A%2F%2Fwwww.xxx.com"; //回调URL

2.签名加密
