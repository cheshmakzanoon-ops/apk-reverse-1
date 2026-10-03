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
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.StringsKt;
import zendesk.android.messaging.UrlSource;
import zendesk.conversationkit.android.model.Message;
import zendesk.conversationkit.android.model.MessageContent;
import zendesk.conversationkit.android.model.MessageKt;
import zendesk.conversationkit.android.model.MessageStatus;
import zendesk.core.p017ui.android.internal.model.MessageActionSize;
import zendesk.core.p017ui.android.internal.model.MessageDirection;
import zendesk.messaging.C1256R;
import zendesk.messaging.android.internal.StubUriHandler;
import zendesk.messaging.android.internal.StubWebViewUriHandler;
import zendesk.messaging.android.internal.UriHandler;
import zendesk.messaging.android.internal.WebViewUriHandler;
import zendesk.messaging.android.internal.adapterdelegate.ListItemAdapterDelegate;
import zendesk.messaging.android.internal.conversationscreen.messagelog.MessageLogListenersKt;
import zendesk.messaging.android.internal.extension.ViewKtxKt;
import zendesk.messaging.android.internal.model.MessageLogEntry;
import zendesk.messaging.android.internal.model.MessageSize;
import zendesk.messaging.android.internal.model.MessagingTheme;
import zendesk.p026ui.android.conversation.avatar.AvatarImageView;
import zendesk.p026ui.android.conversation.file.FileRendering;
import zendesk.p026ui.android.conversation.file.FileState;
import zendesk.p026ui.android.conversation.file.FileView;
import zendesk.p026ui.android.conversation.imagecell.ImageCellDirection;
import zendesk.p026ui.android.conversation.imagecell.ImageCellRendering;
import zendesk.p026ui.android.conversation.imagecell.ImageCellState;
import zendesk.p026ui.android.conversation.imagecell.ImageCellView;
import zendesk.p026ui.android.conversation.imagecell.ImageType;
import zendesk.p026ui.android.conversation.receipt.MessageReceiptView;

@Metadata(m17d1 = {"\u0000x\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0016\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010 \n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u00002\u0014\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00040\u0001:\u0001:Bj\u0012\b\b\u0002\u0010\u0005\u001a\u00020\u0006\u0012\b\b\u0002\u0010\u0007\u001a\u00020\b\u0012\u0006\u0010\t\u001a\u00020\n\u0012\u001e\b\u0002\u0010\u000b\u001a\u0018\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\u000e0\fj\u0002`\u000f\u0012'\b\u0002\u0010\u0010\u001a!\u0012\u0013\u0012\u00110\u0012¢\u0006\f\b\u0013\u0012\b\b\u0014\u0012\u0004\b\b(\u0015\u0012\u0004\u0012\u00020\u000e0\u0011j\u0002`\u0016¢\u0006\u0002\u0010\u0017J&\u0010,\u001a\u00020-2\u0006\u0010.\u001a\u00020\u00032\f\u0010/\u001a\b\u0012\u0004\u0012\u00020\u0003002\u0006\u00101\u001a\u000202H\u0014J(\u00103\u001a\u00020\u000e2\u0006\u0010.\u001a\u00020\u00022\u0006\u00104\u001a\u00020\u00042\u000e\u00105\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010600H\u0014J\u0010\u00107\u001a\u00020\u00042\u0006\u00108\u001a\u000209H\u0016R\u001a\u0010\t\u001a\u00020\nX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0018\u0010\u0019\"\u0004\b\u001a\u0010\u001bR9\u0010\u0010\u001a!\u0012\u0013\u0012\u00110\u0012¢\u0006\f\b\u0013\u0012\b\b\u0014\u0012\u0004\b\b(\u0015\u0012\u0004\u0012\u00020\u000e0\u0011j\u0002`\u0016X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001c\u0010\u001d\"\u0004\b\u001e\u0010\u001fR0\u0010\u000b\u001a\u0018\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\u000e0\fj\u0002`\u000fX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b \u0010!\"\u0004\b\"\u0010#R\u001a\u0010\u0005\u001a\u00020\u0006X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b$\u0010%\"\u0004\b&\u0010'R\u001a\u0010\u0007\u001a\u00020\bX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b(\u0010)\"\u0004\b*\u0010+¨\u0006;"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/delegates/ImageMessageContainerAdapterDelegate;", "Lzendesk/messaging/android/internal/adapterdelegate/ListItemAdapterDelegate;", "Lzendesk/messaging/android/internal/model/MessageLogEntry$ImageMessageContainer;", "Lzendesk/messaging/android/internal/model/MessageLogEntry;", "Lzendesk/messaging/android/internal/conversationscreen/delegates/ImageMessageContainerAdapterDelegate$ViewHolder;", "onUriClicked", "Lzendesk/messaging/android/internal/UriHandler;", "onWebViewUriClicked", "Lzendesk/messaging/android/internal/WebViewUriHandler;", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "onSendPostbackMessage", "Lkotlin/Function2;", "", "", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnSendPostbackMessage;", "onFailedMessageClicked", "Lkotlin/Function1;", "Lzendesk/conversationkit/android/model/Message;", "Lkotlin/ParameterName;", "name", "message", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFailedMessageClickedListener;", "(Lzendesk/messaging/android/internal/UriHandler;Lzendesk/messaging/android/internal/WebViewUriHandler;Lzendesk/messaging/android/internal/model/MessagingTheme;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function1;)V", "getMessagingTheme", "()Lzendesk/messaging/android/internal/model/MessagingTheme;", "setMessagingTheme", "(Lzendesk/messaging/android/internal/model/MessagingTheme;)V", "getOnFailedMessageClicked", "()Lkotlin/jvm/functions/Function1;", "setOnFailedMessageClicked", "(Lkotlin/jvm/functions/Function1;)V", "getOnSendPostbackMessage", "()Lkotlin/jvm/functions/Function2;", "setOnSendPostbackMessage", "(Lkotlin/jvm/functions/Function2;)V", "getOnUriClicked", "()Lzendesk/messaging/android/internal/UriHandler;", "setOnUriClicked", "(Lzendesk/messaging/android/internal/UriHandler;)V", "getOnWebViewUriClicked", "()Lzendesk/messaging/android/internal/WebViewUriHandler;", "setOnWebViewUriClicked", "(Lzendesk/messaging/android/internal/WebViewUriHandler;)V", "isForViewType", "", "item", "items", "", "position", "", "onBindViewHolder", "holder", "payloads", "", "onCreateViewHolder", "parent", "Landroid/view/ViewGroup;", "ViewHolder", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ImageMessageContainerAdapterDelegate extends ListItemAdapterDelegate<MessageLogEntry.ImageMessageContainer, MessageLogEntry, ViewHolder> {
    private MessagingTheme messagingTheme;
    private Function1<? super Message, Unit> onFailedMessageClicked;
    private Function2<? super String, ? super String, Unit> onSendPostbackMessage;
    private UriHandler onUriClicked;
    private WebViewUriHandler onWebViewUriClicked;

    @Override
    public void onBindViewHolder(Object obj, RecyclerView.ViewHolder viewHolder, List list) {
        onBindViewHolder((MessageLogEntry.ImageMessageContainer) obj, (ViewHolder) viewHolder, (List<? extends Object>) list);
    }

    public ImageMessageContainerAdapterDelegate(StubUriHandler stubUriHandler, StubWebViewUriHandler stubWebViewUriHandler, MessagingTheme messagingTheme, Function2 function2, Function1 function1, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? StubUriHandler.INSTANCE : stubUriHandler, (i & 2) != 0 ? StubWebViewUriHandler.INSTANCE : stubWebViewUriHandler, messagingTheme, (i & 8) != 0 ? MessageLogListenersKt.getNOOP_ON_SEND_POSTBACK_MESSAGE() : function2, (i & 16) != 0 ? MessageLogListenersKt.getNOOP_ON_MESSAGE_CONTAINER_CLICKED_LISTENER() : function1);
    }

    public final UriHandler getOnUriClicked() {
        return this.onUriClicked;
    }

    public final void setOnUriClicked(UriHandler uriHandler) {
        Intrinsics.checkNotNullParameter(uriHandler, "<set-?>");
        this.onUriClicked = uriHandler;
    }

    public final WebViewUriHandler getOnWebViewUriClicked() {
        return this.onWebViewUriClicked;
    }

    public final void setOnWebViewUriClicked(WebViewUriHandler webViewUriHandler) {
        Intrinsics.checkNotNullParameter(webViewUriHandler, "<set-?>");
        this.onWebViewUriClicked = webViewUriHandler;
    }

    public final MessagingTheme getMessagingTheme() {
        return this.messagingTheme;
    }

    public final void setMessagingTheme(MessagingTheme messagingTheme) {
        Intrinsics.checkNotNullParameter(messagingTheme, "<set-?>");
        this.messagingTheme = messagingTheme;
    }

    public final Function2<String, String, Unit> getOnSendPostbackMessage() {
        return this.onSendPostbackMessage;
    }

    public final void setOnSendPostbackMessage(Function2<? super String, ? super String, Unit> function2) {
        Intrinsics.checkNotNullParameter(function2, "<set-?>");
        this.onSendPostbackMessage = function2;
    }

    public final Function1<Message, Unit> getOnFailedMessageClicked() {
        return this.onFailedMessageClicked;
    }

    public final void setOnFailedMessageClicked(Function1<? super Message, Unit> function1) {
        Intrinsics.checkNotNullParameter(function1, "<set-?>");
        this.onFailedMessageClicked = function1;
    }

    public ImageMessageContainerAdapterDelegate(UriHandler onUriClicked, WebViewUriHandler onWebViewUriClicked, MessagingTheme messagingTheme, Function2<? super String, ? super String, Unit> onSendPostbackMessage, Function1<? super Message, Unit> onFailedMessageClicked) {
        Intrinsics.checkNotNullParameter(onUriClicked, "onUriClicked");
        Intrinsics.checkNotNullParameter(onWebViewUriClicked, "onWebViewUriClicked");
        Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
        Intrinsics.checkNotNullParameter(onSendPostbackMessage, "onSendPostbackMessage");
        Intrinsics.checkNotNullParameter(onFailedMessageClicked, "onFailedMessageClicked");
        this.onUriClicked = onUriClicked;
        this.onWebViewUriClicked = onWebViewUriClicked;
        this.messagingTheme = messagingTheme;
        this.onSendPostbackMessage = onSendPostbackMessage;
        this.onFailedMessageClicked = onFailedMessageClicked;
    }

    @Override
    public boolean isForViewType(MessageLogEntry item, List<? extends MessageLogEntry> items, int position) {
        Intrinsics.checkNotNullParameter(item, "item");
        Intrinsics.checkNotNullParameter(items, "items");
        return item instanceof MessageLogEntry.ImageMessageContainer;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent) {
        Intrinsics.checkNotNullParameter(parent, "parent");
        View viewInflate = LayoutInflater.from(parent.getContext()).inflate(C1256R.layout.zma_view_message_log_entry_message_container, parent, false);
        Intrinsics.checkNotNullExpressionValue(viewInflate, "inflate(...)");
        return new ViewHolder(viewInflate, this.messagingTheme);
    }

    protected void onBindViewHolder(MessageLogEntry.ImageMessageContainer item, ViewHolder holder, List<? extends Object> payloads) {
        Intrinsics.checkNotNullParameter(item, "item");
        Intrinsics.checkNotNullParameter(holder, "holder");
        Intrinsics.checkNotNullParameter(payloads, "payloads");
        holder.bind(item, this.onUriClicked, this.onWebViewUriClicked, this.onSendPostbackMessage, this.onFailedMessageClicked);
    }

    @Metadata(m17d1 = {"\u0000\u0092\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\b\b\u0000\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006Jc\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u00162\u001c\u0010\u0017\u001a\u0018\u0012\u0004\u0012\u00020\u0019\u0012\u0004\u0012\u00020\u0019\u0012\u0004\u0012\u00020\u00100\u0018j\u0002`\u001a2%\u0010\u001b\u001a!\u0012\u0013\u0012\u00110\u001d¢\u0006\f\b\u001e\u0012\b\b\u001f\u0012\u0004\b\b( \u0012\u0004\u0012\u00020\u00100\u001cj\u0002`!J~\u0010\"\u001a\u00020\u00032\u0006\u0010#\u001a\u00020$2\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010%\u001a\u00020&2\b\b\u0001\u0010'\u001a\u00020(2\b\b\u0001\u0010)\u001a\u00020(2\b\b\u0001\u0010*\u001a\u00020(2\b\b\u0001\u0010+\u001a\u00020(2\b\b\u0001\u0010,\u001a\u00020(2\u0014\b\u0002\u0010-\u001a\u000e\u0012\u0004\u0012\u00020\u0019\u0012\u0004\u0012\u00020\u00100\u001c2\u0014\b\u0002\u0010\u001b\u001a\u000e\u0012\u0004\u0012\u00020\u001d\u0012\u0004\u0012\u00020\u00100\u001cH\u0002JÞ\u0001\u0010.\u001a\u00020\u00032\u0006\u0010#\u001a\u00020$2\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010%\u001a\u00020&2\b\b\u0002\u0010\u0013\u001a\u00020\u00142\b\b\u0001\u0010'\u001a\u00020(2\b\b\u0001\u0010)\u001a\u00020(2\b\b\u0001\u0010/\u001a\u00020(2\b\b\u0001\u00100\u001a\u00020(2\b\b\u0001\u00101\u001a\u00020(2\b\b\u0001\u00102\u001a\u00020(2\b\b\u0001\u0010*\u001a\u00020(2\b\b\u0001\u0010+\u001a\u00020(2\u001c\u0010\u0017\u001a\u0018\u0012\u0004\u0012\u00020\u0019\u0012\u0004\u0012\u00020\u0019\u0012\u0004\u0012\u00020\u00100\u0018j\u0002`\u001a2\u0014\b\u0002\u0010\u001b\u001a\u000e\u0012\u0004\u0012\u00020\u001d\u0012\u0004\u0012\u00020\u00100\u001c2$\b\u0002\u00103\u001a\u001e\u0012\u0004\u0012\u00020\u0019\u0012\u0004\u0012\u000205\u0012\u0004\u0012\u00020\u0019\u0012\u0004\u0012\u00020\u001004j\u0002`62\b\u00107\u001a\u0004\u0018\u00010\u0019H\u0002J \u00108\u001a\u00020\u00102\u0006\u00109\u001a\u00020\u00192\u0006\u0010:\u001a\u00020\u00142\u0006\u0010;\u001a\u00020\u0019H\u0002Jo\u0010<\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u00162\u001c\u0010\u0017\u001a\u0018\u0012\u0004\u0012\u00020\u0019\u0012\u0004\u0012\u00020\u0019\u0012\u0004\u0012\u00020\u00100\u0018j\u0002`\u001a2%\u0010\u001b\u001a!\u0012\u0013\u0012\u00110\u001d¢\u0006\f\b\u001e\u0012\b\b\u001f\u0012\u0004\b\b( \u0012\u0004\u0012\u00020\u00100\u001cj\u0002`!2\b\u00107\u001a\u0004\u0018\u00010\u0019H\u0002JR\u0010=\u001a!\u0012\u0013\u0012\u00110\u001d¢\u0006\f\b\u001e\u0012\b\b\u001f\u0012\u0004\b\b( \u0012\u0004\u0012\u00020\u00100\u001cj\u0002`!*\u00020\u00122%\u0010\u001b\u001a!\u0012\u0013\u0012\u00110\u001d¢\u0006\f\b\u001e\u0012\b\b\u001f\u0012\u0004\b\b( \u0012\u0004\u0012\u00020\u00100\u001cj\u0002`!H\u0002R\u000e\u0010\u0007\u001a\u00020\bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\t\u001a\u00020\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000b\u001a\u00020\fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\r\u001a\u00020\u000eX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006>"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/delegates/ImageMessageContainerAdapterDelegate$ViewHolder;", "Landroidx/recyclerview/widget/RecyclerView$ViewHolder;", "itemView", "Landroid/view/View;", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "(Landroid/view/View;Lzendesk/messaging/android/internal/model/MessagingTheme;)V", "avatarView", "Lzendesk/ui/android/conversation/avatar/AvatarImageView;", "contentView", "Landroid/widget/LinearLayout;", "labelView", "Landroid/widget/TextView;", "receiptView", "Lzendesk/ui/android/conversation/receipt/MessageReceiptView;", "bind", "", "item", "Lzendesk/messaging/android/internal/model/MessageLogEntry$ImageMessageContainer;", "onUriClicked", "Lzendesk/messaging/android/internal/UriHandler;", "onWebViewUriClicked", "Lzendesk/messaging/android/internal/WebViewUriHandler;", "onSendPostbackMessage", "Lkotlin/Function2;", "", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnSendPostbackMessage;", "onFailedMessageClicked", "Lkotlin/Function1;", "Lzendesk/conversationkit/android/model/Message;", "Lkotlin/ParameterName;", "name", "message", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFailedMessageClickedListener;", "createFileView", "content", "Lzendesk/conversationkit/android/model/MessageContent$Image;", "parentView", "Landroid/view/ViewGroup;", "outboundMessageColor", "", "outboundMessageTextColor", "inboundMessageColor", "inboundMessageTextColor", "dangerColor", "onFileClicked", "createImageCell", "errorColor", "errorBackgroundColor", "actionColor", "actionTextColor", "onWebViewMessage", "Lkotlin/Function3;", "Lzendesk/core/ui/android/internal/model/MessageActionSize;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnWebViewMessage;", "authorizationToken", "onActionUriClicked", "source", "uriHandler", "uri", "renderContent", "clickListener", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
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

        public final void bind(MessageLogEntry.ImageMessageContainer item, UriHandler onUriClicked, WebViewUriHandler onWebViewUriClicked, Function2<? super String, ? super String, Unit> onSendPostbackMessage, Function1<? super Message, Unit> onFailedMessageClicked) {
            Intrinsics.checkNotNullParameter(item, "item");
            Intrinsics.checkNotNullParameter(onUriClicked, "onUriClicked");
            Intrinsics.checkNotNullParameter(onWebViewUriClicked, "onWebViewUriClicked");
            Intrinsics.checkNotNullParameter(onSendPostbackMessage, "onSendPostbackMessage");
            Intrinsics.checkNotNullParameter(onFailedMessageClicked, "onFailedMessageClicked");
            AdapterDelegatesHelper.INSTANCE.renderLabel$zendesk_messaging_messaging_android(this.labelView, item.getLabel(), item.getMessage().getContent(), this.messagingTheme);
            AdapterDelegatesHelper.INSTANCE.renderAvatar$zendesk_messaging_messaging_android(this.avatarView, item.getAvatarUrl(), item.getMessage().getContent(), MessageSize.NORMAL, item.getDirection(), this.messagingTheme);
            renderContent(item, onUriClicked, onWebViewUriClicked, onSendPostbackMessage, onFailedMessageClicked, item.getAuthorizationToken());
            AdapterDelegatesHelper.INSTANCE.renderReceipt$zendesk_messaging_messaging_android(this.receiptView, item.getReceipt(), item.getDirection(), item.getStatus(), (item.getMessage().getContent() instanceof MessageContent.Image) || (item.getMessage().getStatus() instanceof MessageStatus.Failed), item.getMessage().getContent() instanceof MessageContent.Unsupported, item.getMessage().getContent(), this.messagingTheme);
            AdapterDelegatesHelper adapterDelegatesHelper = AdapterDelegatesHelper.INSTANCE;
            View itemView = this.itemView;
            Intrinsics.checkNotNullExpressionValue(itemView, "itemView");
            adapterDelegatesHelper.adjustSpacing$zendesk_messaging_messaging_android(itemView, item.getPosition());
        }

        private final void renderContent(final MessageLogEntry.ImageMessageContainer item, UriHandler onUriClicked, final WebViewUriHandler onWebViewUriClicked, Function2<? super String, ? super String, Unit> onSendPostbackMessage, final Function1<? super Message, Unit> onFailedMessageClicked, String authorizationToken) {
            this.contentView.removeAllViews();
            if (item.getMessage().getContent() instanceof MessageContent.Image) {
                MessageContent content = item.getMessage().getContent();
                Intrinsics.checkNotNull(content, "null cannot be cast to non-null type zendesk.conversationkit.android.model.MessageContent.Image");
                MessageContent.Image image = (MessageContent.Image) content;
                LinearLayout linearLayout = this.contentView;
                int actionColor = this.messagingTheme.getActionColor();
                int onMessageColor = this.messagingTheme.getOnMessageColor();
                int onActionColor = this.messagingTheme.getOnActionColor();
                LinearLayout linearLayout2 = linearLayout;
                View viewCreateImageCell = createImageCell(image, item, linearLayout2, onUriClicked, this.messagingTheme.getMessageColor(), onMessageColor, this.messagingTheme.getOnDangerColor(), this.messagingTheme.getDangerColor(), actionColor, onActionColor, this.messagingTheme.getInboundMessageColor(), this.messagingTheme.getOnBackgroundColor(), onSendPostbackMessage, new Function1<Message, Unit>() {
                    {
                        super(1);
                    }

                    @Override
                    public Unit invoke(Message message) {
                        invoke2(message);
                        return Unit.INSTANCE;
                    }

                    public final void invoke2(Message it) {
                        Intrinsics.checkNotNullParameter(it, "it");
                        this.this$0.clickListener(item, onFailedMessageClicked);
                    }
                }, new Function3<String, MessageActionSize, String, Unit>() {
                    {
                        super(3);
                    }

                    @Override
                    public Unit invoke(String str, MessageActionSize messageActionSize, String str2) {
                        invoke2(str, messageActionSize, str2);
                        return Unit.INSTANCE;
                    }

                    public final void invoke2(String uri, MessageActionSize size, String source) {
                        Intrinsics.checkNotNullParameter(uri, "uri");
                        Intrinsics.checkNotNullParameter(size, "size");
                        Intrinsics.checkNotNullParameter(source, "source");
                        onWebViewUriClicked.onWebViewUriClicked(uri, size, UrlSource.WEBVIEW_MESSAGE_ACTION);
                    }
                }, authorizationToken);
                AdapterDelegatesHelper.INSTANCE.adjustDirectionAndWidth$zendesk_messaging_messaging_android(viewCreateImageCell, item.getMessage().getContent(), item.getDirection(), this.contentView);
                this.contentView.addView(viewCreateImageCell);
            }
        }

        public final View createImageCell(final MessageContent.Image content, final MessageLogEntry.ImageMessageContainer item, final ViewGroup parentView, final UriHandler onUriClicked, int outboundMessageColor, int outboundMessageTextColor, final int errorColor, final int errorBackgroundColor, final int actionColor, final int actionTextColor, int inboundMessageColor, int inboundMessageTextColor, final Function2<? super String, ? super String, Unit> onSendPostbackMessage, final Function1<? super Message, Unit> onFailedMessageClicked, final Function3<? super String, ? super MessageActionSize, ? super String, Unit> onWebViewMessage, final String authorizationToken) {
            if (ImageType.INSTANCE.isSupported(content.getMediaType())) {
                Context context = parentView.getContext();
                Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
                final ImageCellView imageCellView = new ImageCellView(context, null, 0, 6, null);
                final int i = item.getDirection() == MessageDirection.INBOUND ? inboundMessageTextColor : outboundMessageTextColor;
                final int i2 = item.getDirection() == MessageDirection.INBOUND ? inboundMessageColor : outboundMessageColor;
                imageCellView.render(new Function1<ImageCellRendering, ImageCellRendering>() {
                    {
                        super(1);
                    }

                    @Override
                    public final ImageCellRendering invoke(ImageCellRendering imageCellRendering) {
                        Intrinsics.checkNotNullParameter(imageCellRendering, "imageCellRendering");
                        ImageCellRendering.Builder builder = imageCellRendering.toBuilder();
                        final MessageContent.Image image = content;
                        final ViewGroup viewGroup = parentView;
                        final MessageLogEntry.ImageMessageContainer imageMessageContainer = item;
                        final ImageCellView imageCellView2 = imageCellView;
                        final int i3 = i;
                        final int i4 = errorColor;
                        final int i5 = errorBackgroundColor;
                        final int i6 = i2;
                        final int i7 = actionColor;
                        final int i8 = actionTextColor;
                        final String str = authorizationToken;
                        ImageCellRendering.Builder builderState = builder.state(new Function1<ImageCellState, ImageCellState>() {
                            {
                                super(1);
                            }

                            @Override
                            public final ImageCellState invoke(ImageCellState state) {
                                Intrinsics.checkNotNullParameter(state, "state");
                                Uri uri = Uri.parse(image.getMediaUrl());
                                String localUri = image.getLocalUri();
                                Uri uri2 = localUri != null ? Uri.parse(localUri) : null;
                                String mediaType = image.getMediaType();
                                String text = image.getText();
                                String string = viewGroup.getContext().getString(C1256R.string.zma_image_view_loading_error);
                                ImageCellDirection imageCellDirection$zendesk_messaging_messaging_android = AdapterDelegatesHelper.INSTANCE.getImageCellDirection$zendesk_messaging_messaging_android(imageMessageContainer.getShape(), imageMessageContainer.getDirection());
                                AdapterDelegatesHelper adapterDelegatesHelper = AdapterDelegatesHelper.INSTANCE;
                                MessageContent content2 = imageMessageContainer.getMessage().getContent();
                                Context context2 = imageCellView2.getContext();
                                Intrinsics.checkNotNullExpressionValue(context2, "getContext(...)");
                                return ImageCellState.copy$default(state, uri, uri2, mediaType, text, false, false, adapterDelegatesHelper.getCellActions$zendesk_messaging_messaging_android(content2, context2), i3, i4, i5, i6, i7, i8, string, imageCellDirection$zendesk_messaging_messaging_android, str, 48, null);
                            }
                        });
                        final MessageLogEntry.ImageMessageContainer imageMessageContainer2 = item;
                        final UriHandler uriHandler = onUriClicked;
                        final MessageContent.Image image2 = content;
                        final Function1<Message, Unit> function1 = onFailedMessageClicked;
                        ImageCellRendering.Builder builderOnImageCellClicked = builderState.onImageCellClicked(new Function1<String, Unit>() {
                            {
                                super(1);
                            }

                            @Override
                            public Unit invoke(String str2) {
                                invoke2(str2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke2(String uri) {
                                Intrinsics.checkNotNullParameter(uri, "uri");
                                if (imageMessageContainer2.getStatus() instanceof MessageStatus.Sent) {
                                    uriHandler.onUriClicked(uri, UrlSource.IMAGE, MessageKt.isPrivateAttachment(image2));
                                } else if (imageMessageContainer2.getStatus() instanceof MessageStatus.Failed) {
                                    function1.invoke(imageMessageContainer2.getMessage());
                                }
                            }
                        });
                        final ImageMessageContainerAdapterDelegate.ViewHolder viewHolder = this;
                        final UriHandler uriHandler2 = onUriClicked;
                        ImageCellRendering.Builder builderOnActionButtonClicked = builderOnImageCellClicked.onActionButtonClicked(new Function2<String, String, Unit>() {
                            {
                                super(2);
                            }

                            @Override
                            public Unit invoke(String str2, String str3) {
                                invoke2(str2, str3);
                                return Unit.INSTANCE;
                            }

                            public final void invoke2(String uri, String source) {
                                Intrinsics.checkNotNullParameter(uri, "uri");
                                Intrinsics.checkNotNullParameter(source, "source");
                                viewHolder.onActionUriClicked(source, uriHandler2, uri);
                            }
                        });
                        final Function3<String, MessageActionSize, String, Unit> function3 = onWebViewMessage;
                        ImageCellRendering.Builder builderOnWebViewActionButtonClicked = builderOnActionButtonClicked.onWebViewActionButtonClicked(new Function3<String, MessageActionSize, String, Unit>() {
                            {
                                super(3);
                            }

                            @Override
                            public Unit invoke(String str2, MessageActionSize messageActionSize, String str3) {
                                invoke2(str2, messageActionSize, str3);
                                return Unit.INSTANCE;
                            }

                            public final void invoke2(String url, MessageActionSize size, String source) {
                                Intrinsics.checkNotNullParameter(url, "url");
                                Intrinsics.checkNotNullParameter(size, "size");
                                Intrinsics.checkNotNullParameter(source, "source");
                                function3.invoke(url, size, source);
                            }
                        });
                        final Function2<String, String, Unit> function2 = onSendPostbackMessage;
                        return builderOnWebViewActionButtonClicked.onPostbackButtonClicked(new Function2<String, String, Unit>() {
                            {
                                super(2);
                            }

                            @Override
                            public Unit invoke(String str2, String str3) {
                                invoke2(str2, str3);
                                return Unit.INSTANCE;
                            }

                            public final void invoke2(String actionId, String text) {
                                Intrinsics.checkNotNullParameter(actionId, "actionId");
                                Intrinsics.checkNotNullParameter(text, "text");
                                function2.invoke(actionId, text);
                            }
                        }).build();
                    }
                });
                return (View) imageCellView;
            }
            return createFileView$default(this, content, item, parentView, outboundMessageColor, outboundMessageTextColor, inboundMessageColor, inboundMessageTextColor, errorColor, new Function1<String, Unit>() {
                {
                    super(1);
                }

                @Override
                public Unit invoke(String str) {
                    invoke2(str);
                    return Unit.INSTANCE;
                }

                public final void invoke2(String uri) {
                    Intrinsics.checkNotNullParameter(uri, "uri");
                    onUriClicked.onUriClicked(uri, UrlSource.FILE, MessageKt.isPrivateAttachment(content));
                }
            }, null, 512, null);
        }

        static View createFileView$default(ViewHolder viewHolder, MessageContent.Image image, MessageLogEntry.ImageMessageContainer imageMessageContainer, ViewGroup viewGroup, int i, int i2, int i3, int i4, int i5, Function1 function1, Function1 function2, int i6, Object obj) {
            return viewHolder.createFileView(image, imageMessageContainer, viewGroup, i, i2, i3, i4, i5, (i6 & 256) != 0 ? new Function1<String, Unit>() {
                public final void invoke2(String it) {
                    Intrinsics.checkNotNullParameter(it, "it");
                }

                @Override
                public Unit invoke(String str) {
                    invoke2(str);
                    return Unit.INSTANCE;
                }
            } : function1, (i6 & 512) != 0 ? new Function1<Message, Unit>() {
                public final void invoke2(Message it) {
                    Intrinsics.checkNotNullParameter(it, "it");
                }

                @Override
                public Unit invoke(Message message) {
                    invoke2(message);
                    return Unit.INSTANCE;
                }
            } : function2);
        }

        private final View createFileView(final MessageContent.Image content, final MessageLogEntry.ImageMessageContainer item, ViewGroup parentView, final int outboundMessageColor, final int outboundMessageTextColor, final int inboundMessageColor, final int inboundMessageTextColor, final int dangerColor, final Function1<? super String, Unit> onFileClicked, final Function1<? super Message, Unit> onFailedMessageClicked) {
            Context context = parentView.getContext();
            Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
            FileView fileView = new FileView(context, null, 0, 0, 14, null);
            fileView.render(new Function1<FileRendering, FileRendering>() {
                {
                    super(1);
                }

                @Override
                public final FileRendering invoke(FileRendering fileRendering) {
                    int iAdjustAlpha$default;
                    Intrinsics.checkNotNullParameter(fileRendering, "fileRendering");
                    if (item.getDirection() == MessageDirection.INBOUND) {
                        iAdjustAlpha$default = inboundMessageTextColor;
                    } else if (item.getDirection() == MessageDirection.OUTBOUND && (item.getStatus() instanceof MessageStatus.Sent)) {
                        iAdjustAlpha$default = outboundMessageTextColor;
                    } else {
                        iAdjustAlpha$default = ViewKtxKt.adjustAlpha$default(outboundMessageTextColor, 0.0f, 1, null);
                    }
                    final int i = iAdjustAlpha$default;
                    FileRendering.Builder builder = fileRendering.toBuilder();
                    final MessageContent.Image image = content;
                    final MessageLogEntry.ImageMessageContainer imageMessageContainer = item;
                    final int i2 = inboundMessageColor;
                    final int i3 = outboundMessageColor;
                    final int i4 = dangerColor;
                    FileRendering.Builder builderState = builder.state(new Function1<FileState, FileState>() {
                        {
                            super(1);
                        }

                        @Override
                        public final FileState invoke(FileState state) {
                            int iAdjustAlpha$default2;
                            Intrinsics.checkNotNullParameter(state, "state");
                            String strSubstringAfterLast$default = StringsKt.substringAfterLast$default(image.getMediaUrl(), "/", (String) null, 2, (Object) null);
                            try {
                                String queryParameter = Uri.parse(image.getMediaUrl()).getQueryParameter("name");
                                if (queryParameter != null) {
                                    strSubstringAfterLast$default = queryParameter;
                                }
                            } catch (NullPointerException unused) {
                            }
                            String str = strSubstringAfterLast$default;
                            Intrinsics.checkNotNull(str);
                            long mediaSize = image.getMediaSize();
                            int i5 = i;
                            if (imageMessageContainer.getDirection() == MessageDirection.INBOUND) {
                                iAdjustAlpha$default2 = i2;
                            } else {
                                MessageStatus status = imageMessageContainer.getStatus();
                                if (status instanceof MessageStatus.Pending) {
                                    iAdjustAlpha$default2 = ViewKtxKt.adjustAlpha$default(i3, 0.0f, 1, null);
                                } else {
                                    if (status instanceof MessageStatus.Sent ? true : status instanceof MessageStatus.Downloading) {
                                        iAdjustAlpha$default2 = i3;
                                    } else {
                                        if (status instanceof MessageStatus.Failed ? true : status instanceof MessageStatus.DownloadFailed) {
                                            iAdjustAlpha$default2 = ViewKtxKt.adjustAlpha$default(i4, 0.0f, 1, null);
                                        } else {
                                            throw new NoWhenBranchMatchedException();
                                        }
                                    }
                                }
                            }
                            return state.copy(str, mediaSize, i5, i5, iAdjustAlpha$default2, Integer.valueOf(AdapterDelegatesHelper.INSTANCE.getCellDrawable$zendesk_messaging_messaging_android(imageMessageContainer.getShape(), imageMessageContainer.getDirection())));
                        }
                    });
                    final MessageLogEntry.ImageMessageContainer imageMessageContainer2 = item;
                    final Function1<String, Unit> function1 = onFileClicked;
                    final MessageContent.Image image2 = content;
                    final Function1<Message, Unit> function2 = onFailedMessageClicked;
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
                            if (imageMessageContainer2.getStatus() instanceof MessageStatus.Sent) {
                                function1.invoke(image2.getMediaUrl());
                            } else if (imageMessageContainer2.getStatus() instanceof MessageStatus.Failed) {
                                function2.invoke(imageMessageContainer2.getMessage());
                            }
                        }
                    }).build();
                }
            });
            return fileView;
        }

        public final Function1<Message, Unit> clickListener(MessageLogEntry.ImageMessageContainer imageMessageContainer, Function1<? super Message, Unit> function1) {
            return imageMessageContainer.getMessage().getStatus() instanceof MessageStatus.Failed ? function1 : MessageLogListenersKt.getNOOP_ON_MESSAGE_CONTAINER_CLICKED_LISTENER();
        }

        public final void onActionUriClicked(String source, UriHandler uriHandler, String uri) {
            UrlSource urlSourceFindByValue = UrlSource.INSTANCE.findByValue(source);
            if (urlSourceFindByValue != null) {
                uriHandler.onUriClicked(uri, urlSourceFindByValue, false);
            }
        }
    }
}
