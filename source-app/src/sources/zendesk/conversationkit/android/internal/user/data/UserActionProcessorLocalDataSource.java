package zendesk.conversationkit.android.internal.user.data;

import java.util.List;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.internal.ConversationKitStorage;
import zendesk.conversationkit.android.internal.app.AppStorage;
import zendesk.conversationkit.android.internal.proactivemessaging.ProactiveMessagingStorage;
import zendesk.conversationkit.android.internal.rest.RestClientFiles;
import zendesk.conversationkit.android.internal.user.UserStorage;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.conversationkit.android.model.ProactiveMessage;
import zendesk.conversationkit.android.model.User;
import zendesk.conversationkit.android.model.VisitType;

@Metadata(m17d1 = {"\u0000^\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0012\b\u0000\u0018\u00002\u00020\u0001B-\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t\u0012\u0006\u0010\n\u001a\u00020\u000b¢\u0006\u0002\u0010\fJ\u000e\u0010\r\u001a\u00020\u000eH\u0086@¢\u0006\u0002\u0010\u000fJ\u0016\u0010\u0010\u001a\u00020\u000e2\u0006\u0010\u0011\u001a\u00020\u0012H\u0086@¢\u0006\u0002\u0010\u0013J\u000e\u0010\u0014\u001a\u00020\u0015H\u0086@¢\u0006\u0002\u0010\u000fJ\u0018\u0010\u0016\u001a\u0004\u0018\u00010\u00172\u0006\u0010\u0018\u001a\u00020\u0015H\u0086@¢\u0006\u0002\u0010\u0019J\u0018\u0010\u001a\u001a\u0004\u0018\u00010\u001b2\u0006\u0010\u0011\u001a\u00020\u0012H\u0086@¢\u0006\u0002\u0010\u0013J\u0010\u0010\u001c\u001a\u0004\u0018\u00010\u0015H\u0086@¢\u0006\u0002\u0010\u000fJ\u0010\u0010\u001d\u001a\u0004\u0018\u00010\u001eH\u0086@¢\u0006\u0002\u0010\u000fJ\u000e\u0010\u001f\u001a\u00020 H\u0086@¢\u0006\u0002\u0010\u000fJ\u0016\u0010!\u001a\u00020\u000e2\u0006\u0010\u0018\u001a\u00020\u0015H\u0086@¢\u0006\u0002\u0010\u0019J\u0016\u0010\"\u001a\u00020\u000e2\u0006\u0010#\u001a\u00020\u0017H\u0086@¢\u0006\u0002\u0010$J\u0016\u0010%\u001a\u00020\u000e2\u0006\u0010&\u001a\u00020\u0015H\u0086@¢\u0006\u0002\u0010\u0019J\u0016\u0010'\u001a\u00020\u000e2\u0006\u0010(\u001a\u00020\u001bH\u0086@¢\u0006\u0002\u0010)J\u0016\u0010*\u001a\u00020\u000e2\u0006\u0010+\u001a\u00020\u0015H\u0086@¢\u0006\u0002\u0010\u0019J\u0016\u0010,\u001a\u00020\u000e2\u0006\u0010-\u001a\u00020 H\u0086@¢\u0006\u0002\u0010.J\u0016\u0010/\u001a\u00020\u000e2\u0006\u00100\u001a\u00020\u001eH\u0086@¢\u0006\u0002\u00101R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\u000bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u00062"}, m18d2 = {"Lzendesk/conversationkit/android/internal/user/data/UserActionProcessorLocalDataSource;", "", "userStorage", "Lzendesk/conversationkit/android/internal/user/UserStorage;", "appStorage", "Lzendesk/conversationkit/android/internal/app/AppStorage;", "conversationKitStorage", "Lzendesk/conversationkit/android/internal/ConversationKitStorage;", "proactiveMessagingStorage", "Lzendesk/conversationkit/android/internal/proactivemessaging/ProactiveMessagingStorage;", "restClientFiles", "Lzendesk/conversationkit/android/internal/rest/RestClientFiles;", "(Lzendesk/conversationkit/android/internal/user/UserStorage;Lzendesk/conversationkit/android/internal/app/AppStorage;Lzendesk/conversationkit/android/internal/ConversationKitStorage;Lzendesk/conversationkit/android/internal/proactivemessaging/ProactiveMessagingStorage;Lzendesk/conversationkit/android/internal/rest/RestClientFiles;)V", "clear", "", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "clearProactiveMessage", "proactiveMessageId", "", "(ILkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getClientId", "", "getConversation", "Lzendesk/conversationkit/android/model/Conversation;", "conversationId", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getProactiveMessage", "Lzendesk/conversationkit/android/model/ProactiveMessage;", "getPushToken", "getUser", "Lzendesk/conversationkit/android/model/User;", "getVisitType", "Lzendesk/conversationkit/android/model/VisitType;", "removeConversationById", "saveConversation", "conversation", "(Lzendesk/conversationkit/android/model/Conversation;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "setIntegrationId", "integrationId", "setProactiveMessage", "proactiveMessage", "(Lzendesk/conversationkit/android/model/ProactiveMessage;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "setPushToken", "pushToken", "setVisitType", "visitType", "(Lzendesk/conversationkit/android/model/VisitType;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "updateUser", "newUser", "(Lzendesk/conversationkit/android/model/User;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class UserActionProcessorLocalDataSource {
    private final AppStorage appStorage;
    private final ConversationKitStorage conversationKitStorage;
    private final ProactiveMessagingStorage proactiveMessagingStorage;
    private final RestClientFiles restClientFiles;
    private final UserStorage userStorage;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorLocalDataSource", m37f = "UserActionProcessorLocalDataSource.kt", m38i = {0, 1}, m39l = {100, 101, 103}, m40m = "clear", m41n = {"this", "this"}, m42s = {"L$0", "L$0"})
    static final class C11761 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C11761(Continuation<? super C11761> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorLocalDataSource.this.clear(this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorLocalDataSource", m37f = "UserActionProcessorLocalDataSource.kt", m38i = {0, 0, 1}, m39l = {92, 93}, m40m = "getConversation", m41n = {"this", "conversationId", "conversationId"}, m42s = {"L$0", "L$1", "L$0"})
    static final class C11771 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C11771(Continuation<? super C11771> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorLocalDataSource.this.getConversation(null, this);
        }
    }

    public UserActionProcessorLocalDataSource(UserStorage userStorage, AppStorage appStorage, ConversationKitStorage conversationKitStorage, ProactiveMessagingStorage proactiveMessagingStorage, RestClientFiles restClientFiles) {
        Intrinsics.checkNotNullParameter(userStorage, "userStorage");
        Intrinsics.checkNotNullParameter(appStorage, "appStorage");
        Intrinsics.checkNotNullParameter(conversationKitStorage, "conversationKitStorage");
        Intrinsics.checkNotNullParameter(proactiveMessagingStorage, "proactiveMessagingStorage");
        Intrinsics.checkNotNullParameter(restClientFiles, "restClientFiles");
        this.userStorage = userStorage;
        this.appStorage = appStorage;
        this.conversationKitStorage = conversationKitStorage;
        this.proactiveMessagingStorage = proactiveMessagingStorage;
        this.restClientFiles = restClientFiles;
    }

    public final Object getClientId(Continuation<? super String> continuation) {
        return this.conversationKitStorage.getClientId(continuation);
    }

    public final Object getPushToken(Continuation<? super String> continuation) {
        return this.conversationKitStorage.getPushToken(continuation);
    }

    public final Object setVisitType(VisitType visitType, Continuation<? super Unit> continuation) {
        Object visitType2 = this.conversationKitStorage.setVisitType(visitType, continuation);
        return visitType2 == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? visitType2 : Unit.INSTANCE;
    }

    public final Object getVisitType(Continuation<? super VisitType> continuation) {
        return this.conversationKitStorage.getVisitType(continuation);
    }

    public final Object updateUser(User user, Continuation<? super Unit> continuation) {
        Object user2 = this.appStorage.setUser(user, continuation);
        return user2 == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? user2 : Unit.INSTANCE;
    }

    public final Object saveConversation(Conversation conversation, Continuation<? super Unit> continuation) {
        Object objSaveConversation = this.userStorage.saveConversation(conversation, continuation);
        return objSaveConversation == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objSaveConversation : Unit.INSTANCE;
    }

    public final Object getConversation(String str, Continuation<? super Conversation> continuation) throws Throwable {
        C11771 c11771;
        UserActionProcessorLocalDataSource userActionProcessorLocalDataSource;
        User user;
        List<Conversation> conversations;
        if (continuation instanceof C11771) {
            c11771 = (C11771) continuation;
            if ((c11771.label & Integer.MIN_VALUE) != 0) {
                c11771.label -= Integer.MIN_VALUE;
            } else {
                c11771 = new C11771(continuation);
            }
        } else {
            c11771 = new C11771(continuation);
        }
        Object conversation = c11771.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11771.label;
        Object obj = null;
        if (i != 0) {
            if (i == 1) {
                str = (String) c11771.L$1;
                userActionProcessorLocalDataSource = (UserActionProcessorLocalDataSource) c11771.L$0;
                ResultKt.throwOnFailure(conversation);
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                str = (String) c11771.L$0;
                ResultKt.throwOnFailure(conversation);
            }
            user = (User) conversation;
            if (user == null && (conversations = user.getConversations()) != null) {
                for (Object obj2 : conversations) {
                    if (Intrinsics.areEqual(((Conversation) obj2).getId(), str)) {
                        obj = obj2;
                        break;
                    }
                }
                return (Conversation) obj;
            }
        }
        ResultKt.throwOnFailure(conversation);
        UserStorage userStorage = this.userStorage;
        c11771.L$0 = this;
        c11771.L$1 = str;
        c11771.label = 1;
        conversation = userStorage.getConversation(str, c11771);
        if (conversation == coroutine_suspended) {
            return coroutine_suspended;
        }
        userActionProcessorLocalDataSource = this;
        Conversation conversation2 = (Conversation) conversation;
        if (conversation2 != null) {
            return conversation2;
        }
        AppStorage appStorage = userActionProcessorLocalDataSource.appStorage;
        c11771.L$0 = str;
        c11771.L$1 = null;
        c11771.label = 2;
        conversation = appStorage.getUser(c11771);
        if (conversation == coroutine_suspended) {
            return coroutine_suspended;
        }
        user = (User) conversation;
        return user == null ? null : null;
    }

    public final Object clear(Continuation<? super Unit> continuation) throws Throwable {
        C11761 c11761;
        UserActionProcessorLocalDataSource userActionProcessorLocalDataSource;
        ProactiveMessagingStorage proactiveMessagingStorage;
        if (continuation instanceof C11761) {
            c11761 = (C11761) continuation;
            if ((c11761.label & Integer.MIN_VALUE) != 0) {
                c11761.label -= Integer.MIN_VALUE;
            } else {
                c11761 = new C11761(continuation);
            }
        } else {
            c11761 = new C11761(continuation);
        }
        Object obj = c11761.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11761.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            UserStorage userStorage = this.userStorage;
            c11761.L$0 = this;
            c11761.label = 1;
            if (userStorage.clear(c11761) == coroutine_suspended) {
                return coroutine_suspended;
            }
            userActionProcessorLocalDataSource = this;
        } else {
            if (i == 1) {
                userActionProcessorLocalDataSource = (UserActionProcessorLocalDataSource) c11761.L$0;
                ResultKt.throwOnFailure(obj);
            } else if (i == 2) {
                userActionProcessorLocalDataSource = (UserActionProcessorLocalDataSource) c11761.L$0;
                ResultKt.throwOnFailure(obj);
                userActionProcessorLocalDataSource.restClientFiles.clearCache();
                proactiveMessagingStorage = userActionProcessorLocalDataSource.proactiveMessagingStorage;
                c11761.L$0 = null;
                c11761.label = 3;
                if (proactiveMessagingStorage.clear(c11761) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 3) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }
        AppStorage appStorage = userActionProcessorLocalDataSource.appStorage;
        c11761.L$0 = userActionProcessorLocalDataSource;
        c11761.label = 2;
        if (appStorage.clearUser(c11761) == coroutine_suspended) {
            return coroutine_suspended;
        }
        userActionProcessorLocalDataSource.restClientFiles.clearCache();
        proactiveMessagingStorage = userActionProcessorLocalDataSource.proactiveMessagingStorage;
        c11761.L$0 = null;
        c11761.label = 3;
        if (proactiveMessagingStorage.clear(c11761) == coroutine_suspended) {
            return coroutine_suspended;
        }
        return Unit.INSTANCE;
    }

    public final Object setPushToken(String str, Continuation<? super Unit> continuation) {
        Object pushToken = this.conversationKitStorage.setPushToken(str, continuation);
        return pushToken == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? pushToken : Unit.INSTANCE;
    }

    public final Object setIntegrationId(String str, Continuation<? super Unit> continuation) {
        Object integrationId = this.conversationKitStorage.setIntegrationId(str, continuation);
        return integrationId == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? integrationId : Unit.INSTANCE;
    }

    public final Object setProactiveMessage(ProactiveMessage proactiveMessage, Continuation<? super Unit> continuation) {
        Object proactiveMessage2 = this.proactiveMessagingStorage.setProactiveMessage(proactiveMessage, continuation);
        return proactiveMessage2 == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? proactiveMessage2 : Unit.INSTANCE;
    }

    public final Object getProactiveMessage(int i, Continuation<? super ProactiveMessage> continuation) {
        return this.proactiveMessagingStorage.getProactiveMessage(i, continuation);
    }

    public final Object clearProactiveMessage(int i, Continuation<? super Unit> continuation) {
        Object objClearProactiveMessage = this.proactiveMessagingStorage.clearProactiveMessage(i, continuation);
        return objClearProactiveMessage == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objClearProactiveMessage : Unit.INSTANCE;
    }

    public final Object removeConversationById(String str, Continuation<? super Unit> continuation) {
        Object objRemoveConversationById = this.userStorage.removeConversationById(str, continuation);
        return objRemoveConversationById == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objRemoveConversationById : Unit.INSTANCE;
    }

    public final Object getUser(Continuation<? super User> continuation) {
        return this.appStorage.getUser(continuation);
    }
}
