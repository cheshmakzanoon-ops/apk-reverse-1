package zendesk.p026ui.android.internal;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0010\u000b\n\u0002\b\u0004\b\u0087\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\t\u0010\u000b\u001a\u00020\u0003HÆ\u0003J\t\u0010\f\u001a\u00020\u0005HÆ\u0003J\u001d\u0010\r\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u000e\u001a\u00020\u000f2\b\u0010\u0010\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0011\u001a\u00020\u0003HÖ\u0001J\t\u0010\u0012\u001a\u00020\u0005HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\n¨\u0006\u0013"}, m18d2 = {"Lzendesk/ui/android/internal/ContextualMenuOption;", "", "optionId", "", "optionTitle", "", "(ILjava/lang/String;)V", "getOptionId", "()I", "getOptionTitle", "()Ljava/lang/String;", "component1", "component2", "copy", "equals", "", "other", "hashCode", "toString", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ContextualMenuOption {
    public static final int $stable = 0;
    private final int optionId;
    private final String optionTitle;

    public static ContextualMenuOption copy$default(ContextualMenuOption contextualMenuOption, int i, String str, int i2, Object obj) {
        if ((i2 & 1) != 0) {
            i = contextualMenuOption.optionId;
        }
        if ((i2 & 2) != 0) {
            str = contextualMenuOption.optionTitle;
        }
        return contextualMenuOption.copy(i, str);
    }

    public final int getOptionId() {
        return this.optionId;
    }

    public final String getOptionTitle() {
        return this.optionTitle;
    }

    public final ContextualMenuOption copy(int optionId, String optionTitle) {
        Intrinsics.checkNotNullParameter(optionTitle, "optionTitle");
        return new ContextualMenuOption(optionId, optionTitle);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ContextualMenuOption)) {
            return false;
        }
        ContextualMenuOption contextualMenuOption = (ContextualMenuOption) other;
        return this.optionId == contextualMenuOption.optionId && Intrinsics.areEqual(this.optionTitle, contextualMenuOption.optionTitle);
    }

    public int hashCode() {
        return (this.optionId * 31) + this.optionTitle.hashCode();
    }

    public String toString() {
        return "ContextualMenuOption(optionId=" + this.optionId + ", optionTitle=" + this.optionTitle + ')';
    }

    public ContextualMenuOption(int i, String optionTitle) {
        Intrinsics.checkNotNullParameter(optionTitle, "optionTitle");
        this.optionId = i;
        this.optionTitle = optionTitle;
    }

    public final int getOptionId() {
        return this.optionId;
    }

    public final String getOptionTitle() {
        return this.optionTitle;
    }
}
