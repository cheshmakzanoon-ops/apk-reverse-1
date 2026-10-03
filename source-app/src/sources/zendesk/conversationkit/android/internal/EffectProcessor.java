package zendesk.conversationkit.android.internal;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.ResultKt;
import kotlin.collections.CollectionsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.ConnectionStatus;
import zendesk.conversationkit.android.ConversationKitError;
import zendesk.conversationkit.android.ConversationKitEvent;
import zendesk.conversationkit.android.ConversationKitResult;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.conversationkit.android.model.Message;
import zendesk.conversationkit.android.model.User;
import zendesk.core.p017ui.android.internal.local.LocaleProvider;

@Metadata(m17d1 = {"\u0000¢\u0001\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0000\u0018\u00002\u00020\u0001B\u001d\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJ\u0016\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\fH\u0086@¢\u0006\u0002\u0010\rJ\u0010\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u000b\u001a\u00020\u0010H\u0002J\u0016\u0010\u0011\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\u0012H\u0082@¢\u0006\u0002\u0010\u0013J\u0010\u0010\u0014\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\u0015H\u0002J$\u0010\u0016\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\u00172\f\u0010\u0018\u001a\b\u0012\u0004\u0012\u00020\u001a0\u0019H\u0082@¢\u0006\u0002\u0010\u001bJ\u001e\u0010\u001c\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\u001d2\f\u0010\u0018\u001a\b\u0012\u0004\u0012\u00020\u001a0\u0019H\u0002J\u0016\u0010\u001e\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\u001fH\u0082@¢\u0006\u0002\u0010 J\u001e\u0010!\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\"2\f\u0010\u0018\u001a\b\u0012\u0004\u0012\u00020\u001a0\u0019H\u0002J\u001e\u0010#\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020$2\f\u0010\u0018\u001a\b\u0012\u0004\u0012\u00020\u001a0\u0019H\u0002J\u001e\u0010%\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020&2\f\u0010\u0018\u001a\b\u0012\u0004\u0012\u00020\u001a0\u0019H\u0002J\u001e\u0010'\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020(2\f\u0010\u0018\u001a\b\u0012\u0004\u0012\u00020\u001a0\u0019H\u0002J\u001e\u0010)\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020*2\f\u0010\u0018\u001a\b\u0012\u0004\u0012\u00020\u001a0\u0019H\u0002J\u0016\u0010+\u001a\u00020\n2\f\u0010\u0018\u001a\b\u0012\u0004\u0012\u00020\u001a0\u0019H\u0002J\u0010\u0010,\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020-H\u0002J\u001e\u0010.\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020/2\f\u0010\u0018\u001a\b\u0012\u0004\u0012\u00020\u001a0\u0019H\u0002J\u001e\u00100\u001a\u00020\n2\u0006\u0010\u000b\u001a\u0002012\f\u0010\u0018\u001a\b\u0012\u0004\u0012\u00020\u001a0\u0019H\u0002J\u001e\u00102\u001a\u00020\n2\u0006\u0010\u000b\u001a\u0002032\f\u0010\u0018\u001a\b\u0012\u0004\u0012\u00020\u001a0\u0019H\u0002J\u001e\u00104\u001a\u00020\n2\u0006\u0010\u000b\u001a\u0002052\f\u0010\u0018\u001a\b\u0012\u0004\u0012\u00020\u001a0\u0019H\u0002R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000¨\u00066"}, m18d2 = {"Lzendesk/conversationkit/android/internal/EffectProcessor;", "", "effectMapper", "Lzendesk/conversationkit/android/internal/EffectMapper;", "accessLevelBuilder", "Lzendesk/conversationkit/android/internal/AccessLevelBuilder;", "localeProvider", "Lzendesk/core/ui/android/internal/local/LocaleProvider;", "(Lzendesk/conversationkit/android/internal/EffectMapper;Lzendesk/conversationkit/android/internal/AccessLevelBuilder;Lzendesk/core/ui/android/internal/local/LocaleProvider;)V", "process", "Lzendesk/conversationkit/android/internal/EffectProcessorResult;", "effect", "Lzendesk/conversationkit/android/internal/Effect;", "(Lzendesk/conversationkit/android/internal/Effect;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processAlreadyLoggedInResult", "Lzendesk/conversationkit/android/internal/EffectProcessorResult$Ends;", "Lzendesk/conversationkit/android/internal/Effect$AlreadyLoggedInResult;", "processCheckForPersistedUserResult", "Lzendesk/conversationkit/android/internal/Effect$CheckForPersistedUserResult;", "(Lzendesk/conversationkit/android/internal/Effect$CheckForPersistedUserResult;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processCreateConversationResult", "Lzendesk/conversationkit/android/internal/Effect$CreateConversationResult;", "processCreateUserResult", "Lzendesk/conversationkit/android/internal/Effect$CreateUserResult;", "mappedEvents", "", "Lzendesk/conversationkit/android/ConversationKitEvent;", "(Lzendesk/conversationkit/android/internal/Effect$CreateUserResult;Ljava/util/List;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processGetConversationResult", "Lzendesk/conversationkit/android/internal/Effect$GetConversationResult;", "processLoginUserResult", "Lzendesk/conversationkit/android/internal/Effect$LoginUserResult;", "(Lzendesk/conversationkit/android/internal/Effect$LoginUserResult;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processLogoutUserResult", "Lzendesk/conversationkit/android/internal/Effect$LogoutUserResult;", "processMessagePrepared", "Lzendesk/conversationkit/android/internal/Effect$MessagePrepared;", "processNetworkConnectionChanged", "Lzendesk/conversationkit/android/internal/Effect$NetworkConnectionChanged;", "processProactiveMessageReferral", "Lzendesk/conversationkit/android/internal/Effect$ProactiveMessageReferral;", "processPushRegistrationPending", "Lzendesk/conversationkit/android/internal/Effect$PushTokenPrepared;", "processPushRegistrationResult", "processReAuthenticateUser", "Lzendesk/conversationkit/android/internal/Effect$ReAuthenticateUser;", "processRealtimeConnectionChanged", "Lzendesk/conversationkit/android/internal/Effect$RealtimeConnectionChanged;", "processRefreshUserResult", "Lzendesk/conversationkit/android/internal/Effect$RefreshUserResult;", "processSendMessageResult", "Lzendesk/conversationkit/android/internal/Effect$SendMessageResult;", "processUserAccessRevoked", "Lzendesk/conversationkit/android/internal/Effect$UserAccessRevoked;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class EffectProcessor {
    private final AccessLevelBuilder accessLevelBuilder;
    private final EffectMapper effectMapper;
    private final LocaleProvider localeProvider;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.EffectProcessor", m37f = "EffectProcessor.kt", m38i = {0, 0}, m39l = {269}, m40m = "processCheckForPersistedUserResult", m41n = {"effect", "supplementaryActions"}, m42s = {"L$0", "L$1"})
    static final class C10351 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C10351(Continuation<? super C10351> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return EffectProcessor.this.processCheckForPersistedUserResult(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.EffectProcessor", m37f = "EffectProcessor.kt", m38i = {0, 0, 0, 0}, m39l = {173}, m40m = "processCreateUserResult", m41n = {"effect", "mappedEvents", "supplementaryActions", "user"}, m42s = {"L$0", "L$1", "L$2", "L$3"})
    static final class C10361 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        int label;
        Object result;

        C10361(Continuation<? super C10361> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return EffectProcessor.this.processCreateUserResult(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.EffectProcessor", m37f = "EffectProcessor.kt", m38i = {0}, m39l = {208}, m40m = "processLoginUserResult", m41n = {"result"}, m42s = {"L$0"})
    static final class C10371 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C10371(Continuation<? super C10371> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return EffectProcessor.this.processLoginUserResult(null, this);
        }
    }

    public EffectProcessor(EffectMapper effectMapper, AccessLevelBuilder accessLevelBuilder, LocaleProvider localeProvider) {
        Intrinsics.checkNotNullParameter(effectMapper, "effectMapper");
        Intrinsics.checkNotNullParameter(accessLevelBuilder, "accessLevelBuilder");
        Intrinsics.checkNotNullParameter(localeProvider, "localeProvider");
        this.effectMapper = effectMapper;
        this.accessLevelBuilder = accessLevelBuilder;
        this.localeProvider = localeProvider;
    }

    public final Object process(Effect effect, Continuation<? super EffectProcessorResult> continuation) {
        List<ConversationKitEvent> map = this.effectMapper.map(effect);
        if (Intrinsics.areEqual(effect, Effect.IncorrectAccessLevel.INSTANCE)) {
            return new EffectProcessorResult.Ends(null, null, null, new ConversationKitResult.Failure(ConversationKitError.IncorrectAccessLevelForAction.INSTANCE), 7, null);
        }
        if (effect instanceof Effect.UserAccessRevoked) {
            return processUserAccessRevoked((Effect.UserAccessRevoked) effect, map);
        }
        if (effect instanceof Effect.CreateUserResult) {
            return processCreateUserResult((Effect.CreateUserResult) effect, map, continuation);
        }
        if (effect instanceof Effect.LoginUserResult) {
            return processLoginUserResult((Effect.LoginUserResult) effect, continuation);
        }
        if (effect instanceof Effect.AlreadyLoggedInResult) {
            return processAlreadyLoggedInResult((Effect.AlreadyLoggedInResult) effect);
        }
        if (effect instanceof Effect.LogoutUserResult) {
            return processLogoutUserResult((Effect.LogoutUserResult) effect, map);
        }
        if (effect instanceof Effect.MessageReceived) {
            return new EffectProcessorResult.Ends(null, map, null, null, 13, null);
        }
        if (effect instanceof Effect.CheckForPersistedUserResult) {
            return processCheckForPersistedUserResult((Effect.CheckForPersistedUserResult) effect, continuation);
        }
        if (effect instanceof Effect.RefreshUserResult) {
            return processRefreshUserResult((Effect.RefreshUserResult) effect, map);
        }
        if (effect instanceof Effect.CreateConversationResult) {
            return processCreateConversationResult((Effect.CreateConversationResult) effect);
        }
        if (effect instanceof Effect.GetConversationResult) {
            return processGetConversationResult((Effect.GetConversationResult) effect, map);
        }
        if (effect instanceof Effect.RefreshConversationResult) {
            return new EffectProcessorResult.Ends(null, map, null, ((Effect.RefreshConversationResult) effect).getResult(), 5, null);
        }
        if (effect instanceof Effect.NetworkConnectionChanged) {
            return processNetworkConnectionChanged((Effect.NetworkConnectionChanged) effect, map);
        }
        if (effect instanceof Effect.RealtimeConnectionChanged) {
            return processRealtimeConnectionChanged((Effect.RealtimeConnectionChanged) effect, map);
        }
        if (effect instanceof Effect.MessagePrepared) {
            return processMessagePrepared((Effect.MessagePrepared) effect, map);
        }
        if (effect instanceof Effect.SendMessageResult) {
            return processSendMessageResult((Effect.SendMessageResult) effect, map);
        }
        if (effect instanceof Effect.PushTokenPrepared) {
            return processPushRegistrationPending((Effect.PushTokenPrepared) effect, map);
        }
        if (effect instanceof Effect.PushTokenUpdateResult) {
            return processPushRegistrationResult(map);
        }
        if (effect instanceof Effect.ActivityEventReceived) {
            return new EffectProcessorResult.Ends(null, map, null, new ConversationKitResult.Success(((Effect.ActivityEventReceived) effect).getActivityEvent()), 5, null);
        }
        if (effect instanceof Effect.LoadMoreMessages) {
            return new EffectProcessorResult.Ends(null, map, null, ((Effect.LoadMoreMessages) effect).getResult(), 5, null);
        }
        if (effect instanceof Effect.GetVisitType) {
            return new EffectProcessorResult.Ends(null, map, null, new ConversationKitResult.Success(((Effect.GetVisitType) effect).getVisitType()), 5, null);
        }
        if (effect instanceof Effect.GetProactiveMessage) {
            return new EffectProcessorResult.Ends(null, map, null, ((Effect.GetProactiveMessage) effect).getResult(), 5, null);
        }
        if (effect instanceof Effect.ProactiveMessageReferral) {
            return processProactiveMessageReferral((Effect.ProactiveMessageReferral) effect, map);
        }
        if (effect instanceof Effect.ReAuthenticateUser) {
            return processReAuthenticateUser((Effect.ReAuthenticateUser) effect);
        }
        if (effect instanceof Effect.ConversationAddedResult) {
            return new EffectProcessorResult.Ends(null, map, null, ((Effect.ConversationAddedResult) effect).getResult(), 5, null);
        }
        if (effect instanceof Effect.ConversationRemovedResult) {
            return new EffectProcessorResult.Ends(null, map, null, ((Effect.ConversationRemovedResult) effect).getResult(), 5, null);
        }
        if (effect instanceof Effect.ConversationUpdatedResult) {
            return new EffectProcessorResult.Ends(null, map, null, ((Effect.ConversationUpdatedResult) effect).getResult(), 5, null);
        }
        if (effect instanceof Effect.GetConversationsResult) {
            return new EffectProcessorResult.Ends(null, null, null, ((Effect.GetConversationsResult) effect).getResult(), 7, null);
        }
        if (effect instanceof Effect.SendPostbackResult) {
            return new EffectProcessorResult.Ends(null, map, null, ((Effect.SendPostbackResult) effect).getResult(), 5, null);
        }
        if (effect instanceof Effect.OpenAttachmentFromFile) {
            return new EffectProcessorResult.Ends(null, map, CollectionsKt.listOf(new Action.RefreshConversation(((Effect.OpenAttachmentFromFile) effect).getConversationId())), null, 9, null);
        }
        if (effect instanceof Effect.FetchWaitTimeResult) {
            return new EffectProcessorResult.Ends(null, map, null, ((Effect.FetchWaitTimeResult) effect).getResult(), 5, null);
        }
        return new EffectProcessorResult.Ends(null, map, null, null, 13, null);
    }

    private final EffectProcessorResult processUserAccessRevoked(Effect.UserAccessRevoked effect, List<? extends ConversationKitEvent> mappedEvents) {
        return new EffectProcessorResult.Ends(this.accessLevelBuilder.buildAppAccess(), mappedEvents, null, effect.getResult(), 4, null);
    }

    public final Object processCreateUserResult(Effect.CreateUserResult createUserResult, List<? extends ConversationKitEvent> list, Continuation<? super EffectProcessorResult> continuation) throws Throwable {
        C10361 c10361;
        List list2;
        AccessLevel accessLevel;
        List<? extends ConversationKitEvent> list3;
        List list4;
        Effect.CreateUserResult createUserResult2;
        User user;
        if (continuation instanceof C10361) {
            c10361 = (C10361) continuation;
            if ((c10361.label & Integer.MIN_VALUE) != 0) {
                c10361.label -= Integer.MIN_VALUE;
            } else {
                c10361 = new C10361(continuation);
            }
        } else {
            c10361 = new C10361(continuation);
        }
        Object obj = c10361.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c10361.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            ArrayList arrayList = new ArrayList();
            if (createUserResult.getResult() instanceof ConversationKitResult.Success) {
                User user2 = (User) ((ConversationKitResult.Success) createUserResult.getResult()).getValue();
                AccessLevelBuilder accessLevelBuilder = this.accessLevelBuilder;
                c10361.L$0 = createUserResult;
                c10361.L$1 = list;
                c10361.L$2 = arrayList;
                c10361.L$3 = user2;
                c10361.label = 1;
                Object objBuildUserAccess = accessLevelBuilder.buildUserAccess(user2, c10361);
                if (objBuildUserAccess == coroutine_suspended) {
                    return coroutine_suspended;
                }
                list3 = list;
                list4 = arrayList;
                obj = objBuildUserAccess;
                createUserResult2 = createUserResult;
                user = user2;
            } else {
                list2 = arrayList;
                accessLevel = null;
            }
            return new EffectProcessorResult.Ends(accessLevel, list, list2, createUserResult.getResult());
        }
        if (i != 1) {
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
        user = (User) c10361.L$3;
        list4 = (List) c10361.L$2;
        list3 = (List) c10361.L$1;
        createUserResult2 = (Effect.CreateUserResult) c10361.L$0;
        ResultKt.throwOnFailure(obj);
        accessLevel = (AccessLevel) obj;
        if (!user.getConversations().isEmpty()) {
            list4.add(Action.StartRealtimeConnection.INSTANCE);
        }
        String pendingPushToken = createUserResult2.getPendingPushToken();
        if (pendingPushToken != null) {
            list4.add(new Action.UpdatePushToken(pendingPushToken));
        }
        createUserResult = createUserResult2;
        list2 = list4;
        list = list3;
        return new EffectProcessorResult.Ends(accessLevel, list, list2, createUserResult.getResult());
    }

    public final Object processLoginUserResult(Effect.LoginUserResult loginUserResult, Continuation<? super EffectProcessorResult> continuation) throws Throwable {
        C10371 c10371;
        ConversationKitResult<User> conversationKitResult;
        if (continuation instanceof C10371) {
            c10371 = (C10371) continuation;
            if ((c10371.label & Integer.MIN_VALUE) != 0) {
                c10371.label -= Integer.MIN_VALUE;
            } else {
                c10371 = new C10371(continuation);
            }
        } else {
            c10371 = new C10371(continuation);
        }
        Object objBuildUserAccess = c10371.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c10371.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objBuildUserAccess);
            ConversationKitResult<User> result = loginUserResult.getResult();
            if (result instanceof ConversationKitResult.Failure) {
                return new EffectProcessorResult.Ends(null, null, null, result, 7, null);
            }
            if (!(result instanceof ConversationKitResult.Success)) {
                throw new NoWhenBranchMatchedException();
            }
            AccessLevelBuilder accessLevelBuilder = this.accessLevelBuilder;
            User user = (User) ((ConversationKitResult.Success) result).getValue();
            c10371.L$0 = result;
            c10371.label = 1;
            objBuildUserAccess = accessLevelBuilder.buildUserAccess(user, c10371);
            if (objBuildUserAccess == coroutine_suspended) {
                return coroutine_suspended;
            }
            conversationKitResult = result;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ConversationKitResult<User> conversationKitResult2 = (ConversationKitResult) c10371.L$0;
            ResultKt.throwOnFailure(objBuildUserAccess);
            conversationKitResult = conversationKitResult2;
        }
        AccessLevel accessLevel = (AccessLevel) objBuildUserAccess;
        ArrayList arrayList = new ArrayList();
        if (!((User) ((ConversationKitResult.Success) conversationKitResult).getValue()).getConversations().isEmpty()) {
            arrayList.add(Action.StartRealtimeConnection.INSTANCE);
        }
        arrayList.add(new Action.GetConversations(0, false));
        return new EffectProcessorResult.Ends(accessLevel, null, arrayList, conversationKitResult, 2, null);
    }

    private final EffectProcessorResult.Ends processAlreadyLoggedInResult(Effect.AlreadyLoggedInResult effect) {
        ConversationKitResult<User> result = effect.getResult();
        if (!(result instanceof ConversationKitResult.Failure) && !(result instanceof ConversationKitResult.Success)) {
            throw new NoWhenBranchMatchedException();
        }
        return new EffectProcessorResult.Ends(null, null, null, result, 7, null);
    }

    private final EffectProcessorResult processLogoutUserResult(Effect.LogoutUserResult effect, List<? extends ConversationKitEvent> mappedEvents) {
        ConversationKitResult<Object> result = effect.getResult();
        if (result instanceof ConversationKitResult.Failure) {
            return new EffectProcessorResult.Ends(null, null, null, result, 7, null);
        }
        if (result instanceof ConversationKitResult.Success) {
            return new EffectProcessorResult.Ends(this.accessLevelBuilder.buildAppAccess(), mappedEvents, null, effect.getResult(), 4, null);
        }
        throw new NoWhenBranchMatchedException();
    }

    public final Object processCheckForPersistedUserResult(Effect.CheckForPersistedUserResult checkForPersistedUserResult, Continuation<? super EffectProcessorResult> continuation) throws Throwable {
        C10351 c10351;
        List list;
        AccessLevel accessLevel;
        Effect.CheckForPersistedUserResult checkForPersistedUserResult2;
        List list2;
        if (continuation instanceof C10351) {
            c10351 = (C10351) continuation;
            if ((c10351.label & Integer.MIN_VALUE) != 0) {
                c10351.label -= Integer.MIN_VALUE;
            } else {
                c10351 = new C10351(continuation);
            }
        } else {
            c10351 = new C10351(continuation);
        }
        Object obj = c10351.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c10351.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            ArrayList arrayList = new ArrayList();
            if (checkForPersistedUserResult.getUser() != null) {
                AccessLevelBuilder accessLevelBuilder = this.accessLevelBuilder;
                User user = checkForPersistedUserResult.getUser();
                c10351.L$0 = checkForPersistedUserResult;
                c10351.L$1 = arrayList;
                c10351.label = 1;
                Object objBuildUserAccess = accessLevelBuilder.buildUserAccess(user, c10351);
                if (objBuildUserAccess == coroutine_suspended) {
                    return coroutine_suspended;
                }
                checkForPersistedUserResult2 = checkForPersistedUserResult;
                list2 = arrayList;
                obj = objBuildUserAccess;
            } else {
                list = arrayList;
                accessLevel = null;
            }
            return new EffectProcessorResult.Ends(accessLevel, null, list, checkForPersistedUserResult.getResult(), 2, null);
        }
        if (i != 1) {
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
        list2 = (List) c10351.L$1;
        checkForPersistedUserResult2 = (Effect.CheckForPersistedUserResult) c10351.L$0;
        ResultKt.throwOnFailure(obj);
        AccessLevel accessLevel2 = (AccessLevel) obj;
        list2.add(new Action.PersistedUserRetrieve(checkForPersistedUserResult2.getUser()));
        if (!checkForPersistedUserResult2.getUser().getConversations().isEmpty()) {
            list2.add(Action.StartRealtimeConnection.INSTANCE);
        }
        list = list2;
        accessLevel = accessLevel2;
        checkForPersistedUserResult = checkForPersistedUserResult2;
        return new EffectProcessorResult.Ends(accessLevel, null, list, checkForPersistedUserResult.getResult(), 2, null);
    }

    private final EffectProcessorResult processCreateConversationResult(Effect.CreateConversationResult effect) {
        List listEmptyList;
        boolean z = effect.getUser().getConversations().size() == 1;
        if ((effect.getResult() instanceof ConversationKitResult.Success) && z) {
            listEmptyList = CollectionsKt.listOf(Action.StartRealtimeConnection.INSTANCE);
        } else {
            listEmptyList = CollectionsKt.emptyList();
        }
        return new EffectProcessorResult.Ends(null, null, listEmptyList, effect.getResult(), 3, null);
    }

    private final EffectProcessorResult processGetConversationResult(Effect.GetConversationResult effect, List<? extends ConversationKitEvent> mappedEvents) {
        List listEmptyList;
        if ((effect.getResult() instanceof ConversationKitResult.Success) && effect.getShouldRefresh()) {
            listEmptyList = CollectionsKt.listOf(new Action.RefreshConversation(((Conversation) ((ConversationKitResult.Success) effect.getResult()).getValue()).getId()));
        } else {
            listEmptyList = CollectionsKt.emptyList();
        }
        return new EffectProcessorResult.Ends(null, mappedEvents, listEmptyList, effect.getResult(), 1, null);
    }

    private final EffectProcessorResult processProactiveMessageReferral(Effect.ProactiveMessageReferral effect, List<? extends ConversationKitEvent> mappedEvents) {
        List listEmptyList;
        if ((effect.getResult() instanceof ConversationKitResult.Success) && effect.getShouldRefresh()) {
            listEmptyList = CollectionsKt.listOf(new Action.RefreshConversation(((Conversation) ((ConversationKitResult.Success) effect.getResult()).getValue()).getId()));
        } else {
            listEmptyList = CollectionsKt.emptyList();
        }
        return new EffectProcessorResult.Ends(null, mappedEvents, listEmptyList, effect.getResult(), 1, null);
    }

    private final EffectProcessorResult processNetworkConnectionChanged(Effect.NetworkConnectionChanged effect, List<? extends ConversationKitEvent> mappedEvents) {
        if (effect.getConnectionStatus() == ConnectionStatus.CONNECTED) {
            return new EffectProcessorResult.Continues(null, mappedEvents, null, Action.StartRealtimeConnection.INSTANCE, 5, null);
        }
        return new EffectProcessorResult.Ends(null, mappedEvents, null, null, 13, null);
    }

    private final EffectProcessorResult processRealtimeConnectionChanged(Effect.RealtimeConnectionChanged effect, List<? extends ConversationKitEvent> mappedEvents) {
        if (effect.getConnectionStatus() == ConnectionStatus.CONNECTED_REALTIME) {
            return new EffectProcessorResult.Continues(null, mappedEvents, null, Action.RefreshUser.INSTANCE, 5, null);
        }
        return new EffectProcessorResult.Ends(null, mappedEvents, null, null, 13, null);
    }

    private final EffectProcessorResult processMessagePrepared(Effect.MessagePrepared effect, List<? extends ConversationKitEvent> mappedEvents) {
        if (effect.getShouldUpdateConversation()) {
            return new EffectProcessorResult.Continues(null, mappedEvents, CollectionsKt.listOf(new Action.SendMessage(effect.getMessage(), effect.getConversationId())), new Action.UpdateConversationMetadata(effect.getMetadata(), effect.getConversationId()), 1, null);
        }
        return new EffectProcessorResult.Continues(null, mappedEvents, null, new Action.SendMessage(effect.getMessage(), effect.getConversationId()), 5, null);
    }

    private final EffectProcessorResult processSendMessageResult(Effect.SendMessageResult effect, List<? extends ConversationKitEvent> mappedEvents) {
        return new EffectProcessorResult.Ends(null, mappedEvents, null, effect.getResult(), 5, null);
    }

    private final EffectProcessorResult processPushRegistrationPending(Effect.PushTokenPrepared effect, List<? extends ConversationKitEvent> mappedEvents) {
        return new EffectProcessorResult.Continues(null, mappedEvents, null, new Action.UpdatePushToken(effect.getPushToken()), 5, null);
    }

    private final EffectProcessorResult processPushRegistrationResult(List<? extends ConversationKitEvent> mappedEvents) {
        return new EffectProcessorResult.Ends(null, mappedEvents, null, null, 13, null);
    }

    private final EffectProcessorResult processRefreshUserResult(Effect.RefreshUserResult effect, List<? extends ConversationKitEvent> mappedEvents) {
        Message message;
        Object next;
        List<Message> messages;
        ArrayList arrayList = new ArrayList();
        String languageTag = this.localeProvider.getLocale().toLanguageTag();
        ConversationKitResult<User> result = effect.getResult();
        if (result instanceof ConversationKitResult.Success) {
            ConversationKitResult.Success success = (ConversationKitResult.Success) result;
            if (!((User) success.getValue()).getConversations().isEmpty()) {
                Iterator<T> it = ((User) success.getValue()).getConversations().iterator();
                do {
                    message = null;
                    if (!it.hasNext()) {
                        next = null;
                        break;
                    }
                    next = it.next();
                } while (!((Conversation) next).isDefault());
                Conversation conversation = (Conversation) next;
                Conversation persistedConversation = effect.getPersistedConversation();
                if (persistedConversation != null && !persistedConversation.getMessages().isEmpty()) {
                    if (conversation != null && (messages = conversation.getMessages()) != null) {
                        message = (Message) CollectionsKt.lastOrNull((List) messages);
                    }
                    if (!Intrinsics.areEqual(message, CollectionsKt.last((List) persistedConversation.getMessages()))) {
                        arrayList.add(new Action.RefreshConversation(((Conversation) CollectionsKt.first((List) ((User) success.getValue()).getConversations())).getId()));
                    }
                }
            }
            if (!Intrinsics.areEqual(((User) success.getValue()).getLocale(), languageTag)) {
                Intrinsics.checkNotNull(languageTag);
                arrayList.add(new Action.UpdateAppUserLocale(languageTag));
            }
        }
        return new EffectProcessorResult.Ends(null, mappedEvents, arrayList, effect.getResult(), 1, null);
    }

    private final EffectProcessorResult processReAuthenticateUser(Effect.ReAuthenticateUser effect) {
        return new EffectProcessorResult.Ends(null, null, CollectionsKt.listOf(new Action.LoginUser(effect.getJwt())), null, 11, null);
    }
}
