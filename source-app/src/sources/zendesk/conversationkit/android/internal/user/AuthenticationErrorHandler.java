package zendesk.conversationkit.android.internal.user;

import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import net.aihelp.data.model.p005cs.ConversationMsg;
import retrofit2.HttpException;
import zendesk.conversationkit.android.ConversationKitResult;
import zendesk.conversationkit.android.ConversationKitResultKt;
import zendesk.conversationkit.android.internal.Effect;
import zendesk.conversationkit.android.internal.exception.JwtIsExpiredException;
import zendesk.conversationkit.android.internal.extension.AuthenticatedUserUtilKt;
import zendesk.conversationkit.android.internal.faye.SunCoFayeClient;
import zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository;
import zendesk.conversationkit.android.model.AuthenticationType;
import zendesk.conversationkit.android.model.User;
import zendesk.core.android.internal.NullabilityKtxKt;

@Metadata(m17d1 = {"\u0000T\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0003\n\u0002\b\u0002\b\u0000\u0018\u00002\u00020\u0001B\u001f\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJ\u000e\u0010\t\u001a\u00020\nH\u0082@¢\u0006\u0002\u0010\u000bJ6\u0010\f\u001a\u00020\r2\b\u0010\u000e\u001a\u0004\u0018\u00010\u000f2\u001c\u0010\u0010\u001a\u0018\b\u0001\u0012\n\u0012\b\u0012\u0004\u0012\u00020\r0\u0012\u0012\u0006\u0012\u0004\u0018\u00010\u00010\u0011H\u0082@¢\u0006\u0002\u0010\u0013J8\u0010\u0014\u001a\u00020\r2\n\b\u0002\u0010\u000e\u001a\u0004\u0018\u00010\u000f2\u001c\u0010\u0010\u001a\u0018\b\u0001\u0012\n\u0012\b\u0012\u0004\u0012\u00020\r0\u0012\u0012\u0006\u0012\u0004\u0018\u00010\u00010\u0011H\u0086@¢\u0006\u0002\u0010\u0013J\u0016\u0010\u0015\u001a\u00020\r2\u0006\u0010\u0016\u001a\u00020\u0017H\u0082@¢\u0006\u0002\u0010\u0018J\u001a\u0010\u0019\u001a\u00020\u001a2\n\b\u0002\u0010\u001b\u001a\u0004\u0018\u00010\u001cH\u0086@¢\u0006\u0002\u0010\u001dR\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u001e"}, m18d2 = {"Lzendesk/conversationkit/android/internal/user/AuthenticationErrorHandler;", "", "userActionProcessorRepository", "Lzendesk/conversationkit/android/internal/user/data/UserActionProcessorRepository;", "sunCoFayeClient", "Lzendesk/conversationkit/android/internal/faye/SunCoFayeClient;", "jwtDecoder", "Lzendesk/conversationkit/android/internal/user/Jwt$Decoder;", "(Lzendesk/conversationkit/android/internal/user/data/UserActionProcessorRepository;Lzendesk/conversationkit/android/internal/faye/SunCoFayeClient;Lzendesk/conversationkit/android/internal/user/Jwt$Decoder;)V", "clearStorageAndDisconnectFromFaye", "", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "decodeJwtAndCheckExpiration", "Lzendesk/conversationkit/android/internal/Effect;", "jwt", "", "block", "Lkotlin/Function1;", "Lkotlin/coroutines/Continuation;", "(Ljava/lang/String;Lkotlin/jvm/functions/Function1;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "executeWithAuthErrorHandling", "reAuthenticateUser", "exception", "Lretrofit2/HttpException;", "(Lretrofit2/HttpException;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "revokeUser", "Lzendesk/conversationkit/android/internal/Effect$UserAccessRevoked;", "throwable", "", "(Ljava/lang/Throwable;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class AuthenticationErrorHandler {
    private final Jwt.Decoder jwtDecoder;
    private final SunCoFayeClient sunCoFayeClient;
    private final UserActionProcessorRepository userActionProcessorRepository;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.AuthenticationErrorHandler", m37f = "AuthenticationErrorHandler.kt", m38i = {0, 0, 0, 1, 2, 3}, m39l = {51, 55, 58, 61, 67, ConversationMsg.TYPE_USER_VIDEO}, m40m = "executeWithAuthErrorHandling", m41n = {"this", "jwt", "block", "this", "this", "this"}, m42s = {"L$0", "L$1", "L$2", "L$0", "L$0", "L$0"})
    static final class C10941 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C10941(Continuation<? super C10941> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return AuthenticationErrorHandler.this.executeWithAuthErrorHandling(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.AuthenticationErrorHandler", m37f = "AuthenticationErrorHandler.kt", m38i = {0, 0, 1, 1, 2, 2, 3, 3}, m39l = {130, 131, 132, 133, 134, 136}, m40m = "reAuthenticateUser", m41n = {"this", "exception", "this", "exception", "this", "exception", "this", "exception"}, m42s = {"L$0", "L$1", "L$0", "L$1", "L$0", "L$1", "L$0", "L$1"})
    static final class C10951 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C10951(Continuation<? super C10951> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return AuthenticationErrorHandler.this.reAuthenticateUser(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.AuthenticationErrorHandler", m37f = "AuthenticationErrorHandler.kt", m38i = {0}, m39l = {115}, m40m = "revokeUser", m41n = {"throwable"}, m42s = {"L$0"})
    static final class C10961 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C10961(Continuation<? super C10961> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return AuthenticationErrorHandler.this.revokeUser(null, this);
        }
    }

    public AuthenticationErrorHandler(UserActionProcessorRepository userActionProcessorRepository, SunCoFayeClient sunCoFayeClient, Jwt.Decoder jwtDecoder) {
        Intrinsics.checkNotNullParameter(userActionProcessorRepository, "userActionProcessorRepository");
        Intrinsics.checkNotNullParameter(sunCoFayeClient, "sunCoFayeClient");
        Intrinsics.checkNotNullParameter(jwtDecoder, "jwtDecoder");
        this.userActionProcessorRepository = userActionProcessorRepository;
        this.sunCoFayeClient = sunCoFayeClient;
        this.jwtDecoder = jwtDecoder;
    }

    public AuthenticationErrorHandler(UserActionProcessorRepository userActionProcessorRepository, SunCoFayeClient sunCoFayeClient, Jwt.Decoder decoder, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(userActionProcessorRepository, sunCoFayeClient, (i & 4) != 0 ? new Jwt.Decoder() : decoder);
    }

    public static Object executeWithAuthErrorHandling$default(AuthenticationErrorHandler authenticationErrorHandler, String str, Function1 function1, Continuation continuation, int i, Object obj) {
        if ((i & 1) != 0) {
            str = null;
        }
        return authenticationErrorHandler.executeWithAuthErrorHandling(str, function1, continuation);
    }

    public final Object executeWithAuthErrorHandling(String str, Function1<? super Continuation<? super Effect>, ? extends Object> function1, Continuation<? super Effect> continuation) throws Throwable {
        C10941 c10941;
        int iCode;
        AuthenticationErrorHandler authenticationErrorHandler;
        String str2;
        User user;
        String str3;
        if (continuation instanceof C10941) {
            c10941 = (C10941) continuation;
            if ((c10941.label & Integer.MIN_VALUE) != 0) {
                c10941.label -= Integer.MIN_VALUE;
            } else {
                c10941 = new C10941(continuation);
            }
        } else {
            c10941 = new C10941(continuation);
        }
        Object objRevokeUser = c10941.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        try {
            switch (c10941.label) {
                case 0:
                    ResultKt.throwOnFailure(objRevokeUser);
                    try {
                        UserActionProcessorRepository userActionProcessorRepository = this.userActionProcessorRepository;
                        c10941.L$0 = this;
                        c10941.L$1 = str;
                        c10941.L$2 = function1;
                        c10941.label = 1;
                        objRevokeUser = userActionProcessorRepository.getUser(c10941);
                        if (objRevokeUser == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        authenticationErrorHandler = this;
                        str2 = str;
                        user = (User) objRevokeUser;
                        AuthenticationType authenticationType = user.getAuthenticationType();
                        str3 = str2;
                        if ((str3 != null || str3.length() == 0) && (authenticationType instanceof AuthenticationType.Jwt)) {
                            String jwt$zendesk_conversationkit_conversationkit_android = user.getJwt$zendesk_conversationkit_conversationkit_android();
                            c10941.L$0 = authenticationErrorHandler;
                            c10941.L$1 = null;
                            c10941.L$2 = null;
                            c10941.label = 2;
                            objRevokeUser = authenticationErrorHandler.decodeJwtAndCheckExpiration(jwt$zendesk_conversationkit_conversationkit_android, function1, c10941);
                            if (objRevokeUser == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                            return (Effect) objRevokeUser;
                        }
                        if (NullabilityKtxKt.isNotNullOrEmpty(str2)) {
                            c10941.L$0 = authenticationErrorHandler;
                            c10941.L$1 = null;
                            c10941.L$2 = null;
                            c10941.label = 3;
                            objRevokeUser = authenticationErrorHandler.decodeJwtAndCheckExpiration(str2, function1, c10941);
                            if (objRevokeUser == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                            return (Effect) objRevokeUser;
                        }
                        c10941.L$0 = authenticationErrorHandler;
                        c10941.L$1 = null;
                        c10941.L$2 = null;
                        c10941.label = 4;
                        objRevokeUser = function1.invoke(c10941);
                        if (objRevokeUser == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) objRevokeUser;
                    } catch (HttpException e) {
                        e = e;
                        str = this;
                        iCode = e.code();
                        if (iCode != 401) {
                            c10941.L$0 = null;
                            c10941.L$1 = null;
                            c10941.L$2 = null;
                            c10941.label = 5;
                            objRevokeUser = str.revokeUser(e, c10941);
                            if (objRevokeUser == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                            return (Effect) objRevokeUser;
                        }
                        if (iCode == 403) {
                            c10941.L$0 = null;
                            c10941.L$1 = null;
                            c10941.L$2 = null;
                            c10941.label = 6;
                            objRevokeUser = str.reAuthenticateUser(e, c10941);
                            if (objRevokeUser == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                            return (Effect) objRevokeUser;
                        }
                        throw e;
                    }
                case 1:
                    function1 = (Function1) c10941.L$2;
                    String str4 = (String) c10941.L$1;
                    AuthenticationErrorHandler authenticationErrorHandler2 = (AuthenticationErrorHandler) c10941.L$0;
                    try {
                        ResultKt.throwOnFailure(objRevokeUser);
                        authenticationErrorHandler = authenticationErrorHandler2;
                        str2 = str4;
                        user = (User) objRevokeUser;
                        AuthenticationType authenticationType2 = user.getAuthenticationType();
                        str3 = str2;
                        if (str3 != null) {
                            String jwt$zendesk_conversationkit_conversationkit_android2 = user.getJwt$zendesk_conversationkit_conversationkit_android();
                            c10941.L$0 = authenticationErrorHandler;
                            c10941.L$1 = null;
                            c10941.L$2 = null;
                            c10941.label = 2;
                            objRevokeUser = authenticationErrorHandler.decodeJwtAndCheckExpiration(jwt$zendesk_conversationkit_conversationkit_android2, function1, c10941);
                            if (objRevokeUser == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                            return (Effect) objRevokeUser;
                        }
                        String jwt$zendesk_conversationkit_conversationkit_android3 = user.getJwt$zendesk_conversationkit_conversationkit_android();
                        c10941.L$0 = authenticationErrorHandler;
                        c10941.L$1 = null;
                        c10941.L$2 = null;
                        c10941.label = 2;
                        objRevokeUser = authenticationErrorHandler.decodeJwtAndCheckExpiration(jwt$zendesk_conversationkit_conversationkit_android3, function1, c10941);
                        if (objRevokeUser == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) objRevokeUser;
                        if (NullabilityKtxKt.isNotNullOrEmpty(str2)) {
                            c10941.L$0 = authenticationErrorHandler;
                            c10941.L$1 = null;
                            c10941.L$2 = null;
                            c10941.label = 3;
                            objRevokeUser = authenticationErrorHandler.decodeJwtAndCheckExpiration(str2, function1, c10941);
                            if (objRevokeUser == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                            return (Effect) objRevokeUser;
                        }
                        c10941.L$0 = authenticationErrorHandler;
                        c10941.L$1 = null;
                        c10941.L$2 = null;
                        c10941.label = 4;
                        objRevokeUser = function1.invoke(c10941);
                        if (objRevokeUser == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return (Effect) objRevokeUser;
                    } catch (HttpException e2) {
                        e = e2;
                        str = authenticationErrorHandler2;
                        iCode = e.code();
                        if (iCode != 401) {
                            c10941.L$0 = null;
                            c10941.L$1 = null;
                            c10941.L$2 = null;
                            c10941.label = 5;
                            objRevokeUser = str.revokeUser(e, c10941);
                            if (objRevokeUser == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                            return (Effect) objRevokeUser;
                        }
                        if (iCode == 403) {
                            c10941.L$0 = null;
                            c10941.L$1 = null;
                            c10941.L$2 = null;
                            c10941.label = 6;
                            objRevokeUser = str.reAuthenticateUser(e, c10941);
                            if (objRevokeUser == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                            return (Effect) objRevokeUser;
                        }
                        throw e;
                    }
                case 2:
                    ResultKt.throwOnFailure(objRevokeUser);
                    return (Effect) objRevokeUser;
                case 3:
                    ResultKt.throwOnFailure(objRevokeUser);
                    return (Effect) objRevokeUser;
                case 4:
                    ResultKt.throwOnFailure(objRevokeUser);
                    return (Effect) objRevokeUser;
                case 5:
                    ResultKt.throwOnFailure(objRevokeUser);
                    return (Effect) objRevokeUser;
                case 6:
                    ResultKt.throwOnFailure(objRevokeUser);
                    return (Effect) objRevokeUser;
                default:
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
        } catch (HttpException e3) {
            e = e3;
        }
    }

    public final Object decodeJwtAndCheckExpiration(String str, Function1<? super Continuation<? super Effect>, ? extends Object> function1, Continuation<? super Effect> continuation) throws Throwable {
        Jwt jwt = str != null ? (Jwt) ConversationKitResultKt.getOrThrow(this.jwtDecoder.decode(str)) : null;
        if (jwt != null) {
            if (AuthenticatedUserUtilKt.isJwtExpired$default(jwt, 0L, 1, null)) {
                Object objRevokeUser = revokeUser(new JwtIsExpiredException(), continuation);
                return objRevokeUser == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objRevokeUser : (Effect) objRevokeUser;
            }
            return function1.invoke(continuation);
        }
        return function1.invoke(continuation);
    }

    public static Object revokeUser$default(AuthenticationErrorHandler authenticationErrorHandler, Throwable th, Continuation continuation, int i, Object obj) {
        if ((i & 1) != 0) {
            th = null;
        }
        return authenticationErrorHandler.revokeUser(th, continuation);
    }

    public final Object revokeUser(Throwable th, Continuation<? super Effect.UserAccessRevoked> continuation) throws Throwable {
        C10961 c10961;
        ConversationKitResult.Success success;
        if (continuation instanceof C10961) {
            c10961 = (C10961) continuation;
            if ((c10961.label & Integer.MIN_VALUE) != 0) {
                c10961.label -= Integer.MIN_VALUE;
            } else {
                c10961 = new C10961(continuation);
            }
        } else {
            c10961 = new C10961(continuation);
        }
        Object obj = c10961.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c10961.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            c10961.L$0 = th;
            c10961.label = 1;
            if (clearStorageAndDisconnectFromFaye(c10961) == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            th = (Throwable) c10961.L$0;
            ResultKt.throwOnFailure(obj);
        }
        if (th != null) {
            success = new ConversationKitResult.Failure(th);
        } else {
            success = new ConversationKitResult.Success(Unit.INSTANCE);
        }
        return new Effect.UserAccessRevoked(success);
    }

    public final Object reAuthenticateUser(HttpException httpException, Continuation<? super Effect> continuation) throws Throwable {
        C10951 c10951;
        AuthenticationErrorHandler authenticationErrorHandler;
        UserActionProcessorRepository userActionProcessorRepository;
        String jwt$zendesk_conversationkit_conversationkit_android;
        if (continuation instanceof C10951) {
            c10951 = (C10951) continuation;
            if ((c10951.label & Integer.MIN_VALUE) != 0) {
                c10951.label -= Integer.MIN_VALUE;
            } else {
                c10951 = new C10951(continuation);
            }
        } else {
            c10951 = new C10951(continuation);
        }
        Object objShouldReAuthenticateUser = c10951.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        switch (c10951.label) {
            case 0:
                ResultKt.throwOnFailure(objShouldReAuthenticateUser);
                UserActionProcessorRepository userActionProcessorRepository2 = this.userActionProcessorRepository;
                c10951.L$0 = this;
                c10951.L$1 = httpException;
                c10951.label = 1;
                objShouldReAuthenticateUser = userActionProcessorRepository2.shouldReAuthenticateUser(c10951);
                if (objShouldReAuthenticateUser == coroutine_suspended) {
                    return coroutine_suspended;
                }
                authenticationErrorHandler = this;
                if (!((Boolean) objShouldReAuthenticateUser).booleanValue()) {
                    userActionProcessorRepository = authenticationErrorHandler.userActionProcessorRepository;
                    c10951.L$0 = authenticationErrorHandler;
                    c10951.L$1 = httpException;
                    c10951.label = 2;
                    if (userActionProcessorRepository.updateReAuthenticateUser(true, c10951) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    c10951.L$0 = authenticationErrorHandler;
                    c10951.L$1 = httpException;
                    c10951.label = 3;
                    if (authenticationErrorHandler.clearStorageAndDisconnectFromFaye(c10951) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    UserActionProcessorRepository userActionProcessorRepository3 = authenticationErrorHandler.userActionProcessorRepository;
                    c10951.L$0 = authenticationErrorHandler;
                    c10951.L$1 = httpException;
                    c10951.label = 4;
                    objShouldReAuthenticateUser = userActionProcessorRepository3.getUser(c10951);
                    if (objShouldReAuthenticateUser == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    jwt$zendesk_conversationkit_conversationkit_android = ((User) objShouldReAuthenticateUser).getJwt$zendesk_conversationkit_conversationkit_android();
                    if (jwt$zendesk_conversationkit_conversationkit_android != null) {
                        return new Effect.ReAuthenticateUser(jwt$zendesk_conversationkit_conversationkit_android);
                    }
                    c10951.L$0 = null;
                    c10951.L$1 = null;
                    c10951.label = 5;
                    objShouldReAuthenticateUser = authenticationErrorHandler.revokeUser(httpException, c10951);
                    if (objShouldReAuthenticateUser == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    return (Effect) objShouldReAuthenticateUser;
                }
                c10951.L$0 = null;
                c10951.L$1 = null;
                c10951.label = 6;
                objShouldReAuthenticateUser = authenticationErrorHandler.revokeUser(httpException, c10951);
                if (objShouldReAuthenticateUser == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return objShouldReAuthenticateUser;
            case 1:
                httpException = (HttpException) c10951.L$1;
                authenticationErrorHandler = (AuthenticationErrorHandler) c10951.L$0;
                ResultKt.throwOnFailure(objShouldReAuthenticateUser);
                if (!((Boolean) objShouldReAuthenticateUser).booleanValue()) {
                    userActionProcessorRepository = authenticationErrorHandler.userActionProcessorRepository;
                    c10951.L$0 = authenticationErrorHandler;
                    c10951.L$1 = httpException;
                    c10951.label = 2;
                    if (userActionProcessorRepository.updateReAuthenticateUser(true, c10951) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    c10951.L$0 = authenticationErrorHandler;
                    c10951.L$1 = httpException;
                    c10951.label = 3;
                    if (authenticationErrorHandler.clearStorageAndDisconnectFromFaye(c10951) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    UserActionProcessorRepository userActionProcessorRepository4 = authenticationErrorHandler.userActionProcessorRepository;
                    c10951.L$0 = authenticationErrorHandler;
                    c10951.L$1 = httpException;
                    c10951.label = 4;
                    objShouldReAuthenticateUser = userActionProcessorRepository4.getUser(c10951);
                    if (objShouldReAuthenticateUser == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    jwt$zendesk_conversationkit_conversationkit_android = ((User) objShouldReAuthenticateUser).getJwt$zendesk_conversationkit_conversationkit_android();
                    if (jwt$zendesk_conversationkit_conversationkit_android != null) {
                        return new Effect.ReAuthenticateUser(jwt$zendesk_conversationkit_conversationkit_android);
                    }
                    c10951.L$0 = null;
                    c10951.L$1 = null;
                    c10951.label = 5;
                    objShouldReAuthenticateUser = authenticationErrorHandler.revokeUser(httpException, c10951);
                    if (objShouldReAuthenticateUser == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    return (Effect) objShouldReAuthenticateUser;
                }
                c10951.L$0 = null;
                c10951.L$1 = null;
                c10951.label = 6;
                objShouldReAuthenticateUser = authenticationErrorHandler.revokeUser(httpException, c10951);
                if (objShouldReAuthenticateUser == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return objShouldReAuthenticateUser;
            case 2:
                httpException = (HttpException) c10951.L$1;
                authenticationErrorHandler = (AuthenticationErrorHandler) c10951.L$0;
                ResultKt.throwOnFailure(objShouldReAuthenticateUser);
                c10951.L$0 = authenticationErrorHandler;
                c10951.L$1 = httpException;
                c10951.label = 3;
                if (authenticationErrorHandler.clearStorageAndDisconnectFromFaye(c10951) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                UserActionProcessorRepository userActionProcessorRepository5 = authenticationErrorHandler.userActionProcessorRepository;
                c10951.L$0 = authenticationErrorHandler;
                c10951.L$1 = httpException;
                c10951.label = 4;
                objShouldReAuthenticateUser = userActionProcessorRepository5.getUser(c10951);
                if (objShouldReAuthenticateUser == coroutine_suspended) {
                    return coroutine_suspended;
                }
                jwt$zendesk_conversationkit_conversationkit_android = ((User) objShouldReAuthenticateUser).getJwt$zendesk_conversationkit_conversationkit_android();
                if (jwt$zendesk_conversationkit_conversationkit_android != null) {
                    return new Effect.ReAuthenticateUser(jwt$zendesk_conversationkit_conversationkit_android);
                }
                c10951.L$0 = null;
                c10951.L$1 = null;
                c10951.label = 5;
                objShouldReAuthenticateUser = authenticationErrorHandler.revokeUser(httpException, c10951);
                if (objShouldReAuthenticateUser == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return (Effect) objShouldReAuthenticateUser;
            case 3:
                httpException = (HttpException) c10951.L$1;
                authenticationErrorHandler = (AuthenticationErrorHandler) c10951.L$0;
                ResultKt.throwOnFailure(objShouldReAuthenticateUser);
                UserActionProcessorRepository userActionProcessorRepository6 = authenticationErrorHandler.userActionProcessorRepository;
                c10951.L$0 = authenticationErrorHandler;
                c10951.L$1 = httpException;
                c10951.label = 4;
                objShouldReAuthenticateUser = userActionProcessorRepository6.getUser(c10951);
                if (objShouldReAuthenticateUser == coroutine_suspended) {
                    return coroutine_suspended;
                }
                jwt$zendesk_conversationkit_conversationkit_android = ((User) objShouldReAuthenticateUser).getJwt$zendesk_conversationkit_conversationkit_android();
                if (jwt$zendesk_conversationkit_conversationkit_android != null) {
                    return new Effect.ReAuthenticateUser(jwt$zendesk_conversationkit_conversationkit_android);
                }
                c10951.L$0 = null;
                c10951.L$1 = null;
                c10951.label = 5;
                objShouldReAuthenticateUser = authenticationErrorHandler.revokeUser(httpException, c10951);
                if (objShouldReAuthenticateUser == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return (Effect) objShouldReAuthenticateUser;
            case 4:
                httpException = (HttpException) c10951.L$1;
                authenticationErrorHandler = (AuthenticationErrorHandler) c10951.L$0;
                ResultKt.throwOnFailure(objShouldReAuthenticateUser);
                jwt$zendesk_conversationkit_conversationkit_android = ((User) objShouldReAuthenticateUser).getJwt$zendesk_conversationkit_conversationkit_android();
                if (jwt$zendesk_conversationkit_conversationkit_android != null) {
                    return new Effect.ReAuthenticateUser(jwt$zendesk_conversationkit_conversationkit_android);
                }
                c10951.L$0 = null;
                c10951.L$1 = null;
                c10951.label = 5;
                objShouldReAuthenticateUser = authenticationErrorHandler.revokeUser(httpException, c10951);
                if (objShouldReAuthenticateUser == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return (Effect) objShouldReAuthenticateUser;
            case 5:
                ResultKt.throwOnFailure(objShouldReAuthenticateUser);
                return (Effect) objShouldReAuthenticateUser;
            case 6:
                ResultKt.throwOnFailure(objShouldReAuthenticateUser);
                return objShouldReAuthenticateUser;
            default:
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    public final Object clearStorageAndDisconnectFromFaye(Continuation<? super Unit> continuation) {
        this.sunCoFayeClient.disconnect();
        Object objClearStorage = this.userActionProcessorRepository.clearStorage(continuation);
        return objClearStorage == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objClearStorage : Unit.INSTANCE;
    }
}
