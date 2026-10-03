package zendesk.messaging.android.internal.conversationscreen.delegates;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.recyclerview.widget.RecyclerView;
import java.util.ArrayList;
import java.util.List;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.android.messaging.UrlSource;
import zendesk.conversationkit.android.model.AuthorSubtype;
import zendesk.conversationkit.android.model.Message;
import zendesk.conversationkit.android.model.MessageContent;
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
import zendesk.messaging.android.internal.model.MessagingTheme;
import zendesk.p026ui.android.conversation.actionbutton.ActionButton;
import zendesk.p026ui.android.conversation.avatar.AvatarImageView;
import zendesk.p026ui.android.conversation.receipt.MessageReceiptView;
import zendesk.p026ui.android.conversation.textcell.TextCellRendering;
import zendesk.p026ui.android.conversation.textcell.TextCellState;
import zendesk.p026ui.android.conversation.textcell.TextCellView;
import zendesk.p026ui.android.internal.ContextualMenuOption;
import zendesk.ui.android.R;

@Metadata(m17d1 = {"\u0000~\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0018\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010 \n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0000\u0018\u0000 >2\u0014\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00040\u0001:\u0002>?B\u0084\u0001\u0012'\b\u0002\u0010\u0005\u001a!\u0012\u0013\u0012\u00110\u0007¢\u0006\f\b\b\u0012\b\b\t\u0012\u0004\b\b(\n\u0012\u0004\u0012\u00020\u000b0\u0006j\u0002`\f\u0012\b\b\u0002\u0010\r\u001a\u00020\u000e\u0012\b\b\u0002\u0010\u000f\u001a\u00020\u0010\u0012\u0006\u0010\u0011\u001a\u00020\u0012\u0012\u0018\b\u0002\u0010\u0013\u001a\u0012\u0012\u0004\u0012\u00020\u0014\u0012\u0004\u0012\u00020\u000b0\u0006j\u0002`\u0015\u0012\u001e\b\u0002\u0010\u0016\u001a\u0018\u0012\u0004\u0012\u00020\u0014\u0012\u0004\u0012\u00020\u0014\u0012\u0004\u0012\u00020\u000b0\u0017j\u0002`\u0018¢\u0006\u0002\u0010\u0019J&\u00100\u001a\u0002012\u0006\u00102\u001a\u00020\u00032\f\u00103\u001a\b\u0012\u0004\u0012\u00020\u0003042\u0006\u00105\u001a\u000206H\u0014J(\u00107\u001a\u00020\u000b2\u0006\u00102\u001a\u00020\u00022\u0006\u00108\u001a\u00020\u00042\u000e\u00109\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010:04H\u0014J\u0010\u0010;\u001a\u00020\u00042\u0006\u0010<\u001a\u00020=H\u0016R\u001a\u0010\u0011\u001a\u00020\u0012X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001a\u0010\u001b\"\u0004\b\u001c\u0010\u001dR*\u0010\u0013\u001a\u0012\u0012\u0004\u0012\u00020\u0014\u0012\u0004\u0012\u00020\u000b0\u0006j\u0002`\u0015X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001e\u0010\u001f\"\u0004\b \u0010!R9\u0010\u0005\u001a!\u0012\u0013\u0012\u00110\u0007¢\u0006\f\b\b\u0012\b\b\t\u0012\u0004\b\b(\n\u0012\u0004\u0012\u00020\u000b0\u0006j\u0002`\fX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\"\u0010\u001f\"\u0004\b#\u0010!R0\u0010\u0016\u001a\u0018\u0012\u0004\u0012\u00020\u0014\u0012\u0004\u0012\u00020\u0014\u0012\u0004\u0012\u00020\u000b0\u0017j\u0002`\u0018X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b$\u0010%\"\u0004\b&\u0010'R\u001a\u0010\r\u001a\u00020\u000eX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b(\u0010)\"\u0004\b*\u0010+R\u001a\u0010\u000f\u001a\u00020\u0010X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b,\u0010-\"\u0004\b.\u0010/¨\u0006@"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/delegates/TextMessageContainerAdapterDelegate;", "Lzendesk/messaging/android/internal/adapterdelegate/ListItemAdapterDelegate;", "Lzendesk/messaging/android/internal/model/MessageLogEntry$TextMessageContainer;", "Lzendesk/messaging/android/internal/model/MessageLogEntry;", "Lzendesk/messaging/android/internal/conversationscreen/delegates/TextMessageContainerAdapterDelegate$ViewHolder;", "onFailedMessageClicked", "Lkotlin/Function1;", "Lzendesk/conversationkit/android/model/Message;", "Lkotlin/ParameterName;", "name", "message", "", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFailedMessageClickedListener;", "onUriClicked", "Lzendesk/messaging/android/internal/UriHandler;", "onWebViewUriClicked", "Lzendesk/messaging/android/internal/WebViewUriHandler;", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "onCopyText", "", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnCopyTextAction;", "onSendPostbackMessage", "Lkotlin/Function2;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnSendPostbackMessage;", "(Lkotlin/jvm/functions/Function1;Lzendesk/messaging/android/internal/UriHandler;Lzendesk/messaging/android/internal/WebViewUriHandler;Lzendesk/messaging/android/internal/model/MessagingTheme;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function2;)V", "getMessagingTheme", "()Lzendesk/messaging/android/internal/model/MessagingTheme;", "setMessagingTheme", "(Lzendesk/messaging/android/internal/model/MessagingTheme;)V", "getOnCopyText", "()Lkotlin/jvm/functions/Function1;", "setOnCopyText", "(Lkotlin/jvm/functions/Function1;)V", "getOnFailedMessageClicked", "setOnFailedMessageClicked", "getOnSendPostbackMessage", "()Lkotlin/jvm/functions/Function2;", "setOnSendPostbackMessage", "(Lkotlin/jvm/functions/Function2;)V", "getOnUriClicked", "()Lzendesk/messaging/android/internal/UriHandler;", "setOnUriClicked", "(Lzendesk/messaging/android/internal/UriHandler;)V", "getOnWebViewUriClicked", "()Lzendesk/messaging/android/internal/WebViewUriHandler;", "setOnWebViewUriClicked", "(Lzendesk/messaging/android/internal/WebViewUriHandler;)V", "isForViewType", "", "item", "items", "", "position", "", "onBindViewHolder", "holder", "payloads", "", "onCreateViewHolder", "parent", "Landroid/view/ViewGroup;", "Companion", "ViewHolder", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class TextMessageContainerAdapterDelegate extends ListItemAdapterDelegate<MessageLogEntry.TextMessageContainer, MessageLogEntry, ViewHolder> {
    public static final float PENDING_ALPHA_FACTOR = 0.66f;
    private MessagingTheme messagingTheme;
    private Function1<? super String, Unit> onCopyText;
    private Function1<? super Message, Unit> onFailedMessageClicked;
    private Function2<? super String, ? super String, Unit> onSendPostbackMessage;
    private UriHandler onUriClicked;
    private WebViewUriHandler onWebViewUriClicked;

    @Override
    public void onBindViewHolder(Object obj, RecyclerView.ViewHolder viewHolder, List list) {
        onBindViewHolder((MessageLogEntry.TextMessageContainer) obj, (ViewHolder) viewHolder, (List<? extends Object>) list);
    }

    public TextMessageContainerAdapterDelegate(Function1 function1, StubUriHandler stubUriHandler, StubWebViewUriHandler stubWebViewUriHandler, MessagingTheme messagingTheme, Function1 function2, Function2 function3, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? MessageLogListenersKt.getNOOP_ON_MESSAGE_CONTAINER_CLICKED_LISTENER() : function1, (i & 2) != 0 ? StubUriHandler.INSTANCE : stubUriHandler, (i & 4) != 0 ? StubWebViewUriHandler.INSTANCE : stubWebViewUriHandler, messagingTheme, (i & 16) != 0 ? MessageLogListenersKt.getNOOP_ON_COPY_TEXT_ACTION() : function2, (i & 32) != 0 ? MessageLogListenersKt.getNOOP_ON_SEND_POSTBACK_MESSAGE() : function3);
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

    public final Function1<String, Unit> getOnCopyText() {
        return this.onCopyText;
    }

    public final void setOnCopyText(Function1<? super String, Unit> function1) {
        Intrinsics.checkNotNullParameter(function1, "<set-?>");
        this.onCopyText = function1;
    }

    public final Function2<String, String, Unit> getOnSendPostbackMessage() {
        return this.onSendPostbackMessage;
    }

    public final void setOnSendPostbackMessage(Function2<? super String, ? super String, Unit> function2) {
        Intrinsics.checkNotNullParameter(function2, "<set-?>");
        this.onSendPostbackMessage = function2;
    }

    public TextMessageContainerAdapterDelegate(Function1<? super Message, Unit> onFailedMessageClicked, UriHandler onUriClicked, WebViewUriHandler onWebViewUriClicked, MessagingTheme messagingTheme, Function1<? super String, Unit> onCopyText, Function2<? super String, ? super String, Unit> onSendPostbackMessage) {
        Intrinsics.checkNotNullParameter(onFailedMessageClicked, "onFailedMessageClicked");
        Intrinsics.checkNotNullParameter(onUriClicked, "onUriClicked");
        Intrinsics.checkNotNullParameter(onWebViewUriClicked, "onWebViewUriClicked");
        Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
        Intrinsics.checkNotNullParameter(onCopyText, "onCopyText");
        Intrinsics.checkNotNullParameter(onSendPostbackMessage, "onSendPostbackMessage");
        this.onFailedMessageClicked = onFailedMessageClicked;
        this.onUriClicked = onUriClicked;
        this.onWebViewUriClicked = onWebViewUriClicked;
        this.messagingTheme = messagingTheme;
        this.onCopyText = onCopyText;
        this.onSendPostbackMessage = onSendPostbackMessage;
    }

    @Override
    public boolean isForViewType(MessageLogEntry item, List<? extends MessageLogEntry> items, int position) {
        Intrinsics.checkNotNullParameter(item, "item");
        Intrinsics.checkNotNullParameter(items, "items");
        return item instanceof MessageLogEntry.TextMessageContainer;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent) {
        Intrinsics.checkNotNullParameter(parent, "parent");
        View viewInflate = LayoutInflater.from(parent.getContext()).inflate(C1256R.layout.zma_view_message_log_entry_message_container, parent, false);
        Intrinsics.checkNotNullExpressionValue(viewInflate, "inflate(...)");
        return new ViewHolder(viewInflate, this.messagingTheme);
    }

    protected void onBindViewHolder(MessageLogEntry.TextMessageContainer item, ViewHolder holder, List<? extends Object> payloads) {
        Intrinsics.checkNotNullParameter(item, "item");
        Intrinsics.checkNotNullParameter(holder, "holder");
        Intrinsics.checkNotNullParameter(payloads, "payloads");
        holder.bind(item, this.onFailedMessageClicked, this.onUriClicked, this.onWebViewUriClicked, this.onCopyText, this.onSendPostbackMessage);
    }

    @Metadata(m17d1 = {"\u0000¤\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0011\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0000\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J{\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122%\u0010\u0013\u001a!\u0012\u0013\u0012\u00110\u0015¢\u0006\f\b\u0016\u0012\b\b\u0017\u0012\u0004\b\b(\u0018\u0012\u0004\u0012\u00020\u00100\u0014j\u0002`\u00192\u0006\u0010\u001a\u001a\u00020\u001b2\u0006\u0010\u001c\u001a\u00020\u001d2\u0016\u0010\u001e\u001a\u0012\u0012\u0004\u0012\u00020\u001f\u0012\u0004\u0012\u00020\u00100\u0014j\u0002` 2\u001c\u0010!\u001a\u0018\u0012\u0004\u0012\u00020\u001f\u0012\u0004\u0012\u00020\u001f\u0012\u0004\u0012\u00020\u00100\"j\u0002`#JÂ\u0002\u0010$\u001a\u00020\u00032\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010%\u001a\u00020&2\b\b\u0001\u0010'\u001a\u00020(2\b\b\u0001\u0010)\u001a\u00020(2\b\b\u0001\u0010*\u001a\u00020(2\b\b\u0001\u0010+\u001a\u00020(2\b\b\u0001\u0010,\u001a\u00020(2\b\b\u0001\u0010-\u001a\u00020(2\b\b\u0001\u0010.\u001a\u00020(2\b\b\u0001\u0010/\u001a\u00020(2\b\b\u0001\u00100\u001a\u00020(2\b\b\u0001\u00101\u001a\u00020(2\b\b\u0001\u00102\u001a\u00020(2\b\b\u0001\u00103\u001a\u00020(2\b\b\u0001\u00104\u001a\u00020(2\u0014\b\u0002\u00105\u001a\u000e\u0012\u0004\u0012\u00020\u0015\u0012\u0004\u0012\u00020\u00100\u00142\u0014\b\u0002\u0010\u0013\u001a\u000e\u0012\u0004\u0012\u00020\u0015\u0012\u0004\u0012\u00020\u00100\u00142\u0014\b\u0002\u00106\u001a\u000e\u0012\u0004\u0012\u00020\u001f\u0012\u0004\u0012\u00020\u00100\u00142\u0014\b\u0002\u00107\u001a\u000e\u0012\u0004\u0012\u00020\u001f\u0012\u0004\u0012\u00020\u00100\u00142\b\b\u0002\u00108\u001a\u00020\u001b2\u001e\b\u0002\u0010!\u001a\u0018\u0012\u0004\u0012\u00020\u001f\u0012\u0004\u0012\u00020\u001f\u0012\u0004\u0012\u00020\u00100\"j\u0002`#2$\b\u0002\u00109\u001a\u001e\u0012\u0004\u0012\u00020\u001f\u0012\u0004\u0012\u00020;\u0012\u0004\u0012\u00020\u001f\u0012\u0004\u0012\u00020\u00100:j\u0002`<H\u0002J,\u0010=\u001a\u00020\u00032\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010%\u001a\u00020&2\b\b\u0001\u0010+\u001a\u00020(2\b\b\u0001\u00100\u001a\u00020(H\u0002J\u0016\u0010>\u001a\b\u0012\u0004\u0012\u00020@0?2\u0006\u0010A\u001a\u00020BH\u0002J \u0010C\u001a\u00020\u00102\u0006\u0010D\u001a\u00020\u001f2\u0006\u00108\u001a\u00020\u001b2\u0006\u0010E\u001a\u00020\u001fH\u0002J}\u0010F\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122%\u0010\u0013\u001a!\u0012\u0013\u0012\u00110\u0015¢\u0006\f\b\u0016\u0012\b\b\u0017\u0012\u0004\b\b(\u0018\u0012\u0004\u0012\u00020\u00100\u0014j\u0002`\u00192\u0006\u0010\u001a\u001a\u00020\u001b2\u0006\u0010\u001c\u001a\u00020\u001d2\u0016\u0010\u001e\u001a\u0012\u0012\u0004\u0012\u00020\u001f\u0012\u0004\u0012\u00020\u00100\u0014j\u0002` 2\u001c\u0010!\u001a\u0018\u0012\u0004\u0012\u00020\u001f\u0012\u0004\u0012\u00020\u001f\u0012\u0004\u0012\u00020\u00100\"j\u0002`#H\u0002JR\u0010G\u001a!\u0012\u0013\u0012\u00110\u0015¢\u0006\f\b\u0016\u0012\b\b\u0017\u0012\u0004\b\b(\u0018\u0012\u0004\u0012\u00020\u00100\u0014j\u0002`\u0019*\u00020\u00122%\u0010\u0013\u001a!\u0012\u0013\u0012\u00110\u0015¢\u0006\f\b\u0016\u0012\b\b\u0017\u0012\u0004\b\b(\u0018\u0012\u0004\u0012\u00020\u00100\u0014j\u0002`\u0019H\u0002R\u000e\u0010\u0007\u001a\u00020\bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\t\u001a\u00020\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000b\u001a\u00020\fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\r\u001a\u00020\u000eX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006H"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/delegates/TextMessageContainerAdapterDelegate$ViewHolder;", "Landroidx/recyclerview/widget/RecyclerView$ViewHolder;", "itemView", "Landroid/view/View;", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "(Landroid/view/View;Lzendesk/messaging/android/internal/model/MessagingTheme;)V", "avatarView", "Lzendesk/ui/android/conversation/avatar/AvatarImageView;", "contentView", "Landroid/widget/LinearLayout;", "labelView", "Landroid/widget/TextView;", "receiptView", "Lzendesk/ui/android/conversation/receipt/MessageReceiptView;", "bind", "", "item", "Lzendesk/messaging/android/internal/model/MessageLogEntry$TextMessageContainer;", "onFailedMessageClicked", "Lkotlin/Function1;", "Lzendesk/conversationkit/android/model/Message;", "Lkotlin/ParameterName;", "name", "message", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFailedMessageClickedListener;", "onUriClicked", "Lzendesk/messaging/android/internal/UriHandler;", "onWebViewUriClicked", "Lzendesk/messaging/android/internal/WebViewUriHandler;", "onCopyText", "", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnCopyTextAction;", "onSendPostbackMessage", "Lkotlin/Function2;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnSendPostbackMessage;", "createTextCell", "parentView", "Landroid/view/ViewGroup;", "inboundMessageColor", "", "inboundMessageTextColor", "outboundMessageColor", "outboundMessageTextColor", "actionColor", "actionTextColor", "disabledColor", "disabledTextColor", "dangerColor", "dangerTextColor", "aiDisclaimerTextColor", "aiDisclaimerImageColor", "aiDisclaimerBorderColor", "onMessageContainerClicked", "onMessageTextClicked", "onCopyTextMenuItemClicked", "uriHandler", "onWebViewMessage", "Lkotlin/Function3;", "Lzendesk/core/ui/android/internal/model/MessageActionSize;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnWebViewMessage;", "createUnsupportedCell", "getCellContextualMenuOptions", "", "Lzendesk/ui/android/internal/ContextualMenuOption;", "context", "Landroid/content/Context;", "onActionUriClicked", "source", "uri", "renderContent", "clickListener", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
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

        public final void bind(MessageLogEntry.TextMessageContainer item, Function1<? super Message, Unit> onFailedMessageClicked, UriHandler onUriClicked, WebViewUriHandler onWebViewUriClicked, Function1<? super String, Unit> onCopyText, Function2<? super String, ? super String, Unit> onSendPostbackMessage) {
            Intrinsics.checkNotNullParameter(item, "item");
            Intrinsics.checkNotNullParameter(onFailedMessageClicked, "onFailedMessageClicked");
            Intrinsics.checkNotNullParameter(onUriClicked, "onUriClicked");
            Intrinsics.checkNotNullParameter(onWebViewUriClicked, "onWebViewUriClicked");
            Intrinsics.checkNotNullParameter(onCopyText, "onCopyText");
            Intrinsics.checkNotNullParameter(onSendPostbackMessage, "onSendPostbackMessage");
            AdapterDelegatesHelper.INSTANCE.renderAvatar$zendesk_messaging_messaging_android(this.avatarView, item.getAvatarUrl(), item.getMessage().getContent(), item.getSize(), item.getDirection(), this.messagingTheme);
            AdapterDelegatesHelper.INSTANCE.renderLabel$zendesk_messaging_messaging_android(this.labelView, item.getLabel(), item.getMessage().getContent(), this.messagingTheme);
            renderContent(item, onFailedMessageClicked, onUriClicked, onWebViewUriClicked, onCopyText, onSendPostbackMessage);
            AdapterDelegatesHelper.INSTANCE.renderReceipt$zendesk_messaging_messaging_android(this.receiptView, item.getReceipt(), item.getDirection(), item.getStatus(), (item.getMessage().getContent() instanceof MessageContent.Text) || (item.getMessage().getContent() instanceof MessageContent.File) || (item.getMessage().getContent() instanceof MessageContent.Image) || (item.getMessage().getContent() instanceof MessageContent.FileUpload) || (item.getMessage().getContent() instanceof MessageContent.Unsupported) || (item.getMessage().getStatus() instanceof MessageStatus.Failed), item.getMessage().getContent() instanceof MessageContent.Unsupported, item.getMessage().getContent(), this.messagingTheme);
            AdapterDelegatesHelper adapterDelegatesHelper = AdapterDelegatesHelper.INSTANCE;
            View itemView = this.itemView;
            Intrinsics.checkNotNullExpressionValue(itemView, "itemView");
            adapterDelegatesHelper.adjustSpacing$zendesk_messaging_messaging_android(itemView, item.getPosition());
        }

        private final void renderContent(final MessageLogEntry.TextMessageContainer item, final Function1<? super Message, Unit> onFailedMessageClicked, final UriHandler onUriClicked, final WebViewUriHandler onWebViewUriClicked, final Function1<? super String, Unit> onCopyText, Function2<? super String, ? super String, Unit> onSendPostbackMessage) {
            ViewHolder viewHolder;
            View viewCreateUnsupportedCell;
            this.contentView.removeAllViews();
            MessageContent content = item.getMessage().getContent();
            if (content instanceof MessageContent.Text) {
                LinearLayout linearLayout = this.contentView;
                int actionColor = this.messagingTheme.getActionColor();
                LinearLayout linearLayout2 = linearLayout;
                viewCreateUnsupportedCell = createTextCell(item, linearLayout2, this.messagingTheme.getInboundMessageColor(), this.messagingTheme.getOnBackgroundColor(), this.messagingTheme.getMessageColor(), this.messagingTheme.getOnMessageColor(), actionColor, this.messagingTheme.getOnActionColor(), this.messagingTheme.getDisabledColor(), this.messagingTheme.getOnBackgroundColor(), this.messagingTheme.getDangerColor(), this.messagingTheme.getOnDangerColor(), this.messagingTheme.getOnBackgroundColor(), this.messagingTheme.getOnBackgroundColor(), this.messagingTheme.getOnBackgroundColor(), new Function1<Message, Unit>() {
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
                }, onFailedMessageClicked, new Function1<String, Unit>() {
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
                        onUriClicked.onUriClicked(uri, UrlSource.TEXT, false);
                    }
                }, new Function1<String, Unit>() {
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
                        onCopyText.invoke(it);
                    }
                }, onUriClicked, onSendPostbackMessage, new Function3<String, MessageActionSize, String, Unit>() {
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
                });
                viewHolder = this;
            } else {
                if (!(content instanceof MessageContent.Unsupported)) {
                    return;
                }
                viewHolder = this;
                viewCreateUnsupportedCell = viewHolder.createUnsupportedCell(item, viewHolder.contentView, viewHolder.messagingTheme.getOnDangerColor(), viewHolder.messagingTheme.getDangerColor());
            }
            AdapterDelegatesHelper.INSTANCE.adjustDirectionAndWidth$zendesk_messaging_messaging_android(viewCreateUnsupportedCell, item.getMessage().getContent(), item.getDirection(), viewHolder.contentView);
            viewHolder.contentView.addView(viewCreateUnsupportedCell);
        }

        public final View createTextCell(final MessageLogEntry.TextMessageContainer item, ViewGroup parentView, final int inboundMessageColor, final int inboundMessageTextColor, final int outboundMessageColor, final int outboundMessageTextColor, final int actionColor, final int actionTextColor, final int disabledColor, final int disabledTextColor, final int dangerColor, final int dangerTextColor, final int aiDisclaimerTextColor, final int aiDisclaimerImageColor, final int aiDisclaimerBorderColor, final Function1<? super Message, Unit> onMessageContainerClicked, final Function1<? super Message, Unit> onFailedMessageClicked, final Function1<? super String, Unit> onMessageTextClicked, final Function1<? super String, Unit> onCopyTextMenuItemClicked, final UriHandler uriHandler, final Function2<? super String, ? super String, Unit> onSendPostbackMessage, final Function3<? super String, ? super MessageActionSize, ? super String, Unit> onWebViewMessage) {
            Context context = parentView.getContext();
            Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
            final TextCellView textCellView = new TextCellView(context, null, 0, 0, 14, null);
            textCellView.render(new Function1<TextCellRendering, TextCellRendering>() {
                {
                    super(1);
                }

                @Override
                public final TextCellRendering invoke(TextCellRendering textCellRendering) {
                    Intrinsics.checkNotNullParameter(textCellRendering, "textCellRendering");
                    TextCellRendering.Builder builder = textCellRendering.toBuilder();
                    final MessageLogEntry.TextMessageContainer textMessageContainer = item;
                    final int i = inboundMessageTextColor;
                    final int i2 = dangerTextColor;
                    final int i3 = outboundMessageTextColor;
                    final int i4 = inboundMessageColor;
                    final int i5 = outboundMessageColor;
                    final int i6 = dangerColor;
                    final TextCellView textCellView2 = textCellView;
                    final TextMessageContainerAdapterDelegate.ViewHolder viewHolder = this;
                    final int i7 = aiDisclaimerTextColor;
                    final int i8 = aiDisclaimerImageColor;
                    final int i9 = aiDisclaimerBorderColor;
                    final int i10 = actionColor;
                    final int i11 = actionTextColor;
                    final int i12 = disabledColor;
                    final int i13 = disabledTextColor;
                    TextCellRendering.Builder builderState = builder.state(new Function1<TextCellState, TextCellState>() {
                        {
                            super(1);
                        }

                        @Override
                        public final TextCellState invoke(TextCellState state) {
                            int i14;
                            int iAdjustAlpha;
                            Intrinsics.checkNotNullParameter(state, "state");
                            MessageContent content = textMessageContainer.getMessage().getContent();
                            MessageContent.Text text = content instanceof MessageContent.Text ? (MessageContent.Text) content : null;
                            String text2 = text != null ? text.getText() : null;
                            String str = text2 == null ? "" : text2;
                            boolean zContains = textMessageContainer.getMessage().getAuthor().getSubtypes().contains(AuthorSubtype.AI);
                            if (textMessageContainer.getDirection() == MessageDirection.INBOUND) {
                                i14 = i;
                            } else {
                                i14 = textMessageContainer.getStatus() instanceof MessageStatus.Failed ? i2 : i3;
                            }
                            if (textMessageContainer.getDirection() == MessageDirection.INBOUND) {
                                iAdjustAlpha = i4;
                            } else {
                                MessageStatus status = textMessageContainer.getStatus();
                                if (status instanceof MessageStatus.Pending) {
                                    iAdjustAlpha = ViewKtxKt.adjustAlpha(i5, 0.66f);
                                } else {
                                    if (status instanceof MessageStatus.Sent ? true : status instanceof MessageStatus.Downloading) {
                                        iAdjustAlpha = i5;
                                    } else {
                                        if (status instanceof MessageStatus.Failed ? true : status instanceof MessageStatus.DownloadFailed) {
                                            iAdjustAlpha = i6;
                                        } else {
                                            throw new NoWhenBranchMatchedException();
                                        }
                                    }
                                }
                            }
                            int cellDrawable$zendesk_messaging_messaging_android = AdapterDelegatesHelper.INSTANCE.getCellDrawable$zendesk_messaging_messaging_android(textMessageContainer.getShape(), textMessageContainer.getDirection());
                            AdapterDelegatesHelper adapterDelegatesHelper = AdapterDelegatesHelper.INSTANCE;
                            MessageContent content2 = textMessageContainer.getMessage().getContent();
                            Context context2 = textCellView2.getContext();
                            Intrinsics.checkNotNullExpressionValue(context2, "getContext(...)");
                            List<ActionButton> cellActions$zendesk_messaging_messaging_android = adapterDelegatesHelper.getCellActions$zendesk_messaging_messaging_android(content2, context2);
                            TextMessageContainerAdapterDelegate.ViewHolder viewHolder2 = viewHolder;
                            Context context3 = textCellView2.getContext();
                            Intrinsics.checkNotNullExpressionValue(context3, "getContext(...)");
                            return state.copy(str, cellActions$zendesk_messaging_messaging_android, viewHolder2.getCellContextualMenuOptions(context3), zContains, Integer.valueOf(i7), Integer.valueOf(i8), Integer.valueOf(i9), Integer.valueOf(i14), Integer.valueOf(iAdjustAlpha), Integer.valueOf(cellDrawable$zendesk_messaging_messaging_android), Integer.valueOf(i10), Integer.valueOf(i11), Integer.valueOf(i12), Integer.valueOf(i13));
                        }
                    });
                    final MessageLogEntry.TextMessageContainer textMessageContainer2 = item;
                    final Function1<Message, Unit> function1 = onFailedMessageClicked;
                    final Function1<Message, Unit> function2 = onMessageContainerClicked;
                    TextCellRendering.Builder builderOnCellClicked = builderState.onCellClicked(new Function1<String, Unit>() {
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
                            if (textMessageContainer2.getStatus() instanceof MessageStatus.Failed) {
                                function1.invoke(textMessageContainer2.getMessage());
                            } else if (textMessageContainer2.getStatus() instanceof MessageStatus.Sent) {
                                function2.invoke(textMessageContainer2.getMessage());
                            }
                        }
                    });
                    final MessageLogEntry.TextMessageContainer textMessageContainer3 = item;
                    final Function1<String, Unit> function3 = onMessageTextClicked;
                    final Function1<Message, Unit> function4 = onFailedMessageClicked;
                    TextCellRendering.Builder builderOnCellTextClicked = builderOnCellClicked.onCellTextClicked(new Function1<String, Unit>() {
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
                            if (!(textMessageContainer3.getStatus() instanceof MessageStatus.Failed)) {
                                function3.invoke(it);
                            } else {
                                function4.invoke(textMessageContainer3.getMessage());
                            }
                        }
                    });
                    final TextMessageContainerAdapterDelegate.ViewHolder viewHolder2 = this;
                    final UriHandler uriHandler2 = uriHandler;
                    TextCellRendering.Builder builderOnActionButtonClicked = builderOnCellTextClicked.onActionButtonClicked(new Function2<String, String, Unit>() {
                        {
                            super(2);
                        }

                        @Override
                        public Unit invoke(String str, String str2) {
                            invoke2(str, str2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke2(String uri, String source) {
                            Intrinsics.checkNotNullParameter(uri, "uri");
                            Intrinsics.checkNotNullParameter(source, "source");
                            viewHolder2.onActionUriClicked(source, uriHandler2, uri);
                        }
                    });
                    final Function3<String, MessageActionSize, String, Unit> function5 = onWebViewMessage;
                    TextCellRendering.Builder builderOnWebViewActionButtonClicked = builderOnActionButtonClicked.onWebViewActionButtonClicked(new Function3<String, MessageActionSize, String, Unit>() {
                        {
                            super(3);
                        }

                        @Override
                        public Unit invoke(String str, MessageActionSize messageActionSize, String str2) {
                            invoke2(str, messageActionSize, str2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke2(String url, MessageActionSize size, String source) {
                            Intrinsics.checkNotNullParameter(url, "url");
                            Intrinsics.checkNotNullParameter(size, "size");
                            Intrinsics.checkNotNullParameter(source, "source");
                            function5.invoke(url, size, source);
                        }
                    });
                    final Function1<String, Unit> function6 = onCopyTextMenuItemClicked;
                    TextCellRendering.Builder builderOnCopyTextMenuItemClicked = builderOnWebViewActionButtonClicked.onCopyTextMenuItemClicked(new Function1<String, Unit>() {
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
                            function6.invoke(it);
                        }
                    });
                    final Function2<String, String, Unit> function7 = onSendPostbackMessage;
                    return builderOnCopyTextMenuItemClicked.onPostbackButtonClicked(new Function2<String, String, Unit>() {
                        {
                            super(2);
                        }

                        @Override
                        public Unit invoke(String str, String str2) {
                            invoke2(str, str2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke2(String actionId, String text) {
                            Intrinsics.checkNotNullParameter(actionId, "actionId");
                            Intrinsics.checkNotNullParameter(text, "text");
                            function7.invoke(actionId, text);
                        }
                    }).build();
                }
            });
            return textCellView;
        }

        private final View createUnsupportedCell(final MessageLogEntry.TextMessageContainer item, ViewGroup parentView, final int outboundMessageTextColor, final int dangerColor) {
            Context context = parentView.getContext();
            Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
            final TextCellView textCellView = new TextCellView(context, null, 0, 0, 14, null);
            textCellView.render(new Function1<TextCellRendering, TextCellRendering>() {
                {
                    super(1);
                }

                @Override
                public final TextCellRendering invoke(TextCellRendering textCellRendering) {
                    Intrinsics.checkNotNullParameter(textCellRendering, "textCellRendering");
                    TextCellRendering.Builder builder = textCellRendering.toBuilder();
                    final TextCellView textCellView2 = textCellView;
                    final int i = outboundMessageTextColor;
                    final int i2 = dangerColor;
                    final MessageLogEntry.TextMessageContainer textMessageContainer = item;
                    return builder.state(new Function1<TextCellState, TextCellState>() {
                        {
                            super(1);
                        }

                        @Override
                        public final TextCellState invoke(TextCellState state) {
                            Intrinsics.checkNotNullParameter(state, "state");
                            String string = textCellView2.getContext().getString(C1256R.string.zma_conversation_message_label_cant_be_displayed);
                            Intrinsics.checkNotNullExpressionValue(string, "getString(...)");
                            return TextCellState.copy$default(state, string, null, null, false, null, null, null, Integer.valueOf(i), Integer.valueOf(ViewKtxKt.adjustAlpha$default(i2, 0.0f, 1, null)), Integer.valueOf(AdapterDelegatesHelper.INSTANCE.getCellDrawable$zendesk_messaging_messaging_android(textMessageContainer.getShape(), textMessageContainer.getDirection())), null, null, null, null, 15486, null);
                        }
                    }).build();
                }
            });
            return textCellView;
        }

        public final void onActionUriClicked(String source, UriHandler uriHandler, String uri) {
            UrlSource urlSourceFindByValue = UrlSource.INSTANCE.findByValue(source);
            if (urlSourceFindByValue != null) {
                uriHandler.onUriClicked(uri, urlSourceFindByValue, false);
            }
        }

        public final Function1<Message, Unit> clickListener(MessageLogEntry.TextMessageContainer textMessageContainer, Function1<? super Message, Unit> function1) {
            return textMessageContainer.getMessage().getStatus() instanceof MessageStatus.Failed ? function1 : MessageLogListenersKt.getNOOP_ON_MESSAGE_CONTAINER_CLICKED_LISTENER();
        }

        public final List<ContextualMenuOption> getCellContextualMenuOptions(Context context) {
            ArrayList arrayList = new ArrayList();
            int i = R.id.zuia_cell_menu_copy;
            String string = context.getString(C1256R.string.zma_contextual_menu_copy);
            Intrinsics.checkNotNullExpressionValue(string, "getString(...)");
            arrayList.add(new ContextualMenuOption(i, string));
            return arrayList;
        }
    }
}
