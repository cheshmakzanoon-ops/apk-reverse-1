package zendesk.messaging.android.internal.conversationscreen.delegates;

import android.content.Context;
import android.net.Uri;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.recyclerview.widget.RecyclerView;
import java.util.List;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.android.messaging.UrlSource;
import zendesk.conversationkit.android.model.Message;
import zendesk.conversationkit.android.model.MessageContent;
import zendesk.conversationkit.android.model.MessageStatus;
import zendesk.core.p017ui.android.internal.model.MessageDirection;
import zendesk.messaging.C1256R;
import zendesk.messaging.android.internal.StubUriHandler;
import zendesk.messaging.android.internal.UriHandler;
import zendesk.messaging.android.internal.adapterdelegate.ListItemAdapterDelegate;
import zendesk.messaging.android.internal.conversationscreen.messagelog.MessageLogListenersKt;
import zendesk.messaging.android.internal.extension.ViewKtxKt;
import zendesk.messaging.android.internal.model.MessageLogEntry;
import zendesk.messaging.android.internal.model.MessagingTheme;
import zendesk.p026ui.android.conversation.avatar.AvatarImageView;
import zendesk.p026ui.android.conversation.file.FileRendering;
import zendesk.p026ui.android.conversation.file.FileState;
import zendesk.p026ui.android.conversation.file.FileView;
import zendesk.p026ui.android.conversation.imagecell.ImageCellRendering;
import zendesk.p026ui.android.conversation.imagecell.ImageCellState;
import zendesk.p026ui.android.conversation.imagecell.ImageCellView;
import zendesk.p026ui.android.conversation.receipt.MessageReceiptView;

@Metadata(m17d1 = {"\u0000j\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0010\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010 \n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u00002\u0014\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00040\u0001:\u00010BZ\u0012'\b\u0002\u0010\u0005\u001a!\u0012\u0013\u0012\u00110\u0007¢\u0006\f\b\b\u0012\b\b\t\u0012\u0004\b\b(\n\u0012\u0004\u0012\u00020\u000b0\u0006j\u0002`\f\u0012\b\b\u0002\u0010\r\u001a\u00020\u000e\u0012\u0018\b\u0002\u0010\u000f\u001a\u0012\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\u000b0\u0006j\u0002`\u0010\u0012\u0006\u0010\u0011\u001a\u00020\u0012¢\u0006\u0002\u0010\u0013J&\u0010\"\u001a\u00020#2\u0006\u0010$\u001a\u00020\u00032\f\u0010%\u001a\b\u0012\u0004\u0012\u00020\u00030&2\u0006\u0010'\u001a\u00020(H\u0014J(\u0010)\u001a\u00020\u000b2\u0006\u0010$\u001a\u00020\u00022\u0006\u0010*\u001a\u00020\u00042\u000e\u0010+\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010,0&H\u0014J\u0010\u0010-\u001a\u00020\u00042\u0006\u0010.\u001a\u00020/H\u0016R\u001a\u0010\u0011\u001a\u00020\u0012X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0014\u0010\u0015\"\u0004\b\u0016\u0010\u0017R9\u0010\u0005\u001a!\u0012\u0013\u0012\u00110\u0007¢\u0006\f\b\b\u0012\b\b\t\u0012\u0004\b\b(\n\u0012\u0004\u0012\u00020\u000b0\u0006j\u0002`\fX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0018\u0010\u0019\"\u0004\b\u001a\u0010\u001bR*\u0010\u000f\u001a\u0012\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\u000b0\u0006j\u0002`\u0010X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001c\u0010\u0019\"\u0004\b\u001d\u0010\u001bR\u001a\u0010\r\u001a\u00020\u000eX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001e\u0010\u001f\"\u0004\b \u0010!¨\u00061"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/delegates/FileMessageContainerAdapterDelegate;", "Lzendesk/messaging/android/internal/adapterdelegate/ListItemAdapterDelegate;", "Lzendesk/messaging/android/internal/model/MessageLogEntry$FileMessageContainer;", "Lzendesk/messaging/android/internal/model/MessageLogEntry;", "Lzendesk/messaging/android/internal/conversationscreen/delegates/FileMessageContainerAdapterDelegate$ViewHolder;", "onFailedMessageClicked", "Lkotlin/Function1;", "Lzendesk/conversationkit/android/model/Message;", "Lkotlin/ParameterName;", "name", "message", "", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFailedMessageClickedListener;", "onUriClicked", "Lzendesk/messaging/android/internal/UriHandler;", "onFileAttachmentClicked", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFileAttachmentClicked;", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "(Lkotlin/jvm/functions/Function1;Lzendesk/messaging/android/internal/UriHandler;Lkotlin/jvm/functions/Function1;Lzendesk/messaging/android/internal/model/MessagingTheme;)V", "getMessagingTheme", "()Lzendesk/messaging/android/internal/model/MessagingTheme;", "setMessagingTheme", "(Lzendesk/messaging/android/internal/model/MessagingTheme;)V", "getOnFailedMessageClicked", "()Lkotlin/jvm/functions/Function1;", "setOnFailedMessageClicked", "(Lkotlin/jvm/functions/Function1;)V", "getOnFileAttachmentClicked", "setOnFileAttachmentClicked", "getOnUriClicked", "()Lzendesk/messaging/android/internal/UriHandler;", "setOnUriClicked", "(Lzendesk/messaging/android/internal/UriHandler;)V", "isForViewType", "", "item", "items", "", "position", "", "onBindViewHolder", "holder", "payloads", "", "onCreateViewHolder", "parent", "Landroid/view/ViewGroup;", "ViewHolder", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class FileMessageContainerAdapterDelegate extends ListItemAdapterDelegate<MessageLogEntry.FileMessageContainer, MessageLogEntry, ViewHolder> {
    private MessagingTheme messagingTheme;
    private Function1<? super Message, Unit> onFailedMessageClicked;
    private Function1<? super Message, Unit> onFileAttachmentClicked;
    private UriHandler onUriClicked;

    @Override
    public void onBindViewHolder(Object obj, RecyclerView.ViewHolder viewHolder, List list) {
        onBindViewHolder((MessageLogEntry.FileMessageContainer) obj, (ViewHolder) viewHolder, (List<? extends Object>) list);
    }

    public FileMessageContainerAdapterDelegate(Function1 function1, StubUriHandler stubUriHandler, Function1 function2, MessagingTheme messagingTheme, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? MessageLogListenersKt.getNOOP_ON_MESSAGE_CONTAINER_CLICKED_LISTENER() : function1, (i & 2) != 0 ? StubUriHandler.INSTANCE : stubUriHandler, (i & 4) != 0 ? MessageLogListenersKt.getNOOP_ON_FILE_ATTACHMENT_CLICKED_ACTION() : function2, messagingTheme);
    }

    public final Function1<Message, Unit> getOnFailedMessageClicked() {
        return this.onFailedMessageClicked;
    }

    public final void setOnFailedMessageClicked(Function1<? super Message, Unit> function1) {
        Intrinsics.checkNotNullParameter(function1, "<set-?>");
        this.onFailedMessageClicked = function1;
    }

    public final UriHandler getOnUriClicked() {
        return this.onUriClicked;
    }

    public final void setOnUriClicked(UriHandler uriHandler) {
        Intrinsics.checkNotNullParameter(uriHandler, "<set-?>");
        this.onUriClicked = uriHandler;
    }

    public final Function1<Message, Unit> getOnFileAttachmentClicked() {
        return this.onFileAttachmentClicked;
    }

    public final void setOnFileAttachmentClicked(Function1<? super Message, Unit> function1) {
        Intrinsics.checkNotNullParameter(function1, "<set-?>");
        this.onFileAttachmentClicked = function1;
    }

    public final MessagingTheme getMessagingTheme() {
        return this.messagingTheme;
    }

    public final void setMessagingTheme(MessagingTheme messagingTheme) {
        Intrinsics.checkNotNullParameter(messagingTheme, "<set-?>");
        this.messagingTheme = messagingTheme;
    }

    public FileMessageContainerAdapterDelegate(Function1<? super Message, Unit> onFailedMessageClicked, UriHandler onUriClicked, Function1<? super Message, Unit> onFileAttachmentClicked, MessagingTheme messagingTheme) {
        Intrinsics.checkNotNullParameter(onFailedMessageClicked, "onFailedMessageClicked");
        Intrinsics.checkNotNullParameter(onUriClicked, "onUriClicked");
        Intrinsics.checkNotNullParameter(onFileAttachmentClicked, "onFileAttachmentClicked");
        Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
        this.onFailedMessageClicked = onFailedMessageClicked;
        this.onUriClicked = onUriClicked;
        this.onFileAttachmentClicked = onFileAttachmentClicked;
        this.messagingTheme = messagingTheme;
    }

    @Override
    public boolean isForViewType(MessageLogEntry item, List<? extends MessageLogEntry> items, int position) {
        Intrinsics.checkNotNullParameter(item, "item");
        Intrinsics.checkNotNullParameter(items, "items");
        return item instanceof MessageLogEntry.FileMessageContainer;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent) {
        Intrinsics.checkNotNullParameter(parent, "parent");
        View viewInflate = LayoutInflater.from(parent.getContext()).inflate(C1256R.layout.zma_view_message_log_entry_message_container, parent, false);
        Intrinsics.checkNotNullExpressionValue(viewInflate, "inflate(...)");
        return new ViewHolder(viewInflate, this.messagingTheme);
    }

    protected void onBindViewHolder(MessageLogEntry.FileMessageContainer item, ViewHolder holder, List<? extends Object> payloads) {
        Intrinsics.checkNotNullParameter(item, "item");
        Intrinsics.checkNotNullParameter(holder, "holder");
        Intrinsics.checkNotNullParameter(payloads, "payloads");
        holder.bind(item, this.onFailedMessageClicked, this.onUriClicked, this.onFileAttachmentClicked);
    }

    @Metadata(m17d1 = {"\u0000\u0086\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\n\b\u0000\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J(\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u00102\u0006\u0010\u0014\u001a\u00020\u00102\u0006\u0010\u0015\u001a\u00020\u0010H\u0002JU\u0010\u0016\u001a\u00020\u00172\u0006\u0010\u0011\u001a\u00020\u00122%\u0010\u0018\u001a!\u0012\u0013\u0012\u00110\u001a¢\u0006\f\b\u001b\u0012\b\b\u001c\u0012\u0004\b\b(\u001d\u0012\u0004\u0012\u00020\u00170\u0019j\u0002`\u001e2\u0006\u0010\u001f\u001a\u00020 2\u0016\u0010!\u001a\u0012\u0012\u0004\u0012\u00020\u001a\u0012\u0004\u0012\u00020\u00170\u0019j\u0002`\"JJ\u0010#\u001a\u00020\u00032\u0006\u0010$\u001a\u00020%2\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010&\u001a\u00020'2\b\b\u0001\u0010(\u001a\u00020\u00102\b\b\u0001\u0010\u000f\u001a\u00020\u00102\u0014\b\u0002\u0010)\u001a\u000e\u0012\u0004\u0012\u00020*\u0012\u0004\u0012\u00020\u00170\u0019H\u0002J\\\u0010+\u001a\u00020\u00032\u0006\u0010,\u001a\u00020-2\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010&\u001a\u00020'2\u0012\u0010\u0018\u001a\u000e\u0012\u0004\u0012\u00020\u001a\u0012\u0004\u0012\u00020\u00170\u00192\b\b\u0002\u0010.\u001a\u00020 2\b\b\u0001\u0010(\u001a\u00020\u00102\b\b\u0001\u0010\u000f\u001a\u00020\u00102\b\b\u0001\u0010/\u001a\u00020\u0010H\u0002JH\u00100\u001a\u00020\u00032\u0006\u00101\u001a\u00020-2\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010&\u001a\u00020'2\b\b\u0001\u0010(\u001a\u00020\u00102\b\b\u0001\u0010\u000f\u001a\u00020\u00102\u0012\u0010\u0018\u001a\u000e\u0012\u0004\u0012\u00020\u001a\u0012\u0004\u0012\u00020\u00170\u0019H\u0002JW\u00102\u001a\u00020\u00172\u0006\u0010\u0011\u001a\u00020\u00122%\u0010\u0018\u001a!\u0012\u0013\u0012\u00110\u001a¢\u0006\f\b\u001b\u0012\b\b\u001c\u0012\u0004\b\b(\u001d\u0012\u0004\u0012\u00020\u00170\u0019j\u0002`\u001e2\u0006\u0010\u001f\u001a\u00020 2\u0016\u0010!\u001a\u0012\u0012\u0004\u0012\u00020\u001a\u0012\u0004\u0012\u00020\u00170\u0019j\u0002`\"H\u0002J(\u0010(\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u00103\u001a\u00020\u00102\u0006\u00104\u001a\u00020\u00102\u0006\u00105\u001a\u00020\u0010H\u0002JR\u00106\u001a!\u0012\u0013\u0012\u00110\u001a¢\u0006\f\b\u001b\u0012\b\b\u001c\u0012\u0004\b\b(\u001d\u0012\u0004\u0012\u00020\u00170\u0019j\u0002`\u001e*\u00020\u00122%\u0010\u0018\u001a!\u0012\u0013\u0012\u00110\u001a¢\u0006\f\b\u001b\u0012\b\b\u001c\u0012\u0004\b\b(\u001d\u0012\u0004\u0012\u00020\u00170\u0019j\u0002`\u001eH\u0002R\u000e\u0010\u0007\u001a\u00020\bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\t\u001a\u00020\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000b\u001a\u00020\fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\r\u001a\u00020\u000eX\u0082\u0004¢\u0006\u0002\n\u0000¨\u00067"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/delegates/FileMessageContainerAdapterDelegate$ViewHolder;", "Landroidx/recyclerview/widget/RecyclerView$ViewHolder;", "itemView", "Landroid/view/View;", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "(Landroid/view/View;Lzendesk/messaging/android/internal/model/MessagingTheme;)V", "avatarView", "Lzendesk/ui/android/conversation/avatar/AvatarImageView;", "contentView", "Landroid/widget/LinearLayout;", "labelView", "Landroid/widget/TextView;", "receiptView", "Lzendesk/ui/android/conversation/receipt/MessageReceiptView;", "backgroundColor", "", "item", "Lzendesk/messaging/android/internal/model/MessageLogEntry$FileMessageContainer;", "inboundMessageColor", "outboundMessageColor", "dangerColor", "bind", "", "onFailedMessageClicked", "Lkotlin/Function1;", "Lzendesk/conversationkit/android/model/Message;", "Lkotlin/ParameterName;", "name", "message", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFailedMessageClickedListener;", "onUriClicked", "Lzendesk/messaging/android/internal/UriHandler;", "onFileAttachmentClicked", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFileAttachmentClicked;", "createFileCell", "fileContent", "Lzendesk/conversationkit/android/model/MessageContent$File;", "parentView", "Landroid/view/ViewGroup;", "textAndIconColor", "onFileClicked", "", "createFileImageUploadCell", "content", "Lzendesk/conversationkit/android/model/MessageContent$FileUpload;", "uriHandler", "errorColor", "createFileUploadCell", "uploadContent", "renderContent", "inboundMessageTextColor", "dangerTextColor", "outboundMessageTextColor", "clickListener", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
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

        public final void bind(MessageLogEntry.FileMessageContainer item, Function1<? super Message, Unit> onFailedMessageClicked, UriHandler onUriClicked, Function1<? super Message, Unit> onFileAttachmentClicked) {
            Intrinsics.checkNotNullParameter(item, "item");
            Intrinsics.checkNotNullParameter(onFailedMessageClicked, "onFailedMessageClicked");
            Intrinsics.checkNotNullParameter(onUriClicked, "onUriClicked");
            Intrinsics.checkNotNullParameter(onFileAttachmentClicked, "onFileAttachmentClicked");
            AdapterDelegatesHelper.INSTANCE.renderLabel$zendesk_messaging_messaging_android(this.labelView, item.getLabel(), item.getMessage().getContent(), this.messagingTheme);
            AdapterDelegatesHelper.INSTANCE.renderAvatar$zendesk_messaging_messaging_android(this.avatarView, item.getAvatarUrl(), item.getMessage().getContent(), item.getSize(), item.getDirection(), this.messagingTheme);
            renderContent(item, onFailedMessageClicked, onUriClicked, onFileAttachmentClicked);
            AdapterDelegatesHelper.INSTANCE.renderReceipt$zendesk_messaging_messaging_android(this.receiptView, item.getReceipt(), item.getDirection(), item.getStatus(), (item.getMessage().getContent() instanceof MessageContent.File) || (item.getMessage().getContent() instanceof MessageContent.FileUpload) || (item.getMessage().getContent() instanceof MessageContent.Unsupported) || (item.getMessage().getStatus() instanceof MessageStatus.Failed) || (item.getMessage().getStatus() instanceof MessageStatus.Downloading) || (item.getMessage().getStatus() instanceof MessageStatus.DownloadFailed), item.getMessage().getContent() instanceof MessageContent.Unsupported, item.getMessage().getContent(), this.messagingTheme);
            AdapterDelegatesHelper adapterDelegatesHelper = AdapterDelegatesHelper.INSTANCE;
            View itemView = this.itemView;
            Intrinsics.checkNotNullExpressionValue(itemView, "itemView");
            adapterDelegatesHelper.adjustSpacing$zendesk_messaging_messaging_android(itemView, item.getPosition());
        }

        private final void renderContent(final MessageLogEntry.FileMessageContainer item, Function1<? super Message, Unit> onFailedMessageClicked, UriHandler onUriClicked, final Function1<? super Message, Unit> onFileAttachmentClicked) {
            View viewCreateFileUploadCell;
            this.contentView.removeAllViews();
            int iTextAndIconColor = textAndIconColor(item, this.messagingTheme.getOnBackgroundColor(), this.messagingTheme.getOnDangerColor(), this.messagingTheme.getOnMessageColor());
            int iBackgroundColor = backgroundColor(item, this.messagingTheme.getInboundMessageColor(), this.messagingTheme.getMessageColor(), ViewKtxKt.adjustAlpha$default(this.messagingTheme.getDangerColor(), 0.0f, 1, null));
            MessageContent content = item.getMessage().getContent();
            if (content instanceof MessageContent.File) {
                MessageContent content2 = item.getMessage().getContent();
                Intrinsics.checkNotNull(content2, "null cannot be cast to non-null type zendesk.conversationkit.android.model.MessageContent.File");
                viewCreateFileUploadCell = createFileCell((MessageContent.File) content2, item, this.contentView, iTextAndIconColor, iBackgroundColor, new Function1<String, Unit>() {
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
                        onFileAttachmentClicked.invoke(item.getMessage());
                    }
                });
            } else {
                if (!(content instanceof MessageContent.FileUpload)) {
                    return;
                }
                MessageContent content3 = item.getMessage().getContent();
                Intrinsics.checkNotNull(content3, "null cannot be cast to non-null type zendesk.conversationkit.android.model.MessageContent.FileUpload");
                if (((MessageContent.FileUpload) content3).isImageMimeType()) {
                    MessageContent content4 = item.getMessage().getContent();
                    Intrinsics.checkNotNull(content4, "null cannot be cast to non-null type zendesk.conversationkit.android.model.MessageContent.FileUpload");
                    viewCreateFileUploadCell = createFileImageUploadCell((MessageContent.FileUpload) content4, item, this.contentView, onFailedMessageClicked, onUriClicked, iTextAndIconColor, iBackgroundColor, this.messagingTheme.getOnDangerColor());
                } else {
                    MessageContent content5 = item.getMessage().getContent();
                    Intrinsics.checkNotNull(content5, "null cannot be cast to non-null type zendesk.conversationkit.android.model.MessageContent.FileUpload");
                    viewCreateFileUploadCell = createFileUploadCell((MessageContent.FileUpload) content5, item, this.contentView, iTextAndIconColor, iBackgroundColor, clickListener(item, onFailedMessageClicked));
                }
            }
            AdapterDelegatesHelper.INSTANCE.adjustDirectionAndWidth$zendesk_messaging_messaging_android(viewCreateFileUploadCell, item.getMessage().getContent(), item.getDirection(), this.contentView);
            this.contentView.addView(viewCreateFileUploadCell);
        }

        private final Function1<Message, Unit> clickListener(MessageLogEntry.FileMessageContainer fileMessageContainer, Function1<? super Message, Unit> function1) {
            return fileMessageContainer.getMessage().getStatus() instanceof MessageStatus.Failed ? function1 : MessageLogListenersKt.getNOOP_ON_MESSAGE_CONTAINER_CLICKED_LISTENER();
        }

        static View createFileCell$default(ViewHolder viewHolder, MessageContent.File file, MessageLogEntry.FileMessageContainer fileMessageContainer, ViewGroup viewGroup, int i, int i2, Function1 function1, int i3, Object obj) {
            if ((i3 & 32) != 0) {
                function1 = new Function1<String, Unit>() {
                    public final void invoke2(String it) {
                        Intrinsics.checkNotNullParameter(it, "it");
                    }

                    @Override
                    public Unit invoke(String str) {
                        invoke2(str);
                        return Unit.INSTANCE;
                    }
                };
            }
            return viewHolder.createFileCell(file, fileMessageContainer, viewGroup, i, i2, function1);
        }

        private final View createFileCell(final MessageContent.File fileContent, final MessageLogEntry.FileMessageContainer item, ViewGroup parentView, final int textAndIconColor, final int backgroundColor, final Function1<? super String, Unit> onFileClicked) {
            Context context = parentView.getContext();
            Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
            FileView fileView = new FileView(context, null, 0, 0, 14, null);
            fileView.render(new Function1<FileRendering, FileRendering>() {
                {
                    super(1);
                }

                @Override
                public final FileRendering invoke(FileRendering fileRendering) {
                    Intrinsics.checkNotNullParameter(fileRendering, "fileRendering");
                    FileRendering.Builder builder = fileRendering.toBuilder();
                    final MessageContent.File file = fileContent;
                    final int i = textAndIconColor;
                    final int i2 = backgroundColor;
                    final MessageLogEntry.FileMessageContainer fileMessageContainer = item;
                    FileRendering.Builder builderState = builder.state(new Function1<FileState, FileState>() {
                        {
                            super(1);
                        }

                        @Override
                        public final FileState invoke(FileState state) {
                            Intrinsics.checkNotNullParameter(state, "state");
                            String altText = file.getAltText();
                            long mediaSize = file.getMediaSize();
                            int i3 = i;
                            return state.copy(altText, mediaSize, i3, i3, i2, Integer.valueOf(AdapterDelegatesHelper.INSTANCE.getCellDrawable$zendesk_messaging_messaging_android(fileMessageContainer.getShape(), fileMessageContainer.getDirection())));
                        }
                    });
                    final MessageLogEntry.FileMessageContainer fileMessageContainer2 = item;
                    final Function1<String, Unit> function1 = onFileClicked;
                    final MessageContent.File file2 = fileContent;
                    return builderState.onCellClicked(new Function0<Unit>() {
                        {
                            super(0);
                        }

                        @Override
                        public Unit invoke() {
                            invoke2();
                            return Unit.INSTANCE;
                        }

                        public final void invoke2() {
                            if ((fileMessageContainer2.getStatus() instanceof MessageStatus.Sent) || (fileMessageContainer2.getStatus() instanceof MessageStatus.DownloadFailed)) {
                                function1.invoke(file2.getMediaUrl());
                            }
                        }
                    }).build();
                }
            });
            return fileView;
        }

        private final View createFileUploadCell(final MessageContent.FileUpload uploadContent, final MessageLogEntry.FileMessageContainer item, ViewGroup parentView, final int textAndIconColor, final int backgroundColor, final Function1<? super Message, Unit> onFailedMessageClicked) {
            Context context = parentView.getContext();
            Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
            FileView fileView = new FileView(context, null, 0, 0, 14, null);
            fileView.render(new Function1<FileRendering, FileRendering>() {
                {
                    super(1);
                }

                @Override
                public final FileRendering invoke(FileRendering fileRendering) {
                    Intrinsics.checkNotNullParameter(fileRendering, "fileRendering");
                    FileRendering.Builder builder = fileRendering.toBuilder();
                    final MessageContent.FileUpload fileUpload = uploadContent;
                    final int i = textAndIconColor;
                    final int i2 = backgroundColor;
                    final MessageLogEntry.FileMessageContainer fileMessageContainer = item;
                    FileRendering.Builder builderState = builder.state(new Function1<FileState, FileState>() {
                        {
                            super(1);
                        }

                        @Override
                        public final FileState invoke(FileState state) {
                            Intrinsics.checkNotNullParameter(state, "state");
                            String name = fileUpload.getName();
                            long size = fileUpload.getSize();
                            int i3 = i;
                            return state.copy(name, size, i3, i3, i2, Integer.valueOf(AdapterDelegatesHelper.INSTANCE.getCellDrawable$zendesk_messaging_messaging_android(fileMessageContainer.getShape(), fileMessageContainer.getDirection())));
                        }
                    });
                    final MessageLogEntry.FileMessageContainer fileMessageContainer2 = item;
                    final Function1<Message, Unit> function1 = onFailedMessageClicked;
                    return builderState.onCellClicked(new Function0<Unit>() {
                        {
                            super(0);
                        }

                        @Override
                        public Unit invoke() {
                            invoke2();
                            return Unit.INSTANCE;
                        }

                        public final void invoke2() {
                            if (fileMessageContainer2.getStatus() instanceof MessageStatus.Failed) {
                                function1.invoke(fileMessageContainer2.getMessage());
                            }
                        }
                    }).build();
                }
            });
            return fileView;
        }

        public final View createFileImageUploadCell(final MessageContent.FileUpload content, final MessageLogEntry.FileMessageContainer item, ViewGroup parentView, final Function1<? super Message, Unit> onFailedMessageClicked, final UriHandler uriHandler, final int textAndIconColor, final int backgroundColor, final int errorColor) {
            Context context = parentView.getContext();
            Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
            ImageCellView imageCellView = new ImageCellView(context, null, 0, 6, null);
            imageCellView.render(new Function1<ImageCellRendering, ImageCellRendering>() {
                {
                    super(1);
                }

                @Override
                public final ImageCellRendering invoke(ImageCellRendering imageCellRendering) {
                    Intrinsics.checkNotNullParameter(imageCellRendering, "imageCellRendering");
                    ImageCellRendering.Builder builder = imageCellRendering.toBuilder();
                    final MessageContent.FileUpload fileUpload = content;
                    final MessageLogEntry.FileMessageContainer fileMessageContainer = item;
                    final int i = textAndIconColor;
                    final int i2 = errorColor;
                    final int i3 = backgroundColor;
                    ImageCellRendering.Builder builderState = builder.state(new Function1<ImageCellState, ImageCellState>() {
                        {
                            super(1);
                        }

                        @Override
                        public final ImageCellState invoke(ImageCellState state) {
                            Intrinsics.checkNotNullParameter(state, "state");
                            return ImageCellState.copy$default(state, Uri.parse(fileUpload.getUri()), Uri.parse(fileUpload.getUri()), fileUpload.getMimeType(), null, fileMessageContainer.getStatus() instanceof MessageStatus.Failed, fileMessageContainer.getStatus() instanceof MessageStatus.Pending, null, i, i2, 0, i3, 0, 0, null, AdapterDelegatesHelper.INSTANCE.getImageCellDirection$zendesk_messaging_messaging_android(fileMessageContainer.getShape(), fileMessageContainer.getDirection()), null, 47688, null);
                        }
                    });
                    final MessageLogEntry.FileMessageContainer fileMessageContainer2 = item;
                    final Function1<Message, Unit> function1 = onFailedMessageClicked;
                    final UriHandler uriHandler2 = uriHandler;
                    final MessageContent.FileUpload fileUpload2 = content;
                    return builderState.onImageCellClicked(new Function1<String, Unit>() {
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
                            if (fileMessageContainer2.getStatus() instanceof MessageStatus.Failed) {
                                function1.invoke(fileMessageContainer2.getMessage());
                            } else if (fileMessageContainer2.getStatus() instanceof MessageStatus.Sent) {
                                uriHandler2.onUriClicked(fileUpload2.getUri(), UrlSource.IMAGE, false);
                            }
                        }
                    }).build();
                }
            });
            return (View) imageCellView;
        }

        private final int backgroundColor(MessageLogEntry.FileMessageContainer item, int inboundMessageColor, int outboundMessageColor, int dangerColor) {
            if (item.getDirection() == MessageDirection.INBOUND) {
                if (!(item.getStatus() instanceof MessageStatus.DownloadFailed)) {
                    return inboundMessageColor;
                }
            } else {
                MessageStatus status = item.getStatus();
                if (status instanceof MessageStatus.Pending) {
                    return ViewKtxKt.adjustAlpha$default(outboundMessageColor, 0.0f, 1, null);
                }
                if (status instanceof MessageStatus.Sent ? true : status instanceof MessageStatus.Downloading) {
                    return outboundMessageColor;
                }
                if (!(status instanceof MessageStatus.Failed ? true : status instanceof MessageStatus.DownloadFailed)) {
                    throw new NoWhenBranchMatchedException();
                }
            }
            return dangerColor;
        }

        private final int textAndIconColor(MessageLogEntry.FileMessageContainer item, int inboundMessageTextColor, int dangerTextColor, int outboundMessageTextColor) {
            if (item.getDirection() == MessageDirection.INBOUND) {
                if (!(item.getStatus() instanceof MessageStatus.DownloadFailed)) {
                    return inboundMessageTextColor;
                }
            } else {
                if (item.getDirection() == MessageDirection.OUTBOUND && (item.getStatus() instanceof MessageStatus.Sent)) {
                    return outboundMessageTextColor;
                }
                if (!(item.getStatus() instanceof MessageStatus.Failed) && !(item.getStatus() instanceof MessageStatus.DownloadFailed)) {
                    return ViewKtxKt.adjustAlpha$default(outboundMessageTextColor, 0.0f, 1, null);
                }
            }
            return dangerTextColor;
        }
    }
}
