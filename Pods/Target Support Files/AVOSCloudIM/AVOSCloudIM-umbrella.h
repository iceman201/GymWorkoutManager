#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AVIMMessageOption.h"
#import "AVIMKeyedConversation.h"
#import "AVIMConversationQuery.h"
#import "AVIMTextMessage.h"
#import "AVIMRecalledMessage.h"
#import "AVIMLocationMessage.h"
#import "AVIMAudioMessage.h"
#import "AVIMVideoMessage.h"
#import "AVIMFileMessage.h"
#import "AVIMTypedMessage.h"
#import "AVIMImageMessage.h"
#import "AVIMClient.h"
#import "AVIMCommon.h"
#import "AVIMConversation.h"
#import "AVIMMessage.h"
#import "AVIMSignature.h"
#import "AVIMClientProtocol.h"
#import "AVIMConversationMemberInfo.h"
#import "AVIMClientInternalConversationManager.h"
#import "AVOSCloudIM.h"

FOUNDATION_EXPORT double AVOSCloudIMVersionNumber;
FOUNDATION_EXPORT const unsigned char AVOSCloudIMVersionString[];

