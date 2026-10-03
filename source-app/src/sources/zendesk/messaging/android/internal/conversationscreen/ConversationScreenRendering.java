package zendesk.messaging.android.internal.conversationscreen;

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
import zendesk.messaging.android.internal.conversationscreen.messagelog.MessageLogListenersKt;
import zendesk.messaging.android.internal.model.MessageLogEntry;
import zendesk.p026ui.android.conversation.carousel.CarouselAction;
import zendesk.p026ui.android.conversation.form.DisplayedField;

@Metadata(m17d1 = {"\u0000Ì\u0001\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\b\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0006\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0000\u0018\u00002\u00020\u0001:\u0001cB\u0007\b\u0016¢\u0006\u0002\u0010\u0002B\r\u0012\u0006\u0010\u0003\u001a\u00020\u0004¢\u0006\u0002\u0010\u0005J\u0006\u0010b\u001a\u00020\u0004R \u0010\u0006\u001a\u000e\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u001e\u0010\f\u001a\f\u0012\u0004\u0012\u00020\t0\rj\u0002`\u000eX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R$\u0010\u0011\u001a\u0012\u0012\u0004\u0012\u00020\u0012\u0012\u0004\u0012\u00020\t0\u0007j\u0002`\u0013X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u000bR \u0010\u0015\u001a\u000e\u0012\u0004\u0012\u00020\u0016\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u000bR\u001e\u0010\u0018\u001a\f\u0012\u0004\u0012\u00020\t0\rj\u0002`\u000eX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u0010R\u001e\u0010\u001a\u001a\f\u0012\u0004\u0012\u00020\t0\rj\u0002`\u000eX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u0010R3\u0010\u001c\u001a!\u0012\u0013\u0012\u00110\u001d¢\u0006\f\b\u001e\u0012\b\b\u001f\u0012\u0004\b\b( \u0012\u0004\u0012\u00020\t0\u0007j\u0002`!X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\"\u0010\u000bR \u0010#\u001a\u000e\u0012\u0004\u0012\u00020\u001d\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b$\u0010\u000bR0\u0010%\u001a\u001e\u0012\n\u0012\b\u0012\u0004\u0012\u00020(0'\u0012\u0004\u0012\u00020)\u0012\u0004\u0012\u00020\t0&j\u0002`*X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b+\u0010,R*\u0010-\u001a\u0018\u0012\u0004\u0012\u00020.\u0012\u0004\u0012\u00020\u0016\u0012\u0004\u0012\u00020\t0&j\u0002`/X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b0\u0010,R$\u00101\u001a\u0012\u0012\u0004\u0012\u000202\u0012\u0004\u0012\u00020\t0\u0007j\u0002`3X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b4\u0010\u000bR \u00105\u001a\u000e\u0012\u0004\u0012\u000206\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b7\u0010\u000bR \u00108\u001a\u000e\u0012\u0004\u0012\u00020\u0016\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b9\u0010\u000bR\u001e\u0010:\u001a\f\u0012\u0004\u0012\u00020\t0\rj\u0002`\u000eX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b;\u0010\u0010R$\u0010<\u001a\u0012\u0012\u0004\u0012\u00020=\u0012\u0004\u0012\u00020\t0\u0007j\u0002`>X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b?\u0010\u000bR\u001e\u0010@\u001a\f\u0012\u0004\u0012\u00020\t0\rj\u0002`AX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\bB\u0010\u0010R$\u0010C\u001a\f\u0012\u0004\u0012\u00020\t0\rj\u0002`\u000eX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bD\u0010\u0010\"\u0004\bE\u0010FR \u0010G\u001a\u000e\u0012\u0004\u0012\u000206\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\bH\u0010\u000bR\u001e\u0010I\u001a\f\u0012\u0004\u0012\u00020\t0\rj\u0002`\u000eX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\bJ\u0010\u0010R$\u0010K\u001a\u0012\u0012\u0004\u0012\u00020\u0016\u0012\u0004\u0012\u00020\t0\u0007j\u0002`LX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\bM\u0010\u000bR*\u0010N\u001a\u0018\u0012\u0004\u0012\u00020\u0016\u0012\u0004\u0012\u00020\u0016\u0012\u0004\u0012\u00020\t0&j\u0002`OX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\bP\u0010,R\u001e\u0010Q\u001a\f\u0012\u0004\u0012\u00020\t0\rj\u0002`\u000eX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\bR\u0010\u0010R\u0014\u0010S\u001a\u00020TX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\bU\u0010VR\u0014\u0010W\u001a\u00020XX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\bY\u0010ZR\u0014\u0010[\u001a\u000202X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\\\u0010]R\u0014\u0010^\u001a\u00020_X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b`\u0010a¨\u0006d"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenRendering;", "", "()V", "builder", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenRendering$Builder;", "(Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenRendering$Builder;)V", "onAttachButtonClicked", "Lkotlin/Function1;", "", "", "getOnAttachButtonClicked$zendesk_messaging_messaging_android", "()Lkotlin/jvm/functions/Function1;", "onBackButtonClicked", "Lkotlin/Function0;", "Lzendesk/messaging/android/internal/conversationscreen/OnClickLambda;", "getOnBackButtonClicked$zendesk_messaging_messaging_android", "()Lkotlin/jvm/functions/Function0;", "onCarouselAction", "Lzendesk/ui/android/conversation/carousel/CarouselAction;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnCarouselAction;", "getOnCarouselAction$zendesk_messaging_messaging_android", "onCopyText", "", "getOnCopyText$zendesk_messaging_messaging_android", "onDeniedPermissionActionClicked", "getOnDeniedPermissionActionClicked$zendesk_messaging_messaging_android", "onDeniedPermissionDismissed", "getOnDeniedPermissionDismissed$zendesk_messaging_messaging_android", "onFailedMessageClicked", "Lzendesk/conversationkit/android/model/Message;", "Lkotlin/ParameterName;", "name", "message", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFailedMessageClickedListener;", "getOnFailedMessageClicked$zendesk_messaging_messaging_android", "onFileAttachmentClicked", "getOnFileAttachmentClicked$zendesk_messaging_messaging_android", "onFormCompleted", "Lkotlin/Function2;", "", "Lzendesk/conversationkit/android/model/Field;", "Lzendesk/messaging/android/internal/model/MessageLogEntry$FormMessageContainer;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFormCompleted;", "getOnFormCompleted$zendesk_messaging_messaging_android", "()Lkotlin/jvm/functions/Function2;", "onFormDisplayedFieldsChanged", "Lzendesk/ui/android/conversation/form/DisplayedField;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFormDisplayedFieldsChanged;", "getOnFormDisplayedFieldsChanged$zendesk_messaging_messaging_android", "onFormFocusChanged", "", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFormFocusChangedListener;", "getOnFormFocusChanged$zendesk_messaging_messaging_android", "onLoadMoreMessages", "", "getOnLoadMoreMessages$zendesk_messaging_messaging_android", "onMessageComposerTextChanged", "getOnMessageComposerTextChanged$zendesk_messaging_messaging_android", "onPostbackFailedDismissedListener", "getOnPostbackFailedDismissedListener$zendesk_messaging_messaging_android", "onReplyActionSelected", "Lzendesk/conversationkit/android/model/MessageAction$Reply;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnReplyActionSelected;", "getOnReplyActionSelected$zendesk_messaging_messaging_android", "onRetryConnectionClicked", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnRetryConnectionClickedListener;", "getOnRetryConnectionClicked$zendesk_messaging_messaging_android", "onRetryLoadConversationClicked", "getOnRetryLoadConversationClicked$zendesk_messaging_messaging_android", "setOnRetryLoadConversationClicked$zendesk_messaging_messaging_android", "(Lkotlin/jvm/functions/Function0;)V", "onRetryLoadMoreClickedListener", "getOnRetryLoadMoreClickedListener$zendesk_messaging_messaging_android", "onSeeLatestClickedListener", "getOnSeeLatestClickedListener$zendesk_messaging_messaging_android", "onSendButtonClicked", "Lzendesk/messaging/android/internal/conversationscreen/OnSendButtonClickLambda;", "getOnSendButtonClicked$zendesk_messaging_messaging_android", "onSendPostbackMessage", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnSendPostbackMessage;", "getOnSendPostbackMessage$zendesk_messaging_messaging_android", "onTyping", "getOnTyping$zendesk_messaging_messaging_android", "onUriClicked", "Lzendesk/messaging/android/internal/UriHandler;", "getOnUriClicked$zendesk_messaging_messaging_android", "()Lzendesk/messaging/android/internal/UriHandler;", "onWebViewUriClicked", "Lzendesk/messaging/android/internal/WebViewUriHandler;", "getOnWebViewUriClicked$zendesk_messaging_messaging_android", "()Lzendesk/messaging/android/internal/WebViewUriHandler;", "shouldScrollToBottom", "getShouldScrollToBottom$zendesk_messaging_messaging_android", "()Z", "state", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenState;", "getState$zendesk_messaging_messaging_android", "()Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenState;", "toBuilder", "Builder", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationScreenRendering {
    private final Function1<Integer, Unit> onAttachButtonClicked;
    private final Function0<Unit> onBackButtonClicked;
    private final Function1<CarouselAction, Unit> onCarouselAction;
    private final Function1<String, Unit> onCopyText;
    private final Function0<Unit> onDeniedPermissionActionClicked;
    private final Function0<Unit> onDeniedPermissionDismissed;
    private final Function1<Message, Unit> onFailedMessageClicked;
    private final Function1<Message, Unit> onFileAttachmentClicked;
    private final Function2<List<? extends Field>, MessageLogEntry.FormMessageContainer, Unit> onFormCompleted;
    private final Function2<DisplayedField, String, Unit> onFormDisplayedFieldsChanged;
    private final Function1<Boolean, Unit> onFormFocusChanged;
    private final Function1<Double, Unit> onLoadMoreMessages;
    private final Function1<String, Unit> onMessageComposerTextChanged;
    private final Function0<Unit> onPostbackFailedDismissedListener;
    private final Function1<MessageAction.Reply, Unit> onReplyActionSelected;
    private final Function0<Unit> onRetryConnectionClicked;
    private Function0<Unit> onRetryLoadConversationClicked;
    private final Function1<Double, Unit> onRetryLoadMoreClickedListener;
    private final Function0<Unit> onSeeLatestClickedListener;
    private final Function1<String, Unit> onSendButtonClicked;
    private final Function2<String, String, Unit> onSendPostbackMessage;
    private final Function0<Unit> onTyping;
    private final UriHandler onUriClicked;
    private final WebViewUriHandler onWebViewUriClicked;
    private final boolean shouldScrollToBottom;
    private final ConversationScreenState state;

    public ConversationScreenRendering(Builder builder) {
        Intrinsics.checkNotNullParameter(builder, "builder");
        this.onFormFocusChanged = builder.getOnFormFocusChanged$zendesk_messaging_messaging_android();
        this.onBackButtonClicked = builder.getOnBackButtonClicked$zendesk_messaging_messaging_android();
        this.onSendButtonClicked = builder.getOnSendButtonClicked$zendesk_messaging_messaging_android();
        this.onAttachButtonClicked = builder.getOnAttachButtonClicked$zendesk_messaging_messaging_android();
        this.onReplyActionSelected = builder.getOnReplyActionSelected$zendesk_messaging_messaging_android();
        this.onFailedMessageClicked = builder.getOnFailedMessageClicked$zendesk_messaging_messaging_android();
        this.onRetryConnectionClicked = builder.m244x6db480bc();
        this.onUriClicked = builder.getOnUriClicked();
        this.onWebViewUriClicked = builder.getOnWebViewUriClicked();
        this.onCarouselAction = builder.getOnCarouselAction$zendesk_messaging_messaging_android();
        this.onSendPostbackMessage = builder.getOnSendPostbackMessage$zendesk_messaging_messaging_android();
        this.onFormCompleted = builder.getOnFormCompleted$zendesk_messaging_messaging_android();
        this.onTyping = builder.getOnTyping$zendesk_messaging_messaging_android();
        this.onMessageComposerTextChanged = builder.m242x6e5dfc47();
        this.onDeniedPermissionActionClicked = builder.m239x4b440ba4();
        this.onDeniedPermissionDismissed = builder.m240x4982bbc();
        this.onFormDisplayedFieldsChanged = builder.m241xd959c585();
        this.onLoadMoreMessages = builder.getOnLoadMoreMessages$zendesk_messaging_messaging_android();
        this.onRetryLoadMoreClickedListener = builder.m246xf184e65f();
        this.onRetryLoadConversationClicked = builder.m245x819e779d();
        this.onSeeLatestClickedListener = builder.m247xa05399e8();
        this.onPostbackFailedDismissedListener = builder.m243x4c8a1eb6();
        this.onCopyText = builder.getOnCopyText$zendesk_messaging_messaging_android();
        this.shouldScrollToBottom = builder.getShouldScrollToBottom();
        this.onFileAttachmentClicked = builder.getOnFileAttachmentClicked$zendesk_messaging_messaging_android();
        this.state = builder.getState();
    }

    public final Function1<Boolean, Unit> getOnFormFocusChanged$zendesk_messaging_messaging_android() {
        return this.onFormFocusChanged;
    }

    public final Function0<Unit> getOnBackButtonClicked$zendesk_messaging_messaging_android() {
        return this.onBackButtonClicked;
    }

    public final Function1<String, Unit> getOnSendButtonClicked$zendesk_messaging_messaging_android() {
        return this.onSendButtonClicked;
    }

    public final Function1<Integer, Unit> getOnAttachButtonClicked$zendesk_messaging_messaging_android() {
        return this.onAttachButtonClicked;
    }

    public final Function1<MessageAction.Reply, Unit> getOnReplyActionSelected$zendesk_messaging_messaging_android() {
        return this.onReplyActionSelected;
    }

    public final Function1<Message, Unit> getOnFailedMessageClicked$zendesk_messaging_messaging_android() {
        return this.onFailedMessageClicked;
    }

    public final Function0<Unit> getOnRetryConnectionClicked$zendesk_messaging_messaging_android() {
        return this.onRetryConnectionClicked;
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

    public final Function2<String, String, Unit> getOnSendPostbackMessage$zendesk_messaging_messaging_android() {
        return this.onSendPostbackMessage;
    }

    public final Function2<List<? extends Field>, MessageLogEntry.FormMessageContainer, Unit> getOnFormCompleted$zendesk_messaging_messaging_android() {
        return this.onFormCompleted;
    }

    public final Function0<Unit> getOnTyping$zendesk_messaging_messaging_android() {
        return this.onTyping;
    }

    public final Function1<String, Unit> m233x6e5dfc47() {
        return this.onMessageComposerTextChanged;
    }

    public final Function0<Unit> m230x4b440ba4() {
        return this.onDeniedPermissionActionClicked;
    }

    public final Function0<Unit> m231x4982bbc() {
        return this.onDeniedPermissionDismissed;
    }

    public final Function2<DisplayedField, String, Unit> m232xd959c585() {
        return this.onFormDisplayedFieldsChanged;
    }

    public final Function1<Double, Unit> getOnLoadMoreMessages$zendesk_messaging_messaging_android() {
        return this.onLoadMoreMessages;
    }

    public final Function1<Double, Unit> m236xf184e65f() {
        return this.onRetryLoadMoreClickedListener;
    }

    public final Function0<Unit> m235x819e779d() {
        return this.onRetryLoadConversationClicked;
    }

    public final void m238xd17131a9(Function0<Unit> function0) {
        Intrinsics.checkNotNullParameter(function0, "<set-?>");
        this.onRetryLoadConversationClicked = function0;
    }

    public final Function0<Unit> m237xa05399e8() {
        return this.onSeeLatestClickedListener;
    }

    public final Function0<Unit> m234x4c8a1eb6() {
        return this.onPostbackFailedDismissedListener;
    }

    public final Function1<String, Unit> getOnCopyText$zendesk_messaging_messaging_android() {
        return this.onCopyText;
    }

    public final boolean getShouldScrollToBottom() {
        return this.shouldScrollToBottom;
    }

    public final Function1<Message, Unit> getOnFileAttachmentClicked$zendesk_messaging_messaging_android() {
        return this.onFileAttachmentClicked;
    }

    public final ConversationScreenState getState() {
        return this.state;
    }

    public ConversationScreenRendering() {
        this(new Builder());
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000Ö\u0001\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0010\b\n\u0002\u0010\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0006\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\f\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\b\u000e\u0018\u00002\u00020\u0001B\u0011\b\u0016\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0007\u0010\u0083\u0001\u001a\u00020\u0003J\u001b\u0010\u0084\u0001\u001a\u00020\u00002\u0012\u0010\u0006\u001a\u000e\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0007J\u0018\u0010\u000e\u001a\u00020\u00002\u0010\u0010\u000e\u001a\f\u0012\u0004\u0012\u00020\t0\u000fj\u0002`\u0010J\u001e\u0010\u0015\u001a\u00020\u00002\u0016\u0010\u0015\u001a\u0012\u0012\u0004\u0012\u00020\u0016\u0012\u0004\u0012\u00020\t0\u0007j\u0002`\u0017J\u001f\u0010\u001a\u001a\u00020\u00002\u0017\u0010\u0085\u0001\u001a\u0012\u0012\u0004\u0012\u00020\u001b\u0012\u0004\u0012\u00020\t0\u0007j\u0002`\u001cJ\u0018\u0010\u001f\u001a\u00020\u00002\u0010\u0010\u001f\u001a\f\u0012\u0004\u0012\u00020\t0\u000fj\u0002`\u0010J\u0018\u0010\"\u001a\u00020\u00002\u0010\u0010\"\u001a\f\u0012\u0004\u0012\u00020\t0\u000fj\u0002`\u0010J-\u0010%\u001a\u00020\u00002%\u0010%\u001a!\u0012\u0013\u0012\u00110&¢\u0006\f\b'\u0012\b\b(\u0012\u0004\b\b()\u0012\u0004\u0012\u00020\t0\u0007j\u0002`*J\u001e\u0010-\u001a\u00020\u00002\u0016\u0010-\u001a\u0012\u0012\u0004\u0012\u00020&\u0012\u0004\u0012\u00020\t0\u0007j\u0002`.J*\u00101\u001a\u00020\u00002\"\u00101\u001a\u001e\u0012\n\u0012\b\u0012\u0004\u0012\u00020403\u0012\u0004\u0012\u000205\u0012\u0004\u0012\u00020\t02j\u0002`6J$\u0010;\u001a\u00020\u00002\u001c\u0010;\u001a\u0018\u0012\u0004\u0012\u00020<\u0012\u0004\u0012\u00020\u001b\u0012\u0004\u0012\u00020\t02j\u0002`=J\u001e\u0010@\u001a\u00020\u00002\u0016\u0010@\u001a\u0012\u0012\u0004\u0012\u00020A\u0012\u0004\u0012\u00020\t0\u0007j\u0002`BJ\u001a\u0010E\u001a\u00020\u00002\u0012\u0010E\u001a\u000e\u0012\u0004\u0012\u00020F\u0012\u0004\u0012\u00020\t0\u0007J\u001a\u0010I\u001a\u00020\u00002\u0012\u0010I\u001a\u000e\u0012\u0004\u0012\u00020\u001b\u0012\u0004\u0012\u00020\t0\u0007J\u0018\u0010L\u001a\u00020\u00002\u0010\u0010L\u001a\f\u0012\u0004\u0012\u00020\t0\u000fj\u0002`\u0010J\u001e\u0010O\u001a\u00020\u00002\u0016\u0010O\u001a\u0012\u0012\u0004\u0012\u00020P\u0012\u0004\u0012\u00020\t0\u0007j\u0002`QJ\u0019\u0010\u0086\u0001\u001a\u00020\u00002\u0010\u0010T\u001a\f\u0012\u0004\u0012\u00020\t0\u000fj\u0002`UJ\u0019\u0010X\u001a\u00020\u00002\u0011\u0010\u0087\u0001\u001a\f\u0012\u0004\u0012\u00020\t0\u000fj\u0002`\u0010J\u001a\u0010[\u001a\u00020\u00002\u0012\u0010[\u001a\u000e\u0012\u0004\u0012\u00020F\u0012\u0004\u0012\u00020\t0\u0007J\u0010\u0010\u0088\u0001\u001a\u00020\u00002\u0007\u0010\u0088\u0001\u001a\u00020AJ\u0018\u0010^\u001a\u00020\u00002\u0010\u0010^\u001a\f\u0012\u0004\u0012\u00020\t0\u000fj\u0002`\u0010J\u001e\u0010a\u001a\u00020\u00002\u0016\u0010a\u001a\u0012\u0012\u0004\u0012\u00020\u001b\u0012\u0004\u0012\u00020\t0\u0007j\u0002`bJ$\u0010e\u001a\u00020\u00002\u001c\u0010e\u001a\u0018\u0012\u0004\u0012\u00020\u001b\u0012\u0004\u0012\u00020\u001b\u0012\u0004\u0012\u00020\t02j\u0002`fJ\u0018\u0010i\u001a\u00020\u00002\u0010\u0010i\u001a\f\u0012\u0004\u0012\u00020\t0\u000fj\u0002`\u0010J\u000f\u0010l\u001a\u00020\u00002\u0007\u0010\u0089\u0001\u001a\u00020mJ\u000f\u0010r\u001a\u00020\u00002\u0007\u0010\u008a\u0001\u001a\u00020sJ\u001b\u0010}\u001a\u00020\u00002\u0013\u0010\u008b\u0001\u001a\u000e\u0012\u0004\u0012\u00020~\u0012\u0004\u0012\u00020~0\u0007R&\u0010\u0006\u001a\u000e\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\n\u0010\u000b\"\u0004\b\f\u0010\rR$\u0010\u000e\u001a\f\u0012\u0004\u0012\u00020\t0\u000fj\u0002`\u0010X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0011\u0010\u0012\"\u0004\b\u0013\u0010\u0014R*\u0010\u0015\u001a\u0012\u0012\u0004\u0012\u00020\u0016\u0012\u0004\u0012\u00020\t0\u0007j\u0002`\u0017X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0018\u0010\u000b\"\u0004\b\u0019\u0010\rR*\u0010\u001a\u001a\u0012\u0012\u0004\u0012\u00020\u001b\u0012\u0004\u0012\u00020\t0\u0007j\u0002`\u001cX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001d\u0010\u000b\"\u0004\b\u001e\u0010\rR$\u0010\u001f\u001a\f\u0012\u0004\u0012\u00020\t0\u000fj\u0002`\u0010X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b \u0010\u0012\"\u0004\b!\u0010\u0014R$\u0010\"\u001a\f\u0012\u0004\u0012\u00020\t0\u000fj\u0002`\u0010X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b#\u0010\u0012\"\u0004\b$\u0010\u0014R9\u0010%\u001a!\u0012\u0013\u0012\u00110&¢\u0006\f\b'\u0012\b\b(\u0012\u0004\b\b()\u0012\u0004\u0012\u00020\t0\u0007j\u0002`*X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b+\u0010\u000b\"\u0004\b,\u0010\rR*\u0010-\u001a\u0012\u0012\u0004\u0012\u00020&\u0012\u0004\u0012\u00020\t0\u0007j\u0002`.X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b/\u0010\u000b\"\u0004\b0\u0010\rR6\u00101\u001a\u001e\u0012\n\u0012\b\u0012\u0004\u0012\u00020403\u0012\u0004\u0012\u000205\u0012\u0004\u0012\u00020\t02j\u0002`6X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b7\u00108\"\u0004\b9\u0010:R0\u0010;\u001a\u0018\u0012\u0004\u0012\u00020<\u0012\u0004\u0012\u00020\u001b\u0012\u0004\u0012\u00020\t02j\u0002`=X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b>\u00108\"\u0004\b?\u0010:R*\u0010@\u001a\u0012\u0012\u0004\u0012\u00020A\u0012\u0004\u0012\u00020\t0\u0007j\u0002`BX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bC\u0010\u000b\"\u0004\bD\u0010\rR&\u0010E\u001a\u000e\u0012\u0004\u0012\u00020F\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bG\u0010\u000b\"\u0004\bH\u0010\rR&\u0010I\u001a\u000e\u0012\u0004\u0012\u00020\u001b\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bJ\u0010\u000b\"\u0004\bK\u0010\rR$\u0010L\u001a\f\u0012\u0004\u0012\u00020\t0\u000fj\u0002`\u0010X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bM\u0010\u0012\"\u0004\bN\u0010\u0014R*\u0010O\u001a\u0012\u0012\u0004\u0012\u00020P\u0012\u0004\u0012\u00020\t0\u0007j\u0002`QX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bR\u0010\u000b\"\u0004\bS\u0010\rR$\u0010T\u001a\f\u0012\u0004\u0012\u00020\t0\u000fj\u0002`UX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bV\u0010\u0012\"\u0004\bW\u0010\u0014R$\u0010X\u001a\f\u0012\u0004\u0012\u00020\t0\u000fj\u0002`\u0010X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bY\u0010\u0012\"\u0004\bZ\u0010\u0014R&\u0010[\u001a\u000e\u0012\u0004\u0012\u00020F\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\\\u0010\u000b\"\u0004\b]\u0010\rR$\u0010^\u001a\f\u0012\u0004\u0012\u00020\t0\u000fj\u0002`\u0010X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b_\u0010\u0012\"\u0004\b`\u0010\u0014R*\u0010a\u001a\u0012\u0012\u0004\u0012\u00020\u001b\u0012\u0004\u0012\u00020\t0\u0007j\u0002`bX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bc\u0010\u000b\"\u0004\bd\u0010\rR0\u0010e\u001a\u0018\u0012\u0004\u0012\u00020\u001b\u0012\u0004\u0012\u00020\u001b\u0012\u0004\u0012\u00020\t02j\u0002`fX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bg\u00108\"\u0004\bh\u0010:R$\u0010i\u001a\f\u0012\u0004\u0012\u00020\t0\u000fj\u0002`\u0010X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bj\u0010\u0012\"\u0004\bk\u0010\u0014R\u001a\u0010l\u001a\u00020mX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bn\u0010o\"\u0004\bp\u0010qR\u001a\u0010r\u001a\u00020sX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bt\u0010u\"\u0004\bv\u0010wR\u001a\u0010x\u001a\u00020AX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\by\u0010z\"\u0004\b{\u0010|R\u001d\u0010}\u001a\u00020~X\u0080\u000e¢\u0006\u0011\n\u0000\u001a\u0005\b\u007f\u0010\u0080\u0001\"\u0006\b\u0081\u0001\u0010\u0082\u0001¨\u0006\u008c\u0001"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenRendering$Builder;", "", "rendering", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenRendering;", "(Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenRendering;)V", "()V", "onAttachButtonClicked", "Lkotlin/Function1;", "", "", "getOnAttachButtonClicked$zendesk_messaging_messaging_android", "()Lkotlin/jvm/functions/Function1;", "setOnAttachButtonClicked$zendesk_messaging_messaging_android", "(Lkotlin/jvm/functions/Function1;)V", "onBackButtonClicked", "Lkotlin/Function0;", "Lzendesk/messaging/android/internal/conversationscreen/OnClickLambda;", "getOnBackButtonClicked$zendesk_messaging_messaging_android", "()Lkotlin/jvm/functions/Function0;", "setOnBackButtonClicked$zendesk_messaging_messaging_android", "(Lkotlin/jvm/functions/Function0;)V", "onCarouselAction", "Lzendesk/ui/android/conversation/carousel/CarouselAction;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnCarouselAction;", "getOnCarouselAction$zendesk_messaging_messaging_android", "setOnCarouselAction$zendesk_messaging_messaging_android", "onCopyText", "", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnCopyTextAction;", "getOnCopyText$zendesk_messaging_messaging_android", "setOnCopyText$zendesk_messaging_messaging_android", "onDeniedPermissionActionClicked", "getOnDeniedPermissionActionClicked$zendesk_messaging_messaging_android", "setOnDeniedPermissionActionClicked$zendesk_messaging_messaging_android", "onDeniedPermissionDismissed", "getOnDeniedPermissionDismissed$zendesk_messaging_messaging_android", "setOnDeniedPermissionDismissed$zendesk_messaging_messaging_android", "onFailedMessageClicked", "Lzendesk/conversationkit/android/model/Message;", "Lkotlin/ParameterName;", "name", "message", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFailedMessageClickedListener;", "getOnFailedMessageClicked$zendesk_messaging_messaging_android", "setOnFailedMessageClicked$zendesk_messaging_messaging_android", "onFileAttachmentClicked", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFileAttachmentClicked;", "getOnFileAttachmentClicked$zendesk_messaging_messaging_android", "setOnFileAttachmentClicked$zendesk_messaging_messaging_android", "onFormCompleted", "Lkotlin/Function2;", "", "Lzendesk/conversationkit/android/model/Field;", "Lzendesk/messaging/android/internal/model/MessageLogEntry$FormMessageContainer;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFormCompleted;", "getOnFormCompleted$zendesk_messaging_messaging_android", "()Lkotlin/jvm/functions/Function2;", "setOnFormCompleted$zendesk_messaging_messaging_android", "(Lkotlin/jvm/functions/Function2;)V", "onFormDisplayedFieldsChanged", "Lzendesk/ui/android/conversation/form/DisplayedField;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFormDisplayedFieldsChanged;", "getOnFormDisplayedFieldsChanged$zendesk_messaging_messaging_android", "setOnFormDisplayedFieldsChanged$zendesk_messaging_messaging_android", "onFormFocusChanged", "", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFormFocusChangedListener;", "getOnFormFocusChanged$zendesk_messaging_messaging_android", "setOnFormFocusChanged$zendesk_messaging_messaging_android", "onLoadMoreMessages", "", "getOnLoadMoreMessages$zendesk_messaging_messaging_android", "setOnLoadMoreMessages$zendesk_messaging_messaging_android", "onMessageComposerTextChanged", "getOnMessageComposerTextChanged$zendesk_messaging_messaging_android", "setOnMessageComposerTextChanged$zendesk_messaging_messaging_android", "onPostbackFailedDismissedListener", "getOnPostbackFailedDismissedListener$zendesk_messaging_messaging_android", "setOnPostbackFailedDismissedListener$zendesk_messaging_messaging_android", "onReplyActionSelected", "Lzendesk/conversationkit/android/model/MessageAction$Reply;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnReplyActionSelected;", "getOnReplyActionSelected$zendesk_messaging_messaging_android", "setOnReplyActionSelected$zendesk_messaging_messaging_android", "onRetryConnectionClickedListener", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnRetryConnectionClickedListener;", "getOnRetryConnectionClickedListener$zendesk_messaging_messaging_android", "setOnRetryConnectionClickedListener$zendesk_messaging_messaging_android", "onRetryLoadConversationClicked", "getOnRetryLoadConversationClicked$zendesk_messaging_messaging_android", "setOnRetryLoadConversationClicked$zendesk_messaging_messaging_android", "onRetryLoadMoreClickedListener", "getOnRetryLoadMoreClickedListener$zendesk_messaging_messaging_android", "setOnRetryLoadMoreClickedListener$zendesk_messaging_messaging_android", "onSeeLatestClickedListener", "getOnSeeLatestClickedListener$zendesk_messaging_messaging_android", "setOnSeeLatestClickedListener$zendesk_messaging_messaging_android", "onSendButtonClicked", "Lzendesk/messaging/android/internal/conversationscreen/OnSendButtonClickLambda;", "getOnSendButtonClicked$zendesk_messaging_messaging_android", "setOnSendButtonClicked$zendesk_messaging_messaging_android", "onSendPostbackMessage", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnSendPostbackMessage;", "getOnSendPostbackMessage$zendesk_messaging_messaging_android", "setOnSendPostbackMessage$zendesk_messaging_messaging_android", "onTyping", "getOnTyping$zendesk_messaging_messaging_android", "setOnTyping$zendesk_messaging_messaging_android", "onUriClicked", "Lzendesk/messaging/android/internal/UriHandler;", "getOnUriClicked$zendesk_messaging_messaging_android", "()Lzendesk/messaging/android/internal/UriHandler;", "setOnUriClicked$zendesk_messaging_messaging_android", "(Lzendesk/messaging/android/internal/UriHandler;)V", "onWebViewUriClicked", "Lzendesk/messaging/android/internal/WebViewUriHandler;", "getOnWebViewUriClicked$zendesk_messaging_messaging_android", "()Lzendesk/messaging/android/internal/WebViewUriHandler;", "setOnWebViewUriClicked$zendesk_messaging_messaging_android", "(Lzendesk/messaging/android/internal/WebViewUriHandler;)V", "shouldScrollToBottom", "getShouldScrollToBottom$zendesk_messaging_messaging_android", "()Z", "setShouldScrollToBottom$zendesk_messaging_messaging_android", "(Z)V", "state", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenState;", "getState$zendesk_messaging_messaging_android", "()Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenState;", "setState$zendesk_messaging_messaging_android", "(Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenState;)V", "build", "onAttachMenuItemClicked", "onCopyTextAction", "onRetryConnectionButtonClicked", "lambda", "onScrollToBottomListener", "uriHandler", "webViewUriHandler", "stateUpdate", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        private Function1<? super Integer, Unit> onAttachButtonClicked;
        private Function0<Unit> onBackButtonClicked;
        private Function1<? super CarouselAction, Unit> onCarouselAction;
        private Function1<? super String, Unit> onCopyText;
        private Function0<Unit> onDeniedPermissionActionClicked;
        private Function0<Unit> onDeniedPermissionDismissed;
        private Function1<? super Message, Unit> onFailedMessageClicked;
        private Function1<? super Message, Unit> onFileAttachmentClicked;
        private Function2<? super List<? extends Field>, ? super MessageLogEntry.FormMessageContainer, Unit> onFormCompleted;
        private Function2<? super DisplayedField, ? super String, Unit> onFormDisplayedFieldsChanged;
        private Function1<? super Boolean, Unit> onFormFocusChanged;
        private Function1<? super Double, Unit> onLoadMoreMessages;
        private Function1<? super String, Unit> onMessageComposerTextChanged;
        private Function0<Unit> onPostbackFailedDismissedListener;
        private Function1<? super MessageAction.Reply, Unit> onReplyActionSelected;
        private Function0<Unit> onRetryConnectionClickedListener;
        private Function0<Unit> onRetryLoadConversationClicked;
        private Function1<? super Double, Unit> onRetryLoadMoreClickedListener;
        private Function0<Unit> onSeeLatestClickedListener;
        private Function1<? super String, Unit> onSendButtonClicked;
        private Function2<? super String, ? super String, Unit> onSendPostbackMessage;
        private Function0<Unit> onTyping;
        private UriHandler onUriClicked;
        private WebViewUriHandler onWebViewUriClicked;
        private boolean shouldScrollToBottom;
        private ConversationScreenState state;

        public Builder() {
            this.onFormFocusChanged = new Function1<Boolean, Unit>() {
                public final void invoke(boolean z) {
                }

                @Override
                public Unit invoke(Boolean bool) {
                    invoke(bool.booleanValue());
                    return Unit.INSTANCE;
                }
            };
            this.onBackButtonClicked = new Function0<Unit>() {
                public final void invoke2() {
                }

                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }
            };
            this.onAttachButtonClicked = new Function1<Integer, Unit>() {
                public final void invoke(int i) {
                }

                @Override
                public Unit invoke(Integer num) {
                    invoke(num.intValue());
                    return Unit.INSTANCE;
                }
            };
            this.onSendButtonClicked = new Function1<String, Unit>() {
                public final void invoke2(String it) {
                    Intrinsics.checkNotNullParameter(it, "it");
                }

                @Override
                public Unit invoke(String str) {
                    invoke2(str);
                    return Unit.INSTANCE;
                }
            };
            this.onUriClicked = StubUriHandler.INSTANCE;
            this.onWebViewUriClicked = StubWebViewUriHandler.INSTANCE;
            this.onCarouselAction = MessageLogListenersKt.getNOOP_ON_CAROUSEL_ACTION();
            this.onReplyActionSelected = MessageLogListenersKt.getNOOP_ON_QUICK_REPLY_OPTION_SELECTED_LISTENER();
            this.onFailedMessageClicked = MessageLogListenersKt.getNOOP_ON_MESSAGE_CONTAINER_CLICKED_LISTENER();
            this.onRetryConnectionClickedListener = MessageLogListenersKt.getNOOP_ON_RETRY_CONNECTION_CLICKED_LISTENER();
            this.onFormCompleted = MessageLogListenersKt.getNOOP_ON_FORM_COMPLETED();
            this.onTyping = new Function0<Unit>() {
                public final void invoke2() {
                }

                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }
            };
            this.onMessageComposerTextChanged = new Function1<String, Unit>() {
                public final void invoke2(String it) {
                    Intrinsics.checkNotNullParameter(it, "it");
                }

                @Override
                public Unit invoke(String str) {
                    invoke2(str);
                    return Unit.INSTANCE;
                }
            };
            this.onDeniedPermissionActionClicked = new Function0<Unit>() {
                public final void invoke2() {
                }

                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }
            };
            this.onDeniedPermissionDismissed = new Function0<Unit>() {
                public final void invoke2() {
                }

                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }
            };
            this.state = new ConversationScreenState(null, null, null, null, null, null, false, null, false, false, null, null, null, false, null, false, false, false, null, false, null, false, null, null, null, null, false, null, 268435455, null);
            this.onFormDisplayedFieldsChanged = new Function2<DisplayedField, String, Unit>() {
                public final void invoke2(DisplayedField displayedField, String str) {
                    Intrinsics.checkNotNullParameter(displayedField, "<anonymous parameter 0>");
                    Intrinsics.checkNotNullParameter(str, "<anonymous parameter 1>");
                }

                @Override
                public Unit invoke(DisplayedField displayedField, String str) {
                    invoke2(displayedField, str);
                    return Unit.INSTANCE;
                }
            };
            this.onLoadMoreMessages = new Function1<Double, Unit>() {
                public final void invoke(double d) {
                }

                @Override
                public Unit invoke(Double d) {
                    invoke(d.doubleValue());
                    return Unit.INSTANCE;
                }
            };
            this.onRetryLoadMoreClickedListener = new Function1<Double, Unit>() {
                public final void invoke(double d) {
                }

                @Override
                public Unit invoke(Double d) {
                    invoke(d.doubleValue());
                    return Unit.INSTANCE;
                }
            };
            this.onRetryLoadConversationClicked = new Function0<Unit>() {
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
            this.onSendPostbackMessage = MessageLogListenersKt.getNOOP_ON_SEND_POSTBACK_MESSAGE();
            this.onPostbackFailedDismissedListener = new Function0<Unit>() {
                public final void invoke2() {
                }

                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }
            };
            this.onCopyText = MessageLogListenersKt.getNOOP_ON_COPY_TEXT_ACTION();
            this.onFileAttachmentClicked = MessageLogListenersKt.getNOOP_ON_FILE_ATTACHMENT_CLICKED_ACTION();
        }

        public final Function1<Boolean, Unit> getOnFormFocusChanged$zendesk_messaging_messaging_android() {
            return this.onFormFocusChanged;
        }

        public final void setOnFormFocusChanged$zendesk_messaging_messaging_android(Function1<? super Boolean, Unit> function1) {
            Intrinsics.checkNotNullParameter(function1, "<set-?>");
            this.onFormFocusChanged = function1;
        }

        public final Function0<Unit> getOnBackButtonClicked$zendesk_messaging_messaging_android() {
            return this.onBackButtonClicked;
        }

        public final void setOnBackButtonClicked$zendesk_messaging_messaging_android(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onBackButtonClicked = function0;
        }

        public final Function1<Integer, Unit> getOnAttachButtonClicked$zendesk_messaging_messaging_android() {
            return this.onAttachButtonClicked;
        }

        public final void setOnAttachButtonClicked$zendesk_messaging_messaging_android(Function1<? super Integer, Unit> function1) {
            Intrinsics.checkNotNullParameter(function1, "<set-?>");
            this.onAttachButtonClicked = function1;
        }

        public final Function1<String, Unit> getOnSendButtonClicked$zendesk_messaging_messaging_android() {
            return this.onSendButtonClicked;
        }

        public final void setOnSendButtonClicked$zendesk_messaging_messaging_android(Function1<? super String, Unit> function1) {
            Intrinsics.checkNotNullParameter(function1, "<set-?>");
            this.onSendButtonClicked = function1;
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

        public final Function1<CarouselAction, Unit> getOnCarouselAction$zendesk_messaging_messaging_android() {
            return this.onCarouselAction;
        }

        public final void setOnCarouselAction$zendesk_messaging_messaging_android(Function1<? super CarouselAction, Unit> function1) {
            Intrinsics.checkNotNullParameter(function1, "<set-?>");
            this.onCarouselAction = function1;
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

        public final Function0<Unit> m244x6db480bc() {
            return this.onRetryConnectionClickedListener;
        }

        public final void m253x13c0e7c8(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onRetryConnectionClickedListener = function0;
        }

        public final Function2<List<? extends Field>, MessageLogEntry.FormMessageContainer, Unit> getOnFormCompleted$zendesk_messaging_messaging_android() {
            return this.onFormCompleted;
        }

        public final void setOnFormCompleted$zendesk_messaging_messaging_android(Function2<? super List<? extends Field>, ? super MessageLogEntry.FormMessageContainer, Unit> function2) {
            Intrinsics.checkNotNullParameter(function2, "<set-?>");
            this.onFormCompleted = function2;
        }

        public final Function0<Unit> getOnTyping$zendesk_messaging_messaging_android() {
            return this.onTyping;
        }

        public final void setOnTyping$zendesk_messaging_messaging_android(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onTyping = function0;
        }

        public final Function1<String, Unit> m242x6e5dfc47() {
            return this.onMessageComposerTextChanged;
        }

        public final void m251xbb6fc953(Function1<? super String, Unit> function1) {
            Intrinsics.checkNotNullParameter(function1, "<set-?>");
            this.onMessageComposerTextChanged = function1;
        }

        public final Function0<Unit> m239x4b440ba4() {
            return this.onDeniedPermissionActionClicked;
        }

        public final void m248xf5c89318(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onDeniedPermissionActionClicked = function0;
        }

        public final Function0<Unit> m240x4982bbc() {
            return this.onDeniedPermissionDismissed;
        }

        public final void m249xfed28d30(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onDeniedPermissionDismissed = function0;
        }

        public final ConversationScreenState getState() {
            return this.state;
        }

        public final void setState$zendesk_messaging_messaging_android(ConversationScreenState conversationScreenState) {
            Intrinsics.checkNotNullParameter(conversationScreenState, "<set-?>");
            this.state = conversationScreenState;
        }

        public final Function2<DisplayedField, String, Unit> m241xd959c585() {
            return this.onFormDisplayedFieldsChanged;
        }

        public final void m250x266b9291(Function2<? super DisplayedField, ? super String, Unit> function2) {
            Intrinsics.checkNotNullParameter(function2, "<set-?>");
            this.onFormDisplayedFieldsChanged = function2;
        }

        public final Function1<Double, Unit> getOnLoadMoreMessages$zendesk_messaging_messaging_android() {
            return this.onLoadMoreMessages;
        }

        public final void setOnLoadMoreMessages$zendesk_messaging_messaging_android(Function1<? super Double, Unit> function1) {
            Intrinsics.checkNotNullParameter(function1, "<set-?>");
            this.onLoadMoreMessages = function1;
        }

        public final Function1<Double, Unit> m246xf184e65f() {
            return this.onRetryLoadMoreClickedListener;
        }

        public final void m255x4157a06b(Function1<? super Double, Unit> function1) {
            Intrinsics.checkNotNullParameter(function1, "<set-?>");
            this.onRetryLoadMoreClickedListener = function1;
        }

        public final Function0<Unit> m245x819e779d() {
            return this.onRetryLoadConversationClicked;
        }

        public final void m254xd17131a9(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onRetryLoadConversationClicked = function0;
        }

        public final Function0<Unit> m247xa05399e8() {
            return this.onSeeLatestClickedListener;
        }

        public final void m256x454d39f4(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onSeeLatestClickedListener = function0;
        }

        public final Function2<String, String, Unit> getOnSendPostbackMessage$zendesk_messaging_messaging_android() {
            return this.onSendPostbackMessage;
        }

        public final void setOnSendPostbackMessage$zendesk_messaging_messaging_android(Function2<? super String, ? super String, Unit> function2) {
            Intrinsics.checkNotNullParameter(function2, "<set-?>");
            this.onSendPostbackMessage = function2;
        }

        public final Function0<Unit> m243x4c8a1eb6() {
            return this.onPostbackFailedDismissedListener;
        }

        public final void m252x680a992a(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onPostbackFailedDismissedListener = function0;
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

        public final boolean getShouldScrollToBottom() {
            return this.shouldScrollToBottom;
        }

        public final void setShouldScrollToBottom$zendesk_messaging_messaging_android(boolean z) {
            this.shouldScrollToBottom = z;
        }

        public Builder(ConversationScreenRendering rendering) {
            this();
            Intrinsics.checkNotNullParameter(rendering, "rendering");
            this.onBackButtonClicked = rendering.getOnBackButtonClicked$zendesk_messaging_messaging_android();
            this.onSendButtonClicked = rendering.getOnSendButtonClicked$zendesk_messaging_messaging_android();
            this.onAttachButtonClicked = rendering.getOnAttachButtonClicked$zendesk_messaging_messaging_android();
            this.onReplyActionSelected = rendering.getOnReplyActionSelected$zendesk_messaging_messaging_android();
            this.onFailedMessageClicked = rendering.getOnFailedMessageClicked$zendesk_messaging_messaging_android();
            this.onRetryConnectionClickedListener = rendering.getOnRetryConnectionClicked$zendesk_messaging_messaging_android();
            this.onUriClicked = rendering.getOnUriClicked();
            this.onWebViewUriClicked = rendering.getOnWebViewUriClicked();
            this.onCarouselAction = rendering.getOnCarouselAction$zendesk_messaging_messaging_android();
            this.onFormCompleted = rendering.getOnFormCompleted$zendesk_messaging_messaging_android();
            this.onFormFocusChanged = rendering.getOnFormFocusChanged$zendesk_messaging_messaging_android();
            this.onFormDisplayedFieldsChanged = rendering.m232xd959c585();
            this.onTyping = rendering.getOnTyping$zendesk_messaging_messaging_android();
            this.onMessageComposerTextChanged = rendering.m233x6e5dfc47();
            this.onDeniedPermissionActionClicked = rendering.m230x4b440ba4();
            this.onDeniedPermissionDismissed = rendering.m231x4982bbc();
            this.onLoadMoreMessages = rendering.getOnLoadMoreMessages$zendesk_messaging_messaging_android();
            this.onRetryLoadMoreClickedListener = rendering.m236xf184e65f();
            this.onSeeLatestClickedListener = rendering.m237xa05399e8();
            this.onPostbackFailedDismissedListener = rendering.m234x4c8a1eb6();
            this.onCopyText = rendering.getOnCopyText$zendesk_messaging_messaging_android();
            this.shouldScrollToBottom = rendering.getShouldScrollToBottom();
            this.onFileAttachmentClicked = rendering.getOnFileAttachmentClicked$zendesk_messaging_messaging_android();
            this.state = rendering.getState();
        }

        public Builder(ConversationScreenRendering conversationScreenRendering, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this((i & 1) != 0 ? new ConversationScreenRendering() : conversationScreenRendering);
        }

        public final Builder onBackButtonClicked(Function0<Unit> onBackButtonClicked) {
            Intrinsics.checkNotNullParameter(onBackButtonClicked, "onBackButtonClicked");
            this.onBackButtonClicked = onBackButtonClicked;
            return this;
        }

        public final Builder onSendButtonClicked(Function1<? super String, Unit> onSendButtonClicked) {
            Intrinsics.checkNotNullParameter(onSendButtonClicked, "onSendButtonClicked");
            this.onSendButtonClicked = onSendButtonClicked;
            return this;
        }

        public final Builder onAttachMenuItemClicked(Function1<? super Integer, Unit> onAttachButtonClicked) {
            Intrinsics.checkNotNullParameter(onAttachButtonClicked, "onAttachButtonClicked");
            this.onAttachButtonClicked = onAttachButtonClicked;
            return this;
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

        public final Builder onRetryConnectionButtonClicked(Function0<Unit> onRetryConnectionClickedListener) {
            Intrinsics.checkNotNullParameter(onRetryConnectionClickedListener, "onRetryConnectionClickedListener");
            this.onRetryConnectionClickedListener = onRetryConnectionClickedListener;
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

        public final Builder onCopyText(Function1<? super String, Unit> onCopyTextAction) {
            Intrinsics.checkNotNullParameter(onCopyTextAction, "onCopyTextAction");
            this.onCopyText = onCopyTextAction;
            return this;
        }

        public final Builder onFormCompleted(Function2<? super List<? extends Field>, ? super MessageLogEntry.FormMessageContainer, Unit> onFormCompleted) {
            Intrinsics.checkNotNullParameter(onFormCompleted, "onFormCompleted");
            this.onFormCompleted = onFormCompleted;
            return this;
        }

        public final Builder onFormFocusChanged(Function1<? super Boolean, Unit> onFormFocusChanged) {
            Intrinsics.checkNotNullParameter(onFormFocusChanged, "onFormFocusChanged");
            this.onFormFocusChanged = onFormFocusChanged;
            return this;
        }

        public final Builder onFormDisplayedFieldsChanged(Function2<? super DisplayedField, ? super String, Unit> onFormDisplayedFieldsChanged) {
            Intrinsics.checkNotNullParameter(onFormDisplayedFieldsChanged, "onFormDisplayedFieldsChanged");
            this.onFormDisplayedFieldsChanged = onFormDisplayedFieldsChanged;
            return this;
        }

        public final Builder onTyping(Function0<Unit> onTyping) {
            Intrinsics.checkNotNullParameter(onTyping, "onTyping");
            this.onTyping = onTyping;
            return this;
        }

        public final Builder onMessageComposerTextChanged(Function1<? super String, Unit> onMessageComposerTextChanged) {
            Intrinsics.checkNotNullParameter(onMessageComposerTextChanged, "onMessageComposerTextChanged");
            this.onMessageComposerTextChanged = onMessageComposerTextChanged;
            return this;
        }

        public final Builder onDeniedPermissionActionClicked(Function0<Unit> onDeniedPermissionActionClicked) {
            Intrinsics.checkNotNullParameter(onDeniedPermissionActionClicked, "onDeniedPermissionActionClicked");
            this.onDeniedPermissionActionClicked = onDeniedPermissionActionClicked;
            return this;
        }

        public final Builder onDeniedPermissionDismissed(Function0<Unit> onDeniedPermissionDismissed) {
            Intrinsics.checkNotNullParameter(onDeniedPermissionDismissed, "onDeniedPermissionDismissed");
            this.onDeniedPermissionDismissed = onDeniedPermissionDismissed;
            return this;
        }

        public final Builder onLoadMoreMessages(Function1<? super Double, Unit> onLoadMoreMessages) {
            Intrinsics.checkNotNullParameter(onLoadMoreMessages, "onLoadMoreMessages");
            this.onLoadMoreMessages = onLoadMoreMessages;
            return this;
        }

        public final Builder onRetryLoadMoreClickedListener(Function1<? super Double, Unit> onRetryLoadMoreClickedListener) {
            Intrinsics.checkNotNullParameter(onRetryLoadMoreClickedListener, "onRetryLoadMoreClickedListener");
            this.onRetryLoadMoreClickedListener = onRetryLoadMoreClickedListener;
            return this;
        }

        public final Builder onRetryLoadConversationClicked(Function0<Unit> lambda) {
            Intrinsics.checkNotNullParameter(lambda, "lambda");
            this.onRetryLoadConversationClicked = lambda;
            return this;
        }

        public final Builder onSeeLatestClickedListener(Function0<Unit> onSeeLatestClickedListener) {
            Intrinsics.checkNotNullParameter(onSeeLatestClickedListener, "onSeeLatestClickedListener");
            this.onSeeLatestClickedListener = onSeeLatestClickedListener;
            return this;
        }

        public final Builder onPostbackFailedDismissedListener(Function0<Unit> onPostbackFailedDismissedListener) {
            Intrinsics.checkNotNullParameter(onPostbackFailedDismissedListener, "onPostbackFailedDismissedListener");
            this.onPostbackFailedDismissedListener = onPostbackFailedDismissedListener;
            return this;
        }

        public final Builder onScrollToBottomListener(boolean onScrollToBottomListener) {
            this.shouldScrollToBottom = onScrollToBottomListener;
            return this;
        }

        public final Builder onFileAttachmentClicked(Function1<? super Message, Unit> onFileAttachmentClicked) {
            Intrinsics.checkNotNullParameter(onFileAttachmentClicked, "onFileAttachmentClicked");
            this.onFileAttachmentClicked = onFileAttachmentClicked;
            return this;
        }

        public final Builder state(Function1<? super ConversationScreenState, ConversationScreenState> stateUpdate) {
            Intrinsics.checkNotNullParameter(stateUpdate, "stateUpdate");
            this.state = stateUpdate.invoke(this.state);
            return this;
        }

        public final ConversationScreenRendering build() {
            return new ConversationScreenRendering(this);
        }
    }
}
