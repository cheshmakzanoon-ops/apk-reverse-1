package zendesk.p026ui.android.conversation.typingindicatorcell;

import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\r\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\b\u0087\b\u0018\u00002\u00020\u0001:\u0001\u0018B\u001f\b\u0000\u0012\n\b\u0003\u0010\u0002\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0003\u0010\u0004\u001a\u0004\u0018\u00010\u0003¢\u0006\u0002\u0010\u0005J\u0012\u0010\n\u001a\u0004\u0018\u00010\u0003HÀ\u0003¢\u0006\u0004\b\u000b\u0010\u0007J\u0012\u0010\f\u001a\u0004\u0018\u00010\u0003HÀ\u0003¢\u0006\u0004\b\r\u0010\u0007J&\u0010\u000e\u001a\u00020\u00002\n\b\u0003\u0010\u0002\u001a\u0004\u0018\u00010\u00032\n\b\u0003\u0010\u0004\u001a\u0004\u0018\u00010\u0003HÆ\u0001¢\u0006\u0002\u0010\u000fJ\u0013\u0010\u0010\u001a\u00020\u00112\b\u0010\u0012\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0013\u001a\u00020\u0003HÖ\u0001J\u0006\u0010\u0014\u001a\u00020\u0015J\t\u0010\u0016\u001a\u00020\u0017HÖ\u0001R\u0018\u0010\u0002\u001a\u0004\u0018\u00010\u0003X\u0080\u0004¢\u0006\n\n\u0002\u0010\b\u001a\u0004\b\u0006\u0010\u0007R\u0018\u0010\u0004\u001a\u0004\u0018\u00010\u0003X\u0080\u0004¢\u0006\n\n\u0002\u0010\b\u001a\u0004\b\t\u0010\u0007¨\u0006\u0019"}, m18d2 = {"Lzendesk/ui/android/conversation/typingindicatorcell/TypingIndicatorCellState;", "", "backgroundColor", "", "dotColor", "(Ljava/lang/Integer;Ljava/lang/Integer;)V", "getBackgroundColor$zendesk_ui_ui_android", "()Ljava/lang/Integer;", "Ljava/lang/Integer;", "getDotColor$zendesk_ui_ui_android", "component1", "component1$zendesk_ui_ui_android", "component2", "component2$zendesk_ui_ui_android", "copy", "(Ljava/lang/Integer;Ljava/lang/Integer;)Lzendesk/ui/android/conversation/typingindicatorcell/TypingIndicatorCellState;", "equals", "", "other", "hashCode", "toBuilder", "Lzendesk/ui/android/conversation/typingindicatorcell/TypingIndicatorCellState$Builder;", "toString", "", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class TypingIndicatorCellState {
    public static final int $stable = 0;
    private final Integer backgroundColor;
    private final Integer dotColor;

    public TypingIndicatorCellState() {
        this(null, 0 == true ? 1 : 0, 3, 0 == true ? 1 : 0);
    }

    public static TypingIndicatorCellState copy$default(TypingIndicatorCellState typingIndicatorCellState, Integer num, Integer num2, int i, Object obj) {
        if ((i & 1) != 0) {
            num = typingIndicatorCellState.backgroundColor;
        }
        if ((i & 2) != 0) {
            num2 = typingIndicatorCellState.dotColor;
        }
        return typingIndicatorCellState.copy(num, num2);
    }

    public final Integer getBackgroundColor() {
        return this.backgroundColor;
    }

    public final Integer getDotColor() {
        return this.dotColor;
    }

    public final TypingIndicatorCellState copy(Integer backgroundColor, Integer dotColor) {
        return new TypingIndicatorCellState(backgroundColor, dotColor);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof TypingIndicatorCellState)) {
            return false;
        }
        TypingIndicatorCellState typingIndicatorCellState = (TypingIndicatorCellState) other;
        return Intrinsics.areEqual(this.backgroundColor, typingIndicatorCellState.backgroundColor) && Intrinsics.areEqual(this.dotColor, typingIndicatorCellState.dotColor);
    }

    public int hashCode() {
        Integer num = this.backgroundColor;
        int iHashCode = (num == null ? 0 : num.hashCode()) * 31;
        Integer num2 = this.dotColor;
        return iHashCode + (num2 != null ? num2.hashCode() : 0);
    }

    public String toString() {
        return "TypingIndicatorCellState(backgroundColor=" + this.backgroundColor + ", dotColor=" + this.dotColor + ')';
    }

    public TypingIndicatorCellState(Integer num, Integer num2) {
        this.backgroundColor = num;
        this.dotColor = num2;
    }

    public TypingIndicatorCellState(Integer num, Integer num2, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? null : num, (i & 2) != 0 ? null : num2);
    }

    public final Integer getBackgroundColor$zendesk_ui_ui_android() {
        return this.backgroundColor;
    }

    public final Integer getDotColor$zendesk_ui_ui_android() {
        return this.dotColor;
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\b\n\u0002\b\u0002\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0010\u0010\u0006\u001a\u00020\u00002\b\b\u0001\u0010\u0007\u001a\u00020\bJ\u0006\u0010\t\u001a\u00020\u0003R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\n"}, m18d2 = {"Lzendesk/ui/android/conversation/typingindicatorcell/TypingIndicatorCellState$Builder;", "", "state", "Lzendesk/ui/android/conversation/typingindicatorcell/TypingIndicatorCellState;", "(Lzendesk/ui/android/conversation/typingindicatorcell/TypingIndicatorCellState;)V", "()V", "backgroundColor", "color", "", "build", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private TypingIndicatorCellState state;

        public Builder() {
            this.state = new TypingIndicatorCellState(null, 0 == true ? 1 : 0, 3, 0 == true ? 1 : 0);
        }

        public Builder(TypingIndicatorCellState state) {
            this();
            Intrinsics.checkNotNullParameter(state, "state");
            this.state = state;
        }

        public final Builder backgroundColor(int color) {
            this.state = TypingIndicatorCellState.copy$default(this.state, Integer.valueOf(color), null, 2, null);
            return this;
        }

        public final TypingIndicatorCellState getState() {
            return this.state;
        }
    }
}
