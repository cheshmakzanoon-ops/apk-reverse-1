package zendesk.messaging.android.internal.conversationslistscreen;

import android.content.Context;
import android.net.Uri;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import androidx.constraintlayout.widget.ConstraintLayout;
import cz.msebera.android.httpclient.HttpStatus;
import kotlin.Lazy;
import kotlin.LazyKt;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.ConnectionStatus;
import zendesk.core.p017ui.android.internal.xml.AccessibilityExtKt;
import zendesk.core.p017ui.android.internal.xml.InsetType;
import zendesk.core.p017ui.android.internal.xml.SystemWindowInsetsKt;
import zendesk.logger.Logger;
import zendesk.messaging.C1256R;
import zendesk.messaging.android.internal.conversationslistscreen.list.ConversationsListView;
import zendesk.messaging.android.internal.conversationslistscreen.list.ConversationsListViewRendering;
import zendesk.p026ui.android.conversation.bottomsheet.BottomSheetRendering;
import zendesk.p026ui.android.conversation.bottomsheet.BottomSheetState;
import zendesk.p026ui.android.conversation.bottomsheet.BottomSheetView;
import zendesk.p026ui.android.conversation.header.ConversationHeaderRendering;
import zendesk.p026ui.android.conversation.header.ConversationHeaderState;
import zendesk.p026ui.android.conversation.header.ConversationHeaderView;
import zendesk.p026ui.android.conversations.LoadingIndicatorRendering;
import zendesk.p026ui.android.conversations.LoadingIndicatorState;
import zendesk.p026ui.android.conversations.LoadingIndicatorView;
import zendesk.ui.android.Renderer;
import zendesk.ui.android.common.button.ButtonRendering;
import zendesk.ui.android.common.button.ButtonState;
import zendesk.ui.android.common.button.ButtonView;
import zendesk.ui.android.common.connectionbanner.ConnectionBannerRendering;
import zendesk.ui.android.common.connectionbanner.ConnectionBannerState;
import zendesk.ui.android.common.connectionbanner.ConnectionBannerView;
import zendesk.ui.android.common.retryerror.RetryErrorRendering;
import zendesk.ui.android.common.retryerror.RetryErrorState;
import zendesk.ui.android.common.retryerror.RetryErrorView;

@Metadata(m17d1 = {"\u0000\u0094\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\b\b\u0000\u0018\u0000 82\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002:\u00018B%\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t¢\u0006\u0002\u0010\nJ\b\u00100\u001a\u000201H\u0002J\b\u00102\u001a\u000201H\u0002J&\u00103\u001a\u0002012\u001c\u00104\u001a\u0018\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030\u000ej\b\u0012\u0004\u0012\u00020\u0003`\u0010H\u0016J\b\u00105\u001a\u000201H\u0002J\b\u00106\u001a\u000201H\u0002J\b\u00107\u001a\u000201H\u0002R\u000e\u0010\u000b\u001a\u00020\fX\u0082\u0004¢\u0006\u0002\n\u0000R$\u0010\r\u001a\u0018\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\u000f0\u000ej\b\u0012\u0004\u0012\u00020\u000f`\u0010X\u0082\u0004¢\u0006\u0002\n\u0000R$\u0010\u0011\u001a\u0018\u0012\u0004\u0012\u00020\u0012\u0012\u0004\u0012\u00020\u00120\u000ej\b\u0012\u0004\u0012\u00020\u0012`\u0010X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0013\u001a\u00020\u0014X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0015\u001a\u00020\u0016X\u0082\u0004¢\u0006\u0002\n\u0000R$\u0010\u0017\u001a\u0018\u0012\u0004\u0012\u00020\u0018\u0012\u0004\u0012\u00020\u00180\u000ej\b\u0012\u0004\u0012\u00020\u0018`\u0010X\u0082\u0004¢\u0006\u0002\n\u0000R$\u0010\u0019\u001a\u0018\u0012\u0004\u0012\u00020\u001a\u0012\u0004\u0012\u00020\u001a0\u000ej\b\u0012\u0004\u0012\u00020\u001a`\u0010X\u0082\u0004¢\u0006\u0002\n\u0000R$\u0010\u001b\u001a\u0018\u0012\u0004\u0012\u00020\u001c\u0012\u0004\u0012\u00020\u001c0\u000ej\b\u0012\u0004\u0012\u00020\u001c`\u0010X\u0082\u0004¢\u0006\u0002\n\u0000R\u001b\u0010\u001d\u001a\u00020\u001e8BX\u0082\u0084\u0002¢\u0006\f\n\u0004\b!\u0010\"\u001a\u0004\b\u001f\u0010 R$\u0010#\u001a\u0018\u0012\u0004\u0012\u00020$\u0012\u0004\u0012\u00020$0\u000ej\b\u0012\u0004\u0012\u00020$`\u0010X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010%\u001a\u00020&X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010'\u001a\u00020(X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010)\u001a\u00020*X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010+\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010,\u001a\u00020-X\u0082\u0004¢\u0006\u0002\n\u0000R$\u0010.\u001a\u0018\u0012\u0004\u0012\u00020/\u0012\u0004\u0012\u00020/0\u000ej\b\u0012\u0004\u0012\u00020/`\u0010X\u0082\u0004¢\u0006\u0002\n\u0000¨\u00069"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenView;", "Landroidx/constraintlayout/widget/ConstraintLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "(Landroid/content/Context;Landroid/util/AttributeSet;I)V", "connectionBannerView", "Lzendesk/ui/android/common/connectionbanner/ConnectionBannerView;", "connectionBannerViewRenderingUpdate", "Lkotlin/Function1;", "Lzendesk/ui/android/common/connectionbanner/ConnectionBannerRendering;", "Lzendesk/messaging/android/internal/conversationscreen/RenderingUpdate;", "conversationHeaderRenderingUpdate", "Lzendesk/ui/android/conversation/header/ConversationHeaderRendering;", "conversationHeaderView", "Lzendesk/ui/android/conversation/header/ConversationHeaderView;", "conversationsListView", "Lzendesk/messaging/android/internal/conversationslistscreen/list/ConversationsListView;", "conversationsListViewRenderingUpdate", "Lzendesk/messaging/android/internal/conversationslistscreen/list/ConversationsListViewRendering;", "conversationsLoaderRenderingUpdate", "Lzendesk/ui/android/conversations/LoadingIndicatorRendering;", "createConversationButtonRenderingUpdate", "Lzendesk/ui/android/common/button/ButtonRendering;", "createConversationFailedBottomSheet", "Lzendesk/ui/android/conversation/bottomsheet/BottomSheetView;", "getCreateConversationFailedBottomSheet", "()Lzendesk/ui/android/conversation/bottomsheet/BottomSheetView;", "createConversationFailedBottomSheet$delegate", "Lkotlin/Lazy;", "createConversationFailedBottomSheetRenderingUpdate", "Lzendesk/ui/android/conversation/bottomsheet/BottomSheetRendering;", "createConversationsButton", "Lzendesk/ui/android/common/button/ButtonView;", "createConversationsButtonContainer", "Landroid/widget/FrameLayout;", "loadingIndicatorView", "Lzendesk/ui/android/conversations/LoadingIndicatorView;", "rendering", "retryErrorView", "Lzendesk/ui/android/common/retryerror/RetryErrorView;", "retryErrorViewRenderingUpdate", "Lzendesk/ui/android/common/retryerror/RetryErrorRendering;", "announceForAccessibilityWhenNewMessageReceived", "", "applyWindowInsetsToScreenContent", "render", "renderingUpdate", "showErrorView", "showListView", "showLoading", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationsListScreenView extends ConstraintLayout implements Renderer<ConversationsListScreenRendering> {
    private static final Companion Companion = new Companion(null);
    private static final String LOG_TAG = "ConversationsListScreenView";
    private final ConnectionBannerView connectionBannerView;
    private final Function1<ConnectionBannerRendering, ConnectionBannerRendering> connectionBannerViewRenderingUpdate;
    private final Function1<ConversationHeaderRendering, ConversationHeaderRendering> conversationHeaderRenderingUpdate;
    private final ConversationHeaderView conversationHeaderView;
    private final ConversationsListView conversationsListView;
    private final Function1<ConversationsListViewRendering, ConversationsListViewRendering> conversationsListViewRenderingUpdate;
    private final Function1<LoadingIndicatorRendering, LoadingIndicatorRendering> conversationsLoaderRenderingUpdate;
    private final Function1<ButtonRendering, ButtonRendering> createConversationButtonRenderingUpdate;

    private final Lazy createConversationFailedBottomSheet;
    private final Function1<BottomSheetRendering, BottomSheetRendering> createConversationFailedBottomSheetRenderingUpdate;
    private final ButtonView createConversationsButton;
    private final FrameLayout createConversationsButtonContainer;
    private final LoadingIndicatorView loadingIndicatorView;
    private ConversationsListScreenRendering rendering;
    private final RetryErrorView retryErrorView;
    private final Function1<RetryErrorRendering, RetryErrorRendering> retryErrorViewRenderingUpdate;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[ConversationsListState.values().length];
            try {
                iArr[ConversationsListState.SUCCESS.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[ConversationsListState.LOADING.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[ConversationsListState.FAILED_ENTRY_POINT.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                iArr[ConversationsListState.FAILED_CONVERSATIONS.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
            try {
                iArr[ConversationsListState.IDLE.ordinal()] = 5;
            } catch (NoSuchFieldError unused5) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public ConversationsListScreenView(Context context) {
        this(context, null, 0, 6, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ConversationsListScreenView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 4, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ConversationsListScreenView(Context context, AttributeSet attributeSet, int i, int i2, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i2 & 2) != 0 ? null : attributeSet, (i2 & 4) != 0 ? 0 : i);
    }

    public ConversationsListScreenView(final Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new ConversationsListScreenRendering();
        this.conversationHeaderRenderingUpdate = new Function1<ConversationHeaderRendering, ConversationHeaderRendering>() {
            {
                super(1);
            }

            @Override
            public final ConversationHeaderRendering invoke(ConversationHeaderRendering conversationHeaderRendering) {
                Intrinsics.checkNotNullParameter(conversationHeaderRendering, "conversationHeaderRendering");
                ConversationHeaderRendering.Builder builder = conversationHeaderRendering.toBuilder();
                final ConversationsListScreenView conversationsListScreenView = this.this$0;
                return builder.state(new Function1<ConversationHeaderState, ConversationHeaderState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final ConversationHeaderState invoke(ConversationHeaderState state) {
                        Intrinsics.checkNotNullParameter(state, "state");
                        return state.copy((HttpStatus.SC_MULTI_STATUS & 1) != 0 ? state.title : conversationsListScreenView.rendering.getState().getTitle(), (HttpStatus.SC_MULTI_STATUS & 2) != 0 ? state.description : conversationsListScreenView.rendering.getState().getDescription(), (HttpStatus.SC_MULTI_STATUS & 4) != 0 ? state.imageUrl : Uri.parse(conversationsListScreenView.rendering.getState().getLogoUrl()), (HttpStatus.SC_MULTI_STATUS & 8) != 0 ? state.accessibilityTitle : null, (HttpStatus.SC_MULTI_STATUS & 16) != 0 ? state.backgroundColor : Integer.valueOf(conversationsListScreenView.rendering.getState().getMessagingTheme().getPrimaryColor()), (HttpStatus.SC_MULTI_STATUS & 32) != 0 ? state.statusBarColor : Integer.valueOf(conversationsListScreenView.rendering.getState().getMessagingTheme().getPrimaryColor()), (HttpStatus.SC_MULTI_STATUS & 64) != 0 ? state.titleColor : Integer.valueOf(conversationsListScreenView.rendering.getState().getMessagingTheme().getOnPrimaryColor()), (HttpStatus.SC_MULTI_STATUS & 128) != 0 ? state.backButtonColor : Integer.valueOf(conversationsListScreenView.rendering.getState().getMessagingTheme().getOnPrimaryColor()));
                    }
                }).onBackButtonClicked(this.this$0.rendering.getOnBackButtonClicked$zendesk_messaging_messaging_android()).build();
            }
        };
        this.conversationsLoaderRenderingUpdate = new Function1<LoadingIndicatorRendering, LoadingIndicatorRendering>() {
            {
                super(1);
            }

            @Override
            public final LoadingIndicatorRendering invoke(LoadingIndicatorRendering loadingRendering) {
                Intrinsics.checkNotNullParameter(loadingRendering, "loadingRendering");
                final ConversationsListState conversationsListState = this.this$0.rendering.getState().getConversationsListState();
                LoadingIndicatorRendering.Builder builder = loadingRendering.toBuilder();
                final ConversationsListScreenView conversationsListScreenView = this.this$0;
                return builder.state(new Function1<LoadingIndicatorState, LoadingIndicatorState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final LoadingIndicatorState invoke(LoadingIndicatorState state) {
                        Intrinsics.checkNotNullParameter(state, "state");
                        return state.copy(conversationsListState == ConversationsListState.LOADING, conversationsListScreenView.rendering.getState().getMessagingTheme().getPrimaryColor());
                    }
                }).build();
            }
        };
        this.conversationsListViewRenderingUpdate = new Function1<ConversationsListViewRendering, ConversationsListViewRendering>() {
            {
                super(1);
            }

            @Override
            public final ConversationsListViewRendering invoke(ConversationsListViewRendering listRendering) {
                Intrinsics.checkNotNullParameter(listRendering, "listRendering");
                ConversationsListViewRendering.Builder builderLoadMoreListener = listRendering.toBuilder().onRetryItemClickLambda(this.this$0.rendering.getOnRetryPaginationClick$zendesk_messaging_messaging_android()).onListItemClickLambda(this.this$0.rendering.getOnListItemClickLambda$zendesk_messaging_messaging_android()).loadMoreListener(this.this$0.rendering.getOnStartPagingLambda$zendesk_messaging_messaging_android());
                final ConversationsListScreenView conversationsListScreenView = this.this$0;
                return builderLoadMoreListener.state(new Function1<zendesk.messaging.android.internal.conversationslistscreen.list.ConversationsListState, zendesk.messaging.android.internal.conversationslistscreen.list.ConversationsListState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final zendesk.messaging.android.internal.conversationslistscreen.list.ConversationsListState invoke(zendesk.messaging.android.internal.conversationslistscreen.list.ConversationsListState state) {
                        Intrinsics.checkNotNullParameter(state, "state");
                        return zendesk.messaging.android.internal.conversationslistscreen.list.ConversationsListState.copy$default(state, conversationsListScreenView.rendering.getState().getConversations(), null, conversationsListScreenView.rendering.getState().getMessagingTheme(), 2, null);
                    }
                }).build();
            }
        };
        this.createConversationButtonRenderingUpdate = new Function1<ButtonRendering, ButtonRendering>() {
            {
                super(1);
            }

            @Override
            public final ButtonRendering invoke(ButtonRendering it) {
                Intrinsics.checkNotNullParameter(it, "it");
                ButtonRendering.Builder builder = it.toBuilder();
                final Context context2 = context;
                final ConversationsListScreenView conversationsListScreenView = this;
                ButtonRendering.Builder builderState = builder.state(new Function1<ButtonState, ButtonState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final ButtonState invoke(ButtonState state) {
                        Intrinsics.checkNotNullParameter(state, "state");
                        String string = context2.getString(C1256R.string.zma_new_conversation_button);
                        int actionColor = conversationsListScreenView.rendering.getState().getMessagingTheme().getActionColor();
                        boolean z = conversationsListScreenView.rendering.getState().getCreateConversationState() == CreateConversationState.LOADING;
                        int onActionColor = conversationsListScreenView.rendering.getState().getMessagingTheme().getOnActionColor();
                        int onActionColor2 = conversationsListScreenView.rendering.getState().getMessagingTheme().getOnActionColor();
                        Intrinsics.checkNotNull(string);
                        return ButtonState.copy$default(state, string, z, Integer.valueOf(actionColor), Integer.valueOf(onActionColor), Integer.valueOf(onActionColor2), false, 32, (Object) null);
                    }
                });
                final ConversationsListScreenView conversationsListScreenView2 = this;
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
                        conversationsListScreenView2.rendering.m269xaab7ad3d().invoke();
                    }
                }).build();
            }
        };
        this.createConversationFailedBottomSheet = LazyKt.lazy(new Function0<BottomSheetView>() {
            {
                super(0);
            }

            @Override
            public final BottomSheetView invoke() {
                return new BottomSheetView(context);
            }
        });
        this.createConversationFailedBottomSheetRenderingUpdate = new Function1<BottomSheetRendering, BottomSheetRendering>() {
            {
                super(1);
            }

            @Override
            public final BottomSheetRendering invoke(BottomSheetRendering bottomSheetRendering) {
                Intrinsics.checkNotNullParameter(bottomSheetRendering, "bottomSheetRendering");
                BottomSheetRendering.Builder builder = bottomSheetRendering.toBuilder();
                final ConversationsListScreenView conversationsListScreenView = this.this$0;
                BottomSheetRendering.Builder builderOnBottomSheetActionClicked = builder.onBottomSheetActionClicked(new Function0<Unit>() {
                    {
                        super(0);
                    }

                    @Override
                    public Unit invoke() {
                        invoke2();
                        return Unit.INSTANCE;
                    }

                    public final void invoke2() {
                        conversationsListScreenView.getCreateConversationFailedBottomSheet().dismiss();
                        conversationsListScreenView.rendering.m270xbb9b9606().invoke();
                    }
                });
                final Context context2 = context;
                final ConversationsListScreenView conversationsListScreenView2 = this.this$0;
                return builderOnBottomSheetActionClicked.state(new Function1<BottomSheetState, BottomSheetState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final BottomSheetState invoke(BottomSheetState state) {
                        Intrinsics.checkNotNullParameter(state, "state");
                        String string = context2.getString(C1256R.string.zma_new_conversation_error_alert);
                        String string2 = context2.getString(C1256R.string.zma_new_conversation_error_alert_dismiss_button);
                        int dangerColor = conversationsListScreenView2.rendering.getState().getMessagingTheme().getDangerColor();
                        int onDangerColor = conversationsListScreenView2.rendering.getState().getMessagingTheme().getOnDangerColor();
                        int onDangerColor2 = conversationsListScreenView2.rendering.getState().getMessagingTheme().getOnDangerColor();
                        boolean z = conversationsListScreenView2.rendering.getState().getCreateConversationState() == CreateConversationState.FAILED;
                        Intrinsics.checkNotNull(string);
                        Intrinsics.checkNotNull(string2);
                        return BottomSheetState.copy$default(state, string, string2, 0L, z, Integer.valueOf(dangerColor), Integer.valueOf(onDangerColor), Integer.valueOf(onDangerColor2), 4, null);
                    }
                }).build();
            }
        };
        this.retryErrorViewRenderingUpdate = new Function1<RetryErrorRendering, RetryErrorRendering>() {
            {
                super(1);
            }

            @Override
            public final RetryErrorRendering invoke(RetryErrorRendering retryErrorRendering) {
                Intrinsics.checkNotNullParameter(retryErrorRendering, "retryErrorRendering");
                final String string = context.getString(C1256R.string.zuia_conversations_list_tap_to_retry_message_label);
                Intrinsics.checkNotNullExpressionValue(string, "getString(...)");
                RetryErrorRendering.Builder builder = retryErrorRendering.toBuilder();
                final ConversationsListScreenView conversationsListScreenView = this;
                final Context context2 = context;
                RetryErrorRendering.Builder builderState = builder.state(new Function1<RetryErrorState, RetryErrorState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final RetryErrorState invoke(RetryErrorState state) {
                        Intrinsics.checkNotNullParameter(state, "state");
                        int onBackgroundColor = conversationsListScreenView.rendering.getState().getMessagingTheme().getOnBackgroundColor();
                        String string2 = context2.getString(C1256R.string.zuia_conversation_message_label_tap_to_retry);
                        int onBackgroundColor2 = conversationsListScreenView.rendering.getState().getMessagingTheme().getOnBackgroundColor();
                        String str = string;
                        Intrinsics.checkNotNull(string2);
                        return state.copy(str, onBackgroundColor2, string2, onBackgroundColor);
                    }
                });
                final ConversationsListScreenView conversationsListScreenView2 = this;
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
                        conversationsListScreenView2.rendering.getOnRetryButtonClicked$zendesk_messaging_messaging_android().invoke();
                    }
                }).build();
            }
        };
        this.connectionBannerViewRenderingUpdate = new Function1<ConnectionBannerRendering, ConnectionBannerRendering>() {
            {
                super(1);
            }

            @Override
            public final ConnectionBannerRendering invoke(ConnectionBannerRendering connectionBannerRendering) {
                Intrinsics.checkNotNullParameter(connectionBannerRendering, "connectionBannerRendering");
                ConnectionBannerRendering.Builder builderShowRetry = connectionBannerRendering.toBuilder().showRetry(false);
                final ConversationsListScreenView conversationsListScreenView = this.this$0;
                return builderShowRetry.state(new Function1<ConnectionBannerState, ConnectionBannerState>() {

                    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
                    public class WhenMappings {
                        public static final int[] $EnumSwitchMapping$0;

                        static {
                            int[] iArr = new int[ConnectionStatus.values().length];
                            try {
                                iArr[ConnectionStatus.DISCONNECTED.ordinal()] = 1;
                            } catch (NoSuchFieldError unused) {
                            }
                            try {
                                iArr[ConnectionStatus.CONNECTING_REALTIME.ordinal()] = 2;
                            } catch (NoSuchFieldError unused2) {
                            }
                            try {
                                iArr[ConnectionStatus.CONNECTED_REALTIME.ordinal()] = 3;
                            } catch (NoSuchFieldError unused3) {
                            }
                            $EnumSwitchMapping$0 = iArr;
                        }
                    }

                    {
                        super(1);
                    }

                    @Override
                    public final ConnectionBannerState invoke(ConnectionBannerState state) {
                        ConnectionBannerState.ConnectionState connectionState;
                        Intrinsics.checkNotNullParameter(state, "state");
                        ConnectionStatus connectionStatus = conversationsListScreenView.rendering.getState().getConnectionStatus();
                        int i2 = connectionStatus == null ? -1 : WhenMappings.$EnumSwitchMapping$0[connectionStatus.ordinal()];
                        if (i2 == 1) {
                            connectionState = ConnectionBannerState.ConnectionState.Disconnected.INSTANCE;
                        } else if (i2 == 2) {
                            connectionState = (ConnectionBannerState.ConnectionState) ConnectionBannerState.ConnectionState.Reconnecting.INSTANCE;
                        } else if (i2 == 3) {
                            connectionState = (ConnectionBannerState.ConnectionState) ConnectionBannerState.ConnectionState.Reconnected.INSTANCE;
                        } else {
                            connectionState = (ConnectionBannerState.ConnectionState) ConnectionBannerState.ConnectionState.Connected.INSTANCE;
                        }
                        return state.copy(connectionState, conversationsListScreenView.rendering.getState().getMessagingTheme().getBackgroundColor(), conversationsListScreenView.rendering.getState().getMessagingTheme().getOnBackgroundColor(), conversationsListScreenView.rendering.getState().getMessagingTheme().getSuccessColor());
                    }
                }).build();
            }
        };
        ConstraintLayout.inflate(context, C1256R.layout.zma_view_conversations_list_screen, (ViewGroup) this);
        View viewFindViewById = findViewById(C1256R.id.zma_conversations_list_header_view);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
        this.conversationHeaderView = (ConversationHeaderView) viewFindViewById;
        View viewFindViewById2 = findViewById(C1256R.id.zma_loading_indicator_view);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById2, "findViewById(...)");
        this.loadingIndicatorView = (LoadingIndicatorView) viewFindViewById2;
        View viewFindViewById3 = findViewById(C1256R.id.zma_conversations_list_view);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById3, "findViewById(...)");
        this.conversationsListView = (ConversationsListView) viewFindViewById3;
        ButtonView buttonViewFindViewById = findViewById(C1256R.id.zma_create_conversation_button);
        Intrinsics.checkNotNullExpressionValue(buttonViewFindViewById, "findViewById(...)");
        this.createConversationsButton = buttonViewFindViewById;
        View viewFindViewById4 = findViewById(C1256R.id.zma_button_container);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById4, "findViewById(...)");
        this.createConversationsButtonContainer = (FrameLayout) viewFindViewById4;
        RetryErrorView retryErrorViewFindViewById = findViewById(C1256R.id.zma_retry_error_view);
        Intrinsics.checkNotNullExpressionValue(retryErrorViewFindViewById, "findViewById(...)");
        this.retryErrorView = retryErrorViewFindViewById;
        ConnectionBannerView connectionBannerViewFindViewById = findViewById(C1256R.id.zma_conversations_list_connection_banner);
        Intrinsics.checkNotNullExpressionValue(connectionBannerViewFindViewById, "findViewById(...)");
        this.connectionBannerView = connectionBannerViewFindViewById;
        render(new Function1<ConversationsListScreenRendering, ConversationsListScreenRendering>() {
            @Override
            public final ConversationsListScreenRendering invoke(ConversationsListScreenRendering it) {
                Intrinsics.checkNotNullParameter(it, "it");
                return it;
            }
        });
    }

    public final BottomSheetView getCreateConversationFailedBottomSheet() {
        return (BottomSheetView) this.createConversationFailedBottomSheet.getValue();
    }

    public void render(Function1<? super ConversationsListScreenRendering, ConversationsListScreenRendering> renderingUpdate) {
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        this.rendering = renderingUpdate.invoke(this.rendering);
        Logger.m221i(LOG_TAG, "Updating the Conversations List Screen with " + this.rendering.getState(), new Object[0]);
        setBackgroundColor(this.rendering.getState().getMessagingTheme().getBackgroundColor());
        this.conversationHeaderView.render(this.conversationHeaderRenderingUpdate);
        this.loadingIndicatorView.render(this.conversationsLoaderRenderingUpdate);
        this.conversationsListView.render(this.conversationsListViewRenderingUpdate);
        this.connectionBannerView.render(this.connectionBannerViewRenderingUpdate);
        getCreateConversationFailedBottomSheet().render(this.createConversationFailedBottomSheetRenderingUpdate);
        this.retryErrorView.render(this.retryErrorViewRenderingUpdate);
        this.createConversationsButton.render(this.createConversationButtonRenderingUpdate);
        int i = WhenMappings.$EnumSwitchMapping$0[this.rendering.getState().getConversationsListState().ordinal()];
        if (i == 1) {
            showListView();
        } else if (i == 2) {
            showLoading();
        } else if (i != 3) {
            if (i == 4) {
                if (this.rendering.getState().getConversations().isEmpty()) {
                    showErrorView();
                } else {
                    showListView();
                }
            }
        } else if (this.rendering.getState().getConversations().isEmpty()) {
            showErrorView();
        } else {
            showListView();
        }
        applyWindowInsetsToScreenContent();
        announceForAccessibilityWhenNewMessageReceived();
    }

    private final void showErrorView() {
        this.loadingIndicatorView.setVisibility(8);
        this.retryErrorView.setVisibility(0);
        this.createConversationsButton.setVisibility(8);
    }

    private final void showListView() {
        this.retryErrorView.setVisibility(8);
        this.loadingIndicatorView.setVisibility(8);
        this.createConversationsButton.setVisibility(this.rendering.getState().getCanUserCreateMoreConversations() ? 0 : 8);
    }

    private final void showLoading() {
        this.loadingIndicatorView.setVisibility(0);
        this.retryErrorView.setVisibility(8);
        this.createConversationsButton.setVisibility(8);
    }

    private final void applyWindowInsetsToScreenContent() {
        SystemWindowInsetsKt.applyWindowInsets((View) this, InsetType.BOTTOM);
        SystemWindowInsetsKt.applyWindowInsets(this.loadingIndicatorView, InsetType.HORIZONTAL);
        SystemWindowInsetsKt.applyWindowInsets(this.conversationsListView, InsetType.HORIZONTAL);
        SystemWindowInsetsKt.applyWindowInsets(this.connectionBannerView, InsetType.HORIZONTAL);
        SystemWindowInsetsKt.applyWindowInsets(this.retryErrorView, InsetType.HORIZONTAL);
        SystemWindowInsetsKt.applyWindowInsets(this.createConversationsButtonContainer, InsetType.HORIZONTAL);
    }

    private final void announceForAccessibilityWhenNewMessageReceived() {
        String receivedMessageAuthor;
        Context context = getContext();
        Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
        if (!AccessibilityExtKt.isAccessibilityServiceRunning(context) || (receivedMessageAuthor = this.rendering.getState().getReceivedMessageAuthor()) == null) {
            return;
        }
        String string = getContext().getString(C1256R.string.zuia_accessibility_message_received, receivedMessageAuthor);
        Intrinsics.checkNotNullExpressionValue(string, "getString(...)");
        announceForAccessibility(string);
        this.rendering.m271x6ade096f().invoke();
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u0005"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenView$Companion;", "", "()V", "LOG_TAG", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
