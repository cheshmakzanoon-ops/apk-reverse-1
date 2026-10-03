package zendesk.p026ui.android.conversation.quickreply;

import java.util.List;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u000f\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\b\u0087\b\u0018\u00002\u00020\u0001:\u0001\u001dB+\b\u0000\u0012\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\b\b\u0003\u0010\u0005\u001a\u00020\u0006\u0012\b\b\u0003\u0010\u0007\u001a\u00020\u0006¢\u0006\u0002\u0010\bJ\u0014\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÀ\u0003¢\u0006\u0002\b\u000fJ\u000e\u0010\u0010\u001a\u00020\u0006HÀ\u0003¢\u0006\u0002\b\u0011J\u000e\u0010\u0012\u001a\u00020\u0006HÀ\u0003¢\u0006\u0002\b\u0013J-\u0010\u0014\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\b\u0003\u0010\u0005\u001a\u00020\u00062\b\b\u0003\u0010\u0007\u001a\u00020\u0006HÆ\u0001J\u0013\u0010\u0015\u001a\u00020\u00162\b\u0010\u0017\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0018\u001a\u00020\u0006HÖ\u0001J\u0006\u0010\u0019\u001a\u00020\u001aJ\t\u0010\u001b\u001a\u00020\u001cHÖ\u0001R\u0014\u0010\u0007\u001a\u00020\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u0014\u0010\u0005\u001a\u00020\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\nR\u001a\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\r¨\u0006\u001e"}, m18d2 = {"Lzendesk/ui/android/conversation/quickreply/QuickReplyState;", "", "quickReplyOptions", "", "Lzendesk/ui/android/conversation/quickreply/QuickReplyOption;", "color", "", "backgroundColor", "(Ljava/util/List;II)V", "getBackgroundColor$zendesk_ui_ui_android", "()I", "getColor$zendesk_ui_ui_android", "getQuickReplyOptions$zendesk_ui_ui_android", "()Ljava/util/List;", "component1", "component1$zendesk_ui_ui_android", "component2", "component2$zendesk_ui_ui_android", "component3", "component3$zendesk_ui_ui_android", "copy", "equals", "", "other", "hashCode", "toBuilder", "Lzendesk/ui/android/conversation/quickreply/QuickReplyState$Builder;", "toString", "", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class QuickReplyState {
    public static final int $stable = 8;
    private final int backgroundColor;
    private final int color;
    private final List<QuickReplyOption> quickReplyOptions;

    public QuickReplyState() {
        this(null, 0, 0, 7, null);
    }

    public static QuickReplyState copy$default(QuickReplyState quickReplyState, List list, int i, int i2, int i3, Object obj) {
        if ((i3 & 1) != 0) {
            list = quickReplyState.quickReplyOptions;
        }
        if ((i3 & 2) != 0) {
            i = quickReplyState.color;
        }
        if ((i3 & 4) != 0) {
            i2 = quickReplyState.backgroundColor;
        }
        return quickReplyState.copy(list, i, i2);
    }

    public final List<QuickReplyOption> component1$zendesk_ui_ui_android() {
        return this.quickReplyOptions;
    }

    public final int getColor() {
        return this.color;
    }

    public final int getBackgroundColor() {
        return this.backgroundColor;
    }

    public final QuickReplyState copy(List<QuickReplyOption> quickReplyOptions, int color, int backgroundColor) {
        Intrinsics.checkNotNullParameter(quickReplyOptions, "quickReplyOptions");
        return new QuickReplyState(quickReplyOptions, color, backgroundColor);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof QuickReplyState)) {
            return false;
        }
        QuickReplyState quickReplyState = (QuickReplyState) other;
        return Intrinsics.areEqual(this.quickReplyOptions, quickReplyState.quickReplyOptions) && this.color == quickReplyState.color && this.backgroundColor == quickReplyState.backgroundColor;
    }

    public int hashCode() {
        return (((this.quickReplyOptions.hashCode() * 31) + this.color) * 31) + this.backgroundColor;
    }

    public String toString() {
        return "QuickReplyState(quickReplyOptions=" + this.quickReplyOptions + ", color=" + this.color + ", backgroundColor=" + this.backgroundColor + ')';
    }

    public QuickReplyState(List<QuickReplyOption> quickReplyOptions, int i, int i2) {
        Intrinsics.checkNotNullParameter(quickReplyOptions, "quickReplyOptions");
        this.quickReplyOptions = quickReplyOptions;
        this.color = i;
        this.backgroundColor = i2;
    }

    public QuickReplyState(List list, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this((i3 & 1) != 0 ? CollectionsKt.emptyList() : list, (i3 & 2) != 0 ? 0 : i, (i3 & 4) != 0 ? 0 : i2);
    }

    public final List<QuickReplyOption> getQuickReplyOptions$zendesk_ui_ui_android() {
        return this.quickReplyOptions;
    }

    public final int getColor$zendesk_ui_ui_android() {
        return this.color;
    }

    public final int getBackgroundColor$zendesk_ui_ui_android() {
        return this.backgroundColor;
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0010\u0010\u0006\u001a\u00020\u00002\b\b\u0001\u0010\u0007\u001a\u00020\bJ\u0006\u0010\t\u001a\u00020\u0003J\u0010\u0010\u0007\u001a\u00020\u00002\b\b\u0001\u0010\u0007\u001a\u00020\bJ\u0014\u0010\n\u001a\u00020\u00002\f\u0010\n\u001a\b\u0012\u0004\u0012\u00020\f0\u000bR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\r"}, m18d2 = {"Lzendesk/ui/android/conversation/quickreply/QuickReplyState$Builder;", "", "state", "Lzendesk/ui/android/conversation/quickreply/QuickReplyState;", "(Lzendesk/ui/android/conversation/quickreply/QuickReplyState;)V", "()V", "backgroundColor", "color", "", "build", "quickReplyOptions", "", "Lzendesk/ui/android/conversation/quickreply/QuickReplyOption;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private QuickReplyState state;

        public Builder() {
            this.state = new QuickReplyState(null, 0, 0, 7, null);
        }

        public Builder(QuickReplyState state) {
            this();
            Intrinsics.checkNotNullParameter(state, "state");
            this.state = state;
        }

        public final Builder quickReplyOptions(List<QuickReplyOption> quickReplyOptions) {
            Intrinsics.checkNotNullParameter(quickReplyOptions, "quickReplyOptions");
            this.state = QuickReplyState.copy$default(this.state, quickReplyOptions, 0, 0, 6, null);
            return this;
        }

        public final Builder color(int color) {
            this.state = QuickReplyState.copy$default(this.state, null, color, 0, 5, null);
            return this;
        }

        public final Builder backgroundColor(int color) {
            this.state = QuickReplyState.copy$default(this.state, null, 0, color, 3, null);
            return this;
        }

        public final QuickReplyState getState() {
            return this.state;
        }
    }
}
