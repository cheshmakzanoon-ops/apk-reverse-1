package zendesk.messaging.android.internal.conversationscreen.messagelog;

import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.model.Field;
import zendesk.conversationkit.android.model.Message;
import zendesk.conversationkit.android.model.MessageAction;
import zendesk.messaging.android.internal.StubUriHandler;
import zendesk.messaging.android.internal.StubWebViewUriHandler;
import zendesk.messaging.android.internal.UriHandler;
import zendesk.messaging.android.internal.WebViewUriHandler;
import zendesk.messaging.android.internal.model.MessageLogEntry;
import zendesk.p026ui.android.conversation.carousel.CarouselAction;
import zendesk.p026ui.android.conversation.form.DisplayedField;

@Metadata(m17d1 = {"\u0000¨\u0001\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0000\u0018\u00002\u00020\u0001:\u0001EB\u0007\b\u0016¢\u0006\u0002\u0010\u0002B\u000f\b\u0000\u0012\u0006\u0010\u0003\u001a\u00020\u0004¢\u0006\u0002\u0010\u0005J\u0006\u0010D\u001a\u00020\u0004R$\u0010\u0006\u001a\u0012\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0007j\u0002`\nX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR \u0010\r\u001a\u000e\u0012\u0004\u0012\u00020\u000e\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\fR3\u0010\u0010\u001a!\u0012\u0013\u0012\u00110\u0011¢\u0006\f\b\u0012\u0012\b\b\u0013\u0012\u0004\b\b(\u0014\u0012\u0004\u0012\u00020\t0\u0007j\u0002`\u0015X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\fR \u0010\u0017\u001a\u000e\u0012\u0004\u0012\u00020\u0011\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\fR0\u0010\u0019\u001a\u001e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u001c0\u001b\u0012\u0004\u0012\u00020\u001d\u0012\u0004\u0012\u00020\t0\u001aj\u0002`\u001eX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001f\u0010 R*\u0010!\u001a\u0018\u0012\u0004\u0012\u00020\"\u0012\u0004\u0012\u00020\u000e\u0012\u0004\u0012\u00020\t0\u001aj\u0002`#X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b$\u0010 R$\u0010%\u001a\u0012\u0012\u0004\u0012\u00020&\u0012\u0004\u0012\u00020\t0\u0007j\u0002`'X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b(\u0010\fR \u0010)\u001a\u000e\u0012\u0004\u0012\u00020&\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b*\u0010\fR$\u0010+\u001a\u0012\u0012\u0004\u0012\u00020,\u0012\u0004\u0012\u00020\t0\u0007j\u0002`-X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b.\u0010\fR\u001a\u0010/\u001a\b\u0012\u0004\u0012\u00020\t00X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b1\u00102R\u001a\u00103\u001a\b\u0012\u0004\u0012\u00020\t00X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b4\u00102R*\u00105\u001a\u0018\u0012\u0004\u0012\u00020\u000e\u0012\u0004\u0012\u00020\u000e\u0012\u0004\u0012\u00020\t0\u001aj\u0002`6X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b7\u0010 R\u0014\u00108\u001a\u000209X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b:\u0010;R\u0014\u0010<\u001a\u00020=X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b>\u0010?R\u0014\u0010@\u001a\u00020AX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\bB\u0010C¨\u0006F"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/messagelog/MessageLogRendering;", "", "()V", "builder", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/MessageLogRendering$Builder;", "(Lzendesk/messaging/android/internal/conversationscreen/messagelog/MessageLogRendering$Builder;)V", "onCarouselAction", "Lkotlin/Function1;", "Lzendesk/ui/android/conversation/carousel/CarouselAction;", "", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnCarouselAction;", "getOnCarouselAction$zendesk_messaging_messaging_android", "()Lkotlin/jvm/functions/Function1;", "onCopyText", "", "getOnCopyText$zendesk_messaging_messaging_android", "onFailedMessageClicked", "Lzendesk/conversationkit/android/model/Message;", "Lkotlin/ParameterName;", "name", "message", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFailedMessageClickedListener;", "getOnFailedMessageClicked$zendesk_messaging_messaging_android", "onFileAttachmentClicked", "getOnFileAttachmentClicked$zendesk_messaging_messaging_android", "onFormCompleted", "Lkotlin/Function2;", "", "Lzendesk/conversationkit/android/model/Field;", "Lzendesk/messaging/android/internal/model/MessageLogEntry$FormMessageContainer;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFormCompleted;", "getOnFormCompleted$zendesk_messaging_messaging_android", "()Lkotlin/jvm/functions/Function2;", "onFormDisplayedFieldsChanged", "Lzendesk/ui/android/conversation/form/DisplayedField;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFormDisplayedFieldsChanged;", "getOnFormDisplayedFieldsChanged$zendesk_messaging_messaging_android", "onFormFocusChanged", "", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFormFocusChangedListener;", "getOnFormFocusChanged$zendesk_messaging_messaging_android", "onLoadMoreListener", "getOnLoadMoreListener$zendesk_messaging_messaging_android", "onReplyActionSelected", "Lzendesk/conversationkit/android/model/MessageAction$Reply;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnReplyActionSelected;", "getOnReplyActionSelected$zendesk_messaging_messaging_android", "onRetryLoadMoreClickedListener", "Lkotlin/Function0;", "getOnRetryLoadMoreClickedListener$zendesk_messaging_messaging_android", "()Lkotlin/jvm/functions/Function0;", "onSeeLatestClickedListener", "getOnSeeLatestClickedListener$zendesk_messaging_messaging_android", "onSendPostbackMessage", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnSendPostbackMessage;", "getOnSendPostbackMessage$zendesk_messaging_messaging_android", "onUriClicked", "Lzendesk/messaging/android/internal/UriHandler;", "getOnUriClicked$zendesk_messaging_messaging_android", "()Lzendesk/messaging/android/internal/UriHandler;", "onWebViewUriClicked", "Lzendesk/messaging/android/internal/WebViewUriHandler;", "getOnWebViewUriClicked$zendesk_messaging_messaging_android", "()Lzendesk/messaging/android/internal/WebViewUriHandler;", "state", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/MessageLogState;", "getState$zendesk_messaging_messaging_android", "()Lzendesk/messaging/android/internal/conversationscreen/messagelog/MessageLogState;", "toBuilder", "Builder", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessageLogRendering {
    private final Function1<CarouselAction, Unit> onCarouselAction;
    private final Function1<String, Unit> onCopyText;
    private final Function1<Message, Unit> onFailedMessageClicked;
    private final Function1<Message, Unit> onFileAttachmentClicked;
    private final Function2<List<? extends Field>, MessageLogEntry.FormMessageContainer, Unit> onFormCompleted;
    private final Function2<DisplayedField, String, Unit> onFormDisplayedFieldsChanged;
    private final Function1<Boolean, Unit> onFormFocusChanged;
    private final Function1<Boolean, Unit> onLoadMoreListener;
    private final Function1<MessageAction.Reply, Unit> onReplyActionSelected;
    private final Function0<Unit> onRetryLoadMoreClickedListener;
    private final Function0<Unit> onSeeLatestClickedListener;
    private final Function2<String, String, Unit> onSendPostbackMessage;
    private final UriHandler onUriClicked;
    private final WebViewUriHandler onWebViewUriClicked;
    private final MessageLogState state;

    public MessageLogRendering(Builder builder) {
        Intrinsics.checkNotNullParameter(builder, "builder");
        this.onReplyActionSelected = builder.getOnReplyActionSelected$zendesk_messaging_messaging_android();
        this.onFailedMessageClicked = builder.getOnFailedMessageClicked$zendesk_messaging_messaging_android();
        this.onUriClicked = builder.getOnUriClicked();
        this.onWebViewUriClicked = builder.getOnWebViewUriClicked();
        this.onCarouselAction = builder.getOnCarouselAction$zendesk_messaging_messaging_android();
        this.onFormCompleted = builder.getOnFormCompleted$zendesk_messaging_messaging_android();
        this.onFormFocusChanged = builder.getOnFormFocusChanged$zendesk_messaging_messaging_android();
        this.onFormDisplayedFieldsChanged = builder.m262xd959c585();
        this.onLoadMoreListener = builder.getOnLoadMoreListener$zendesk_messaging_messaging_android();
        this.onRetryLoadMoreClickedListener = builder.m263xf184e65f();
        this.onSeeLatestClickedListener = builder.m264xa05399e8();
        this.onSendPostbackMessage = builder.getOnSendPostbackMessage$zendesk_messaging_messaging_android();
        this.onCopyText = builder.getOnCopyText$zendesk_messaging_messaging_android();
        this.onFileAttachmentClicked = builder.getOnFileAttachmentClicked$zendesk_messaging_messaging_android();
        this.state = builder.getState();
    }

    public final Function1<MessageAction.Reply, Unit> getOnReplyActionSelected$zendesk_messaging_messaging_android() {
        return this.onReplyActionSelected;
    }

    public final Function1<Message, Unit> getOnFailedMessageClicked$zendesk_messaging_messaging_android() {
        return this.onFailedMessageClicked;
    }

    public final UriHandler getOnUriClicked() {
        return this.onUriClicked;
    }

    public final WebViewUriHandler getOnWebViewUriClicked() {
        return this.onWebViewUriClicked;
    }

    public final Function1<CarouselAction, Unit> getOnCarouselAction$zendesk_messaging_messaging_android() {
        return this.onCarouselAction;
    }

    public final Function2<List<? extends Field>, MessageLogEntry.FormMessageContainer, Unit> getOnFormCompleted$zendesk_messaging_messaging_android() {
        return this.onFormCompleted;
    }

    public final Function1<Boolean, Unit> getOnFormFocusChanged$zendesk_messaging_messaging_android() {
        return this.onFormFocusChanged;
    }

    public final Function2<DisplayedField, String, Unit> m259xd959c585() {
        return this.onFormDisplayedFieldsChanged;
    }

    public final Function1<Boolean, Unit> getOnLoadMoreListener$zendesk_messaging_messaging_android() {
        return this.onLoadMoreListener;
    }

    public final Function0<Unit> m260xf184e65f() {
        return this.onRetryLoadMoreClickedListener;
    }

    public final Function0<Unit> m261xa05399e8() {
        return this.onSeeLatestClickedListener;
    }

    public final Function2<String, String, Unit> getOnSendPostbackMessage$zendesk_messaging_messaging_android() {
        return this.onSendPostbackMessage;
    }

    public final Function1<String, Unit> getOnCopyText$zendesk_messaging_messaging_android() {
        return this.onCopyText;
    }

    public final Function1<Message, Unit> getOnFileAttachmentClicked$zendesk_messaging_messaging_android() {
        return this.onFileAttachmentClicked;
    }

    public final MessageLogState getState() {
        return this.state;
    }

    public MessageLogRendering() {
        this(new Builder());
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000²\u0001\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u000f\n\u0002\u0018\u0002\n\u0002\b\u000b\u0018\u00002\u00020\u0001B\u0011\b\u0010\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010e\u001a\u00020\u0003J\u001e\u0010\u0006\u001a\u00020\u00002\u0016\u0010\u0006\u001a\u0012\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0007j\u0002`\nJ\u001e\u0010\u000f\u001a\u00020\u00002\u0016\u0010f\u001a\u0012\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\t0\u0007j\u0002`\u0011J-\u0010\u0014\u001a\u00020\u00002%\u0010\u0014\u001a!\u0012\u0013\u0012\u00110\u0015¢\u0006\f\b\u0016\u0012\b\b\u0017\u0012\u0004\b\b(\u0018\u0012\u0004\u0012\u00020\t0\u0007j\u0002`\u0019J\u001e\u0010\u001c\u001a\u00020\u00002\u0016\u0010\u001c\u001a\u0012\u0012\u0004\u0012\u00020\u0015\u0012\u0004\u0012\u00020\t0\u0007j\u0002`\u001dJ*\u0010 \u001a\u00020\u00002\"\u0010 \u001a\u001e\u0012\n\u0012\b\u0012\u0004\u0012\u00020#0\"\u0012\u0004\u0012\u00020$\u0012\u0004\u0012\u00020\t0!j\u0002`%J$\u0010*\u001a\u00020\u00002\u001c\u0010*\u001a\u0018\u0012\u0004\u0012\u00020+\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\t0!j\u0002`,J\u001e\u0010/\u001a\u00020\u00002\u0016\u0010g\u001a\u0012\u0012\u0004\u0012\u000200\u0012\u0004\u0012\u00020\t0\u0007j\u0002`1J\u001a\u00104\u001a\u00020\u00002\u0012\u00104\u001a\u000e\u0012\u0004\u0012\u000200\u0012\u0004\u0012\u00020\t0\u0007J\u001e\u00107\u001a\u00020\u00002\u0016\u00107\u001a\u0012\u0012\u0004\u0012\u000208\u0012\u0004\u0012\u00020\t0\u0007j\u0002`9J\u0014\u0010<\u001a\u00020\u00002\f\u0010<\u001a\b\u0012\u0004\u0012\u00020\t0=J\u0014\u0010B\u001a\u00020\u00002\f\u0010B\u001a\b\u0012\u0004\u0012\u00020\t0=J$\u0010E\u001a\u00020\u00002\u001c\u0010E\u001a\u0018\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\t0!j\u0002`FJ\u000e\u0010I\u001a\u00020\u00002\u0006\u0010h\u001a\u00020JJ\u000e\u0010O\u001a\u00020\u00002\u0006\u0010i\u001a\u00020PJ\u001a\u0010_\u001a\u00020\u00002\u0012\u0010j\u001a\u000e\u0012\u0004\u0012\u00020`\u0012\u0004\u0012\u00020`0\u0007R*\u0010\u0006\u001a\u0012\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0007j\u0002`\nX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000b\u0010\f\"\u0004\b\r\u0010\u000eR*\u0010\u000f\u001a\u0012\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\t0\u0007j\u0002`\u0011X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0012\u0010\f\"\u0004\b\u0013\u0010\u000eR9\u0010\u0014\u001a!\u0012\u0013\u0012\u00110\u0015¢\u0006\f\b\u0016\u0012\b\b\u0017\u0012\u0004\b\b(\u0018\u0012\u0004\u0012\u00020\t0\u0007j\u0002`\u0019X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001a\u0010\f\"\u0004\b\u001b\u0010\u000eR*\u0010\u001c\u001a\u0012\u0012\u0004\u0012\u00020\u0015\u0012\u0004\u0012\u00020\t0\u0007j\u0002`\u001dX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001e\u0010\f\"\u0004\b\u001f\u0010\u000eR6\u0010 \u001a\u001e\u0012\n\u0012\b\u0012\u0004\u0012\u00020#0\"\u0012\u0004\u0012\u00020$\u0012\u0004\u0012\u00020\t0!j\u0002`%X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b&\u0010'\"\u0004\b(\u0010)R0\u0010*\u001a\u0018\u0012\u0004\u0012\u00020+\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\t0!j\u0002`,X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b-\u0010'\"\u0004\b.\u0010)R*\u0010/\u001a\u0012\u0012\u0004\u0012\u000200\u0012\u0004\u0012\u00020\t0\u0007j\u0002`1X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b2\u0010\f\"\u0004\b3\u0010\u000eR&\u00104\u001a\u000e\u0012\u0004\u0012\u000200\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b5\u0010\f\"\u0004\b6\u0010\u000eR*\u00107\u001a\u0012\u0012\u0004\u0012\u000208\u0012\u0004\u0012\u00020\t0\u0007j\u0002`9X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b:\u0010\f\"\u0004\b;\u0010\u000eR \u0010<\u001a\b\u0012\u0004\u0012\u00020\t0=X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b>\u0010?\"\u0004\b@\u0010AR \u0010B\u001a\b\u0012\u0004\u0012\u00020\t0=X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bC\u0010?\"\u0004\bD\u0010AR0\u0010E\u001a\u0018\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\t0!j\u0002`FX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bG\u0010'\"\u0004\bH\u0010)R\u001a\u0010I\u001a\u00020JX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bK\u0010L\"\u0004\bM\u0010NR\u001a\u0010O\u001a\u00020PX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bQ\u0010R\"\u0004\bS\u0010TR\u001a\u0010U\u001a\u00020\u0010X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bV\u0010W\"\u0004\bX\u0010YR\u001a\u0010Z\u001a\u000200X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b[\u0010\\\"\u0004\b]\u0010^R\u001a\u0010_\u001a\u00020`X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\ba\u0010b\"\u0004\bc\u0010d¨\u0006k"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/messagelog/MessageLogRendering$Builder;", "", "rendering", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/MessageLogRendering;", "(Lzendesk/messaging/android/internal/conversationscreen/messagelog/MessageLogRendering;)V", "()V", "onCarouselAction", "Lkotlin/Function1;", "Lzendesk/ui/android/conversation/carousel/CarouselAction;", "", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnCarouselAction;", "getOnCarouselAction$zendesk_messaging_messaging_android", "()Lkotlin/jvm/functions/Function1;", "setOnCarouselAction$zendesk_messaging_messaging_android", "(Lkotlin/jvm/functions/Function1;)V", "onCopyText", "", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnCopyTextAction;", "getOnCopyText$zendesk_messaging_messaging_android", "setOnCopyText$zendesk_messaging_messaging_android", "onFailedMessageClicked", "Lzendesk/conversationkit/android/model/Message;", "Lkotlin/ParameterName;", "name", "message", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFailedMessageClickedListener;", "getOnFailedMessageClicked$zendesk_messaging_messaging_android", "setOnFailedMessageClicked$zendesk_messaging_messaging_android", "onFileAttachmentClicked", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFileAttachmentClicked;", "getOnFileAttachmentClicked$zendesk_messaging_messaging_android", "setOnFileAttachmentClicked$zendesk_messaging_messaging_android", "onFormCompleted", "Lkotlin/Function2;", "", "Lzendesk/conversationkit/android/model/Field;", "Lzendesk/messaging/android/internal/model/MessageLogEntry$FormMessageContainer;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFormCompleted;", "getOnFormCompleted$zendesk_messaging_messaging_android", "()Lkotlin/jvm/functions/Function2;", "setOnFormCompleted$zendesk_messaging_messaging_android", "(Lkotlin/jvm/functions/Function2;)V", "onFormDisplayedFieldsChanged", "Lzendesk/ui/android/conversation/form/DisplayedField;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFormDisplayedFieldsChanged;", "getOnFormDisplayedFieldsChanged$zendesk_messaging_messaging_android", "setOnFormDisplayedFieldsChanged$zendesk_messaging_messaging_android", "onFormFocusChanged", "", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFormFocusChangedListener;", "getOnFormFocusChanged$zendesk_messaging_messaging_android", "setOnFormFocusChanged$zendesk_messaging_messaging_android", "onLoadMoreListener", "getOnLoadMoreListener$zendesk_messaging_messaging_android", "setOnLoadMoreListener$zendesk_messaging_messaging_android", "onReplyActionSelected", "Lzendesk/conversationkit/android/model/MessageAction$Reply;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnReplyActionSelected;", "getOnReplyActionSelected$zendesk_messaging_messaging_android", "setOnReplyActionSelected$zendesk_messaging_messaging_android", "onRetryLoadMoreClickedListener", "Lkotlin/Function0;", "getOnRetryLoadMoreClickedListener$zendesk_messaging_messaging_android", "()Lkotlin/jvm/functions/Function0;", "setOnRetryLoadMoreClickedListener$zendesk_messaging_messaging_android", "(Lkotlin/jvm/functions/Function0;)V", "onSeeLatestClickedListener", "getOnSeeLatestClickedListener$zendesk_messaging_messaging_android", "setOnSeeLatestClickedListener$zendesk_messaging_messaging_android", "onSendPostbackMessage", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnSendPostbackMessage;", "getOnSendPostbackMessage$zendesk_messaging_messaging_android", "setOnSendPostbackMessage$zendesk_messaging_messaging_android", "onUriClicked", "Lzendesk/messaging/android/internal/UriHandler;", "getOnUriClicked$zendesk_messaging_messaging_android", "()Lzendesk/messaging/android/internal/UriHandler;", "setOnUriClicked$zendesk_messaging_messaging_android", "(Lzendesk/messaging/android/internal/UriHandler;)V", "onWebViewUriClicked", "Lzendesk/messaging/android/internal/WebViewUriHandler;", "getOnWebViewUriClicked$zendesk_messaging_messaging_android", "()Lzendesk/messaging/android/internal/WebViewUriHandler;", "setOnWebViewUriClicked$zendesk_messaging_messaging_android", "(Lzendesk/messaging/android/internal/WebViewUriHandler;)V", "postbackErrorText", "getPostbackErrorText$zendesk_messaging_messaging_android", "()Ljava/lang/String;", "setPostbackErrorText$zendesk_messaging_messaging_android", "(Ljava/lang/String;)V", "showPostbackErrorBanner", "getShowPostbackErrorBanner$zendesk_messaging_messaging_android", "()Z", "setShowPostbackErrorBanner$zendesk_messaging_messaging_android", "(Z)V", "state", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/MessageLogState;", "getState$zendesk_messaging_messaging_android", "()Lzendesk/messaging/android/internal/conversationscreen/messagelog/MessageLogState;", "setState$zendesk_messaging_messaging_android", "(Lzendesk/messaging/android/internal/conversationscreen/messagelog/MessageLogState;)V", "build", "onCopyTextAction", "onFormFocusChangedListener", "uriHandler", "webViewUriHandler", "stateUpdate", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        private Function1<? super CarouselAction, Unit> onCarouselAction;
        private Function1<? super String, Unit> onCopyText;
        private Function1<? super Message, Unit> onFailedMessageClicked;
        private Function1<? super Message, Unit> onFileAttachmentClicked;
        private Function2<? super List<? extends Field>, ? super MessageLogEntry.FormMessageContainer, Unit> onFormCompleted;
        private Function2<? super DisplayedField, ? super String, Unit> onFormDisplayedFieldsChanged;
        private Function1<? super Boolean, Unit> onFormFocusChanged;
        private Function1<? super Boolean, Unit> onLoadMoreListener;
        private Function1<? super MessageAction.Reply, Unit> onReplyActionSelected;
        private Function0<Unit> onRetryLoadMoreClickedListener;
        private Function0<Unit> onSeeLatestClickedListener;
        private Function2<? super String, ? super String, Unit> onSendPostbackMessage;
        private UriHandler onUriClicked;
        private WebViewUriHandler onWebViewUriClicked;
        private String postbackErrorText;
        private boolean showPostbackErrorBanner;
        private MessageLogState state;

        public Builder() {
            this.onReplyActionSelected = MessageLogListenersKt.getNOOP_ON_QUICK_REPLY_OPTION_SELECTED_LISTENER();
            this.onFailedMessageClicked = MessageLogListenersKt.getNOOP_ON_MESSAGE_CONTAINER_CLICKED_LISTENER();
            this.onUriClicked = StubUriHandler.INSTANCE;
            this.onWebViewUriClicked = StubWebViewUriHandler.INSTANCE;
            this.onFormCompleted = MessageLogListenersKt.getNOOP_ON_FORM_COMPLETED();
            this.onCarouselAction = MessageLogListenersKt.getNOOP_ON_CAROUSEL_ACTION();
            this.onFormFocusChanged = MessageLogListenersKt.getNOOP_ON_FORM_FOCUS_CHANGED_LISTENER();
            this.state = new MessageLogState(null, false, null, false, false, false, null, null, null, 511, null);
            this.onFormDisplayedFieldsChanged = MessageLogListenersKt.getNOOP_ON_FORM_DISPLAYED_FIELDS_CHANGED();
            this.onRetryLoadMoreClickedListener = new Function0<Unit>() {
                public final void invoke2() {
                }

                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }
            };
            this.onSeeLatestClickedListener = new Function0<Unit>() {
                public final void invoke2() {
                }

                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }
            };
            this.onLoadMoreListener = new Function1<Boolean, Unit>() {
                public final void invoke(boolean z) {
                }

                @Override
                public Unit invoke(Boolean bool) {
                    invoke(bool.booleanValue());
                    return Unit.INSTANCE;
                }
            };
            this.postbackErrorText = "";
            this.onSendPostbackMessage = MessageLogListenersKt.getNOOP_ON_SEND_POSTBACK_MESSAGE();
            this.onCopyText = MessageLogListenersKt.getNOOP_ON_COPY_TEXT_ACTION();
            this.onFileAttachmentClicked = MessageLogListenersKt.getNOOP_ON_FILE_ATTACHMENT_CLICKED_ACTION();
        }

        public final Function1<MessageAction.Reply, Unit> getOnReplyActionSelected$zendesk_messaging_messaging_android() {
            return this.onReplyActionSelected;
        }

        public final void setOnReplyActionSelected$zendesk_messaging_messaging_android(Function1<? super MessageAction.Reply, Unit> function1) {
            Intrinsics.checkNotNullParameter(function1, "<set-?>");
            this.onReplyActionSelected = function1;
        }

        public final Function1<Message, Unit> getOnFailedMessageClicked$zendesk_messaging_messaging_android() {
            return this.onFailedMessageClicked;
        }

        public final void setOnFailedMessageClicked$zendesk_messaging_messaging_android(Function1<? super Message, Unit> function1) {
            Intrinsics.checkNotNullParameter(function1, "<set-?>");
            this.onFailedMessageClicked = function1;
        }

        public final UriHandler getOnUriClicked() {
            return this.onUriClicked;
        }

        public final void setOnUriClicked$zendesk_messaging_messaging_android(UriHandler uriHandler) {
            Intrinsics.checkNotNullParameter(uriHandler, "<set-?>");
            this.onUriClicked = uriHandler;
        }

        public final WebViewUriHandler getOnWebViewUriClicked() {
            return this.onWebViewUriClicked;
        }

        public final void setOnWebViewUriClicked$zendesk_messaging_messaging_android(WebViewUriHandler webViewUriHandler) {
            Intrinsics.checkNotNullParameter(webViewUriHandler, "<set-?>");
            this.onWebViewUriClicked = webViewUriHandler;
        }

        public final Function2<List<? extends Field>, MessageLogEntry.FormMessageContainer, Unit> getOnFormCompleted$zendesk_messaging_messaging_android() {
            return this.onFormCompleted;
        }

        public final void setOnFormCompleted$zendesk_messaging_messaging_android(Function2<? super List<? extends Field>, ? super MessageLogEntry.FormMessageContainer, Unit> function2) {
            Intrinsics.checkNotNullParameter(function2, "<set-?>");
            this.onFormCompleted = function2;
        }

        public final Function1<CarouselAction, Unit> getOnCarouselAction$zendesk_messaging_messaging_android() {
            return this.onCarouselAction;
        }

        public final void setOnCarouselAction$zendesk_messaging_messaging_android(Function1<? super CarouselAction, Unit> function1) {
            Intrinsics.checkNotNullParameter(function1, "<set-?>");
            this.onCarouselAction = function1;
        }

        public final Function1<Boolean, Unit> getOnFormFocusChanged$zendesk_messaging_messaging_android() {
            return this.onFormFocusChanged;
        }

        public final void setOnFormFocusChanged$zendesk_messaging_messaging_android(Function1<? super Boolean, Unit> function1) {
            Intrinsics.checkNotNullParameter(function1, "<set-?>");
            this.onFormFocusChanged = function1;
        }

        public final MessageLogState getState() {
            return this.state;
        }

        public final void setState$zendesk_messaging_messaging_android(MessageLogState messageLogState) {
            Intrinsics.checkNotNullParameter(messageLogState, "<set-?>");
            this.state = messageLogState;
        }

        public final Function2<DisplayedField, String, Unit> m262xd959c585() {
            return this.onFormDisplayedFieldsChanged;
        }

        public final void m265x266b9291(Function2<? super DisplayedField, ? super String, Unit> function2) {
            Intrinsics.checkNotNullParameter(function2, "<set-?>");
            this.onFormDisplayedFieldsChanged = function2;
        }

        public final Function0<Unit> m263xf184e65f() {
            return this.onRetryLoadMoreClickedListener;
        }

        public final void m266x4157a06b(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onRetryLoadMoreClickedListener = function0;
        }

        public final Function0<Unit> m264xa05399e8() {
            return this.onSeeLatestClickedListener;
        }

        public final void m267x454d39f4(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onSeeLatestClickedListener = function0;
        }

        public final Function1<Boolean, Unit> getOnLoadMoreListener$zendesk_messaging_messaging_android() {
            return this.onLoadMoreListener;
        }

        public final void setOnLoadMoreListener$zendesk_messaging_messaging_android(Function1<? super Boolean, Unit> function1) {
            Intrinsics.checkNotNullParameter(function1, "<set-?>");
            this.onLoadMoreListener = function1;
        }

        public final boolean getShowPostbackErrorBanner() {
            return this.showPostbackErrorBanner;
        }

        public final void setShowPostbackErrorBanner$zendesk_messaging_messaging_android(boolean z) {
            this.showPostbackErrorBanner = z;
        }

        public final String getPostbackErrorText() {
            return this.postbackErrorText;
        }

        public final void setPostbackErrorText$zendesk_messaging_messaging_android(String str) {
            Intrinsics.checkNotNullParameter(str, "<set-?>");
            this.postbackErrorText = str;
        }

        public final Function2<String, String, Unit> getOnSendPostbackMessage$zendesk_messaging_messaging_android() {
            return this.onSendPostbackMessage;
        }

        public final void setOnSendPostbackMessage$zendesk_messaging_messaging_android(Function2<? super String, ? super String, Unit> function2) {
            Intrinsics.checkNotNullParameter(function2, "<set-?>");
            this.onSendPostbackMessage = function2;
        }

        public final Function1<String, Unit> getOnCopyText$zendesk_messaging_messaging_android() {
            return this.onCopyText;
        }

        public final void setOnCopyText$zendesk_messaging_messaging_android(Function1<? super String, Unit> function1) {
            Intrinsics.checkNotNullParameter(function1, "<set-?>");
            this.onCopyText = function1;
        }

        public final Function1<Message, Unit> getOnFileAttachmentClicked$zendesk_messaging_messaging_android() {
            return this.onFileAttachmentClicked;
        }

        public final void setOnFileAttachmentClicked$zendesk_messaging_messaging_android(Function1<? super Message, Unit> function1) {
            Intrinsics.checkNotNullParameter(function1, "<set-?>");
            this.onFileAttachmentClicked = function1;
        }

        public Builder(MessageLogRendering rendering) {
            this();
            Intrinsics.checkNotNullParameter(rendering, "rendering");
            this.onReplyActionSelected = rendering.getOnReplyActionSelected$zendesk_messaging_messaging_android();
            this.onFailedMessageClicked = rendering.getOnFailedMessageClicked$zendesk_messaging_messaging_android();
            this.onUriClicked = rendering.getOnUriClicked();
            this.onFormFocusChanged = rendering.getOnFormFocusChanged$zendesk_messaging_messaging_android();
            this.onFormDisplayedFieldsChanged = rendering.m259xd959c585();
            this.onLoadMoreListener = rendering.getOnLoadMoreListener$zendesk_messaging_messaging_android();
            this.onRetryLoadMoreClickedListener = rendering.m260xf184e65f();
            this.onSeeLatestClickedListener = rendering.m261xa05399e8();
            this.onCopyText = rendering.getOnCopyText$zendesk_messaging_messaging_android();
            this.onFileAttachmentClicked = rendering.getOnFileAttachmentClicked$zendesk_messaging_messaging_android();
            this.state = rendering.getState();
        }

        public Builder(MessageLogRendering messageLogRendering, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this((i & 1) != 0 ? new MessageLogRendering() : messageLogRendering);
        }

        public final Builder onReplyActionSelected(Function1<? super MessageAction.Reply, Unit> onReplyActionSelected) {
            Intrinsics.checkNotNullParameter(onReplyActionSelected, "onReplyActionSelected");
            this.onReplyActionSelected = onReplyActionSelected;
            return this;
        }

        public final Builder onFailedMessageClicked(Function1<? super Message, Unit> onFailedMessageClicked) {
            Intrinsics.checkNotNullParameter(onFailedMessageClicked, "onFailedMessageClicked");
            this.onFailedMessageClicked = onFailedMessageClicked;
            return this;
        }

        public final Builder onUriClicked(UriHandler uriHandler) {
            Intrinsics.checkNotNullParameter(uriHandler, "uriHandler");
            this.onUriClicked = uriHandler;
            return this;
        }

        public final Builder onWebViewUriClicked(WebViewUriHandler webViewUriHandler) {
            Intrinsics.checkNotNullParameter(webViewUriHandler, "webViewUriHandler");
            this.onWebViewUriClicked = webViewUriHandler;
            return this;
        }

        public final Builder onCarouselAction(Function1<? super CarouselAction, Unit> onCarouselAction) {
            Intrinsics.checkNotNullParameter(onCarouselAction, "onCarouselAction");
            this.onCarouselAction = onCarouselAction;
            return this;
        }

        public final Builder onSendPostbackMessage(Function2<? super String, ? super String, Unit> onSendPostbackMessage) {
            Intrinsics.checkNotNullParameter(onSendPostbackMessage, "onSendPostbackMessage");
            this.onSendPostbackMessage = onSendPostbackMessage;
            return this;
        }

        public final Builder onFormCompleted(Function2<? super List<? extends Field>, ? super MessageLogEntry.FormMessageContainer, Unit> onFormCompleted) {
            Intrinsics.checkNotNullParameter(onFormCompleted, "onFormCompleted");
            this.onFormCompleted = onFormCompleted;
            return this;
        }

        public final Builder onFormFocusChanged(Function1<? super Boolean, Unit> onFormFocusChangedListener) {
            Intrinsics.checkNotNullParameter(onFormFocusChangedListener, "onFormFocusChangedListener");
            this.onFormFocusChanged = onFormFocusChangedListener;
            return this;
        }

        public final Builder onFormDisplayedFieldsChanged(Function2<? super DisplayedField, ? super String, Unit> onFormDisplayedFieldsChanged) {
            Intrinsics.checkNotNullParameter(onFormDisplayedFieldsChanged, "onFormDisplayedFieldsChanged");
            this.onFormDisplayedFieldsChanged = onFormDisplayedFieldsChanged;
            return this;
        }

        public final Builder onLoadMoreListener(Function1<? super Boolean, Unit> onLoadMoreListener) {
            Intrinsics.checkNotNullParameter(onLoadMoreListener, "onLoadMoreListener");
            this.onLoadMoreListener = onLoadMoreListener;
            return this;
        }

        public final Builder onRetryLoadMoreClickedListener(Function0<Unit> onRetryLoadMoreClickedListener) {
            Intrinsics.checkNotNullParameter(onRetryLoadMoreClickedListener, "onRetryLoadMoreClickedListener");
            this.onRetryLoadMoreClickedListener = onRetryLoadMoreClickedListener;
            return this;
        }

        public final Builder onSeeLatestClickedListener(Function0<Unit> onSeeLatestClickedListener) {
            Intrinsics.checkNotNullParameter(onSeeLatestClickedListener, "onSeeLatestClickedListener");
            this.onSeeLatestClickedListener = onSeeLatestClickedListener;
            return this;
        }

        public final Builder onCopyText(Function1<? super String, Unit> onCopyTextAction) {
            Intrinsics.checkNotNullParameter(onCopyTextAction, "onCopyTextAction");
            this.onCopyText = onCopyTextAction;
            return this;
        }

        public final Builder onFileAttachmentClicked(Function1<? super Message, Unit> onFileAttachmentClicked) {
            Intrinsics.checkNotNullParameter(onFileAttachmentClicked, "onFileAttachmentClicked");
            this.onFileAttachmentClicked = onFileAttachmentClicked;
            return this;
        }

        public final Builder state(Function1<? super MessageLogState, MessageLogState> stateUpdate) {
            Intrinsics.checkNotNullParameter(stateUpdate, "stateUpdate");
            this.state = stateUpdate.invoke(this.state);
            return this;
        }

        public final MessageLogRendering build() {
            return new MessageLogRendering(this);
        }
    }
}
