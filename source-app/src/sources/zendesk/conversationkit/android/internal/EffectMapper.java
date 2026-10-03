package zendesk.conversationkit.android.internal;

import java.util.List;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.ConversationKitEvent;
import zendesk.conversationkit.android.ConversationKitResult;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.conversationkit.android.model.Message;
import zendesk.conversationkit.android.model.MessageAction;
import zendesk.conversationkit.android.model.MessageKt;
import zendesk.conversationkit.android.model.User;
import zendesk.logger.Logger;

@Metadata(m17d1 = {"\u0000¨\u0001\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u0000 62\u00020\u0001:\u00016B\u0005¢\u0006\u0002\u0010\u0002J\u0014\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0006\u001a\u00020\u0007J\u0016\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0006\u001a\u00020\tH\u0002J\u0016\u0010\n\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0006\u001a\u00020\u000bH\u0002J\u0016\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0006\u001a\u00020\rH\u0002J\u0016\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0006\u001a\u00020\u000fH\u0002J\u0016\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0006\u001a\u00020\u0011H\u0002J\u0016\u0010\u0012\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0006\u001a\u00020\u0013H\u0002J\u0016\u0010\u0014\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0006\u001a\u00020\u0015H\u0002J\u0016\u0010\u0016\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0006\u001a\u00020\u0017H\u0002J\u0016\u0010\u0018\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0006\u001a\u00020\u0019H\u0002J\u0016\u0010\u001a\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0006\u001a\u00020\u001bH\u0002J\u0016\u0010\u001c\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0006\u001a\u00020\u001dH\u0002J\u0016\u0010\u001e\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0006\u001a\u00020\u001fH\u0002J\u0016\u0010 \u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0006\u001a\u00020!H\u0002J\u0016\u0010\"\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0006\u001a\u00020#H\u0002J\u0016\u0010$\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0006\u001a\u00020%H\u0002J\u0016\u0010&\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0006\u001a\u00020'H\u0002J\u0016\u0010(\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0006\u001a\u00020)H\u0002J\u0016\u0010*\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0006\u001a\u00020+H\u0002J\u0016\u0010,\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0006\u001a\u00020-H\u0002J\u0016\u0010.\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0006\u001a\u00020/H\u0002J\u0016\u00100\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0006\u001a\u000201H\u0002J\u0016\u00102\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0006\u001a\u000203H\u0002J\u0016\u00104\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0006\u001a\u000205H\u0002¨\u00067"}, m18d2 = {"Lzendesk/conversationkit/android/internal/EffectMapper;", "", "()V", "map", "", "Lzendesk/conversationkit/android/ConversationKitEvent;", "effect", "Lzendesk/conversationkit/android/internal/Effect;", "mapActivityEvent", "Lzendesk/conversationkit/android/internal/Effect$ActivityEventReceived;", "mapAttachmentDownloadStarted", "Lzendesk/conversationkit/android/internal/Effect$AttachmentDownloadStarted;", "mapConnectionChanged", "Lzendesk/conversationkit/android/internal/Effect$ConnectionChanged;", "mapConversationAdded", "Lzendesk/conversationkit/android/internal/Effect$ConversationAddedResult;", "mapConversationRemoved", "Lzendesk/conversationkit/android/internal/Effect$ConversationRemovedResult;", "mapConversationUpdated", "Lzendesk/conversationkit/android/internal/Effect$ConversationUpdatedResult;", "mapCreateConversationResult", "Lzendesk/conversationkit/android/internal/Effect$CreateConversationResult;", "mapCreateUserResult", "Lzendesk/conversationkit/android/internal/Effect$CreateUserResult;", "mapGetConversationResult", "Lzendesk/conversationkit/android/internal/Effect$GetConversationResult;", "mapLoadMoreMessages", "Lzendesk/conversationkit/android/internal/Effect$LoadMoreMessages;", "mapLogoutUserResult", "Lzendesk/conversationkit/android/internal/Effect$LogoutUserResult;", "mapMessagePrepared", "Lzendesk/conversationkit/android/internal/Effect$MessagePrepared;", "mapMessageReceived", "Lzendesk/conversationkit/android/internal/Effect$MessageReceived;", "mapOpenAttachmentFromFile", "Lzendesk/conversationkit/android/internal/Effect$OpenAttachmentFromFile;", "mapPersistedUserReceived", "Lzendesk/conversationkit/android/internal/Effect$PersistedUserReceived;", "mapPostbackSent", "Lzendesk/conversationkit/android/internal/Effect$SendPostbackResult;", "mapProactiveMessageReferral", "Lzendesk/conversationkit/android/internal/Effect$ProactiveMessageReferral;", "mapPushRegistrationPending", "Lzendesk/conversationkit/android/internal/Effect$PushTokenPrepared;", "mapPushRegistrationResult", "Lzendesk/conversationkit/android/internal/Effect$PushTokenUpdateResult;", "mapRefreshConversationResult", "Lzendesk/conversationkit/android/internal/Effect$RefreshConversationResult;", "mapRefreshUserResult", "Lzendesk/conversationkit/android/internal/Effect$RefreshUserResult;", "mapSendMessageResult", "Lzendesk/conversationkit/android/internal/Effect$SendMessageResult;", "mapUserAccessRevoked", "Lzendesk/conversationkit/android/internal/Effect$UserAccessRevoked;", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class EffectMapper {
    private static final String LOG_TAG = "EffectMapper";

    public final List<ConversationKitEvent> map(Effect effect) {
        Intrinsics.checkNotNullParameter(effect, "effect");
        if (effect instanceof Effect.ConnectionChanged) {
            return mapConnectionChanged((Effect.ConnectionChanged) effect);
        }
        if (effect instanceof Effect.RefreshUserResult) {
            return mapRefreshUserResult((Effect.RefreshUserResult) effect);
        }
        if (effect instanceof Effect.CreateConversationResult) {
            return mapCreateConversationResult((Effect.CreateConversationResult) effect);
        }
        if (effect instanceof Effect.GetConversationResult) {
            return mapGetConversationResult((Effect.GetConversationResult) effect);
        }
        if (effect instanceof Effect.ProactiveMessageReferral) {
            return mapProactiveMessageReferral((Effect.ProactiveMessageReferral) effect);
        }
        if (effect instanceof Effect.RefreshConversationResult) {
            return mapRefreshConversationResult((Effect.RefreshConversationResult) effect);
        }
        if (effect instanceof Effect.MessageReceived) {
            return mapMessageReceived((Effect.MessageReceived) effect);
        }
        if (effect instanceof Effect.LoadMoreMessages) {
            return mapLoadMoreMessages((Effect.LoadMoreMessages) effect);
        }
        if (effect instanceof Effect.MessagePrepared) {
            return mapMessagePrepared((Effect.MessagePrepared) effect);
        }
        if (effect instanceof Effect.SendMessageResult) {
            return mapSendMessageResult((Effect.SendMessageResult) effect);
        }
        if (effect instanceof Effect.PushTokenPrepared) {
            return mapPushRegistrationPending((Effect.PushTokenPrepared) effect);
        }
        if (effect instanceof Effect.PushTokenUpdateResult) {
            return mapPushRegistrationResult((Effect.PushTokenUpdateResult) effect);
        }
        if (effect instanceof Effect.ActivityEventReceived) {
            return mapActivityEvent((Effect.ActivityEventReceived) effect);
        }
        if (effect instanceof Effect.PersistedUserReceived) {
            return mapPersistedUserReceived((Effect.PersistedUserReceived) effect);
        }
        if (effect instanceof Effect.UserAccessRevoked) {
            return mapUserAccessRevoked((Effect.UserAccessRevoked) effect);
        }
        if (effect instanceof Effect.LogoutUserResult) {
            return mapLogoutUserResult((Effect.LogoutUserResult) effect);
        }
        if (effect instanceof Effect.ConversationAddedResult) {
            return mapConversationAdded((Effect.ConversationAddedResult) effect);
        }
        if (effect instanceof Effect.ConversationRemovedResult) {
            return mapConversationRemoved((Effect.ConversationRemovedResult) effect);
        }
        if (effect instanceof Effect.ConversationUpdatedResult) {
            return mapConversationUpdated((Effect.ConversationUpdatedResult) effect);
        }
        if (effect instanceof Effect.SendPostbackResult) {
            return mapPostbackSent((Effect.SendPostbackResult) effect);
        }
        if (effect instanceof Effect.CreateUserResult) {
            return mapCreateUserResult((Effect.CreateUserResult) effect);
        }
        if (effect instanceof Effect.AttachmentDownloadStarted) {
            return mapAttachmentDownloadStarted((Effect.AttachmentDownloadStarted) effect);
        }
        if (effect instanceof Effect.OpenAttachmentFromFile) {
            return mapOpenAttachmentFromFile((Effect.OpenAttachmentFromFile) effect);
        }
        Logger.m217d(LOG_TAG, "Effect " + effect + " has no public counterpart, skipping.", new Object[0]);
        return CollectionsKt.emptyList();
    }

    private final List<ConversationKitEvent> mapCreateUserResult(final Effect.CreateUserResult effect) {
        return EffectMapperKt.mapEvents(new Function1<EventReceiver, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(EventReceiver eventReceiver) {
                invoke2(eventReceiver);
                return Unit.INSTANCE;
            }

            public final void invoke2(EventReceiver mapEvents) {
                Intrinsics.checkNotNullParameter(mapEvents, "$this$mapEvents");
                if (effect.getResult() instanceof ConversationKitResult.Success) {
                    final User user = (User) ((ConversationKitResult.Success) effect.getResult()).getValue();
                    if (user.getConversations().size() == 1) {
                        mapEvents.event(new Function0<ConversationKitEvent>() {
                            {
                                super(0);
                            }

                            @Override
                            public final ConversationKitEvent invoke() {
                                return new ConversationKitEvent.ConversationAddedSuccess((Conversation) CollectionsKt.first((List) user.getConversations()));
                            }
                        });
                    }
                }
            }
        });
    }

    private final List<ConversationKitEvent> mapLogoutUserResult(final Effect.LogoutUserResult effect) {
        return EffectMapperKt.mapEvents(new Function1<EventReceiver, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(EventReceiver eventReceiver) {
                invoke2(eventReceiver);
                return Unit.INSTANCE;
            }

            public final void invoke2(EventReceiver mapEvents) {
                final ConversationKitResult.Success success;
                Intrinsics.checkNotNullParameter(mapEvents, "$this$mapEvents");
                ConversationKitResult<Object> result = effect.getResult();
                if (result instanceof ConversationKitResult.Failure) {
                    success = effect.getResult();
                } else {
                    if (!(result instanceof ConversationKitResult.Success)) {
                        throw new NoWhenBranchMatchedException();
                    }
                    success = new ConversationKitResult.Success(Unit.INSTANCE);
                }
                mapEvents.event(new Function0<ConversationKitEvent>() {
                    {
                        super(0);
                    }

                    @Override
                    public final ConversationKitEvent invoke() {
                        return new ConversationKitEvent.LogoutUserCompleted(success);
                    }
                });
            }
        });
    }

    private final List<ConversationKitEvent> mapUserAccessRevoked(final Effect.UserAccessRevoked effect) {
        return EffectMapperKt.mapEvents(new Function1<EventReceiver, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(EventReceiver eventReceiver) {
                invoke2(eventReceiver);
                return Unit.INSTANCE;
            }

            public final void invoke2(EventReceiver mapEvents) {
                Intrinsics.checkNotNullParameter(mapEvents, "$this$mapEvents");
                if (effect.getResult() instanceof ConversationKitResult.Failure) {
                    final Effect.UserAccessRevoked userAccessRevoked = effect;
                    mapEvents.event(new Function0<ConversationKitEvent>() {
                        {
                            super(0);
                        }

                        @Override
                        public final ConversationKitEvent invoke() {
                            return new ConversationKitEvent.UserAccessRevoked(((ConversationKitResult.Failure) userAccessRevoked.getResult()).getCause());
                        }
                    });
                }
            }
        });
    }

    private final List<ConversationKitEvent> mapConnectionChanged(final Effect.ConnectionChanged effect) {
        return EffectMapperKt.mapEvents(new Function1<EventReceiver, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(EventReceiver eventReceiver) {
                invoke2(eventReceiver);
                return Unit.INSTANCE;
            }

            public final void invoke2(EventReceiver mapEvents) {
                Intrinsics.checkNotNullParameter(mapEvents, "$this$mapEvents");
                final Effect.ConnectionChanged connectionChanged = effect;
                mapEvents.event(new Function0<ConversationKitEvent>() {
                    {
                        super(0);
                    }

                    @Override
                    public final ConversationKitEvent invoke() {
                        return new ConversationKitEvent.ConnectionStatusChanged(connectionChanged.getConnectionStatus());
                    }
                });
            }
        });
    }

    private final List<ConversationKitEvent> mapRefreshUserResult(final Effect.RefreshUserResult effect) {
        return EffectMapperKt.mapEvents(new Function1<EventReceiver, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(EventReceiver eventReceiver) {
                invoke2(eventReceiver);
                return Unit.INSTANCE;
            }

            public final void invoke2(EventReceiver mapEvents) {
                Intrinsics.checkNotNullParameter(mapEvents, "$this$mapEvents");
                if (effect.getResult() instanceof ConversationKitResult.Success) {
                    final Effect.RefreshUserResult refreshUserResult = effect;
                    mapEvents.event(new Function0<ConversationKitEvent>() {
                        {
                            super(0);
                        }

                        @Override
                        public final ConversationKitEvent invoke() {
                            return new ConversationKitEvent.UserUpdated((User) ((ConversationKitResult.Success) refreshUserResult.getResult()).getValue());
                        }
                    });
                }
            }
        });
    }

    private final List<ConversationKitEvent> mapCreateConversationResult(final Effect.CreateConversationResult effect) {
        return EffectMapperKt.mapEvents(new Function1<EventReceiver, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(EventReceiver eventReceiver) {
                invoke2(eventReceiver);
                return Unit.INSTANCE;
            }

            public final void invoke2(EventReceiver mapEvents) {
                Intrinsics.checkNotNullParameter(mapEvents, "$this$mapEvents");
                if (effect.getResult() instanceof ConversationKitResult.Success) {
                    final Effect.CreateConversationResult createConversationResult = effect;
                    mapEvents.event(new Function0<ConversationKitEvent>() {
                        {
                            super(0);
                        }

                        @Override
                        public final ConversationKitEvent invoke() {
                            return new ConversationKitEvent.ConversationUpdated((Conversation) ((ConversationKitResult.Success) createConversationResult.getResult()).getValue());
                        }
                    });
                }
            }
        });
    }

    private final List<ConversationKitEvent> mapGetConversationResult(final Effect.GetConversationResult effect) {
        return EffectMapperKt.mapEvents(new Function1<EventReceiver, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(EventReceiver eventReceiver) {
                invoke2(eventReceiver);
                return Unit.INSTANCE;
            }

            public final void invoke2(EventReceiver mapEvents) {
                Intrinsics.checkNotNullParameter(mapEvents, "$this$mapEvents");
                if (effect.getResult() instanceof ConversationKitResult.Success) {
                    final Effect.GetConversationResult getConversationResult = effect;
                    mapEvents.event(new Function0<ConversationKitEvent>() {
                        {
                            super(0);
                        }

                        @Override
                        public final ConversationKitEvent invoke() {
                            return new ConversationKitEvent.ConversationUpdated((Conversation) ((ConversationKitResult.Success) getConversationResult.getResult()).getValue());
                        }
                    });
                }
            }
        });
    }

    private final List<ConversationKitEvent> mapProactiveMessageReferral(final Effect.ProactiveMessageReferral effect) {
        return EffectMapperKt.mapEvents(new Function1<EventReceiver, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(EventReceiver eventReceiver) {
                invoke2(eventReceiver);
                return Unit.INSTANCE;
            }

            public final void invoke2(EventReceiver mapEvents) {
                Intrinsics.checkNotNullParameter(mapEvents, "$this$mapEvents");
                if (effect.getResult() instanceof ConversationKitResult.Success) {
                    final Effect.ProactiveMessageReferral proactiveMessageReferral = effect;
                    mapEvents.event(new Function0<ConversationKitEvent>() {
                        {
                            super(0);
                        }

                        @Override
                        public final ConversationKitEvent invoke() {
                            return new ConversationKitEvent.ConversationUpdated((Conversation) ((ConversationKitResult.Success) proactiveMessageReferral.getResult()).getValue());
                        }
                    });
                }
            }
        });
    }

    private final List<ConversationKitEvent> mapRefreshConversationResult(final Effect.RefreshConversationResult effect) {
        return EffectMapperKt.mapEvents(new Function1<EventReceiver, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(EventReceiver eventReceiver) {
                invoke2(eventReceiver);
                return Unit.INSTANCE;
            }

            public final void invoke2(EventReceiver mapEvents) {
                Intrinsics.checkNotNullParameter(mapEvents, "$this$mapEvents");
                if (effect.getResult() instanceof ConversationKitResult.Success) {
                    final Effect.RefreshConversationResult refreshConversationResult = effect;
                    mapEvents.event(new Function0<ConversationKitEvent>() {
                        {
                            super(0);
                        }

                        @Override
                        public final ConversationKitEvent invoke() {
                            return new ConversationKitEvent.ConversationUpdated((Conversation) ((ConversationKitResult.Success) refreshConversationResult.getResult()).getValue());
                        }
                    });
                }
            }
        });
    }

    private final List<ConversationKitEvent> mapMessageReceived(final Effect.MessageReceived effect) {
        return EffectMapperKt.mapEvents(new Function1<EventReceiver, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(EventReceiver eventReceiver) {
                invoke2(eventReceiver);
                return Unit.INSTANCE;
            }

            public final void invoke2(EventReceiver mapEvents) {
                Intrinsics.checkNotNullParameter(mapEvents, "$this$mapEvents");
                final Effect.MessageReceived messageReceived = effect;
                mapEvents.event(new Function0<ConversationKitEvent>() {
                    {
                        super(0);
                    }

                    @Override
                    public final ConversationKitEvent invoke() {
                        return new ConversationKitEvent.MessageReceived(messageReceived.getMessage(), messageReceived.getConversationId());
                    }
                });
                mapEvents.event(effect.getConversation(), new Function1<Conversation, ConversationKitEvent>() {
                    @Override
                    public final ConversationKitEvent invoke(Conversation conversation) {
                        Intrinsics.checkNotNullParameter(conversation, "conversation");
                        return new ConversationKitEvent.ConversationUpdated(conversation);
                    }
                });
                final MessageAction.WebView webViewCheckMessageIsAWebViewWithOpenOnReceive = MessageKt.checkMessageIsAWebViewWithOpenOnReceive(effect.getMessage().getContent());
                if (webViewCheckMessageIsAWebViewWithOpenOnReceive != null) {
                    final Effect.MessageReceived messageReceived2 = effect;
                    mapEvents.event(new Function0<ConversationKitEvent>() {
                        {
                            super(0);
                        }

                        @Override
                        public final ConversationKitEvent invoke() {
                            return new ConversationKitEvent.OpenWebViewMessageReceived(webViewCheckMessageIsAWebViewWithOpenOnReceive.getUri(), webViewCheckMessageIsAWebViewWithOpenOnReceive.getSize(), messageReceived2.getConversationId());
                        }
                    });
                }
            }
        });
    }

    private final List<ConversationKitEvent> mapLoadMoreMessages(final Effect.LoadMoreMessages effect) {
        return EffectMapperKt.mapEvents(new Function1<EventReceiver, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(EventReceiver eventReceiver) {
                invoke2(eventReceiver);
                return Unit.INSTANCE;
            }

            public final void invoke2(EventReceiver mapEvents) {
                final List listEmptyList;
                Intrinsics.checkNotNullParameter(mapEvents, "$this$mapEvents");
                ConversationKitResult<List<Message>> result = effect.getResult();
                if (result instanceof ConversationKitResult.Success) {
                    listEmptyList = (List) ((ConversationKitResult.Success) effect.getResult()).getValue();
                } else {
                    if (!(result instanceof ConversationKitResult.Failure)) {
                        throw new NoWhenBranchMatchedException();
                    }
                    listEmptyList = CollectionsKt.emptyList();
                }
                final Effect.LoadMoreMessages loadMoreMessages = effect;
                mapEvents.event(new Function0<ConversationKitEvent>() {
                    {
                        super(0);
                    }

                    @Override
                    public final ConversationKitEvent invoke() {
                        return new ConversationKitEvent.LoadMoreMessages(listEmptyList, loadMoreMessages.getConversationId());
                    }
                });
                mapEvents.event(effect.getConversation(), new Function1<Conversation, ConversationKitEvent>() {
                    @Override
                    public final ConversationKitEvent invoke(Conversation conversation) {
                        Intrinsics.checkNotNullParameter(conversation, "conversation");
                        return new ConversationKitEvent.ConversationUpdated(conversation);
                    }
                });
            }
        });
    }

    private final List<ConversationKitEvent> mapMessagePrepared(final Effect.MessagePrepared effect) {
        return EffectMapperKt.mapEvents(new Function1<EventReceiver, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(EventReceiver eventReceiver) {
                invoke2(eventReceiver);
                return Unit.INSTANCE;
            }

            public final void invoke2(EventReceiver mapEvents) {
                Intrinsics.checkNotNullParameter(mapEvents, "$this$mapEvents");
                mapEvents.event(effect.getConversation(), new Function1<Conversation, ConversationKitEvent>() {
                    @Override
                    public final ConversationKitEvent invoke(Conversation conversation) {
                        Intrinsics.checkNotNullParameter(conversation, "conversation");
                        return new ConversationKitEvent.ConversationUpdated(conversation);
                    }
                });
            }
        });
    }

    private final List<ConversationKitEvent> mapSendMessageResult(final Effect.SendMessageResult effect) {
        return EffectMapperKt.mapEvents(new Function1<EventReceiver, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(EventReceiver eventReceiver) {
                invoke2(eventReceiver);
                return Unit.INSTANCE;
            }

            public final void invoke2(EventReceiver mapEvents) {
                Message message;
                Intrinsics.checkNotNullParameter(mapEvents, "$this$mapEvents");
                ConversationKitResult<Message> result = effect.getResult();
                if (result instanceof ConversationKitResult.Success) {
                    message = (Message) ((ConversationKitResult.Success) effect.getResult()).getValue();
                } else if (result instanceof ConversationKitResult.Failure) {
                    final Effect.SendMessageResult sendMessageResult = effect;
                    mapEvents.event(new Function0<ConversationKitEvent>() {
                        {
                            super(0);
                        }

                        @Override
                        public final ConversationKitEvent invoke() {
                            return new ConversationKitEvent.SendMessageFailed(((ConversationKitResult.Failure) sendMessageResult.getResult()).getCause());
                        }
                    });
                    message = effect.getMessage();
                } else {
                    throw new NoWhenBranchMatchedException();
                }
                final Effect.SendMessageResult sendMessageResult2 = effect;
                mapEvents.event(message, new Function1<Message, ConversationKitEvent>() {
                    {
                        super(1);
                    }

                    @Override
                    public final ConversationKitEvent invoke(Message message2) {
                        Intrinsics.checkNotNullParameter(message2, "message");
                        return new ConversationKitEvent.MessageUpdated(message2, sendMessageResult2.getConversationId());
                    }
                });
                mapEvents.event(effect.getConversation(), new Function1<Conversation, ConversationKitEvent>() {
                    @Override
                    public final ConversationKitEvent invoke(Conversation conversation) {
                        Intrinsics.checkNotNullParameter(conversation, "conversation");
                        return new ConversationKitEvent.ConversationUpdated(conversation);
                    }
                });
            }
        });
    }

    private final List<ConversationKitEvent> mapPushRegistrationPending(final Effect.PushTokenPrepared effect) {
        return EffectMapperKt.mapEvents(new Function1<EventReceiver, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(EventReceiver eventReceiver) {
                invoke2(eventReceiver);
                return Unit.INSTANCE;
            }

            public final void invoke2(EventReceiver mapEvents) {
                Intrinsics.checkNotNullParameter(mapEvents, "$this$mapEvents");
                final Effect.PushTokenPrepared pushTokenPrepared = effect;
                mapEvents.event(new Function0<ConversationKitEvent>() {
                    {
                        super(0);
                    }

                    @Override
                    public final ConversationKitEvent invoke() {
                        return new ConversationKitEvent.PushTokenPrepared(pushTokenPrepared.getPushToken());
                    }
                });
            }
        });
    }

    private final List<ConversationKitEvent> mapPushRegistrationResult(final Effect.PushTokenUpdateResult effect) {
        return EffectMapperKt.mapEvents(new Function1<EventReceiver, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(EventReceiver eventReceiver) {
                invoke2(eventReceiver);
                return Unit.INSTANCE;
            }

            public final void invoke2(EventReceiver mapEvents) {
                Intrinsics.checkNotNullParameter(mapEvents, "$this$mapEvents");
                final Effect.PushTokenUpdateResult pushTokenUpdateResult = effect;
                mapEvents.event(new Function0<ConversationKitEvent>() {
                    {
                        super(0);
                    }

                    @Override
                    public final ConversationKitEvent invoke() {
                        return new ConversationKitEvent.PushTokenUpdateResult(pushTokenUpdateResult.getResult(), pushTokenUpdateResult.getPushToken());
                    }
                });
            }
        });
    }

    private final List<ConversationKitEvent> mapActivityEvent(final Effect.ActivityEventReceived effect) {
        return EffectMapperKt.mapEvents(new Function1<EventReceiver, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(EventReceiver eventReceiver) {
                invoke2(eventReceiver);
                return Unit.INSTANCE;
            }

            public final void invoke2(EventReceiver mapEvents) {
                Intrinsics.checkNotNullParameter(mapEvents, "$this$mapEvents");
                final Effect.ActivityEventReceived activityEventReceived = effect;
                mapEvents.event(new Function0<ConversationKitEvent>() {
                    {
                        super(0);
                    }

                    @Override
                    public final ConversationKitEvent invoke() {
                        return new ConversationKitEvent.ActivityEventReceived(activityEventReceived.getActivityEvent());
                    }
                });
                mapEvents.event(effect.getConversation(), new Function1<Conversation, ConversationKitEvent>() {
                    @Override
                    public final ConversationKitEvent invoke(Conversation conversation) {
                        Intrinsics.checkNotNullParameter(conversation, "conversation");
                        return new ConversationKitEvent.ConversationUpdated(conversation);
                    }
                });
            }
        });
    }

    private final List<ConversationKitEvent> mapPersistedUserReceived(final Effect.PersistedUserReceived effect) {
        return EffectMapperKt.mapEvents(new Function1<EventReceiver, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(EventReceiver eventReceiver) {
                invoke2(eventReceiver);
                return Unit.INSTANCE;
            }

            public final void invoke2(EventReceiver mapEvents) {
                Intrinsics.checkNotNullParameter(mapEvents, "$this$mapEvents");
                final Effect.PersistedUserReceived persistedUserReceived = effect;
                mapEvents.event(new Function0<ConversationKitEvent>() {
                    {
                        super(0);
                    }

                    @Override
                    public final ConversationKitEvent invoke() {
                        return new ConversationKitEvent.PersistedUserReceived(persistedUserReceived.getUser());
                    }
                });
            }
        });
    }

    private final List<ConversationKitEvent> mapConversationAdded(final Effect.ConversationAddedResult effect) {
        return EffectMapperKt.mapEvents(new Function1<EventReceiver, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(EventReceiver eventReceiver) {
                invoke2(eventReceiver);
                return Unit.INSTANCE;
            }

            public final void invoke2(EventReceiver mapEvents) {
                Intrinsics.checkNotNullParameter(mapEvents, "$this$mapEvents");
                ConversationKitResult<Conversation> result = effect.getResult();
                if (result instanceof ConversationKitResult.Success) {
                    final Effect.ConversationAddedResult conversationAddedResult = effect;
                    mapEvents.event(new Function0<ConversationKitEvent>() {
                        {
                            super(0);
                        }

                        @Override
                        public final ConversationKitEvent invoke() {
                            return new ConversationKitEvent.ConversationAddedSuccess((Conversation) ((ConversationKitResult.Success) conversationAddedResult.getResult()).getValue());
                        }
                    });
                } else if (result instanceof ConversationKitResult.Failure) {
                    final Effect.ConversationAddedResult conversationAddedResult2 = effect;
                    mapEvents.event(new Function0<ConversationKitEvent>() {
                        {
                            super(0);
                        }

                        @Override
                        public final ConversationKitEvent invoke() {
                            return new ConversationKitEvent.ConversationAddedFailure(((ConversationKitResult.Failure) conversationAddedResult2.getResult()).getCause());
                        }
                    });
                }
            }
        });
    }

    private final List<ConversationKitEvent> mapConversationRemoved(final Effect.ConversationRemovedResult effect) {
        return EffectMapperKt.mapEvents(new Function1<EventReceiver, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(EventReceiver eventReceiver) {
                invoke2(eventReceiver);
                return Unit.INSTANCE;
            }

            public final void invoke2(EventReceiver mapEvents) {
                Intrinsics.checkNotNullParameter(mapEvents, "$this$mapEvents");
                ConversationKitResult<String> result = effect.getResult();
                if (result instanceof ConversationKitResult.Success) {
                    final Effect.ConversationRemovedResult conversationRemovedResult = effect;
                    mapEvents.event(new Function0<ConversationKitEvent>() {
                        {
                            super(0);
                        }

                        @Override
                        public final ConversationKitEvent invoke() {
                            return new ConversationKitEvent.ConversationRemovedSuccess((String) ((ConversationKitResult.Success) conversationRemovedResult.getResult()).getValue());
                        }
                    });
                } else if (result instanceof ConversationKitResult.Failure) {
                    final Effect.ConversationRemovedResult conversationRemovedResult2 = effect;
                    mapEvents.event(new Function0<ConversationKitEvent>() {
                        {
                            super(0);
                        }

                        @Override
                        public final ConversationKitEvent invoke() {
                            return new ConversationKitEvent.ConversationRemovedFailure(((ConversationKitResult.Failure) conversationRemovedResult2.getResult()).getCause());
                        }
                    });
                }
            }
        });
    }

    private final List<ConversationKitEvent> mapConversationUpdated(final Effect.ConversationUpdatedResult effect) {
        return EffectMapperKt.mapEvents(new Function1<EventReceiver, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(EventReceiver eventReceiver) {
                invoke2(eventReceiver);
                return Unit.INSTANCE;
            }

            public final void invoke2(EventReceiver mapEvents) {
                Intrinsics.checkNotNullParameter(mapEvents, "$this$mapEvents");
                final ConversationKitResult<Conversation> result = effect.getResult();
                if (result instanceof ConversationKitResult.Success) {
                    mapEvents.event(new Function0<ConversationKitEvent>() {
                        {
                            super(0);
                        }

                        @Override
                        public final ConversationKitEvent invoke() {
                            return new ConversationKitEvent.ConversationUpdated((Conversation) ((ConversationKitResult.Success) result).getValue());
                        }
                    });
                } else if (result instanceof ConversationKitResult.Failure) {
                    mapEvents.event(new Function0<ConversationKitEvent>() {
                        {
                            super(0);
                        }

                        @Override
                        public final ConversationKitEvent invoke() {
                            return new ConversationKitEvent.ConversationUpdatedFailure(((ConversationKitResult.Failure) result).getCause());
                        }
                    });
                }
            }
        });
    }

    private final List<ConversationKitEvent> mapPostbackSent(final Effect.SendPostbackResult effect) {
        return EffectMapperKt.mapEvents(new Function1<EventReceiver, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(EventReceiver eventReceiver) {
                invoke2(eventReceiver);
                return Unit.INSTANCE;
            }

            public final void invoke2(EventReceiver mapEvents) {
                Intrinsics.checkNotNullParameter(mapEvents, "$this$mapEvents");
                final ConversationKitResult<String> result = effect.getResult();
                if (result instanceof ConversationKitResult.Success) {
                    mapEvents.event(new Function0<ConversationKitEvent>() {
                        {
                            super(0);
                        }

                        @Override
                        public final ConversationKitEvent invoke() {
                            return new ConversationKitEvent.PostbackSuccess((String) ((ConversationKitResult.Success) result).getValue());
                        }
                    });
                } else if (result instanceof ConversationKitResult.Failure) {
                    mapEvents.event(new Function0<ConversationKitEvent>() {
                        {
                            super(0);
                        }

                        @Override
                        public final ConversationKitEvent invoke() {
                            return new ConversationKitEvent.PostbackFailure(((ConversationKitResult.Failure) result).getCause());
                        }
                    });
                }
            }
        });
    }

    private final List<ConversationKitEvent> mapAttachmentDownloadStarted(final Effect.AttachmentDownloadStarted effect) {
        return EffectMapperKt.mapEvents(new Function1<EventReceiver, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(EventReceiver eventReceiver) {
                invoke2(eventReceiver);
                return Unit.INSTANCE;
            }

            public final void invoke2(EventReceiver mapEvents) {
                Intrinsics.checkNotNullParameter(mapEvents, "$this$mapEvents");
                mapEvents.event(effect.getConversation(), new Function1<Conversation, ConversationKitEvent>() {
                    @Override
                    public final ConversationKitEvent invoke(Conversation conversation) {
                        Intrinsics.checkNotNullParameter(conversation, "conversation");
                        return new ConversationKitEvent.ConversationUpdated(conversation);
                    }
                });
            }
        });
    }

    private final List<ConversationKitEvent> mapOpenAttachmentFromFile(final Effect.OpenAttachmentFromFile effect) {
        return EffectMapperKt.mapEvents(new Function1<EventReceiver, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(EventReceiver eventReceiver) {
                invoke2(eventReceiver);
                return Unit.INSTANCE;
            }

            public final void invoke2(EventReceiver mapEvents) {
                Intrinsics.checkNotNullParameter(mapEvents, "$this$mapEvents");
                final Effect.OpenAttachmentFromFile openAttachmentFromFile = effect;
                mapEvents.event(new Function0<ConversationKitEvent>() {
                    {
                        super(0);
                    }

                    @Override
                    public final ConversationKitEvent invoke() {
                        return new ConversationKitEvent.OpenFileAttachment(openAttachmentFromFile.getFile(), openAttachmentFromFile.getConversationId());
                    }
                });
            }
        });
    }
}
