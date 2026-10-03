package zendesk.conversationkit.android.internal.user.data;

import java.net.UnknownHostException;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;
import zendesk.conversationkit.android.internal.ConnectivityObserver;
import zendesk.conversationkit.android.internal.user.UserExtensionsKt;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.conversationkit.android.model.User;

@Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/conversationkit/android/model/Conversation;", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository$refreshConversation$conversation$1", m37f = "UserActionProcessorRepository.kt", m38i = {}, m39l = {143, 145, 146, 144, 143, 145, 146, 144}, m40m = "invokeSuspend", m41n = {}, m42s = {})
final class UserActionProcessorRepository$refreshConversation$conversation$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Conversation>, Object> {
    final String $conversationId;
    Object L$0;
    Object L$1;
    Object L$2;
    Object L$3;
    int label;
    final UserActionProcessorRepository this$0;

    UserActionProcessorRepository$refreshConversation$conversation$1(UserActionProcessorRepository userActionProcessorRepository, String str, Continuation<? super UserActionProcessorRepository$refreshConversation$conversation$1> continuation) {
        super(2, continuation);
        this.this$0 = userActionProcessorRepository;
        this.$conversationId = str;
    }

    @Override
    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new UserActionProcessorRepository$refreshConversation$conversation$1(this.this$0, this.$conversationId, continuation);
    }

    @Override
    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Conversation> continuation) {
        return ((UserActionProcessorRepository$refreshConversation$conversation$1) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        UserActionProcessorRepository userActionProcessorRepository;
        ConnectivityObserver connectivityObserver;
        ?? r1;
        UserActionProcessorRepository userActionProcessorRepository2;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource;
        Object user;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource2;
        ?? r2;
        String authorization;
        Object user2;
        String str;
        ?? r4;
        ?? r3;
        String str2;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource3;
        Object user3;
        String str3;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource4;
        String authorization2;
        Object user4;
        String str4;
        UserActionProcessorRepository userActionProcessorRepository3;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource5;
        String str5;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        ?? r5 = this.label;
        try {
            switch (r5) {
                case 0:
                    ResultKt.throwOnFailure(obj);
                    userActionProcessorRepository = this.this$0;
                    str2 = this.$conversationId;
                    try {
                        ConnectivityObserver connectivityObserver2 = userActionProcessorRepository.connectivityObserver;
                        this.L$0 = userActionProcessorRepository;
                        this.L$1 = str2;
                        this.label = 1;
                        if (connectivityObserver2.awaitConnection(this) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        userActionProcessorRemoteDataSource3 = userActionProcessorRepository.userActionProcessorRemoteDataSource;
                        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource = userActionProcessorRepository.userActionProcessorInMemoryDataSource;
                        this.L$0 = userActionProcessorRepository;
                        this.L$1 = str2;
                        this.L$2 = userActionProcessorRemoteDataSource3;
                        this.label = 2;
                        user3 = userActionProcessorInMemoryDataSource.getUser(this);
                        if (user3 == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        str3 = str2;
                        obj = user3;
                        userActionProcessorRemoteDataSource4 = userActionProcessorRemoteDataSource3;
                        authorization2 = UserExtensionsKt.getAuthorization((User) obj);
                        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource2 = userActionProcessorRepository.userActionProcessorInMemoryDataSource;
                        this.L$0 = userActionProcessorRepository;
                        this.L$1 = str3;
                        this.L$2 = userActionProcessorRemoteDataSource4;
                        this.L$3 = authorization2;
                        this.label = 3;
                        user4 = userActionProcessorInMemoryDataSource2.getUser(this);
                        if (user4 == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        String str6 = str3;
                        str4 = authorization2;
                        obj = user4;
                        userActionProcessorRepository3 = userActionProcessorRepository;
                        userActionProcessorRemoteDataSource5 = userActionProcessorRemoteDataSource4;
                        str5 = str6;
                        String id = ((User) obj).getId();
                        this.L$0 = userActionProcessorRepository3;
                        this.L$1 = str5;
                        this.L$2 = null;
                        this.L$3 = null;
                        this.label = 4;
                        obj = userActionProcessorRemoteDataSource5.getConversation(str4, str5, id, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        r5 = str5;
                        userActionProcessorRepository = userActionProcessorRepository3;
                        return (Conversation) obj;
                    } catch (UnknownHostException unused) {
                        r5 = str2;
                        connectivityObserver = userActionProcessorRepository.connectivityObserver;
                        this.L$0 = userActionProcessorRepository;
                        this.L$1 = r5;
                        this.L$2 = null;
                        this.L$3 = null;
                        this.label = 5;
                        r1 = r5;
                        if (connectivityObserver.awaitConnection(this) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        userActionProcessorRepository2 = userActionProcessorRepository;
                        userActionProcessorRemoteDataSource = userActionProcessorRepository2.userActionProcessorRemoteDataSource;
                        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource3 = userActionProcessorRepository2.userActionProcessorInMemoryDataSource;
                        this.L$0 = userActionProcessorRepository2;
                        this.L$1 = r1;
                        this.L$2 = userActionProcessorRemoteDataSource;
                        this.label = 6;
                        user = userActionProcessorInMemoryDataSource3.getUser(this);
                        if (user == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        userActionProcessorRemoteDataSource2 = userActionProcessorRemoteDataSource;
                        obj = user;
                        r2 = r1;
                        authorization = UserExtensionsKt.getAuthorization((User) obj);
                        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource4 = userActionProcessorRepository2.userActionProcessorInMemoryDataSource;
                        this.L$0 = r2;
                        this.L$1 = userActionProcessorRemoteDataSource2;
                        this.L$2 = authorization;
                        this.label = 7;
                        user2 = userActionProcessorInMemoryDataSource4.getUser(this);
                        if (user2 == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        ?? r7 = r2;
                        str = authorization;
                        obj = user2;
                        r4 = r7;
                        r3 = userActionProcessorRemoteDataSource2;
                        String id2 = ((User) obj).getId();
                        this.L$0 = null;
                        this.L$1 = null;
                        this.L$2 = null;
                        this.label = 8;
                        obj = r3.getConversation(str, r4, id2, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Conversation) obj;
                    }
                case 1:
                    String str7 = (String) this.L$1;
                    userActionProcessorRepository = (UserActionProcessorRepository) this.L$0;
                    ResultKt.throwOnFailure(obj);
                    str2 = str7;
                    userActionProcessorRemoteDataSource3 = userActionProcessorRepository.userActionProcessorRemoteDataSource;
                    UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource5 = userActionProcessorRepository.userActionProcessorInMemoryDataSource;
                    this.L$0 = userActionProcessorRepository;
                    this.L$1 = str2;
                    this.L$2 = userActionProcessorRemoteDataSource3;
                    this.label = 2;
                    user3 = userActionProcessorInMemoryDataSource5.getUser(this);
                    if (user3 == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    str3 = str2;
                    obj = user3;
                    userActionProcessorRemoteDataSource4 = userActionProcessorRemoteDataSource3;
                    authorization2 = UserExtensionsKt.getAuthorization((User) obj);
                    UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource6 = userActionProcessorRepository.userActionProcessorInMemoryDataSource;
                    this.L$0 = userActionProcessorRepository;
                    this.L$1 = str3;
                    this.L$2 = userActionProcessorRemoteDataSource4;
                    this.L$3 = authorization2;
                    this.label = 3;
                    user4 = userActionProcessorInMemoryDataSource6.getUser(this);
                    if (user4 == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    String str8 = str3;
                    str4 = authorization2;
                    obj = user4;
                    userActionProcessorRepository3 = userActionProcessorRepository;
                    userActionProcessorRemoteDataSource5 = userActionProcessorRemoteDataSource4;
                    str5 = str8;
                    String id3 = ((User) obj).getId();
                    this.L$0 = userActionProcessorRepository3;
                    this.L$1 = str5;
                    this.L$2 = null;
                    this.L$3 = null;
                    this.label = 4;
                    obj = userActionProcessorRemoteDataSource5.getConversation(str4, str5, id3, this);
                    if (obj == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    r5 = str5;
                    userActionProcessorRepository = userActionProcessorRepository3;
                    return (Conversation) obj;
                case 2:
                    UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource6 = (UserActionProcessorRemoteDataSource) this.L$2;
                    String str9 = (String) this.L$1;
                    UserActionProcessorRepository userActionProcessorRepository4 = (UserActionProcessorRepository) this.L$0;
                    try {
                        ResultKt.throwOnFailure(obj);
                        userActionProcessorRemoteDataSource4 = userActionProcessorRemoteDataSource6;
                        str3 = str9;
                        userActionProcessorRepository = userActionProcessorRepository4;
                        authorization2 = UserExtensionsKt.getAuthorization((User) obj);
                        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource7 = userActionProcessorRepository.userActionProcessorInMemoryDataSource;
                        this.L$0 = userActionProcessorRepository;
                        this.L$1 = str3;
                        this.L$2 = userActionProcessorRemoteDataSource4;
                        this.L$3 = authorization2;
                        this.label = 3;
                        user4 = userActionProcessorInMemoryDataSource7.getUser(this);
                        if (user4 == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        String str10 = str3;
                        str4 = authorization2;
                        obj = user4;
                        userActionProcessorRepository3 = userActionProcessorRepository;
                        userActionProcessorRemoteDataSource5 = userActionProcessorRemoteDataSource4;
                        str5 = str10;
                        String id4 = ((User) obj).getId();
                        this.L$0 = userActionProcessorRepository3;
                        this.L$1 = str5;
                        this.L$2 = null;
                        this.L$3 = null;
                        this.label = 4;
                        obj = userActionProcessorRemoteDataSource5.getConversation(str4, str5, id4, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        r5 = str5;
                        userActionProcessorRepository = userActionProcessorRepository3;
                        return (Conversation) obj;
                    } catch (UnknownHostException unused2) {
                        r5 = str9;
                        userActionProcessorRepository = userActionProcessorRepository4;
                        connectivityObserver = userActionProcessorRepository.connectivityObserver;
                        this.L$0 = userActionProcessorRepository;
                        this.L$1 = r5;
                        this.L$2 = null;
                        this.L$3 = null;
                        this.label = 5;
                        r1 = r5;
                        if (connectivityObserver.awaitConnection(this) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        userActionProcessorRepository2 = userActionProcessorRepository;
                        userActionProcessorRemoteDataSource = userActionProcessorRepository2.userActionProcessorRemoteDataSource;
                        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource8 = userActionProcessorRepository2.userActionProcessorInMemoryDataSource;
                        this.L$0 = userActionProcessorRepository2;
                        this.L$1 = r1;
                        this.L$2 = userActionProcessorRemoteDataSource;
                        this.label = 6;
                        user = userActionProcessorInMemoryDataSource8.getUser(this);
                        if (user == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        userActionProcessorRemoteDataSource2 = userActionProcessorRemoteDataSource;
                        obj = user;
                        r2 = r1;
                        authorization = UserExtensionsKt.getAuthorization((User) obj);
                        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource9 = userActionProcessorRepository2.userActionProcessorInMemoryDataSource;
                        this.L$0 = r2;
                        this.L$1 = userActionProcessorRemoteDataSource2;
                        this.L$2 = authorization;
                        this.label = 7;
                        user2 = userActionProcessorInMemoryDataSource9.getUser(this);
                        if (user2 == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        ?? r8 = r2;
                        str = authorization;
                        obj = user2;
                        r4 = r8;
                        r3 = userActionProcessorRemoteDataSource2;
                        String id5 = ((User) obj).getId();
                        this.L$0 = null;
                        this.L$1 = null;
                        this.L$2 = null;
                        this.label = 8;
                        obj = r3.getConversation(str, r4, id5, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Conversation) obj;
                    }
                case 3:
                    str4 = (String) this.L$3;
                    userActionProcessorRemoteDataSource5 = (UserActionProcessorRemoteDataSource) this.L$2;
                    str5 = (String) this.L$1;
                    userActionProcessorRepository3 = (UserActionProcessorRepository) this.L$0;
                    try {
                        ResultKt.throwOnFailure(obj);
                        String id6 = ((User) obj).getId();
                        this.L$0 = userActionProcessorRepository3;
                        this.L$1 = str5;
                        this.L$2 = null;
                        this.L$3 = null;
                        this.label = 4;
                        obj = userActionProcessorRemoteDataSource5.getConversation(str4, str5, id6, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        r5 = str5;
                        userActionProcessorRepository = userActionProcessorRepository3;
                        return (Conversation) obj;
                    } catch (UnknownHostException unused3) {
                        r5 = str5;
                        userActionProcessorRepository = userActionProcessorRepository3;
                        connectivityObserver = userActionProcessorRepository.connectivityObserver;
                        this.L$0 = userActionProcessorRepository;
                        this.L$1 = r5;
                        this.L$2 = null;
                        this.L$3 = null;
                        this.label = 5;
                        r1 = r5;
                        if (connectivityObserver.awaitConnection(this) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        userActionProcessorRepository2 = userActionProcessorRepository;
                        userActionProcessorRemoteDataSource = userActionProcessorRepository2.userActionProcessorRemoteDataSource;
                        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource10 = userActionProcessorRepository2.userActionProcessorInMemoryDataSource;
                        this.L$0 = userActionProcessorRepository2;
                        this.L$1 = r1;
                        this.L$2 = userActionProcessorRemoteDataSource;
                        this.label = 6;
                        user = userActionProcessorInMemoryDataSource10.getUser(this);
                        if (user == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        userActionProcessorRemoteDataSource2 = userActionProcessorRemoteDataSource;
                        obj = user;
                        r2 = r1;
                        authorization = UserExtensionsKt.getAuthorization((User) obj);
                        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource11 = userActionProcessorRepository2.userActionProcessorInMemoryDataSource;
                        this.L$0 = r2;
                        this.L$1 = userActionProcessorRemoteDataSource2;
                        this.L$2 = authorization;
                        this.label = 7;
                        user2 = userActionProcessorInMemoryDataSource11.getUser(this);
                        if (user2 == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        ?? r9 = r2;
                        str = authorization;
                        obj = user2;
                        r4 = r9;
                        r3 = userActionProcessorRemoteDataSource2;
                        String id7 = ((User) obj).getId();
                        this.L$0 = null;
                        this.L$1 = null;
                        this.L$2 = null;
                        this.label = 8;
                        obj = r3.getConversation(str, r4, id7, this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Conversation) obj;
                    }
                case 4:
                    String str11 = (String) this.L$1;
                    userActionProcessorRepository = (UserActionProcessorRepository) this.L$0;
                    ResultKt.throwOnFailure(obj);
                    r5 = str11;
                    return (Conversation) obj;
                case 5:
                    String str12 = (String) this.L$1;
                    userActionProcessorRepository = (UserActionProcessorRepository) this.L$0;
                    ResultKt.throwOnFailure(obj);
                    r1 = str12;
                    userActionProcessorRepository2 = userActionProcessorRepository;
                    userActionProcessorRemoteDataSource = userActionProcessorRepository2.userActionProcessorRemoteDataSource;
                    UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource12 = userActionProcessorRepository2.userActionProcessorInMemoryDataSource;
                    this.L$0 = userActionProcessorRepository2;
                    this.L$1 = r1;
                    this.L$2 = userActionProcessorRemoteDataSource;
                    this.label = 6;
                    user = userActionProcessorInMemoryDataSource12.getUser(this);
                    if (user == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    userActionProcessorRemoteDataSource2 = userActionProcessorRemoteDataSource;
                    obj = user;
                    r2 = r1;
                    authorization = UserExtensionsKt.getAuthorization((User) obj);
                    UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource13 = userActionProcessorRepository2.userActionProcessorInMemoryDataSource;
                    this.L$0 = r2;
                    this.L$1 = userActionProcessorRemoteDataSource2;
                    this.L$2 = authorization;
                    this.label = 7;
                    user2 = userActionProcessorInMemoryDataSource13.getUser(this);
                    if (user2 == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    ?? r10 = r2;
                    str = authorization;
                    obj = user2;
                    r4 = r10;
                    r3 = userActionProcessorRemoteDataSource2;
                    String id8 = ((User) obj).getId();
                    this.L$0 = null;
                    this.L$1 = null;
                    this.L$2 = null;
                    this.label = 8;
                    obj = r3.getConversation(str, r4, id8, this);
                    if (obj == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    return (Conversation) obj;
                case 6:
                    UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource7 = (UserActionProcessorRemoteDataSource) this.L$2;
                    String str13 = (String) this.L$1;
                    userActionProcessorRepository2 = (UserActionProcessorRepository) this.L$0;
                    ResultKt.throwOnFailure(obj);
                    userActionProcessorRemoteDataSource2 = userActionProcessorRemoteDataSource7;
                    r2 = str13;
                    authorization = UserExtensionsKt.getAuthorization((User) obj);
                    UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource14 = userActionProcessorRepository2.userActionProcessorInMemoryDataSource;
                    this.L$0 = r2;
                    this.L$1 = userActionProcessorRemoteDataSource2;
                    this.L$2 = authorization;
                    this.label = 7;
                    user2 = userActionProcessorInMemoryDataSource14.getUser(this);
                    if (user2 == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    ?? r11 = r2;
                    str = authorization;
                    obj = user2;
                    r4 = r11;
                    r3 = userActionProcessorRemoteDataSource2;
                    String id9 = ((User) obj).getId();
                    this.L$0 = null;
                    this.L$1 = null;
                    this.L$2 = null;
                    this.label = 8;
                    obj = r3.getConversation(str, r4, id9, this);
                    if (obj == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    return (Conversation) obj;
                case 7:
                    str = (String) this.L$2;
                    UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource8 = (UserActionProcessorRemoteDataSource) this.L$1;
                    String str14 = (String) this.L$0;
                    ResultKt.throwOnFailure(obj);
                    r3 = userActionProcessorRemoteDataSource8;
                    r4 = str14;
                    String id10 = ((User) obj).getId();
                    this.L$0 = null;
                    this.L$1 = null;
                    this.L$2 = null;
                    this.label = 8;
                    obj = r3.getConversation(str, r4, id10, this);
                    if (obj == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    return (Conversation) obj;
                case 8:
                    ResultKt.throwOnFailure(obj);
                    return (Conversation) obj;
                default:
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
        } catch (UnknownHostException unused4) {
        }
    }
}
