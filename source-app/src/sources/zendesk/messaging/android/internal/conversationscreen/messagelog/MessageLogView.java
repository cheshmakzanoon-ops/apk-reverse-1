package zendesk.messaging.android.internal.conversationscreen.messagelog;

import android.content.Context;
import android.text.Spanned;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.EdgeEffect;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.LinearSmoothScroller;
import androidx.recyclerview.widget.RecyclerView;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import net.aihelp.p007ui.webkit.AIHelpWebProgress;
import zendesk.core.p017ui.android.internal.model.MessageDirection;
import zendesk.messaging.C1256R;
import zendesk.messaging.android.internal.conversationscreen.MessageListAdapter;
import zendesk.messaging.android.internal.model.MessageLogEntry;
import zendesk.messaging.android.internal.model.MessageLogType;
import zendesk.p026ui.android.internal.ViewKt;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;
import zendesk.ui.android.common.buttonbanner.ButtonBannerRendering;
import zendesk.ui.android.common.buttonbanner.ButtonBannerState;
import zendesk.ui.android.common.buttonbanner.ButtonBannerView;
import zendesk.ui.android.common.buttonbanner.ButtonBannerViewType;

@Metadata(m17d1 = {"\u0000r\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0005\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0000\u0018\u0000 42\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002:\u00014B/\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\t¢\u0006\u0002\u0010\u000bJ\b\u0010\u001c\u001a\u00020\u001dH\u0002J\u001a\u0010\u001e\u001a\u00020\u001d2\b\u0010\u001f\u001a\u0004\u0018\u00010\u00122\u0006\u0010 \u001a\u00020\tH\u0002J\u0016\u0010!\u001a\u00020\t2\f\u0010\"\u001a\b\u0012\u0004\u0012\u00020$0#H\u0002J\b\u0010%\u001a\u00020\u001dH\u0002J\u001f\u0010&\u001a\u00020\u000f2\b\u0010'\u001a\u0004\u0018\u00010\t2\u0006\u0010(\u001a\u00020\tH\u0002¢\u0006\u0002\u0010)J\u001c\u0010*\u001a\u00020\u001d2\u0012\u0010+\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030,H\u0016J\u001a\u0010-\u001a\u00020\u001d2\b\u0010\u001f\u001a\u0004\u0018\u00010\u00122\u0006\u0010(\u001a\u00020\tH\u0002J\u0016\u0010.\u001a\u00020\u001d2\f\u0010\"\u001a\b\u0012\u0004\u0012\u00020$0#H\u0002J\u0016\u0010/\u001a\u00020\u001d2\f\u0010\"\u001a\b\u0012\u0004\u0012\u00020$0#H\u0002J\u0012\u00100\u001a\u00020\u001d2\b\u00101\u001a\u0004\u0018\u000102H\u0002J\f\u00103\u001a\u00020\u001d*\u00020\u0018H\u0002R\u000e\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u000fX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0010\u001a\u00020\u000fX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0011\u001a\u00020\u0012X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0013\u001a\u00020\u0014X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0015\u001a\u00020\u0016X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0017\u001a\u00020\u0018X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0019\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u001a\u001a\u00020\u0016X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u001b\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000¨\u00065"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/messagelog/MessageLogView;", "Landroidx/constraintlayout/widget/ConstraintLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/MessageLogRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "defStyleRes", "(Landroid/content/Context;Landroid/util/AttributeSet;II)V", "firstUnreadMessagePosition", "Ljava/util/concurrent/atomic/AtomicInteger;", "isFormFocused", "", "isNewMessagesClicked", "layoutManager", "Landroidx/recyclerview/widget/LinearLayoutManager;", "messageListAdapter", "Lzendesk/messaging/android/internal/conversationscreen/MessageListAdapter;", "newMessagesView", "Lzendesk/ui/android/common/buttonbanner/ButtonBannerView;", "recyclerView", "Landroidx/recyclerview/widget/RecyclerView;", "rendering", "seeLatestView", "verticalScrollOffset", "announceNewMessageContentForAccessibility", "", "fastSmoothScrollToBottom", "linearLayoutManager", "messagePosition", "getNewMessagesDividerPosition", "messageList", "", "Lzendesk/messaging/android/internal/model/MessageLogEntry;", "hideSeeLatestView", "isQuickReplyAtBottomOfList", "lastVisibleItemPosition", "lastMessagePosition", "(Ljava/lang/Integer;I)Z", "render", "renderingUpdate", "Lkotlin/Function1;", "scrollToBottom", "showNewMessagesViewIfNeeded", "showSeeLatestViewIfNeeded", "updateScrollingBehaviourOnFocusChange", "newFocus", "Landroid/view/View;", "onScrollToBottomIfKeyboardShown", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessageLogView extends ConstraintLayout implements Renderer<MessageLogRendering> {
    private static final Companion Companion = new Companion(null);

    @Deprecated
    public static final int MAXIMUM_MESSAGES_NUMBER = 100;

    @Deprecated
    public static final long NEW_CONTENT_CHANGE_ACCESSIBILITY_EVENT_DELAY = 1500;

    @Deprecated
    public static final long NEW_MESSAGE_VIEW_DELAY = 1500;

    @Deprecated
    public static final int NO_UNREAD_MESSAGES_EXIST = -1;

    @Deprecated
    public static final int OFFSET_WITH_EMPTY_MESSAGE = 2;

    @Deprecated
    public static final int OFFSET_WITH_NONEMPTY_MESSAGE = 1;

    @Deprecated
    public static final int OFFSET_WITH_REGULAR_MESSAGE = 1;

    @Deprecated
    public static final int ONE_HUNDRED_OR_MORE_UNREAD_MESSAGES = 0;

    @Deprecated
    public static final String TAG = "MessageLogView";
    private final AtomicInteger firstUnreadMessagePosition;
    private boolean isFormFocused;
    private boolean isNewMessagesClicked;
    private LinearLayoutManager layoutManager;
    private final MessageListAdapter messageListAdapter;
    private final ButtonBannerView newMessagesView;
    private final RecyclerView recyclerView;
    private MessageLogRendering rendering;
    private final ButtonBannerView seeLatestView;
    private final AtomicInteger verticalScrollOffset;

    public MessageLogView(Context context) {
        this(context, null, 0, 0, 14, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public MessageLogView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 0, 12, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public MessageLogView(Context context, AttributeSet attributeSet, int i) {
        this(context, attributeSet, i, 0, 8, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public MessageLogView(Context context, AttributeSet attributeSet, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i3 & 2) != 0 ? null : attributeSet, (i3 & 4) != 0 ? 0 : i, (i3 & 8) != 0 ? 0 : i2);
    }

    public MessageLogView(Context context, AttributeSet attributeSet, int i, int i2) {
        super(context, attributeSet, i, i2);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new MessageLogRendering();
        this.layoutManager = new LinearLayoutManager(context, 1, false);
        this.verticalScrollOffset = new AtomicInteger(0);
        this.firstUnreadMessagePosition = new AtomicInteger(0);
        ConstraintLayout.inflate(context, C1256R.layout.zma_view_message_log, (ViewGroup) this);
        RecyclerView recyclerViewFindViewById = findViewById(C1256R.id.zma_message_list_recycler_view);
        Intrinsics.checkNotNullExpressionValue(recyclerViewFindViewById, "findViewById(...)");
        RecyclerView recyclerView = recyclerViewFindViewById;
        this.recyclerView = recyclerView;
        ButtonBannerView buttonBannerViewFindViewById = findViewById(C1256R.id.zma_message_list_new_messages_view);
        Intrinsics.checkNotNullExpressionValue(buttonBannerViewFindViewById, "findViewById(...)");
        this.newMessagesView = buttonBannerViewFindViewById;
        ButtonBannerView buttonBannerViewFindViewById2 = findViewById(C1256R.id.zma_message_list_see_latest_view);
        Intrinsics.checkNotNullExpressionValue(buttonBannerViewFindViewById2, "findViewById(...)");
        this.seeLatestView = buttonBannerViewFindViewById2;
        RecyclerView.Adapter messageListAdapter = new MessageListAdapter(null, null, null, null, null, null, null, null, null, 511, null);
        this.messageListAdapter = messageListAdapter;
        recyclerView.setAdapter(messageListAdapter);
        recyclerView.setLayoutManager(this.layoutManager);
        messageListAdapter.setStateRestorationPolicy(RecyclerView.Adapter.StateRestorationPolicy.PREVENT_WHEN_EMPTY);
        recyclerView.addOnLayoutChangeListener(new View.OnLayoutChangeListener() {
            @Override
            public final void onLayoutChange(View view, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10) {
                MessageLogView._init_$lambda$0(this.f$0, view, i3, i4, i5, i6, i7, i8, i9, i10);
            }
        });
        recyclerView.addOnScrollListener(new RecyclerView.OnScrollListener() {
            private AtomicInteger state = new AtomicInteger(0);

            public final AtomicInteger getState() {
                return this.state;
            }

            public final void setState(AtomicInteger atomicInteger) {
                Intrinsics.checkNotNullParameter(atomicInteger, "<set-?>");
                this.state = atomicInteger;
            }

            public void onScrollStateChanged(RecyclerView recyclerView2, int newState) {
                Intrinsics.checkNotNullParameter(recyclerView2, "recyclerView");
                this.state.compareAndSet(0, newState);
                if (newState == 0) {
                    if (this.state.compareAndSet(2, newState)) {
                        return;
                    }
                    this.state.compareAndSet(1, newState);
                } else if (newState == 1) {
                    this.state.compareAndSet(0, newState);
                } else {
                    if (newState != 2) {
                        return;
                    }
                    this.state.compareAndSet(1, newState);
                }
            }

            public void onScrolled(RecyclerView recyclerView2, int dx, int dy) {
                Intrinsics.checkNotNullParameter(recyclerView2, "recyclerView");
                if (this.state.get() != 0) {
                    MessageLogView.this.verticalScrollOffset.getAndAdd(dy);
                    MessageLogView.this.rendering.getOnLoadMoreListener$zendesk_messaging_messaging_android().invoke(Boolean.valueOf(MessageLogView.this.layoutManager.findFirstCompletelyVisibleItemPosition() == 0));
                    MessageLogView.this.hideSeeLatestView();
                    if (MessageLogView.this.firstUnreadMessagePosition.get() == MessageLogView.this.layoutManager.findFirstVisibleItemPosition() && MessageLogView.this.newMessagesView.getVisibility() == 0) {
                        ButtonBannerView buttonBannerView = MessageLogView.this.newMessagesView;
                        final MessageLogView messageLogView = MessageLogView.this;
                        buttonBannerView.render(new Function1<ButtonBannerRendering, ButtonBannerRendering>() {
                            {
                                super(1);
                            }

                            @Override
                            public final ButtonBannerRendering invoke(ButtonBannerRendering unreadMessagesRendering) {
                                Intrinsics.checkNotNullParameter(unreadMessagesRendering, "unreadMessagesRendering");
                                ButtonBannerRendering.Builder builder = unreadMessagesRendering.toBuilder();
                                final MessageLogView messageLogView2 = messageLogView;
                                return builder.state(new Function1<ButtonBannerState, ButtonBannerState>() {
                                    {
                                        super(1);
                                    }

                                    @Override
                                    public final ButtonBannerState invoke(ButtonBannerState unreadMessagesState) {
                                        Intrinsics.checkNotNullParameter(unreadMessagesState, "unreadMessagesState");
                                        return ButtonBannerState.copy$default(unreadMessagesState, ButtonBannerViewType.NEW_MESSAGES, (String) null, false, Integer.valueOf(messageLogView2.rendering.getState().getMessagingTheme$zendesk_messaging_messaging_android().getOnBackgroundColor()), Integer.valueOf(messageLogView2.rendering.getState().getMessagingTheme$zendesk_messaging_messaging_android().getOnBackgroundColor()), Integer.valueOf(messageLogView2.rendering.getState().getMessagingTheme$zendesk_messaging_messaging_android().getElevatedColor()), (Integer) null, (Spanned) null, false, AIHelpWebProgress.MAX_DECELERATE_SPEED_DURATION, (Object) null);
                                    }
                                }).build();
                            }
                        });
                        MessageLogView.this.isNewMessagesClicked = true;
                    }
                }
            }
        });
        recyclerView.getViewTreeObserver().addOnGlobalFocusChangeListener(new ViewTreeObserver.OnGlobalFocusChangeListener() {
            @Override
            public final void onGlobalFocusChanged(View view, View view2) {
                MessageLogView._init_$lambda$1(this.f$0, view, view2);
            }
        });
        render(new Function1<MessageLogRendering, MessageLogRendering>() {
            @Override
            public final MessageLogRendering invoke(MessageLogRendering it) {
                Intrinsics.checkNotNullParameter(it, "it");
                return it;
            }
        });
    }

    public static final void _init_$lambda$0(MessageLogView this$0, View view, int i, int i2, int i3, int i4, int i5, int i6, int i7, int i8) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        if (this$0.isFormFocused) {
            return;
        }
        int i9 = i8 - i4;
        if (Math.abs(i9) > 0) {
            if (i9 > 0 || Math.abs(this$0.verticalScrollOffset.get()) >= Math.abs(i9)) {
                this$0.recyclerView.scrollBy(0, Math.abs(i9));
            } else {
                this$0.recyclerView.scrollBy(0, this$0.verticalScrollOffset.get());
            }
        }
    }

    public static final void _init_$lambda$1(MessageLogView this$0, View view, View view2) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        this$0.updateScrollingBehaviourOnFocusChange(view2);
    }

    public void render(Function1<? super MessageLogRendering, MessageLogRendering> renderingUpdate) {
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        MessageLogState state = this.rendering.getState();
        MessageLogRendering messageLogRenderingInvoke = renderingUpdate.invoke(this.rendering);
        this.rendering = messageLogRenderingInvoke;
        MessageLogState state2 = messageLogRenderingInvoke.getState();
        this.recyclerView.setEdgeEffectFactory(new RecyclerView.EdgeEffectFactory() {
            protected EdgeEffect createEdgeEffect(RecyclerView view, int direction) {
                Intrinsics.checkNotNullParameter(view, "view");
                EdgeEffect edgeEffect = new EdgeEffect(view.getContext());
                edgeEffect.setColor(MessageLogView.this.rendering.getState().getMessagingTheme$zendesk_messaging_messaging_android().getMessageColor());
                return edgeEffect;
            }
        });
        MessageListAdapter messageListAdapter = this.messageListAdapter;
        messageListAdapter.setOnReplyActionSelected(this.rendering.getOnReplyActionSelected$zendesk_messaging_messaging_android());
        messageListAdapter.setOnFailedMessageClicked(this.rendering.getOnFailedMessageClicked$zendesk_messaging_messaging_android());
        messageListAdapter.setOnUriClicked(this.rendering.getOnUriClicked());
        messageListAdapter.setOnWebViewUriClicked(this.rendering.getOnWebViewUriClicked());
        messageListAdapter.setOnFormCompleted(this.rendering.getOnFormCompleted$zendesk_messaging_messaging_android());
        messageListAdapter.setOnCarouselAction(this.rendering.getOnCarouselAction$zendesk_messaging_messaging_android());
        messageListAdapter.setOnFormFocusChanged(this.rendering.getOnFormFocusChanged$zendesk_messaging_messaging_android());
        messageListAdapter.setMapOfDisplayedFields(this.rendering.getState().getMapOfDisplayedFields$zendesk_messaging_messaging_android());
        messageListAdapter.setOnFormDisplayedFieldsChanged(this.rendering.m259xd959c585());
        messageListAdapter.setOnLoadMoreRetryClicked(this.rendering.m260xf184e65f());
        messageListAdapter.setOnSendPostbackMessage(this.rendering.getOnSendPostbackMessage$zendesk_messaging_messaging_android());
        messageListAdapter.setOnCopyText(this.rendering.getOnCopyText$zendesk_messaging_messaging_android());
        messageListAdapter.setMessagingTheme(this.rendering.getState().getMessagingTheme$zendesk_messaging_messaging_android());
        messageListAdapter.setOnFileAttachmentClicked(this.rendering.getOnFileAttachmentClicked$zendesk_messaging_messaging_android());
        if (Intrinsics.areEqual(state.getMessageLogEntryList$zendesk_messaging_messaging_android(), state2.getMessageLogEntryList$zendesk_messaging_messaging_android()) || state2.getMessageLogEntryList$zendesk_messaging_messaging_android().isEmpty()) {
            return;
        }
        messageListAdapter.submitList(this.rendering.getState().getMessageLogEntryList$zendesk_messaging_messaging_android(), new Runnable() {
            @Override
            public final void run() {
                MessageLogView.render$lambda$5$lambda$4(this.f$0);
            }
        });
    }

    public static final void render$lambda$5$lambda$4(final MessageLogView this$0) {
        boolean zIsQuickReplyAtBottomOfList;
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        int size = this$0.rendering.getState().getMessageLogEntryList$zendesk_messaging_messaging_android().size();
        int i = size - 1;
        MessageLogEntry messageLogEntry = (MessageLogEntry) CollectionsKt.lastOrNull((List) this$0.rendering.getState().getMessageLogEntryList$zendesk_messaging_messaging_android());
        int i2 = size - 2;
        MessageLogEntry messageLogEntry2 = (MessageLogEntry) CollectionsKt.getOrNull(this$0.rendering.getState().getMessageLogEntryList$zendesk_messaging_messaging_android(), i2);
        RecyclerView.LayoutManager layoutManager = this$0.recyclerView.getLayoutManager();
        LinearLayoutManager linearLayoutManager = layoutManager instanceof LinearLayoutManager ? (LinearLayoutManager) layoutManager : null;
        Integer numValueOf = linearLayoutManager != null ? Integer.valueOf(linearLayoutManager.findLastVisibleItemPosition()) : null;
        if ((messageLogEntry instanceof MessageLogEntry.QuickReply) && (messageLogEntry2 instanceof MessageLogEntry.TextMessageContainer)) {
            zIsQuickReplyAtBottomOfList = this$0.isQuickReplyAtBottomOfList(numValueOf, i);
        } else {
            zIsQuickReplyAtBottomOfList = numValueOf != null && numValueOf.intValue() == i2;
        }
        if (zIsQuickReplyAtBottomOfList || this$0.rendering.getState().getShouldScrollToBottom$zendesk_messaging_messaging_android()) {
            this$0.scrollToBottom(linearLayoutManager, i);
            View view = this$0.recyclerView;
            if (view.isLaidOut() && !view.isLayoutRequested()) {
                if (!this$0.rendering.getState().getMessageLogEntryList$zendesk_messaging_messaging_android().isEmpty()) {
                    this$0.recyclerView.postDelayed(new MessageLogView$render$2$1$1$1(this$0), 1500L);
                }
            } else {
                view.addOnLayoutChangeListener(new View.OnLayoutChangeListener() {
                    @Override
                    public void onLayoutChange(View view2, int left, int top, int right, int bottom, int oldLeft, int oldTop, int oldRight, int oldBottom) {
                        view2.removeOnLayoutChangeListener(this);
                        if (this.this$0.rendering.getState().getMessageLogEntryList$zendesk_messaging_messaging_android().isEmpty()) {
                            return;
                        }
                        this.this$0.recyclerView.postDelayed(new MessageLogView$render$2$1$1$1(this.this$0), 1500L);
                    }
                });
            }
        } else {
            View view2 = this$0.recyclerView;
            if (view2.isLaidOut() && !view2.isLayoutRequested()) {
                if (this$0.rendering.getState().m268xbd7bc74e() && !this$0.rendering.getState().getMessageLogEntryList$zendesk_messaging_messaging_android().isEmpty()) {
                    this$0.recyclerView.postDelayed(new MessageLogView$render$2$1$2$1(this$0), 1500L);
                }
            } else {
                view2.addOnLayoutChangeListener(new View.OnLayoutChangeListener() {
                    @Override
                    public void onLayoutChange(View view3, int left, int top, int right, int bottom, int oldLeft, int oldTop, int oldRight, int oldBottom) {
                        view3.removeOnLayoutChangeListener(this);
                        if (!this.this$0.rendering.getState().m268xbd7bc74e() || this.this$0.rendering.getState().getMessageLogEntryList$zendesk_messaging_messaging_android().isEmpty()) {
                            return;
                        }
                        this.this$0.recyclerView.postDelayed(new MessageLogView$render$2$1$2$1(this.this$0), 1500L);
                    }
                });
            }
        }
        this$0.announceNewMessageContentForAccessibility();
    }

    private final boolean isQuickReplyAtBottomOfList(Integer lastVisibleItemPosition, int lastMessagePosition) {
        if (lastVisibleItemPosition == null) {
            return false;
        }
        int iIntValue = lastVisibleItemPosition.intValue();
        return iIntValue == lastMessagePosition || iIntValue == lastMessagePosition + (-1) || iIntValue == lastMessagePosition + (-2);
    }

    public final void hideSeeLatestView() {
        if (this.layoutManager.findLastVisibleItemPosition() == this.messageListAdapter.getItemCount() - 1 && this.seeLatestView.getVisibility() == 0) {
            this.seeLatestView.render(new Function1<ButtonBannerRendering, ButtonBannerRendering>() {
                {
                    super(1);
                }

                @Override
                public final ButtonBannerRendering invoke(ButtonBannerRendering connectionBannerRendering) {
                    Intrinsics.checkNotNullParameter(connectionBannerRendering, "connectionBannerRendering");
                    ButtonBannerRendering.Builder builder = connectionBannerRendering.toBuilder();
                    final MessageLogView messageLogView = MessageLogView.this;
                    return builder.state(new Function1<ButtonBannerState, ButtonBannerState>() {
                        {
                            super(1);
                        }

                        @Override
                        public final ButtonBannerState invoke(ButtonBannerState unreadMessagesState) {
                            Intrinsics.checkNotNullParameter(unreadMessagesState, "unreadMessagesState");
                            return ButtonBannerState.copy$default(unreadMessagesState, ButtonBannerViewType.SEE_LATEST, (String) null, false, Integer.valueOf(messageLogView.rendering.getState().getMessagingTheme$zendesk_messaging_messaging_android().getOnBackgroundColor()), Integer.valueOf(messageLogView.rendering.getState().getMessagingTheme$zendesk_messaging_messaging_android().getOnBackgroundColor()), Integer.valueOf(messageLogView.rendering.getState().getMessagingTheme$zendesk_messaging_messaging_android().getElevatedColor()), (Integer) null, (Spanned) null, false, AIHelpWebProgress.MAX_DECELERATE_SPEED_DURATION, (Object) null);
                        }
                    }).build();
                }
            });
            this.rendering.m261xa05399e8().invoke();
        }
    }

    public final void scrollToBottom(final LinearLayoutManager linearLayoutManager, final int lastMessagePosition) {
        if (linearLayoutManager != null) {
            linearLayoutManager.scrollToPosition(lastMessagePosition);
            post(new Runnable() {
                @Override
                public final void run() {
                    MessageLogView.scrollToBottom$lambda$9$lambda$8(linearLayoutManager, lastMessagePosition, this);
                }
            });
        }
    }

    public static final void scrollToBottom$lambda$9$lambda$8(LinearLayoutManager layoutManager, int i, MessageLogView this$0) {
        Intrinsics.checkNotNullParameter(layoutManager, "$layoutManager");
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        View viewFindViewByPosition = layoutManager.findViewByPosition(i);
        if (viewFindViewByPosition != null) {
            layoutManager.scrollToPositionWithOffset(i, this$0.getMeasuredHeight() - viewFindViewByPosition.getMeasuredHeight());
        }
    }

    public final void fastSmoothScrollToBottom(LinearLayoutManager linearLayoutManager, int messagePosition) {
        final Context context = this.recyclerView.getContext();
        final int i = -1;
        RecyclerView.SmoothScroller smoothScroller = new LinearSmoothScroller(context) {
            protected int getVerticalSnapPreference() {
                return i;
            }

            protected int get$snapMode() {
                return i;
            }
        };
        smoothScroller.setTargetPosition(messagePosition);
        if (linearLayoutManager != null) {
            linearLayoutManager.startSmoothScroll(smoothScroller);
        }
    }

    private final void onScrollToBottomIfKeyboardShown(final RecyclerView recyclerView) {
        ViewKt.onKeyboardShown((View) recyclerView, new Function0<Unit>() {
            {
                super(0);
            }

            @Override
            public Unit invoke() {
                invoke2();
                return Unit.INSTANCE;
            }

            public final void invoke2() {
                RecyclerView.Adapter adapter = recyclerView.getAdapter();
                if (adapter != null) {
                    MessageLogView messageLogView = this;
                    RecyclerView recyclerView2 = recyclerView;
                    int itemCount = adapter.getItemCount() - 1;
                    LinearLayoutManager layoutManager = recyclerView2.getLayoutManager();
                    messageLogView.scrollToBottom(layoutManager instanceof LinearLayoutManager ? layoutManager : null, itemCount);
                }
            }
        });
    }

    private final void announceNewMessageContentForAccessibility() {
        List<MessageLogEntry> messageLogEntryList$zendesk_messaging_messaging_android = this.rendering.getState().getMessageLogEntryList$zendesk_messaging_messaging_android();
        ArrayList arrayList = new ArrayList();
        for (Object obj : messageLogEntryList$zendesk_messaging_messaging_android) {
            if (obj instanceof MessageLogEntry.MessageContainer) {
                arrayList.add(obj);
            }
        }
        ArrayList arrayList2 = arrayList;
        if (arrayList2.isEmpty()) {
            return;
        }
        Object objLast = CollectionsKt.last((List<? extends Object>) arrayList2);
        Intrinsics.checkNotNull(objLast, "null cannot be cast to non-null type zendesk.messaging.android.internal.model.MessageLogEntry.MessageContainer");
        final MessageLogEntry.MessageContainer messageContainer = (MessageLogEntry.MessageContainer) objLast;
        if (messageContainer.getDirection() == MessageDirection.INBOUND && this.rendering.getState().getShouldAnnounceMessage$zendesk_messaging_messaging_android()) {
            this.recyclerView.postDelayed(new Runnable() {
                @Override
                public final void run() {
                    MessageLogView.announceNewMessageContentForAccessibility$lambda$11(this.f$0, messageContainer);
                }
            }, 1500L);
        }
    }

    public static final void announceNewMessageContentForAccessibility$lambda$11(MessageLogView this$0, MessageLogEntry.MessageContainer lastMessageEntry) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        Intrinsics.checkNotNullParameter(lastMessageEntry, "$lastMessageEntry");
        RecyclerView recyclerView = this$0.recyclerView;
        recyclerView.announceForAccessibility(recyclerView.getContext().getString(R.string.zuia_new_content_change_accessibility_label, lastMessageEntry.getMessage().getAuthor().getDisplayName()));
    }

    public final void showNewMessagesViewIfNeeded(List<? extends MessageLogEntry> messageList) {
        int iFindLastVisibleItemPosition;
        LinearLayoutManager layoutManager = this.recyclerView.getLayoutManager();
        Intrinsics.checkNotNull(layoutManager, "null cannot be cast to non-null type androidx.recyclerview.widget.LinearLayoutManager");
        final int size = 0;
        if (layoutManager.findLastVisibleItemPosition() > 0) {
            LinearLayoutManager layoutManager2 = this.recyclerView.getLayoutManager();
            Intrinsics.checkNotNull(layoutManager2, "null cannot be cast to non-null type androidx.recyclerview.widget.LinearLayoutManager");
            iFindLastVisibleItemPosition = layoutManager2.findLastVisibleItemPosition();
        } else {
            iFindLastVisibleItemPosition = 0;
        }
        MessageLogEntry messageLogEntry = messageList.get(iFindLastVisibleItemPosition);
        MessageDirection direction = messageLogEntry instanceof MessageLogEntry.MessageContainer ? ((MessageLogEntry.MessageContainer) messageLogEntry).getDirection() : null;
        if (this.newMessagesView.getVisibility() == 0 && direction == MessageDirection.OUTBOUND) {
            this.newMessagesView.render(new Function1<ButtonBannerRendering, ButtonBannerRendering>() {
                {
                    super(1);
                }

                @Override
                public final ButtonBannerRendering invoke(ButtonBannerRendering unreadMessagesRendering) {
                    Intrinsics.checkNotNullParameter(unreadMessagesRendering, "unreadMessagesRendering");
                    ButtonBannerRendering.Builder builder = unreadMessagesRendering.toBuilder();
                    final MessageLogView messageLogView = MessageLogView.this;
                    return builder.state(new Function1<ButtonBannerState, ButtonBannerState>() {
                        {
                            super(1);
                        }

                        @Override
                        public final ButtonBannerState invoke(ButtonBannerState unreadMessagesState) {
                            Intrinsics.checkNotNullParameter(unreadMessagesState, "unreadMessagesState");
                            return ButtonBannerState.copy$default(unreadMessagesState, ButtonBannerViewType.NEW_MESSAGES, (String) null, false, Integer.valueOf(messageLogView.rendering.getState().getMessagingTheme$zendesk_messaging_messaging_android().getOnBackgroundColor()), Integer.valueOf(messageLogView.rendering.getState().getMessagingTheme$zendesk_messaging_messaging_android().getOnBackgroundColor()), Integer.valueOf(messageLogView.rendering.getState().getMessagingTheme$zendesk_messaging_messaging_android().getElevatedColor()), (Integer) null, (Spanned) null, false, AIHelpWebProgress.MAX_DECELERATE_SPEED_DURATION, (Object) null);
                        }
                    }).build();
                }
            });
            this.isNewMessagesClicked = true;
        }
        final int newMessagesDividerPosition = getNewMessagesDividerPosition(messageList);
        if (newMessagesDividerPosition != -1) {
            size = newMessagesDividerPosition != 0 ? (messageList.size() - 1) - newMessagesDividerPosition : 100;
        }
        if (this.isNewMessagesClicked || size <= 0) {
            return;
        }
        this.newMessagesView.render(new Function1<ButtonBannerRendering, ButtonBannerRendering>() {
            {
                super(1);
            }

            @Override
            public final ButtonBannerRendering invoke(ButtonBannerRendering unreadMessagesRendering) {
                Intrinsics.checkNotNullParameter(unreadMessagesRendering, "unreadMessagesRendering");
                ButtonBannerRendering.Builder builder = unreadMessagesRendering.toBuilder();
                final MessageLogView messageLogView = MessageLogView.this;
                final int i = newMessagesDividerPosition;
                ButtonBannerRendering.Builder builderOnViewClicked = builder.onViewClicked(new Function0<Unit>() {
                    {
                        super(0);
                    }

                    @Override
                    public Unit invoke() {
                        invoke2();
                        return Unit.INSTANCE;
                    }

                    public final void invoke2() {
                        MessageLogView messageLogView2 = messageLogView;
                        LinearLayoutManager linearLayoutManager = messageLogView2.layoutManager;
                        if (!(linearLayoutManager instanceof LinearLayoutManager)) {
                            linearLayoutManager = null;
                        }
                        messageLogView2.fastSmoothScrollToBottom(linearLayoutManager, i);
                        messageLogView.isNewMessagesClicked = true;
                    }
                });
                final MessageLogView messageLogView2 = MessageLogView.this;
                ButtonBannerRendering.Builder builderOnViewDismissed = builderOnViewClicked.onViewDismissed(new Function0<Unit>() {
                    {
                        super(0);
                    }

                    @Override
                    public Unit invoke() {
                        invoke2();
                        return Unit.INSTANCE;
                    }

                    public final void invoke2() {
                        messageLogView2.isNewMessagesClicked = true;
                    }
                });
                final int i2 = size;
                final MessageLogView messageLogView3 = MessageLogView.this;
                return builderOnViewDismissed.state(new Function1<ButtonBannerState, ButtonBannerState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final ButtonBannerState invoke(ButtonBannerState unreadMessagesState) {
                        String string;
                        Intrinsics.checkNotNullParameter(unreadMessagesState, "unreadMessagesState");
                        if (i2 == 100) {
                            string = messageLogView3.getContext().getString(C1256R.string.zuia_new_messages_nighty_night_plus_label);
                        } else {
                            string = messageLogView3.getContext().getString(C1256R.string.zuia_new_messages_label, Integer.valueOf(i2));
                        }
                        return ButtonBannerState.copy$default(unreadMessagesState, ButtonBannerViewType.NEW_MESSAGES, string, true, Integer.valueOf(messageLogView3.rendering.getState().getMessagingTheme$zendesk_messaging_messaging_android().getOnBackgroundColor()), Integer.valueOf(messageLogView3.rendering.getState().getMessagingTheme$zendesk_messaging_messaging_android().getOnBackgroundColor()), Integer.valueOf(messageLogView3.rendering.getState().getMessagingTheme$zendesk_messaging_messaging_android().getElevatedColor()), (Integer) null, (Spanned) null, false, 448, (Object) null);
                    }
                }).build();
            }
        });
    }

    public final void showSeeLatestViewIfNeeded(final List<? extends MessageLogEntry> messageList) {
        int iFindLastVisibleItemPosition;
        LinearLayoutManager layoutManager = this.recyclerView.getLayoutManager();
        Intrinsics.checkNotNull(layoutManager, "null cannot be cast to non-null type androidx.recyclerview.widget.LinearLayoutManager");
        if (layoutManager.findLastVisibleItemPosition() > 0) {
            LinearLayoutManager layoutManager2 = this.recyclerView.getLayoutManager();
            Intrinsics.checkNotNull(layoutManager2, "null cannot be cast to non-null type androidx.recyclerview.widget.LinearLayoutManager");
            iFindLastVisibleItemPosition = layoutManager2.findLastVisibleItemPosition();
        } else {
            iFindLastVisibleItemPosition = 0;
        }
        if (Intrinsics.areEqual(messageList.get(iFindLastVisibleItemPosition), CollectionsKt.last((List) messageList))) {
            this.seeLatestView.render(new Function1<ButtonBannerRendering, ButtonBannerRendering>() {
                {
                    super(1);
                }

                @Override
                public final ButtonBannerRendering invoke(ButtonBannerRendering unreadMessagesRendering) {
                    Intrinsics.checkNotNullParameter(unreadMessagesRendering, "unreadMessagesRendering");
                    ButtonBannerRendering.Builder builder = unreadMessagesRendering.toBuilder();
                    final MessageLogView messageLogView = MessageLogView.this;
                    return builder.state(new Function1<ButtonBannerState, ButtonBannerState>() {
                        {
                            super(1);
                        }

                        @Override
                        public final ButtonBannerState invoke(ButtonBannerState unreadMessagesState) {
                            Intrinsics.checkNotNullParameter(unreadMessagesState, "unreadMessagesState");
                            return ButtonBannerState.copy$default(unreadMessagesState, ButtonBannerViewType.SEE_LATEST, (String) null, false, Integer.valueOf(messageLogView.rendering.getState().getMessagingTheme$zendesk_messaging_messaging_android().getOnBackgroundColor()), Integer.valueOf(messageLogView.rendering.getState().getMessagingTheme$zendesk_messaging_messaging_android().getOnBackgroundColor()), Integer.valueOf(messageLogView.rendering.getState().getMessagingTheme$zendesk_messaging_messaging_android().getElevatedColor()), (Integer) null, (Spanned) null, false, AIHelpWebProgress.MAX_DECELERATE_SPEED_DURATION, (Object) null);
                        }
                    }).build();
                }
            });
            this.rendering.m261xa05399e8().invoke();
        } else {
            if (this.newMessagesView.getVisibility() == 0) {
                this.newMessagesView.render(new Function1<ButtonBannerRendering, ButtonBannerRendering>() {
                    {
                        super(1);
                    }

                    @Override
                    public final ButtonBannerRendering invoke(ButtonBannerRendering unreadMessagesRendering) {
                        Intrinsics.checkNotNullParameter(unreadMessagesRendering, "unreadMessagesRendering");
                        ButtonBannerRendering.Builder builder = unreadMessagesRendering.toBuilder();
                        final MessageLogView messageLogView = MessageLogView.this;
                        return builder.state(new Function1<ButtonBannerState, ButtonBannerState>() {
                            {
                                super(1);
                            }

                            @Override
                            public final ButtonBannerState invoke(ButtonBannerState unreadMessagesState) {
                                Intrinsics.checkNotNullParameter(unreadMessagesState, "unreadMessagesState");
                                return ButtonBannerState.copy$default(unreadMessagesState, ButtonBannerViewType.NEW_MESSAGES, (String) null, false, Integer.valueOf(messageLogView.rendering.getState().getMessagingTheme$zendesk_messaging_messaging_android().getOnBackgroundColor()), Integer.valueOf(messageLogView.rendering.getState().getMessagingTheme$zendesk_messaging_messaging_android().getOnBackgroundColor()), Integer.valueOf(messageLogView.rendering.getState().getMessagingTheme$zendesk_messaging_messaging_android().getElevatedColor()), (Integer) null, (Spanned) null, false, AIHelpWebProgress.MAX_DECELERATE_SPEED_DURATION, (Object) null);
                            }
                        }).build();
                    }
                });
                this.isNewMessagesClicked = true;
            }
            this.seeLatestView.render(new Function1<ButtonBannerRendering, ButtonBannerRendering>() {
                {
                    super(1);
                }

                @Override
                public final ButtonBannerRendering invoke(ButtonBannerRendering unreadMessagesRendering) {
                    Intrinsics.checkNotNullParameter(unreadMessagesRendering, "unreadMessagesRendering");
                    ButtonBannerRendering.Builder builder = unreadMessagesRendering.toBuilder();
                    final MessageLogView messageLogView = MessageLogView.this;
                    final List<MessageLogEntry> list = messageList;
                    ButtonBannerRendering.Builder builderOnViewClicked = builder.onViewClicked(new Function0<Unit>() {
                        {
                            super(0);
                        }

                        @Override
                        public Unit invoke() {
                            invoke2();
                            return Unit.INSTANCE;
                        }

                        public final void invoke2() {
                            MessageLogView messageLogView2 = messageLogView;
                            LinearLayoutManager linearLayoutManager = messageLogView2.layoutManager;
                            if (!(linearLayoutManager instanceof LinearLayoutManager)) {
                                linearLayoutManager = null;
                            }
                            messageLogView2.fastSmoothScrollToBottom(linearLayoutManager, list.size() - 1);
                            messageLogView.rendering.m261xa05399e8().invoke();
                        }
                    });
                    final MessageLogView messageLogView2 = MessageLogView.this;
                    return builderOnViewClicked.state(new Function1<ButtonBannerState, ButtonBannerState>() {
                        {
                            super(1);
                        }

                        @Override
                        public final ButtonBannerState invoke(ButtonBannerState unreadMessagesState) {
                            Intrinsics.checkNotNullParameter(unreadMessagesState, "unreadMessagesState");
                            return ButtonBannerState.copy$default(unreadMessagesState, ButtonBannerViewType.SEE_LATEST, messageLogView2.getContext().getString(C1256R.string.zuia_see_latest_label), true, Integer.valueOf(messageLogView2.rendering.getState().getMessagingTheme$zendesk_messaging_messaging_android().getOnBackgroundColor()), Integer.valueOf(messageLogView2.rendering.getState().getMessagingTheme$zendesk_messaging_messaging_android().getOnBackgroundColor()), Integer.valueOf(messageLogView2.rendering.getState().getMessagingTheme$zendesk_messaging_messaging_android().getElevatedColor()), (Integer) null, (Spanned) null, false, 448, (Object) null);
                        }
                    }).build();
                }
            });
        }
    }

    private final void updateScrollingBehaviourOnFocusChange(View newFocus) {
        if (newFocus == null || newFocus.getId() != R.id.zuia_field_input) {
            this.isFormFocused = false;
            onScrollToBottomIfKeyboardShown(this.recyclerView);
        } else {
            this.isFormFocused = true;
            this.recyclerView.stopScroll();
        }
    }

    private final int getNewMessagesDividerPosition(List<? extends MessageLogEntry> messageList) {
        if (this.firstUnreadMessagePosition.get() == -1) {
            return -1;
        }
        LinearLayoutManager layoutManager = this.recyclerView.getLayoutManager();
        LinearLayoutManager linearLayoutManager = layoutManager instanceof LinearLayoutManager ? layoutManager : null;
        int iFindFirstVisibleItemPosition = linearLayoutManager != null ? linearLayoutManager.findFirstVisibleItemPosition() : 0;
        int i = 0;
        for (Object obj : messageList) {
            int i2 = i + 1;
            if (i < 0) {
                CollectionsKt.throwIndexOverflow();
            }
            MessageLogEntry messageLogEntry = (MessageLogEntry) obj;
            if ((messageLogEntry instanceof MessageLogEntry.MessagesDivider) && ((MessageLogEntry.MessagesDivider) messageLogEntry).getType() == MessageLogType.NewMessagesDivider) {
                if (i == 0) {
                    this.firstUnreadMessagePosition.set(0);
                    return 0;
                }
                if (iFindFirstVisibleItemPosition > i) {
                    this.firstUnreadMessagePosition.set(i);
                    return i;
                }
            }
            i = i2;
        }
        this.firstUnreadMessagePosition.set(-1);
        return -1;
    }

    @Metadata(m17d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0010\t\n\u0002\b\u0007\n\u0002\u0010\u000e\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0006X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\u0006X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\t\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u000b\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\f\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\r\u001a\u00020\u000eX\u0086T¢\u0006\u0002\n\u0000¨\u0006\u000f"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/messagelog/MessageLogView$Companion;", "", "()V", "MAXIMUM_MESSAGES_NUMBER", "", "NEW_CONTENT_CHANGE_ACCESSIBILITY_EVENT_DELAY", "", "NEW_MESSAGE_VIEW_DELAY", "NO_UNREAD_MESSAGES_EXIST", "OFFSET_WITH_EMPTY_MESSAGE", "OFFSET_WITH_NONEMPTY_MESSAGE", "OFFSET_WITH_REGULAR_MESSAGE", "ONE_HUNDRED_OR_MORE_UNREAD_MESSAGES", "TAG", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
