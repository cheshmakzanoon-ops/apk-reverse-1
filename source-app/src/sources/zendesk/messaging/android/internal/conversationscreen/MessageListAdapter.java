package zendesk.messaging.android.internal.conversationscreen;

import androidx.recyclerview.widget.DiffUtil;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.model.Field;
import zendesk.conversationkit.android.model.Message;
import zendesk.conversationkit.android.model.MessageAction;
import zendesk.conversationkit.android.model.MessageActionType;
import zendesk.conversationkit.android.model.MessageContent;
import zendesk.messaging.android.internal.UriHandler;
import zendesk.messaging.android.internal.WebViewUriHandler;
import zendesk.messaging.android.internal.adapterdelegate.AdapterDelegatesManager;
import zendesk.messaging.android.internal.adapterdelegate.AsyncListDifferDelegationAdapter;
import zendesk.messaging.android.internal.conversationscreen.delegates.CarouselContainerAdapterDelegate;
import zendesk.messaging.android.internal.conversationscreen.delegates.FileMessageContainerAdapterDelegate;
import zendesk.messaging.android.internal.conversationscreen.delegates.FormMessageContainerAdapterDelegate;
import zendesk.messaging.android.internal.conversationscreen.delegates.ImageMessageContainerAdapterDelegate;
import zendesk.messaging.android.internal.conversationscreen.delegates.MessageLoadMoreAdapterDelegate;
import zendesk.messaging.android.internal.conversationscreen.delegates.MessagesDividerAdapterDelegate;
import zendesk.messaging.android.internal.conversationscreen.delegates.QuickReplyAdapterDelegate;
import zendesk.messaging.android.internal.conversationscreen.delegates.TextMessageContainerAdapterDelegate;
import zendesk.messaging.android.internal.conversationscreen.delegates.TypingIndicatorContainerAdapterDelegate;
import zendesk.messaging.android.internal.model.MessageLogEntry;
import zendesk.messaging.android.internal.model.MessagingTheme;
import zendesk.p026ui.android.conversation.carousel.CarouselAction;
import zendesk.p026ui.android.conversation.form.DisplayedField;
import zendesk.p026ui.android.conversation.form.DisplayedForm;

@Metadata(m17d1 = {"\u0000ò\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010%\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0007\b\u0000\u0018\u0000 m2\b\u0012\u0004\u0012\u00020\u00020\u0001:\u0001mB_\u0012\b\b\u0002\u0010\u0003\u001a\u00020\u0004\u0012\b\b\u0002\u0010\u0005\u001a\u00020\u0006\u0012\b\b\u0002\u0010\u0007\u001a\u00020\b\u0012\b\b\u0002\u0010\t\u001a\u00020\n\u0012\b\b\u0002\u0010\u000b\u001a\u00020\f\u0012\b\b\u0002\u0010\r\u001a\u00020\u000e\u0012\b\b\u0002\u0010\u000f\u001a\u00020\u0010\u0012\b\b\u0002\u0010\u0011\u001a\u00020\u0012\u0012\b\b\u0002\u0010\u0013\u001a\u00020\u0014¢\u0006\u0002\u0010\u0015R\u000e\u0010\u0013\u001a\u00020\u0014X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\r\u001a\u00020\u000eX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0011\u001a\u00020\u0012X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000f\u001a\u00020\u0010X\u0082\u0004¢\u0006\u0002\n\u0000R<\u0010\u001a\u001a\u000e\u0012\u0004\u0012\u00020\u0018\u0012\u0004\u0012\u00020\u00190\u00172\u0012\u0010\u0016\u001a\u000e\u0012\u0004\u0012\u00020\u0018\u0012\u0004\u0012\u00020\u00190\u00178F@FX\u0086\u000e¢\u0006\f\u001a\u0004\b\u001b\u0010\u001c\"\u0004\b\u001d\u0010\u001eR\u000e\u0010\u0007\u001a\u00020\bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R$\u0010 \u001a\u00020\u001f2\u0006\u0010\u0016\u001a\u00020\u001f8F@FX\u0086\u000e¢\u0006\f\u001a\u0004\b!\u0010\"\"\u0004\b#\u0010$RD\u0010)\u001a\u0012\u0012\u0004\u0012\u00020&\u0012\u0004\u0012\u00020'0%j\u0002`(2\u0016\u0010\u0016\u001a\u0012\u0012\u0004\u0012\u00020&\u0012\u0004\u0012\u00020'0%j\u0002`(8F@FX\u0086\u000e¢\u0006\f\u001a\u0004\b*\u0010+\"\u0004\b,\u0010-RD\u0010/\u001a\u0012\u0012\u0004\u0012\u00020\u0018\u0012\u0004\u0012\u00020'0%j\u0002`.2\u0016\u0010\u0016\u001a\u0012\u0012\u0004\u0012\u00020\u0018\u0012\u0004\u0012\u00020'0%j\u0002`.8F@FX\u0086\u000e¢\u0006\f\u001a\u0004\b0\u0010+\"\u0004\b1\u0010-Rb\u00107\u001a!\u0012\u0013\u0012\u001102¢\u0006\f\b3\u0012\b\b4\u0012\u0004\b\b(5\u0012\u0004\u0012\u00020'0%j\u0002`62%\u0010\u0016\u001a!\u0012\u0013\u0012\u001102¢\u0006\f\b3\u0012\b\b4\u0012\u0004\b\b(5\u0012\u0004\u0012\u00020'0%j\u0002`68F@FX\u0086\u000e¢\u0006\f\u001a\u0004\b8\u0010+\"\u0004\b9\u0010-RD\u0010;\u001a\u0012\u0012\u0004\u0012\u000202\u0012\u0004\u0012\u00020'0%j\u0002`:2\u0016\u0010\u0016\u001a\u0012\u0012\u0004\u0012\u000202\u0012\u0004\u0012\u00020'0%j\u0002`:8F@FX\u0086\u000e¢\u0006\f\u001a\u0004\b<\u0010+\"\u0004\b=\u0010-R\\\u0010C\u001a\u001e\u0012\n\u0012\b\u0012\u0004\u0012\u00020@0?\u0012\u0004\u0012\u00020A\u0012\u0004\u0012\u00020'0>j\u0002`B2\"\u0010\u0016\u001a\u001e\u0012\n\u0012\b\u0012\u0004\u0012\u00020@0?\u0012\u0004\u0012\u00020A\u0012\u0004\u0012\u00020'0>j\u0002`B8F@FX\u0086\u000e¢\u0006\f\u001a\u0004\bD\u0010E\"\u0004\bF\u0010GRP\u0010J\u001a\u0018\u0012\u0004\u0012\u00020H\u0012\u0004\u0012\u00020\u0018\u0012\u0004\u0012\u00020'0>j\u0002`I2\u001c\u0010\u0016\u001a\u0018\u0012\u0004\u0012\u00020H\u0012\u0004\u0012\u00020\u0018\u0012\u0004\u0012\u00020'0>j\u0002`I8F@FX\u0086\u000e¢\u0006\f\u001a\u0004\bK\u0010E\"\u0004\bL\u0010GRD\u0010O\u001a\u0012\u0012\u0004\u0012\u00020M\u0012\u0004\u0012\u00020'0%j\u0002`N2\u0016\u0010\u0016\u001a\u0012\u0012\u0004\u0012\u00020M\u0012\u0004\u0012\u00020'0%j\u0002`N8F@FX\u0086\u000e¢\u0006\f\u001a\u0004\bP\u0010+\"\u0004\bQ\u0010-R4\u0010S\u001a\n\u0012\u0004\u0012\u00020'\u0018\u00010R2\u000e\u0010\u0016\u001a\n\u0012\u0004\u0012\u00020'\u0018\u00010R8F@FX\u0086\u000e¢\u0006\f\u001a\u0004\bT\u0010U\"\u0004\bV\u0010WRD\u0010Z\u001a\u0012\u0012\u0004\u0012\u00020X\u0012\u0004\u0012\u00020'0%j\u0002`Y2\u0016\u0010\u0016\u001a\u0012\u0012\u0004\u0012\u00020X\u0012\u0004\u0012\u00020'0%j\u0002`Y8F@FX\u0086\u000e¢\u0006\f\u001a\u0004\b[\u0010+\"\u0004\b\\\u0010-RP\u0010^\u001a\u0018\u0012\u0004\u0012\u00020\u0018\u0012\u0004\u0012\u00020\u0018\u0012\u0004\u0012\u00020'0>j\u0002`]2\u001c\u0010\u0016\u001a\u0018\u0012\u0004\u0012\u00020\u0018\u0012\u0004\u0012\u00020\u0018\u0012\u0004\u0012\u00020'0>j\u0002`]8F@FX\u0086\u000e¢\u0006\f\u001a\u0004\b_\u0010E\"\u0004\b`\u0010GR$\u0010b\u001a\u00020a2\u0006\u0010\u0016\u001a\u00020a8F@FX\u0086\u000e¢\u0006\f\u001a\u0004\bc\u0010d\"\u0004\be\u0010fR$\u0010h\u001a\u00020g2\u0006\u0010\u0016\u001a\u00020g8F@FX\u0086\u000e¢\u0006\f\u001a\u0004\bi\u0010j\"\u0004\bk\u0010lR\u000e\u0010\t\u001a\u00020\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000b\u001a\u00020\fX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006n"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/MessageListAdapter;", "Lzendesk/messaging/android/internal/adapterdelegate/AsyncListDifferDelegationAdapter;", "Lzendesk/messaging/android/internal/model/MessageLogEntry;", "textMessageContainerAdapterDelegate", "Lzendesk/messaging/android/internal/conversationscreen/delegates/TextMessageContainerAdapterDelegate;", "messagesDividerAdapterDelegate", "Lzendesk/messaging/android/internal/conversationscreen/delegates/MessagesDividerAdapterDelegate;", "messageLoadMoreAdapterDelegate", "Lzendesk/messaging/android/internal/conversationscreen/delegates/MessageLoadMoreAdapterDelegate;", "quickReplyAdapterDelegate", "Lzendesk/messaging/android/internal/conversationscreen/delegates/QuickReplyAdapterDelegate;", "typingIndicatorContainerAdapterDelegate", "Lzendesk/messaging/android/internal/conversationscreen/delegates/TypingIndicatorContainerAdapterDelegate;", "fileMessageContainerAdapterDelegate", "Lzendesk/messaging/android/internal/conversationscreen/delegates/FileMessageContainerAdapterDelegate;", "imageMessageContainerAdapterDelegate", "Lzendesk/messaging/android/internal/conversationscreen/delegates/ImageMessageContainerAdapterDelegate;", "formMessageContainerAdapterDelegate", "Lzendesk/messaging/android/internal/conversationscreen/delegates/FormMessageContainerAdapterDelegate;", "carouselContainerAdapterDelegate", "Lzendesk/messaging/android/internal/conversationscreen/delegates/CarouselContainerAdapterDelegate;", "(Lzendesk/messaging/android/internal/conversationscreen/delegates/TextMessageContainerAdapterDelegate;Lzendesk/messaging/android/internal/conversationscreen/delegates/MessagesDividerAdapterDelegate;Lzendesk/messaging/android/internal/conversationscreen/delegates/MessageLoadMoreAdapterDelegate;Lzendesk/messaging/android/internal/conversationscreen/delegates/QuickReplyAdapterDelegate;Lzendesk/messaging/android/internal/conversationscreen/delegates/TypingIndicatorContainerAdapterDelegate;Lzendesk/messaging/android/internal/conversationscreen/delegates/FileMessageContainerAdapterDelegate;Lzendesk/messaging/android/internal/conversationscreen/delegates/ImageMessageContainerAdapterDelegate;Lzendesk/messaging/android/internal/conversationscreen/delegates/FormMessageContainerAdapterDelegate;Lzendesk/messaging/android/internal/conversationscreen/delegates/CarouselContainerAdapterDelegate;)V", "value", "", "", "Lzendesk/ui/android/conversation/form/DisplayedForm;", "mapOfDisplayedFields", "getMapOfDisplayedFields", "()Ljava/util/Map;", "setMapOfDisplayedFields", "(Ljava/util/Map;)V", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "messagingTheme", "getMessagingTheme", "()Lzendesk/messaging/android/internal/model/MessagingTheme;", "setMessagingTheme", "(Lzendesk/messaging/android/internal/model/MessagingTheme;)V", "Lkotlin/Function1;", "Lzendesk/ui/android/conversation/carousel/CarouselAction;", "", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnCarouselAction;", "onCarouselAction", "getOnCarouselAction", "()Lkotlin/jvm/functions/Function1;", "setOnCarouselAction", "(Lkotlin/jvm/functions/Function1;)V", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnCopyTextAction;", "onCopyText", "getOnCopyText", "setOnCopyText", "Lzendesk/conversationkit/android/model/Message;", "Lkotlin/ParameterName;", "name", "message", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFailedMessageClickedListener;", "onFailedMessageClicked", "getOnFailedMessageClicked", "setOnFailedMessageClicked", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFileAttachmentClicked;", "onFileAttachmentClicked", "getOnFileAttachmentClicked", "setOnFileAttachmentClicked", "Lkotlin/Function2;", "", "Lzendesk/conversationkit/android/model/Field;", "Lzendesk/messaging/android/internal/model/MessageLogEntry$FormMessageContainer;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFormCompleted;", "onFormCompleted", "getOnFormCompleted", "()Lkotlin/jvm/functions/Function2;", "setOnFormCompleted", "(Lkotlin/jvm/functions/Function2;)V", "Lzendesk/ui/android/conversation/form/DisplayedField;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFormDisplayedFieldsChanged;", "onFormDisplayedFieldsChanged", "getOnFormDisplayedFieldsChanged", "setOnFormDisplayedFieldsChanged", "", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFormFocusChangedListener;", "onFormFocusChanged", "getOnFormFocusChanged", "setOnFormFocusChanged", "Lkotlin/Function0;", "onLoadMoreRetryClicked", "getOnLoadMoreRetryClicked", "()Lkotlin/jvm/functions/Function0;", "setOnLoadMoreRetryClicked", "(Lkotlin/jvm/functions/Function0;)V", "Lzendesk/conversationkit/android/model/MessageAction$Reply;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnReplyActionSelected;", "onReplyActionSelected", "getOnReplyActionSelected", "setOnReplyActionSelected", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnSendPostbackMessage;", "onSendPostbackMessage", "getOnSendPostbackMessage", "setOnSendPostbackMessage", "Lzendesk/messaging/android/internal/UriHandler;", "onUriClicked", "getOnUriClicked", "()Lzendesk/messaging/android/internal/UriHandler;", "setOnUriClicked", "(Lzendesk/messaging/android/internal/UriHandler;)V", "Lzendesk/messaging/android/internal/WebViewUriHandler;", "onWebViewUriClicked", "getOnWebViewUriClicked", "()Lzendesk/messaging/android/internal/WebViewUriHandler;", "setOnWebViewUriClicked", "(Lzendesk/messaging/android/internal/WebViewUriHandler;)V", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessageListAdapter extends AsyncListDifferDelegationAdapter<MessageLogEntry> {

    public static final Companion INSTANCE = new Companion(null);
    private final CarouselContainerAdapterDelegate carouselContainerAdapterDelegate;
    private final FileMessageContainerAdapterDelegate fileMessageContainerAdapterDelegate;
    private final FormMessageContainerAdapterDelegate formMessageContainerAdapterDelegate;
    private final ImageMessageContainerAdapterDelegate imageMessageContainerAdapterDelegate;
    private final MessageLoadMoreAdapterDelegate messageLoadMoreAdapterDelegate;
    private final MessagesDividerAdapterDelegate messagesDividerAdapterDelegate;
    private final QuickReplyAdapterDelegate quickReplyAdapterDelegate;
    private final TextMessageContainerAdapterDelegate textMessageContainerAdapterDelegate;
    private final TypingIndicatorContainerAdapterDelegate typingIndicatorContainerAdapterDelegate;

    public MessageListAdapter() {
        this(null, null, null, null, null, null, null, null, null, 511, null);
    }

    public MessageListAdapter(TextMessageContainerAdapterDelegate textMessageContainerAdapterDelegate, MessagesDividerAdapterDelegate messagesDividerAdapterDelegate, MessageLoadMoreAdapterDelegate messageLoadMoreAdapterDelegate, QuickReplyAdapterDelegate quickReplyAdapterDelegate, TypingIndicatorContainerAdapterDelegate typingIndicatorContainerAdapterDelegate, FileMessageContainerAdapterDelegate fileMessageContainerAdapterDelegate, ImageMessageContainerAdapterDelegate imageMessageContainerAdapterDelegate, FormMessageContainerAdapterDelegate formMessageContainerAdapterDelegate, CarouselContainerAdapterDelegate carouselContainerAdapterDelegate, int i, DefaultConstructorMarker defaultConstructorMarker) {
        QuickReplyAdapterDelegate quickReplyAdapterDelegate2;
        CarouselContainerAdapterDelegate carouselContainerAdapterDelegate2;
        TextMessageContainerAdapterDelegate textMessageContainerAdapterDelegate2 = (i & 1) != 0 ? new TextMessageContainerAdapterDelegate(null, null, null, MessagingTheme.INSTANCE.getDEFAULT(), null, null, 55, null) : textMessageContainerAdapterDelegate;
        MessagesDividerAdapterDelegate messagesDividerAdapterDelegate2 = (i & 2) != 0 ? new MessagesDividerAdapterDelegate(MessagingTheme.INSTANCE.getDEFAULT()) : messagesDividerAdapterDelegate;
        MessageLoadMoreAdapterDelegate messageLoadMoreAdapterDelegate2 = (i & 4) != 0 ? new MessageLoadMoreAdapterDelegate() : messageLoadMoreAdapterDelegate;
        Function1 function1 = null;
        Object[] objArr = 0;
        Object[] objArr2 = 0;
        Object[] objArr3 = 0;
        int i2 = 1;
        if ((i & 8) != 0) {
            quickReplyAdapterDelegate2 = new QuickReplyAdapterDelegate(function1, MessagingTheme.INSTANCE.getDEFAULT(), i2, objArr3 == true ? 1 : 0);
        } else {
            quickReplyAdapterDelegate2 = quickReplyAdapterDelegate;
        }
        TypingIndicatorContainerAdapterDelegate typingIndicatorContainerAdapterDelegate2 = (i & 16) != 0 ? new TypingIndicatorContainerAdapterDelegate(MessagingTheme.INSTANCE.getDEFAULT()) : typingIndicatorContainerAdapterDelegate;
        FileMessageContainerAdapterDelegate fileMessageContainerAdapterDelegate2 = (i & 32) != 0 ? new FileMessageContainerAdapterDelegate(null, null, null, MessagingTheme.INSTANCE.getDEFAULT(), 7, null) : fileMessageContainerAdapterDelegate;
        ImageMessageContainerAdapterDelegate imageMessageContainerAdapterDelegate2 = (i & 64) != 0 ? new ImageMessageContainerAdapterDelegate(null, null, MessagingTheme.INSTANCE.getDEFAULT(), null, null, 27, null) : imageMessageContainerAdapterDelegate;
        FormMessageContainerAdapterDelegate formMessageContainerAdapterDelegate2 = (i & 128) != 0 ? new FormMessageContainerAdapterDelegate(null, null, null, null, MessagingTheme.INSTANCE.getDEFAULT(), 15, null) : formMessageContainerAdapterDelegate;
        if ((i & 256) != 0) {
            carouselContainerAdapterDelegate2 = new CarouselContainerAdapterDelegate(objArr2 == true ? 1 : 0, MessagingTheme.INSTANCE.getDEFAULT(), i2, objArr == true ? 1 : 0);
        } else {
            carouselContainerAdapterDelegate2 = carouselContainerAdapterDelegate;
        }
        this(textMessageContainerAdapterDelegate2, messagesDividerAdapterDelegate2, messageLoadMoreAdapterDelegate2, quickReplyAdapterDelegate2, typingIndicatorContainerAdapterDelegate2, fileMessageContainerAdapterDelegate2, imageMessageContainerAdapterDelegate2, formMessageContainerAdapterDelegate2, carouselContainerAdapterDelegate2);
    }

    public MessageListAdapter(TextMessageContainerAdapterDelegate textMessageContainerAdapterDelegate, MessagesDividerAdapterDelegate messagesDividerAdapterDelegate, MessageLoadMoreAdapterDelegate messageLoadMoreAdapterDelegate, QuickReplyAdapterDelegate quickReplyAdapterDelegate, TypingIndicatorContainerAdapterDelegate typingIndicatorContainerAdapterDelegate, FileMessageContainerAdapterDelegate fileMessageContainerAdapterDelegate, ImageMessageContainerAdapterDelegate imageMessageContainerAdapterDelegate, FormMessageContainerAdapterDelegate formMessageContainerAdapterDelegate, CarouselContainerAdapterDelegate carouselContainerAdapterDelegate) {
        super(INSTANCE, new AdapterDelegatesManager(formMessageContainerAdapterDelegate, fileMessageContainerAdapterDelegate, textMessageContainerAdapterDelegate, messagesDividerAdapterDelegate, typingIndicatorContainerAdapterDelegate, messageLoadMoreAdapterDelegate, quickReplyAdapterDelegate, imageMessageContainerAdapterDelegate, carouselContainerAdapterDelegate));
        Intrinsics.checkNotNullParameter(textMessageContainerAdapterDelegate, "textMessageContainerAdapterDelegate");
        Intrinsics.checkNotNullParameter(messagesDividerAdapterDelegate, "messagesDividerAdapterDelegate");
        Intrinsics.checkNotNullParameter(messageLoadMoreAdapterDelegate, "messageLoadMoreAdapterDelegate");
        Intrinsics.checkNotNullParameter(quickReplyAdapterDelegate, "quickReplyAdapterDelegate");
        Intrinsics.checkNotNullParameter(typingIndicatorContainerAdapterDelegate, "typingIndicatorContainerAdapterDelegate");
        Intrinsics.checkNotNullParameter(fileMessageContainerAdapterDelegate, "fileMessageContainerAdapterDelegate");
        Intrinsics.checkNotNullParameter(imageMessageContainerAdapterDelegate, "imageMessageContainerAdapterDelegate");
        Intrinsics.checkNotNullParameter(formMessageContainerAdapterDelegate, "formMessageContainerAdapterDelegate");
        Intrinsics.checkNotNullParameter(carouselContainerAdapterDelegate, "carouselContainerAdapterDelegate");
        this.textMessageContainerAdapterDelegate = textMessageContainerAdapterDelegate;
        this.messagesDividerAdapterDelegate = messagesDividerAdapterDelegate;
        this.messageLoadMoreAdapterDelegate = messageLoadMoreAdapterDelegate;
        this.quickReplyAdapterDelegate = quickReplyAdapterDelegate;
        this.typingIndicatorContainerAdapterDelegate = typingIndicatorContainerAdapterDelegate;
        this.fileMessageContainerAdapterDelegate = fileMessageContainerAdapterDelegate;
        this.imageMessageContainerAdapterDelegate = imageMessageContainerAdapterDelegate;
        this.formMessageContainerAdapterDelegate = formMessageContainerAdapterDelegate;
        this.carouselContainerAdapterDelegate = carouselContainerAdapterDelegate;
    }

    public final Function1<MessageAction.Reply, Unit> getOnReplyActionSelected() {
        return this.quickReplyAdapterDelegate.getOnOptionSelected();
    }

    public final void setOnReplyActionSelected(Function1<? super MessageAction.Reply, Unit> value) {
        Intrinsics.checkNotNullParameter(value, "value");
        this.quickReplyAdapterDelegate.setOnOptionSelected(value);
    }

    public final MessagingTheme getMessagingTheme() {
        return this.textMessageContainerAdapterDelegate.getMessagingTheme();
    }

    public final void setMessagingTheme(MessagingTheme value) {
        Intrinsics.checkNotNullParameter(value, "value");
        this.carouselContainerAdapterDelegate.setMessagingTheme(value);
        this.textMessageContainerAdapterDelegate.setMessagingTheme(value);
        this.messagesDividerAdapterDelegate.setMessagingTheme(value);
        this.quickReplyAdapterDelegate.setMessagingTheme(value);
        this.typingIndicatorContainerAdapterDelegate.setMessagingTheme(value);
        this.fileMessageContainerAdapterDelegate.setMessagingTheme(value);
        this.formMessageContainerAdapterDelegate.setMessagingTheme(value);
        this.imageMessageContainerAdapterDelegate.setMessagingTheme(value);
    }

    public final Function1<Message, Unit> getOnFailedMessageClicked() {
        return this.textMessageContainerAdapterDelegate.getOnFailedMessageClicked();
    }

    public final void setOnFailedMessageClicked(Function1<? super Message, Unit> value) {
        Intrinsics.checkNotNullParameter(value, "value");
        this.textMessageContainerAdapterDelegate.setOnFailedMessageClicked(value);
        this.fileMessageContainerAdapterDelegate.setOnFailedMessageClicked(value);
        this.imageMessageContainerAdapterDelegate.setOnFailedMessageClicked(value);
    }

    public final UriHandler getOnUriClicked() {
        return this.textMessageContainerAdapterDelegate.getOnUriClicked();
    }

    public final void setOnUriClicked(UriHandler value) {
        Intrinsics.checkNotNullParameter(value, "value");
        this.textMessageContainerAdapterDelegate.setOnUriClicked(value);
        this.fileMessageContainerAdapterDelegate.setOnUriClicked(value);
        this.imageMessageContainerAdapterDelegate.setOnUriClicked(value);
    }

    public final WebViewUriHandler getOnWebViewUriClicked() {
        return this.textMessageContainerAdapterDelegate.getOnWebViewUriClicked();
    }

    public final void setOnWebViewUriClicked(WebViewUriHandler value) {
        Intrinsics.checkNotNullParameter(value, "value");
        this.textMessageContainerAdapterDelegate.setOnWebViewUriClicked(value);
        this.imageMessageContainerAdapterDelegate.setOnWebViewUriClicked(value);
    }

    public final Function2<List<? extends Field>, MessageLogEntry.FormMessageContainer, Unit> getOnFormCompleted() {
        return this.formMessageContainerAdapterDelegate.getOnFormCompleted();
    }

    public final void setOnFormCompleted(Function2<? super List<? extends Field>, ? super MessageLogEntry.FormMessageContainer, Unit> value) {
        Intrinsics.checkNotNullParameter(value, "value");
        this.formMessageContainerAdapterDelegate.setOnFormCompleted(value);
    }

    public final Function1<CarouselAction, Unit> getOnCarouselAction() {
        return this.carouselContainerAdapterDelegate.getOnCarouselAction();
    }

    public final void setOnCarouselAction(Function1<? super CarouselAction, Unit> value) {
        Intrinsics.checkNotNullParameter(value, "value");
        this.carouselContainerAdapterDelegate.setOnCarouselAction(value);
    }

    public final Function2<String, String, Unit> getOnSendPostbackMessage() {
        return this.textMessageContainerAdapterDelegate.getOnSendPostbackMessage();
    }

    public final void setOnSendPostbackMessage(Function2<? super String, ? super String, Unit> value) {
        Intrinsics.checkNotNullParameter(value, "value");
        this.imageMessageContainerAdapterDelegate.setOnSendPostbackMessage(value);
        this.textMessageContainerAdapterDelegate.setOnSendPostbackMessage(value);
    }

    public final Function1<String, Unit> getOnCopyText() {
        return this.textMessageContainerAdapterDelegate.getOnCopyText();
    }

    public final void setOnCopyText(Function1<? super String, Unit> value) {
        Intrinsics.checkNotNullParameter(value, "value");
        this.textMessageContainerAdapterDelegate.setOnCopyText(value);
    }

    public final Function1<Boolean, Unit> getOnFormFocusChanged() {
        return this.formMessageContainerAdapterDelegate.getOnFormFocusChangedListener();
    }

    public final void setOnFormFocusChanged(Function1<? super Boolean, Unit> value) {
        Intrinsics.checkNotNullParameter(value, "value");
        this.formMessageContainerAdapterDelegate.setOnFormFocusChangedListener(value);
    }

    public final Function2<DisplayedField, String, Unit> getOnFormDisplayedFieldsChanged() {
        return this.formMessageContainerAdapterDelegate.getOnFormDisplayedFieldsChanged();
    }

    public final void setOnFormDisplayedFieldsChanged(Function2<? super DisplayedField, ? super String, Unit> value) {
        Intrinsics.checkNotNullParameter(value, "value");
        this.formMessageContainerAdapterDelegate.setOnFormDisplayedFieldsChanged(value);
    }

    public final Map<String, DisplayedForm> getMapOfDisplayedFields() {
        return this.formMessageContainerAdapterDelegate.getMapOfDisplayedForm();
    }

    public final void setMapOfDisplayedFields(Map<String, DisplayedForm> value) {
        Intrinsics.checkNotNullParameter(value, "value");
        this.formMessageContainerAdapterDelegate.setMapOfDisplayedForm(value);
    }

    public final Function0<Unit> getOnLoadMoreRetryClicked() {
        return this.messageLoadMoreAdapterDelegate.getOnRetryClicked$zendesk_messaging_messaging_android();
    }

    public final void setOnLoadMoreRetryClicked(Function0<Unit> function0) {
        this.messageLoadMoreAdapterDelegate.setOnRetryClicked$zendesk_messaging_messaging_android(function0);
    }

    public final Function1<Message, Unit> getOnFileAttachmentClicked() {
        return this.fileMessageContainerAdapterDelegate.getOnFileAttachmentClicked();
    }

    public final void setOnFileAttachmentClicked(Function1<? super Message, Unit> value) {
        Intrinsics.checkNotNullParameter(value, "value");
        this.fileMessageContainerAdapterDelegate.setOnFileAttachmentClicked(value);
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0086\u0003\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001:\u0001\u000fB\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u00022\u0006\u0010\u0007\u001a\u00020\u0002H\u0016J\u0018\u0010\b\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u00022\u0006\u0010\u0007\u001a\u00020\u0002H\u0016J\"\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\f2\b\b\u0002\u0010\u000e\u001a\u00020\u0005H\u0002¨\u0006\u0010"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/MessageListAdapter$Companion;", "Landroidx/recyclerview/widget/DiffUtil$ItemCallback;", "Lzendesk/messaging/android/internal/model/MessageLogEntry;", "()V", "areContentsTheSame", "", "oldItem", "newItem", "areItemsTheSame", "getPostbackInfo", "Lzendesk/messaging/android/internal/conversationscreen/MessageListAdapter$Companion$PostbackDiffData;", "oldItemContent", "Lzendesk/conversationkit/android/model/MessageContent;", "newItemContent", "isText", "PostbackDiffData", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion extends DiffUtil.ItemCallback<MessageLogEntry> {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public boolean areItemsTheSame(zendesk.messaging.android.internal.model.MessageLogEntry r7, zendesk.messaging.android.internal.model.MessageLogEntry r8) {
            throw new UnsupportedOperationException("Method not decompiled: zendesk.messaging.android.internal.conversationscreen.MessageListAdapter.Companion.areItemsTheSame(zendesk.messaging.android.internal.model.MessageLogEntry, zendesk.messaging.android.internal.model.MessageLogEntry):boolean");
        }

        static PostbackDiffData getPostbackInfo$default(Companion companion, MessageContent messageContent, MessageContent messageContent2, boolean z, int i, Object obj) {
            if ((i & 4) != 0) {
                z = false;
            }
            return companion.getPostbackInfo(messageContent, messageContent2, z);
        }

        private final PostbackDiffData getPostbackInfo(MessageContent oldItemContent, MessageContent newItemContent, boolean isText) {
            boolean z;
            MessageAction.Postback postback;
            List<MessageAction> actions;
            Iterator<MessageAction> it;
            boolean z2;
            MessageAction next;
            boolean z3;
            List<MessageAction> actions2;
            Iterator<MessageAction> it2;
            MessageAction next2;
            boolean z4 = false;
            MessageAction.Postback postback2 = null;
            if (isText) {
                Intrinsics.checkNotNull(newItemContent, "null cannot be cast to non-null type zendesk.conversationkit.android.model.MessageContent.Text");
                List<MessageAction> actions3 = ((MessageContent.Text) newItemContent).getActions();
                if (actions3 != null) {
                    Iterator<MessageAction> it3 = actions3.iterator();
                    z = false;
                    while (true) {
                        if (it3.hasNext()) {
                            MessageAction next3 = it3.next();
                            boolean z5 = next3.getMessageActionType() == MessageActionType.POSTBACK;
                            if (z5) {
                                Intrinsics.checkNotNull(next3, "null cannot be cast to non-null type zendesk.conversationkit.android.model.MessageAction.Postback");
                                postback = (MessageAction.Postback) next3;
                                z = z5;
                                break;
                            }
                            z = z5;
                        }
                    }
                    Intrinsics.checkNotNull(oldItemContent, "null cannot be cast to non-null type zendesk.conversationkit.android.model.MessageContent.Text");
                    actions2 = ((MessageContent.Text) oldItemContent).getActions();
                    if (actions2 != null) {
                        it2 = actions2.iterator();
                        z2 = false;
                        while (true) {
                            if (it2.hasNext()) {
                                next2 = it2.next();
                                if (next2.getMessageActionType() == MessageActionType.POSTBACK) {
                                    z3 = true;
                                } else {
                                    z3 = false;
                                }
                                if (z3) {
                                    Intrinsics.checkNotNull(next2, "null cannot be cast to non-null type zendesk.conversationkit.android.model.MessageAction.Postback");
                                    postback2 = (MessageAction.Postback) next2;
                                    z4 = z3;
                                } else {
                                    z2 = z3;
                                }
                            } else {
                                z4 = z2;
                            }
                        }
                    }
                } else {
                    z = false;
                }
                postback = null;
                Intrinsics.checkNotNull(oldItemContent, "null cannot be cast to non-null type zendesk.conversationkit.android.model.MessageContent.Text");
                actions2 = ((MessageContent.Text) oldItemContent).getActions();
                if (actions2 != null) {
                    it2 = actions2.iterator();
                    z2 = false;
                    while (true) {
                        if (it2.hasNext()) {
                            next2 = it2.next();
                            if (next2.getMessageActionType() == MessageActionType.POSTBACK) {
                                z3 = true;
                            } else {
                                z3 = false;
                            }
                            if (z3) {
                                Intrinsics.checkNotNull(next2, "null cannot be cast to non-null type zendesk.conversationkit.android.model.MessageAction.Postback");
                                postback2 = (MessageAction.Postback) next2;
                                z4 = z3;
                            } else {
                                z2 = z3;
                            }
                        } else {
                            z4 = z2;
                        }
                    }
                }
            } else {
                Intrinsics.checkNotNull(newItemContent, "null cannot be cast to non-null type zendesk.conversationkit.android.model.MessageContent.Image");
                List<MessageAction> actions4 = ((MessageContent.Image) newItemContent).getActions();
                if (actions4 != null) {
                    Iterator<MessageAction> it4 = actions4.iterator();
                    z = false;
                    while (true) {
                        if (it4.hasNext()) {
                            MessageAction next4 = it4.next();
                            boolean z6 = next4.getMessageActionType() == MessageActionType.POSTBACK;
                            if (z6) {
                                Intrinsics.checkNotNull(next4, "null cannot be cast to non-null type zendesk.conversationkit.android.model.MessageAction.Postback");
                                postback = (MessageAction.Postback) next4;
                                z = z6;
                                break;
                            }
                            z = z6;
                        }
                    }
                    Intrinsics.checkNotNull(oldItemContent, "null cannot be cast to non-null type zendesk.conversationkit.android.model.MessageContent.Image");
                    actions = ((MessageContent.Image) oldItemContent).getActions();
                    if (actions != null) {
                        it = actions.iterator();
                        z2 = false;
                        while (true) {
                            if (it.hasNext()) {
                                next = it.next();
                                if (next.getMessageActionType() == MessageActionType.POSTBACK) {
                                    z3 = true;
                                } else {
                                    z3 = false;
                                }
                                if (z3) {
                                    Intrinsics.checkNotNull(next, "null cannot be cast to non-null type zendesk.conversationkit.android.model.MessageAction.Postback");
                                    postback2 = (MessageAction.Postback) next;
                                    z4 = z3;
                                } else {
                                    z2 = z3;
                                }
                            } else {
                                z4 = z2;
                            }
                        }
                    }
                } else {
                    z = false;
                }
                postback = null;
                Intrinsics.checkNotNull(oldItemContent, "null cannot be cast to non-null type zendesk.conversationkit.android.model.MessageContent.Image");
                actions = ((MessageContent.Image) oldItemContent).getActions();
                if (actions != null) {
                    it = actions.iterator();
                    z2 = false;
                    while (true) {
                        if (it.hasNext()) {
                            next = it.next();
                            if (next.getMessageActionType() == MessageActionType.POSTBACK) {
                                z3 = true;
                            } else {
                                z3 = false;
                            }
                            if (z3) {
                                Intrinsics.checkNotNull(next, "null cannot be cast to non-null type zendesk.conversationkit.android.model.MessageAction.Postback");
                                postback2 = (MessageAction.Postback) next;
                                z4 = z3;
                            } else {
                                z2 = z3;
                            }
                        } else {
                            z4 = z2;
                        }
                    }
                }
            }
            return new PostbackDiffData(z4, z, postback2, postback);
        }

        public boolean areContentsTheSame(MessageLogEntry oldItem, MessageLogEntry newItem) {
            Intrinsics.checkNotNullParameter(oldItem, "oldItem");
            Intrinsics.checkNotNullParameter(newItem, "newItem");
            return Intrinsics.areEqual(oldItem, newItem);
        }

        @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u000e\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0082\b\u0018\u00002\u00020\u0001B)\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\b\u0010\u0005\u001a\u0004\u0018\u00010\u0006\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\u0006¢\u0006\u0002\u0010\bJ\t\u0010\r\u001a\u00020\u0003HÆ\u0003J\t\u0010\u000e\u001a\u00020\u0003HÆ\u0003J\u000b\u0010\u000f\u001a\u0004\u0018\u00010\u0006HÆ\u0003J\u000b\u0010\u0010\u001a\u0004\u0018\u00010\u0006HÆ\u0003J5\u0010\u0011\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00032\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u00062\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\u0006HÆ\u0001J\u0013\u0010\u0012\u001a\u00020\u00032\b\u0010\u0013\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0014\u001a\u00020\u0015HÖ\u0001J\t\u0010\u0016\u001a\u00020\u0017HÖ\u0001R\u0011\u0010\u0004\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0004\u0010\tR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0002\u0010\tR\u0013\u0010\u0007\u001a\u0004\u0018\u00010\u0006¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u0013\u0010\u0005\u001a\u0004\u0018\u00010\u0006¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\u000b¨\u0006\u0018"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/MessageListAdapter$Companion$PostbackDiffData;", "", "isOldPostbackMessageAction", "", "isNewPostbackMessageAction", "oldPostbackMessageAction", "Lzendesk/conversationkit/android/model/MessageAction$Postback;", "newPostbackMessageAction", "(ZZLzendesk/conversationkit/android/model/MessageAction$Postback;Lzendesk/conversationkit/android/model/MessageAction$Postback;)V", "()Z", "getNewPostbackMessageAction", "()Lzendesk/conversationkit/android/model/MessageAction$Postback;", "getOldPostbackMessageAction", "component1", "component2", "component3", "component4", "copy", "equals", "other", "hashCode", "", "toString", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        private static final class PostbackDiffData {
            private final boolean isNewPostbackMessageAction;
            private final boolean isOldPostbackMessageAction;
            private final MessageAction.Postback newPostbackMessageAction;
            private final MessageAction.Postback oldPostbackMessageAction;

            public static PostbackDiffData copy$default(PostbackDiffData postbackDiffData, boolean z, boolean z2, MessageAction.Postback postback, MessageAction.Postback postback2, int i, Object obj) {
                if ((i & 1) != 0) {
                    z = postbackDiffData.isOldPostbackMessageAction;
                }
                if ((i & 2) != 0) {
                    z2 = postbackDiffData.isNewPostbackMessageAction;
                }
                if ((i & 4) != 0) {
                    postback = postbackDiffData.oldPostbackMessageAction;
                }
                if ((i & 8) != 0) {
                    postback2 = postbackDiffData.newPostbackMessageAction;
                }
                return postbackDiffData.copy(z, z2, postback, postback2);
            }

            public final boolean getIsOldPostbackMessageAction() {
                return this.isOldPostbackMessageAction;
            }

            public final boolean getIsNewPostbackMessageAction() {
                return this.isNewPostbackMessageAction;
            }

            public final MessageAction.Postback getOldPostbackMessageAction() {
                return this.oldPostbackMessageAction;
            }

            public final MessageAction.Postback getNewPostbackMessageAction() {
                return this.newPostbackMessageAction;
            }

            public final PostbackDiffData copy(boolean isOldPostbackMessageAction, boolean isNewPostbackMessageAction, MessageAction.Postback oldPostbackMessageAction, MessageAction.Postback newPostbackMessageAction) {
                return new PostbackDiffData(isOldPostbackMessageAction, isNewPostbackMessageAction, oldPostbackMessageAction, newPostbackMessageAction);
            }

            public boolean equals(Object other) {
                if (this == other) {
                    return true;
                }
                if (!(other instanceof PostbackDiffData)) {
                    return false;
                }
                PostbackDiffData postbackDiffData = (PostbackDiffData) other;
                return this.isOldPostbackMessageAction == postbackDiffData.isOldPostbackMessageAction && this.isNewPostbackMessageAction == postbackDiffData.isNewPostbackMessageAction && Intrinsics.areEqual(this.oldPostbackMessageAction, postbackDiffData.oldPostbackMessageAction) && Intrinsics.areEqual(this.newPostbackMessageAction, postbackDiffData.newPostbackMessageAction);
            }

            public int hashCode() {
                int iM30m = ((UByte$$ExternalSyntheticBackport0.m30m(this.isOldPostbackMessageAction) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.isNewPostbackMessageAction)) * 31;
                MessageAction.Postback postback = this.oldPostbackMessageAction;
                int iHashCode = (iM30m + (postback == null ? 0 : postback.hashCode())) * 31;
                MessageAction.Postback postback2 = this.newPostbackMessageAction;
                return iHashCode + (postback2 != null ? postback2.hashCode() : 0);
            }

            public String toString() {
                return "PostbackDiffData(isOldPostbackMessageAction=" + this.isOldPostbackMessageAction + ", isNewPostbackMessageAction=" + this.isNewPostbackMessageAction + ", oldPostbackMessageAction=" + this.oldPostbackMessageAction + ", newPostbackMessageAction=" + this.newPostbackMessageAction + ')';
            }

            public PostbackDiffData(boolean z, boolean z2, MessageAction.Postback postback, MessageAction.Postback postback2) {
                this.isOldPostbackMessageAction = z;
                this.isNewPostbackMessageAction = z2;
                this.oldPostbackMessageAction = postback;
                this.newPostbackMessageAction = postback2;
            }

            public final boolean isOldPostbackMessageAction() {
                return this.isOldPostbackMessageAction;
            }

            public final boolean isNewPostbackMessageAction() {
                return this.isNewPostbackMessageAction;
            }

            public final MessageAction.Postback getOldPostbackMessageAction() {
                return this.oldPostbackMessageAction;
            }

            public final MessageAction.Postback getNewPostbackMessageAction() {
                return this.newPostbackMessageAction;
            }
        }
    }
}
