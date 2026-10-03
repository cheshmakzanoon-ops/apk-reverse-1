package zendesk.p026ui.android.conversation.textcell;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.p017ui.android.internal.model.MessageActionSize;
import zendesk.logger.Logger;

@Metadata(m17d1 = {"\u0000@\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0007\u0018\u0000 !2\u00020\u0001:\u0002 !B\u0007\b\u0016¢\u0006\u0002\u0010\u0002B\u000f\b\u0000\u0012\u0006\u0010\u0003\u001a\u00020\u0004¢\u0006\u0002\u0010\u0005J\u0006\u0010\u001f\u001a\u00020\u0004R&\u0010\u0006\u001a\u0014\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR \u0010\f\u001a\u000e\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\rX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\"\u0010\u0010\u001a\u0010\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t\u0018\u00010\rX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u000fR \u0010\u0012\u001a\u000e\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\rX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u000fR&\u0010\u0014\u001a\u0014\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u000bR,\u0010\u0016\u001a\u001a\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\u0018\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0017X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u001aR\u0014\u0010\u001b\u001a\u00020\u001cX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001d\u0010\u001e¨\u0006\""}, m18d2 = {"Lzendesk/ui/android/conversation/textcell/TextCellRendering;", "", "()V", "builder", "Lzendesk/ui/android/conversation/textcell/TextCellRendering$Builder;", "(Lzendesk/ui/android/conversation/textcell/TextCellRendering$Builder;)V", "onActionButtonClicked", "Lkotlin/Function2;", "", "", "getOnActionButtonClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function2;", "onCellClicked", "Lkotlin/Function1;", "getOnCellClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function1;", "onCellTextClicked", "getOnCellTextClicked$zendesk_ui_ui_android", "onCopyTextMenuItemClicked", "getOnCopyTextMenuItemClicked$zendesk_ui_ui_android", "onPostbackButtonClicked", "getOnPostbackButtonClicked$zendesk_ui_ui_android", "onWebViewActionButtonClicked", "Lkotlin/Function3;", "Lzendesk/core/ui/android/internal/model/MessageActionSize;", "getOnWebViewActionButtonClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function3;", "state", "Lzendesk/ui/android/conversation/textcell/TextCellState;", "getState$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/textcell/TextCellState;", "toBuilder", "Builder", "Companion", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class TextCellRendering {
    private static final String LOG_TAG = "TextCellRendering";
    private final Function2<String, String, Unit> onActionButtonClicked;
    private final Function1<String, Unit> onCellClicked;
    private final Function1<String, Unit> onCellTextClicked;
    private final Function1<String, Unit> onCopyTextMenuItemClicked;
    private final Function2<String, String, Unit> onPostbackButtonClicked;
    private final Function3<String, MessageActionSize, String, Unit> onWebViewActionButtonClicked;
    private final TextCellState state;
    private static final Companion Companion = new Companion(null);
    public static final int $stable = 8;

    public TextCellRendering(Builder builder) {
        Intrinsics.checkNotNullParameter(builder, "builder");
        this.onCellClicked = builder.getOnCellClicked$zendesk_ui_ui_android();
        this.onCellTextClicked = builder.getOnCellTextClicked$zendesk_ui_ui_android();
        this.onActionButtonClicked = builder.getOnActionButtonClicked$zendesk_ui_ui_android();
        this.onPostbackButtonClicked = builder.getOnPostbackButtonClicked$zendesk_ui_ui_android();
        this.onCopyTextMenuItemClicked = builder.getOnCopyTextMenuItemClicked$zendesk_ui_ui_android();
        this.onWebViewActionButtonClicked = builder.getOnWebViewActionButtonClicked$zendesk_ui_ui_android();
        this.state = builder.getState();
    }

    public final Function1<String, Unit> getOnCellClicked$zendesk_ui_ui_android() {
        return this.onCellClicked;
    }

    public final Function1<String, Unit> getOnCellTextClicked$zendesk_ui_ui_android() {
        return this.onCellTextClicked;
    }

    public final Function2<String, String, Unit> getOnActionButtonClicked$zendesk_ui_ui_android() {
        return this.onActionButtonClicked;
    }

    public final Function2<String, String, Unit> getOnPostbackButtonClicked$zendesk_ui_ui_android() {
        return this.onPostbackButtonClicked;
    }

    public final Function1<String, Unit> getOnCopyTextMenuItemClicked$zendesk_ui_ui_android() {
        return this.onCopyTextMenuItemClicked;
    }

    public final Function3<String, MessageActionSize, String, Unit> getOnWebViewActionButtonClicked$zendesk_ui_ui_android() {
        return this.onWebViewActionButtonClicked;
    }

    public final TextCellState getState() {
        return this.state;
    }

    public TextCellRendering() {
        this(new Builder());
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000>\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\u0010\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u000e\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\b\b\u0007\u0018\u00002\u00020\u0001B\u0011\b\u0010\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010*\u001a\u00020\u0003J \u0010\u0006\u001a\u00020\u00002\u0018\u0010\u0006\u001a\u0014\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0007J\u001a\u0010\u000e\u001a\u00020\u00002\u0012\u0010\u000e\u001a\u000e\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u000fJ\u001a\u0010\u0014\u001a\u00020\u00002\u0012\u0010\u0014\u001a\u000e\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u000fJ\u001a\u0010\u0017\u001a\u00020\u00002\u0012\u0010\u0017\u001a\u000e\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u000fJ \u0010\u001a\u001a\u00020\u00002\u0018\u0010\u001a\u001a\u0014\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0007J&\u0010\u001d\u001a\u00020\u00002\u001e\u0010+\u001a\u001a\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\u001f\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u001eJ\u001a\u0010$\u001a\u00020\u00002\u0012\u0010,\u001a\u000e\u0012\u0004\u0012\u00020%\u0012\u0004\u0012\u00020%0\u000fR,\u0010\u0006\u001a\u0014\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\n\u0010\u000b\"\u0004\b\f\u0010\rR&\u0010\u000e\u001a\u000e\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u000fX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0010\u0010\u0011\"\u0004\b\u0012\u0010\u0013R(\u0010\u0014\u001a\u0010\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t\u0018\u00010\u000fX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0015\u0010\u0011\"\u0004\b\u0016\u0010\u0013R&\u0010\u0017\u001a\u000e\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u000fX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0018\u0010\u0011\"\u0004\b\u0019\u0010\u0013R,\u0010\u001a\u001a\u0014\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001b\u0010\u000b\"\u0004\b\u001c\u0010\rR2\u0010\u001d\u001a\u001a\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\u001f\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t0\u001eX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b \u0010!\"\u0004\b\"\u0010#R\u001a\u0010$\u001a\u00020%X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b&\u0010'\"\u0004\b(\u0010)¨\u0006-"}, m18d2 = {"Lzendesk/ui/android/conversation/textcell/TextCellRendering$Builder;", "", "rendering", "Lzendesk/ui/android/conversation/textcell/TextCellRendering;", "(Lzendesk/ui/android/conversation/textcell/TextCellRendering;)V", "()V", "onActionButtonClicked", "Lkotlin/Function2;", "", "", "getOnActionButtonClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function2;", "setOnActionButtonClicked$zendesk_ui_ui_android", "(Lkotlin/jvm/functions/Function2;)V", "onCellClicked", "Lkotlin/Function1;", "getOnCellClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function1;", "setOnCellClicked$zendesk_ui_ui_android", "(Lkotlin/jvm/functions/Function1;)V", "onCellTextClicked", "getOnCellTextClicked$zendesk_ui_ui_android", "setOnCellTextClicked$zendesk_ui_ui_android", "onCopyTextMenuItemClicked", "getOnCopyTextMenuItemClicked$zendesk_ui_ui_android", "setOnCopyTextMenuItemClicked$zendesk_ui_ui_android", "onPostbackButtonClicked", "getOnPostbackButtonClicked$zendesk_ui_ui_android", "setOnPostbackButtonClicked$zendesk_ui_ui_android", "onWebViewActionButtonClicked", "Lkotlin/Function3;", "Lzendesk/core/ui/android/internal/model/MessageActionSize;", "getOnWebViewActionButtonClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function3;", "setOnWebViewActionButtonClicked$zendesk_ui_ui_android", "(Lkotlin/jvm/functions/Function3;)V", "state", "Lzendesk/ui/android/conversation/textcell/TextCellState;", "getState$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/textcell/TextCellState;", "setState$zendesk_ui_ui_android", "(Lzendesk/ui/android/conversation/textcell/TextCellState;)V", "build", "onWebViewMenuItemClicked", "stateUpdate", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private Function2<? super String, ? super String, Unit> onActionButtonClicked;
        private Function1<? super String, Unit> onCellClicked;
        private Function1<? super String, Unit> onCellTextClicked;
        private Function1<? super String, Unit> onCopyTextMenuItemClicked;
        private Function2<? super String, ? super String, Unit> onPostbackButtonClicked;
        private Function3<? super String, ? super MessageActionSize, ? super String, Unit> onWebViewActionButtonClicked;
        private TextCellState state;

        public Builder() {
            this.onCellClicked = new Function1<String, Unit>() {
                @Override
                public Unit invoke(String str) {
                    invoke2(str);
                    return Unit.INSTANCE;
                }

                public final void invoke2(String it) {
                    Intrinsics.checkNotNullParameter(it, "it");
                    Logger.m225w("TextCellRendering", "TextCellRendering#onCellClicked == null", new Object[0]);
                }
            };
            this.onActionButtonClicked = new Function2<String, String, Unit>() {
                @Override
                public Unit invoke(String str, String str2) {
                    invoke2(str, str2);
                    return Unit.INSTANCE;
                }

                public final void invoke2(String str, String str2) {
                    Intrinsics.checkNotNullParameter(str, "<anonymous parameter 0>");
                    Intrinsics.checkNotNullParameter(str2, "<anonymous parameter 1>");
                    Logger.m225w("TextCellRendering", "TextCellRendering#onActionButtonClicked == null", new Object[0]);
                }
            };
            this.onPostbackButtonClicked = new Function2<String, String, Unit>() {
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
            this.onCopyTextMenuItemClicked = new Function1<String, Unit>() {
                @Override
                public Unit invoke(String str) {
                    invoke2(str);
                    return Unit.INSTANCE;
                }

                public final void invoke2(String it) {
                    Intrinsics.checkNotNullParameter(it, "it");
                    Logger.m225w("TextCellRendering", "TextCellRendering#onCopyTextMenuItemClicked == null", new Object[0]);
                }
            };
            this.onWebViewActionButtonClicked = new Function3<String, MessageActionSize, String, Unit>() {
                @Override
                public Unit invoke(String str, MessageActionSize messageActionSize, String str2) {
                    invoke2(str, messageActionSize, str2);
                    return Unit.INSTANCE;
                }

                public final void invoke2(String str, MessageActionSize messageActionSize, String str2) {
                    Intrinsics.checkNotNullParameter(str, "<anonymous parameter 0>");
                    Intrinsics.checkNotNullParameter(messageActionSize, "<anonymous parameter 1>");
                    Intrinsics.checkNotNullParameter(str2, "<anonymous parameter 2>");
                    Logger.m225w("TextCellRendering", "TextCellRendering#onWebViewActionButtonClicked == null", new Object[0]);
                }
            };
            this.state = new TextCellState(null, null, null, false, null, null, null, null, null, null, null, null, null, null, 16383, null);
        }

        public final Function1<String, Unit> getOnCellClicked$zendesk_ui_ui_android() {
            return this.onCellClicked;
        }

        public final void setOnCellClicked$zendesk_ui_ui_android(Function1<? super String, Unit> function1) {
            Intrinsics.checkNotNullParameter(function1, "<set-?>");
            this.onCellClicked = function1;
        }

        public final Function1<String, Unit> getOnCellTextClicked$zendesk_ui_ui_android() {
            return this.onCellTextClicked;
        }

        public final void setOnCellTextClicked$zendesk_ui_ui_android(Function1<? super String, Unit> function1) {
            this.onCellTextClicked = function1;
        }

        public final Function2<String, String, Unit> getOnActionButtonClicked$zendesk_ui_ui_android() {
            return this.onActionButtonClicked;
        }

        public final void setOnActionButtonClicked$zendesk_ui_ui_android(Function2<? super String, ? super String, Unit> function2) {
            Intrinsics.checkNotNullParameter(function2, "<set-?>");
            this.onActionButtonClicked = function2;
        }

        public final Function2<String, String, Unit> getOnPostbackButtonClicked$zendesk_ui_ui_android() {
            return this.onPostbackButtonClicked;
        }

        public final void setOnPostbackButtonClicked$zendesk_ui_ui_android(Function2<? super String, ? super String, Unit> function2) {
            Intrinsics.checkNotNullParameter(function2, "<set-?>");
            this.onPostbackButtonClicked = function2;
        }

        public final Function1<String, Unit> getOnCopyTextMenuItemClicked$zendesk_ui_ui_android() {
            return this.onCopyTextMenuItemClicked;
        }

        public final void setOnCopyTextMenuItemClicked$zendesk_ui_ui_android(Function1<? super String, Unit> function1) {
            Intrinsics.checkNotNullParameter(function1, "<set-?>");
            this.onCopyTextMenuItemClicked = function1;
        }

        public final Function3<String, MessageActionSize, String, Unit> getOnWebViewActionButtonClicked$zendesk_ui_ui_android() {
            return this.onWebViewActionButtonClicked;
        }

        public final void setOnWebViewActionButtonClicked$zendesk_ui_ui_android(Function3<? super String, ? super MessageActionSize, ? super String, Unit> function3) {
            Intrinsics.checkNotNullParameter(function3, "<set-?>");
            this.onWebViewActionButtonClicked = function3;
        }

        public final TextCellState getState() {
            return this.state;
        }

        public final void setState$zendesk_ui_ui_android(TextCellState textCellState) {
            Intrinsics.checkNotNullParameter(textCellState, "<set-?>");
            this.state = textCellState;
        }

        public Builder(TextCellRendering rendering) {
            this();
            Intrinsics.checkNotNullParameter(rendering, "rendering");
            this.onCellClicked = rendering.getOnCellClicked$zendesk_ui_ui_android();
            this.state = rendering.getState();
        }

        public Builder(TextCellRendering textCellRendering, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this((i & 1) != 0 ? new TextCellRendering() : textCellRendering);
        }

        public final Builder onCellClicked(Function1<? super String, Unit> onCellClicked) {
            Intrinsics.checkNotNullParameter(onCellClicked, "onCellClicked");
            this.onCellClicked = onCellClicked;
            return this;
        }

        public final Builder onCellTextClicked(Function1<? super String, Unit> onCellTextClicked) {
            Intrinsics.checkNotNullParameter(onCellTextClicked, "onCellTextClicked");
            this.onCellTextClicked = onCellTextClicked;
            return this;
        }

        public final Builder onActionButtonClicked(Function2<? super String, ? super String, Unit> onActionButtonClicked) {
            Intrinsics.checkNotNullParameter(onActionButtonClicked, "onActionButtonClicked");
            this.onActionButtonClicked = onActionButtonClicked;
            return this;
        }

        public final Builder onPostbackButtonClicked(Function2<? super String, ? super String, Unit> onPostbackButtonClicked) {
            Intrinsics.checkNotNullParameter(onPostbackButtonClicked, "onPostbackButtonClicked");
            this.onPostbackButtonClicked = onPostbackButtonClicked;
            return this;
        }

        public final Builder onCopyTextMenuItemClicked(Function1<? super String, Unit> onCopyTextMenuItemClicked) {
            Intrinsics.checkNotNullParameter(onCopyTextMenuItemClicked, "onCopyTextMenuItemClicked");
            this.onCopyTextMenuItemClicked = onCopyTextMenuItemClicked;
            return this;
        }

        public final Builder onWebViewActionButtonClicked(Function3<? super String, ? super MessageActionSize, ? super String, Unit> onWebViewMenuItemClicked) {
            Intrinsics.checkNotNullParameter(onWebViewMenuItemClicked, "onWebViewMenuItemClicked");
            this.onWebViewActionButtonClicked = onWebViewMenuItemClicked;
            return this;
        }

        public final Builder state(Function1<? super TextCellState, TextCellState> stateUpdate) {
            Intrinsics.checkNotNullParameter(stateUpdate, "stateUpdate");
            this.state = stateUpdate.invoke(this.state);
            return this;
        }

        public final TextCellRendering build() {
            return new TextCellRendering(this);
        }
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u0005"}, m18d2 = {"Lzendesk/ui/android/conversation/textcell/TextCellRendering$Companion;", "", "()V", "LOG_TAG", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
