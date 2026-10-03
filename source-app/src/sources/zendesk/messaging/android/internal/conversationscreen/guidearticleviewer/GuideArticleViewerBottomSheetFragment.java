package zendesk.messaging.android.internal.conversationscreen.guidearticleviewer;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
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
import cz.msebera.android.httpclient.protocol.HTTP;
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
import zendesk.core.p017ui.android.internal.xml.BottomSheetDialogKtxKt;
import zendesk.guidekit.android.GuideKit;
import zendesk.logger.Logger;
import zendesk.messaging.C1256R;
import zendesk.messaging.android.internal.DefaultMessaging;
import zendesk.messaging.android.internal.extension.ContextKtxKt;
import zendesk.messaging.android.internal.extension.ZendeskKtxKt;
import zendesk.messaging.android.internal.model.MessagingTheme;
import zendesk.messaging.android.internal.p023di.MessagingComponentKt;
import zendesk.p026ui.android.conversation.articleviewer.ArticleViewer;
import zendesk.p026ui.android.conversation.articleviewer.ArticleViewerRendering;
import zendesk.p026ui.android.conversation.articleviewer.ArticleViewerState;
import zendesk.p026ui.android.conversation.articleviewer.articleattachmentcarousel.ArticleAttachmentItem;
import zendesk.p026ui.android.conversation.articleviewer.articlecontent.ArticleContentState;
import zendesk.p026ui.android.conversation.articleviewer.articleheader.ArticleHeaderState;

@Metadata(m17d1 = {"\u0000·\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004*\u0001+\b\u0000\u0018\u0000 \\2\u00020\u0001:\u0001\\B\u0005¢\u0006\u0002\u0010\u0002J\u0016\u0010@\u001a\u00020)2\u0006\u0010A\u001a\u00020BH\u0082@¢\u0006\u0002\u0010CJ\u000e\u0010D\u001a\u00020)H\u0082@¢\u0006\u0002\u0010EJ\b\u0010F\u001a\u00020)H\u0002J\b\u0010G\u001a\u00020HH\u0002J\u0010\u0010I\u001a\u00020)2\u0006\u0010J\u001a\u00020KH\u0002J\b\u0010L\u001a\u00020)H\u0016J\b\u0010M\u001a\u00020)H\u0016J\u001a\u0010N\u001a\u00020)2\u0006\u0010O\u001a\u00020P2\b\u0010Q\u001a\u0004\u0018\u00010RH\u0016J\u0010\u0010S\u001a\u00020)2\u0006\u0010T\u001a\u00020UH\u0002J\u0010\u0010V\u001a\u00020)2\u0006\u0010T\u001a\u00020WH\u0002J\u0010\u0010X\u001a\u00020)2\u0006\u0010T\u001a\u00020YH\u0002J\u000e\u0010Z\u001a\u00020)H\u0082@¢\u0006\u0002\u0010EJ\u0010\u0010[\u001a\u00020)2\u0006\u00103\u001a\u00020\u0006H\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082.¢\u0006\u0002\n\u0000R$\u0010\u0005\u001a\u00020\u00068\u0006@\u0006X\u0087.¢\u0006\u0014\n\u0000\u0012\u0004\b\u0007\u0010\u0002\u001a\u0004\b\b\u0010\t\"\u0004\b\n\u0010\u000bR$\u0010\f\u001a\u0018\u0012\u0004\u0012\u00020\u000e\u0012\u0004\u0012\u00020\u000e0\rj\b\u0012\u0004\u0012\u00020\u000e`\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0010\u001a\u00020\u0011X\u0082.¢\u0006\u0002\n\u0000R\u001e\u0010\u0012\u001a\u00020\u00138\u0006@\u0006X\u0087.¢\u0006\u000e\n\u0000\u001a\u0004\b\u0014\u0010\u0015\"\u0004\b\u0016\u0010\u0017R\u001e\u0010\u0018\u001a\u00020\u00198\u0006@\u0006X\u0087.¢\u0006\u000e\n\u0000\u001a\u0004\b\u001a\u0010\u001b\"\u0004\b\u001c\u0010\u001dR\u001e\u0010\u001e\u001a\u00020\u001f8\u0006@\u0006X\u0087.¢\u0006\u000e\n\u0000\u001a\u0004\b \u0010!\"\u0004\b\"\u0010#R)\u0010$\u001a\u001d\u0012\u0013\u0012\u00110%¢\u0006\f\b&\u0012\b\b'\u0012\u0004\b\b((\u0012\u0004\u0012\u00020)0\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010*\u001a\u00020+X\u0082\u0004¢\u0006\u0004\n\u0002\u0010,R)\u0010-\u001a\u001d\u0012\u0013\u0012\u00110.¢\u0006\f\b&\u0012\b\b'\u0012\u0004\b\b(/\u0012\u0004\u0012\u00020)0\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u00100\u001a\b\u0012\u0004\u0012\u00020)01X\u0082\u0004¢\u0006\u0002\n\u0000R+\u00102\u001a\u001f\u0012\u0015\u0012\u0013\u0018\u00010\u0006¢\u0006\f\b&\u0012\b\b'\u0012\u0004\b\b(3\u0012\u0004\u0012\u0002040\rX\u0082\u0004¢\u0006\u0002\n\u0000R$\u00105\u001a\u0002068\u0006@\u0006X\u0087.¢\u0006\u0014\n\u0000\u0012\u0004\b7\u0010\u0002\u001a\u0004\b8\u00109\"\u0004\b:\u0010;R$\u0010<\u001a\u0002068\u0006@\u0006X\u0087.¢\u0006\u0014\n\u0000\u0012\u0004\b=\u0010\u0002\u001a\u0004\b>\u00109\"\u0004\b?\u0010;¨\u0006]"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerBottomSheetFragment;", "Lcom/google/android/material/bottomsheet/BottomSheetDialogFragment;", "()V", "articleViewer", "Lzendesk/ui/android/conversation/articleviewer/ArticleViewer;", "baseUrl", "", "getBaseUrl$annotations", "getBaseUrl", "()Ljava/lang/String;", "setBaseUrl", "(Ljava/lang/String;)V", "defaultRendering", "Lkotlin/Function1;", "Lzendesk/ui/android/conversation/articleviewer/ArticleViewerRendering;", "Lzendesk/messaging/android/internal/conversationscreen/RenderingUpdate;", "guideArticleViewerViewModel", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerViewModel;", "guideArticleViewerViewModelFactory", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerViewModelFactory;", "getGuideArticleViewerViewModelFactory", "()Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerViewModelFactory;", "setGuideArticleViewerViewModelFactory", "(Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerViewModelFactory;)V", "guideKit", "Lzendesk/guidekit/android/GuideKit;", "getGuideKit", "()Lzendesk/guidekit/android/GuideKit;", "setGuideKit", "(Lzendesk/guidekit/android/GuideKit;)V", "messagingSettings", "Lzendesk/android/messaging/model/MessagingSettings;", "getMessagingSettings", "()Lzendesk/android/messaging/model/MessagingSettings;", "setMessagingSettings", "(Lzendesk/android/messaging/model/MessagingSettings;)V", "onAttachmentItemClicked", "Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentItem;", "Lkotlin/ParameterName;", "name", "attachmentItem", "", "onBackPressedCallback", "zendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerBottomSheetFragment$onBackPressedCallback$1", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerBottomSheetFragment$onBackPressedCallback$1;", "onMenuItemClicked", "Lzendesk/ui/android/conversation/articleviewer/articleheader/ArticleHeaderState$ButtonName;", "itemClicked", "onRetryButtonClicked", "Lkotlin/Function0;", "shouldOverrideUrl", "url", "", MessagingComponentKt.USER_DARK_COLORS, "Lzendesk/android/messaging/model/UserColors;", "getUserDarkColors$annotations", "getUserDarkColors", "()Lzendesk/android/messaging/model/UserColors;", "setUserDarkColors", "(Lzendesk/android/messaging/model/UserColors;)V", MessagingComponentKt.USER_LIGHT_COLORS, "getUserLightColors$annotations", "getUserLightColors", "setUserLightColors", "collectEvents", "context", "Landroid/content/Context;", "(Landroid/content/Context;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "collectStateUpdates", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "errorHandler", "getMessagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "initGuideArticleViewerViewModel", "messaging", "Lzendesk/android/messaging/Messaging;", "onDestroy", "onStart", "onViewCreated", "view", "Landroid/view/View;", "savedInstanceState", "Landroid/os/Bundle;", "renderError", "state", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerState$Error;", "renderGuideArticleSuccess", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerState$SuccessGuideArticle;", "renderLoading", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerState$Loading;", "setupGuideArticleViewerDependencies", "shareUrl", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class GuideArticleViewerBottomSheetFragment extends BottomSheetDialogFragment {
    private static final String ARG_CREDENTIALS = "GuideArticleViewerBottomSheetFragment.ARG_CREDENTIALS";
    public static final String ARG_GUIDE_ARTICLE_URL = "GuideArticleViewerBottomSheetFragment.ARG_GUIDE_ARTICLE_URL";

    public static final Companion INSTANCE = new Companion(null);
    public static final String LOG_TAG = "GuideArticleFrag";
    public static final String TAG = "GuideArticleViewerBottomSheetFragment";
    private ArticleViewer articleViewer;

    @Inject
    public String baseUrl;
    private final Function1<ArticleViewerRendering, ArticleViewerRendering> defaultRendering;
    private GuideArticleViewerViewModel guideArticleViewerViewModel;

    @Inject
    public GuideArticleViewerViewModelFactory guideArticleViewerViewModelFactory;

    @Inject
    public GuideKit guideKit;

    @Inject
    public MessagingSettings messagingSettings;
    private final Function1<ArticleAttachmentItem, Unit> onAttachmentItemClicked;
    private final GuideArticleViewerBottomSheetFragment$onBackPressedCallback$1 onBackPressedCallback;
    private final Function1<ArticleHeaderState.ButtonName, Unit> onMenuItemClicked;
    private final Function0<Unit> onRetryButtonClicked;
    private final Function1<String, Boolean> shouldOverrideUrl;

    @Inject
    public UserColors userDarkColors;

    @Inject
    public UserColors userLightColors;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.GuideArticleViewerBottomSheetFragment", m37f = "GuideArticleViewerBottomSheetFragment.kt", m38i = {}, m39l = {266}, m40m = "collectStateUpdates", m41n = {}, m42s = {})
    static final class C14211 extends ContinuationImpl {
        int label;
        Object result;

        C14211(Continuation<? super C14211> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return GuideArticleViewerBottomSheetFragment.this.collectStateUpdates(this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.GuideArticleViewerBottomSheetFragment", m37f = "GuideArticleViewerBottomSheetFragment.kt", m38i = {0}, m39l = {306}, m40m = "setupGuideArticleViewerDependencies", m41n = {"this"}, m42s = {"L$0"})
    static final class C14281 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C14281(Continuation<? super C14281> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return GuideArticleViewerBottomSheetFragment.this.setupGuideArticleViewerDependencies(this);
        }
    }

    @Named("baseUrl")
    public static void getBaseUrl$annotations() {
    }

    @Named(MessagingComponentKt.USER_DARK_COLORS)
    public static void getUserDarkColors$annotations() {
    }

    @Named(MessagingComponentKt.USER_LIGHT_COLORS)
    public static void getUserLightColors$annotations() {
    }

    public GuideArticleViewerBottomSheetFragment() {
        super(C1256R.layout.zma_bottom_sheet_guide_article_viewer);
        this.onBackPressedCallback = new OnBackPressedCallback() {
            {
                super(true);
            }

            public void handleOnBackPressed() {
                GuideArticleViewerViewModel guideArticleViewerViewModel = this.this$0.guideArticleViewerViewModel;
                if (guideArticleViewerViewModel == null) {
                    Intrinsics.throwUninitializedPropertyAccessException("guideArticleViewerViewModel");
                    guideArticleViewerViewModel = null;
                }
                guideArticleViewerViewModel.process(GuideArticleViewerAction.Back.INSTANCE);
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
                GuideArticleViewerViewModel guideArticleViewerViewModel = this.this$0.guideArticleViewerViewModel;
                if (guideArticleViewerViewModel == null) {
                    Intrinsics.throwUninitializedPropertyAccessException("guideArticleViewerViewModel");
                    guideArticleViewerViewModel = null;
                }
                guideArticleViewerViewModel.process(GuideArticleViewerAction.Reload.INSTANCE);
            }
        };
        this.onAttachmentItemClicked = new Function1<ArticleAttachmentItem, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(ArticleAttachmentItem articleAttachmentItem) {
                invoke2(articleAttachmentItem);
                return Unit.INSTANCE;
            }

            public final void invoke2(ArticleAttachmentItem it) {
                Intrinsics.checkNotNullParameter(it, "it");
                GuideArticleViewerViewModel guideArticleViewerViewModel = this.this$0.guideArticleViewerViewModel;
                if (guideArticleViewerViewModel == null) {
                    Intrinsics.throwUninitializedPropertyAccessException("guideArticleViewerViewModel");
                    guideArticleViewerViewModel = null;
                }
                guideArticleViewerViewModel.process(new GuideArticleViewerAction.OpenAttachment(it));
            }
        };
        this.onMenuItemClicked = new Function1<ArticleHeaderState.ButtonName, Unit>() {

            @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
            public class WhenMappings {
                public static final int[] $EnumSwitchMapping$0;

                static {
                    int[] iArr = new int[ArticleHeaderState.ButtonName.values().length];
                    try {
                        iArr[ArticleHeaderState.ButtonName.CLOSE.ordinal()] = 1;
                    } catch (NoSuchFieldError unused) {
                    }
                    try {
                        iArr[ArticleHeaderState.ButtonName.BACK.ordinal()] = 2;
                    } catch (NoSuchFieldError unused2) {
                    }
                    try {
                        iArr[ArticleHeaderState.ButtonName.SHARE.ordinal()] = 3;
                    } catch (NoSuchFieldError unused3) {
                    }
                    $EnumSwitchMapping$0 = iArr;
                }
            }

            {
                super(1);
            }

            @Override
            public Unit invoke(ArticleHeaderState.ButtonName buttonName) {
                invoke2(buttonName);
                return Unit.INSTANCE;
            }

            public final void invoke2(ArticleHeaderState.ButtonName it) {
                Intrinsics.checkNotNullParameter(it, "it");
                int i = WhenMappings.$EnumSwitchMapping$0[it.ordinal()];
                if (i == 1) {
                    this.this$0.dismiss();
                    return;
                }
                GuideArticleViewerViewModel guideArticleViewerViewModel = null;
                if (i == 2) {
                    GuideArticleViewerViewModel guideArticleViewerViewModel2 = this.this$0.guideArticleViewerViewModel;
                    if (guideArticleViewerViewModel2 == null) {
                        Intrinsics.throwUninitializedPropertyAccessException("guideArticleViewerViewModel");
                    } else {
                        guideArticleViewerViewModel = guideArticleViewerViewModel2;
                    }
                    guideArticleViewerViewModel.process(GuideArticleViewerAction.Back.INSTANCE);
                    return;
                }
                if (i != 3) {
                    return;
                }
                GuideArticleViewerViewModel guideArticleViewerViewModel3 = this.this$0.guideArticleViewerViewModel;
                if (guideArticleViewerViewModel3 == null) {
                    Intrinsics.throwUninitializedPropertyAccessException("guideArticleViewerViewModel");
                } else {
                    guideArticleViewerViewModel = guideArticleViewerViewModel3;
                }
                guideArticleViewerViewModel.process(GuideArticleViewerAction.Share.INSTANCE);
            }
        };
        this.shouldOverrideUrl = new Function1<String, Boolean>() {
            {
                super(1);
            }

            @Override
            public final Boolean invoke(String str) {
                if (str != null) {
                    GuideArticleViewerViewModel guideArticleViewerViewModel = this.this$0.guideArticleViewerViewModel;
                    if (guideArticleViewerViewModel == null) {
                        Intrinsics.throwUninitializedPropertyAccessException("guideArticleViewerViewModel");
                        guideArticleViewerViewModel = null;
                    }
                    guideArticleViewerViewModel.process(new GuideArticleViewerAction.Load(str));
                }
                return true;
            }
        };
        this.defaultRendering = new Function1<ArticleViewerRendering, ArticleViewerRendering>() {
            {
                super(1);
            }

            @Override
            public final ArticleViewerRendering invoke(ArticleViewerRendering articleViewerRendering) {
                Intrinsics.checkNotNullParameter(articleViewerRendering, "articleViewerRendering");
                return articleViewerRendering.toBuilder().state(new Function1<ArticleViewerState, ArticleViewerState>() {
                    @Override
                    public final ArticleViewerState invoke(ArticleViewerState it) {
                        Intrinsics.checkNotNullParameter(it, "it");
                        return ArticleViewerState.copy$default(it, null, ArticleContentState.ArticleLoadingStatus.IDLE, MessagingTheme.INSTANCE.getDEFAULT().getOnBackgroundColor(), MessagingTheme.INSTANCE.getDEFAULT().getElevatedColor(), MessagingTheme.INSTANCE.getDEFAULT().getBackgroundColor(), MessagingTheme.INSTANCE.getDEFAULT().getOnBackgroundColor(), MessagingTheme.INSTANCE.getDEFAULT().getSuccessColor(), MessagingTheme.INSTANCE.getDEFAULT().getPrimaryColor(), false, true, null, MessagingTheme.INSTANCE.getDEFAULT().getOnBackgroundColor(), MessagingTheme.INSTANCE.getDEFAULT().getBackgroundColor(), 0, null, false, 25601, null);
                    }
                }).onMenuItemClicked(this.this$0.onMenuItemClicked).shouldOverrideUrl(this.this$0.shouldOverrideUrl).build();
            }
        };
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

    public final GuideArticleViewerViewModelFactory getGuideArticleViewerViewModelFactory() {
        GuideArticleViewerViewModelFactory guideArticleViewerViewModelFactory = this.guideArticleViewerViewModelFactory;
        if (guideArticleViewerViewModelFactory != null) {
            return guideArticleViewerViewModelFactory;
        }
        Intrinsics.throwUninitializedPropertyAccessException("guideArticleViewerViewModelFactory");
        return null;
    }

    public final void setGuideArticleViewerViewModelFactory(GuideArticleViewerViewModelFactory guideArticleViewerViewModelFactory) {
        Intrinsics.checkNotNullParameter(guideArticleViewerViewModelFactory, "<set-?>");
        this.guideArticleViewerViewModelFactory = guideArticleViewerViewModelFactory;
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

    public final String getBaseUrl() {
        String str = this.baseUrl;
        if (str != null) {
            return str;
        }
        Intrinsics.throwUninitializedPropertyAccessException("baseUrl");
        return null;
    }

    public final void setBaseUrl(String str) {
        Intrinsics.checkNotNullParameter(str, "<set-?>");
        this.baseUrl = str;
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

    public final void renderGuideArticleSuccess(final GuideArticleViewerState.SuccessGuideArticle state) {
        ArticleViewer articleViewer = this.articleViewer;
        if (articleViewer == null) {
            Intrinsics.throwUninitializedPropertyAccessException("articleViewer");
            articleViewer = null;
        }
        articleViewer.render(new Function1<ArticleViewerRendering, ArticleViewerRendering>() {
            {
                super(1);
            }

            @Override
            public final ArticleViewerRendering invoke(ArticleViewerRendering articleViewerRendering) {
                Intrinsics.checkNotNullParameter(articleViewerRendering, "articleViewerRendering");
                ArticleViewerRendering.Builder builder = articleViewerRendering.toBuilder();
                final GuideArticleViewerState.SuccessGuideArticle successGuideArticle = state;
                final GuideArticleViewerBottomSheetFragment guideArticleViewerBottomSheetFragment = GuideArticleViewerBottomSheetFragment.this;
                return builder.state(new Function1<ArticleViewerState, ArticleViewerState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final ArticleViewerState invoke(ArticleViewerState it) {
                        Intrinsics.checkNotNullParameter(it, "it");
                        ArticleContentState.ArticleLoadingStatus articleLoadingStatus = ArticleContentState.ArticleLoadingStatus.SUCCESS;
                        boolean z = !successGuideArticle.getBackStack().isEmpty();
                        Uri uri = Uri.parse(successGuideArticle.getUrl());
                        Intrinsics.checkNotNullExpressionValue(uri, "parse(...)");
                        return ArticleViewerState.copy$default(it, new ArticleContentState.ArticleData(uri, successGuideArticle.getTitle(), successGuideArticle.getHtmlBody(), guideArticleViewerBottomSheetFragment.getBaseUrl()), articleLoadingStatus, successGuideArticle.getMessagingTheme().getOnBackgroundColor(), successGuideArticle.getMessagingTheme().getElevatedColor(), successGuideArticle.getMessagingTheme().getBackgroundColor(), successGuideArticle.getMessagingTheme().getOnBackgroundColor(), successGuideArticle.getMessagingTheme().getSuccessColor(), successGuideArticle.getMessagingTheme().getPrimaryColor(), z, true, successGuideArticle.getAttachments(), successGuideArticle.getMessagingTheme().getOnBackgroundColor(), successGuideArticle.getMessagingTheme().getBackgroundColor(), 0, null, false, 24576, null);
                    }
                }).onMenuItemClicked(GuideArticleViewerBottomSheetFragment.this.onMenuItemClicked).shouldOverrideUrl(GuideArticleViewerBottomSheetFragment.this.shouldOverrideUrl).onAttachmentItemClicked(GuideArticleViewerBottomSheetFragment.this.onAttachmentItemClicked).build();
            }
        });
    }

    public final void renderLoading(final GuideArticleViewerState.Loading state) {
        ArticleViewer articleViewer = this.articleViewer;
        if (articleViewer == null) {
            Intrinsics.throwUninitializedPropertyAccessException("articleViewer");
            articleViewer = null;
        }
        articleViewer.render(new Function1<ArticleViewerRendering, ArticleViewerRendering>() {
            {
                super(1);
            }

            @Override
            public final ArticleViewerRendering invoke(ArticleViewerRendering articleViewerRendering) {
                Intrinsics.checkNotNullParameter(articleViewerRendering, "articleViewerRendering");
                ArticleViewerRendering.Builder builder = articleViewerRendering.toBuilder();
                final GuideArticleViewerState.Loading loading = state;
                return builder.state(new Function1<ArticleViewerState, ArticleViewerState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final ArticleViewerState invoke(ArticleViewerState it) {
                        Intrinsics.checkNotNullParameter(it, "it");
                        return ArticleViewerState.copy$default(it, null, ArticleContentState.ArticleLoadingStatus.LOADING, loading.getMessagingTheme().getOnBackgroundColor(), loading.getMessagingTheme().getElevatedColor(), loading.getMessagingTheme().getBackgroundColor(), loading.getMessagingTheme().getOnBackgroundColor(), loading.getMessagingTheme().getSuccessColor(), loading.getMessagingTheme().getPrimaryColor(), !loading.getBackStack().isEmpty(), true, null, loading.getMessagingTheme().getOnBackgroundColor(), loading.getMessagingTheme().getBackgroundColor(), 0, null, false, 25601, null);
                    }
                }).onMenuItemClicked(GuideArticleViewerBottomSheetFragment.this.onMenuItemClicked).shouldOverrideUrl(GuideArticleViewerBottomSheetFragment.this.shouldOverrideUrl).build();
            }
        });
    }

    public final void renderError(final GuideArticleViewerState.Error state) {
        ArticleViewer articleViewer = this.articleViewer;
        if (articleViewer == null) {
            Intrinsics.throwUninitializedPropertyAccessException("articleViewer");
            articleViewer = null;
        }
        articleViewer.render(new Function1<ArticleViewerRendering, ArticleViewerRendering>() {
            {
                super(1);
            }

            @Override
            public final ArticleViewerRendering invoke(ArticleViewerRendering articleViewerRendering) {
                Intrinsics.checkNotNullParameter(articleViewerRendering, "articleViewerRendering");
                ArticleViewerRendering.Builder builder = articleViewerRendering.toBuilder();
                final GuideArticleViewerState.Error error = state;
                return builder.state(new Function1<ArticleViewerState, ArticleViewerState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final ArticleViewerState invoke(ArticleViewerState it) {
                        Intrinsics.checkNotNullParameter(it, "it");
                        return ArticleViewerState.copy$default(it, null, ArticleContentState.ArticleLoadingStatus.FAILED, error.getMessagingTheme().getOnBackgroundColor(), error.getMessagingTheme().getElevatedColor(), error.getMessagingTheme().getBackgroundColor(), error.getMessagingTheme().getOnBackgroundColor(), error.getMessagingTheme().getSuccessColor(), error.getMessagingTheme().getPrimaryColor(), !error.getBackStack().isEmpty(), true, null, error.getMessagingTheme().getOnBackgroundColor(), error.getMessagingTheme().getBackgroundColor(), 0, null, false, 25601, null);
                    }
                }).onMenuItemClicked(GuideArticleViewerBottomSheetFragment.this.onMenuItemClicked).shouldOverrideUrl(GuideArticleViewerBottomSheetFragment.this.shouldOverrideUrl).onRetryButtonClicked(GuideArticleViewerBottomSheetFragment.this.onRetryButtonClicked).build();
            }
        });
    }

    public final Object collectEvents(final Context context, Continuation<? super Unit> continuation) {
        GuideArticleViewerViewModel guideArticleViewerViewModel = this.guideArticleViewerViewModel;
        if (guideArticleViewerViewModel == null) {
            Intrinsics.throwUninitializedPropertyAccessException("guideArticleViewerViewModel");
            guideArticleViewerViewModel = null;
        }
        Object objCollect = guideArticleViewerViewModel.getEventsChannel().collect(new FlowCollector() {
            @Override
            public Object emit(Object obj, Continuation continuation2) {
                return emit((GuideArticleViewerEvent) obj, (Continuation<? super Unit>) continuation2);
            }

            public final Object emit(GuideArticleViewerEvent guideArticleViewerEvent, Continuation<? super Unit> continuation2) {
                if (guideArticleViewerEvent instanceof GuideArticleViewerEvent.LoadUrlInBrowser) {
                    Intent intent = new Intent("android.intent.action.VIEW", Uri.parse(((GuideArticleViewerEvent.LoadUrlInBrowser) guideArticleViewerEvent).getUrl()));
                    if (intent.resolveActivity(context.getPackageManager()) != null) {
                        this.startActivity(intent);
                    } else {
                        Logger.m219e(GuideArticleViewerBottomSheetFragment.LOG_TAG, "Unable to find an activity for " + guideArticleViewerEvent, new Object[0]);
                    }
                } else if (guideArticleViewerEvent instanceof GuideArticleViewerEvent.ShareUrl) {
                    this.shareUrl(((GuideArticleViewerEvent.ShareUrl) guideArticleViewerEvent).getUrl());
                } else if (Intrinsics.areEqual(guideArticleViewerEvent, GuideArticleViewerEvent.Close.INSTANCE)) {
                    this.dismiss();
                }
                return Unit.INSTANCE;
            }
        }, continuation);
        return objCollect == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objCollect : Unit.INSTANCE;
    }

    public final Object collectStateUpdates(Continuation<? super Unit> continuation) throws Throwable {
        C14211 c14211;
        if (continuation instanceof C14211) {
            c14211 = (C14211) continuation;
            if ((c14211.label & Integer.MIN_VALUE) != 0) {
                c14211.label -= Integer.MIN_VALUE;
            } else {
                c14211 = new C14211(continuation);
            }
        } else {
            c14211 = new C14211(continuation);
        }
        Object obj = c14211.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c14211.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            GuideArticleViewerViewModel guideArticleViewerViewModel = this.guideArticleViewerViewModel;
            if (guideArticleViewerViewModel == null) {
                Intrinsics.throwUninitializedPropertyAccessException("guideArticleViewerViewModel");
                guideArticleViewerViewModel = null;
            }
            StateFlow<GuideArticleViewerState> articleViewerState = guideArticleViewerViewModel.getArticleViewerState();
            FlowCollector<? super GuideArticleViewerState> flowCollector = new FlowCollector() {
                @Override
                public Object emit(Object obj2, Continuation continuation2) {
                    return emit((GuideArticleViewerState) obj2, (Continuation<? super Unit>) continuation2);
                }

                public final Object emit(GuideArticleViewerState guideArticleViewerState, Continuation<? super Unit> continuation2) {
                    if (guideArticleViewerState instanceof GuideArticleViewerState.Error) {
                        GuideArticleViewerBottomSheetFragment.this.renderError((GuideArticleViewerState.Error) guideArticleViewerState);
                    } else if (guideArticleViewerState instanceof GuideArticleViewerState.Loading) {
                        GuideArticleViewerBottomSheetFragment.this.renderLoading((GuideArticleViewerState.Loading) guideArticleViewerState);
                    } else if (guideArticleViewerState instanceof GuideArticleViewerState.SuccessGuideArticle) {
                        GuideArticleViewerBottomSheetFragment.this.renderGuideArticleSuccess((GuideArticleViewerState.SuccessGuideArticle) guideArticleViewerState);
                    } else {
                        boolean z = guideArticleViewerState instanceof GuideArticleViewerState.Idle;
                    }
                    return Unit.INSTANCE;
                }
            };
            c14211.label = 1;
            if (articleViewerState.collect(flowCollector, c14211) == coroutine_suspended) {
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

    public final Object setupGuideArticleViewerDependencies(Continuation<? super Unit> continuation) throws Throwable {
        C14281 c14281;
        String string;
        GuideArticleViewerBottomSheetFragment guideArticleViewerBottomSheetFragment;
        if (continuation instanceof C14281) {
            c14281 = (C14281) continuation;
            if ((c14281.label & Integer.MIN_VALUE) != 0) {
                c14281.label -= Integer.MIN_VALUE;
            } else {
                c14281 = new C14281(continuation);
            }
        } else {
            c14281 = new C14281(continuation);
        }
        C14281 c14282 = c14281;
        Object objMessaging$default = c14282.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c14282.label;
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
            c14282.L$0 = this;
            c14282.label = 1;
            objMessaging$default = ZendeskKtxKt.messaging$default(companion, contextRequireContext, zendeskCredentialsFromQuery, null, c14282, 4, null);
            if (objMessaging$default == coroutine_suspended) {
                return coroutine_suspended;
            }
            guideArticleViewerBottomSheetFragment = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            guideArticleViewerBottomSheetFragment = (GuideArticleViewerBottomSheetFragment) c14282.L$0;
            ResultKt.throwOnFailure(objMessaging$default);
        }
        ZendeskResult zendeskResult = (ZendeskResult) objMessaging$default;
        if (zendeskResult instanceof ZendeskResult.Failure) {
            guideArticleViewerBottomSheetFragment.errorHandler();
        } else if (zendeskResult instanceof ZendeskResult.Success) {
            guideArticleViewerBottomSheetFragment.initGuideArticleViewerViewModel((Messaging) ((ZendeskResult.Success) zendeskResult).getValue());
        }
        return Unit.INSTANCE;
    }

    private final void initGuideArticleViewerViewModel(Messaging messaging) {
        if (!(messaging instanceof DefaultMessaging)) {
            errorHandler();
        } else {
            ((DefaultMessaging) messaging).getMessagingComponent().guideArticleFragmentComponent().create((SavedStateRegistryOwner) this, getArguments()).inject(this);
            this.guideArticleViewerViewModel = (GuideArticleViewerViewModel) new ViewModelProvider((ViewModelStoreOwner) this, getGuideArticleViewerViewModelFactory()).get(GuideArticleViewerViewModel.class);
        }
    }

    public final void errorHandler() {
        Logger.m219e(LOG_TAG, "Unable to show the article viewer screen without a Messaging instance.", new Object[0]);
        FragmentActivity activity = getActivity();
        if (activity != null) {
            activity.finish();
        }
    }

    public void onViewCreated(View view, Bundle savedInstanceState) {
        Intrinsics.checkNotNullParameter(view, "view");
        super.onViewCreated(view, savedInstanceState);
        BottomSheetDialog bottomSheetDialogRequireDialog = requireDialog();
        Intrinsics.checkNotNull(bottomSheetDialogRequireDialog, "null cannot be cast to non-null type com.google.android.material.bottomsheet.BottomSheetDialog");
        bottomSheetDialogRequireDialog.getOnBackPressedDispatcher().addCallback(this.onBackPressedCallback);
        Object objFindViewById = view.findViewById(C1256R.id.zma_article_viewer);
        Intrinsics.checkNotNullExpressionValue(objFindViewById, "findViewById(...)");
        ArticleViewer articleViewer = (ArticleViewer) objFindViewById;
        this.articleViewer = articleViewer;
        if (articleViewer == null) {
            Intrinsics.throwUninitializedPropertyAccessException("articleViewer");
            articleViewer = null;
        }
        articleViewer.render(this.defaultRendering);
        LifecycleOwner viewLifecycleOwner = getViewLifecycleOwner();
        Intrinsics.checkNotNullExpressionValue(viewLifecycleOwner, "getViewLifecycleOwner(...)");
        BuildersKt__Builders_commonKt.launch$default(LifecycleOwnerKt.getLifecycleScope(viewLifecycleOwner), null, null, new C14241(null), 3, null);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.GuideArticleViewerBottomSheetFragment$onViewCreated$1", m37f = "GuideArticleViewerBottomSheetFragment.kt", m38i = {}, m39l = {355}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C14241 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C14241(Continuation<? super C14241> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return GuideArticleViewerBottomSheetFragment.this.new C14241(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C14241) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
        @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.GuideArticleViewerBottomSheetFragment$onViewCreated$1$1", m37f = "GuideArticleViewerBottomSheetFragment.kt", m38i = {}, m39l = {356, 370}, m40m = "invokeSuspend", m41n = {}, m42s = {})
        static final class AnonymousClass1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
            int label;
            final GuideArticleViewerBottomSheetFragment this$0;

            AnonymousClass1(GuideArticleViewerBottomSheetFragment guideArticleViewerBottomSheetFragment, Continuation<? super AnonymousClass1> continuation) {
                super(2, continuation);
                this.this$0 = guideArticleViewerBottomSheetFragment;
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
                    if (this.this$0.setupGuideArticleViewerDependencies(this) == coroutine_suspended) {
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
                String string = arguments != null ? arguments.getString(GuideArticleViewerBottomSheetFragment.ARG_GUIDE_ARTICLE_URL) : null;
                if (string != null) {
                    GuideArticleViewerViewModel guideArticleViewerViewModel = this.this$0.guideArticleViewerViewModel;
                    if (guideArticleViewerViewModel == null) {
                        Intrinsics.throwUninitializedPropertyAccessException("guideArticleViewerViewModel");
                        guideArticleViewerViewModel = null;
                    }
                    guideArticleViewerViewModel.process(new GuideArticleViewerAction.RefreshTheme(this.this$0.getMessagingTheme()));
                    GuideArticleViewerViewModel guideArticleViewerViewModel2 = this.this$0.guideArticleViewerViewModel;
                    if (guideArticleViewerViewModel2 == null) {
                        Intrinsics.throwUninitializedPropertyAccessException("guideArticleViewerViewModel");
                        guideArticleViewerViewModel2 = null;
                    }
                    guideArticleViewerViewModel2.process(new GuideArticleViewerAction.Load(string));
                    LifecycleOwner viewLifecycleOwner = this.this$0.getViewLifecycleOwner();
                    Intrinsics.checkNotNullExpressionValue(viewLifecycleOwner, "getViewLifecycleOwner(...)");
                    this.label = 2;
                    if (RepeatOnLifecycleKt.repeatOnLifecycle(viewLifecycleOwner, Lifecycle.State.STARTED, new C16761(this.this$0, null), this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    this.this$0.errorHandler();
                }
                return Unit.INSTANCE;
            }

            @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
            @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.GuideArticleViewerBottomSheetFragment$onViewCreated$1$1$1", m37f = "GuideArticleViewerBottomSheetFragment.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
            static final class C16761 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                private Object L$0;
                int label;
                final GuideArticleViewerBottomSheetFragment this$0;

                C16761(GuideArticleViewerBottomSheetFragment guideArticleViewerBottomSheetFragment, Continuation<? super C16761> continuation) {
                    super(2, continuation);
                    this.this$0 = guideArticleViewerBottomSheetFragment;
                }

                @Override
                public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                    C16761 c16761 = new C16761(this.this$0, continuation);
                    c16761.L$0 = obj;
                    return c16761;
                }

                @Override
                public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                    return ((C16761) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
                }

                @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
                @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.GuideArticleViewerBottomSheetFragment$onViewCreated$1$1$1$1", m37f = "GuideArticleViewerBottomSheetFragment.kt", m38i = {}, m39l = {372}, m40m = "invokeSuspend", m41n = {}, m42s = {})
                static final class C16771 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                    int label;
                    final GuideArticleViewerBottomSheetFragment this$0;

                    C16771(GuideArticleViewerBottomSheetFragment guideArticleViewerBottomSheetFragment, Continuation<? super C16771> continuation) {
                        super(2, continuation);
                        this.this$0 = guideArticleViewerBottomSheetFragment;
                    }

                    @Override
                    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                        return new C16771(this.this$0, continuation);
                    }

                    @Override
                    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                        return ((C16771) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
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
                        BuildersKt__Builders_commonKt.launch$default(coroutineScope, null, null, new C16771(this.this$0, null), 3, null);
                        BuildersKt__Builders_commonKt.launch$default(coroutineScope, null, null, new AnonymousClass2(this.this$0, null), 3, null);
                        return Unit.INSTANCE;
                    }
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }

                @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
                @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.GuideArticleViewerBottomSheetFragment$onViewCreated$1$1$1$2", m37f = "GuideArticleViewerBottomSheetFragment.kt", m38i = {}, m39l = {375}, m40m = "invokeSuspend", m41n = {}, m42s = {})
                static final class AnonymousClass2 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                    int label;
                    final GuideArticleViewerBottomSheetFragment this$0;

                    AnonymousClass2(GuideArticleViewerBottomSheetFragment guideArticleViewerBottomSheetFragment, Continuation<? super AnonymousClass2> continuation) {
                        super(2, continuation);
                        this.this$0 = guideArticleViewerBottomSheetFragment;
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
                            GuideArticleViewerBottomSheetFragment guideArticleViewerBottomSheetFragment = this.this$0;
                            Context contextRequireContext = guideArticleViewerBottomSheetFragment.requireContext();
                            Intrinsics.checkNotNullExpressionValue(contextRequireContext, "requireContext(...)");
                            this.label = 1;
                            if (guideArticleViewerBottomSheetFragment.collectEvents(contextRequireContext, this) == coroutine_suspended) {
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
                LifecycleOwner viewLifecycleOwner = GuideArticleViewerBottomSheetFragment.this.getViewLifecycleOwner();
                Intrinsics.checkNotNullExpressionValue(viewLifecycleOwner, "getViewLifecycleOwner(...)");
                this.label = 1;
                if (RepeatOnLifecycleKt.repeatOnLifecycle(viewLifecycleOwner, Lifecycle.State.CREATED, new AnonymousClass1(GuideArticleViewerBottomSheetFragment.this, null), this) == coroutine_suspended) {
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
        Dialog dialog = getDialog();
        if (dialog != null) {
            BottomSheetDialogKtxKt.setFullScreen$default(dialog, 0, false, 3, null);
        }
    }

    public final void shareUrl(String url) {
        Intent intent = new Intent();
        intent.setAction("android.intent.action.SEND");
        intent.putExtra("android.intent.extra.TEXT", url);
        intent.setType(HTTP.PLAIN_TEXT_TYPE);
        startActivity(Intent.createChooser(intent, ""));
    }

    @Metadata(m17d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0016\u0010\b\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\u00042\u0006\u0010\u000b\u001a\u00020\u0004R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0004X\u0080T¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000¨\u0006\f"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerBottomSheetFragment$Companion;", "", "()V", "ARG_CREDENTIALS", "", "ARG_GUIDE_ARTICLE_URL", "LOG_TAG", "TAG", "newInstance", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerBottomSheetFragment;", "guideArticleUrl", "credentials", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final GuideArticleViewerBottomSheetFragment newInstance(String guideArticleUrl, String credentials) {
            Intrinsics.checkNotNullParameter(guideArticleUrl, "guideArticleUrl");
            Intrinsics.checkNotNullParameter(credentials, "credentials");
            GuideArticleViewerBottomSheetFragment guideArticleViewerBottomSheetFragment = new GuideArticleViewerBottomSheetFragment();
            Bundle bundle = new Bundle();
            bundle.putString(GuideArticleViewerBottomSheetFragment.ARG_GUIDE_ARTICLE_URL, guideArticleUrl);
            bundle.putString(GuideArticleViewerBottomSheetFragment.ARG_CREDENTIALS, credentials);
            guideArticleViewerBottomSheetFragment.setArguments(bundle);
            return guideArticleViewerBottomSheetFragment;
        }
    }
}
