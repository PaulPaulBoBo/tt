//
//  R_LBPWebSocketManager.h
//  tt
//
//  Created by l on 2021/2/25.
//

#import <Foundation/Foundation.h>
#import "SocketRocket.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,WebSocketConnectType){
    WebSocketDefault = 0,   //初始状态,未连接,不需要重新连接
    WebSocketConnect,       //已连接
    WebSocketDisconnect    //连接后断开,需要重新连接
};

@interface R_LBPWebSocketManager : NSObject

@property (nonatomic, strong) SRWebSocket *webSocket;
@property(nonatomic, weak) id<SRWebSocketDelegate> delegate;
@property (nonatomic, assign) WebSocketConnectType connectType;

@property (nonatomic, assign) BOOL isConnect;  //是否连接

+ (instancetype)shareInstance;

- (void)connectServer;//建立长连接
- (void)reConnectServer;//重新连接
- (void)RMWebSocketClose;//关闭长连接
- (void)sendDataToServer:(NSString *)data;//发送数据给服务器

@end

NS_ASSUME_NONNULL_END
