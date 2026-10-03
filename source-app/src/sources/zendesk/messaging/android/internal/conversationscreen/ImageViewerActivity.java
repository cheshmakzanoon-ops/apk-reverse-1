package zendesk.messaging.android.internal.conversationscreen;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.ViewGroup;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.ContextCompat;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleOwner;
import androidx.lifecycle.LifecycleOwnerKt;
import androidx.lifecycle.RepeatOnLifecycleKt;
import androidx.lifecycle.ViewModelProvider;
import androidx.lifecycle.ViewModelStoreOwner;
import androidx.savedstate.SavedStateRegistryOwner;
import javax.inject.Inject;
import javax.inject.Named;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.Boxing;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt__Builders_commonKt;
import kotlinx.coroutines.CoroutineScope;
import net.aihelp.data.track.data.TrackType;
import zendesk.android.Zendesk;
import zendesk.android.ZendeskCredentials;
import zendesk.android.ZendeskResult;
import zendesk.android.messaging.Messaging;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.android.messaging.model.UserColors;
import zendesk.core.android.internal.app.FeatureFlagManager;
import zendesk.logger.Logger;
import zendesk.messaging.android.internal.DefaultMessaging;
import zendesk.messaging.android.internal.VisibleScreen;
import zendesk.messaging.android.internal.VisibleScreenTracker;
import zendesk.messaging.android.internal.extension.ContextKtxKt;
import zendesk.messaging.android.internal.extension.ZendeskKtxKt;
import zendesk.messaging.android.internal.p023di.MessagingComponentKt;
import zendesk.p026ui.android.conversation.imagerviewer.ImageViewerView;
import zendesk.ui.android.R;

@Metadata(m17d1 = {"\u0000H\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0000\u0018\u0000 ,2\u00020\u0001:\u0001,B\u0005¢\u0006\u0002\u0010\u0002J\b\u0010$\u001a\u00020%H\u0002J\u0012\u0010&\u001a\u00020%2\b\u0010'\u001a\u0004\u0018\u00010(H\u0015J\b\u0010)\u001a\u00020%H\u0014J\u000e\u0010*\u001a\u00020%H\u0082@¢\u0006\u0002\u0010+R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082.¢\u0006\u0002\n\u0000R\u001e\u0010\u0005\u001a\u00020\u00068\u0006@\u0006X\u0087.¢\u0006\u000e\n\u0000\u001a\u0004\b\u0007\u0010\b\"\u0004\b\t\u0010\nR\u001e\u0010\u000b\u001a\u00020\f8\u0006@\u0006X\u0087.¢\u0006\u000e\n\u0000\u001a\u0004\b\r\u0010\u000e\"\u0004\b\u000f\u0010\u0010R\u000e\u0010\u0011\u001a\u00020\u0012X\u0082.¢\u0006\u0002\n\u0000R\u001e\u0010\u0013\u001a\u00020\u00148\u0006@\u0006X\u0087.¢\u0006\u000e\n\u0000\u001a\u0004\b\u0015\u0010\u0016\"\u0004\b\u0017\u0010\u0018R$\u0010\u0019\u001a\u00020\u001a8\u0006@\u0006X\u0087.¢\u0006\u0014\n\u0000\u0012\u0004\b\u001b\u0010\u0002\u001a\u0004\b\u001c\u0010\u001d\"\u0004\b\u001e\u0010\u001fR$\u0010 \u001a\u00020\u001a8\u0006@\u0006X\u0087.¢\u0006\u0014\n\u0000\u0012\u0004\b!\u0010\u0002\u001a\u0004\b\"\u0010\u001d\"\u0004\b#\u0010\u001f¨\u0006-"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ImageViewerActivity;", "Landroidx/appcompat/app/AppCompatActivity;", "()V", "conversationScreenViewModel", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenViewModel;", "conversationScreenViewModelFactory", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenViewModelFactory;", "getConversationScreenViewModelFactory", "()Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenViewModelFactory;", "setConversationScreenViewModelFactory", "(Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenViewModelFactory;)V", "featureFlagManager", "Lzendesk/core/android/internal/app/FeatureFlagManager;", "getFeatureFlagManager", "()Lzendesk/core/android/internal/app/FeatureFlagManager;", "setFeatureFlagManager", "(Lzendesk/core/android/internal/app/FeatureFlagManager;)V", "imageViewerScreenCoordinator", "Lzendesk/messaging/android/internal/conversationscreen/ImageViewerScreenCoordinator;", "messagingSettings", "Lzendesk/android/messaging/model/MessagingSettings;", "getMessagingSettings", "()Lzendesk/android/messaging/model/MessagingSettings;", "setMessagingSettings", "(Lzendesk/android/messaging/model/MessagingSettings;)V", MessagingComponentKt.USER_DARK_COLORS, "Lzendesk/android/messaging/model/UserColors;", "getUserDarkColors$annotations", "getUserDarkColors", "()Lzendesk/android/messaging/model/UserColors;", "setUserDarkColors", "(Lzendesk/android/messaging/model/UserColors;)V", MessagingComponentKt.USER_LIGHT_COLORS, "getUserLightColors$annotations", "getUserLightColors", "setUserLightColors", "errorHandler", "", "onCreate", "savedInstanceState", "Landroid/os/Bundle;", "onStop", "setupConversationScreenViewModel", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ImageViewerActivity extends AppCompatActivity {
    private static final String LOG_TAG = "ImageViewerActivity";
    private ConversationScreenViewModel conversationScreenViewModel;

    @Inject
    public ConversationScreenViewModelFactory conversationScreenViewModelFactory;

    @Inject
    public FeatureFlagManager featureFlagManager;
    private ImageViewerScreenCoordinator imageViewerScreenCoordinator;

    @Inject
    public MessagingSettings messagingSettings;

    @Inject
    public UserColors userDarkColors;

    @Inject
    public UserColors userLightColors;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ImageViewerActivity", m37f = "ImageViewerActivity.kt", m38i = {0}, m39l = {120}, m40m = "setupConversationScreenViewModel", m41n = {"this"}, m42s = {"L$0"})
    static final class C13681 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C13681(Continuation<? super C13681> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ImageViewerActivity.this.setupConversationScreenViewModel(this);
        }
    }

    @Named(MessagingComponentKt.USER_DARK_COLORS)
    public static void getUserDarkColors$annotations() {
    }

    @Named(MessagingComponentKt.USER_LIGHT_COLORS)
    public static void getUserLightColors$annotations() {
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

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ImageViewerView imageViewerView = new ImageViewerView((Context) this, null, 0, 0, 14, null);
        imageViewerView.setLayoutParams(new ViewGroup.LayoutParams(-1, -1));
        imageViewerView.setBackground(getDrawable(R.color.zuia_color_black));
        BuildersKt__Builders_commonKt.launch$default(LifecycleOwnerKt.getLifecycleScope((LifecycleOwner) this), null, null, new C13671(imageViewerView, null), 3, null);
        setContentView(imageViewerView);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ImageViewerActivity$onCreate$1", m37f = "ImageViewerActivity.kt", m38i = {}, m39l = {86, 95}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C13671 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final ImageViewerView $imageViewerView;
        int label;

        C13671(ImageViewerView imageViewerView, Continuation<? super C13671> continuation) {
            super(2, continuation);
            this.$imageViewerView = imageViewerView;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ImageViewerActivity.this.new C13671(this.$imageViewerView, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C13671) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            ConversationScreenViewModel conversationScreenViewModel;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (ImageViewerActivity.this.setupConversationScreenViewModel(this) == coroutine_suspended) {
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
            ImageViewerActivity imageViewerActivity = ImageViewerActivity.this;
            Intent intent = ImageViewerActivity.this.getIntent();
            Intrinsics.checkNotNullExpressionValue(intent, "getIntent(...)");
            String uri = ImageViewerActivityKt.getUri(intent);
            Intent intent2 = ImageViewerActivity.this.getIntent();
            Intrinsics.checkNotNullExpressionValue(intent2, "getIntent(...)");
            boolean privateAttachmentFlag = ImageViewerActivityKt.getPrivateAttachmentFlag(intent2);
            Integer numBoxInt = Boxing.boxInt(ContextCompat.getColor((Context) ImageViewerActivity.this, R.color.zuia_color_black_38p));
            final ImageViewerActivity imageViewerActivity2 = ImageViewerActivity.this;
            Function0<Unit> function0 = new Function0<Unit>() {
                {
                    super(0);
                }

                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }

                public final void invoke2() {
                    imageViewerActivity2.onBackPressed();
                }
            };
            ImageViewerView imageViewerView = this.$imageViewerView;
            ConversationScreenViewModel conversationScreenViewModel2 = ImageViewerActivity.this.conversationScreenViewModel;
            if (conversationScreenViewModel2 == null) {
                Intrinsics.throwUninitializedPropertyAccessException("conversationScreenViewModel");
                conversationScreenViewModel = null;
            } else {
                conversationScreenViewModel = conversationScreenViewModel2;
            }
            imageViewerActivity.imageViewerScreenCoordinator = new ImageViewerScreenCoordinator(uri, privateAttachmentFlag, numBoxInt, function0, imageViewerView, conversationScreenViewModel);
            this.label = 2;
            if (RepeatOnLifecycleKt.repeatOnLifecycle(ImageViewerActivity.this.getLifecycle(), Lifecycle.State.STARTED, new AnonymousClass2(ImageViewerActivity.this, null), this) == coroutine_suspended) {
                return coroutine_suspended;
            }
            return Unit.INSTANCE;
        }

        @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
        @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ImageViewerActivity$onCreate$1$2", m37f = "ImageViewerActivity.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
        static final class AnonymousClass2 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
            private Object L$0;
            int label;
            final ImageViewerActivity this$0;

            AnonymousClass2(ImageViewerActivity imageViewerActivity, Continuation<? super AnonymousClass2> continuation) {
                super(2, continuation);
                this.this$0 = imageViewerActivity;
            }

            @Override
            public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                AnonymousClass2 anonymousClass2 = new AnonymousClass2(this.this$0, continuation);
                anonymousClass2.L$0 = obj;
                return anonymousClass2;
            }

            @Override
            public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                return ((AnonymousClass2) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
            }

            @Override
            public final Object invokeSuspend(Object obj) throws Throwable {
                IntrinsicsKt.getCOROUTINE_SUSPENDED();
                if (this.label != 0) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
                CoroutineScope coroutineScope = (CoroutineScope) this.L$0;
                VisibleScreenTracker.INSTANCE.setShownScreen$zendesk_messaging_messaging_android(VisibleScreen.ImageViewerScreen.INSTANCE);
                ConversationScreenViewModel conversationScreenViewModel = this.this$0.conversationScreenViewModel;
                if (conversationScreenViewModel == null) {
                    Intrinsics.throwUninitializedPropertyAccessException("conversationScreenViewModel");
                    conversationScreenViewModel = null;
                }
                ImageViewerActivity imageViewerActivity = this.this$0;
                conversationScreenViewModel.refreshTheme$zendesk_messaging_messaging_android(ContextKtxKt.getMessagingTheme((Context) imageViewerActivity, imageViewerActivity.getMessagingSettings(), this.this$0.getUserLightColors(), this.this$0.getUserDarkColors()));
                BuildersKt__Builders_commonKt.launch$default(coroutineScope, null, null, new AnonymousClass1(this.this$0, null), 3, null);
                return Unit.INSTANCE;
            }

            @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
            @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ImageViewerActivity$onCreate$1$2$1", m37f = "ImageViewerActivity.kt", m38i = {}, m39l = {TrackType.TRACK_ENTRANCE_CLICK_FAQ}, m40m = "invokeSuspend", m41n = {}, m42s = {})
            static final class AnonymousClass1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                int label;
                final ImageViewerActivity this$0;

                AnonymousClass1(ImageViewerActivity imageViewerActivity, Continuation<? super AnonymousClass1> continuation) {
                    super(2, continuation);
                    this.this$0 = imageViewerActivity;
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
                        ImageViewerScreenCoordinator imageViewerScreenCoordinator = this.this$0.imageViewerScreenCoordinator;
                        if (imageViewerScreenCoordinator == null) {
                            Intrinsics.throwUninitializedPropertyAccessException("imageViewerScreenCoordinator");
                            imageViewerScreenCoordinator = null;
                        }
                        this.label = 1;
                        if (imageViewerScreenCoordinator.init(this) == coroutine_suspended) {
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

    protected void onStop() {
        super.onStop();
        VisibleScreenTracker.INSTANCE.setHiddenScreen$zendesk_messaging_messaging_android(VisibleScreen.ImageViewerScreen.INSTANCE);
    }

    public final Object setupConversationScreenViewModel(Continuation<? super Unit> continuation) throws Throwable {
        C13681 c13681;
        ImageViewerActivity imageViewerActivity;
        if (continuation instanceof C13681) {
            c13681 = (C13681) continuation;
            if ((c13681.label & Integer.MIN_VALUE) != 0) {
                c13681.label -= Integer.MIN_VALUE;
            } else {
                c13681 = new C13681(continuation);
            }
        } else {
            c13681 = new C13681(continuation);
        }
        C13681 c13682 = c13681;
        Object objMessaging$default = c13682.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c13682.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objMessaging$default);
            ZendeskCredentials.Companion companion = ZendeskCredentials.INSTANCE;
            Intent intent = getIntent();
            Intrinsics.checkNotNullExpressionValue(intent, "getIntent(...)");
            ZendeskCredentials zendeskCredentialsFromQuery = companion.fromQuery(ImageViewerActivityKt.getCredentials(intent));
            if (zendeskCredentialsFromQuery != null) {
                c13682.L$0 = this;
                c13682.label = 1;
                objMessaging$default = ZendeskKtxKt.messaging$default(Zendesk.INSTANCE, (Context) this, zendeskCredentialsFromQuery, null, c13682, 4, null);
                if (objMessaging$default == coroutine_suspended) {
                    return coroutine_suspended;
                }
                imageViewerActivity = this;
            } else {
                errorHandler();
            }
            return Unit.INSTANCE;
        }
        if (i != 1) {
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
        ImageViewerActivity imageViewerActivity2 = (ImageViewerActivity) c13682.L$0;
        ResultKt.throwOnFailure(objMessaging$default);
        imageViewerActivity = imageViewerActivity2;
        ZendeskResult zendeskResult = (ZendeskResult) objMessaging$default;
        if (zendeskResult instanceof ZendeskResult.Failure) {
            imageViewerActivity.errorHandler();
        } else if (zendeskResult instanceof ZendeskResult.Success) {
            Messaging messaging = (Messaging) ((ZendeskResult.Success) zendeskResult).getValue();
            if (!(messaging instanceof DefaultMessaging)) {
                imageViewerActivity.errorHandler();
                return Unit.INSTANCE;
            }
            ((DefaultMessaging) messaging).getMessagingComponent().imageViewerActivityComponent().create(imageViewerActivity, (SavedStateRegistryOwner) imageViewerActivity, imageViewerActivity.getIntent().getExtras()).inject(imageViewerActivity);
            imageViewerActivity.conversationScreenViewModel = (ConversationScreenViewModel) new ViewModelProvider((ViewModelStoreOwner) imageViewerActivity, (ViewModelProvider.Factory) imageViewerActivity.getConversationScreenViewModelFactory()).get(ConversationScreenViewModel.class);
        }
        return Unit.INSTANCE;
    }

    private final void errorHandler() {
        Logger.m219e(LOG_TAG, "Unable to show the conversation screen without a Messaging instance.", new Object[0]);
        finish();
    }
}
