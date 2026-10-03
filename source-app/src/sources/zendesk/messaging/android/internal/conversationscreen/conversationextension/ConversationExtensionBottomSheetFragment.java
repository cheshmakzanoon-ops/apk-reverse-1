package zendesk.messaging.android.internal.conversationscreen.conversationextension;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.view.View;
import androidx.activity.OnBackPressedCallback;
import androidx.fragment.app.FragmentActivity;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleOwner;
import androidx.lifecycle.LifecycleOwnerKt;
import androidx.lifecycle.RepeatOnLifecycleKt;
import androidx.lifecycle.ViewModelProvider;
import androidx.lifecycle.ViewModelStoreOwner;
import androidx.savedstate.SavedStateRegistryOwner;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.bottomsheet.BottomSheetDialogFragment;
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
import zendesk.android.Zendesk;
import zendesk.android.ZendeskCredentials;
import zendesk.android.ZendeskResult;
import zendesk.android.messaging.Messaging;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.android.messaging.model.UserColors;
import zendesk.core.android.internal.app.FeatureFlagManager;
import zendesk.core.p017ui.android.internal.model.MessageActionSize;
import zendesk.core.p017ui.android.internal.xml.BottomSheetDialogKtxKt;
import zendesk.logger.Logger;
import zendesk.messaging.BuildConfig;
import zendesk.messaging.C1256R;
import zendesk.messaging.android.internal.DefaultMessaging;
import zendesk.messaging.android.internal.extension.ContextKtxKt;
import zendesk.messaging.android.internal.extension.ZendeskKtxKt;
import zendesk.messaging.android.internal.model.MessagingTheme;
import zendesk.messaging.android.internal.p023di.MessagingComponentKt;
import zendesk.p026ui.android.conversation.conversationextension.ConversationExtensionLoadingState;
import zendesk.p026ui.android.conversation.conversationextension.ConversationExtensionRendering;
import zendesk.p026ui.android.conversation.conversationextension.ConversationExtensionView;

@Metadata(m17d1 = {"\u0000\u0095\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\b\u0004\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u000e\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0006\n\u0002\b\u0003*\u0001\"\b\u0000\u0018\u0000 Q2\u00020\u0001:\u0001QB\u0005¢\u0006\u0002\u0010\u0002J\u000e\u00109\u001a\u00020\u0005H\u0082@¢\u0006\u0002\u0010:J\u000e\u0010;\u001a\u00020\u0005H\u0082@¢\u0006\u0002\u0010:J\b\u0010<\u001a\u00020\u0005H\u0002J\b\u0010=\u001a\u00020>H\u0002J\u0010\u0010?\u001a\u00020\u00052\u0006\u0010@\u001a\u00020AH\u0002J\b\u0010B\u001a\u00020\u0005H\u0016J\b\u0010C\u001a\u00020\u0005H\u0016J\u001a\u0010D\u001a\u00020\u00052\u0006\u0010E\u001a\u00020F2\b\u0010G\u001a\u0004\u0018\u00010HH\u0016J\u0018\u0010I\u001a\u00020\u00052\u0006\u0010J\u001a\u00020K2\u0006\u0010L\u001a\u00020MH\u0002J\b\u0010N\u001a\u00020OH\u0002J\u000e\u0010P\u001a\u00020\u0005H\u0082@¢\u0006\u0002\u0010:R\u0014\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082.¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\tX\u0082.¢\u0006\u0002\n\u0000R\u001e\u0010\n\u001a\u00020\u000b8\u0006@\u0006X\u0087.¢\u0006\u000e\n\u0000\u001a\u0004\b\f\u0010\r\"\u0004\b\u000e\u0010\u000fR$\u0010\u0010\u001a\u0018\u0012\u0004\u0012\u00020\u0012\u0012\u0004\u0012\u00020\u00120\u0011j\b\u0012\u0004\u0012\u00020\u0012`\u0013X\u0082\u0004¢\u0006\u0002\n\u0000R\u001e\u0010\u0014\u001a\u00020\u00158\u0006@\u0006X\u0087.¢\u0006\u000e\n\u0000\u001a\u0004\b\u0016\u0010\u0017\"\u0004\b\u0018\u0010\u0019R\u001e\u0010\u001a\u001a\u00020\u001b8\u0006@\u0006X\u0087.¢\u0006\u000e\n\u0000\u001a\u0004\b\u001c\u0010\u001d\"\u0004\b\u001e\u0010\u001fR\u0014\u0010 \u001a\b\u0012\u0004\u0012\u00020\u00050\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010!\u001a\u00020\"X\u0082\u0004¢\u0006\u0004\n\u0002\u0010#R\u0014\u0010$\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R)\u0010%\u001a\u001d\u0012\u0013\u0012\u00110&¢\u0006\f\b'\u0012\b\b(\u0012\u0004\b\b()\u0012\u0004\u0012\u00020\u00050\u0011X\u0082\u0004¢\u0006\u0002\n\u0000R+\u0010*\u001a\u001f\u0012\u0015\u0012\u0013\u0018\u00010&¢\u0006\f\b'\u0012\b\b(\u0012\u0004\b\b(+\u0012\u0004\u0012\u00020\u00050\u0011X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010,\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010-\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R$\u0010.\u001a\u00020/8\u0006@\u0006X\u0087.¢\u0006\u0014\n\u0000\u0012\u0004\b0\u0010\u0002\u001a\u0004\b1\u00102\"\u0004\b3\u00104R$\u00105\u001a\u00020/8\u0006@\u0006X\u0087.¢\u0006\u0014\n\u0000\u0012\u0004\b6\u0010\u0002\u001a\u0004\b7\u00102\"\u0004\b8\u00104¨\u0006R"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionBottomSheetFragment;", "Lcom/google/android/material/bottomsheet/BottomSheetDialogFragment;", "()V", "closeDialog", "Lkotlin/Function0;", "", "conversationExtensionView", "Lzendesk/ui/android/conversation/conversationextension/ConversationExtensionView;", "conversationExtensionViewModel", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionViewModel;", "conversationExtensionViewModelFactory", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionViewModelFactory;", "getConversationExtensionViewModelFactory", "()Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionViewModelFactory;", "setConversationExtensionViewModelFactory", "(Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionViewModelFactory;)V", "defaultRendering", "Lkotlin/Function1;", "Lzendesk/ui/android/conversation/conversationextension/ConversationExtensionRendering;", "Lzendesk/messaging/android/internal/conversationscreen/RenderingUpdate;", "featureFlagManager", "Lzendesk/core/android/internal/app/FeatureFlagManager;", "getFeatureFlagManager", "()Lzendesk/core/android/internal/app/FeatureFlagManager;", "setFeatureFlagManager", "(Lzendesk/core/android/internal/app/FeatureFlagManager;)V", "messagingSettings", "Lzendesk/android/messaging/model/MessagingSettings;", "getMessagingSettings", "()Lzendesk/android/messaging/model/MessagingSettings;", "setMessagingSettings", "(Lzendesk/android/messaging/model/MessagingSettings;)V", "onBackButtonClicked", "onBackPressedCallback", "zendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionBottomSheetFragment$onBackPressedCallback$1", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionBottomSheetFragment$onBackPressedCallback$1;", "onRetryButtonClicked", "onUrlUpdated", "", "Lkotlin/ParameterName;", "name", "url", "onWebSdkUpdateTitle", "title", "onWebViewError", "pageLoadingComplete", MessagingComponentKt.USER_DARK_COLORS, "Lzendesk/android/messaging/model/UserColors;", "getUserDarkColors$annotations", "getUserDarkColors", "()Lzendesk/android/messaging/model/UserColors;", "setUserDarkColors", "(Lzendesk/android/messaging/model/UserColors;)V", MessagingComponentKt.USER_LIGHT_COLORS, "getUserLightColors$annotations", "getUserLightColors", "setUserLightColors", "collectEvents", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "collectStateUpdates", "errorHandler", "getMessagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "initConversationExtensionViewModel", "messaging", "Lzendesk/android/messaging/Messaging;", "onDestroy", "onStart", "onViewCreated", "view", "Landroid/view/View;", "savedInstanceState", "Landroid/os/Bundle;", "renderSate", "state", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionState;", "contentState", "Lzendesk/ui/android/conversation/conversationextension/ConversationExtensionLoadingState;", "screenSize", "", "setupConversationExtensionDependencies", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationExtensionBottomSheetFragment extends BottomSheetDialogFragment {
    public static final String ARG_CONVERSATION_EXTENSION_SIZE = "ConversationExtensionBottomSheetFragment.ARG_CONVERSATION_EXTENSION_SIZE";
    public static final String ARG_CONVERSATION_EXTENSION_URL = "ConversationExtensionBottomSheetFragment.ARG_CONVERSATION_EXTENSION_URL";
    private static final String ARG_CREDENTIALS = "ConversationExtensionBottomSheetFragment.ARG_CREDENTIALS";
    private static final double COMPACT_SCREEN_SIZE = 0.5d;

    public static final Companion INSTANCE = new Companion(null);
    private static final double FULL_SCREEN_SIZE = 1.0d;
    public static final String LOG_TAG = "ConversationExtFrag";
    private static final String SIZE_COMPACT = "COMPACT";
    private static final String SIZE_FULL = "FULL";
    private static final String SIZE_TALL = "TALL";
    public static final String TAG = "ConversationExtensionBottomSheetFragment";
    private static final double TALL_SCREEN_SIZE = 0.7d;
    private final Function0<Unit> closeDialog;
    private ConversationExtensionView conversationExtensionView;
    private ConversationExtensionViewModel conversationExtensionViewModel;

    @Inject
    public ConversationExtensionViewModelFactory conversationExtensionViewModelFactory;
    private final Function1<ConversationExtensionRendering, ConversationExtensionRendering> defaultRendering;

    @Inject
    public FeatureFlagManager featureFlagManager;

    @Inject
    public MessagingSettings messagingSettings;
    private final Function0<Unit> onBackButtonClicked;
    private final ConversationExtensionBottomSheetFragment$onBackPressedCallback$1 onBackPressedCallback;
    private final Function0<Unit> onRetryButtonClicked;
    private final Function1<String, Unit> onUrlUpdated;
    private final Function1<String, Unit> onWebSdkUpdateTitle;
    private final Function0<Unit> onWebViewError;
    private final Function0<Unit> pageLoadingComplete;

    @Inject
    public UserColors userDarkColors;

    @Inject
    public UserColors userLightColors;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.conversationextension.ConversationExtensionBottomSheetFragment", m37f = "ConversationExtensionBottomSheetFragment.kt", m38i = {}, m39l = {192}, m40m = "collectStateUpdates", m41n = {}, m42s = {})
    static final class C13791 extends ContinuationImpl {
        int label;
        Object result;

        C13791(Continuation<? super C13791> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationExtensionBottomSheetFragment.this.collectStateUpdates(this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.conversationextension.ConversationExtensionBottomSheetFragment", m37f = "ConversationExtensionBottomSheetFragment.kt", m38i = {0}, m39l = {232}, m40m = "setupConversationExtensionDependencies", m41n = {"this"}, m42s = {"L$0"})
    static final class C13841 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C13841(Continuation<? super C13841> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationExtensionBottomSheetFragment.this.setupConversationExtensionDependencies(this);
        }
    }

    @Named(MessagingComponentKt.USER_DARK_COLORS)
    public static void getUserDarkColors$annotations() {
    }

    @Named(MessagingComponentKt.USER_LIGHT_COLORS)
    public static void getUserLightColors$annotations() {
    }

    public ConversationExtensionBottomSheetFragment() {
        super(C1256R.layout.zma_bottom_sheet_conversation_extension);
        this.onBackPressedCallback = new OnBackPressedCallback() {
            {
                super(true);
            }

            public void handleOnBackPressed() {
                ConversationExtensionViewModel conversationExtensionViewModel = this.this$0.conversationExtensionViewModel;
                if (conversationExtensionViewModel == null) {
                    Intrinsics.throwUninitializedPropertyAccessException("conversationExtensionViewModel");
                    conversationExtensionViewModel = null;
                }
                conversationExtensionViewModel.process(ConversationExtensionAction.Back.INSTANCE);
            }
        };
        this.onRetryButtonClicked = new Function0<Unit>() {
            {
                super(0);
            }

            @Override
            public Unit invoke() {
                invoke2();
                return Unit.INSTANCE;
            }

            public final void invoke2() {
                ConversationExtensionViewModel conversationExtensionViewModel = this.this$0.conversationExtensionViewModel;
                if (conversationExtensionViewModel == null) {
                    Intrinsics.throwUninitializedPropertyAccessException("conversationExtensionViewModel");
                    conversationExtensionViewModel = null;
                }
                conversationExtensionViewModel.process(ConversationExtensionAction.Reload.INSTANCE);
            }
        };
        this.onWebViewError = new Function0<Unit>() {
            {
                super(0);
            }

            @Override
            public Unit invoke() {
                invoke2();
                return Unit.INSTANCE;
            }

            public final void invoke2() {
                ConversationExtensionViewModel conversationExtensionViewModel = this.this$0.conversationExtensionViewModel;
                if (conversationExtensionViewModel == null) {
                    Intrinsics.throwUninitializedPropertyAccessException("conversationExtensionViewModel");
                    conversationExtensionViewModel = null;
                }
                conversationExtensionViewModel.process(ConversationExtensionAction.WebViewError.INSTANCE);
            }
        };
        this.onWebSdkUpdateTitle = new Function1<String, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(String str) {
                invoke2(str);
                return Unit.INSTANCE;
            }

            public final void invoke2(String str) {
                ConversationExtensionViewModel conversationExtensionViewModel = this.this$0.conversationExtensionViewModel;
                if (conversationExtensionViewModel == null) {
                    Intrinsics.throwUninitializedPropertyAccessException("conversationExtensionViewModel");
                    conversationExtensionViewModel = null;
                }
                conversationExtensionViewModel.process(new ConversationExtensionAction.UpdateTitle(str));
            }
        };
        this.closeDialog = new Function0<Unit>() {
            {
                super(0);
            }

            @Override
            public Unit invoke() {
                invoke2();
                return Unit.INSTANCE;
            }

            public final void invoke2() {
                ConversationExtensionViewModel conversationExtensionViewModel = this.this$0.conversationExtensionViewModel;
                if (conversationExtensionViewModel == null) {
                    Intrinsics.throwUninitializedPropertyAccessException("conversationExtensionViewModel");
                    conversationExtensionViewModel = null;
                }
                conversationExtensionViewModel.process(ConversationExtensionAction.Close.INSTANCE);
            }
        };
        this.onBackButtonClicked = new Function0<Unit>() {
            {
                super(0);
            }

            @Override
            public Unit invoke() {
                invoke2();
                return Unit.INSTANCE;
            }

            public final void invoke2() {
                ConversationExtensionViewModel conversationExtensionViewModel = this.this$0.conversationExtensionViewModel;
                if (conversationExtensionViewModel == null) {
                    Intrinsics.throwUninitializedPropertyAccessException("conversationExtensionViewModel");
                    conversationExtensionViewModel = null;
                }
                conversationExtensionViewModel.process(ConversationExtensionAction.Back.INSTANCE);
            }
        };
        this.onUrlUpdated = new Function1<String, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(String str) {
                invoke2(str);
                return Unit.INSTANCE;
            }

            public final void invoke2(String it) {
                Intrinsics.checkNotNullParameter(it, "it");
                ConversationExtensionViewModel conversationExtensionViewModel = this.this$0.conversationExtensionViewModel;
                if (conversationExtensionViewModel == null) {
                    Intrinsics.throwUninitializedPropertyAccessException("conversationExtensionViewModel");
                    conversationExtensionViewModel = null;
                }
                conversationExtensionViewModel.process(new ConversationExtensionAction.UpdateUrl(it));
            }
        };
        this.pageLoadingComplete = new Function0<Unit>() {
            {
                super(0);
            }

            @Override
            public Unit invoke() {
                invoke2();
                return Unit.INSTANCE;
            }

            public final void invoke2() {
                ConversationExtensionViewModel conversationExtensionViewModel = this.this$0.conversationExtensionViewModel;
                if (conversationExtensionViewModel == null) {
                    Intrinsics.throwUninitializedPropertyAccessException("conversationExtensionViewModel");
                    conversationExtensionViewModel = null;
                }
                conversationExtensionViewModel.process(ConversationExtensionAction.LoadingComplete.INSTANCE);
            }
        };
        this.defaultRendering = new Function1<ConversationExtensionRendering, ConversationExtensionRendering>() {
            {
                super(1);
            }

            @Override
            public final ConversationExtensionRendering invoke(ConversationExtensionRendering conversationExtensionRendering) {
                Intrinsics.checkNotNullParameter(conversationExtensionRendering, "conversationExtensionRendering");
                return conversationExtensionRendering.toBuilder().state(new Function1<zendesk.p026ui.android.conversation.conversationextension.ConversationExtensionState, zendesk.p026ui.android.conversation.conversationextension.ConversationExtensionState>() {
                    @Override
                    public final zendesk.p026ui.android.conversation.conversationextension.ConversationExtensionState invoke(zendesk.p026ui.android.conversation.conversationextension.ConversationExtensionState it) {
                        Intrinsics.checkNotNullParameter(it, "it");
                        return zendesk.p026ui.android.conversation.conversationextension.ConversationExtensionState.copy$default(it, ConversationExtensionLoadingState.IDLE, MessagingTheme.INSTANCE.getDEFAULT().getOnBackgroundColor(), MessagingTheme.INSTANCE.getDEFAULT().getElevatedColor(), MessagingTheme.INSTANCE.getDEFAULT().getBackgroundColor(), MessagingTheme.INSTANCE.getDEFAULT().getOnBackgroundColor(), MessagingTheme.INSTANCE.getDEFAULT().getSuccessColor(), MessagingTheme.INSTANCE.getDEFAULT().getPrimaryColor(), MessagingTheme.INSTANCE.getDEFAULT().getBackgroundColor(), 0, null, null, BuildConfig.VERSION_NAME, false, 5888, null);
                    }
                }).onWebSdkUpdateTitle(this.this$0.onWebSdkUpdateTitle).onWebViewError(this.this$0.onWebViewError).onWebSdkClose(this.this$0.closeDialog).onCloseButtonClicked(this.this$0.closeDialog).onRetryButtonClicked(this.this$0.onRetryButtonClicked).onUrlUpdated(this.this$0.onUrlUpdated).onPageLoadingComplete(this.this$0.pageLoadingComplete).onBackButtonClicked(this.this$0.onBackButtonClicked).build();
            }
        };
    }

    public final ConversationExtensionViewModelFactory getConversationExtensionViewModelFactory() {
        ConversationExtensionViewModelFactory conversationExtensionViewModelFactory = this.conversationExtensionViewModelFactory;
        if (conversationExtensionViewModelFactory != null) {
            return conversationExtensionViewModelFactory;
        }
        Intrinsics.throwUninitializedPropertyAccessException("conversationExtensionViewModelFactory");
        return null;
    }

    public final void setConversationExtensionViewModelFactory(ConversationExtensionViewModelFactory conversationExtensionViewModelFactory) {
        Intrinsics.checkNotNullParameter(conversationExtensionViewModelFactory, "<set-?>");
        this.conversationExtensionViewModelFactory = conversationExtensionViewModelFactory;
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

    public final void renderSate(final ConversationExtensionState state, final ConversationExtensionLoadingState contentState) {
        ConversationExtensionView conversationExtensionView = this.conversationExtensionView;
        if (conversationExtensionView == null) {
            Intrinsics.throwUninitializedPropertyAccessException("conversationExtensionView");
            conversationExtensionView = null;
        }
        conversationExtensionView.render(new Function1<ConversationExtensionRendering, ConversationExtensionRendering>() {
            {
                super(1);
            }

            @Override
            public final ConversationExtensionRendering invoke(ConversationExtensionRendering conversationExtensionRendering) {
                Intrinsics.checkNotNullParameter(conversationExtensionRendering, "conversationExtensionRendering");
                ConversationExtensionRendering.Builder builder = conversationExtensionRendering.toBuilder();
                final ConversationExtensionBottomSheetFragment conversationExtensionBottomSheetFragment = ConversationExtensionBottomSheetFragment.this;
                final ConversationExtensionState conversationExtensionState = state;
                final ConversationExtensionLoadingState conversationExtensionLoadingState = contentState;
                return builder.state(new Function1<zendesk.p026ui.android.conversation.conversationextension.ConversationExtensionState, zendesk.p026ui.android.conversation.conversationextension.ConversationExtensionState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final zendesk.p026ui.android.conversation.conversationextension.ConversationExtensionState invoke(zendesk.p026ui.android.conversation.conversationextension.ConversationExtensionState it) {
                        Intrinsics.checkNotNullParameter(it, "it");
                        return zendesk.p026ui.android.conversation.conversationextension.ConversationExtensionState.copy$default(it, conversationExtensionLoadingState, conversationExtensionState.getMessagingTheme().getOnBackgroundColor(), conversationExtensionState.getMessagingTheme().getElevatedColor(), conversationExtensionState.getMessagingTheme().getBackgroundColor(), conversationExtensionState.getMessagingTheme().getOnBackgroundColor(), conversationExtensionState.getMessagingTheme().getSuccessColor(), conversationExtensionState.getMessagingTheme().getPrimaryColor(), conversationExtensionState.getMessagingTheme().getBackgroundColor(), 0, conversationExtensionState.getTitle(), conversationExtensionState.getUrl(), BuildConfig.VERSION_NAME, conversationExtensionBottomSheetFragment.getFeatureFlagManager().isConversationExtensionBackButtonEnabled() && !conversationExtensionState.getBackStack().isEmpty(), 256, null);
                    }
                }).onWebSdkUpdateTitle(ConversationExtensionBottomSheetFragment.this.onWebSdkUpdateTitle).onWebViewError(ConversationExtensionBottomSheetFragment.this.onWebViewError).onWebSdkClose(ConversationExtensionBottomSheetFragment.this.closeDialog).onCloseButtonClicked(ConversationExtensionBottomSheetFragment.this.closeDialog).onRetryButtonClicked(ConversationExtensionBottomSheetFragment.this.onRetryButtonClicked).onUrlUpdated(ConversationExtensionBottomSheetFragment.this.onUrlUpdated).onPageLoadingComplete(ConversationExtensionBottomSheetFragment.this.pageLoadingComplete).onBackButtonClicked(ConversationExtensionBottomSheetFragment.this.onBackButtonClicked).build();
            }
        });
    }

    public final Object collectEvents(Continuation<? super Unit> continuation) {
        ConversationExtensionViewModel conversationExtensionViewModel = this.conversationExtensionViewModel;
        if (conversationExtensionViewModel == null) {
            Intrinsics.throwUninitializedPropertyAccessException("conversationExtensionViewModel");
            conversationExtensionViewModel = null;
        }
        Object objCollect = conversationExtensionViewModel.getEventsChannel().collect(new FlowCollector() {
            @Override
            public Object emit(Object obj, Continuation continuation2) {
                return emit((ConversationExtensionEvent) obj, (Continuation<? super Unit>) continuation2);
            }

            public final Object emit(ConversationExtensionEvent conversationExtensionEvent, Continuation<? super Unit> continuation2) {
                if (Intrinsics.areEqual(conversationExtensionEvent, ConversationExtensionEvent.Close.INSTANCE)) {
                    ConversationExtensionBottomSheetFragment.this.dismiss();
                }
                return Unit.INSTANCE;
            }
        }, continuation);
        return objCollect == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objCollect : Unit.INSTANCE;
    }

    public final Object collectStateUpdates(Continuation<? super Unit> continuation) throws Throwable {
        C13791 c13791;
        if (continuation instanceof C13791) {
            c13791 = (C13791) continuation;
            if ((c13791.label & Integer.MIN_VALUE) != 0) {
                c13791.label -= Integer.MIN_VALUE;
            } else {
                c13791 = new C13791(continuation);
            }
        } else {
            c13791 = new C13791(continuation);
        }
        Object obj = c13791.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c13791.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            ConversationExtensionViewModel conversationExtensionViewModel = this.conversationExtensionViewModel;
            ConversationExtensionViewModel conversationExtensionViewModel2 = null;
            if (conversationExtensionViewModel == null) {
                Intrinsics.throwUninitializedPropertyAccessException("conversationExtensionViewModel");
                conversationExtensionViewModel = null;
            }
            ConversationExtensionViewModel conversationExtensionViewModel3 = this.conversationExtensionViewModel;
            if (conversationExtensionViewModel3 == null) {
                Intrinsics.throwUninitializedPropertyAccessException("conversationExtensionViewModel");
                conversationExtensionViewModel3 = null;
            }
            conversationExtensionViewModel.process(new ConversationExtensionAction.Load(conversationExtensionViewModel3.getConversationExtensionState().getValue().getUrl()));
            ConversationExtensionViewModel conversationExtensionViewModel4 = this.conversationExtensionViewModel;
            if (conversationExtensionViewModel4 == null) {
                Intrinsics.throwUninitializedPropertyAccessException("conversationExtensionViewModel");
            } else {
                conversationExtensionViewModel2 = conversationExtensionViewModel4;
            }
            StateFlow<ConversationExtensionState> conversationExtensionState = conversationExtensionViewModel2.getConversationExtensionState();
            FlowCollector<? super ConversationExtensionState> flowCollector = new FlowCollector() {
                @Override
                public Object emit(Object obj2, Continuation continuation2) {
                    return emit((ConversationExtensionState) obj2, (Continuation<? super Unit>) continuation2);
                }

                public final Object emit(ConversationExtensionState conversationExtensionState2, Continuation<? super Unit> continuation2) {
                    if (!(conversationExtensionState2 instanceof ConversationExtensionState.Idle)) {
                        if (conversationExtensionState2 instanceof ConversationExtensionState.Success) {
                            ConversationExtensionBottomSheetFragment.this.renderSate(conversationExtensionState2, ConversationExtensionLoadingState.SUCCESS);
                        } else if (conversationExtensionState2 instanceof ConversationExtensionState.Error) {
                            ConversationExtensionBottomSheetFragment.this.renderSate(conversationExtensionState2, ConversationExtensionLoadingState.FAILED);
                        } else if (conversationExtensionState2 instanceof ConversationExtensionState.Loading) {
                            ConversationExtensionBottomSheetFragment.this.renderSate(conversationExtensionState2, ConversationExtensionLoadingState.LOADING);
                        }
                    }
                    return Unit.INSTANCE;
                }
            };
            c13791.label = 1;
            if (conversationExtensionState.collect(flowCollector, c13791) == coroutine_suspended) {
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

    public final MessagingTheme getMessagingTheme() {
        Context contextRequireContext = requireContext();
        Intrinsics.checkNotNullExpressionValue(contextRequireContext, "requireContext(...)");
        return ContextKtxKt.getMessagingTheme(contextRequireContext, getMessagingSettings(), getUserLightColors(), getUserDarkColors());
    }

    public final Object setupConversationExtensionDependencies(Continuation<? super Unit> continuation) throws Throwable {
        C13841 c13841;
        String string;
        ConversationExtensionBottomSheetFragment conversationExtensionBottomSheetFragment;
        if (continuation instanceof C13841) {
            c13841 = (C13841) continuation;
            if ((c13841.label & Integer.MIN_VALUE) != 0) {
                c13841.label -= Integer.MIN_VALUE;
            } else {
                c13841 = new C13841(continuation);
            }
        } else {
            c13841 = new C13841(continuation);
        }
        C13841 c13842 = c13841;
        Object objMessaging$default = c13842.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c13842.label;
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
            c13842.L$0 = this;
            c13842.label = 1;
            objMessaging$default = ZendeskKtxKt.messaging$default(companion, contextRequireContext, zendeskCredentialsFromQuery, null, c13842, 4, null);
            if (objMessaging$default == coroutine_suspended) {
                return coroutine_suspended;
            }
            conversationExtensionBottomSheetFragment = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            conversationExtensionBottomSheetFragment = (ConversationExtensionBottomSheetFragment) c13842.L$0;
            ResultKt.throwOnFailure(objMessaging$default);
        }
        ZendeskResult zendeskResult = (ZendeskResult) objMessaging$default;
        if (zendeskResult instanceof ZendeskResult.Failure) {
            conversationExtensionBottomSheetFragment.errorHandler();
        } else if (zendeskResult instanceof ZendeskResult.Success) {
            conversationExtensionBottomSheetFragment.initConversationExtensionViewModel((Messaging) ((ZendeskResult.Success) zendeskResult).getValue());
        }
        return Unit.INSTANCE;
    }

    private final void initConversationExtensionViewModel(Messaging messaging) {
        if (!(messaging instanceof DefaultMessaging)) {
            errorHandler();
        } else {
            ((DefaultMessaging) messaging).getMessagingComponent().conversationExtensionFragmentComponent().create((SavedStateRegistryOwner) this, getArguments()).inject(this);
            this.conversationExtensionViewModel = (ConversationExtensionViewModel) new ViewModelProvider((ViewModelStoreOwner) this, getConversationExtensionViewModelFactory()).get(ConversationExtensionViewModel.class);
        }
    }

    public final void errorHandler() {
        Logger.m219e(LOG_TAG, "Unable to show the Conversation Extension without a Messaging instance.", new Object[0]);
        FragmentActivity activity = getActivity();
        if (activity != null) {
            activity.finish();
        }
    }

    public void onViewCreated(View view, Bundle savedInstanceState) {
        Intrinsics.checkNotNullParameter(view, "view");
        super.onViewCreated(view, savedInstanceState);
        Object objFindViewById = view.findViewById(C1256R.id.zma_conversation_extension);
        Intrinsics.checkNotNullExpressionValue(objFindViewById, "findViewById(...)");
        ConversationExtensionView conversationExtensionView = (ConversationExtensionView) objFindViewById;
        this.conversationExtensionView = conversationExtensionView;
        if (conversationExtensionView == null) {
            Intrinsics.throwUninitializedPropertyAccessException("conversationExtensionView");
            conversationExtensionView = null;
        }
        conversationExtensionView.render(this.defaultRendering);
        BottomSheetDialog bottomSheetDialogRequireDialog = requireDialog();
        Intrinsics.checkNotNull(bottomSheetDialogRequireDialog, "null cannot be cast to non-null type com.google.android.material.bottomsheet.BottomSheetDialog");
        bottomSheetDialogRequireDialog.getOnBackPressedDispatcher().addCallback(this.onBackPressedCallback);
        LifecycleOwner viewLifecycleOwner = getViewLifecycleOwner();
        Intrinsics.checkNotNullExpressionValue(viewLifecycleOwner, "getViewLifecycleOwner(...)");
        BuildersKt__Builders_commonKt.launch$default(LifecycleOwnerKt.getLifecycleScope(viewLifecycleOwner), null, null, new C13821(null), 3, null);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.conversationextension.ConversationExtensionBottomSheetFragment$onViewCreated$1", m37f = "ConversationExtensionBottomSheetFragment.kt", m38i = {}, m39l = {281}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C13821 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C13821(Continuation<? super C13821> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationExtensionBottomSheetFragment.this.new C13821(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C13821) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
        @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.conversationextension.ConversationExtensionBottomSheetFragment$onViewCreated$1$1", m37f = "ConversationExtensionBottomSheetFragment.kt", m38i = {}, m39l = {282, 293}, m40m = "invokeSuspend", m41n = {}, m42s = {})
        static final class AnonymousClass1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
            int label;
            final ConversationExtensionBottomSheetFragment this$0;

            AnonymousClass1(ConversationExtensionBottomSheetFragment conversationExtensionBottomSheetFragment, Continuation<? super AnonymousClass1> continuation) {
                super(2, continuation);
                this.this$0 = conversationExtensionBottomSheetFragment;
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
                    if (this.this$0.setupConversationExtensionDependencies(this) == coroutine_suspended) {
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
                Bundle arguments = this.this$0.getArguments();
                if ((arguments != null ? arguments.getString(ConversationExtensionBottomSheetFragment.ARG_CONVERSATION_EXTENSION_URL) : null) != null) {
                    ConversationExtensionViewModel conversationExtensionViewModel = this.this$0.conversationExtensionViewModel;
                    if (conversationExtensionViewModel == null) {
                        Intrinsics.throwUninitializedPropertyAccessException("conversationExtensionViewModel");
                        conversationExtensionViewModel = null;
                    }
                    conversationExtensionViewModel.process(new ConversationExtensionAction.RefreshTheme(this.this$0.getMessagingTheme()));
                } else {
                    this.this$0.errorHandler();
                }
                LifecycleOwner viewLifecycleOwner = this.this$0.getViewLifecycleOwner();
                Intrinsics.checkNotNullExpressionValue(viewLifecycleOwner, "getViewLifecycleOwner(...)");
                this.label = 2;
                if (RepeatOnLifecycleKt.repeatOnLifecycle(viewLifecycleOwner, Lifecycle.State.STARTED, new C16741(this.this$0, null), this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return Unit.INSTANCE;
            }

            @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
            @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.conversationextension.ConversationExtensionBottomSheetFragment$onViewCreated$1$1$1", m37f = "ConversationExtensionBottomSheetFragment.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
            static final class C16741 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                private Object L$0;
                int label;
                final ConversationExtensionBottomSheetFragment this$0;

                C16741(ConversationExtensionBottomSheetFragment conversationExtensionBottomSheetFragment, Continuation<? super C16741> continuation) {
                    super(2, continuation);
                    this.this$0 = conversationExtensionBottomSheetFragment;
                }

                @Override
                public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                    C16741 c16741 = new C16741(this.this$0, continuation);
                    c16741.L$0 = obj;
                    return c16741;
                }

                @Override
                public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                    return ((C16741) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
                }

                @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
                @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.conversationextension.ConversationExtensionBottomSheetFragment$onViewCreated$1$1$1$1", m37f = "ConversationExtensionBottomSheetFragment.kt", m38i = {}, m39l = {295}, m40m = "invokeSuspend", m41n = {}, m42s = {})
                static final class C16751 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                    int label;
                    final ConversationExtensionBottomSheetFragment this$0;

                    C16751(ConversationExtensionBottomSheetFragment conversationExtensionBottomSheetFragment, Continuation<? super C16751> continuation) {
                        super(2, continuation);
                        this.this$0 = conversationExtensionBottomSheetFragment;
                    }

                    @Override
                    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                        return new C16751(this.this$0, continuation);
                    }

                    @Override
                    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                        return ((C16751) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
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
                        BuildersKt__Builders_commonKt.launch$default(coroutineScope, null, null, new C16751(this.this$0, null), 3, null);
                        BuildersKt__Builders_commonKt.launch$default(coroutineScope, null, null, new AnonymousClass2(this.this$0, null), 3, null);
                        return Unit.INSTANCE;
                    }
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }

                @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
                @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.conversationextension.ConversationExtensionBottomSheetFragment$onViewCreated$1$1$1$2", m37f = "ConversationExtensionBottomSheetFragment.kt", m38i = {}, m39l = {298}, m40m = "invokeSuspend", m41n = {}, m42s = {})
                static final class AnonymousClass2 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                    int label;
                    final ConversationExtensionBottomSheetFragment this$0;

                    AnonymousClass2(ConversationExtensionBottomSheetFragment conversationExtensionBottomSheetFragment, Continuation<? super AnonymousClass2> continuation) {
                        super(2, continuation);
                        this.this$0 = conversationExtensionBottomSheetFragment;
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
                            if (this.this$0.collectEvents(this) == coroutine_suspended) {
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
                LifecycleOwner viewLifecycleOwner = ConversationExtensionBottomSheetFragment.this.getViewLifecycleOwner();
                Intrinsics.checkNotNullExpressionValue(viewLifecycleOwner, "getViewLifecycleOwner(...)");
                this.label = 1;
                if (RepeatOnLifecycleKt.repeatOnLifecycle(viewLifecycleOwner, Lifecycle.State.CREATED, new AnonymousClass1(ConversationExtensionBottomSheetFragment.this, null), this) == coroutine_suspended) {
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

    public void onDestroy() {
        super.onDestroy();
        remove();
    }

    public void onStart() {
        super.onStart();
        if (getResources().getConfiguration().orientation == 2) {
            Dialog dialog = getDialog();
            if (dialog != null) {
                BottomSheetDialogKtxKt.setConversationExtensionFullScreen$default(dialog, 0, false, FULL_SCREEN_SIZE, 3, null);
                return;
            }
            return;
        }
        Dialog dialog2 = getDialog();
        if (dialog2 != null) {
            BottomSheetDialogKtxKt.setConversationExtensionFullScreen$default(dialog2, 0, false, screenSize(), 3, null);
        }
    }

    private final double screenSize() {
        Bundle arguments = getArguments();
        String string = arguments != null ? arguments.getString(ARG_CONVERSATION_EXTENSION_SIZE) : null;
        if (string == null) {
            return FULL_SCREEN_SIZE;
        }
        int iHashCode = string.hashCode();
        if (iHashCode == 2169487) {
            string.equals(SIZE_FULL);
            return FULL_SCREEN_SIZE;
        }
        if (iHashCode != 2567341) {
            return (iHashCode == 1668466435 && string.equals(SIZE_COMPACT)) ? COMPACT_SCREEN_SIZE : FULL_SCREEN_SIZE;
        }
        return !string.equals(SIZE_TALL) ? FULL_SCREEN_SIZE : TALL_SCREEN_SIZE;
    }

    @Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0010\u0006\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u001e\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u00042\u0006\u0010\u0013\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u0004R\u000e\u0010\u0003\u001a\u00020\u0004X\u0080T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0004X\u0080T¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\bX\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\t\u001a\u00020\bX\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u000b\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\f\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\r\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u000f\u001a\u00020\bX\u0082T¢\u0006\u0002\n\u0000¨\u0006\u0016"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionBottomSheetFragment$Companion;", "", "()V", "ARG_CONVERSATION_EXTENSION_SIZE", "", "ARG_CONVERSATION_EXTENSION_URL", "ARG_CREDENTIALS", "COMPACT_SCREEN_SIZE", "", "FULL_SCREEN_SIZE", "LOG_TAG", "SIZE_COMPACT", "SIZE_FULL", "SIZE_TALL", "TAG", "TALL_SCREEN_SIZE", "newInstance", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionBottomSheetFragment;", "conversationExtensionUrl", "conversationExtensionSize", "Lzendesk/core/ui/android/internal/model/MessageActionSize;", "credentials", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final ConversationExtensionBottomSheetFragment newInstance(String conversationExtensionUrl, MessageActionSize conversationExtensionSize, String credentials) {
            Intrinsics.checkNotNullParameter(conversationExtensionUrl, "conversationExtensionUrl");
            Intrinsics.checkNotNullParameter(conversationExtensionSize, "conversationExtensionSize");
            Intrinsics.checkNotNullParameter(credentials, "credentials");
            ConversationExtensionBottomSheetFragment conversationExtensionBottomSheetFragment = new ConversationExtensionBottomSheetFragment();
            Bundle bundle = new Bundle();
            bundle.putString(ConversationExtensionBottomSheetFragment.ARG_CONVERSATION_EXTENSION_URL, conversationExtensionUrl);
            bundle.putString(ConversationExtensionBottomSheetFragment.ARG_CONVERSATION_EXTENSION_SIZE, conversationExtensionSize.toString());
            bundle.putString(ConversationExtensionBottomSheetFragment.ARG_CREDENTIALS, credentials);
            conversationExtensionBottomSheetFragment.setArguments(bundle);
            return conversationExtensionBottomSheetFragment;
        }
    }
}
