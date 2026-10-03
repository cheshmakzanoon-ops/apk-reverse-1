package zendesk.messaging.android.internal.conversationscreen.delegates;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.recyclerview.widget.RecyclerView;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.model.Field;
import zendesk.conversationkit.android.model.MessageContent;
import zendesk.conversationkit.android.model.MessageStatus;
import zendesk.messaging.C1256R;
import zendesk.messaging.android.internal.adapterdelegate.ListItemAdapterDelegate;
import zendesk.messaging.android.internal.conversationscreen.RenderingUpdates;
import zendesk.messaging.android.internal.conversationscreen.messagelog.MessageLogListenersKt;
import zendesk.messaging.android.internal.extension.ViewKtxKt;
import zendesk.messaging.android.internal.model.MessageLogEntry;
import zendesk.messaging.android.internal.model.MessagingTheme;
import zendesk.p026ui.android.conversation.avatar.AvatarImageView;
import zendesk.p026ui.android.conversation.form.DisplayedField;
import zendesk.p026ui.android.conversation.form.DisplayedForm;
import zendesk.p026ui.android.conversation.form.FormRendering;
import zendesk.p026ui.android.conversation.form.FormResponseRendering;
import zendesk.p026ui.android.conversation.form.FormResponseView;
import zendesk.p026ui.android.conversation.form.FormView;
import zendesk.p026ui.android.conversation.receipt.MessageReceiptView;

@Metadata(m17d1 = {"\u0000r\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010%\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0017\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0000\u0018\u0000 72\u0014\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00040\u0001:\u000278B\u0083\u0001\u0012$\b\u0002\u0010\u0005\u001a\u001e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\b0\u0007\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\t0\u0006j\u0002`\n\u0012\u0018\b\u0002\u0010\u000b\u001a\u0012\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\t0\fj\u0002`\u000e\u0012\u001e\b\u0002\u0010\u000f\u001a\u0018\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\u0011\u0012\u0004\u0012\u00020\t0\u0006j\u0002`\u0012\u0012\u0014\b\u0002\u0010\u0013\u001a\u000e\u0012\u0004\u0012\u00020\u0011\u0012\u0004\u0012\u00020\u00150\u0014\u0012\u0006\u0010\u0016\u001a\u00020\u0017¢\u0006\u0002\u0010\u0018J&\u0010+\u001a\u00020\r2\u0006\u0010,\u001a\u00020\u00032\f\u0010-\u001a\b\u0012\u0004\u0012\u00020\u00030\u00072\u0006\u0010.\u001a\u00020/H\u0014J(\u00100\u001a\u00020\t2\u0006\u0010,\u001a\u00020\u00022\u0006\u00101\u001a\u00020\u00042\u000e\u00102\u001a\n\u0012\u0006\u0012\u0004\u0018\u0001030\u0007H\u0014J\u0010\u00104\u001a\u00020\u00042\u0006\u00105\u001a\u000206H\u0016R&\u0010\u0013\u001a\u000e\u0012\u0004\u0012\u00020\u0011\u0012\u0004\u0012\u00020\u00150\u0014X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0019\u0010\u001a\"\u0004\b\u001b\u0010\u001cR\u001a\u0010\u0016\u001a\u00020\u0017X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001d\u0010\u001e\"\u0004\b\u001f\u0010 R6\u0010\u0005\u001a\u001e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\b0\u0007\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\t0\u0006j\u0002`\nX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b!\u0010\"\"\u0004\b#\u0010$R0\u0010\u000f\u001a\u0018\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\u0011\u0012\u0004\u0012\u00020\t0\u0006j\u0002`\u0012X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b%\u0010\"\"\u0004\b&\u0010$R*\u0010\u000b\u001a\u0012\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\t0\fj\u0002`\u000eX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b'\u0010(\"\u0004\b)\u0010*¨\u00069"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/delegates/FormMessageContainerAdapterDelegate;", "Lzendesk/messaging/android/internal/adapterdelegate/ListItemAdapterDelegate;", "Lzendesk/messaging/android/internal/model/MessageLogEntry$FormMessageContainer;", "Lzendesk/messaging/android/internal/model/MessageLogEntry;", "Lzendesk/messaging/android/internal/conversationscreen/delegates/FormMessageContainerAdapterDelegate$ViewHolder;", "onFormCompleted", "Lkotlin/Function2;", "", "Lzendesk/conversationkit/android/model/Field;", "", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFormCompleted;", "onFormFocusChangedListener", "Lkotlin/Function1;", "", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFormFocusChangedListener;", "onFormDisplayedFieldsChanged", "Lzendesk/ui/android/conversation/form/DisplayedField;", "", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFormDisplayedFieldsChanged;", "mapOfDisplayedForm", "", "Lzendesk/ui/android/conversation/form/DisplayedForm;", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "(Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function2;Ljava/util/Map;Lzendesk/messaging/android/internal/model/MessagingTheme;)V", "getMapOfDisplayedForm", "()Ljava/util/Map;", "setMapOfDisplayedForm", "(Ljava/util/Map;)V", "getMessagingTheme", "()Lzendesk/messaging/android/internal/model/MessagingTheme;", "setMessagingTheme", "(Lzendesk/messaging/android/internal/model/MessagingTheme;)V", "getOnFormCompleted", "()Lkotlin/jvm/functions/Function2;", "setOnFormCompleted", "(Lkotlin/jvm/functions/Function2;)V", "getOnFormDisplayedFieldsChanged", "setOnFormDisplayedFieldsChanged", "getOnFormFocusChangedListener", "()Lkotlin/jvm/functions/Function1;", "setOnFormFocusChangedListener", "(Lkotlin/jvm/functions/Function1;)V", "isForViewType", "item", "items", "position", "", "onBindViewHolder", "holder", "payloads", "", "onCreateViewHolder", "parent", "Landroid/view/ViewGroup;", "Companion", "ViewHolder", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class FormMessageContainerAdapterDelegate extends ListItemAdapterDelegate<MessageLogEntry.FormMessageContainer, MessageLogEntry, ViewHolder> {
    public static final float FORM_FIELD_BORDER_ALPHA = 0.55f;
    public static final float FORM_RESPONSE_BORDER_ALPHA = 0.12f;
    private Map<String, DisplayedForm> mapOfDisplayedForm;
    private MessagingTheme messagingTheme;
    private Function2<? super List<? extends Field>, ? super MessageLogEntry.FormMessageContainer, Unit> onFormCompleted;
    private Function2<? super DisplayedField, ? super String, Unit> onFormDisplayedFieldsChanged;
    private Function1<? super Boolean, Unit> onFormFocusChangedListener;

    @Override
    public void onBindViewHolder(Object obj, RecyclerView.ViewHolder viewHolder, List list) {
        onBindViewHolder((MessageLogEntry.FormMessageContainer) obj, (ViewHolder) viewHolder, (List<? extends Object>) list);
    }

    public FormMessageContainerAdapterDelegate(Function2 function2, Function1 function1, Function2 function3, HashMap map, MessagingTheme messagingTheme, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? MessageLogListenersKt.getNOOP_ON_FORM_COMPLETED() : function2, (i & 2) != 0 ? MessageLogListenersKt.getNOOP_ON_FORM_FOCUS_CHANGED_LISTENER() : function1, (i & 4) != 0 ? MessageLogListenersKt.getNOOP_ON_FORM_DISPLAYED_FIELDS_CHANGED() : function3, (i & 8) != 0 ? new HashMap() : map, messagingTheme);
    }

    public final Function2<List<? extends Field>, MessageLogEntry.FormMessageContainer, Unit> getOnFormCompleted() {
        return this.onFormCompleted;
    }

    public final void setOnFormCompleted(Function2<? super List<? extends Field>, ? super MessageLogEntry.FormMessageContainer, Unit> function2) {
        Intrinsics.checkNotNullParameter(function2, "<set-?>");
        this.onFormCompleted = function2;
    }

    public final Function1<Boolean, Unit> getOnFormFocusChangedListener() {
        return this.onFormFocusChangedListener;
    }

    public final void setOnFormFocusChangedListener(Function1<? super Boolean, Unit> function1) {
        Intrinsics.checkNotNullParameter(function1, "<set-?>");
        this.onFormFocusChangedListener = function1;
    }

    public final Function2<DisplayedField, String, Unit> getOnFormDisplayedFieldsChanged() {
        return this.onFormDisplayedFieldsChanged;
    }

    public final void setOnFormDisplayedFieldsChanged(Function2<? super DisplayedField, ? super String, Unit> function2) {
        Intrinsics.checkNotNullParameter(function2, "<set-?>");
        this.onFormDisplayedFieldsChanged = function2;
    }

    public final Map<String, DisplayedForm> getMapOfDisplayedForm() {
        return this.mapOfDisplayedForm;
    }

    public final void setMapOfDisplayedForm(Map<String, DisplayedForm> map) {
        Intrinsics.checkNotNullParameter(map, "<set-?>");
        this.mapOfDisplayedForm = map;
    }

    public final MessagingTheme getMessagingTheme() {
        return this.messagingTheme;
    }

    public final void setMessagingTheme(MessagingTheme messagingTheme) {
        Intrinsics.checkNotNullParameter(messagingTheme, "<set-?>");
        this.messagingTheme = messagingTheme;
    }

    public FormMessageContainerAdapterDelegate(Function2<? super List<? extends Field>, ? super MessageLogEntry.FormMessageContainer, Unit> onFormCompleted, Function1<? super Boolean, Unit> onFormFocusChangedListener, Function2<? super DisplayedField, ? super String, Unit> onFormDisplayedFieldsChanged, Map<String, DisplayedForm> mapOfDisplayedForm, MessagingTheme messagingTheme) {
        Intrinsics.checkNotNullParameter(onFormCompleted, "onFormCompleted");
        Intrinsics.checkNotNullParameter(onFormFocusChangedListener, "onFormFocusChangedListener");
        Intrinsics.checkNotNullParameter(onFormDisplayedFieldsChanged, "onFormDisplayedFieldsChanged");
        Intrinsics.checkNotNullParameter(mapOfDisplayedForm, "mapOfDisplayedForm");
        Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
        this.onFormCompleted = onFormCompleted;
        this.onFormFocusChangedListener = onFormFocusChangedListener;
        this.onFormDisplayedFieldsChanged = onFormDisplayedFieldsChanged;
        this.mapOfDisplayedForm = mapOfDisplayedForm;
        this.messagingTheme = messagingTheme;
    }

    @Override
    public boolean isForViewType(MessageLogEntry item, List<? extends MessageLogEntry> items, int position) {
        Intrinsics.checkNotNullParameter(item, "item");
        Intrinsics.checkNotNullParameter(items, "items");
        return item instanceof MessageLogEntry.FormMessageContainer;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent) {
        Intrinsics.checkNotNullParameter(parent, "parent");
        View viewInflate = LayoutInflater.from(parent.getContext()).inflate(C1256R.layout.zma_view_message_log_entry_message_container, parent, false);
        Intrinsics.checkNotNullExpressionValue(viewInflate, "inflate(...)");
        return new ViewHolder(viewInflate, this.messagingTheme);
    }

    protected void onBindViewHolder(MessageLogEntry.FormMessageContainer item, ViewHolder holder, List<? extends Object> payloads) {
        Intrinsics.checkNotNullParameter(item, "item");
        Intrinsics.checkNotNullParameter(holder, "holder");
        Intrinsics.checkNotNullParameter(payloads, "payloads");
        holder.bind(item, this.onFormCompleted, this.onFormFocusChangedListener, this.onFormDisplayedFieldsChanged, this.mapOfDisplayedForm);
    }

    @Metadata(m17d1 = {"\u0000\u0096\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010%\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0000\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J|\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\"\u0010\u0013\u001a\u001e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00160\u0015\u0012\u0004\u0012\u00020\u0012\u0012\u0004\u0012\u00020\u00100\u0014j\u0002`\u00172\u0016\u0010\u0018\u001a\u0012\u0012\u0004\u0012\u00020\u001a\u0012\u0004\u0012\u00020\u00100\u0019j\u0002`\u001b2\u001c\u0010\u001c\u001a\u0018\u0012\u0004\u0012\u00020\u001d\u0012\u0004\u0012\u00020\u001e\u0012\u0004\u0012\u00020\u00100\u0014j\u0002`\u001f2\u0012\u0010 \u001a\u000e\u0012\u0004\u0012\u00020\u001e\u0012\u0004\u0012\u00020\"0!J.\u0010#\u001a\u00020$2\u0006\u0010%\u001a\u00020&2\u001c\u0010'\u001a\u0018\u0012\u0004\u0012\u00020(\u0012\u0004\u0012\u00020(0\u0019j\b\u0012\u0004\u0012\u00020(`)H\u0002JF\u0010*\u001a\b\u0012\u0004\u0012\u00020\u00160+2\u0006\u0010%\u001a\u00020&2.\u0010'\u001a*\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00160,\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00160,0\u0019j\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00160,`)H\u0002J~\u0010-\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\"\u0010\u0013\u001a\u001e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00160\u0015\u0012\u0004\u0012\u00020\u0012\u0012\u0004\u0012\u00020\u00100\u0014j\u0002`\u00172\u0016\u0010.\u001a\u0012\u0012\u0004\u0012\u00020\u001a\u0012\u0004\u0012\u00020\u00100\u0019j\u0002`\u001b2\u001c\u0010\u001c\u001a\u0018\u0012\u0004\u0012\u00020\u001d\u0012\u0004\u0012\u00020\u001e\u0012\u0004\u0012\u00020\u00100\u0014j\u0002`\u001f2\u0012\u0010 \u001a\u000e\u0012\u0004\u0012\u00020\u001e\u0012\u0004\u0012\u00020\"0!H\u0002R\u000e\u0010\u0007\u001a\u00020\bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\t\u001a\u00020\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000b\u001a\u00020\fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\r\u001a\u00020\u000eX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006/"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/delegates/FormMessageContainerAdapterDelegate$ViewHolder;", "Landroidx/recyclerview/widget/RecyclerView$ViewHolder;", "itemView", "Landroid/view/View;", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "(Landroid/view/View;Lzendesk/messaging/android/internal/model/MessagingTheme;)V", "avatarView", "Lzendesk/ui/android/conversation/avatar/AvatarImageView;", "contentView", "Landroid/widget/LinearLayout;", "labelView", "Landroid/widget/TextView;", "receiptView", "Lzendesk/ui/android/conversation/receipt/MessageReceiptView;", "bind", "", "item", "Lzendesk/messaging/android/internal/model/MessageLogEntry$FormMessageContainer;", "onFormCompleted", "Lkotlin/Function2;", "", "Lzendesk/conversationkit/android/model/Field;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFormCompleted;", "onFormFocusChangedListener", "Lkotlin/Function1;", "", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFormFocusChangedListener;", "onFormDisplayedFieldsChanged", "Lzendesk/ui/android/conversation/form/DisplayedField;", "", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFormDisplayedFieldsChanged;", "mapOfDisplayedForm", "", "Lzendesk/ui/android/conversation/form/DisplayedForm;", "createFormResponseView", "Lzendesk/ui/android/conversation/form/FormResponseView;", "parentView", "Landroid/view/ViewGroup;", "renderingUpdate", "Lzendesk/ui/android/conversation/form/FormResponseRendering;", "Lzendesk/messaging/android/internal/conversationscreen/RenderingUpdate;", "createFormView", "Lzendesk/ui/android/conversation/form/FormView;", "Lzendesk/ui/android/conversation/form/FormRendering;", "renderContent", "onFormFocusChanged", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
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

        public final void bind(MessageLogEntry.FormMessageContainer item, Function2<? super List<? extends Field>, ? super MessageLogEntry.FormMessageContainer, Unit> onFormCompleted, Function1<? super Boolean, Unit> onFormFocusChangedListener, Function2<? super DisplayedField, ? super String, Unit> onFormDisplayedFieldsChanged, Map<String, DisplayedForm> mapOfDisplayedForm) {
            Intrinsics.checkNotNullParameter(item, "item");
            Intrinsics.checkNotNullParameter(onFormCompleted, "onFormCompleted");
            Intrinsics.checkNotNullParameter(onFormFocusChangedListener, "onFormFocusChangedListener");
            Intrinsics.checkNotNullParameter(onFormDisplayedFieldsChanged, "onFormDisplayedFieldsChanged");
            Intrinsics.checkNotNullParameter(mapOfDisplayedForm, "mapOfDisplayedForm");
            AdapterDelegatesHelper.INSTANCE.renderLabel$zendesk_messaging_messaging_android(this.labelView, item.getLabel(), item.getMessage().getContent(), this.messagingTheme);
            AdapterDelegatesHelper.INSTANCE.renderAvatar$zendesk_messaging_messaging_android(this.avatarView, item.getAvatarUrl(), item.getMessage().getContent(), item.getSize(), item.getDirection(), this.messagingTheme);
            renderContent(item, onFormCompleted, onFormFocusChangedListener, onFormDisplayedFieldsChanged, mapOfDisplayedForm);
            AdapterDelegatesHelper.INSTANCE.renderReceipt$zendesk_messaging_messaging_android(this.receiptView, item.getReceipt(), item.getDirection(), item.getStatus(), (item.getMessage().getContent() instanceof MessageContent.Unsupported) || (item.getMessage().getStatus() instanceof MessageStatus.Failed), item.getMessage().getContent() instanceof MessageContent.Unsupported, item.getMessage().getContent(), this.messagingTheme);
            AdapterDelegatesHelper adapterDelegatesHelper = AdapterDelegatesHelper.INSTANCE;
            View itemView = this.itemView;
            Intrinsics.checkNotNullExpressionValue(itemView, "itemView");
            adapterDelegatesHelper.adjustSpacing$zendesk_messaging_messaging_android(itemView, item.getPosition());
        }

        private final void renderContent(final MessageLogEntry.FormMessageContainer item, final Function2<? super List<? extends Field>, ? super MessageLogEntry.FormMessageContainer, Unit> onFormCompleted, final Function1<? super Boolean, Unit> onFormFocusChanged, Function2<? super DisplayedField, ? super String, Unit> onFormDisplayedFieldsChanged, Map<String, DisplayedForm> mapOfDisplayedForm) {
            String formId;
            List<Field> fields;
            View viewCreateFormResponseView;
            this.contentView.removeAllViews();
            if (item.getMessage().getContent() instanceof MessageContent.FormResponse) {
                MessageContent content = item.getMessage().getContent();
                Intrinsics.checkNotNull(content, "null cannot be cast to non-null type zendesk.conversationkit.android.model.MessageContent.FormResponse");
                formId = ((MessageContent.FormResponse) content).getQuotedMessageId();
            } else {
                MessageContent content2 = item.getMessage().getContent();
                Intrinsics.checkNotNull(content2, "null cannot be cast to non-null type zendesk.conversationkit.android.model.MessageContent.Form");
                formId = ((MessageContent.Form) content2).getFormId();
            }
            String str = formId;
            if (item.getMessage().getContent() instanceof MessageContent.FormResponse) {
                MessageContent content3 = item.getMessage().getContent();
                Intrinsics.checkNotNull(content3, "null cannot be cast to non-null type zendesk.conversationkit.android.model.MessageContent.FormResponse");
                fields = ((MessageContent.FormResponse) content3).getFields();
            } else {
                MessageContent content4 = item.getMessage().getContent();
                Intrinsics.checkNotNull(content4, "null cannot be cast to non-null type zendesk.conversationkit.android.model.MessageContent.Form");
                fields = ((MessageContent.Form) content4).getFields();
            }
            List<Field> list = fields;
            MessageContent content5 = item.getMessage().getContent();
            if (content5 instanceof MessageContent.Form) {
                viewCreateFormResponseView = createFormView(this.contentView, RenderingUpdates.INSTANCE.formRenderingUpdate(list, new Function1<List<? extends Field>, Unit>() {
                    {
                        super(1);
                    }

                    @Override
                    public Unit invoke(List<? extends Field> list2) {
                        invoke2(list2);
                        return Unit.INSTANCE;
                    }

                    public final void invoke2(List<? extends Field> field) {
                        Intrinsics.checkNotNullParameter(field, "field");
                        onFormCompleted.invoke(field, item);
                    }
                }, new Function1<Boolean, Unit>() {
                    {
                        super(1);
                    }

                    @Override
                    public Unit invoke(Boolean bool) {
                        invoke(bool.booleanValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(boolean z) {
                        onFormFocusChanged.invoke(Boolean.valueOf(z));
                    }
                }, this.messagingTheme.getActionColor(), item.getMessage().getStatus() instanceof MessageStatus.Pending, onFormDisplayedFieldsChanged, mapOfDisplayedForm, str, this.messagingTheme.getOnActionColor(), this.messagingTheme.getOnDangerColor(), this.messagingTheme.getOnActionBackgroundColor(), ViewKtxKt.adjustAlpha(this.messagingTheme.getOnBackgroundColor(), 0.55f), this.messagingTheme.getOnBackgroundColor(), this.messagingTheme.getSystemMessageColor(), item.getMessage().getStatus() instanceof MessageStatus.Failed));
            } else {
                if (!(content5 instanceof MessageContent.FormResponse)) {
                    return;
                }
                MessageStatus status = item.getMessage().getStatus();
                if (status instanceof MessageStatus.Pending ? true : status instanceof MessageStatus.Failed) {
                    LinearLayout linearLayout = this.contentView;
                    RenderingUpdates renderingUpdates = RenderingUpdates.INSTANCE;
                    int actionColor = this.messagingTheme.getActionColor();
                    boolean z = item.getMessage().getStatus() instanceof MessageStatus.Pending;
                    int onDangerColor = this.messagingTheme.getOnDangerColor();
                    viewCreateFormResponseView = createFormView(linearLayout, renderingUpdates.formRenderingUpdate(list, new Function1<List<? extends Field>, Unit>() {
                        {
                            super(1);
                        }

                        @Override
                        public Unit invoke(List<? extends Field> list2) {
                            invoke2(list2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke2(List<? extends Field> field) {
                            Intrinsics.checkNotNullParameter(field, "field");
                            onFormCompleted.invoke(field, item);
                        }
                    }, new Function1<Boolean, Unit>() {
                        {
                            super(1);
                        }

                        @Override
                        public Unit invoke(Boolean bool) {
                            invoke(bool.booleanValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(boolean z2) {
                            onFormFocusChanged.invoke(Boolean.valueOf(z2));
                        }
                    }, actionColor, z, onFormDisplayedFieldsChanged, mapOfDisplayedForm, str, this.messagingTheme.getOnActionColor(), onDangerColor, this.messagingTheme.getOnActionBackgroundColor(), ViewKtxKt.adjustAlpha(this.messagingTheme.getOnBackgroundColor(), 0.55f), this.messagingTheme.getOnBackgroundColor(), this.messagingTheme.getSystemMessageColor(), item.getMessage().getStatus() instanceof MessageStatus.Failed));
                } else if (!(status instanceof MessageStatus.Sent)) {
                    return;
                } else {
                    viewCreateFormResponseView = createFormResponseView(this.contentView, RenderingUpdates.INSTANCE.formResponseRenderingUpdate(list, ViewKtxKt.adjustAlpha(this.messagingTheme.getOnBackgroundColor(), 0.12f), this.messagingTheme.getSystemMessageColor(), this.messagingTheme.getOnBackgroundColor()));
                }
            }
            View view = viewCreateFormResponseView;
            AdapterDelegatesHelper.INSTANCE.adjustDirectionAndWidth$zendesk_messaging_messaging_android(view, item.getMessage().getContent(), item.getDirection(), this.contentView);
            this.contentView.addView(view);
        }

        private final FormView<Field> createFormView(ViewGroup parentView, Function1<? super FormRendering<Field>, FormRendering<Field>> renderingUpdate) {
            Context context = parentView.getContext();
            Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
            FormView<Field> formView = new FormView<>(context, null, 0, 0, 14, null);
            formView.render(renderingUpdate);
            return formView;
        }

        private final FormResponseView createFormResponseView(ViewGroup parentView, Function1<? super FormResponseRendering, FormResponseRendering> renderingUpdate) {
            Context context = parentView.getContext();
            Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
            FormResponseView formResponseView = new FormResponseView(context, null, 0, 0, 14, null);
            formResponseView.render(renderingUpdate);
            return formResponseView;
        }
    }
}
