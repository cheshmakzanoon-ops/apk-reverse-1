package zendesk.messaging.android.internal.conversationscreen;

import android.content.Context;
import android.net.Uri;
import android.text.Spanned;
import android.util.AttributeSet;
import android.view.View;
import android.widget.RelativeLayout;
import androidx.core.content.ContextCompat;
import androidx.core.text.HtmlCompat;
import java.util.List;
import java.util.Map;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.enums.EnumEntries;
import kotlin.enums.EnumEntriesKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.ConnectionStatus;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.conversationkit.android.model.Message;
import zendesk.core.p017ui.android.internal.xml.InsetType;
import zendesk.core.p017ui.android.internal.xml.SystemWindowInsetsKt;
import zendesk.logger.Logger;
import zendesk.messaging.C1256R;
import zendesk.messaging.android.internal.conversationscreen.messagelog.MessageLogRendering;
import zendesk.messaging.android.internal.conversationscreen.messagelog.MessageLogState;
import zendesk.messaging.android.internal.conversationscreen.messagelog.MessageLogView;
import zendesk.messaging.android.internal.model.MessageLogEntry;
import zendesk.p026ui.android.conversation.bottomsheet.BottomSheetRendering;
import zendesk.p026ui.android.conversation.bottomsheet.BottomSheetState;
import zendesk.p026ui.android.conversation.bottomsheet.BottomSheetView;
import zendesk.p026ui.android.conversation.composer.MessageComposerRendering;
import zendesk.p026ui.android.conversation.composer.MessageComposerState;
import zendesk.p026ui.android.conversation.composer.MessageComposerView;
import zendesk.p026ui.android.conversation.form.DisplayedForm;
import zendesk.p026ui.android.conversation.header.ConversationHeaderRendering;
import zendesk.p026ui.android.conversation.header.ConversationHeaderState;
import zendesk.p026ui.android.conversation.header.ConversationHeaderView;
import zendesk.p026ui.android.conversation.waittimebanner.WaitTimeBannerRendering;
import zendesk.p026ui.android.conversation.waittimebanner.WaitTimeBannerState;
import zendesk.p026ui.android.conversation.waittimebanner.WaitTimeBannerType;
import zendesk.p026ui.android.conversation.waittimebanner.WaitTimeBannerView;
import zendesk.p026ui.android.conversations.LoadingIndicatorRendering;
import zendesk.p026ui.android.conversations.LoadingIndicatorState;
import zendesk.p026ui.android.conversations.LoadingIndicatorView;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;
import zendesk.ui.android.common.buttonbanner.ButtonBannerRendering;
import zendesk.ui.android.common.buttonbanner.ButtonBannerState;
import zendesk.ui.android.common.buttonbanner.ButtonBannerView;
import zendesk.ui.android.common.buttonbanner.ButtonBannerViewType;
import zendesk.ui.android.common.connectionbanner.ConnectionBannerRendering;
import zendesk.ui.android.common.connectionbanner.ConnectionBannerState;
import zendesk.ui.android.common.connectionbanner.ConnectionBannerView;
import zendesk.ui.android.common.retryerror.RetryErrorRendering;
import zendesk.ui.android.common.retryerror.RetryErrorState;
import zendesk.ui.android.common.retryerror.RetryErrorView;

@Metadata(m17d1 = {"\u0000Ä\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0000\u0018\u0000 B2\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002:\u0002BCB%\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t¢\u0006\u0002\u0010\nJ\b\u00102\u001a\u000203H\u0002J\u0010\u00104\u001a\u00020\t2\u0006\u00105\u001a\u000206H\u0002J\u0010\u00107\u001a\u0002032\u0006\u00108\u001a\u000209H\u0002J&\u0010:\u001a\u0002032\u001c\u0010;\u001a\u0018\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030\fj\b\u0012\u0004\u0012\u00020\u0003`\u000eH\u0016J\u0018\u0010<\u001a\u0002032\u0006\u0010=\u001a\u00020>2\u0006\u00105\u001a\u000206H\u0002J\u0010\u0010?\u001a\u0002032\u0006\u0010@\u001a\u00020AH\u0002R$\u0010\u000b\u001a\u0018\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\r0\fj\b\u0012\u0004\u0012\u00020\r`\u000eX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000f\u001a\u00020\u0010X\u0082\u0004¢\u0006\u0002\n\u0000R$\u0010\u0011\u001a\u0018\u0012\u0004\u0012\u00020\u0012\u0012\u0004\u0012\u00020\u00120\fj\b\u0012\u0004\u0012\u00020\u0012`\u000eX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0013\u001a\u00020\u0014X\u0082\u0004¢\u0006\u0002\n\u0000R$\u0010\u0015\u001a\u0018\u0012\u0004\u0012\u00020\u0016\u0012\u0004\u0012\u00020\u00160\fj\b\u0012\u0004\u0012\u00020\u0016`\u000eX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0017\u001a\u00020\u0018X\u0082\u0004¢\u0006\u0002\n\u0000R$\u0010\u0019\u001a\u0018\u0012\u0004\u0012\u00020\u001a\u0012\u0004\u0012\u00020\u001a0\fj\b\u0012\u0004\u0012\u00020\u001a`\u000eX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u001b\u001a\u00020\u001cX\u0082\u0004¢\u0006\u0002\n\u0000R$\u0010\u001d\u001a\u0018\u0012\u0004\u0012\u00020\u001e\u0012\u0004\u0012\u00020\u001e0\fj\b\u0012\u0004\u0012\u00020\u001e`\u000eX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u001f\u001a\u00020 X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010!\u001a\u00020\"X\u0082\u0004¢\u0006\u0002\n\u0000R$\u0010#\u001a\u0018\u0012\u0004\u0012\u00020$\u0012\u0004\u0012\u00020$0\fj\b\u0012\u0004\u0012\u00020$`\u000eX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010%\u001a\u00020&X\u0082\u0004¢\u0006\u0002\n\u0000R$\u0010'\u001a\u0018\u0012\u0004\u0012\u00020(\u0012\u0004\u0012\u00020(0\fj\b\u0012\u0004\u0012\u00020(`\u000eX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010)\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010*\u001a\u00020+X\u0082\u0004¢\u0006\u0002\n\u0000R$\u0010,\u001a\u0018\u0012\u0004\u0012\u00020-\u0012\u0004\u0012\u00020-0\fj\b\u0012\u0004\u0012\u00020-`\u000eX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010.\u001a\u00020/X\u0082\u0004¢\u0006\u0002\n\u0000R$\u00100\u001a\u0018\u0012\u0004\u0012\u000201\u0012\u0004\u0012\u0002010\fj\b\u0012\u0004\u0012\u000201`\u000eX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006D"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenView;", "Landroid/widget/RelativeLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "(Landroid/content/Context;Landroid/util/AttributeSet;I)V", "connectionBannerRenderingUpdate", "Lkotlin/Function1;", "Lzendesk/ui/android/common/connectionbanner/ConnectionBannerRendering;", "Lzendesk/messaging/android/internal/conversationscreen/RenderingUpdate;", "connectionBannerView", "Lzendesk/ui/android/common/connectionbanner/ConnectionBannerView;", "conversationHeaderRenderingUpdate", "Lzendesk/ui/android/conversation/header/ConversationHeaderRendering;", "conversationHeaderView", "Lzendesk/ui/android/conversation/header/ConversationHeaderView;", "deniedPermissionBottomSheetRenderingUpdate", "Lzendesk/ui/android/conversation/bottomsheet/BottomSheetRendering;", "deniedPermissionBottomSheetView", "Lzendesk/ui/android/conversation/bottomsheet/BottomSheetView;", "loadingIndicatorRenderingUpdate", "Lzendesk/ui/android/conversations/LoadingIndicatorRendering;", "loadingIndicatorView", "Lzendesk/ui/android/conversations/LoadingIndicatorView;", "messageComposerRenderingUpdate", "Lzendesk/ui/android/conversation/composer/MessageComposerRendering;", "messageComposerView", "Lzendesk/ui/android/conversation/composer/MessageComposerView;", "messageLogView", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/MessageLogView;", "messageLogViewRenderingUpdate", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/MessageLogRendering;", "postbackBannerView", "Lzendesk/ui/android/common/buttonbanner/ButtonBannerView;", "postbackFailureBannerRenderingUpdate", "Lzendesk/ui/android/common/buttonbanner/ButtonBannerRendering;", "rendering", "retryErrorView", "Lzendesk/ui/android/common/retryerror/RetryErrorView;", "retryErrorViewRenderingUpdate", "Lzendesk/ui/android/common/retryerror/RetryErrorRendering;", "waitTimeBannerView", "Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerView;", "waitTimeBannerViewRenderingUpdate", "Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerRendering;", "applyWindowInsetsToScreenContent", "", "composerVisibility", "isFormFocused", "", "loadMoreMessages", "conversation", "Lzendesk/conversationkit/android/model/Conversation;", "render", "renderingUpdate", "renderWaitTimeBanner", "waitTimeBannerType", "Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerType;", "setState", "state", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenView$ScreenState;", "Companion", "ScreenState", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationScreenView extends RelativeLayout implements Renderer<ConversationScreenRendering> {
    private static final int COMPOSER_MAX_LENGTH = 4096;
    private static final Companion Companion = new Companion(null);
    private static final String LOG_TAG = "ConversationScreenView";
    private static final int MAX_CONVERSATION_LIST_NUM = 100;
    private final Function1<ConnectionBannerRendering, ConnectionBannerRendering> connectionBannerRenderingUpdate;
    private final ConnectionBannerView connectionBannerView;
    private final Function1<ConversationHeaderRendering, ConversationHeaderRendering> conversationHeaderRenderingUpdate;
    private final ConversationHeaderView conversationHeaderView;
    private final Function1<BottomSheetRendering, BottomSheetRendering> deniedPermissionBottomSheetRenderingUpdate;
    private final BottomSheetView deniedPermissionBottomSheetView;
    private final Function1<LoadingIndicatorRendering, LoadingIndicatorRendering> loadingIndicatorRenderingUpdate;
    private final LoadingIndicatorView loadingIndicatorView;
    private final Function1<MessageComposerRendering, MessageComposerRendering> messageComposerRenderingUpdate;
    private final MessageComposerView messageComposerView;
    private final MessageLogView messageLogView;
    private final Function1<MessageLogRendering, MessageLogRendering> messageLogViewRenderingUpdate;
    private final ButtonBannerView postbackBannerView;
    private final Function1<ButtonBannerRendering, ButtonBannerRendering> postbackFailureBannerRenderingUpdate;
    private ConversationScreenRendering rendering;
    private final RetryErrorView retryErrorView;
    private final Function1<RetryErrorRendering, RetryErrorRendering> retryErrorViewRenderingUpdate;
    private final WaitTimeBannerView waitTimeBannerView;
    private final Function1<WaitTimeBannerRendering, WaitTimeBannerRendering> waitTimeBannerViewRenderingUpdate;

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\b\u0005\b\u0082\u0081\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00000\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002j\u0002\b\u0003j\u0002\b\u0004j\u0002\b\u0005¨\u0006\u0006"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenView$ScreenState;", "", "(Ljava/lang/String;I)V", "DEFAULT", "LOADING", "RETRY", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private enum ScreenState {
        DEFAULT,
        LOADING,
        RETRY;

        private static final EnumEntries $ENTRIES = EnumEntriesKt.enumEntries(values());

        public static EnumEntries<ScreenState> getEntries() {
            return $ENTRIES;
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[ConversationScreenStatus.values().length];
            try {
                iArr[ConversationScreenStatus.SUCCESS.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[ConversationScreenStatus.FAILED.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public ConversationScreenView(Context context) {
        this(context, null, 0, 6, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ConversationScreenView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 4, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public final int composerVisibility(boolean isFormFocused) {
        return isFormFocused ? 8 : 0;
    }

    public ConversationScreenView(Context context, AttributeSet attributeSet, int i, int i2, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i2 & 2) != 0 ? null : attributeSet, (i2 & 4) != 0 ? 0 : i);
    }

    public ConversationScreenView(final Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new ConversationScreenRendering();
        this.conversationHeaderRenderingUpdate = new Function1<ConversationHeaderRendering, ConversationHeaderRendering>() {
            {
                super(1);
            }

            @Override
            public final ConversationHeaderRendering invoke(ConversationHeaderRendering conversationHeaderRendering) {
                Intrinsics.checkNotNullParameter(conversationHeaderRendering, "conversationHeaderRendering");
                ConversationHeaderRendering.Builder builder = conversationHeaderRendering.toBuilder();
                final ConversationScreenView conversationScreenView = this.this$0;
                return builder.state(new Function1<ConversationHeaderState, ConversationHeaderState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final ConversationHeaderState invoke(ConversationHeaderState state) {
                        Intrinsics.checkNotNullParameter(state, "state");
                        return state.copy(conversationScreenView.rendering.getState().getTitle(), conversationScreenView.rendering.getState().getDescription(), Uri.parse(conversationScreenView.rendering.getState().getToolbarImageUrl()), conversationScreenView.rendering.getState().getAccessibilityTitle(), Integer.valueOf(conversationScreenView.rendering.getState().getMessagingTheme().getPrimaryColor()), Integer.valueOf(conversationScreenView.rendering.getState().getMessagingTheme().getPrimaryColor()), Integer.valueOf(conversationScreenView.rendering.getState().getMessagingTheme().getOnPrimaryColor()), Integer.valueOf(conversationScreenView.rendering.getState().getMessagingTheme().getOnPrimaryColor()));
                    }
                }).onBackButtonClicked(this.this$0.rendering.getOnBackButtonClicked$zendesk_messaging_messaging_android()).build();
            }
        };
        this.connectionBannerRenderingUpdate = new Function1<ConnectionBannerRendering, ConnectionBannerRendering>() {
            {
                super(1);
            }

            @Override
            public final ConnectionBannerRendering invoke(ConnectionBannerRendering connectionBannerRendering) {
                Intrinsics.checkNotNullParameter(connectionBannerRendering, "connectionBannerRendering");
                ConnectionBannerRendering.Builder builderOnRetryClicked = connectionBannerRendering.toBuilder().onRetryClicked(this.this$0.rendering.getOnRetryConnectionClicked$zendesk_messaging_messaging_android());
                final ConversationScreenView conversationScreenView = this.this$0;
                return builderOnRetryClicked.state(new Function1<ConnectionBannerState, ConnectionBannerState>() {

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
                        ConnectionStatus connectionStatus = conversationScreenView.rendering.getState().getConnectionStatus();
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
                        return state.copy(connectionState, conversationScreenView.rendering.getState().getMessagingTheme().getBackgroundColor(), conversationScreenView.rendering.getState().getMessagingTheme().getOnBackgroundColor(), conversationScreenView.rendering.getState().getMessagingTheme().getSuccessColor());
                    }
                }).build();
            }
        };
        this.messageLogViewRenderingUpdate = new Function1<MessageLogRendering, MessageLogRendering>() {
            {
                super(1);
            }

            @Override
            public final MessageLogRendering invoke(MessageLogRendering messageLogRendering) {
                Intrinsics.checkNotNullParameter(messageLogRendering, "messageLogRendering");
                MessageLogRendering.Builder builder = messageLogRendering.toBuilder();
                final ConversationScreenView conversationScreenView = this.this$0;
                MessageLogRendering.Builder builderOnFormDisplayedFieldsChanged = builder.state(new Function1<MessageLogState, MessageLogState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final MessageLogState invoke(MessageLogState state) {
                        Intrinsics.checkNotNullParameter(state, "state");
                        List<MessageLogEntry> messageLog = conversationScreenView.rendering.getState().getMessageLog();
                        Map<String, DisplayedForm> mapOfDisplayedForms = conversationScreenView.rendering.getState().getMapOfDisplayedForms();
                        boolean shouldAnnounceMessage = conversationScreenView.rendering.getState().getShouldAnnounceMessage();
                        boolean shouldSeeLatestViewVisible = conversationScreenView.rendering.getState().getShouldSeeLatestViewVisible();
                        return state.copy(messageLog, conversationScreenView.rendering.getState().getScrollToTheBottom(), mapOfDisplayedForms, shouldAnnounceMessage, shouldSeeLatestViewVisible, conversationScreenView.rendering.getState().getShowPostbackErrorBanner(), conversationScreenView.rendering.getState().getPostbackErrorText(), conversationScreenView.rendering.getState().getMessagingTheme(), conversationScreenView.rendering.getState().getAuthorizationToken());
                    }
                }).onReplyActionSelected(this.this$0.rendering.getOnReplyActionSelected$zendesk_messaging_messaging_android()).onFailedMessageClicked(this.this$0.rendering.getOnFailedMessageClicked$zendesk_messaging_messaging_android()).onUriClicked(this.this$0.rendering.getOnUriClicked()).onWebViewUriClicked(this.this$0.rendering.getOnWebViewUriClicked()).onCarouselAction(this.this$0.rendering.getOnCarouselAction$zendesk_messaging_messaging_android()).onSendPostbackMessage(this.this$0.rendering.getOnSendPostbackMessage$zendesk_messaging_messaging_android()).onCopyText(this.this$0.rendering.getOnCopyText$zendesk_messaging_messaging_android()).onFormCompleted(this.this$0.rendering.getOnFormCompleted$zendesk_messaging_messaging_android()).onFormFocusChanged(this.this$0.rendering.getOnFormFocusChanged$zendesk_messaging_messaging_android()).onFormDisplayedFieldsChanged(this.this$0.rendering.m232xd959c585());
                final ConversationScreenView conversationScreenView2 = this.this$0;
                MessageLogRendering.Builder builderOnLoadMoreListener = builderOnFormDisplayedFieldsChanged.onLoadMoreListener(new Function1<Boolean, Unit>() {
                    {
                        super(1);
                    }

                    @Override
                    public Unit invoke(Boolean bool) {
                        invoke(bool.booleanValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(boolean z) {
                        Conversation conversation = conversationScreenView2.rendering.getState().getConversation();
                        if (conversation != null) {
                            ConversationScreenView conversationScreenView3 = conversationScreenView2;
                            if (z) {
                                conversationScreenView3.loadMoreMessages(conversation);
                            }
                        }
                    }
                });
                final ConversationScreenView conversationScreenView3 = this.this$0;
                return builderOnLoadMoreListener.onRetryLoadMoreClickedListener(new Function0<Unit>() {
                    {
                        super(0);
                    }

                    @Override
                    public Unit invoke() {
                        invoke2();
                        return Unit.INSTANCE;
                    }

                    public final void invoke2() {
                        Conversation conversation = conversationScreenView3.rendering.getState().getConversation();
                        if (conversation != null) {
                            ConversationScreenView conversationScreenView4 = conversationScreenView3;
                            if (conversation.getMessages().size() >= 100) {
                                conversationScreenView4.loadMoreMessages(conversation);
                            }
                        }
                    }
                }).onSeeLatestClickedListener(this.this$0.rendering.m237xa05399e8()).onFileAttachmentClicked(this.this$0.rendering.getOnFileAttachmentClicked$zendesk_messaging_messaging_android()).build();
            }
        };
        this.messageComposerRenderingUpdate = new Function1<MessageComposerRendering, MessageComposerRendering>() {
            {
                super(1);
            }

            @Override
            public final MessageComposerRendering invoke(MessageComposerRendering messageComposerRendering) {
                Intrinsics.checkNotNullParameter(messageComposerRendering, "messageComposerRendering");
                MessageComposerRendering.Builder builderOnTextChanged = messageComposerRendering.toBuilder().onSendButtonClicked(this.this$0.rendering.getOnSendButtonClicked$zendesk_messaging_messaging_android()).onAttachButtonClicked(this.this$0.rendering.getOnAttachButtonClicked$zendesk_messaging_messaging_android()).onTyping(this.this$0.rendering.getOnTyping$zendesk_messaging_messaging_android()).onTextChanged(this.this$0.rendering.m233x6e5dfc47());
                final ConversationScreenView conversationScreenView = this.this$0;
                return builderOnTextChanged.state(new Function1<MessageComposerState, MessageComposerState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final MessageComposerState invoke(MessageComposerState state) {
                        Intrinsics.checkNotNullParameter(state, "state");
                        int onActionBackgroundColor = conversationScreenView.rendering.getState().getMessagingTheme().getOnActionBackgroundColor();
                        int onBackgroundColor = conversationScreenView.rendering.getState().getMessagingTheme().getOnBackgroundColor();
                        int onBackgroundColor2 = conversationScreenView.rendering.getState().getMessagingTheme().getOnBackgroundColor();
                        int onBackgroundColor3 = conversationScreenView.rendering.getState().getMessagingTheme().getOnBackgroundColor();
                        boolean z = !conversationScreenView.rendering.getState().getBlockChatInput();
                        boolean zIsAttachmentsEnabled = conversationScreenView.rendering.getState().isAttachmentsEnabled();
                        boolean gallerySupported = conversationScreenView.rendering.getState().getGallerySupported();
                        boolean cameraSupported = conversationScreenView.rendering.getState().getCameraSupported();
                        ConversationScreenView conversationScreenView2 = conversationScreenView;
                        return state.copy(z, cameraSupported, gallerySupported, zIsAttachmentsEnabled, conversationScreenView2.composerVisibility(conversationScreenView2.rendering.getState().isFormFocused()), 4096, onActionBackgroundColor, onBackgroundColor, onBackgroundColor2, onBackgroundColor3, conversationScreenView.rendering.getState().getComposerText());
                    }
                }).build();
            }
        };
        this.deniedPermissionBottomSheetRenderingUpdate = new Function1<BottomSheetRendering, BottomSheetRendering>() {
            {
                super(1);
            }

            @Override
            public final BottomSheetRendering invoke(BottomSheetRendering bottomSheetRendering) {
                Intrinsics.checkNotNullParameter(bottomSheetRendering, "bottomSheetRendering");
                BottomSheetRendering.Builder builderOnBottomSheetDismissed = bottomSheetRendering.toBuilder().onBottomSheetActionClicked(this.this$0.rendering.m230x4b440ba4()).onBottomSheetDismissed(this.this$0.rendering.m231x4982bbc());
                final Context context2 = context;
                final ConversationScreenView conversationScreenView = this.this$0;
                return builderOnBottomSheetDismissed.state(new Function1<BottomSheetState, BottomSheetState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final BottomSheetState invoke(BottomSheetState state) {
                        Intrinsics.checkNotNullParameter(state, "state");
                        String string = context2.getString(C1256R.string.zuia_attachment_permissions_rationale);
                        String string2 = context2.getString(C1256R.string.zuia_settings);
                        int color = ContextCompat.getColor(context2, C1256R.color.zma_color_bottom_sheet_background);
                        int color2 = ContextCompat.getColor(context2, C1256R.color.zma_color_bottom_sheet_error_text);
                        int color3 = ContextCompat.getColor(context2, C1256R.color.zma_color_bottom_sheet_action_text);
                        boolean showDeniedPermission = conversationScreenView.rendering.getState().getShowDeniedPermission();
                        Intrinsics.checkNotNull(string);
                        Intrinsics.checkNotNull(string2);
                        return BottomSheetState.copy$default(state, string, string2, 0L, showDeniedPermission, Integer.valueOf(color), Integer.valueOf(color2), Integer.valueOf(color3), 4, null);
                    }
                }).build();
            }
        };
        this.loadingIndicatorRenderingUpdate = new Function1<LoadingIndicatorRendering, LoadingIndicatorRendering>() {
            {
                super(1);
            }

            @Override
            public final LoadingIndicatorRendering invoke(LoadingIndicatorRendering loadingRendering) {
                Intrinsics.checkNotNullParameter(loadingRendering, "loadingRendering");
                final ConversationScreenStatus status = this.this$0.rendering.getState().getStatus();
                LoadingIndicatorRendering.Builder builder = loadingRendering.toBuilder();
                final ConversationScreenView conversationScreenView = this.this$0;
                return builder.state(new Function1<LoadingIndicatorState, LoadingIndicatorState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final LoadingIndicatorState invoke(LoadingIndicatorState state) {
                        Intrinsics.checkNotNullParameter(state, "state");
                        return state.copy(status == ConversationScreenStatus.LOADING, conversationScreenView.rendering.getState().getMessagingTheme().getPrimaryColor());
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
                final String string = context.getString(R.string.zuia_load_more_messages_failed_to_load);
                Intrinsics.checkNotNullExpressionValue(string, "getString(...)");
                RetryErrorRendering.Builder builder = retryErrorRendering.toBuilder();
                final ConversationScreenView conversationScreenView = this;
                final Context context2 = context;
                RetryErrorRendering.Builder builderState = builder.state(new Function1<RetryErrorState, RetryErrorState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final RetryErrorState invoke(RetryErrorState state) {
                        Intrinsics.checkNotNullParameter(state, "state");
                        int onBackgroundColor = conversationScreenView.rendering.getState().getMessagingTheme().getOnBackgroundColor();
                        String string2 = context2.getString(C1256R.string.zuia_conversation_message_label_tap_to_retry);
                        int onBackgroundColor2 = conversationScreenView.rendering.getState().getMessagingTheme().getOnBackgroundColor();
                        String str = string;
                        Intrinsics.checkNotNull(string2);
                        return state.copy(str, onBackgroundColor2, string2, onBackgroundColor);
                    }
                });
                final ConversationScreenView conversationScreenView2 = this;
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
                        conversationScreenView2.rendering.m235x819e779d().invoke();
                    }
                }).build();
            }
        };
        this.postbackFailureBannerRenderingUpdate = new Function1<ButtonBannerRendering, ButtonBannerRendering>() {
            {
                super(1);
            }

            @Override
            public final ButtonBannerRendering invoke(ButtonBannerRendering buttonBannerRendering) {
                Intrinsics.checkNotNullParameter(buttonBannerRendering, "buttonBannerRendering");
                String string = context.getString(C1256R.string.zuia_postback_error_banner_message, "<b>" + this.this$0.rendering.getState().getPostbackErrorText() + "</b>");
                Intrinsics.checkNotNullExpressionValue(string, "getString(...)");
                final Spanned spannedFromHtml = HtmlCompat.fromHtml(string, 63);
                Intrinsics.checkNotNullExpressionValue(spannedFromHtml, "fromHtml(...)");
                ButtonBannerRendering.Builder builder = buttonBannerRendering.toBuilder();
                final ConversationScreenView conversationScreenView = this.this$0;
                ButtonBannerRendering.Builder builderState = builder.state(new Function1<ButtonBannerState, ButtonBannerState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final ButtonBannerState invoke(ButtonBannerState state) {
                        Intrinsics.checkNotNullParameter(state, "state");
                        ButtonBannerViewType buttonBannerViewType = ButtonBannerViewType.FAILED_BANNER;
                        boolean showPostbackErrorBanner = conversationScreenView.rendering.getState().getShowPostbackErrorBanner();
                        int dangerColor = conversationScreenView.rendering.getState().getMessagingTheme().getDangerColor();
                        int onDangerColor = conversationScreenView.rendering.getState().getMessagingTheme().getOnDangerColor();
                        int onDangerColor2 = conversationScreenView.rendering.getState().getMessagingTheme().getOnDangerColor();
                        return ButtonBannerState.copy$default(state, buttonBannerViewType, (String) null, Boolean.valueOf(showPostbackErrorBanner), Integer.valueOf(onDangerColor), (Integer) null, Integer.valueOf(dangerColor), Integer.valueOf(onDangerColor2), spannedFromHtml, conversationScreenView.rendering.getState().getShowPostbackErrorBanner(), 18, (Object) null);
                    }
                });
                final ConversationScreenView conversationScreenView2 = this.this$0;
                return builderState.onViewDismissed(new Function0<Unit>() {
                    {
                        super(0);
                    }

                    @Override
                    public Unit invoke() {
                        invoke2();
                        return Unit.INSTANCE;
                    }

                    public final void invoke2() {
                        conversationScreenView2.rendering.m234x4c8a1eb6().invoke();
                    }
                }).build();
            }
        };
        this.waitTimeBannerViewRenderingUpdate = new Function1<WaitTimeBannerRendering, WaitTimeBannerRendering>() {
            {
                super(1);
            }

            @Override
            public final WaitTimeBannerRendering invoke(WaitTimeBannerRendering waitTimeBannerRendering) {
                Intrinsics.checkNotNullParameter(waitTimeBannerRendering, "waitTimeBannerRendering");
                WaitTimeBannerRendering.Builder builder = waitTimeBannerRendering.toBuilder();
                final ConversationScreenView conversationScreenView = this.this$0;
                return builder.state(new Function1<WaitTimeBannerState, WaitTimeBannerState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final WaitTimeBannerState invoke(WaitTimeBannerState state) {
                        Intrinsics.checkNotNullParameter(state, "state");
                        return state.copy(conversationScreenView.rendering.getState().getWaitTimeBannerType(), conversationScreenView.rendering.getState().getMessagingTheme().getOnBackgroundColor(), conversationScreenView.rendering.getState().getMessagingTheme().getOnActionBackgroundColor());
                    }
                }).build();
            }
        };
        RelativeLayout.inflate(context, C1256R.layout.zma_view_conversation, this);
        View viewFindViewById = findViewById(C1256R.id.zma_conversation_header_view);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
        this.conversationHeaderView = (ConversationHeaderView) viewFindViewById;
        Object objFindViewById = findViewById(C1256R.id.zma_message_list);
        Intrinsics.checkNotNullExpressionValue(objFindViewById, "findViewById(...)");
        this.messageLogView = (MessageLogView) objFindViewById;
        View viewFindViewById2 = findViewById(C1256R.id.zma_message_composer_view);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById2, "findViewById(...)");
        this.messageComposerView = (MessageComposerView) viewFindViewById2;
        View viewFindViewById3 = findViewById(C1256R.id.zma_wait_time_banner_view);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById3, "findViewById(...)");
        this.waitTimeBannerView = (WaitTimeBannerView) viewFindViewById3;
        ConnectionBannerView connectionBannerViewFindViewById = findViewById(C1256R.id.zma_connection_banner_view);
        Intrinsics.checkNotNullExpressionValue(connectionBannerViewFindViewById, "findViewById(...)");
        ConnectionBannerView connectionBannerView = connectionBannerViewFindViewById;
        this.connectionBannerView = connectionBannerView;
        this.deniedPermissionBottomSheetView = new BottomSheetView(context);
        View viewFindViewById4 = findViewById(C1256R.id.zma_loading_indicator_view);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById4, "findViewById(...)");
        this.loadingIndicatorView = (LoadingIndicatorView) viewFindViewById4;
        RetryErrorView retryErrorViewFindViewById = findViewById(C1256R.id.zma_retry_error_view);
        Intrinsics.checkNotNullExpressionValue(retryErrorViewFindViewById, "findViewById(...)");
        this.retryErrorView = retryErrorViewFindViewById;
        ButtonBannerView buttonBannerViewFindViewById = findViewById(C1256R.id.zma_postback_failure_banner);
        Intrinsics.checkNotNullExpressionValue(buttonBannerViewFindViewById, "findViewById(...)");
        ButtonBannerView buttonBannerView = buttonBannerViewFindViewById;
        this.postbackBannerView = buttonBannerView;
        connectionBannerView.bringToFront();
        buttonBannerView.bringToFront();
        render(new Function1<ConversationScreenRendering, ConversationScreenRendering>() {
            @Override
            public final ConversationScreenRendering invoke(ConversationScreenRendering it) {
                Intrinsics.checkNotNullParameter(it, "it");
                return it;
            }
        });
    }

    public void render(Function1<? super ConversationScreenRendering, ConversationScreenRendering> renderingUpdate) {
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        this.rendering = renderingUpdate.invoke(this.rendering);
        Logger.m221i(LOG_TAG, "Updating the Conversation Screen with " + this.rendering.getState(), new Object[0]);
        int i = WhenMappings.$EnumSwitchMapping$0[this.rendering.getState().getStatus().ordinal()];
        if (i == 1) {
            setState(ScreenState.DEFAULT);
        } else if (i == 2) {
            setState(ScreenState.RETRY);
        } else {
            setState(ScreenState.LOADING);
        }
        setBackgroundColor(this.rendering.getState().getMessagingTheme().getBackgroundColor());
        this.conversationHeaderView.render(this.conversationHeaderRenderingUpdate);
        this.connectionBannerView.render(this.connectionBannerRenderingUpdate);
        this.messageLogView.render(this.messageLogViewRenderingUpdate);
        this.messageComposerView.render(this.messageComposerRenderingUpdate);
        renderWaitTimeBanner(this.rendering.getState().getWaitTimeBannerType(), this.rendering.getState().isFormFocused());
        this.deniedPermissionBottomSheetView.render(this.deniedPermissionBottomSheetRenderingUpdate);
        this.loadingIndicatorView.render(this.loadingIndicatorRenderingUpdate);
        if (this.retryErrorView.getVisibility() == 0) {
            this.retryErrorView.render(this.retryErrorViewRenderingUpdate);
        }
        this.postbackBannerView.render(this.postbackFailureBannerRenderingUpdate);
        applyWindowInsetsToScreenContent();
    }

    private final void setState(ScreenState state) {
        ((View) this.messageLogView).setVisibility(state == ScreenState.DEFAULT ? 0 : 8);
        this.loadingIndicatorView.setVisibility(state == ScreenState.LOADING ? 0 : 8);
        this.retryErrorView.setVisibility(state == ScreenState.RETRY ? 0 : 8);
    }

    private final void applyWindowInsetsToScreenContent() {
        SystemWindowInsetsKt.applyWindowInsets(this, InsetType.BOTTOM);
        SystemWindowInsetsKt.applyWindowInsets(this.connectionBannerView, InsetType.HORIZONTAL);
        SystemWindowInsetsKt.applyWindowInsets((View) this.messageLogView, InsetType.HORIZONTAL);
        SystemWindowInsetsKt.applyWindowInsets(this.messageComposerView, InsetType.HORIZONTAL);
        SystemWindowInsetsKt.applyWindowInsets(this.loadingIndicatorView, InsetType.HORIZONTAL);
        SystemWindowInsetsKt.applyWindowInsets(this.retryErrorView, InsetType.HORIZONTAL);
        SystemWindowInsetsKt.applyWindowInsets(this.postbackBannerView, InsetType.HORIZONTAL);
        SystemWindowInsetsKt.applyWindowInsets(this.waitTimeBannerView, InsetType.HORIZONTAL);
    }

    public final void loadMoreMessages(Conversation conversation) {
        this.rendering.getOnLoadMoreMessages$zendesk_messaging_messaging_android().invoke(Double.valueOf(((Message) CollectionsKt.first((List) conversation.getMessages())).getBeforeTimestamp()));
    }

    private final void renderWaitTimeBanner(WaitTimeBannerType waitTimeBannerType, boolean isFormFocused) {
        if (!isFormFocused) {
            if (waitTimeBannerType instanceof WaitTimeBannerType.Queued ? true : Intrinsics.areEqual(waitTimeBannerType, WaitTimeBannerType.Assigned.INSTANCE)) {
                this.waitTimeBannerView.render(this.waitTimeBannerViewRenderingUpdate);
                this.waitTimeBannerView.setVisibility(0);
                return;
            } else {
                if (waitTimeBannerType instanceof WaitTimeBannerType.Cleared) {
                    this.waitTimeBannerView.setVisibility(8);
                    return;
                }
                return;
            }
        }
        this.waitTimeBannerView.setVisibility(8);
    }

    @Metadata(m17d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\b"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenView$Companion;", "", "()V", "COMPOSER_MAX_LENGTH", "", "LOG_TAG", "", "MAX_CONVERSATION_LIST_NUM", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
