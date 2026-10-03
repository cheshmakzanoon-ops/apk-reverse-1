package zendesk.messaging.android.internal.conversationscreen.delegates;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.recyclerview.widget.RecyclerView;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.model.MessageAction;
import zendesk.conversationkit.android.model.MessageContent;
import zendesk.conversationkit.android.model.MessageItem;
import zendesk.conversationkit.android.model.MessageStatus;
import zendesk.core.p017ui.android.internal.model.MessageActionSize;
import zendesk.core.p017ui.android.internal.model.MessagePosition;
import zendesk.messaging.C1256R;
import zendesk.messaging.android.internal.adapterdelegate.ListItemAdapterDelegate;
import zendesk.messaging.android.internal.conversationscreen.messagelog.MessageLogListenersKt;
import zendesk.messaging.android.internal.model.MessageLogEntry;
import zendesk.messaging.android.internal.model.MessageSize;
import zendesk.messaging.android.internal.model.MessagingTheme;
import zendesk.p026ui.android.conversation.avatar.AvatarImageState;
import zendesk.p026ui.android.conversation.avatar.AvatarImageView;
import zendesk.p026ui.android.conversation.avatar.AvatarMask;
import zendesk.p026ui.android.conversation.carousel.CarouselAction;
import zendesk.p026ui.android.conversation.carousel.CarouselCellData;
import zendesk.p026ui.android.conversation.carousel.CarouselCellState;
import zendesk.p026ui.android.conversation.carousel.CarouselCellView;
import zendesk.p026ui.android.conversation.carousel.CarouselRendering;
import zendesk.p026ui.android.conversation.receipt.MessageReceiptView;
import zendesk.ui.android.R;

@Metadata(m17d1 = {"\u0000V\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010 \n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u00002\u0014\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00040\u0001:\u0001#B'\u0012\u0018\b\u0002\u0010\u0005\u001a\u0012\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\b0\u0006j\u0002`\t\u0012\u0006\u0010\n\u001a\u00020\u000b¢\u0006\u0002\u0010\fJ&\u0010\u0015\u001a\u00020\u00162\u0006\u0010\u0017\u001a\u00020\u00032\f\u0010\u0018\u001a\b\u0012\u0004\u0012\u00020\u00030\u00192\u0006\u0010\u001a\u001a\u00020\u001bH\u0014J(\u0010\u001c\u001a\u00020\b2\u0006\u0010\u0017\u001a\u00020\u00022\u0006\u0010\u001d\u001a\u00020\u00042\u000e\u0010\u001e\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u001f0\u0019H\u0014J\u0010\u0010 \u001a\u00020\u00042\u0006\u0010!\u001a\u00020\"H\u0016R\u001a\u0010\n\u001a\u00020\u000bX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\r\u0010\u000e\"\u0004\b\u000f\u0010\u0010R*\u0010\u0005\u001a\u0012\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\b0\u0006j\u0002`\tX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0011\u0010\u0012\"\u0004\b\u0013\u0010\u0014¨\u0006$"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/delegates/CarouselContainerAdapterDelegate;", "Lzendesk/messaging/android/internal/adapterdelegate/ListItemAdapterDelegate;", "Lzendesk/messaging/android/internal/model/MessageLogEntry$CarouselContainer;", "Lzendesk/messaging/android/internal/model/MessageLogEntry;", "Lzendesk/messaging/android/internal/conversationscreen/delegates/CarouselContainerAdapterDelegate$ViewHolder;", "onCarouselAction", "Lkotlin/Function1;", "Lzendesk/ui/android/conversation/carousel/CarouselAction;", "", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnCarouselAction;", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "(Lkotlin/jvm/functions/Function1;Lzendesk/messaging/android/internal/model/MessagingTheme;)V", "getMessagingTheme", "()Lzendesk/messaging/android/internal/model/MessagingTheme;", "setMessagingTheme", "(Lzendesk/messaging/android/internal/model/MessagingTheme;)V", "getOnCarouselAction", "()Lkotlin/jvm/functions/Function1;", "setOnCarouselAction", "(Lkotlin/jvm/functions/Function1;)V", "isForViewType", "", "item", "items", "", "position", "", "onBindViewHolder", "holder", "payloads", "", "onCreateViewHolder", "parent", "Landroid/view/ViewGroup;", "ViewHolder", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class CarouselContainerAdapterDelegate extends ListItemAdapterDelegate<MessageLogEntry.CarouselContainer, MessageLogEntry, ViewHolder> {
    private MessagingTheme messagingTheme;
    private Function1<? super CarouselAction, Unit> onCarouselAction;

    @Override
    public void onBindViewHolder(Object obj, RecyclerView.ViewHolder viewHolder, List list) {
        onBindViewHolder((MessageLogEntry.CarouselContainer) obj, (ViewHolder) viewHolder, (List<? extends Object>) list);
    }

    public CarouselContainerAdapterDelegate(Function1 function1, MessagingTheme messagingTheme, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? MessageLogListenersKt.getNOOP_ON_CAROUSEL_ACTION() : function1, messagingTheme);
    }

    public final Function1<CarouselAction, Unit> getOnCarouselAction() {
        return this.onCarouselAction;
    }

    public final void setOnCarouselAction(Function1<? super CarouselAction, Unit> function1) {
        Intrinsics.checkNotNullParameter(function1, "<set-?>");
        this.onCarouselAction = function1;
    }

    public final MessagingTheme getMessagingTheme() {
        return this.messagingTheme;
    }

    public final void setMessagingTheme(MessagingTheme messagingTheme) {
        Intrinsics.checkNotNullParameter(messagingTheme, "<set-?>");
        this.messagingTheme = messagingTheme;
    }

    public CarouselContainerAdapterDelegate(Function1<? super CarouselAction, Unit> onCarouselAction, MessagingTheme messagingTheme) {
        Intrinsics.checkNotNullParameter(onCarouselAction, "onCarouselAction");
        Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
        this.onCarouselAction = onCarouselAction;
        this.messagingTheme = messagingTheme;
    }

    @Override
    public boolean isForViewType(MessageLogEntry item, List<? extends MessageLogEntry> items, int position) {
        Intrinsics.checkNotNullParameter(item, "item");
        Intrinsics.checkNotNullParameter(items, "items");
        return item instanceof MessageLogEntry.CarouselContainer;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent) {
        Intrinsics.checkNotNullParameter(parent, "parent");
        View viewInflate = LayoutInflater.from(parent.getContext()).inflate(C1256R.layout.zma_view_message_log_entry_message_container, parent, false);
        Intrinsics.checkNotNullExpressionValue(viewInflate, "inflate(...)");
        return new ViewHolder(viewInflate, this.messagingTheme);
    }

    protected void onBindViewHolder(MessageLogEntry.CarouselContainer item, ViewHolder holder, List<? extends Object> payloads) {
        Intrinsics.checkNotNullParameter(item, "item");
        Intrinsics.checkNotNullParameter(holder, "holder");
        Intrinsics.checkNotNullParameter(payloads, "payloads");
        holder.bind(item, this.onCarouselAction);
    }

    @Metadata(m17d1 = {"\u0000t\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\u001a\u0010\u000f\u001a\u0004\u0018\u00010\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0014H\u0002J&\u0010\u0015\u001a\u00020\u00162\u0006\u0010\u0017\u001a\u00020\u00122\u0016\u0010\u0018\u001a\u0012\u0012\u0004\u0012\u00020\u001a\u0012\u0004\u0012\u00020\u00160\u0019j\u0002`\u001bJ\u009a\u0001\u0010\u001c\u001a\u00020\u00032\u0006\u0010\u001d\u001a\u00020\u001e2\u0006\u0010\u001f\u001a\u00020 2\u0006\u0010\u0011\u001a\u00020\u00122\b\b\u0001\u0010!\u001a\u00020\u00142\b\b\u0001\u0010\"\u001a\u00020\u00142\b\b\u0001\u0010#\u001a\u00020\u00142\b\b\u0001\u0010\u0013\u001a\u00020\u00142\b\b\u0001\u0010$\u001a\u00020\u00142\b\b\u0001\u0010%\u001a\u00020\u00142\b\b\u0001\u0010&\u001a\u00020\u00142\b\b\u0001\u0010'\u001a\u00020\u00142\u0014\b\u0002\u0010(\u001a\u000e\u0012\u0004\u0012\u00020\u001a\u0012\u0004\u0012\u00020\u00160\u00192\b\b\u0001\u0010)\u001a\u00020\u00142\b\b\u0001\u0010*\u001a\u00020\u0014H\u0002J2\u0010+\u001a\b\u0012\u0004\u0012\u00020-0,2\u0006\u0010\u001d\u001a\u00020\u001e2\u0006\u0010\u001f\u001a\u00020 2\u0012\u0010(\u001a\u000e\u0012\u0004\u0012\u00020\u001a\u0012\u0004\u0012\u00020\u00160\u0019H\u0002J(\u0010.\u001a\u00020\u00162\u0006\u0010\u0017\u001a\u00020\u00122\u0016\u0010\u0018\u001a\u0012\u0012\u0004\u0012\u00020\u001a\u0012\u0004\u0012\u00020\u00160\u0019j\u0002`\u001bH\u0002R\u000e\u0010\u0007\u001a\u00020\bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\t\u001a\u00020\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000b\u001a\u00020\fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\r\u001a\u00020\u000eX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006/"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/delegates/CarouselContainerAdapterDelegate$ViewHolder;", "Landroidx/recyclerview/widget/RecyclerView$ViewHolder;", "itemView", "Landroid/view/View;", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "(Landroid/view/View;Lzendesk/messaging/android/internal/model/MessagingTheme;)V", "avatarView", "Lzendesk/ui/android/conversation/avatar/AvatarImageView;", "contentView", "Landroid/widget/LinearLayout;", "labelView", "Landroid/widget/TextView;", "receiptView", "Lzendesk/ui/android/conversation/receipt/MessageReceiptView;", "avatarImageState", "Lzendesk/ui/android/conversation/avatar/AvatarImageState;", "container", "Lzendesk/messaging/android/internal/model/MessageLogEntry$CarouselContainer;", "inboundMessageColor", "", "bind", "", "item", "onCarouselAction", "Lkotlin/Function1;", "Lzendesk/ui/android/conversation/carousel/CarouselAction;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnCarouselAction;", "createCarouselCell", "parentView", "Landroid/view/ViewGroup;", "content", "Lzendesk/conversationkit/android/model/MessageContent$Carousel;", "navigationButtonColor", "navigationIconColor", "textColor", "buttonTextColor", "buttonDisabledTextColor", "focusedStateBorderColor", "systemMessageColor", "carouselItemClickListener", "disabledBackgroundColor", "actionBackgroundColor", "mapActionsToCarouselItems", "", "Lzendesk/ui/android/conversation/carousel/CarouselCellData$Item;", "renderContent", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ViewHolder extends RecyclerView.ViewHolder {
        private final AvatarImageView avatarView;
        private final LinearLayout contentView;
        private final TextView labelView;
        private final MessagingTheme messagingTheme;
        private final MessageReceiptView receiptView;

        public ViewHolder(View itemView, MessagingTheme messagingTheme) {
            super(itemView);
            Intrinsics.checkNotNullParameter(itemView, "itemView");
            Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
            this.messagingTheme = messagingTheme;
            View viewFindViewById = itemView.findViewById(C1256R.id.zma_message_label);
            Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
            this.labelView = (TextView) viewFindViewById;
            View viewFindViewById2 = itemView.findViewById(C1256R.id.zma_avatar_view);
            Intrinsics.checkNotNullExpressionValue(viewFindViewById2, "findViewById(...)");
            this.avatarView = (AvatarImageView) viewFindViewById2;
            View viewFindViewById3 = itemView.findViewById(C1256R.id.zma_message_content);
            Intrinsics.checkNotNullExpressionValue(viewFindViewById3, "findViewById(...)");
            this.contentView = (LinearLayout) viewFindViewById3;
            View viewFindViewById4 = itemView.findViewById(C1256R.id.zma_message_receipt);
            Intrinsics.checkNotNullExpressionValue(viewFindViewById4, "findViewById(...)");
            this.receiptView = (MessageReceiptView) viewFindViewById4;
        }

        public final void bind(MessageLogEntry.CarouselContainer item, Function1<? super CarouselAction, Unit> onCarouselAction) {
            Intrinsics.checkNotNullParameter(item, "item");
            Intrinsics.checkNotNullParameter(onCarouselAction, "onCarouselAction");
            if (MessageSize.FULL_WIDTH == item.getSize()) {
                this.avatarView.setVisibility(8);
            }
            AdapterDelegatesHelper.INSTANCE.renderLabel$zendesk_messaging_messaging_android(this.labelView, item.getLabel(), item.getMessage().getContent(), this.messagingTheme);
            renderContent(item, onCarouselAction);
            AdapterDelegatesHelper.INSTANCE.renderReceipt$zendesk_messaging_messaging_android(this.receiptView, item.getReceipt(), item.getDirection(), item.getStatus(), (item.getMessage().getContent() instanceof MessageContent.File) || (item.getMessage().getContent() instanceof MessageContent.FileUpload) || (item.getMessage().getContent() instanceof MessageContent.Unsupported) || (item.getMessage().getStatus() instanceof MessageStatus.Failed) || (item.getMessage().getStatus() instanceof MessageStatus.Downloading) || (item.getMessage().getStatus() instanceof MessageStatus.DownloadFailed), item.getMessage().getContent() instanceof MessageContent.Unsupported, item.getMessage().getContent(), this.messagingTheme);
            AdapterDelegatesHelper adapterDelegatesHelper = AdapterDelegatesHelper.INSTANCE;
            View itemView = this.itemView;
            Intrinsics.checkNotNullExpressionValue(itemView, "itemView");
            adapterDelegatesHelper.adjustSpacing$zendesk_messaging_messaging_android(itemView, item.getPosition());
        }

        private final void renderContent(MessageLogEntry.CarouselContainer item, Function1<? super CarouselAction, Unit> onCarouselAction) {
            this.contentView.removeAllViews();
            LinearLayout linearLayout = this.contentView;
            MessageContent content = item.getMessage().getContent();
            Intrinsics.checkNotNull(content, "null cannot be cast to non-null type zendesk.conversationkit.android.model.MessageContent.Carousel");
            int elevatedColor = this.messagingTheme.getElevatedColor();
            int onBackgroundColor = this.messagingTheme.getOnBackgroundColor();
            int onBackgroundColor2 = this.messagingTheme.getOnBackgroundColor();
            int inboundMessageColor = this.messagingTheme.getInboundMessageColor();
            int onActionColor = this.messagingTheme.getOnActionColor();
            int onBackgroundColor3 = this.messagingTheme.getOnBackgroundColor();
            int systemMessageColor = this.messagingTheme.getSystemMessageColor();
            int disabledColor = this.messagingTheme.getDisabledColor();
            int actionColor = this.messagingTheme.getActionColor();
            View viewCreateCarouselCell = createCarouselCell(linearLayout, (MessageContent.Carousel) content, item, elevatedColor, onBackgroundColor, onBackgroundColor2, inboundMessageColor, onActionColor, onBackgroundColor3, this.messagingTheme.getOnBackgroundColor(), systemMessageColor, onCarouselAction, disabledColor, actionColor);
            AdapterDelegatesHelper.INSTANCE.adjustDirectionAndWidth$zendesk_messaging_messaging_android(viewCreateCarouselCell, item.getMessage().getContent(), item.getDirection(), this.contentView);
            this.contentView.addView(viewCreateCarouselCell);
        }

        public final View createCarouselCell(final ViewGroup parentView, final MessageContent.Carousel content, final MessageLogEntry.CarouselContainer container, final int navigationButtonColor, final int navigationIconColor, final int textColor, final int inboundMessageColor, final int buttonTextColor, final int buttonDisabledTextColor, final int focusedStateBorderColor, final int systemMessageColor, final Function1<? super CarouselAction, Unit> carouselItemClickListener, final int disabledBackgroundColor, final int actionBackgroundColor) {
            Context context = parentView.getContext();
            Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
            CarouselCellView carouselCellView = new CarouselCellView(context, null, 0, 6, null);
            Iterator it = CollectionsKt.listOf((Object[]) new Integer[]{Integer.valueOf(C1256R.dimen.zma_cell_inbound_margin_end), Integer.valueOf(R.dimen.zuia_horizontal_spacing_medium), Integer.valueOf(R.dimen.zuia_avatar_image_size)}).iterator();
            final int dimensionPixelSize = 0;
            while (it.hasNext()) {
                dimensionPixelSize += parentView.getResources().getDimensionPixelSize(((Number) it.next()).intValue());
            }
            carouselCellView.render(new Function1<CarouselCellState, CarouselCellState>() {
                {
                    super(1);
                }

                @Override
                public final CarouselCellState invoke(CarouselCellState state) {
                    Intrinsics.checkNotNullParameter(state, "state");
                    return state.copy(this.mapActionsToCarouselItems(parentView, content, carouselItemClickListener), this.avatarImageState(container, inboundMessageColor), new CarouselRendering(navigationButtonColor, navigationIconColor, systemMessageColor, textColor, dimensionPixelSize, inboundMessageColor, buttonTextColor, buttonDisabledTextColor, focusedStateBorderColor, container.getPosition() == MessagePosition.GROUP_BOTTOM || container.getPosition() == MessagePosition.STANDALONE, disabledBackgroundColor, actionBackgroundColor));
                }
            });
            return carouselCellView;
        }

        public final AvatarImageState avatarImageState(MessageLogEntry.CarouselContainer container, int inboundMessageColor) {
            if (container.getAvatarUrl() != null) {
                return new AvatarImageState.Builder().backgroundColor(inboundMessageColor).mask(AvatarMask.CIRCLE).uri(container.getAvatarUrl()).getState();
            }
            return null;
        }

        public final List<CarouselCellData.Item> mapActionsToCarouselItems(ViewGroup parentView, MessageContent.Carousel content, Function1<? super CarouselAction, Unit> carouselItemClickListener) {
            CarouselAction unsupported;
            String string = parentView.getContext().getString(C1256R.string.zuia_carousel_action_not_supported);
            Intrinsics.checkNotNullExpressionValue(string, "getString(...)");
            List<MessageItem> items = content.getItems();
            ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(items, 10));
            for (MessageItem messageItem : items) {
                List<MessageAction> actions = messageItem.getActions();
                ArrayList arrayList2 = new ArrayList(CollectionsKt.collectionSizeOrDefault(actions, 10));
                for (MessageAction messageAction : actions) {
                    if (messageAction instanceof MessageAction.Link) {
                        String id = messageAction.getId();
                        MessageAction.Link link = (MessageAction.Link) messageAction;
                        unsupported = new CarouselAction.Link(id, link.getText(), carouselItemClickListener, link.getUri());
                    } else if (messageAction instanceof MessageAction.Postback) {
                        String id2 = messageAction.getId();
                        MessageAction.Postback postback = (MessageAction.Postback) messageAction;
                        unsupported = new CarouselAction.Postback(id2, postback.getText(), carouselItemClickListener, postback.isLoading());
                    } else if (messageAction instanceof MessageAction.WebView) {
                        String id3 = messageAction.getId();
                        MessageAction.WebView webView = (MessageAction.WebView) messageAction;
                        unsupported = new CarouselAction.WebView(id3, webView.getText(), carouselItemClickListener, webView.getUri(), MessageActionSize.valueOf(webView.getSize().name()));
                    } else {
                        unsupported = new CarouselAction.Unsupported(messageAction.getId(), string, carouselItemClickListener);
                    }
                    arrayList2.add(unsupported);
                }
                arrayList.add(new CarouselCellData.Item(messageItem.getTitle(), messageItem.getDescription(), messageItem.getMediaUrl(), messageItem.getMediaType(), arrayList2));
            }
            return arrayList;
        }
    }
}
