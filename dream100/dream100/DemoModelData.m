//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "DemoModelData.h"

#import "NSUserDefaults+DemoSettings.h"
#import "CDUserManager.h"


/**
 *  This is for demo/testing purposes only.
 *  This object sets up some fake model data.
 *  Do not actually do anything like this.
 */

@implementation DemoModelData

- (instancetype)init
{
    self = [super init];
    if (self) {
        [NSUserDefaults saveIncomingAvatarSetting:YES];
        [NSUserDefaults saveOutgoingAvatarSetting:YES];
        
        if ([NSUserDefaults emptyMessagesSetting]) {
            self.messages = [NSMutableArray new];
        }
        else {
            //[self loadFakeMessages];
            self.messages = [NSMutableArray new];
            //[self loadMessage];
        }
        
        
        /**
         *  Create avatar images once.
         *
         *  Be sure to create your avatars one time and reuse them for good performance.
         *
         *  If you are not using avatars, ignore this.
         */
//        JSQMessagesAvatarImageFactory *avatarFactory = [[JSQMessagesAvatarImageFactory alloc] initWithDiameter:kJSQMessagesCollectionViewAvatarSizeDefault];
//        
//        
//        JSQMessagesAvatarImage *jsqImage = [avatarFactory avatarImageWithUserInitials:@"JSQ"
//                                                                      backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
//                                                                            textColor:[UIColor colorWithWhite:0.60f alpha:1.0f]
//                                                                                 font:[UIFont systemFontOfSize:14.0f]];
//        
//        JSQMessagesAvatarImage *cookImage = [avatarFactory avatarImageWithImage:[UIImage imageNamed:@"demo_avatar_cook"]];
//        
//        JSQMessagesAvatarImage *jobsImage = [avatarFactory avatarImageWithImage:[UIImage imageNamed:@"demo_avatar_jobs"]];
//        
//        JSQMessagesAvatarImage *wozImage = [avatarFactory avatarImageWithImage:[UIImage imageNamed:@"demo_avatar_woz"]];
//        
//        self.avatars = @{ kJSQDemoAvatarIdSquires : jsqImage,
//                          kJSQDemoAvatarIdCook : cookImage,
//                          kJSQDemoAvatarIdJobs : jobsImage,
//                          kJSQDemoAvatarIdWoz : wozImage };
//        
//        
//        self.users = @{ kJSQDemoAvatarIdJobs : kJSQDemoAvatarDisplayNameJobs,
//                        kJSQDemoAvatarIdCook : kJSQDemoAvatarDisplayNameCook,
//                        kJSQDemoAvatarIdWoz : kJSQDemoAvatarDisplayNameWoz,
//                        kJSQDemoAvatarIdSquires : kJSQDemoAvatarDisplayNameSquires };
        
        
//        /**
//         *  Create message bubble images objects.
//         *
//         *  Be sure to create your bubble images one time and reuse them for good performance.
//         *
//         */
//        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
//        
//        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
//        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    }
    
    return self;
}

- (void)initUserInfo {
    self.avatars = [[NSMutableDictionary alloc] init];
    self.users = [[NSMutableDictionary alloc] init];
    JSQMessagesAvatarImageFactory *avatarFactory = [[JSQMessagesAvatarImageFactory alloc] initWithDiameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    
    [[CDUserManager manager] getAvatarImageOfUser:_fromUser block:^(UIImage *image) {
        JSQMessagesAvatarImage *fromUserAvatar = [avatarFactory avatarImageWithImage:image];
        
        [self.avatars setObject:fromUserAvatar forKey:_fromUser.objectId];
        [self.users setObject:_fromUser.username forKey:_fromUser.objectId];
    }];
    
    [[CDUserManager manager] getAvatarImageOfUser:[AVUser currentUser] block:^(UIImage *image) {
        JSQMessagesAvatarImage *toUserAvatar = [avatarFactory avatarImageWithImage:image];
        
        [self.avatars setObject:toUserAvatar forKey:[AVUser currentUser].objectId];
        [self.users setObject:[AVUser currentUser].username forKey:_fromUser.objectId];
    }];
    
    /**
     *  Create message bubble images objects.
     *
     *  Be sure to create your bubble images one time and reuse them for good performance.
     *
     */
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
}

- (void)fetchTextData {
    AVQuery *queryFromMe = [AVQuery queryWithClassName:@"Message"];
    [queryFromMe whereKey:@"fromUser" equalTo:[AVUser currentUser]];
    [queryFromMe whereKey:@"toUser" equalTo:_fromUser];
    
    AVQuery *queryToMe = [AVQuery queryWithClassName:@"Message"];
    [queryToMe whereKey:@"fromUser" equalTo:_fromUser];
    [queryToMe whereKey:@"toUser" equalTo:[AVUser currentUser]];
    
    AVQuery *query = [AVQuery orQueryWithSubqueries:@[queryFromMe, queryToMe]];
    [query includeKey:@"fromUser"];
    [query includeKey:@"toUser"];
    [query orderByDescending:@"createdAt"];
    [query setLimit:10];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"IFetchMessageErrorNotification" object:nil];
        } else {
            [self.messages removeAllObjects];
            if (objects.count > 0) {
                [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    AVObject *messageObject = obj;
                    NSString *senderId = messageObject[@"fromUser"][@"objectId"];
                    NSString *displayName = messageObject[@"fromUser"][@"username"];
                    NSDate *sendDate = messageObject[@"createdAt"];
                    NSString *text = messageObject[@"message"];
                    
                    JSQMessage *jsqMessage = [[JSQMessage alloc] initWithSenderId:senderId
                                                                senderDisplayName:displayName
                                                                             date:sendDate
                                                                             text:text];
                    
                    [self.messages insertObject:jsqMessage atIndex:0];
                }];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"IFetchMoreMessageNotification" object:nil];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ILNoMoreMessageNotification" object:nil];
            }
        }
    }];
}

- (void)fetchMoreTextData {
    AVQuery *queryFromMe = [AVQuery queryWithClassName:@"Message"];
    [queryFromMe whereKey:@"fromUser" equalTo:[AVUser currentUser]];
    [queryFromMe whereKey:@"toUser" equalTo:_fromUser];
    
    AVQuery *queryToMe = [AVQuery queryWithClassName:@"Message"];
    [queryToMe whereKey:@"fromUser" equalTo:_fromUser];
    [queryToMe whereKey:@"toUser" equalTo:[AVUser currentUser]];
    
    AVQuery *query = [AVQuery orQueryWithSubqueries:@[queryFromMe, queryToMe]];
    [query includeKey:@"fromUser"];
    [query includeKey:@"toUser"];
    if(self.messages.count > 0){
        JSQMessage *jsqMessage = self.messages[0];
        [query whereKey:@"createdAt" lessThan:jsqMessage.date];
    }
    [query orderByDescending:@"createdAt"];
    [query setLimit:10];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"IFetchMessageErrorNotification" object:nil];
        } else {
            if (objects.count > 0) {
                [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    AVObject *messageObject = obj;
                    NSString *senderId = messageObject[@"fromUser"][@"objectId"];
                    NSString *displayName = messageObject[@"fromUser"][@"username"];
                    NSDate *sendDate = messageObject[@"createdAt"];
                    NSString *text = messageObject[@"message"];
                    
                    JSQMessage *jsqMessage = [[JSQMessage alloc] initWithSenderId:senderId
                                                                senderDisplayName:displayName
                                                                             date:sendDate
                                                                             text:text];
                    
                    [self.messages insertObject:jsqMessage atIndex:0];
                    //[self.messages addObject:jsqMessage];
                }];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"IFetchMoreMessageNotification" object:nil];

            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ILNoMoreMessageNotification" object:nil];

            }
        }
    }];
}

- (void)loadFakeMessages
{
    /**
     *  Load some fake messages for demo.
     *
     *  You should have a mutable array or orderedSet, or something.
     */
    self.messages = [[NSMutableArray alloc] initWithObjects:
                     [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdSquires
                                        senderDisplayName:kJSQDemoAvatarDisplayNameSquires
                                                     date:[NSDate distantPast]
                                                     text:NSLocalizedString(@"Welcome to JSQMessages: A messaging UI framework for iOS.", nil)],
                     
                     [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdWoz
                                        senderDisplayName:kJSQDemoAvatarDisplayNameWoz
                                                     date:[NSDate distantPast]
                                                     text:NSLocalizedString(@"It is simple, elegant, and easy to use. There are super sweet default settings, but you can customize like crazy.", nil)],
                     
                     [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdSquires
                                        senderDisplayName:kJSQDemoAvatarDisplayNameSquires
                                                     date:[NSDate distantPast]
                                                     text:NSLocalizedString(@"It even has data detectors. You can call me tonight. My cell number is 123-456-7890. My website is www.hexedbits.com.", nil)],
                     
                     [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdJobs
                                        senderDisplayName:kJSQDemoAvatarDisplayNameJobs
                                                     date:[NSDate date]
                                                     text:NSLocalizedString(@"JSQMessagesViewController is nearly an exact replica of the iOS Messages App. And perhaps, better.", nil)],
                     
                     [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdCook
                                        senderDisplayName:kJSQDemoAvatarDisplayNameCook
                                                     date:[NSDate date]
                                                     text:NSLocalizedString(@"It is unit-tested, free, open-source, and documented.", nil)],
                     
                     [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdSquires
                                        senderDisplayName:kJSQDemoAvatarDisplayNameSquires
                                                     date:[NSDate date]
                                                     text:NSLocalizedString(@"Now with media messages!", nil)],
                     nil];
    
    [self addPhotoMediaMessage];
    [self addAudioMediaMessage];
    
    /**
     *  Setting to load extra messages for testing/demo
     */
    if ([NSUserDefaults extraMessagesSetting]) {
        NSArray *copyOfMessages = [self.messages copy];
        for (NSUInteger i = 0; i < 4; i++) {
            [self.messages addObjectsFromArray:copyOfMessages];
        }
    }
    
    
    /**
     *  Setting to load REALLY long message for testing/demo
     *  You should see "END" twice
     */
    if ([NSUserDefaults longMessageSetting]) {
        JSQMessage *reallyLongMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
                                                            displayName:kJSQDemoAvatarDisplayNameSquires
                                                                   text:@"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? END Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? END"];
        
        [self.messages addObject:reallyLongMessage];
    }
}

- (void)addAudioMediaMessage
{
    NSString * sample = [[NSBundle mainBundle] pathForResource:@"jsq_messages_sample" ofType:@"m4a"];
    NSData * audioData = [NSData dataWithContentsOfFile:sample];
    JSQAudioMediaItem *audioItem = [[JSQAudioMediaItem alloc] initWithData:audioData];
    JSQMessage *audioMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
                                                   displayName:kJSQDemoAvatarDisplayNameSquires
                                                         media:audioItem];
    [self.messages addObject:audioMessage];
}

- (void)addPhotoMediaMessage
{
    JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:[UIImage imageNamed:@"goldengate"]];
    JSQMessage *photoMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
                                                   displayName:kJSQDemoAvatarDisplayNameSquires
                                                         media:photoItem];
    [self.messages addObject:photoMessage];
}

- (void)addLocationMediaMessageCompletion:(JSQLocationMediaItemCompletionBlock)completion
{
    CLLocation *ferryBuildingInSF = [[CLLocation alloc] initWithLatitude:37.795313 longitude:-122.393757];
    
    JSQLocationMediaItem *locationItem = [[JSQLocationMediaItem alloc] init];
    [locationItem setLocation:ferryBuildingInSF withCompletionHandler:completion];
    
    JSQMessage *locationMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
                                                      displayName:kJSQDemoAvatarDisplayNameSquires
                                                            media:locationItem];
    [self.messages addObject:locationMessage];
}

- (void)addVideoMediaMessage
{
    // don't have a real video, just pretending
    NSURL *videoURL = [NSURL URLWithString:@"file://"];
    
    JSQVideoMediaItem *videoItem = [[JSQVideoMediaItem alloc] initWithFileURL:videoURL isReadyToPlay:YES];
    JSQMessage *videoMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
                                                   displayName:kJSQDemoAvatarDisplayNameSquires
                                                         media:videoItem];
    [self.messages addObject:videoMessage];
}

- (void)addVideoMediaMessageWithThumbnail
{
    // don't have a real video, just pretending
    NSURL *videoURL = [NSURL URLWithString:@"file://"];
    
    JSQVideoMediaItem *videoItem = [[JSQVideoMediaItem alloc] initWithFileURL:videoURL isReadyToPlay:YES thumbnailImage:[UIImage imageNamed:@"goldengate"]];
    JSQMessage *videoMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
                                                   displayName:kJSQDemoAvatarDisplayNameSquires
                                                         media:videoItem];
    [self.messages addObject:videoMessage];
}

@end
