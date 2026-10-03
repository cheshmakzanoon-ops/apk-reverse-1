package zendesk.messaging.android.internal.conversationslistscreen;

import android.content.Context;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import androidx.activity.OnBackPressedCallback;
import androidx.activity.OnBackPressedDispatcher;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleOwner;
import androidx.lifecycle.LifecycleOwnerKt;
import androidx.lifecycle.RepeatOnLifecycleKt;
import androidx.lifecycle.ViewModelProvider;
import androidx.lifecycle.ViewModelStoreOwner;
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
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt__Builders_commonKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.flow.FlowCollector;
import kotlinx.coroutines.flow.StateFlow;
import net.aihelp.data.track.data.TrackType;
import zendesk.android.Zendesk;
import zendesk.android.ZendeskCredentials;
import zendesk.android.ZendeskResult;
import zendesk.android.messaging.Messaging;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.android.messaging.model.UserColors;
import zendesk.core.android.internal.app.FeatureFlagManager;
import zendesk.core.p017ui.android.internal.model.ConversationEntry;
import zendesk.logger.Logger;
import zendesk.messaging.C1256R;
import zendesk.messaging.android.internal.DefaultMessaging;
import zendesk.messaging.android.internal.VisibleScreen;
import zendesk.messaging.android.internal.VisibleScreenTracker;
import zendesk.messaging.android.internal.conversationscreen.ConversationFragment;
import zendesk.messaging.android.internal.conversationslistscreen.p022di.ConversationListFragmentComponent;
import zendesk.messaging.android.internal.extension.ContextKtxKt;
import zendesk.messaging.android.internal.extension.ZendeskKtxKt;
import zendesk.messaging.android.internal.messagingscreen.MessagingNavigator;
import zendesk.messaging.android.internal.p023di.MessagingComponentKt;
import zendesk.messaging.android.internal.permissions.RuntimePermissionRequester;
import zendesk.ui.android.Renderer;

@Metadata(m17d1 = {"\u0000\u007f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0010\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0005*\u0001!\b\u0000\u0018\u0000 H2\u00020\u0001:\u0001HB\u0005¢\u0006\u0002\u0010\u0002J\u000e\u00100\u001a\u000201H\u0082@¢\u0006\u0002\u00102J\b\u00103\u001a\u000201H\u0002J\u0010\u00104\u001a\u0002012\u0006\u00105\u001a\u000206H\u0002J\u000e\u00107\u001a\u000201H\u0082@¢\u0006\u0002\u00102J\u0010\u00108\u001a\u0002012\u0006\u00109\u001a\u00020:H\u0016J\b\u0010;\u001a\u000201H\u0016J\b\u0010<\u001a\u000201H\u0016J\u001a\u0010=\u001a\u0002012\u0006\u0010>\u001a\u00020?2\b\u0010@\u001a\u0004\u0018\u00010AH\u0016J\u0010\u0010B\u001a\u0002012\u0006\u0010C\u001a\u00020DH\u0002J\b\u0010E\u001a\u000201H\u0002J\u000e\u0010F\u001a\u000201H\u0082@¢\u0006\u0002\u00102J\u0010\u0010G\u001a\u0002012\u0006\u00109\u001a\u00020:H\u0002R\u0014\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004X\u0082.¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082.¢\u0006\u0002\n\u0000R\u001e\u0010\b\u001a\u00020\t8\u0006@\u0006X\u0087.¢\u0006\u000e\n\u0000\u001a\u0004\b\n\u0010\u000b\"\u0004\b\f\u0010\rR\u001e\u0010\u000e\u001a\u00020\u000f8\u0006@\u0006X\u0087.¢\u0006\u000e\n\u0000\u001a\u0004\b\u0010\u0010\u0011\"\u0004\b\u0012\u0010\u0013R\u001e\u0010\u0014\u001a\u00020\u00158\u0006@\u0006X\u0087.¢\u0006\u000e\n\u0000\u001a\u0004\b\u0016\u0010\u0017\"\u0004\b\u0018\u0010\u0019R\u001e\u0010\u001a\u001a\u00020\u001b8\u0006@\u0006X\u0087.¢\u0006\u000e\n\u0000\u001a\u0004\b\u001c\u0010\u001d\"\u0004\b\u001e\u0010\u001fR\u0010\u0010 \u001a\u00020!X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\"R\u000e\u0010#\u001a\u00020$X\u0082.¢\u0006\u0002\n\u0000R$\u0010%\u001a\u00020&8\u0006@\u0006X\u0087.¢\u0006\u0014\n\u0000\u0012\u0004\b'\u0010\u0002\u001a\u0004\b(\u0010)\"\u0004\b*\u0010+R$\u0010,\u001a\u00020&8\u0006@\u0006X\u0087.¢\u0006\u0014\n\u0000\u0012\u0004\b-\u0010\u0002\u001a\u0004\b.\u0010)\"\u0004\b/\u0010+¨\u0006I"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/ConversationListFragment;", "Landroidx/fragment/app/Fragment;", "()V", "conversationListScreen", "Lzendesk/ui/android/Renderer;", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenRendering;", "conversationsListScreenViewModel", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenViewModel;", "conversationsListScreenViewModelFactory", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenViewModelFactory;", "getConversationsListScreenViewModelFactory", "()Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenViewModelFactory;", "setConversationsListScreenViewModelFactory", "(Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenViewModelFactory;)V", "featureFlagManager", "Lzendesk/core/android/internal/app/FeatureFlagManager;", "getFeatureFlagManager", "()Lzendesk/core/android/internal/app/FeatureFlagManager;", "setFeatureFlagManager", "(Lzendesk/core/android/internal/app/FeatureFlagManager;)V", "messagingNavigator", "Lzendesk/messaging/android/internal/messagingscreen/MessagingNavigator;", "getMessagingNavigator", "()Lzendesk/messaging/android/internal/messagingscreen/MessagingNavigator;", "setMessagingNavigator", "(Lzendesk/messaging/android/internal/messagingscreen/MessagingNavigator;)V", "messagingSettings", "Lzendesk/android/messaging/model/MessagingSettings;", "getMessagingSettings", "()Lzendesk/android/messaging/model/MessagingSettings;", "setMessagingSettings", "(Lzendesk/android/messaging/model/MessagingSettings;)V", "onBackPressedCallback", "zendesk/messaging/android/internal/conversationslistscreen/ConversationListFragment$onBackPressedCallback$1", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationListFragment$onBackPressedCallback$1;", "permissionRequester", "Lzendesk/messaging/android/internal/permissions/RuntimePermissionRequester;", MessagingComponentKt.USER_DARK_COLORS, "Lzendesk/android/messaging/model/UserColors;", "getUserDarkColors$annotations", "getUserDarkColors", "()Lzendesk/android/messaging/model/UserColors;", "setUserDarkColors", "(Lzendesk/android/messaging/model/UserColors;)V", MessagingComponentKt.USER_LIGHT_COLORS, "getUserLightColors$annotations", "getUserLightColors", "setUserLightColors", "collectStateUpdates", "", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "errorHandler", "initViewModel", "messaging", "Lzendesk/android/messaging/Messaging;", "navigationEvents", "onAttach", "context", "Landroid/content/Context;", "onDestroy", "onStop", "onViewCreated", "view", "Landroid/view/View;", "savedInstanceState", "Landroid/os/Bundle;", "openMessagingScreen", "conversationId", "", "requestNotificationPermission", "setupDependencies", "setupPermissionRequester", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationListFragment extends Fragment {
    private static final String ARG_CREDENTIALS = "ConversationListFragment.ARG_CREDENTIALS";

    public static final Companion INSTANCE = new Companion(null);
    private static final String LOG_TAG = "ConversationListFragment";
    public static final String NAME = "ConversationListFragment";
    private Renderer<ConversationsListScreenRendering> conversationListScreen;
    private ConversationsListScreenViewModel conversationsListScreenViewModel;

    @Inject
    public ConversationsListScreenViewModelFactory conversationsListScreenViewModelFactory;

    @Inject
    public FeatureFlagManager featureFlagManager;

    @Inject
    public MessagingNavigator messagingNavigator;

    @Inject
    public MessagingSettings messagingSettings;
    private final ConversationListFragment$onBackPressedCallback$1 onBackPressedCallback;
    private RuntimePermissionRequester permissionRequester;

    @Inject
    public UserColors userDarkColors;

    @Inject
    public UserColors userLightColors;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationslistscreen.ConversationListFragment", m37f = "ConversationListFragment.kt", m38i = {}, m39l = {143}, m40m = "collectStateUpdates", m41n = {}, m42s = {})
    static final class C14581 extends ContinuationImpl {
        int label;
        Object result;

        C14581(Continuation<? super C14581> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationListFragment.this.collectStateUpdates(this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationslistscreen.ConversationListFragment", m37f = "ConversationListFragment.kt", m38i = {0}, m39l = {220}, m40m = "setupDependencies", m41n = {"this"}, m42s = {"L$0"})
    static final class C14621 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C14621(Continuation<? super C14621> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationListFragment.this.setupDependencies(this);
        }
    }

    @Named(MessagingComponentKt.USER_DARK_COLORS)
    public static void getUserDarkColors$annotations() {
    }

    @Named(MessagingComponentKt.USER_LIGHT_COLORS)
    public static void getUserLightColors$annotations() {
    }

    public ConversationListFragment() {
        super(C1256R.layout.zma_screen_conversations_list);
        this.onBackPressedCallback = new OnBackPressedCallback() {
            {
                super(true);
            }

            public void handleOnBackPressed() {
                setEnabled(false);
                FragmentActivity activity = this.this$0.getActivity();
                if (activity != null) {
                    activity.finish();
                }
            }
        };
    }

    public final ConversationsListScreenViewModelFactory getConversationsListScreenViewModelFactory() {
        ConversationsListScreenViewModelFactory conversationsListScreenViewModelFactory = this.conversationsListScreenViewModelFactory;
        if (conversationsListScreenViewModelFactory != null) {
            return conversationsListScreenViewModelFactory;
        }
        Intrinsics.throwUninitializedPropertyAccessException("conversationsListScreenViewModelFactory");
        return null;
    }

    public final void setConversationsListScreenViewModelFactory(ConversationsListScreenViewModelFactory conversationsListScreenViewModelFactory) {
        Intrinsics.checkNotNullParameter(conversationsListScreenViewModelFactory, "<set-?>");
        this.conversationsListScreenViewModelFactory = conversationsListScreenViewModelFactory;
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

    public final FeatureFlagManager getFeatureFlagManager() {
        FeatureFlagManager featureFlagManager = this.featureFlagManager;
        if (featureFlagManager != null) {
            return featureFlagManager;
        }
        Intrinsics.throwUninitializedPropertyAccessException("featureFlagManager");
        return null;
    }

    public final void setFeatureFlagManager(FeatureFlagManager featureFlagManager) {
        Intrinsics.checkNotNullParameter(featureFlagManager, "<set-?>");
        this.featureFlagManager = featureFlagManager;
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

    public void onAttach(Context context) {
        Intrinsics.checkNotNullParameter(context, "context");
        super.onAttach(context);
        setupPermissionRequester(context);
    }

    public void onViewCreated(View view, Bundle savedInstanceState) {
        Intrinsics.checkNotNullParameter(view, "view");
        super.onViewCreated(view, savedInstanceState);
        OnBackPressedDispatcher onBackPressedDispatcher = requireActivity().getOnBackPressedDispatcher();
        LifecycleOwner viewLifecycleOwner = getViewLifecycleOwner();
        Intrinsics.checkNotNullExpressionValue(viewLifecycleOwner, "getViewLifecycleOwner(...)");
        onBackPressedDispatcher.addCallback(viewLifecycleOwner, this.onBackPressedCallback);
        Renderer<ConversationsListScreenRendering> rendererFindViewById = view.findViewById(C1256R.id.zma_conversations_list_screen);
        Intrinsics.checkNotNullExpressionValue(rendererFindViewById, "findViewById(...)");
        this.conversationListScreen = rendererFindViewById;
        LifecycleOwner viewLifecycleOwner2 = getViewLifecycleOwner();
        Intrinsics.checkNotNullExpressionValue(viewLifecycleOwner2, "getViewLifecycleOwner(...)");
        BuildersKt__Builders_commonKt.launch$default(LifecycleOwnerKt.getLifecycleScope(viewLifecycleOwner2), null, null, new C14611(null), 3, null);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationslistscreen.ConversationListFragment$onViewCreated$1", m37f = "ConversationListFragment.kt", m38i = {}, m39l = {93}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C14611 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C14611(Continuation<? super C14611> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationListFragment.this.new C14611(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C14611) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
        @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationslistscreen.ConversationListFragment$onViewCreated$1$1", m37f = "ConversationListFragment.kt", m38i = {}, m39l = {94, 104}, m40m = "invokeSuspend", m41n = {}, m42s = {})
        static final class AnonymousClass1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
            int label;
            final ConversationListFragment this$0;

            AnonymousClass1(ConversationListFragment conversationListFragment, Continuation<? super AnonymousClass1> continuation) {
                super(2, continuation);
                this.this$0 = conversationListFragment;
            }

            @Override
            public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                return new AnonymousClass1(this.this$0, continuation);
            }

            @Override
            public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                return ((AnonymousClass1) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
            }

            @Override
            public final Object invokeSuspend(Object obj) throws Throwable {
                Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                int i = this.label;
                if (i == 0) {
                    ResultKt.throwOnFailure(obj);
                    this.label = 1;
                    if (this.this$0.setupDependencies(this) == coroutine_suspended) {
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
                ConversationsListScreenViewModel conversationsListScreenViewModel = this.this$0.conversationsListScreenViewModel;
                if (conversationsListScreenViewModel == null) {
                    Intrinsics.throwUninitializedPropertyAccessException("conversationsListScreenViewModel");
                    conversationsListScreenViewModel = null;
                }
                Context contextRequireContext = this.this$0.requireContext();
                Intrinsics.checkNotNullExpressionValue(contextRequireContext, "requireContext(...)");
                conversationsListScreenViewModel.refreshTheme$zendesk_messaging_messaging_android(ContextKtxKt.getMessagingTheme(contextRequireContext, this.this$0.getMessagingSettings(), this.this$0.getUserLightColors(), this.this$0.getUserDarkColors()));
                VisibleScreenTracker.INSTANCE.clearVisibleScreens$zendesk_messaging_messaging_android();
                VisibleScreenTracker.INSTANCE.setShownScreen$zendesk_messaging_messaging_android(VisibleScreen.ConversationListScreen.INSTANCE);
                LifecycleOwner viewLifecycleOwner = this.this$0.getViewLifecycleOwner();
                Intrinsics.checkNotNullExpressionValue(viewLifecycleOwner, "getViewLifecycleOwner(...)");
                this.label = 2;
                if (RepeatOnLifecycleKt.repeatOnLifecycle(viewLifecycleOwner, Lifecycle.State.STARTED, new C16791(this.this$0, null), this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return Unit.INSTANCE;
            }

            @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
            @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationslistscreen.ConversationListFragment$onViewCreated$1$1$1", m37f = "ConversationListFragment.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
            static final class C16791 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                private Object L$0;
                int label;
                final ConversationListFragment this$0;

                C16791(ConversationListFragment conversationListFragment, Continuation<? super C16791> continuation) {
                    super(2, continuation);
                    this.this$0 = conversationListFragment;
                }

                @Override
                public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                    C16791 c16791 = new C16791(this.this$0, continuation);
                    c16791.L$0 = obj;
                    return c16791;
                }

                @Override
                public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                    return ((C16791) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
                }

                @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
                @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationslistscreen.ConversationListFragment$onViewCreated$1$1$1$1", m37f = "ConversationListFragment.kt", m38i = {}, m39l = {TrackType.TRACK_ENTRANCE_CLICK_CUSTOMER_SERVICE}, m40m = "invokeSuspend", m41n = {}, m42s = {})
                static final class C16801 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                    int label;
                    final ConversationListFragment this$0;

                    C16801(ConversationListFragment conversationListFragment, Continuation<? super C16801> continuation) {
                        super(2, continuation);
                        this.this$0 = conversationListFragment;
                    }

                    @Override
                    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                        return new C16801(this.this$0, continuation);
                    }

                    @Override
                    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                        return ((C16801) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
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
                        CoroutineScope coroutineScope = (CoroutineScope) this.L$0;
                        BuildersKt__Builders_commonKt.launch$default(coroutineScope, null, null, new C16801(this.this$0, null), 3, null);
                        BuildersKt__Builders_commonKt.launch$default(coroutineScope, null, null, new AnonymousClass2(this.this$0, null), 3, null);
                        return Unit.INSTANCE;
                    }
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }

                @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
                @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationslistscreen.ConversationListFragment$onViewCreated$1$1$1$2", m37f = "ConversationListFragment.kt", m38i = {}, m39l = {109}, m40m = "invokeSuspend", m41n = {}, m42s = {})
                static final class AnonymousClass2 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                    int label;
                    final ConversationListFragment this$0;

                    AnonymousClass2(ConversationListFragment conversationListFragment, Continuation<? super AnonymousClass2> continuation) {
                        super(2, continuation);
                        this.this$0 = conversationListFragment;
                    }

                    @Override
                    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                        return new AnonymousClass2(this.this$0, continuation);
                    }

                    @Override
                    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                        return ((AnonymousClass2) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
                    }

                    @Override
                    public final Object invokeSuspend(Object obj) throws Throwable {
                        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                        int i = this.label;
                        if (i == 0) {
                            ResultKt.throwOnFailure(obj);
                            this.label = 1;
                            if (this.this$0.navigationEvents(this) == coroutine_suspended) {
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
            }
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                LifecycleOwner viewLifecycleOwner = ConversationListFragment.this.getViewLifecycleOwner();
                Intrinsics.checkNotNullExpressionValue(viewLifecycleOwner, "getViewLifecycleOwner(...)");
                this.label = 1;
                if (RepeatOnLifecycleKt.repeatOnLifecycle(viewLifecycleOwner, Lifecycle.State.CREATED, new AnonymousClass1(ConversationListFragment.this, null), this) == coroutine_suspended) {
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

    public void onStop() {
        VisibleScreenTracker.INSTANCE.setHiddenScreen$zendesk_messaging_messaging_android(VisibleScreen.ConversationListScreen.INSTANCE);
        super.onStop();
    }

    public void onDestroy() {
        super.onDestroy();
        remove();
    }

    public final void openMessagingScreen(String conversationId) {
        String string;
        Logger.m221i("ConversationListFragment", "Showing the Conversation Screen: " + conversationId, new Object[0]);
        Bundle arguments = getArguments();
        if (arguments == null || (string = arguments.getString(ARG_CREDENTIALS)) == null) {
            return;
        }
        MessagingNavigator.navigateToScreen$default(getMessagingNavigator(), ConversationFragment.Companion.newInstance$default(ConversationFragment.INSTANCE, string, conversationId, null, 4, null), "ConversationFragment", false, null, 12, null);
    }

    public final Object collectStateUpdates(Continuation<? super Unit> continuation) throws Throwable {
        C14581 c14581;
        if (continuation instanceof C14581) {
            c14581 = (C14581) continuation;
            if ((c14581.label & Integer.MIN_VALUE) != 0) {
                c14581.label -= Integer.MIN_VALUE;
            } else {
                c14581 = new C14581(continuation);
            }
        } else {
            c14581 = new C14581(continuation);
        }
        Object obj = c14581.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c14581.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            ConversationsListScreenViewModel conversationsListScreenViewModel = this.conversationsListScreenViewModel;
            if (conversationsListScreenViewModel == null) {
                Intrinsics.throwUninitializedPropertyAccessException("conversationsListScreenViewModel");
                conversationsListScreenViewModel = null;
            }
            StateFlow<ConversationsListScreenState> conversationsListScreenStateFlow = conversationsListScreenViewModel.getConversationsListScreenStateFlow();
            FlowCollector<? super ConversationsListScreenState> flowCollector = new FlowCollector() {
                @Override
                public Object emit(Object obj2, Continuation continuation2) {
                    return emit((ConversationsListScreenState) obj2, (Continuation<? super Unit>) continuation2);
                }

                public final Object emit(final ConversationsListScreenState conversationsListScreenState, Continuation<? super Unit> continuation2) {
                    Renderer renderer = ConversationListFragment.this.conversationListScreen;
                    if (renderer == null) {
                        Intrinsics.throwUninitializedPropertyAccessException("conversationListScreen");
                        renderer = null;
                    }
                    final ConversationListFragment conversationListFragment = ConversationListFragment.this;
                    renderer.render(new Function1<ConversationsListScreenRendering, ConversationsListScreenRendering>() {
                        {
                            super(1);
                        }

                        @Override
                        public final ConversationsListScreenRendering invoke(ConversationsListScreenRendering currentRendering) {
                            Intrinsics.checkNotNullParameter(currentRendering, "currentRendering");
                            ConversationsListScreenRendering.Builder builder = currentRendering.toBuilder();
                            final ConversationsListScreenState conversationsListScreenState2 = conversationsListScreenState;
                            ConversationsListScreenRendering.Builder builderState = builder.state(new Function1<ConversationsListScreenState, ConversationsListScreenState>() {
                                {
                                    super(1);
                                }

                                @Override
                                public final ConversationsListScreenState invoke(ConversationsListScreenState it) {
                                    Intrinsics.checkNotNullParameter(it, "it");
                                    ConversationsListScreenState conversationsListScreenState3 = conversationsListScreenState2;
                                    return conversationsListScreenState3.copy((32639 & 1) != 0 ? conversationsListScreenState3.messagingTheme : null, (32639 & 2) != 0 ? conversationsListScreenState3.title : null, (32639 & 4) != 0 ? conversationsListScreenState3.description : null, (32639 & 8) != 0 ? conversationsListScreenState3.logoUrl : null, (32639 & 16) != 0 ? conversationsListScreenState3.isMultiConvoEnabled : false, (32639 & 32) != 0 ? conversationsListScreenState3.canUserCreateMoreConversations : false, (32639 & 64) != 0 ? conversationsListScreenState3.conversations : null, (32639 & 128) != 0 ? conversationsListScreenState3.connectionStatus : null, (32639 & 256) != 0 ? conversationsListScreenState3.showDeniedPermission : false, (32639 & 512) != 0 ? conversationsListScreenState3.createConversationState : null, (32639 & 1024) != 0 ? conversationsListScreenState3.conversationsListState : null, (32639 & 2048) != 0 ? conversationsListScreenState3.shouldLoadMore : false, (32639 & 4096) != 0 ? conversationsListScreenState3.currentPaginationOffset : 0, (32639 & 8192) != 0 ? conversationsListScreenState3.loadMoreStatus : null, (32639 & 16384) != 0 ? conversationsListScreenState3.receivedMessageAuthor : null);
                                }
                            });
                            final ConversationListFragment conversationListFragment2 = conversationListFragment;
                            ConversationsListScreenRendering.Builder builderOnBackButtonClicked = builderState.onBackButtonClicked(new Function0<Unit>() {
                                {
                                    super(0);
                                }

                                @Override
                                public Unit invoke() {
                                    invoke2();
                                    return Unit.INSTANCE;
                                }

                                public final void invoke2() {
                                    conversationListFragment2.requireActivity().getOnBackPressedDispatcher().onBackPressed();
                                }
                            });
                            final ConversationListFragment conversationListFragment3 = conversationListFragment;
                            ConversationsListScreenRendering.Builder builderOnCreateConversationClicked = builderOnBackButtonClicked.onCreateConversationClicked(new Function0<Unit>() {
                                {
                                    super(0);
                                }

                                @Override
                                public Unit invoke() {
                                    invoke2();
                                    return Unit.INSTANCE;
                                }

                                public final void invoke2() {
                                    ConversationsListScreenViewModel conversationsListScreenViewModel2 = conversationListFragment3.conversationsListScreenViewModel;
                                    if (conversationsListScreenViewModel2 == null) {
                                        Intrinsics.throwUninitializedPropertyAccessException("conversationsListScreenViewModel");
                                        conversationsListScreenViewModel2 = null;
                                    }
                                    conversationsListScreenViewModel2.dispatchAction(ConversationsListScreenActions.CreateConversation.INSTANCE);
                                }
                            });
                            final ConversationListFragment conversationListFragment4 = conversationListFragment;
                            ConversationsListScreenRendering.Builder builderOnListConversationClicked = builderOnCreateConversationClicked.onListConversationClicked(new Function1<ConversationEntry.ConversationItem, Unit>() {
                                {
                                    super(1);
                                }

                                @Override
                                public Unit invoke(ConversationEntry.ConversationItem conversationItem) {
                                    invoke2(conversationItem);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke2(ConversationEntry.ConversationItem entry) {
                                    Intrinsics.checkNotNullParameter(entry, "entry");
                                    conversationListFragment4.openMessagingScreen(entry.getId());
                                }
                            });
                            final ConversationListFragment conversationListFragment5 = conversationListFragment;
                            ConversationsListScreenRendering.Builder builderOnRetryButtonClicked = builderOnListConversationClicked.onRetryButtonClicked(new Function0<Unit>() {
                                {
                                    super(0);
                                }

                                @Override
                                public Unit invoke() {
                                    invoke2();
                                    return Unit.INSTANCE;
                                }

                                public final void invoke2() {
                                    ConversationsListScreenViewModel conversationsListScreenViewModel2 = conversationListFragment5.conversationsListScreenViewModel;
                                    if (conversationsListScreenViewModel2 == null) {
                                        Intrinsics.throwUninitializedPropertyAccessException("conversationsListScreenViewModel");
                                        conversationsListScreenViewModel2 = null;
                                    }
                                    conversationsListScreenViewModel2.dispatchAction(ConversationsListScreenActions.Retry.INSTANCE);
                                }
                            });
                            final ConversationListFragment conversationListFragment6 = conversationListFragment;
                            ConversationsListScreenRendering.Builder builderOnRetryPaginationClicked = builderOnRetryButtonClicked.onRetryPaginationClicked(new Function1<ConversationEntry.LoadMore, Unit>() {
                                {
                                    super(1);
                                }

                                @Override
                                public Unit invoke(ConversationEntry.LoadMore loadMore) {
                                    invoke2(loadMore);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke2(ConversationEntry.LoadMore it) {
                                    Intrinsics.checkNotNullParameter(it, "it");
                                    ConversationsListScreenViewModel conversationsListScreenViewModel2 = conversationListFragment6.conversationsListScreenViewModel;
                                    ConversationsListScreenViewModel conversationsListScreenViewModel3 = null;
                                    if (conversationsListScreenViewModel2 == null) {
                                        Intrinsics.throwUninitializedPropertyAccessException("conversationsListScreenViewModel");
                                        conversationsListScreenViewModel2 = null;
                                    }
                                    conversationsListScreenViewModel2.dispatchAction(ConversationsListScreenActions.ResetLoadMoreStatus.INSTANCE);
                                    ConversationsListScreenViewModel conversationsListScreenViewModel4 = conversationListFragment6.conversationsListScreenViewModel;
                                    if (conversationsListScreenViewModel4 == null) {
                                        Intrinsics.throwUninitializedPropertyAccessException("conversationsListScreenViewModel");
                                    } else {
                                        conversationsListScreenViewModel3 = conversationsListScreenViewModel4;
                                    }
                                    conversationsListScreenViewModel3.dispatchAction(ConversationsListScreenActions.LoadConversations.INSTANCE);
                                }
                            });
                            final ConversationListFragment conversationListFragment7 = conversationListFragment;
                            ConversationsListScreenRendering.Builder builderOnStartPaging = builderOnRetryPaginationClicked.onStartPaging(new Function0<Unit>() {
                                {
                                    super(0);
                                }

                                @Override
                                public Unit invoke() {
                                    invoke2();
                                    return Unit.INSTANCE;
                                }

                                public final void invoke2() {
                                    ConversationsListScreenViewModel conversationsListScreenViewModel2 = conversationListFragment7.conversationsListScreenViewModel;
                                    if (conversationsListScreenViewModel2 == null) {
                                        Intrinsics.throwUninitializedPropertyAccessException("conversationsListScreenViewModel");
                                        conversationsListScreenViewModel2 = null;
                                    }
                                    conversationsListScreenViewModel2.dispatchAction(ConversationsListScreenActions.LoadConversations.INSTANCE);
                                }
                            });
                            final ConversationListFragment conversationListFragment8 = conversationListFragment;
                            ConversationsListScreenRendering.Builder builderOnDismissCreateConversationError = builderOnStartPaging.onDismissCreateConversationError(new Function0<Unit>() {
                                {
                                    super(0);
                                }

                                @Override
                                public Unit invoke() {
                                    invoke2();
                                    return Unit.INSTANCE;
                                }

                                public final void invoke2() {
                                    ConversationsListScreenViewModel conversationsListScreenViewModel2 = conversationListFragment8.conversationsListScreenViewModel;
                                    if (conversationsListScreenViewModel2 == null) {
                                        Intrinsics.throwUninitializedPropertyAccessException("conversationsListScreenViewModel");
                                        conversationsListScreenViewModel2 = null;
                                    }
                                    conversationsListScreenViewModel2.dispatchAction(ConversationsListScreenActions.DismissCreateConversationError.INSTANCE);
                                }
                            });
                            final ConversationListFragment conversationListFragment9 = conversationListFragment;
                            return builderOnDismissCreateConversationError.onMessageReceivedAuthorAnnounced(new Function0<Unit>() {
                                {
                                    super(0);
                                }

                                @Override
                                public Unit invoke() {
                                    invoke2();
                                    return Unit.INSTANCE;
                                }

                                public final void invoke2() {
                                    ConversationsListScreenViewModel conversationsListScreenViewModel2 = conversationListFragment9.conversationsListScreenViewModel;
                                    if (conversationsListScreenViewModel2 == null) {
                                        Intrinsics.throwUninitializedPropertyAccessException("conversationsListScreenViewModel");
                                        conversationsListScreenViewModel2 = null;
                                    }
                                    conversationsListScreenViewModel2.dispatchAction(ConversationsListScreenActions.ResetReceivedMessageAuthor.INSTANCE);
                                }
                            }).build();
                        }
                    });
                    return Unit.INSTANCE;
                }
            };
            c14581.label = 1;
            if (conversationsListScreenStateFlow.collect(flowCollector, c14581) == coroutine_suspended) {
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

    public final Object navigationEvents(Continuation<? super Unit> continuation) {
        ConversationsListScreenViewModel conversationsListScreenViewModel = this.conversationsListScreenViewModel;
        if (conversationsListScreenViewModel == null) {
            Intrinsics.throwUninitializedPropertyAccessException("conversationsListScreenViewModel");
            conversationsListScreenViewModel = null;
        }
        Object objCollect = conversationsListScreenViewModel.getNavigationChannel().collect(new FlowCollector() {
            @Override
            public Object emit(Object obj, Continuation continuation2) {
                return emit((ConversationsListScreenNavigationEvents) obj, (Continuation<? super Unit>) continuation2);
            }

            public final Object emit(ConversationsListScreenNavigationEvents conversationsListScreenNavigationEvents, Continuation<? super Unit> continuation2) {
                if (conversationsListScreenNavigationEvents instanceof ConversationsListScreenNavigationEvents.NotificationPermissions) {
                    ConversationListFragment.this.requestNotificationPermission();
                } else if (conversationsListScreenNavigationEvents instanceof ConversationsListScreenNavigationEvents.ConversationScreen) {
                    ConversationListFragment.this.openMessagingScreen(((ConversationsListScreenNavigationEvents.ConversationScreen) conversationsListScreenNavigationEvents).getConversationId());
                }
                return Unit.INSTANCE;
            }
        }, continuation);
        return objCollect == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objCollect : Unit.INSTANCE;
    }

    public final void requestNotificationPermission() {
        if (Build.VERSION.SDK_INT >= 33) {
            RuntimePermissionRequester runtimePermissionRequester = this.permissionRequester;
            if (runtimePermissionRequester == null) {
                Intrinsics.throwUninitializedPropertyAccessException("permissionRequester");
                runtimePermissionRequester = null;
            }
            RuntimePermissionRequester.DefaultImpls.launchSinglePermissionRequest$default(runtimePermissionRequester, "android.permission.POST_NOTIFICATIONS", null, 2, null);
        }
    }

    public final Object setupDependencies(Continuation<? super Unit> continuation) throws Throwable {
        C14621 c14621;
        String string;
        ConversationListFragment conversationListFragment;
        if (continuation instanceof C14621) {
            c14621 = (C14621) continuation;
            if ((c14621.label & Integer.MIN_VALUE) != 0) {
                c14621.label -= Integer.MIN_VALUE;
            } else {
                c14621 = new C14621(continuation);
            }
        } else {
            c14621 = new C14621(continuation);
        }
        C14621 c14622 = c14621;
        Object objMessaging$default = c14622.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c14622.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objMessaging$default);
            Context contextRequireContext = requireContext();
            Intrinsics.checkNotNullExpressionValue(contextRequireContext, "requireContext(...)");
            Bundle arguments = getArguments();
            if (arguments == null || (string = arguments.getString(ARG_CREDENTIALS)) == null) {
                errorHandler();
                return Unit.INSTANCE;
            }
            ZendeskCredentials zendeskCredentialsFromQuery = ZendeskCredentials.INSTANCE.fromQuery(string);
            if (zendeskCredentialsFromQuery == null) {
                errorHandler();
                return Unit.INSTANCE;
            }
            Zendesk.Companion companion = Zendesk.INSTANCE;
            c14622.L$0 = this;
            c14622.label = 1;
            objMessaging$default = ZendeskKtxKt.messaging$default(companion, contextRequireContext, zendeskCredentialsFromQuery, null, c14622, 4, null);
            if (objMessaging$default == coroutine_suspended) {
                return coroutine_suspended;
            }
            conversationListFragment = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            conversationListFragment = (ConversationListFragment) c14622.L$0;
            ResultKt.throwOnFailure(objMessaging$default);
        }
        ZendeskResult zendeskResult = (ZendeskResult) objMessaging$default;
        if (zendeskResult instanceof ZendeskResult.Failure) {
            conversationListFragment.errorHandler();
        } else if (zendeskResult instanceof ZendeskResult.Success) {
            conversationListFragment.initViewModel((Messaging) ((ZendeskResult.Success) zendeskResult).getValue());
        }
        return Unit.INSTANCE;
    }

    private final void initViewModel(Messaging messaging) {
        if (!(messaging instanceof DefaultMessaging)) {
            errorHandler();
            return;
        }
        ConversationListFragmentComponent.Factory factoryConversationListFragmentComponent = ((DefaultMessaging) messaging).getMessagingComponent().conversationListFragmentComponent();
        FragmentActivity fragmentActivityRequireActivity = requireActivity();
        Intrinsics.checkNotNull(fragmentActivityRequireActivity, "null cannot be cast to non-null type androidx.appcompat.app.AppCompatActivity");
        factoryConversationListFragmentComponent.create((AppCompatActivity) fragmentActivityRequireActivity).inject(this);
        this.conversationsListScreenViewModel = (ConversationsListScreenViewModel) new ViewModelProvider((ViewModelStoreOwner) this, getConversationsListScreenViewModelFactory()).get(ConversationsListScreenViewModel.class);
    }

    private final void errorHandler() {
        Logger.m219e("ConversationListFragment", "Unable to show the conversation list without a Messaging instance.", new Object[0]);
        FragmentActivity activity = getActivity();
        if (activity != null) {
            activity.finish();
        }
    }

    private final void setupPermissionRequester(Context context) {
        if (context instanceof RuntimePermissionRequester) {
            this.permissionRequester = (RuntimePermissionRequester) context;
            return;
        }
        Logger.m219e("ConversationListFragment", context + " must implement RuntimePermissionRequester", new Object[0]);
    }

    @Metadata(m17d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000e\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\u0004R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000¨\u0006\n"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/ConversationListFragment$Companion;", "", "()V", "ARG_CREDENTIALS", "", "LOG_TAG", "NAME", "newInstance", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationListFragment;", "credentials", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final ConversationListFragment newInstance(String credentials) {
            Intrinsics.checkNotNullParameter(credentials, "credentials");
            ConversationListFragment conversationListFragment = new ConversationListFragment();
            Bundle bundle = new Bundle();
            bundle.putString(ConversationListFragment.ARG_CREDENTIALS, credentials);
            conversationListFragment.setArguments(bundle);
            return conversationListFragment;
        }
    }
}
