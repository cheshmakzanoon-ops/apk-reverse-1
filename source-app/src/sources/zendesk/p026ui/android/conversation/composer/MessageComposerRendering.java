package zendesk.p026ui.android.conversation.composer;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.logger.Logger;

@Metadata(m17d1 = {"\u0000<\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\b\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0007\u0018\u0000 \u001b2\u00020\u0001:\u0002\u001a\u001bB\u0007\b\u0016¢\u0006\u0002\u0010\u0002B\u000f\b\u0000\u0012\u0006\u0010\u0003\u001a\u00020\u0004¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0019\u001a\u00020\u0004R \u0010\u0006\u001a\u000e\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR \u0010\f\u001a\u000e\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000bR \u0010\u000f\u001a\u000e\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u000bR\u001a\u0010\u0011\u001a\b\u0012\u0004\u0012\u00020\t0\u0012X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014R\u0014\u0010\u0015\u001a\u00020\u0016X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0018¨\u0006\u001c"}, m18d2 = {"Lzendesk/ui/android/conversation/composer/MessageComposerRendering;", "", "()V", "builder", "Lzendesk/ui/android/conversation/composer/MessageComposerRendering$Builder;", "(Lzendesk/ui/android/conversation/composer/MessageComposerRendering$Builder;)V", "onAttachButtonClicked", "Lkotlin/Function1;", "", "", "getOnAttachButtonClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function1;", "onSendButtonClicked", "", "getOnSendButtonClicked$zendesk_ui_ui_android", "onTextChanged", "getOnTextChanged$zendesk_ui_ui_android", "onTyping", "Lkotlin/Function0;", "getOnTyping$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function0;", "state", "Lzendesk/ui/android/conversation/composer/MessageComposerState;", "getState$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/composer/MessageComposerState;", "toBuilder", "Builder", "Companion", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessageComposerRendering {
    public static final int $stable = 0;
    private static final Companion Companion = new Companion(null);
    private static final String LOG_TAG = "MessageComposerRendering";
    private final Function1<Integer, Unit> onAttachButtonClicked;
    private final Function1<String, Unit> onSendButtonClicked;
    private final Function1<String, Unit> onTextChanged;
    private final Function0<Unit> onTyping;
    private final MessageComposerState state;

    public MessageComposerRendering(Builder builder) {
        Intrinsics.checkNotNullParameter(builder, "builder");
        this.onSendButtonClicked = builder.getOnSendButtonClicked$zendesk_ui_ui_android();
        this.onAttachButtonClicked = builder.getOnAttachButtonClicked$zendesk_ui_ui_android();
        this.onTyping = builder.getOnTyping$zendesk_ui_ui_android();
        this.onTextChanged = builder.getOnTextChanged$zendesk_ui_ui_android();
        this.state = builder.getState();
    }

    public final Function1<String, Unit> getOnSendButtonClicked$zendesk_ui_ui_android() {
        return this.onSendButtonClicked;
    }

    public final Function1<Integer, Unit> getOnAttachButtonClicked$zendesk_ui_ui_android() {
        return this.onAttachButtonClicked;
    }

    public final Function0<Unit> getOnTyping$zendesk_ui_ui_android() {
        return this.onTyping;
    }

    public final Function1<String, Unit> getOnTextChanged$zendesk_ui_ui_android() {
        return this.onTextChanged;
    }

    public final MessageComposerState getState() {
        return this.state;
    }

    public MessageComposerRendering() {
        this(new Builder());
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000:\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0010\b\n\u0002\u0010\u0002\n\u0002\b\u0005\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\b\b\u0007\u0018\u00002\u00020\u0001B\u0011\b\u0010\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010!\u001a\u00020\u0003J\u001a\u0010\u0006\u001a\u00020\u00002\u0012\u0010\u0006\u001a\u000e\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0007J\u001a\u0010\u000e\u001a\u00020\u00002\u0012\u0010\u000e\u001a\u000e\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\t0\u0007J\u001a\u0010\u0012\u001a\u00020\u00002\u0012\u0010\"\u001a\u000e\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\t0\u0007J\u0014\u0010\u0015\u001a\u00020\u00002\f\u0010\u0015\u001a\b\u0012\u0004\u0012\u00020\t0\u0016J\u001a\u0010\u001b\u001a\u00020\u00002\u0012\u0010#\u001a\u000e\u0012\u0004\u0012\u00020\u001c\u0012\u0004\u0012\u00020\u001c0\u0007R&\u0010\u0006\u001a\u000e\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\n\u0010\u000b\"\u0004\b\f\u0010\rR&\u0010\u000e\u001a\u000e\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0010\u0010\u000b\"\u0004\b\u0011\u0010\rR&\u0010\u0012\u001a\u000e\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0013\u0010\u000b\"\u0004\b\u0014\u0010\rR \u0010\u0015\u001a\b\u0012\u0004\u0012\u00020\t0\u0016X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0017\u0010\u0018\"\u0004\b\u0019\u0010\u001aR\u001a\u0010\u001b\u001a\u00020\u001cX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001d\u0010\u001e\"\u0004\b\u001f\u0010 ¨\u0006$"}, m18d2 = {"Lzendesk/ui/android/conversation/composer/MessageComposerRendering$Builder;", "", "rendering", "Lzendesk/ui/android/conversation/composer/MessageComposerRendering;", "(Lzendesk/ui/android/conversation/composer/MessageComposerRendering;)V", "()V", "onAttachButtonClicked", "Lkotlin/Function1;", "", "", "getOnAttachButtonClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function1;", "setOnAttachButtonClicked$zendesk_ui_ui_android", "(Lkotlin/jvm/functions/Function1;)V", "onSendButtonClicked", "", "getOnSendButtonClicked$zendesk_ui_ui_android", "setOnSendButtonClicked$zendesk_ui_ui_android", "onTextChanged", "getOnTextChanged$zendesk_ui_ui_android", "setOnTextChanged$zendesk_ui_ui_android", "onTyping", "Lkotlin/Function0;", "getOnTyping$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function0;", "setOnTyping$zendesk_ui_ui_android", "(Lkotlin/jvm/functions/Function0;)V", "state", "Lzendesk/ui/android/conversation/composer/MessageComposerState;", "getState$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/composer/MessageComposerState;", "setState$zendesk_ui_ui_android", "(Lzendesk/ui/android/conversation/composer/MessageComposerState;)V", "build", "onTextChanges", "stateUpdate", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private Function1<? super Integer, Unit> onAttachButtonClicked;
        private Function1<? super String, Unit> onSendButtonClicked;
        private Function1<? super String, Unit> onTextChanged;
        private Function0<Unit> onTyping;
        private MessageComposerState state;

        public Builder() {
            this.onSendButtonClicked = new Function1<String, Unit>() {
                @Override
                public Unit invoke(String str) {
                    invoke2(str);
                    return Unit.INSTANCE;
                }

                public final void invoke2(String it) {
                    Intrinsics.checkNotNullParameter(it, "it");
                    Logger.m225w("MessageComposerRendering", "MessageComposerRendering#onSendButtonClicked == null", new Object[0]);
                }
            };
            this.onAttachButtonClicked = new Function1<Integer, Unit>() {
                @Override
                public Unit invoke(Integer num) {
                    invoke(num.intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(int i) {
                    Logger.m225w("MessageComposerRendering", "MessageComposerRendering#onAttachButtonClicked == null", new Object[0]);
                }
            };
            this.onTyping = new Function0<Unit>() {
                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }

                public final void invoke2() {
                    Logger.m225w("MessageComposerRendering", "MessageComposerRendering#onTyping == null", new Object[0]);
                }
            };
            this.onTextChanged = new Function1<String, Unit>() {
                @Override
                public Unit invoke(String str) {
                    invoke2(str);
                    return Unit.INSTANCE;
                }

                public final void invoke2(String it) {
                    Intrinsics.checkNotNullParameter(it, "it");
                    Logger.m225w("MessageComposerRendering", "MessageComposerRendering#onTextChanged == null", new Object[0]);
                }
            };
            this.state = new MessageComposerState(false, false, false, false, 0, 0, 0, 0, 0, 0, null, 2047, null);
        }

        public final Function1<String, Unit> getOnSendButtonClicked$zendesk_ui_ui_android() {
            return this.onSendButtonClicked;
        }

        public final void setOnSendButtonClicked$zendesk_ui_ui_android(Function1<? super String, Unit> function1) {
            Intrinsics.checkNotNullParameter(function1, "<set-?>");
            this.onSendButtonClicked = function1;
        }

        public final Function1<Integer, Unit> getOnAttachButtonClicked$zendesk_ui_ui_android() {
            return this.onAttachButtonClicked;
        }

        public final void setOnAttachButtonClicked$zendesk_ui_ui_android(Function1<? super Integer, Unit> function1) {
            Intrinsics.checkNotNullParameter(function1, "<set-?>");
            this.onAttachButtonClicked = function1;
        }

        public final Function0<Unit> getOnTyping$zendesk_ui_ui_android() {
            return this.onTyping;
        }

        public final void setOnTyping$zendesk_ui_ui_android(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onTyping = function0;
        }

        public final Function1<String, Unit> getOnTextChanged$zendesk_ui_ui_android() {
            return this.onTextChanged;
        }

        public final void setOnTextChanged$zendesk_ui_ui_android(Function1<? super String, Unit> function1) {
            Intrinsics.checkNotNullParameter(function1, "<set-?>");
            this.onTextChanged = function1;
        }

        public final MessageComposerState getState() {
            return this.state;
        }

        public final void setState$zendesk_ui_ui_android(MessageComposerState messageComposerState) {
            Intrinsics.checkNotNullParameter(messageComposerState, "<set-?>");
            this.state = messageComposerState;
        }

        public Builder(MessageComposerRendering rendering) {
            this();
            Intrinsics.checkNotNullParameter(rendering, "rendering");
            this.onSendButtonClicked = rendering.getOnSendButtonClicked$zendesk_ui_ui_android();
            this.onTyping = rendering.getOnTyping$zendesk_ui_ui_android();
            this.onTextChanged = rendering.getOnTextChanged$zendesk_ui_ui_android();
            this.state = rendering.getState();
        }

        public Builder(MessageComposerRendering messageComposerRendering, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this((i & 1) != 0 ? new MessageComposerRendering() : messageComposerRendering);
        }

        public final Builder onSendButtonClicked(Function1<? super String, Unit> onSendButtonClicked) {
            Intrinsics.checkNotNullParameter(onSendButtonClicked, "onSendButtonClicked");
            this.onSendButtonClicked = onSendButtonClicked;
            return this;
        }

        public final Builder onAttachButtonClicked(Function1<? super Integer, Unit> onAttachButtonClicked) {
            Intrinsics.checkNotNullParameter(onAttachButtonClicked, "onAttachButtonClicked");
            this.onAttachButtonClicked = onAttachButtonClicked;
            return this;
        }

        public final Builder onTyping(Function0<Unit> onTyping) {
            Intrinsics.checkNotNullParameter(onTyping, "onTyping");
            this.onTyping = onTyping;
            return this;
        }

        public final Builder onTextChanged(Function1<? super String, Unit> onTextChanges) {
            Intrinsics.checkNotNullParameter(onTextChanges, "onTextChanges");
            this.onTextChanged = onTextChanges;
            return this;
        }

        public final Builder state(Function1<? super MessageComposerState, MessageComposerState> stateUpdate) {
            Intrinsics.checkNotNullParameter(stateUpdate, "stateUpdate");
            this.state = stateUpdate.invoke(this.state);
            return this;
        }

        public final MessageComposerRendering build() {
            return new MessageComposerRendering(this);
        }
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u0005"}, m18d2 = {"Lzendesk/ui/android/conversation/composer/MessageComposerRendering$Companion;", "", "()V", "LOG_TAG", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
