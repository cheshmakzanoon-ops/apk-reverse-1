package zendesk.messaging.android.internal.conversationslistscreen.conversation;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import androidx.core.content.ContextCompat;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.p017ui.android.internal.model.ConversationEntry;
import zendesk.messaging.C1256R;
import zendesk.p026ui.android.conversation.avatar.AvatarImageState;
import zendesk.p026ui.android.conversation.avatar.AvatarMask;
import zendesk.p026ui.android.conversations.cell.ConversationCellState;
import zendesk.p026ui.android.conversations.cell.ConversationCellView;
import zendesk.ui.android.R;
import zendesk.ui.android.common.loadmore.LoadMoreView;

@Metadata(m17d1 = {"\u0000<\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÀ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0018\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\bH\u0002J0\u0010\t\u001a\u00020\n2\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\b2\u0006\u0010\u0005\u001a\u00020\u00062\u0014\b\u0002\u0010\u000b\u001a\u000e\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\r0\fJ\u000e\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0005\u001a\u00020\u0006J3\u0010\u0010\u001a\u00020\u00112\b\u0010\u0007\u001a\u0004\u0018\u00010\b2\u0006\u0010\u0005\u001a\u00020\u00062\u0012\u0010\u000b\u001a\u000e\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\r0\fH\u0000¢\u0006\u0002\b\u0012¨\u0006\u0013"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/conversation/ConversationCellFactory;", "", "()V", "createAvatarImageState", "Lzendesk/ui/android/conversation/avatar/AvatarImageState;", "parentView", "Landroid/view/View;", "item", "Lzendesk/core/ui/android/internal/model/ConversationEntry$ConversationItem;", "createConversationCellView", "Lzendesk/ui/android/conversations/cell/ConversationCellView;", "clickListener", "Lkotlin/Function1;", "", "createLoadMoreCellView", "Lzendesk/ui/android/common/loadmore/LoadMoreView;", "mapToConversationCellState", "Lzendesk/ui/android/conversations/cell/ConversationCellState;", "mapToConversationCellState$zendesk_messaging_messaging_android", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationCellFactory {
    public static final ConversationCellFactory INSTANCE = new ConversationCellFactory();

    private ConversationCellFactory() {
    }

    public static ConversationCellView createConversationCellView$default(ConversationCellFactory conversationCellFactory, ConversationEntry.ConversationItem conversationItem, View view, Function1 function1, int i, Object obj) {
        if ((i & 1) != 0) {
            conversationItem = null;
        }
        if ((i & 4) != 0) {
            function1 = new Function1<ConversationEntry.ConversationItem, Unit>() {
                public final void invoke2(ConversationEntry.ConversationItem it) {
                    Intrinsics.checkNotNullParameter(it, "it");
                }

                @Override
                public Unit invoke(ConversationEntry.ConversationItem conversationItem2) {
                    invoke2(conversationItem2);
                    return Unit.INSTANCE;
                }
            };
        }
        return conversationCellFactory.createConversationCellView(conversationItem, view, function1);
    }

    public final ConversationCellView createConversationCellView(ConversationEntry.ConversationItem item, View parentView, Function1<? super ConversationEntry.ConversationItem, Unit> clickListener) {
        Intrinsics.checkNotNullParameter(parentView, "parentView");
        Intrinsics.checkNotNullParameter(clickListener, "clickListener");
        Context context = parentView.getContext();
        Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
        ConversationCellView conversationCellView = new ConversationCellView(context, null, 0, 0, 14, null);
        conversationCellView.onBind(INSTANCE.mapToConversationCellState$zendesk_messaging_messaging_android(item, parentView, clickListener));
        return conversationCellView;
    }

    public final LoadMoreView createLoadMoreCellView(View parentView) {
        Intrinsics.checkNotNullParameter(parentView, "parentView");
        Context context = parentView.getContext();
        Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
        LoadMoreView loadMoreView = new LoadMoreView(context, (AttributeSet) null, 0, 0, 14, (DefaultConstructorMarker) null);
        loadMoreView.setLayoutParams(new ViewGroup.LayoutParams(-1, -2));
        return loadMoreView;
    }

    public final ConversationCellState mapToConversationCellState$zendesk_messaging_messaging_android(final ConversationEntry.ConversationItem item, View parentView, final Function1<? super ConversationEntry.ConversationItem, Unit> clickListener) {
        Intrinsics.checkNotNullParameter(parentView, "parentView");
        Intrinsics.checkNotNullParameter(clickListener, "clickListener");
        if (item != null) {
            ConversationCellState.Builder builder = new ConversationCellState.Builder();
            AvatarImageState avatarImageStateCreateAvatarImageState = createAvatarImageState(parentView, item);
            String latestMessage = item.getLatestMessage();
            String latestMessageOwner = item.getLatestMessageOwner();
            return builder.conversationCellState(item.getParticipantName(), item.getConversationTitle(), latestMessage, latestMessageOwner, avatarImageStateCreateAvatarImageState, item.getFormattedDateTimeStampString(), item.getUnreadMessages(), item.getUnreadMessagesColor(), item.getDateTimestampTextColor(), item.getLastMessageTextColor(), item.getConversationParticipantsTextColor(), item.getConversationTitleTextColor(), new Function0<Unit>() {
                {
                    super(0);
                }

                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }

                public final void invoke2() {
                    clickListener.invoke(item);
                }
            }, item.getAccessibilityTitle()).getState();
        }
        return new ConversationCellState.Builder().conversationCellState((16383 & 1) != 0 ? "" : null, (16383 & 2) != 0 ? "" : null, (16383 & 4) != 0 ? "" : null, (16383 & 8) != 0 ? null : null, (16383 & 16) == 0 ? null : null, (16383 & 32) != 0 ? "" : null, (16383 & 64) != 0 ? 0 : 0, (16383 & 128) != 0 ? 0 : 0, (16383 & 256) != 0 ? 0 : 0, (16383 & 512) != 0 ? 0 : 0, (16383 & 1024) != 0 ? 0 : 0, (16383 & 2048) == 0 ? 0 : 0, (16383 & 4096) != 0 ? new Function0<Unit>() {
            public final void invoke2() {
            }

            @Override
            public Unit invoke() {
                invoke2();
                return Unit.INSTANCE;
            }
        } : null, (16383 & 8192) == 0 ? null : "").getState();
    }

    private final AvatarImageState createAvatarImageState(View parentView, ConversationEntry.ConversationItem item) {
        if (item.getAvatarUrl().length() > 0) {
            return new AvatarImageState.Builder().backgroundColor(ContextCompat.getColor(parentView.getContext(), C1256R.color.zma_color_background)).shouldAnimate(false).mask(AvatarMask.CIRCLE).uri(item.getAvatarUrl()).avatarSize(Integer.valueOf(R.dimen.zuia_conversation_cell_avatar_image_size)).getState();
        }
        return new AvatarImageState.Builder().getState();
    }
}
