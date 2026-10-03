package zendesk.messaging.android.internal.messagingscreen;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentContainerView;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleObserver;
import androidx.lifecycle.LifecycleOwner;
import androidx.lifecycle.LifecycleOwnerKt;
import androidx.lifecycle.RepeatOnLifecycleKt;
import androidx.lifecycle.ViewModelProvider;
import androidx.lifecycle.ViewModelStoreOwner;
import androidx.savedstate.SavedStateRegistryOwner;
import com.google.android.material.progressindicator.CircularProgressIndicator;
import javax.inject.Inject;
import javax.inject.Named;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt__Builders_commonKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.flow.FlowCollector;
import kotlinx.coroutines.flow.StateFlow;
import net.aihelp.data.model.p005cs.ConversationMsg;
import zendesk.android.Zendesk;
import zendesk.android.ZendeskCredentials;
import zendesk.android.ZendeskResult;
import zendesk.android.messaging.Messaging;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.android.messaging.model.UserColors;
import zendesk.logger.Logger;
import zendesk.messaging.C1256R;
import zendesk.messaging.android.internal.DefaultMessaging;
import zendesk.messaging.android.internal.extension.ContextKtxKt;
import zendesk.messaging.android.internal.extension.MessagingFragmentScreenKtxKt;
import zendesk.messaging.android.internal.extension.ZendeskKtxKt;
import zendesk.messaging.android.internal.model.MessagingTheme;
import zendesk.messaging.android.internal.p023di.MessagingComponentKt;
import zendesk.messaging.android.internal.permissions.RuntimePermissionLauncher;
import zendesk.messaging.android.internal.permissions.RuntimePermissionRequester;
import zendesk.ui.android.common.retryerror.RetryErrorRendering;
import zendesk.ui.android.common.retryerror.RetryErrorState;
import zendesk.ui.android.common.retryerror.RetryErrorView;

@Metadata(m17d1 = {"\u0000\u0090\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0010\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0007\b\u0000\u0018\u0000 L2\u00020\u00012\u00020\u0002:\u0001LB\u0005¢\u0006\u0002\u0010\u0003J\u000e\u00101\u001a\u000202H\u0082@¢\u0006\u0002\u00103J\b\u00104\u001a\u000202H\u0002J\b\u00105\u001a\u000202H\u0002J\b\u00106\u001a\u000202H\u0002J\u0010\u00107\u001a\u0002022\u0006\u00108\u001a\u000209H\u0002J\b\u0010:\u001a\u00020;H\u0002J&\u0010<\u001a\u0002022\u0006\u0010=\u001a\u00020>2\u0014\u0010?\u001a\u0010\u0012\u0004\u0012\u00020;\u0012\u0004\u0012\u000202\u0018\u00010#H\u0016J\u0012\u0010@\u001a\u0002022\b\u0010A\u001a\u0004\u0018\u00010BH\u0014J\b\u0010C\u001a\u000202H\u0014J\u0010\u0010D\u001a\u0002022\u0006\u0010E\u001a\u00020FH\u0015J\u000e\u0010G\u001a\u000202H\u0082@¢\u0006\u0002\u00103J\b\u0010H\u001a\u000202H\u0002J\b\u0010I\u001a\u000202H\u0002J\b\u0010J\u001a\u000202H\u0002J\b\u0010K\u001a\u000202H\u0002R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082.¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082.¢\u0006\u0002\n\u0000R\u001e\u0010\b\u001a\u00020\t8\u0006@\u0006X\u0087.¢\u0006\u000e\n\u0000\u001a\u0004\b\n\u0010\u000b\"\u0004\b\f\u0010\rR\u000e\u0010\u000e\u001a\u00020\u000fX\u0082.¢\u0006\u0002\n\u0000R\u001e\u0010\u0010\u001a\u00020\u00118\u0006@\u0006X\u0087.¢\u0006\u000e\n\u0000\u001a\u0004\b\u0012\u0010\u0013\"\u0004\b\u0014\u0010\u0015R\u001e\u0010\u0016\u001a\u00020\u00178\u0006@\u0006X\u0087.¢\u0006\u000e\n\u0000\u001a\u0004\b\u0018\u0010\u0019\"\u0004\b\u001a\u0010\u001bR\u000e\u0010\u001c\u001a\u00020\u001dX\u0082.¢\u0006\u0002\n\u0000R\u000e\u0010\u001e\u001a\u00020\u001fX\u0082.¢\u0006\u0002\n\u0000R\u000e\u0010 \u001a\u00020!X\u0082.¢\u0006\u0002\n\u0000R$\u0010\"\u001a\u0018\u0012\u0004\u0012\u00020$\u0012\u0004\u0012\u00020$0#j\b\u0012\u0004\u0012\u00020$`%X\u0082\u0004¢\u0006\u0002\n\u0000R$\u0010&\u001a\u00020'8\u0006@\u0006X\u0087.¢\u0006\u0014\n\u0000\u0012\u0004\b(\u0010\u0003\u001a\u0004\b)\u0010*\"\u0004\b+\u0010,R$\u0010-\u001a\u00020'8\u0006@\u0006X\u0087.¢\u0006\u0014\n\u0000\u0012\u0004\b.\u0010\u0003\u001a\u0004\b/\u0010*\"\u0004\b0\u0010,¨\u0006M"}, m18d2 = {"Lzendesk/messaging/android/internal/messagingscreen/MessagingActivity;", "Landroidx/appcompat/app/AppCompatActivity;", "Lzendesk/messaging/android/internal/permissions/RuntimePermissionRequester;", "()V", "circularProgressIndicator", "Lcom/google/android/material/progressindicator/CircularProgressIndicator;", "fragmentContainerView", "Landroidx/fragment/app/FragmentContainerView;", "messagingNavigator", "Lzendesk/messaging/android/internal/messagingscreen/MessagingNavigator;", "getMessagingNavigator", "()Lzendesk/messaging/android/internal/messagingscreen/MessagingNavigator;", "setMessagingNavigator", "(Lzendesk/messaging/android/internal/messagingscreen/MessagingNavigator;)V", "messagingScreenViewModel", "Lzendesk/messaging/android/internal/messagingscreen/MessagingScreenViewModel;", "messagingScreenViewModelFactory", "Lzendesk/messaging/android/internal/messagingscreen/MessagingScreenViewModelFactory;", "getMessagingScreenViewModelFactory", "()Lzendesk/messaging/android/internal/messagingscreen/MessagingScreenViewModelFactory;", "setMessagingScreenViewModelFactory", "(Lzendesk/messaging/android/internal/messagingscreen/MessagingScreenViewModelFactory;)V", "messagingSettings", "Lzendesk/android/messaging/model/MessagingSettings;", "getMessagingSettings", "()Lzendesk/android/messaging/model/MessagingSettings;", "setMessagingSettings", "(Lzendesk/android/messaging/model/MessagingSettings;)V", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "permissionLauncher", "Lzendesk/messaging/android/internal/permissions/RuntimePermissionLauncher;", "retryErrorView", "Lzendesk/ui/android/common/retryerror/RetryErrorView;", "retryErrorViewRendering", "Lkotlin/Function1;", "Lzendesk/ui/android/common/retryerror/RetryErrorRendering;", "Lzendesk/messaging/android/internal/conversationscreen/RenderingUpdate;", MessagingComponentKt.USER_DARK_COLORS, "Lzendesk/android/messaging/model/UserColors;", "getUserDarkColors$annotations", "getUserDarkColors", "()Lzendesk/android/messaging/model/UserColors;", "setUserDarkColors", "(Lzendesk/android/messaging/model/UserColors;)V", MessagingComponentKt.USER_LIGHT_COLORS, "getUserLightColors$annotations", "getUserLightColors", "setUserLightColors", "collectStateUpdates", "", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "errorHandler", "hideCircularProgressBarIndicator", "hideRetryErrorViewIfNeeded", "initViewModel", "messaging", "Lzendesk/android/messaging/Messaging;", "isFragmentContainerEmpty", "", "launchSinglePermissionRequest", "permission", "", "onPermissionResult", "onCreate", "savedInstanceState", "Landroid/os/Bundle;", "onDestroy", "onNewIntent", "intent", "Landroid/content/Intent;", "setupDependencies", "setupMessagingTheme", "setupPermissionLauncher", "showCircularProgressBarIndicator", "showRetryErrorView", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessagingActivity extends AppCompatActivity implements RuntimePermissionRequester {
    public static final String CONVERSATION_ID_KEY = "CONVERSATION_ID";
    public static final String TAG = "MessagingActivity";
    private CircularProgressIndicator circularProgressIndicator;
    private FragmentContainerView fragmentContainerView;

    @Inject
    public MessagingNavigator messagingNavigator;
    private MessagingScreenViewModel messagingScreenViewModel;

    @Inject
    public MessagingScreenViewModelFactory messagingScreenViewModelFactory;

    @Inject
    public MessagingSettings messagingSettings;
    private MessagingTheme messagingTheme;
    private RuntimePermissionLauncher permissionLauncher;
    private RetryErrorView retryErrorView;
    private final Function1<RetryErrorRendering, RetryErrorRendering> retryErrorViewRendering = new Function1<RetryErrorRendering, RetryErrorRendering>() {
        {
            super(1);
        }

        @Override
        public final RetryErrorRendering invoke(RetryErrorRendering retryErrorRendering) {
            Intrinsics.checkNotNullParameter(retryErrorRendering, "retryErrorRendering");
            RetryErrorRendering.Builder builder = retryErrorRendering.toBuilder();
            final MessagingActivity messagingActivity = this.this$0;
            RetryErrorRendering.Builder builderState = builder.state(new Function1<RetryErrorState, RetryErrorState>() {
                {
                    super(1);
                }

                @Override
                public final RetryErrorState invoke(RetryErrorState state) {
                    Intrinsics.checkNotNullParameter(state, "state");
                    MessagingTheme messagingTheme = messagingActivity.messagingTheme;
                    MessagingTheme messagingTheme2 = null;
                    if (messagingTheme == null) {
                        Intrinsics.throwUninitializedPropertyAccessException("messagingTheme");
                        messagingTheme = null;
                    }
                    int onBackgroundColor = messagingTheme.getOnBackgroundColor();
                    String string = messagingActivity.getString(C1256R.string.zuia_conversation_message_label_tap_to_retry);
                    MessagingTheme messagingTheme3 = messagingActivity.messagingTheme;
                    if (messagingTheme3 == null) {
                        Intrinsics.throwUninitializedPropertyAccessException("messagingTheme");
                    } else {
                        messagingTheme2 = messagingTheme3;
                    }
                    int onBackgroundColor2 = messagingTheme2.getOnBackgroundColor();
                    String string2 = messagingActivity.getString(C1256R.string.zuia_conversations_list_tap_to_retry_message_label);
                    Intrinsics.checkNotNull(string2);
                    Intrinsics.checkNotNull(string);
                    return state.copy(string2, onBackgroundColor2, string, onBackgroundColor);
                }
            });
            final MessagingActivity messagingActivity2 = this.this$0;
            return builderState.onButtonClicked(new Function0<Unit>() {
                {
                    super(0);
                }

                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }

                public final void invoke2() {
                    MessagingScreenViewModel messagingScreenViewModel = messagingActivity2.messagingScreenViewModel;
                    if (messagingScreenViewModel == null) {
                        Intrinsics.throwUninitializedPropertyAccessException("messagingScreenViewModel");
                        messagingScreenViewModel = null;
                    }
                    messagingScreenViewModel.process(MessagingScreenAction.ResolveScreen.INSTANCE);
                }
            }).build();
        }
    };

    @Inject
    public UserColors userDarkColors;

    @Inject
    public UserColors userLightColors;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.messagingscreen.MessagingActivity", m37f = "MessagingActivity.kt", m38i = {}, m39l = {108}, m40m = "collectStateUpdates", m41n = {}, m42s = {})
    static final class C15121 extends ContinuationImpl {
        int label;
        Object result;

        C15121(Continuation<? super C15121> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return MessagingActivity.this.collectStateUpdates(this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.messagingscreen.MessagingActivity", m37f = "MessagingActivity.kt", m38i = {0}, m39l = {157}, m40m = "setupDependencies", m41n = {"this"}, m42s = {"L$0"})
    static final class C15181 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C15181(Continuation<? super C15181> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return MessagingActivity.this.setupDependencies(this);
        }
    }

    @Named(MessagingComponentKt.USER_DARK_COLORS)
    public static void getUserDarkColors$annotations() {
    }

    @Named(MessagingComponentKt.USER_LIGHT_COLORS)
    public static void getUserLightColors$annotations() {
    }

    public final MessagingSettings getMessagingSettings() {
        MessagingSettings messagingSettings = this.messagingSettings;
        if (messagingSettings != null) {
            return messagingSettings;
        }
        Intrinsics.throwUninitializedPropertyAccessException("messagingSettings");
        return null;
    }

    public final void setMessagingSettings(MessagingSettings messagingSettings) {
        Intrinsics.checkNotNullParameter(messagingSettings, "<set-?>");
        this.messagingSettings = messagingSettings;
    }

    public final UserColors getUserDarkColors() {
        UserColors userColors = this.userDarkColors;
        if (userColors != null) {
            return userColors;
        }
        Intrinsics.throwUninitializedPropertyAccessException(MessagingComponentKt.USER_DARK_COLORS);
        return null;
    }

    public final void setUserDarkColors(UserColors userColors) {
        Intrinsics.checkNotNullParameter(userColors, "<set-?>");
        this.userDarkColors = userColors;
    }

    public final UserColors getUserLightColors() {
        UserColors userColors = this.userLightColors;
        if (userColors != null) {
            return userColors;
        }
        Intrinsics.throwUninitializedPropertyAccessException(MessagingComponentKt.USER_LIGHT_COLORS);
        return null;
    }

    public final void setUserLightColors(UserColors userColors) {
        Intrinsics.checkNotNullParameter(userColors, "<set-?>");
        this.userLightColors = userColors;
    }

    public final MessagingScreenViewModelFactory getMessagingScreenViewModelFactory() {
        MessagingScreenViewModelFactory messagingScreenViewModelFactory = this.messagingScreenViewModelFactory;
        if (messagingScreenViewModelFactory != null) {
            return messagingScreenViewModelFactory;
        }
        Intrinsics.throwUninitializedPropertyAccessException("messagingScreenViewModelFactory");
        return null;
    }

    public final void setMessagingScreenViewModelFactory(MessagingScreenViewModelFactory messagingScreenViewModelFactory) {
        Intrinsics.checkNotNullParameter(messagingScreenViewModelFactory, "<set-?>");
        this.messagingScreenViewModelFactory = messagingScreenViewModelFactory;
    }

    public final MessagingNavigator getMessagingNavigator() {
        MessagingNavigator messagingNavigator = this.messagingNavigator;
        if (messagingNavigator != null) {
            return messagingNavigator;
        }
        Intrinsics.throwUninitializedPropertyAccessException("messagingNavigator");
        return null;
    }

    public final void setMessagingNavigator(MessagingNavigator messagingNavigator) {
        Intrinsics.checkNotNullParameter(messagingNavigator, "<set-?>");
        this.messagingNavigator = messagingNavigator;
    }

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(C1256R.layout.zma_screen_messaging);
        setupPermissionLauncher();
        RetryErrorView retryErrorViewFindViewById = findViewById(C1256R.id.zma_retry_error_view);
        Intrinsics.checkNotNullExpressionValue(retryErrorViewFindViewById, "findViewById(...)");
        this.retryErrorView = retryErrorViewFindViewById;
        FragmentContainerView fragmentContainerViewFindViewById = findViewById(C1256R.id.zma_fragment_container);
        Intrinsics.checkNotNullExpressionValue(fragmentContainerViewFindViewById, "findViewById(...)");
        this.fragmentContainerView = fragmentContainerViewFindViewById;
        CircularProgressIndicator circularProgressIndicatorFindViewById = findViewById(C1256R.id.zuia_progress_bar_indicator);
        Intrinsics.checkNotNullExpressionValue(circularProgressIndicatorFindViewById, "findViewById(...)");
        this.circularProgressIndicator = circularProgressIndicatorFindViewById;
        BuildersKt__Builders_commonKt.launch$default(LifecycleOwnerKt.getLifecycleScope((LifecycleOwner) this), null, null, new C15151(null), 3, null);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.messagingscreen.MessagingActivity$onCreate$1", m37f = "MessagingActivity.kt", m38i = {}, m39l = {78, 80}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C15151 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C15151(Continuation<? super C15151> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return MessagingActivity.this.new C15151(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C15151) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (MessagingActivity.this.setupDependencies(this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i == 1) {
                    ResultKt.throwOnFailure(obj);
                } else {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                return Unit.INSTANCE;
            }
            MessagingActivity.this.setupMessagingTheme();
            this.label = 2;
            if (RepeatOnLifecycleKt.repeatOnLifecycle(MessagingActivity.this, Lifecycle.State.STARTED, new AnonymousClass1(MessagingActivity.this, null), this) == coroutine_suspended) {
                return coroutine_suspended;
            }
            return Unit.INSTANCE;
        }

        @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
        @DebugMetadata(m36c = "zendesk.messaging.android.internal.messagingscreen.MessagingActivity$onCreate$1$1", m37f = "MessagingActivity.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
        static final class AnonymousClass1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
            private Object L$0;
            int label;
            final MessagingActivity this$0;

            AnonymousClass1(MessagingActivity messagingActivity, Continuation<? super AnonymousClass1> continuation) {
                super(2, continuation);
                this.this$0 = messagingActivity;
            }

            @Override
            public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                AnonymousClass1 anonymousClass1 = new AnonymousClass1(this.this$0, continuation);
                anonymousClass1.L$0 = obj;
                return anonymousClass1;
            }

            @Override
            public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                return ((AnonymousClass1) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
            }

            @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
            @DebugMetadata(m36c = "zendesk.messaging.android.internal.messagingscreen.MessagingActivity$onCreate$1$1$1", m37f = "MessagingActivity.kt", m38i = {}, m39l = {ConversationMsg.TYPE_ADMIN_IMAGE}, m40m = "invokeSuspend", m41n = {}, m42s = {})
            static final class C16811 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                int label;
                final MessagingActivity this$0;

                C16811(MessagingActivity messagingActivity, Continuation<? super C16811> continuation) {
                    super(2, continuation);
                    this.this$0 = messagingActivity;
                }

                @Override
                public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                    return new C16811(this.this$0, continuation);
                }

                @Override
                public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                    return ((C16811) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
                }

                @Override
                public final Object invokeSuspend(Object obj) throws Throwable {
                    Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                    int i = this.label;
                    if (i == 0) {
                        ResultKt.throwOnFailure(obj);
                        this.label = 1;
                        if (this.this$0.collectStateUpdates(this) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                    } else {
                        if (i != 1) {
                            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                        }
                        ResultKt.throwOnFailure(obj);
                    }
                    return Unit.INSTANCE;
                }
            }

            @Override
            public final Object invokeSuspend(Object obj) throws Throwable {
                IntrinsicsKt.getCOROUTINE_SUSPENDED();
                if (this.label == 0) {
                    ResultKt.throwOnFailure(obj);
                    BuildersKt__Builders_commonKt.launch$default((CoroutineScope) this.L$0, null, null, new C16811(this.this$0, null), 3, null);
                    return Unit.INSTANCE;
                }
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
        }
    }

    protected void onDestroy() {
        super.onDestroy();
        Lifecycle lifecycle = getLifecycle();
        RuntimePermissionLauncher runtimePermissionLauncher = this.permissionLauncher;
        if (runtimePermissionLauncher == null) {
            Intrinsics.throwUninitializedPropertyAccessException("permissionLauncher");
            runtimePermissionLauncher = null;
        }
        lifecycle.removeObserver((LifecycleObserver) runtimePermissionLauncher);
    }

    protected void onNewIntent(Intent intent) {
        Intrinsics.checkNotNullParameter(intent, "intent");
        super.onNewIntent(intent);
        String stringExtra = intent.getStringExtra(CONVERSATION_ID_KEY);
        MessagingScreenViewModel messagingScreenViewModel = this.messagingScreenViewModel;
        if (messagingScreenViewModel == null) {
            Intrinsics.throwUninitializedPropertyAccessException("messagingScreenViewModel");
            messagingScreenViewModel = null;
        }
        messagingScreenViewModel.process(new MessagingScreenAction.LaunchConversationScreenFromNotification(stringExtra, null, 2, null));
    }

    public final Object collectStateUpdates(Continuation<? super Unit> continuation) throws Throwable {
        C15121 c15121;
        if (continuation instanceof C15121) {
            c15121 = (C15121) continuation;
            if ((c15121.label & Integer.MIN_VALUE) != 0) {
                c15121.label -= Integer.MIN_VALUE;
            } else {
                c15121 = new C15121(continuation);
            }
        } else {
            c15121 = new C15121(continuation);
        }
        Object obj = c15121.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c15121.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            MessagingScreenViewModel messagingScreenViewModel = this.messagingScreenViewModel;
            if (messagingScreenViewModel == null) {
                Intrinsics.throwUninitializedPropertyAccessException("messagingScreenViewModel");
                messagingScreenViewModel = null;
            }
            StateFlow<MessagingScreenState> messagingScreenState = messagingScreenViewModel.getMessagingScreenState();
            FlowCollector<? super MessagingScreenState> flowCollector = new FlowCollector() {
                @Override
                public Object emit(Object obj2, Continuation continuation2) {
                    return emit((MessagingScreenState) obj2, (Continuation<? super Unit>) continuation2);
                }

                public final Object emit(MessagingScreenState messagingScreenState2, Continuation<? super Unit> continuation2) {
                    if (messagingScreenState2 instanceof MessagingScreenState.Loading) {
                        MessagingActivity.this.hideRetryErrorViewIfNeeded();
                        MessagingActivity.this.showCircularProgressBarIndicator();
                    } else if (messagingScreenState2 instanceof MessagingScreenState.Success) {
                        if (MessagingActivity.this.isFragmentContainerEmpty() || ((MessagingScreenState.Success) messagingScreenState2).isPushNotification()) {
                            MessagingNavigator messagingNavigator = MessagingActivity.this.getMessagingNavigator();
                            MessagingScreenState.Success success = (MessagingScreenState.Success) messagingScreenState2;
                            String tagName = MessagingFragmentScreenKtxKt.getTagName(success.getScreen());
                            MessagingFragmentScreen screen = success.getScreen();
                            Intent intent = MessagingActivity.this.getIntent();
                            Intrinsics.checkNotNullExpressionValue(intent, "getIntent(...)");
                            MessagingNavigator.navigateToScreen$default(messagingNavigator, MessagingFragmentScreenKtxKt.getInstance(screen, MessagingActivityIntentBuilderKt.getCredentials(intent)), tagName, false, null, 12, null);
                        }
                        MessagingActivity.this.hideCircularProgressBarIndicator();
                    } else if (messagingScreenState2 instanceof MessagingScreenState.Error) {
                        MessagingActivity.this.hideCircularProgressBarIndicator();
                        MessagingActivity.this.showRetryErrorView();
                    }
                    return Unit.INSTANCE;
                }
            };
            c15121.label = 1;
            if (messagingScreenState.collect(flowCollector, c15121) == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
        }
        throw new KotlinNothingValueException();
    }

    public final void setupMessagingTheme() {
        this.messagingTheme = ContextKtxKt.getMessagingTheme((Context) this, getMessagingSettings(), getUserLightColors(), getUserDarkColors());
    }

    public final Object setupDependencies(Continuation<? super Unit> continuation) throws Throwable {
        C15181 c15181;
        MessagingActivity messagingActivity;
        if (continuation instanceof C15181) {
            c15181 = (C15181) continuation;
            if ((c15181.label & Integer.MIN_VALUE) != 0) {
                c15181.label -= Integer.MIN_VALUE;
            } else {
                c15181 = new C15181(continuation);
            }
        } else {
            c15181 = new C15181(continuation);
        }
        C15181 c15182 = c15181;
        Object objMessaging$default = c15182.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c15182.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objMessaging$default);
            ZendeskCredentials.Companion companion = ZendeskCredentials.INSTANCE;
            Intent intent = getIntent();
            Intrinsics.checkNotNullExpressionValue(intent, "getIntent(...)");
            ZendeskCredentials zendeskCredentialsFromQuery = companion.fromQuery(MessagingActivityIntentBuilderKt.getCredentials(intent));
            if (zendeskCredentialsFromQuery != null) {
                c15182.L$0 = this;
                c15182.label = 1;
                objMessaging$default = ZendeskKtxKt.messaging$default(Zendesk.INSTANCE, (Context) this, zendeskCredentialsFromQuery, null, c15182, 4, null);
                if (objMessaging$default == coroutine_suspended) {
                    return coroutine_suspended;
                }
                messagingActivity = this;
            } else {
                errorHandler();
            }
            return Unit.INSTANCE;
        }
        if (i != 1) {
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
        MessagingActivity messagingActivity2 = (MessagingActivity) c15182.L$0;
        ResultKt.throwOnFailure(objMessaging$default);
        messagingActivity = messagingActivity2;
        ZendeskResult zendeskResult = (ZendeskResult) objMessaging$default;
        if (zendeskResult instanceof ZendeskResult.Failure) {
            messagingActivity.errorHandler();
        } else if (zendeskResult instanceof ZendeskResult.Success) {
            messagingActivity.initViewModel((Messaging) ((ZendeskResult.Success) zendeskResult).getValue());
        }
        return Unit.INSTANCE;
    }

    private final void initViewModel(Messaging messaging) {
        if (!(messaging instanceof DefaultMessaging)) {
            errorHandler();
        } else {
            ((DefaultMessaging) messaging).getMessagingComponent().messagingActivityComponent().create(this, (SavedStateRegistryOwner) this, getIntent().getExtras()).inject(this);
            this.messagingScreenViewModel = (MessagingScreenViewModel) new ViewModelProvider((ViewModelStoreOwner) this, getMessagingScreenViewModelFactory()).get(MessagingScreenViewModel.class);
        }
    }

    private final void errorHandler() {
        Logger.m219e(TAG, "Unable to start the messaging screen without a Messaging instance.", new Object[0]);
        finish();
    }

    public final boolean isFragmentContainerEmpty() {
        FragmentContainerView fragmentContainerView = this.fragmentContainerView;
        if (fragmentContainerView == null) {
            Intrinsics.throwUninitializedPropertyAccessException("fragmentContainerView");
            fragmentContainerView = null;
        }
        return fragmentContainerView.getChildCount() == 0;
    }

    public final void showCircularProgressBarIndicator() {
        if (isFragmentContainerEmpty()) {
            CircularProgressIndicator circularProgressIndicator = this.circularProgressIndicator;
            if (circularProgressIndicator == null) {
                Intrinsics.throwUninitializedPropertyAccessException("circularProgressIndicator");
                circularProgressIndicator = null;
            }
            circularProgressIndicator.show();
        }
    }

    public final void hideCircularProgressBarIndicator() {
        CircularProgressIndicator circularProgressIndicator = this.circularProgressIndicator;
        if (circularProgressIndicator == null) {
            Intrinsics.throwUninitializedPropertyAccessException("circularProgressIndicator");
            circularProgressIndicator = null;
        }
        circularProgressIndicator.hide();
    }

    public final void hideRetryErrorViewIfNeeded() {
        RetryErrorView retryErrorView = this.retryErrorView;
        View view = null;
        if (retryErrorView == null) {
            Intrinsics.throwUninitializedPropertyAccessException("retryErrorView");
            retryErrorView = null;
        }
        if (((View) retryErrorView).getVisibility() == 0) {
            View view2 = this.retryErrorView;
            if (view2 == null) {
                Intrinsics.throwUninitializedPropertyAccessException("retryErrorView");
            } else {
                view = view2;
            }
            view.setVisibility(8);
        }
    }

    public final void showRetryErrorView() {
        if (isFragmentContainerEmpty()) {
            RetryErrorView retryErrorView = this.retryErrorView;
            RetryErrorView retryErrorView2 = null;
            if (retryErrorView == null) {
                Intrinsics.throwUninitializedPropertyAccessException("retryErrorView");
                retryErrorView = null;
            }
            ((View) retryErrorView).setVisibility(0);
            RetryErrorView retryErrorView3 = this.retryErrorView;
            if (retryErrorView3 == null) {
                Intrinsics.throwUninitializedPropertyAccessException("retryErrorView");
            } else {
                retryErrorView2 = retryErrorView3;
            }
            retryErrorView2.render(this.retryErrorViewRendering);
        }
    }

    private final void setupPermissionLauncher() {
        LifecycleObserver runtimePermissionLauncher = new RuntimePermissionLauncher(getActivityResultRegistry(), (Context) this);
        this.permissionLauncher = runtimePermissionLauncher;
        getLifecycle().addObserver(runtimePermissionLauncher);
    }

    @Override
    public void launchSinglePermissionRequest(String permission, final Function1<? super Boolean, Unit> onPermissionResult) {
        Intrinsics.checkNotNullParameter(permission, "permission");
        RuntimePermissionLauncher runtimePermissionLauncher = this.permissionLauncher;
        if (runtimePermissionLauncher == null) {
            Intrinsics.throwUninitializedPropertyAccessException("permissionLauncher");
            runtimePermissionLauncher = null;
        }
        runtimePermissionLauncher.launchSinglePermissionRequest(permission, new Function1<Boolean, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(Boolean bool) {
                invoke(bool.booleanValue());
                return Unit.INSTANCE;
            }

            public final void invoke(boolean z) {
                Function1<Boolean, Unit> function1 = onPermissionResult;
                if (function1 != null) {
                    function1.invoke(Boolean.valueOf(z));
                }
            }
        });
    }
}
