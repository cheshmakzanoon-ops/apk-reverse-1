package zendesk.messaging.android.internal.conversationscreen;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import androidx.activity.OnBackPressedCallback;
import androidx.activity.OnBackPressedDispatcher;
import androidx.activity.result.ActivityResultRegistry;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.FileProvider;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleObserver;
import androidx.lifecycle.LifecycleOwner;
import androidx.lifecycle.LifecycleOwnerKt;
import androidx.lifecycle.RepeatOnLifecycleKt;
import androidx.lifecycle.ViewModelProvider;
import androidx.lifecycle.ViewModelStoreOwner;
import androidx.savedstate.SavedStateRegistryOwner;
import cz.msebera.android.httpclient.HttpStatus;
import java.util.List;
import java.util.concurrent.CancellationException;
import javax.inject.Inject;
import javax.inject.Named;
import kotlin.Lazy;
import kotlin.LazyKt;
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
import kotlinx.coroutines.Job;
import kotlinx.coroutines.flow.FlowCollector;
import zendesk.android.Zendesk;
import zendesk.android.ZendeskCredentials;
import zendesk.android.ZendeskResult;
import zendesk.android.messaging.Messaging;
import zendesk.android.messaging.UrlSource;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.android.messaging.model.UserColors;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.core.android.internal.app.FeatureFlagManager;
import zendesk.core.p017ui.android.internal.model.MessageActionSize;
import zendesk.guidekit.android.GuideKit;
import zendesk.logger.Logger;
import zendesk.messaging.C1256R;
import zendesk.messaging.android.internal.AttachmentFileResolver;
import zendesk.messaging.android.internal.AttachmentIntents;
import zendesk.messaging.android.internal.AttachmentIntentsLauncher;
import zendesk.messaging.android.internal.DefaultAttachmentIntents;
import zendesk.messaging.android.internal.DefaultMessaging;
import zendesk.messaging.android.internal.UriHandler;
import zendesk.messaging.android.internal.VisibleScreen;
import zendesk.messaging.android.internal.VisibleScreenTracker;
import zendesk.messaging.android.internal.WebViewUriHandler;
import zendesk.messaging.android.internal.conversationscreen.conversationextension.ConversationExtensionBottomSheetFragment;
import zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.GuideArticleViewerBottomSheetFragment;
import zendesk.messaging.android.internal.conversationscreen.p020di.ConversationFragmentComponent;
import zendesk.messaging.android.internal.conversationslistscreen.ConversationListFragment;
import zendesk.messaging.android.internal.extension.ActivityKtxKt;
import zendesk.messaging.android.internal.extension.ContextKtxKt;
import zendesk.messaging.android.internal.extension.ZendeskKtxKt;
import zendesk.messaging.android.internal.messagingscreen.BackNavigationResolver;
import zendesk.messaging.android.internal.messagingscreen.MessagingNavigator;
import zendesk.messaging.android.internal.p023di.MessagingComponentKt;
import zendesk.messaging.android.internal.permissions.RuntimePermissionRequester;
import zendesk.messaging.android.push.internal.NotificationBuilder;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;

@Metadata(m17d1 = {"\u0000ñ\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0010\b\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0002\b\u0003*\u0001C\b\u0000\u0018\u0000 \u007f2\u00020\u0001:\u0001\u007fB\u0005¢\u0006\u0002\u0010\u0002J\u000e\u0010\\\u001a\u00020@H\u0082@¢\u0006\u0002\u0010]J\u0010\u0010^\u001a\u00020\u00162\u0006\u0010_\u001a\u00020\u0018H\u0002J\b\u0010`\u001a\u00020@H\u0002J\u0010\u0010a\u001a\u00020@2\u0006\u0010b\u001a\u00020cH\u0002J\u0010\u0010d\u001a\u00020@2\u0006\u0010e\u001a\u00020\u0014H\u0002J\u0010\u0010f\u001a\u00020@2\u0006\u0010e\u001a\u00020\u0014H\u0002J\u0018\u0010g\u001a\u00020@2\u0006\u0010e\u001a\u00020\u00142\u0006\u0010h\u001a\u00020iH\u0002J\u0010\u0010j\u001a\u00020@2\u0006\u0010k\u001a\u00020lH\u0016J\u0012\u0010m\u001a\u00020@2\b\u0010n\u001a\u0004\u0018\u00010oH\u0016J\b\u0010p\u001a\u00020@H\u0016J\b\u0010q\u001a\u00020@H\u0016J\u001a\u0010r\u001a\u00020@2\u0006\u0010s\u001a\u00020t2\b\u0010n\u001a\u0004\u0018\u00010oH\u0016J\u0010\u0010u\u001a\u00020@2\u0006\u0010v\u001a\u00020wH\u0002J\u0012\u0010x\u001a\u00020@2\b\u0010\u0013\u001a\u0004\u0018\u00010\u0014H\u0002J\b\u0010y\u001a\u00020@H\u0002J\u000e\u0010z\u001a\u00020@H\u0082@¢\u0006\u0002\u0010]J\u0010\u0010{\u001a\u00020@2\u0006\u0010k\u001a\u00020lH\u0002J\b\u0010|\u001a\u00020}H\u0002J\b\u0010~\u001a\u00020@H\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082.¢\u0006\u0002\n\u0000R\u001b\u0010\u0005\u001a\u00020\u00068BX\u0082\u0084\u0002¢\u0006\f\n\u0004\b\t\u0010\n\u001a\u0004\b\u0007\u0010\bR\u001e\u0010\u000b\u001a\u00020\f8\u0006@\u0006X\u0087.¢\u0006\u000e\n\u0000\u001a\u0004\b\r\u0010\u000e\"\u0004\b\u000f\u0010\u0010R\u0010\u0010\u0011\u001a\u0004\u0018\u00010\u0012X\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010\u0013\u001a\u0004\u0018\u00010\u0014X\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010\u0015\u001a\u0004\u0018\u00010\u0016X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0017\u001a\u00020\u0018X\u0082.¢\u0006\u0002\n\u0000R\u001e\u0010\u0019\u001a\u00020\u001a8\u0006@\u0006X\u0087.¢\u0006\u000e\n\u0000\u001a\u0004\b\u001b\u0010\u001c\"\u0004\b\u001d\u0010\u001eR\u0014\u0010\u001f\u001a\b\u0012\u0004\u0012\u00020!0 X\u0082.¢\u0006\u0002\n\u0000R\u000e\u0010\"\u001a\u00020\u0014X\u0082.¢\u0006\u0002\n\u0000R\u001e\u0010#\u001a\u00020$8\u0006@\u0006X\u0087.¢\u0006\u000e\n\u0000\u001a\u0004\b%\u0010&\"\u0004\b'\u0010(R\u0010\u0010)\u001a\u0004\u0018\u00010*X\u0082\u000e¢\u0006\u0002\n\u0000R\u001e\u0010+\u001a\u00020,8\u0006@\u0006X\u0087.¢\u0006\u000e\n\u0000\u001a\u0004\b-\u0010.\"\u0004\b/\u00100R\u001e\u00101\u001a\u0002028\u0006@\u0006X\u0087.¢\u0006\u000e\n\u0000\u001a\u0004\b3\u00104\"\u0004\b5\u00106R\u001e\u00107\u001a\u0002088\u0006@\u0006X\u0087.¢\u0006\u000e\n\u0000\u001a\u0004\b9\u0010:\"\u0004\b;\u0010<R\u001a\u0010=\u001a\u000e\u0012\u0004\u0012\u00020?\u0012\u0004\u0012\u00020@0>X\u0082\u0004¢\u0006\u0002\n\u0000R\u001c\u0010A\u001a\u0010\u0012\u0006\u0012\u0004\u0018\u00010\u0014\u0012\u0004\u0012\u00020@0>X\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010B\u001a\u00020CX\u0082\u0004¢\u0006\u0004\n\u0002\u0010DR\u001e\u0010E\u001a\u0012\u0012\u0004\u0012\u00020\u0014\u0012\u0004\u0012\u00020@0>j\u0002`FX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010G\u001a\b\u0012\u0004\u0012\u00020@0HX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010I\u001a\u00020JX\u0082.¢\u0006\u0002\n\u0000R\u0010\u0010K\u001a\u0004\u0018\u00010LX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010M\u001a\u00020NX\u0082\u0004¢\u0006\u0002\n\u0000R$\u0010O\u001a\u00020P8\u0006@\u0006X\u0087.¢\u0006\u0014\n\u0000\u0012\u0004\bQ\u0010\u0002\u001a\u0004\bR\u0010S\"\u0004\bT\u0010UR$\u0010V\u001a\u00020P8\u0006@\u0006X\u0087.¢\u0006\u0014\n\u0000\u0012\u0004\bW\u0010\u0002\u001a\u0004\bX\u0010S\"\u0004\bY\u0010UR\u000e\u0010Z\u001a\u00020[X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0080\u0001"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationFragment;", "Landroidx/fragment/app/Fragment;", "()V", "attachmentIntentLauncher", "Lzendesk/messaging/android/internal/AttachmentIntentsLauncher;", "attachmentIntents", "Lzendesk/messaging/android/internal/AttachmentIntents;", "getAttachmentIntents", "()Lzendesk/messaging/android/internal/AttachmentIntents;", "attachmentIntents$delegate", "Lkotlin/Lazy;", "backNavigationResolver", "Lzendesk/messaging/android/internal/messagingscreen/BackNavigationResolver;", "getBackNavigationResolver", "()Lzendesk/messaging/android/internal/messagingscreen/BackNavigationResolver;", "setBackNavigationResolver", "(Lzendesk/messaging/android/internal/messagingscreen/BackNavigationResolver;)V", "conversationExtensionBottomSheetFragment", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionBottomSheetFragment;", "conversationId", "", "conversationScreenCoordinator", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenCoordinator;", "conversationScreenViewModel", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenViewModel;", "conversationScreenViewModelFactory", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenViewModelFactory;", "getConversationScreenViewModelFactory", "()Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenViewModelFactory;", "setConversationScreenViewModelFactory", "(Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenViewModelFactory;)V", "conversationView", "Lzendesk/ui/android/Renderer;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenRendering;", "credentials", "featureFlagManager", "Lzendesk/core/android/internal/app/FeatureFlagManager;", "getFeatureFlagManager", "()Lzendesk/core/android/internal/app/FeatureFlagManager;", "setFeatureFlagManager", "(Lzendesk/core/android/internal/app/FeatureFlagManager;)V", "guideArticleViewerBottomSheetFragment", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerBottomSheetFragment;", "guideKit", "Lzendesk/guidekit/android/GuideKit;", "getGuideKit", "()Lzendesk/guidekit/android/GuideKit;", "setGuideKit", "(Lzendesk/guidekit/android/GuideKit;)V", "messagingNavigator", "Lzendesk/messaging/android/internal/messagingscreen/MessagingNavigator;", "getMessagingNavigator", "()Lzendesk/messaging/android/internal/messagingscreen/MessagingNavigator;", "setMessagingNavigator", "(Lzendesk/messaging/android/internal/messagingscreen/MessagingNavigator;)V", "messagingSettings", "Lzendesk/android/messaging/model/MessagingSettings;", "getMessagingSettings", "()Lzendesk/android/messaging/model/MessagingSettings;", "setMessagingSettings", "(Lzendesk/android/messaging/model/MessagingSettings;)V", "onAttachButtonClicked", "Lkotlin/Function1;", "", "", "onBackButtonClickedHandler", "onBackPressedCallback", "zendesk/messaging/android/internal/conversationscreen/ConversationFragment$onBackPressedCallback$1", "Lzendesk/messaging/android/internal/conversationscreen/ConversationFragment$onBackPressedCallback$1;", "onCopyTextAction", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnCopyTextAction;", "onDeniedPermissionActionClicked", "Lkotlin/Function0;", "permissionRequester", "Lzendesk/messaging/android/internal/permissions/RuntimePermissionRequester;", "pollingJob", "Lkotlinx/coroutines/Job;", "uriHandler", "Lzendesk/messaging/android/internal/UriHandler;", MessagingComponentKt.USER_DARK_COLORS, "Lzendesk/android/messaging/model/UserColors;", "getUserDarkColors$annotations", "getUserDarkColors", "()Lzendesk/android/messaging/model/UserColors;", "setUserDarkColors", "(Lzendesk/android/messaging/model/UserColors;)V", MessagingComponentKt.USER_LIGHT_COLORS, "getUserLightColors$annotations", "getUserLightColors", "setUserLightColors", "webViewUriHandler", "Lzendesk/messaging/android/internal/WebViewUriHandler;", "collectEvents", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "createConversationScreenCoordinator", "viewModel", "errorHandler", "initViewModel", "messaging", "Lzendesk/android/messaging/Messaging;", "launchActivity", "uri", "launchArticleViewer", "launchConversationExtension", "size", "Lzendesk/core/ui/android/internal/model/MessageActionSize;", "onAttach", "context", "Landroid/content/Context;", "onCreate", "savedInstanceState", "Landroid/os/Bundle;", "onDestroy", "onStop", "onViewCreated", "view", "Landroid/view/View;", "openFileFromStorage", "fileAttachment", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenEvent$OpenFileAttachment;", "setHiddenScreen", "setupAttachmentIntentLauncher", "setupDependencies", "setupPermissionRequester", "shouldDisplayBottomSheets", "", "startPolling", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationFragment extends Fragment {
    public static final String ARG_CONVERSATION_ID = "ConversationFragment.ARG_CONVERSATION_ID";
    private static final String ARG_CREDENTIALS = "ConversationFragment.ARG_CREDENTIALS";

    public static final Companion INSTANCE = new Companion(null);
    private static final String INTENT_URI_SCHEMA = "package";
    public static final String LOG_TAG = "ConversationFragment";
    public static final String NAME = "ConversationFragment";
    private AttachmentIntentsLauncher attachmentIntentLauncher;

    private final Lazy attachmentIntents;

    @Inject
    public BackNavigationResolver backNavigationResolver;
    private ConversationExtensionBottomSheetFragment conversationExtensionBottomSheetFragment;
    private String conversationId;
    private ConversationScreenCoordinator conversationScreenCoordinator;
    private ConversationScreenViewModel conversationScreenViewModel;

    @Inject
    public ConversationScreenViewModelFactory conversationScreenViewModelFactory;
    private Renderer<ConversationScreenRendering> conversationView;
    private String credentials;

    @Inject
    public FeatureFlagManager featureFlagManager;
    private GuideArticleViewerBottomSheetFragment guideArticleViewerBottomSheetFragment;

    @Inject
    public GuideKit guideKit;

    @Inject
    public MessagingNavigator messagingNavigator;

    @Inject
    public MessagingSettings messagingSettings;
    private final Function1<Integer, Unit> onAttachButtonClicked;
    private final Function1<String, Unit> onBackButtonClickedHandler;
    private final ConversationFragment$onBackPressedCallback$1 onBackPressedCallback;
    private final Function1<String, Unit> onCopyTextAction;
    private final Function0<Unit> onDeniedPermissionActionClicked;
    private RuntimePermissionRequester permissionRequester;
    private Job pollingJob;
    private final UriHandler uriHandler;

    @Inject
    public UserColors userDarkColors;

    @Inject
    public UserColors userLightColors;
    private final WebViewUriHandler webViewUriHandler;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationFragment", m37f = "ConversationFragment.kt", m38i = {0}, m39l = {HttpStatus.SC_NOT_FOUND}, m40m = "setupDependencies", m41n = {"this"}, m42s = {"L$0"})
    static final class C12751 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C12751(Continuation<? super C12751> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationFragment.this.setupDependencies(this);
        }
    }

    @Named(MessagingComponentKt.USER_DARK_COLORS)
    public static void getUserDarkColors$annotations() {
    }

    @Named(MessagingComponentKt.USER_LIGHT_COLORS)
    public static void getUserLightColors$annotations() {
    }

    public ConversationFragment() {
        super(C1256R.layout.zma_screen_conversation);
        this.attachmentIntents = LazyKt.lazy(new Function0<DefaultAttachmentIntents>() {
            {
                super(0);
            }

            @Override
            public final DefaultAttachmentIntents invoke() {
                Activity activityRequireActivity = this.this$0.requireActivity();
                Intrinsics.checkNotNullExpressionValue(activityRequireActivity, "requireActivity(...)");
                return new DefaultAttachmentIntents(activityRequireActivity);
            }
        });
        this.uriHandler = new UriHandler() {
            @Override
            public final void onUriClicked(String str, UrlSource urlSource, boolean z) {
                ConversationFragment.uriHandler$lambda$0(this.f$0, str, urlSource, z);
            }
        };
        this.webViewUriHandler = new WebViewUriHandler() {
            @Override
            public final void onWebViewUriClicked(String str, MessageActionSize messageActionSize, UrlSource urlSource) {
                ConversationFragment.webViewUriHandler$lambda$1(this.f$0, str, messageActionSize, urlSource);
            }
        };
        this.onCopyTextAction = new Function1<String, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(String str) {
                invoke2(str);
                return Unit.INSTANCE;
            }

            public final void invoke2(String text) {
                Intrinsics.checkNotNullParameter(text, "text");
                Object systemService = this.this$0.requireActivity().getSystemService("clipboard");
                Intrinsics.checkNotNull(systemService, "null cannot be cast to non-null type android.content.ClipboardManager");
                ClipData clipDataNewPlainText = ClipData.newPlainText("", text);
                Logger.m221i("ConversationFragment", "Copy text " + text, new Object[0]);
                ((ClipboardManager) systemService).setPrimaryClip(clipDataNewPlainText);
            }
        };
        this.onAttachButtonClicked = new Function1<Integer, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(Integer num) {
                invoke(num.intValue());
                return Unit.INSTANCE;
            }

            public final void invoke(int i) {
                ConversationScreenCoordinator conversationScreenCoordinator;
                if (this.this$0.conversationScreenCoordinator == null) {
                    Logger.m219e("ConversationFragment", "ConversationScreenCoordinator is null. Unable to perform menu item action.", new Object[0]);
                }
                if (i == R.id.menu_item_camera) {
                    ConversationScreenCoordinator conversationScreenCoordinator2 = this.this$0.conversationScreenCoordinator;
                    if (conversationScreenCoordinator2 != null) {
                        conversationScreenCoordinator2.launchCamera$zendesk_messaging_messaging_android();
                        return;
                    }
                    return;
                }
                if (i != R.id.menu_item_gallery || (conversationScreenCoordinator = this.this$0.conversationScreenCoordinator) == null) {
                    return;
                }
                conversationScreenCoordinator.launchGallery$zendesk_messaging_messaging_android();
            }
        };
        this.onBackPressedCallback = new OnBackPressedCallback() {
            {
                super(true);
            }

            public void handleOnBackPressed() {
                setEnabled(false);
                Function1 function1 = this.this$0.onBackButtonClickedHandler;
                ConversationScreenViewModel conversationScreenViewModel = this.this$0.conversationScreenViewModel;
                if (conversationScreenViewModel == null) {
                    Intrinsics.throwUninitializedPropertyAccessException("conversationScreenViewModel");
                    conversationScreenViewModel = null;
                }
                Conversation conversation = conversationScreenViewModel.getConversationScreenStateFlow().getValue().getConversation();
                function1.invoke(conversation != null ? conversation.getId() : null);
            }
        };
        this.onBackButtonClickedHandler = new Function1<String, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(String str) {
                invoke2(str);
                return Unit.INSTANCE;
            }

            public final void invoke2(String str) {
                FragmentActivity fragmentActivityRequireActivity = this.this$0.requireActivity();
                Intrinsics.checkNotNullExpressionValue(fragmentActivityRequireActivity, "requireActivity(...)");
                ActivityKtxKt.hideKeyboard(fragmentActivityRequireActivity);
                this.this$0.setHiddenScreen(str);
                BuildersKt__Builders_commonKt.launch$default(LifecycleOwnerKt.getLifecycleScope(this.this$0), null, null, new C12711(this.this$0, fragmentActivityRequireActivity, null), 3, null);
            }

            @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
            @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationFragment$onBackButtonClickedHandler$1$1", m37f = "ConversationFragment.kt", m38i = {}, m39l = {210}, m40m = "invokeSuspend", m41n = {}, m42s = {})
            static final class C12711 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                final FragmentActivity $activity;
                int label;
                final ConversationFragment this$0;

                C12711(ConversationFragment conversationFragment, FragmentActivity fragmentActivity, Continuation<? super C12711> continuation) {
                    super(2, continuation);
                    this.this$0 = conversationFragment;
                    this.$activity = fragmentActivity;
                }

                @Override
                public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                    return new C12711(this.this$0, this.$activity, continuation);
                }

                @Override
                public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                    return ((C12711) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
                }

                @Override
                public final Object invokeSuspend(Object obj) throws Throwable {
                    Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                    int i = this.label;
                    if (i == 0) {
                        ResultKt.throwOnFailure(obj);
                        this.label = 1;
                        obj = this.this$0.getBackNavigationResolver().shouldGoToConversationListScreen(this);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                    } else {
                        if (i != 1) {
                            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                        }
                        ResultKt.throwOnFailure(obj);
                    }
                    if (((Boolean) obj).booleanValue()) {
                        MessagingNavigator messagingNavigator = this.this$0.getMessagingNavigator();
                        ConversationFragment conversationFragment = this.this$0;
                        messagingNavigator.popBackCurrentScreen("ConversationFragment");
                        if (!messagingNavigator.hasScreenBeenDisplayed(ConversationListFragment.NAME)) {
                            ConversationListFragment.Companion companion = ConversationListFragment.INSTANCE;
                            String str = conversationFragment.credentials;
                            if (str == null) {
                                Intrinsics.throwUninitializedPropertyAccessException("credentials");
                                str = null;
                            }
                            MessagingNavigator.navigateToScreen$default(messagingNavigator, companion.newInstance(str), ConversationListFragment.NAME, false, null, 12, null);
                        }
                    } else {
                        this.$activity.finish();
                    }
                    return Unit.INSTANCE;
                }
            }
        };
        this.onDeniedPermissionActionClicked = new Function0<Unit>() {
            {
                super(0);
            }

            @Override
            public Unit invoke() {
                invoke2();
                return Unit.INSTANCE;
            }

            public final void invoke2() {
                Intent intent = new Intent("android.settings.APPLICATION_DETAILS_SETTINGS");
                ConversationFragment conversationFragment = this.this$0;
                intent.setData(Uri.fromParts("package", conversationFragment.requireActivity().getPackageName(), null));
                conversationFragment.startActivity(intent);
            }
        };
    }

    public final ConversationScreenViewModelFactory getConversationScreenViewModelFactory() {
        ConversationScreenViewModelFactory conversationScreenViewModelFactory = this.conversationScreenViewModelFactory;
        if (conversationScreenViewModelFactory != null) {
            return conversationScreenViewModelFactory;
        }
        Intrinsics.throwUninitializedPropertyAccessException("conversationScreenViewModelFactory");
        return null;
    }

    public final void setConversationScreenViewModelFactory(ConversationScreenViewModelFactory conversationScreenViewModelFactory) {
        Intrinsics.checkNotNullParameter(conversationScreenViewModelFactory, "<set-?>");
        this.conversationScreenViewModelFactory = conversationScreenViewModelFactory;
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

    public final GuideKit getGuideKit() {
        GuideKit guideKit = this.guideKit;
        if (guideKit != null) {
            return guideKit;
        }
        Intrinsics.throwUninitializedPropertyAccessException("guideKit");
        return null;
    }

    public final void setGuideKit(GuideKit guideKit) {
        Intrinsics.checkNotNullParameter(guideKit, "<set-?>");
        this.guideKit = guideKit;
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

    public final BackNavigationResolver getBackNavigationResolver() {
        BackNavigationResolver backNavigationResolver = this.backNavigationResolver;
        if (backNavigationResolver != null) {
            return backNavigationResolver;
        }
        Intrinsics.throwUninitializedPropertyAccessException("backNavigationResolver");
        return null;
    }

    public final void setBackNavigationResolver(BackNavigationResolver backNavigationResolver) {
        Intrinsics.checkNotNullParameter(backNavigationResolver, "<set-?>");
        this.backNavigationResolver = backNavigationResolver;
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

    private final AttachmentIntents getAttachmentIntents() {
        return (AttachmentIntents) this.attachmentIntents.getValue();
    }

    public static final void uriHandler$lambda$0(final ConversationFragment this$0, final String uri, final UrlSource source, final boolean z) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        Intrinsics.checkNotNullParameter(uri, "uri");
        Intrinsics.checkNotNullParameter(source, "source");
        if (this$0.conversationScreenCoordinator == null) {
            Logger.m219e("ConversationFragment", "Unable to handle URI.", new Object[0]);
        }
        ConversationScreenCoordinator conversationScreenCoordinator = this$0.conversationScreenCoordinator;
        if (conversationScreenCoordinator != null) {
            conversationScreenCoordinator.handleUri(uri, source, new Function0<Unit>() {
                {
                    super(0);
                }

                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }

                public final void invoke2() {
                    String str = null;
                    if (source != UrlSource.IMAGE) {
                        BuildersKt__Builders_commonKt.launch$default(LifecycleOwnerKt.getLifecycleScope(this$0), null, null, new C12772(this$0, uri, null), 3, null);
                        return;
                    }
                    Context contextRequireActivity = this$0.requireActivity();
                    Intrinsics.checkNotNullExpressionValue(contextRequireActivity, "requireActivity(...)");
                    Context context = contextRequireActivity;
                    String str2 = this$0.credentials;
                    if (str2 == null) {
                        Intrinsics.throwUninitializedPropertyAccessException("credentials");
                    } else {
                        str = str2;
                    }
                    this$0.startActivity(new ImageViewerActivityIntentBuilder(context, str).withUri(uri).withPrivateAttachmentFlag(z).getIntent());
                }

                @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
                @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationFragment$uriHandler$1$1$2", m37f = "ConversationFragment.kt", m38i = {}, m39l = {143}, m40m = "invokeSuspend", m41n = {}, m42s = {})
                static final class C12772 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                    final String $uri;
                    int label;
                    final ConversationFragment this$0;

                    C12772(ConversationFragment conversationFragment, String str, Continuation<? super C12772> continuation) {
                        super(2, continuation);
                        this.this$0 = conversationFragment;
                        this.$uri = str;
                    }

                    @Override
                    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                        return new C12772(this.this$0, this.$uri, continuation);
                    }

                    @Override
                    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                        return ((C12772) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
                    }

                    @Override
                    public final Object invokeSuspend(Object obj) throws Throwable {
                        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                        int i = this.label;
                        if (i == 0) {
                            ResultKt.throwOnFailure(obj);
                            this.label = 1;
                            obj = this.this$0.getGuideKit().isValidGuideUrl(this.$uri, this);
                            if (obj == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                        } else {
                            if (i != 1) {
                                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                            }
                            ResultKt.throwOnFailure(obj);
                        }
                        if (((Boolean) obj).booleanValue()) {
                            this.this$0.launchArticleViewer(this.$uri);
                        } else {
                            this.this$0.launchActivity(this.$uri);
                        }
                        return Unit.INSTANCE;
                    }
                }
            });
        }
    }

    public static final void webViewUriHandler$lambda$1(final ConversationFragment this$0, final String uri, final MessageActionSize size, final UrlSource source) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        Intrinsics.checkNotNullParameter(uri, "uri");
        Intrinsics.checkNotNullParameter(size, "size");
        Intrinsics.checkNotNullParameter(source, "source");
        if (this$0.conversationScreenCoordinator == null) {
            Logger.m219e("ConversationFragment", "Unable to handle URI.", new Object[0]);
        }
        ConversationScreenCoordinator conversationScreenCoordinator = this$0.conversationScreenCoordinator;
        if (conversationScreenCoordinator != null) {
            conversationScreenCoordinator.handleUri(uri, source, new Function0<Unit>() {
                {
                    super(0);
                }

                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }

                public final void invoke2() {
                    if (source == UrlSource.WEBVIEW_MESSAGE_ACTION) {
                        this$0.launchConversationExtension(uri, size);
                    } else {
                        this$0.launchActivity(uri);
                    }
                }
            });
        }
    }

    private final void setupAttachmentIntentLauncher() {
        Context contextRequireContext = requireContext();
        ActivityResultRegistry activityResultRegistry = requireActivity().getActivityResultRegistry();
        AttachmentFileResolver attachmentFileResolver = new AttachmentFileResolver();
        Function1<List<? extends Uri>, Unit> function1 = new Function1<List<? extends Uri>, Unit>() {
            {
                super(1);
            }

            public final void invoke2(List<? extends Uri> it) {
                Intrinsics.checkNotNullParameter(it, "it");
                ConversationScreenViewModel conversationScreenViewModel = ConversationFragment.this.conversationScreenViewModel;
                if (conversationScreenViewModel == null) {
                    Intrinsics.throwUninitializedPropertyAccessException("conversationScreenViewModel");
                    conversationScreenViewModel = null;
                }
                conversationScreenViewModel.saveRestoredUris(it);
            }

            @Override
            public Unit invoke(List<? extends Uri> list) {
                invoke2(list);
                return Unit.INSTANCE;
            }
        };
        Function0<Unit> function0 = new Function0<Unit>() {
            {
                super(0);
            }

            public final void invoke2() {
                ConversationScreenCoordinator conversationScreenCoordinator = ConversationFragment.this.conversationScreenCoordinator;
                if (conversationScreenCoordinator != null) {
                    conversationScreenCoordinator.m229x49623ed2();
                }
            }

            @Override
            public Unit invoke() {
                invoke2();
                return Unit.INSTANCE;
            }
        };
        Intrinsics.checkNotNull(contextRequireContext);
        LifecycleObserver attachmentIntentsLauncher = new AttachmentIntentsLauncher(activityResultRegistry, attachmentFileResolver, function1, function0, contextRequireContext);
        this.attachmentIntentLauncher = attachmentIntentsLauncher;
        getLifecycle().addObserver(attachmentIntentsLauncher);
    }

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Bundle arguments = getArguments();
        if (arguments != null) {
            this.credentials = String.valueOf(arguments.getString(ARG_CREDENTIALS));
            this.conversationId = arguments.getString(ARG_CONVERSATION_ID);
        }
    }

    public void onAttach(Context context) {
        Intrinsics.checkNotNullParameter(context, "context");
        super.onAttach(context);
        setupAttachmentIntentLauncher();
        setupPermissionRequester(context);
    }

    public void onStop() {
        ConversationScreenViewModel conversationScreenViewModel = this.conversationScreenViewModel;
        if (conversationScreenViewModel == null) {
            Intrinsics.throwUninitializedPropertyAccessException("conversationScreenViewModel");
            conversationScreenViewModel = null;
        }
        Conversation conversation = conversationScreenViewModel.getConversationScreenStateFlow().getValue().getConversation();
        setHiddenScreen(conversation != null ? conversation.getId() : null);
        super.onStop();
    }

    public void onViewCreated(View view, Bundle savedInstanceState) {
        Intrinsics.checkNotNullParameter(view, "view");
        super.onViewCreated(view, savedInstanceState);
        OnBackPressedDispatcher onBackPressedDispatcher = requireActivity().getOnBackPressedDispatcher();
        LifecycleOwner viewLifecycleOwner = getViewLifecycleOwner();
        Intrinsics.checkNotNullExpressionValue(viewLifecycleOwner, "getViewLifecycleOwner(...)");
        onBackPressedDispatcher.addCallback(viewLifecycleOwner, this.onBackPressedCallback);
        Renderer<ConversationScreenRendering> rendererFindViewById = view.findViewById(C1256R.id.zma_conversation_screen_conversation);
        Intrinsics.checkNotNullExpressionValue(rendererFindViewById, "findViewById(...)");
        this.conversationView = rendererFindViewById;
        LifecycleOwner viewLifecycleOwner2 = getViewLifecycleOwner();
        Intrinsics.checkNotNullExpressionValue(viewLifecycleOwner2, "getViewLifecycleOwner(...)");
        BuildersKt__Builders_commonKt.launch$default(LifecycleOwnerKt.getLifecycleScope(viewLifecycleOwner2), null, null, new C12721(null), 3, null);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationFragment$onViewCreated$1", m37f = "ConversationFragment.kt", m38i = {}, m39l = {285}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C12721 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C12721(Continuation<? super C12721> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationFragment.this.new C12721(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C12721) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
        @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationFragment$onViewCreated$1$1", m37f = "ConversationFragment.kt", m38i = {}, m39l = {286, 294}, m40m = "invokeSuspend", m41n = {}, m42s = {})
        static final class AnonymousClass1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
            int label;
            final ConversationFragment this$0;

            AnonymousClass1(ConversationFragment conversationFragment, Continuation<? super AnonymousClass1> continuation) {
                super(2, continuation);
                this.this$0 = conversationFragment;
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
                ConversationScreenViewModel conversationScreenViewModel = this.this$0.conversationScreenViewModel;
                if (conversationScreenViewModel == null) {
                    Intrinsics.throwUninitializedPropertyAccessException("conversationScreenViewModel");
                    conversationScreenViewModel = null;
                }
                Context contextRequireContext = this.this$0.requireContext();
                Intrinsics.checkNotNullExpressionValue(contextRequireContext, "requireContext(...)");
                conversationScreenViewModel.refreshTheme$zendesk_messaging_messaging_android(ContextKtxKt.getMessagingTheme(contextRequireContext, this.this$0.getMessagingSettings(), this.this$0.getUserLightColors(), this.this$0.getUserDarkColors()));
                LifecycleOwner viewLifecycleOwner = this.this$0.getViewLifecycleOwner();
                Intrinsics.checkNotNullExpressionValue(viewLifecycleOwner, "getViewLifecycleOwner(...)");
                this.label = 2;
                if (RepeatOnLifecycleKt.repeatOnLifecycle(viewLifecycleOwner, Lifecycle.State.STARTED, new C16691(this.this$0, null), this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return Unit.INSTANCE;
            }

            @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
            @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationFragment$onViewCreated$1$1$1", m37f = "ConversationFragment.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
            static final class C16691 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                private Object L$0;
                int label;
                final ConversationFragment this$0;

                C16691(ConversationFragment conversationFragment, Continuation<? super C16691> continuation) {
                    super(2, continuation);
                    this.this$0 = conversationFragment;
                }

                @Override
                public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                    C16691 c16691 = new C16691(this.this$0, continuation);
                    c16691.L$0 = obj;
                    return c16691;
                }

                @Override
                public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                    return ((C16691) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
                }

                @Override
                public final Object invokeSuspend(Object obj) throws Throwable {
                    IntrinsicsKt.getCOROUTINE_SUSPENDED();
                    if (this.label != 0) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                    CoroutineScope coroutineScope = (CoroutineScope) this.L$0;
                    ConversationFragment conversationFragment = this.this$0;
                    ConversationScreenViewModel conversationScreenViewModel = conversationFragment.conversationScreenViewModel;
                    if (conversationScreenViewModel == null) {
                        Intrinsics.throwUninitializedPropertyAccessException("conversationScreenViewModel");
                        conversationScreenViewModel = null;
                    }
                    conversationFragment.conversationScreenCoordinator = conversationFragment.createConversationScreenCoordinator(conversationScreenViewModel);
                    BuildersKt__Builders_commonKt.launch$default(coroutineScope, null, null, new C16701(this.this$0, null), 3, null);
                    BuildersKt__Builders_commonKt.launch$default(coroutineScope, null, null, new AnonymousClass2(this.this$0, null), 3, null);
                    if (Build.VERSION.SDK_INT >= 33) {
                        RuntimePermissionRequester runtimePermissionRequester = this.this$0.permissionRequester;
                        if (runtimePermissionRequester == null) {
                            Intrinsics.throwUninitializedPropertyAccessException("permissionRequester");
                            runtimePermissionRequester = null;
                        }
                        RuntimePermissionRequester.DefaultImpls.launchSinglePermissionRequest$default(runtimePermissionRequester, "android.permission.POST_NOTIFICATIONS", null, 2, null);
                    }
                    return Unit.INSTANCE;
                }

                @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
                @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationFragment$onViewCreated$1$1$1$1", m37f = "ConversationFragment.kt", m38i = {}, m39l = {298}, m40m = "invokeSuspend", m41n = {}, m42s = {})
                static final class C16701 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                    int label;
                    final ConversationFragment this$0;

                    C16701(ConversationFragment conversationFragment, Continuation<? super C16701> continuation) {
                        super(2, continuation);
                        this.this$0 = conversationFragment;
                    }

                    @Override
                    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                        return new C16701(this.this$0, continuation);
                    }

                    @Override
                    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                        return ((C16701) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
                    }

                    @Override
                    public final Object invokeSuspend(Object obj) throws Throwable {
                        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                        int i = this.label;
                        if (i == 0) {
                            ResultKt.throwOnFailure(obj);
                            ConversationScreenCoordinator conversationScreenCoordinator = this.this$0.conversationScreenCoordinator;
                            if (conversationScreenCoordinator != null) {
                                this.label = 1;
                                if (conversationScreenCoordinator.init$zendesk_messaging_messaging_android(this) == coroutine_suspended) {
                                    return coroutine_suspended;
                                }
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

                @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
                @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationFragment$onViewCreated$1$1$1$2", m37f = "ConversationFragment.kt", m38i = {}, m39l = {HttpStatus.SC_MOVED_PERMANENTLY}, m40m = "invokeSuspend", m41n = {}, m42s = {})
                static final class AnonymousClass2 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                    int label;
                    final ConversationFragment this$0;

                    AnonymousClass2(ConversationFragment conversationFragment, Continuation<? super AnonymousClass2> continuation) {
                        super(2, continuation);
                        this.this$0 = conversationFragment;
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
                LifecycleOwner viewLifecycleOwner = ConversationFragment.this.getViewLifecycleOwner();
                Intrinsics.checkNotNullExpressionValue(viewLifecycleOwner, "getViewLifecycleOwner(...)");
                this.label = 1;
                if (RepeatOnLifecycleKt.repeatOnLifecycle(viewLifecycleOwner, Lifecycle.State.CREATED, new AnonymousClass1(ConversationFragment.this, null), this) == coroutine_suspended) {
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
        ConversationScreenCoordinator conversationScreenCoordinator;
        FragmentActivity activity = getActivity();
        if (activity != null && !activity.isChangingConfigurations() && (conversationScreenCoordinator = this.conversationScreenCoordinator) != null) {
            conversationScreenCoordinator.clearNewMessagesDivider$zendesk_messaging_messaging_android();
        }
        remove();
        Lifecycle lifecycle = getLifecycle();
        AttachmentIntentsLauncher attachmentIntentsLauncher = this.attachmentIntentLauncher;
        if (attachmentIntentsLauncher == null) {
            Intrinsics.throwUninitializedPropertyAccessException("attachmentIntentLauncher");
            attachmentIntentsLauncher = null;
        }
        lifecycle.removeObserver((LifecycleObserver) attachmentIntentsLauncher);
        super.onDestroy();
    }

    public final void setHiddenScreen(String conversationId) {
        if (conversationId != null) {
            VisibleScreenTracker.INSTANCE.setHiddenScreen$zendesk_messaging_messaging_android(new VisibleScreen.ConversationScreen(conversationId));
        }
    }

    public final void launchActivity(String uri) {
        Intent intent = new Intent("android.intent.action.VIEW", Uri.parse(uri));
        if (intent.resolveActivity(requireActivity().getPackageManager()) != null) {
            startActivity(intent);
            return;
        }
        Logger.m219e("ConversationFragment", "Unable to find activity to launch the ACTION_VIEW intent for : " + uri, new Object[0]);
    }

    private final boolean shouldDisplayBottomSheets() {
        return getChildFragmentManager().findFragmentByTag(ConversationExtensionBottomSheetFragment.TAG) == null && getChildFragmentManager().findFragmentByTag(GuideArticleViewerBottomSheetFragment.TAG) == null;
    }

    public final void launchArticleViewer(String uri) {
        if (shouldDisplayBottomSheets()) {
            GuideArticleViewerBottomSheetFragment.Companion companion = GuideArticleViewerBottomSheetFragment.INSTANCE;
            String str = this.credentials;
            if (str == null) {
                Intrinsics.throwUninitializedPropertyAccessException("credentials");
                str = null;
            }
            GuideArticleViewerBottomSheetFragment guideArticleViewerBottomSheetFragmentNewInstance = companion.newInstance(uri, str);
            this.guideArticleViewerBottomSheetFragment = guideArticleViewerBottomSheetFragmentNewInstance;
            if (guideArticleViewerBottomSheetFragmentNewInstance != null) {
                guideArticleViewerBottomSheetFragmentNewInstance.setCancelable(false);
            }
            GuideArticleViewerBottomSheetFragment guideArticleViewerBottomSheetFragment = this.guideArticleViewerBottomSheetFragment;
            if (guideArticleViewerBottomSheetFragment != null) {
                guideArticleViewerBottomSheetFragment.show(getChildFragmentManager(), GuideArticleViewerBottomSheetFragment.TAG);
            }
        }
    }

    public final void launchConversationExtension(String uri, MessageActionSize size) {
        if (shouldDisplayBottomSheets()) {
            ConversationExtensionBottomSheetFragment.Companion companion = ConversationExtensionBottomSheetFragment.INSTANCE;
            String str = this.credentials;
            if (str == null) {
                Intrinsics.throwUninitializedPropertyAccessException("credentials");
                str = null;
            }
            ConversationExtensionBottomSheetFragment conversationExtensionBottomSheetFragmentNewInstance = companion.newInstance(uri, size, str);
            this.conversationExtensionBottomSheetFragment = conversationExtensionBottomSheetFragmentNewInstance;
            if (conversationExtensionBottomSheetFragmentNewInstance != null) {
                conversationExtensionBottomSheetFragmentNewInstance.setCancelable(false);
            }
            ConversationExtensionBottomSheetFragment conversationExtensionBottomSheetFragment = this.conversationExtensionBottomSheetFragment;
            if (conversationExtensionBottomSheetFragment != null) {
                conversationExtensionBottomSheetFragment.show(getChildFragmentManager(), ConversationExtensionBottomSheetFragment.TAG);
            }
        }
    }

    public final ConversationScreenCoordinator createConversationScreenCoordinator(ConversationScreenViewModel viewModel) {
        Renderer<ConversationScreenRendering> renderer;
        RuntimePermissionRequester runtimePermissionRequester;
        AttachmentIntentsLauncher attachmentIntentsLauncher;
        Renderer<ConversationScreenRendering> renderer2 = this.conversationView;
        if (renderer2 == null) {
            Intrinsics.throwUninitializedPropertyAccessException("conversationView");
            renderer = null;
        } else {
            renderer = renderer2;
        }
        Function1<String, Unit> function1 = this.onBackButtonClickedHandler;
        Function0<Unit> function0 = this.onDeniedPermissionActionClicked;
        Function1<Integer, Unit> function2 = this.onAttachButtonClicked;
        UriHandler uriHandler = this.uriHandler;
        WebViewUriHandler webViewUriHandler = this.webViewUriHandler;
        AttachmentIntents attachmentIntents = getAttachmentIntents();
        CoroutineScope lifecycleScope = LifecycleOwnerKt.getLifecycleScope((LifecycleOwner) this);
        VisibleScreenTracker visibleScreenTracker = VisibleScreenTracker.INSTANCE;
        MessagingSettings messagingSettings = getMessagingSettings();
        Function1<String, Unit> function3 = this.onCopyTextAction;
        RuntimePermissionRequester runtimePermissionRequester2 = this.permissionRequester;
        if (runtimePermissionRequester2 == null) {
            Intrinsics.throwUninitializedPropertyAccessException("permissionRequester");
            runtimePermissionRequester = null;
        } else {
            runtimePermissionRequester = runtimePermissionRequester2;
        }
        AttachmentIntentsLauncher attachmentIntentsLauncher2 = this.attachmentIntentLauncher;
        if (attachmentIntentsLauncher2 == null) {
            Intrinsics.throwUninitializedPropertyAccessException("attachmentIntentLauncher");
            attachmentIntentsLauncher = null;
        } else {
            attachmentIntentsLauncher = attachmentIntentsLauncher2;
        }
        return new ConversationScreenCoordinator(renderer, function1, function0, function2, uriHandler, webViewUriHandler, attachmentIntents, lifecycleScope, visibleScreenTracker, viewModel, messagingSettings, function3, runtimePermissionRequester, attachmentIntentsLauncher);
    }

    public final Object setupDependencies(Continuation<? super Unit> continuation) throws Throwable {
        C12751 c12751;
        String string;
        ConversationFragment conversationFragment;
        if (continuation instanceof C12751) {
            c12751 = (C12751) continuation;
            if ((c12751.label & Integer.MIN_VALUE) != 0) {
                c12751.label -= Integer.MIN_VALUE;
            } else {
                c12751 = new C12751(continuation);
            }
        } else {
            c12751 = new C12751(continuation);
        }
        C12751 c12752 = c12751;
        Object objMessaging$default = c12752.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c12752.label;
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
            c12752.L$0 = this;
            c12752.label = 1;
            objMessaging$default = ZendeskKtxKt.messaging$default(companion, contextRequireContext, zendeskCredentialsFromQuery, null, c12752, 4, null);
            if (objMessaging$default == coroutine_suspended) {
                return coroutine_suspended;
            }
            conversationFragment = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            conversationFragment = (ConversationFragment) c12752.L$0;
            ResultKt.throwOnFailure(objMessaging$default);
        }
        ZendeskResult zendeskResult = (ZendeskResult) objMessaging$default;
        if (zendeskResult instanceof ZendeskResult.Failure) {
            conversationFragment.errorHandler();
        } else if (zendeskResult instanceof ZendeskResult.Success) {
            conversationFragment.initViewModel((Messaging) ((ZendeskResult.Success) zendeskResult).getValue());
        }
        return Unit.INSTANCE;
    }

    private final void initViewModel(Messaging messaging) {
        if (!(messaging instanceof DefaultMessaging)) {
            errorHandler();
            return;
        }
        ConversationFragmentComponent.Factory factoryConversationFragmentComponent = ((DefaultMessaging) messaging).getMessagingComponent().conversationFragmentComponent();
        FragmentActivity fragmentActivityRequireActivity = requireActivity();
        Intrinsics.checkNotNull(fragmentActivityRequireActivity, "null cannot be cast to non-null type androidx.appcompat.app.AppCompatActivity");
        factoryConversationFragmentComponent.create((AppCompatActivity) fragmentActivityRequireActivity, (SavedStateRegistryOwner) this, getArguments()).inject(this);
        this.conversationScreenViewModel = (ConversationScreenViewModel) new ViewModelProvider((ViewModelStoreOwner) this, getConversationScreenViewModelFactory()).get(ConversationScreenViewModel.class);
    }

    private final void errorHandler() {
        Logger.m219e("ConversationFragment", "Unable to show the conversation without a Messaging instance.", new Object[0]);
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
        Logger.m219e("ConversationFragment", context + " must implement RuntimePermissionRequester", new Object[0]);
    }

    public final Object collectEvents(Continuation<? super Unit> continuation) {
        ConversationScreenViewModel conversationScreenViewModel = this.conversationScreenViewModel;
        if (conversationScreenViewModel == null) {
            Intrinsics.throwUninitializedPropertyAccessException("conversationScreenViewModel");
            conversationScreenViewModel = null;
        }
        Object objCollect = conversationScreenViewModel.getEventsChannel().collect(new C12702(), continuation);
        return objCollect == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objCollect : Unit.INSTANCE;
    }

    @Metadata(m17d1 = {"\u0000\u0010\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u0003H\u008a@¢\u0006\u0004\b\u0004\u0010\u0005"}, m18d2 = {"<anonymous>", "", "it", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenEvent;", "emit", "(Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenEvent;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    static final class C12702<T> implements FlowCollector {
        C12702() {
        }

        @Override
        public Object emit(Object obj, Continuation continuation) {
            return emit((ConversationScreenEvent) obj, (Continuation<? super Unit>) continuation);
        }

        public final Object emit(ConversationScreenEvent conversationScreenEvent, Continuation<? super Unit> continuation) throws Throwable {
            ConversationFragment$collectEvents$2$emit$1 conversationFragment$collectEvents$2$emit$1;
            Job job;
            ConversationScreenEvent conversationScreenEvent2;
            String str;
            C12702<T> c12702;
            if (continuation instanceof ConversationFragment$collectEvents$2$emit$1) {
                conversationFragment$collectEvents$2$emit$1 = (ConversationFragment$collectEvents$2$emit$1) continuation;
                if ((conversationFragment$collectEvents$2$emit$1.label & Integer.MIN_VALUE) != 0) {
                    conversationFragment$collectEvents$2$emit$1.label -= Integer.MIN_VALUE;
                } else {
                    conversationFragment$collectEvents$2$emit$1 = new ConversationFragment$collectEvents$2$emit$1(this, continuation);
                }
            } else {
                conversationFragment$collectEvents$2$emit$1 = new ConversationFragment$collectEvents$2$emit$1(this, continuation);
            }
            Object obj = conversationFragment$collectEvents$2$emit$1.result;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = conversationFragment$collectEvents$2$emit$1.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                ConversationScreenViewModel conversationScreenViewModel = null;
                if (conversationScreenEvent instanceof ConversationScreenEvent.LaunchConversationExtension) {
                    String conversationId = ((ConversationScreenEvent.LaunchConversationExtension) conversationScreenEvent).getConversationId();
                    ConversationScreenViewModel conversationScreenViewModel2 = ConversationFragment.this.conversationScreenViewModel;
                    if (conversationScreenViewModel2 == null) {
                        Intrinsics.throwUninitializedPropertyAccessException("conversationScreenViewModel");
                    } else {
                        conversationScreenViewModel = conversationScreenViewModel2;
                    }
                    conversationFragment$collectEvents$2$emit$1.L$0 = this;
                    conversationFragment$collectEvents$2$emit$1.L$1 = conversationScreenEvent;
                    conversationFragment$collectEvents$2$emit$1.L$2 = conversationId;
                    conversationFragment$collectEvents$2$emit$1.label = 1;
                    Object objConversationId$zendesk_messaging_messaging_android = conversationScreenViewModel.conversationId$zendesk_messaging_messaging_android(conversationFragment$collectEvents$2$emit$1);
                    if (objConversationId$zendesk_messaging_messaging_android == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    conversationScreenEvent2 = conversationScreenEvent;
                    str = conversationId;
                    obj = objConversationId$zendesk_messaging_messaging_android;
                    c12702 = this;
                } else if (conversationScreenEvent instanceof ConversationScreenEvent.OpenFileAttachment) {
                    ConversationFragment.this.openFileFromStorage((ConversationScreenEvent.OpenFileAttachment) conversationScreenEvent);
                } else if (conversationScreenEvent instanceof ConversationScreenEvent.StartPolling) {
                    if (ConversationFragment.this.getFeatureFlagManager().getEnableWaitTimeBanner()) {
                        ConversationFragment.this.startPolling();
                    }
                } else if ((conversationScreenEvent instanceof ConversationScreenEvent.StopPolling) && (job = ConversationFragment.this.pollingJob) != null) {
                    Job.DefaultImpls.cancel$default(job, (CancellationException) null, 1, (Object) null);
                }
                return Unit.INSTANCE;
            }
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            str = (String) conversationFragment$collectEvents$2$emit$1.L$2;
            conversationScreenEvent2 = (ConversationScreenEvent) conversationFragment$collectEvents$2$emit$1.L$1;
            c12702 = (C12702) conversationFragment$collectEvents$2$emit$1.L$0;
            ResultKt.throwOnFailure(obj);
            if (Intrinsics.areEqual(str, obj)) {
                ConversationScreenEvent.LaunchConversationExtension launchConversationExtension = (ConversationScreenEvent.LaunchConversationExtension) conversationScreenEvent2;
                ConversationFragment.this.launchConversationExtension(launchConversationExtension.getUrl(), launchConversationExtension.getSize());
            }
            return Unit.INSTANCE;
        }
    }

    public final void startPolling() {
        Job job = this.pollingJob;
        if (job == null || !job.isActive()) {
            LifecycleOwner viewLifecycleOwner = getViewLifecycleOwner();
            Intrinsics.checkNotNullExpressionValue(viewLifecycleOwner, "getViewLifecycleOwner(...)");
            this.pollingJob = BuildersKt__Builders_commonKt.launch$default(LifecycleOwnerKt.getLifecycleScope(viewLifecycleOwner), null, null, new C12761(null), 3, null);
        }
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationFragment$startPolling$1", m37f = "ConversationFragment.kt", m38i = {}, m39l = {489}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C12761 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C12761(Continuation<? super C12761> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationFragment.this.new C12761(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C12761) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
        @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationFragment$startPolling$1$1", m37f = "ConversationFragment.kt", m38i = {}, m39l = {492}, m40m = "invokeSuspend", m41n = {}, m42s = {})
        static final class AnonymousClass1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
            int label;
            final ConversationFragment this$0;

            AnonymousClass1(ConversationFragment conversationFragment, Continuation<? super AnonymousClass1> continuation) {
                super(2, continuation);
                this.this$0 = conversationFragment;
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
                    ConversationScreenViewModel conversationScreenViewModel = this.this$0.conversationScreenViewModel;
                    if (conversationScreenViewModel == null) {
                        Intrinsics.throwUninitializedPropertyAccessException("conversationScreenViewModel");
                        conversationScreenViewModel = null;
                    }
                    this.label = 1;
                    if (conversationScreenViewModel.startPolling().collect(new FlowCollector() {
                        @Override
                        public Object emit(Object obj2, Continuation continuation) {
                            return emit((Unit) obj2, (Continuation<? super Unit>) continuation);
                        }

                        public final Object emit(Unit unit, Continuation<? super Unit> continuation) {
                            return Unit.INSTANCE;
                        }
                    }, this) == coroutine_suspended) {
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
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                LifecycleOwner viewLifecycleOwner = ConversationFragment.this.getViewLifecycleOwner();
                Intrinsics.checkNotNullExpressionValue(viewLifecycleOwner, "getViewLifecycleOwner(...)");
                this.label = 1;
                if (RepeatOnLifecycleKt.repeatOnLifecycle(viewLifecycleOwner, Lifecycle.State.STARTED, new AnonymousClass1(ConversationFragment.this, null), this) == coroutine_suspended) {
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

    public final void openFileFromStorage(ConversationScreenEvent.OpenFileAttachment fileAttachment) {
        Uri uriForFile = FileProvider.getUriForFile(requireContext(), requireContext().getPackageName() + ".zendesk.messaging.provider", fileAttachment.getFile());
        Intent intent = new Intent("android.intent.action.VIEW");
        intent.setDataAndType(uriForFile, fileAttachment.getMimeType());
        intent.addFlags(1);
        intent.addFlags(268435456);
        try {
            startActivity(intent);
        } catch (ActivityNotFoundException unused) {
            Logger.m219e("ConversationFragment", "Unable to find activity to launch the ACTION_VIEW intent for : " + Uri.fromFile(fileAttachment.getFile()), new Object[0]);
        }
    }

    @Metadata(m17d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J+\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\u00042\n\b\u0002\u0010\f\u001a\u0004\u0018\u00010\u00042\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\u000e¢\u0006\u0002\u0010\u000fR\u000e\u0010\u0003\u001a\u00020\u0004X\u0080T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000¨\u0006\u0010"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationFragment$Companion;", "", "()V", "ARG_CONVERSATION_ID", "", "ARG_CREDENTIALS", "INTENT_URI_SCHEMA", "LOG_TAG", "NAME", "newInstance", "Lzendesk/messaging/android/internal/conversationscreen/ConversationFragment;", "credentials", "conversationId", "proactiveNotificationId", "", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Integer;)Lzendesk/messaging/android/internal/conversationscreen/ConversationFragment;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public static ConversationFragment newInstance$default(Companion companion, String str, String str2, Integer num, int i, Object obj) {
            if ((i & 2) != 0) {
                str2 = null;
            }
            if ((i & 4) != 0) {
                num = null;
            }
            return companion.newInstance(str, str2, num);
        }

        public final ConversationFragment newInstance(String credentials, String conversationId, Integer proactiveNotificationId) {
            Intrinsics.checkNotNullParameter(credentials, "credentials");
            ConversationFragment conversationFragment = new ConversationFragment();
            Bundle bundle = new Bundle();
            bundle.putString(ConversationFragment.ARG_CREDENTIALS, credentials);
            bundle.putString(ConversationFragment.ARG_CONVERSATION_ID, conversationId);
            if (proactiveNotificationId != null) {
                bundle.putInt(NotificationBuilder.PROACTIVE_NOTIFICATION_ID, proactiveNotificationId.intValue());
            }
            conversationFragment.setArguments(bundle);
            return conversationFragment;
        }
    }
}
