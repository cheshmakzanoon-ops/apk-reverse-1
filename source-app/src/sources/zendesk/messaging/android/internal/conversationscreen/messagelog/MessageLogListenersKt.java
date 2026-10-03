package zendesk.messaging.android.internal.conversationscreen.messagelog;

import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.model.Field;
import zendesk.conversationkit.android.model.Message;
import zendesk.conversationkit.android.model.MessageAction;
import zendesk.messaging.android.internal.model.MessageLogEntry;
import zendesk.p026ui.android.conversation.carousel.CarouselAction;
import zendesk.p026ui.android.conversation.form.DisplayedField;

@Metadata(m17d1 = {"\u0000¦\u0001\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\"$\u0010\u0000\u001a\u0012\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u00030\u0001j\u0002`\u0004X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006\"$\u0010\u0007\u001a\u0012\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\u00030\u0001j\u0002`\tX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u0006\"$\u0010\u000b\u001a\u0012\u0012\u0004\u0012\u00020\f\u0012\u0004\u0012\u00020\u00030\u0001j\u0002`\rX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u0006\"0\u0010\u000f\u001a\u001e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00120\u0011\u0012\u0004\u0012\u00020\u0013\u0012\u0004\u0012\u00020\u00030\u0010j\u0002`\u0014X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016\"*\u0010\u0017\u001a\u0018\u0012\u0004\u0012\u00020\u0018\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\u00030\u0010j\u0002`\u0019X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u0016\"$\u0010\u001b\u001a\u0012\u0012\u0004\u0012\u00020\u001c\u0012\u0004\u0012\u00020\u00030\u0001j\u0002`\u001dX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001e\u0010\u0006\"3\u0010\u001f\u001a!\u0012\u0013\u0012\u00110\f¢\u0006\f\b \u0012\b\b!\u0012\u0004\b\b(\"\u0012\u0004\u0012\u00020\u00030\u0001j\u0002`#X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b$\u0010\u0006\"$\u0010%\u001a\u0012\u0012\u0004\u0012\u00020&\u0012\u0004\u0012\u00020\u00030\u0001j\u0002`'X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b(\u0010\u0006\"\u001e\u0010)\u001a\f\u0012\u0004\u0012\u00020\u00030*j\u0002`+X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b,\u0010-\"*\u0010.\u001a\u0018\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\u00030\u0010j\u0002`/X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b0\u0010\u0016*$\b\u0000\u00101\"\u000e\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u00030\u00012\u000e\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u00030\u0001*$\b\u0000\u00102\"\u000e\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\u00030\u00012\u000e\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\u00030\u0001*B\b\u0000\u00103\"\u001d\u0012\u0013\u0012\u00110\f¢\u0006\f\b \u0012\b\b!\u0012\u0004\b\b(\"\u0012\u0004\u0012\u00020\u00030\u00012\u001d\u0012\u0013\u0012\u00110\f¢\u0006\f\b \u0012\b\b!\u0012\u0004\b\b(\"\u0012\u0004\u0012\u00020\u00030\u0001*$\b\u0000\u00104\"\u000e\u0012\u0004\u0012\u00020\f\u0012\u0004\u0012\u00020\u00030\u00012\u000e\u0012\u0004\u0012\u00020\f\u0012\u0004\u0012\u00020\u00030\u0001*<\b\u0000\u00105\"\u001a\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00120\u0011\u0012\u0004\u0012\u00020\u0013\u0012\u0004\u0012\u00020\u00030\u00102\u001a\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00120\u0011\u0012\u0004\u0012\u00020\u0013\u0012\u0004\u0012\u00020\u00030\u0010*0\b\u0000\u00106\"\u0014\u0012\u0004\u0012\u00020\u0018\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\u00030\u00102\u0014\u0012\u0004\u0012\u00020\u0018\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\u00030\u0010*$\b\u0000\u00107\"\u000e\u0012\u0004\u0012\u00020\u001c\u0012\u0004\u0012\u00020\u00030\u00012\u000e\u0012\u0004\u0012\u00020\u001c\u0012\u0004\u0012\u00020\u00030\u0001*$\b\u0000\u00108\"\u000e\u0012\u0004\u0012\u000209\u0012\u0004\u0012\u00020\u00030\u00012\u000e\u0012\u0004\u0012\u000209\u0012\u0004\u0012\u00020\u00030\u0001*$\b\u0000\u0010:\"\u000e\u0012\u0004\u0012\u00020;\u0012\u0004\u0012\u00020\u00030\u00012\u000e\u0012\u0004\u0012\u00020;\u0012\u0004\u0012\u00020\u00030\u0001*$\b\u0000\u0010<\"\u000e\u0012\u0004\u0012\u00020&\u0012\u0004\u0012\u00020\u00030\u00012\u000e\u0012\u0004\u0012\u00020&\u0012\u0004\u0012\u00020\u00030\u0001*\u0018\b\u0000\u0010=\"\b\u0012\u0004\u0012\u00020\u00030*2\b\u0012\u0004\u0012\u00020\u00030**0\b\u0000\u0010>\"\u0014\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\u00030\u00102\u0014\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\u00030\u0010*<\b\u0000\u0010?\"\u001a\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020A\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\u00030@2\u001a\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020A\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\u00030@¨\u0006B"}, m18d2 = {"NOOP_ON_CAROUSEL_ACTION", "Lkotlin/Function1;", "Lzendesk/ui/android/conversation/carousel/CarouselAction;", "", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnCarouselAction;", "getNOOP_ON_CAROUSEL_ACTION", "()Lkotlin/jvm/functions/Function1;", "NOOP_ON_COPY_TEXT_ACTION", "", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnCopyTextAction;", "getNOOP_ON_COPY_TEXT_ACTION", "NOOP_ON_FILE_ATTACHMENT_CLICKED_ACTION", "Lzendesk/conversationkit/android/model/Message;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFileAttachmentClicked;", "getNOOP_ON_FILE_ATTACHMENT_CLICKED_ACTION", "NOOP_ON_FORM_COMPLETED", "Lkotlin/Function2;", "", "Lzendesk/conversationkit/android/model/Field;", "Lzendesk/messaging/android/internal/model/MessageLogEntry$FormMessageContainer;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFormCompleted;", "getNOOP_ON_FORM_COMPLETED", "()Lkotlin/jvm/functions/Function2;", "NOOP_ON_FORM_DISPLAYED_FIELDS_CHANGED", "Lzendesk/ui/android/conversation/form/DisplayedField;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFormDisplayedFieldsChanged;", "getNOOP_ON_FORM_DISPLAYED_FIELDS_CHANGED", "NOOP_ON_FORM_FOCUS_CHANGED_LISTENER", "", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFormFocusChangedListener;", "getNOOP_ON_FORM_FOCUS_CHANGED_LISTENER", "NOOP_ON_MESSAGE_CONTAINER_CLICKED_LISTENER", "Lkotlin/ParameterName;", "name", "message", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFailedMessageClickedListener;", "getNOOP_ON_MESSAGE_CONTAINER_CLICKED_LISTENER", "NOOP_ON_QUICK_REPLY_OPTION_SELECTED_LISTENER", "Lzendesk/conversationkit/android/model/MessageAction$Reply;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnReplyActionSelected;", "getNOOP_ON_QUICK_REPLY_OPTION_SELECTED_LISTENER", "NOOP_ON_RETRY_CONNECTION_CLICKED_LISTENER", "Lkotlin/Function0;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnRetryConnectionClickedListener;", "getNOOP_ON_RETRY_CONNECTION_CLICKED_LISTENER", "()Lkotlin/jvm/functions/Function0;", "NOOP_ON_SEND_POSTBACK_MESSAGE", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnSendPostbackMessage;", "getNOOP_ON_SEND_POSTBACK_MESSAGE", "OnCarouselAction", "OnCopyTextAction", "OnFailedMessageClickedListener", "OnFileAttachmentClicked", "OnFormCompleted", "OnFormDisplayedFieldsChanged", "OnFormFocusChangedListener", "OnMessageClickedListener", "Lzendesk/messaging/android/internal/model/MessageLogEntry$MessageContainer;", "OnQuickReplyOptionListener", "Lzendesk/ui/android/conversation/quickreply/QuickReplyOption;", "OnReplyActionSelected", "OnRetryConnectionClickedListener", "OnSendPostbackMessage", "OnWebViewMessage", "Lkotlin/Function3;", "Lzendesk/core/ui/android/internal/model/MessageActionSize;", "zendesk.messaging_messaging-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessageLogListenersKt {
    private static final Function1<MessageAction.Reply, Unit> NOOP_ON_QUICK_REPLY_OPTION_SELECTED_LISTENER = new Function1<MessageAction.Reply, Unit>() {
        public final void invoke2(MessageAction.Reply reply) {
            Intrinsics.checkNotNullParameter(reply, "<anonymous parameter 0>");
        }

        @Override
        public Unit invoke(MessageAction.Reply reply) {
            invoke2(reply);
            return Unit.INSTANCE;
        }
    };
    private static final Function1<Message, Unit> NOOP_ON_MESSAGE_CONTAINER_CLICKED_LISTENER = new Function1<Message, Unit>() {
        public final void invoke2(Message message) {
            Intrinsics.checkNotNullParameter(message, "<anonymous parameter 0>");
        }

        @Override
        public Unit invoke(Message message) {
            invoke2(message);
            return Unit.INSTANCE;
        }
    };
    private static final Function2<List<? extends Field>, MessageLogEntry.FormMessageContainer, Unit> NOOP_ON_FORM_COMPLETED = new Function2<List<? extends Field>, MessageLogEntry.FormMessageContainer, Unit>() {
        public final void invoke2(List<? extends Field> list, MessageLogEntry.FormMessageContainer formMessageContainer) {
            Intrinsics.checkNotNullParameter(list, "<anonymous parameter 0>");
            Intrinsics.checkNotNullParameter(formMessageContainer, "<anonymous parameter 1>");
        }

        @Override
        public Unit invoke(List<? extends Field> list, MessageLogEntry.FormMessageContainer formMessageContainer) {
            invoke2(list, formMessageContainer);
            return Unit.INSTANCE;
        }
    };
    private static final Function1<CarouselAction, Unit> NOOP_ON_CAROUSEL_ACTION = new Function1<CarouselAction, Unit>() {
        public final void invoke2(CarouselAction it) {
            Intrinsics.checkNotNullParameter(it, "it");
        }

        @Override
        public Unit invoke(CarouselAction carouselAction) {
            invoke2(carouselAction);
            return Unit.INSTANCE;
        }
    };
    private static final Function2<String, String, Unit> NOOP_ON_SEND_POSTBACK_MESSAGE = new Function2<String, String, Unit>() {
        public final void invoke2(String str, String str2) {
            Intrinsics.checkNotNullParameter(str, "<anonymous parameter 0>");
            Intrinsics.checkNotNullParameter(str2, "<anonymous parameter 1>");
        }

        @Override
        public Unit invoke(String str, String str2) {
            invoke2(str, str2);
            return Unit.INSTANCE;
        }
    };
    private static final Function1<String, Unit> NOOP_ON_COPY_TEXT_ACTION = new Function1<String, Unit>() {
        public final void invoke2(String str) {
            Intrinsics.checkNotNullParameter(str, "<anonymous parameter 0>");
        }

        @Override
        public Unit invoke(String str) {
            invoke2(str);
            return Unit.INSTANCE;
        }
    };
    private static final Function0<Unit> NOOP_ON_RETRY_CONNECTION_CLICKED_LISTENER = new Function0<Unit>() {
        public final void invoke2() {
        }

        @Override
        public Unit invoke() {
            invoke2();
            return Unit.INSTANCE;
        }
    };
    private static final Function1<Boolean, Unit> NOOP_ON_FORM_FOCUS_CHANGED_LISTENER = new Function1<Boolean, Unit>() {
        public final void invoke(boolean z) {
        }

        @Override
        public Unit invoke(Boolean bool) {
            invoke(bool.booleanValue());
            return Unit.INSTANCE;
        }
    };
    private static final Function2<DisplayedField, String, Unit> NOOP_ON_FORM_DISPLAYED_FIELDS_CHANGED = new Function2<DisplayedField, String, Unit>() {
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
    private static final Function1<Message, Unit> NOOP_ON_FILE_ATTACHMENT_CLICKED_ACTION = new Function1<Message, Unit>() {
        public final void invoke2(Message message) {
            Intrinsics.checkNotNullParameter(message, "<anonymous parameter 0>");
        }

        @Override
        public Unit invoke(Message message) {
            invoke2(message);
            return Unit.INSTANCE;
        }
    };

    public static final Function1<MessageAction.Reply, Unit> getNOOP_ON_QUICK_REPLY_OPTION_SELECTED_LISTENER() {
        return NOOP_ON_QUICK_REPLY_OPTION_SELECTED_LISTENER;
    }

    public static final Function1<Message, Unit> getNOOP_ON_MESSAGE_CONTAINER_CLICKED_LISTENER() {
        return NOOP_ON_MESSAGE_CONTAINER_CLICKED_LISTENER;
    }

    public static final Function2<List<? extends Field>, MessageLogEntry.FormMessageContainer, Unit> getNOOP_ON_FORM_COMPLETED() {
        return NOOP_ON_FORM_COMPLETED;
    }

    public static final Function1<CarouselAction, Unit> getNOOP_ON_CAROUSEL_ACTION() {
        return NOOP_ON_CAROUSEL_ACTION;
    }

    public static final Function2<String, String, Unit> getNOOP_ON_SEND_POSTBACK_MESSAGE() {
        return NOOP_ON_SEND_POSTBACK_MESSAGE;
    }

    public static final Function1<String, Unit> getNOOP_ON_COPY_TEXT_ACTION() {
        return NOOP_ON_COPY_TEXT_ACTION;
    }

    public static final Function0<Unit> getNOOP_ON_RETRY_CONNECTION_CLICKED_LISTENER() {
        return NOOP_ON_RETRY_CONNECTION_CLICKED_LISTENER;
    }

    public static final Function1<Boolean, Unit> getNOOP_ON_FORM_FOCUS_CHANGED_LISTENER() {
        return NOOP_ON_FORM_FOCUS_CHANGED_LISTENER;
    }

    public static final Function2<DisplayedField, String, Unit> getNOOP_ON_FORM_DISPLAYED_FIELDS_CHANGED() {
        return NOOP_ON_FORM_DISPLAYED_FIELDS_CHANGED;
    }

    public static final Function1<Message, Unit> getNOOP_ON_FILE_ATTACHMENT_CLICKED_ACTION() {
        return NOOP_ON_FILE_ATTACHMENT_CLICKED_ACTION;
    }
}
