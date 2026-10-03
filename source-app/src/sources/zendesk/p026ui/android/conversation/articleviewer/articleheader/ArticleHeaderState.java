package zendesk.p026ui.android.conversation.articleviewer.articleheader;

import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.enums.EnumEntries;
import kotlin.enums.EnumEntriesKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0010\u000b\n\u0002\b\u001b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\b\u0087\b\u0018\u00002\u00020\u0001:\u0002'(BC\b\u0000\u0012\b\b\u0003\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0003\u0010\u0004\u001a\u00020\u0003\u0012\b\b\u0003\u0010\u0005\u001a\u00020\u0003\u0012\b\b\u0003\u0010\u0006\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0007\u001a\u00020\b\u0012\b\b\u0002\u0010\t\u001a\u00020\b¢\u0006\u0002\u0010\nJ\u000e\u0010\u0013\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\u0014J\u000e\u0010\u0015\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\u0016J\u000e\u0010\u0017\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\u0018J\u000e\u0010\u0019\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\u001aJ\u000e\u0010\u001b\u001a\u00020\bHÀ\u0003¢\u0006\u0002\b\u001cJ\u000e\u0010\u001d\u001a\u00020\bHÀ\u0003¢\u0006\u0002\b\u001eJE\u0010\u001f\u001a\u00020\u00002\b\b\u0003\u0010\u0002\u001a\u00020\u00032\b\b\u0003\u0010\u0004\u001a\u00020\u00032\b\b\u0003\u0010\u0005\u001a\u00020\u00032\b\b\u0003\u0010\u0006\u001a\u00020\u00032\b\b\u0002\u0010\u0007\u001a\u00020\b2\b\b\u0002\u0010\t\u001a\u00020\bHÆ\u0001J\u0013\u0010 \u001a\u00020\b2\b\u0010!\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\"\u001a\u00020\u0003HÖ\u0001J\u0006\u0010#\u001a\u00020$J\t\u0010%\u001a\u00020&HÖ\u0001R\u0014\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0014\u0010\u0004\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\fR\u0014\u0010\u0006\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\fR\u0014\u0010\u0005\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\fR\u0014\u0010\t\u001a\u00020\bX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0011R\u0014\u0010\u0007\u001a\u00020\bX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0011¨\u0006)"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/articleheader/ArticleHeaderState;", "", "backgroundColor", "", "buttonBackgroundColor", "iconColor", "focusedBorderColor", "showShareButton", "", "showBackButton", "(IIIIZZ)V", "getBackgroundColor$zendesk_ui_ui_android", "()I", "getButtonBackgroundColor$zendesk_ui_ui_android", "getFocusedBorderColor$zendesk_ui_ui_android", "getIconColor$zendesk_ui_ui_android", "getShowBackButton$zendesk_ui_ui_android", "()Z", "getShowShareButton$zendesk_ui_ui_android", "component1", "component1$zendesk_ui_ui_android", "component2", "component2$zendesk_ui_ui_android", "component3", "component3$zendesk_ui_ui_android", "component4", "component4$zendesk_ui_ui_android", "component5", "component5$zendesk_ui_ui_android", "component6", "component6$zendesk_ui_ui_android", "copy", "equals", "other", "hashCode", "toBuilder", "Lzendesk/ui/android/conversation/articleviewer/articleheader/ArticleHeaderState$Builder;", "toString", "", "Builder", "ButtonName", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ArticleHeaderState {
    public static final int $stable = 0;
    private final int backgroundColor;
    private final int buttonBackgroundColor;
    private final int focusedBorderColor;
    private final int iconColor;
    private final boolean showBackButton;
    private final boolean showShareButton;

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\b\u0005\b\u0086\u0081\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00000\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002j\u0002\b\u0003j\u0002\b\u0004j\u0002\b\u0005¨\u0006\u0006"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/articleheader/ArticleHeaderState$ButtonName;", "", "(Ljava/lang/String;I)V", "BACK", "SHARE", "CLOSE", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public enum ButtonName {
        BACK,
        SHARE,
        CLOSE;

        private static final EnumEntries $ENTRIES = EnumEntriesKt.enumEntries(values());

        public static EnumEntries<ButtonName> getEntries() {
            return $ENTRIES;
        }
    }

    public ArticleHeaderState() {
        this(0, 0, 0, 0, false, false, 63, null);
    }

    public static ArticleHeaderState copy$default(ArticleHeaderState articleHeaderState, int i, int i2, int i3, int i4, boolean z, boolean z2, int i5, Object obj) {
        if ((i5 & 1) != 0) {
            i = articleHeaderState.backgroundColor;
        }
        if ((i5 & 2) != 0) {
            i2 = articleHeaderState.buttonBackgroundColor;
        }
        int i6 = i2;
        if ((i5 & 4) != 0) {
            i3 = articleHeaderState.iconColor;
        }
        int i7 = i3;
        if ((i5 & 8) != 0) {
            i4 = articleHeaderState.focusedBorderColor;
        }
        int i8 = i4;
        if ((i5 & 16) != 0) {
            z = articleHeaderState.showShareButton;
        }
        boolean z3 = z;
        if ((i5 & 32) != 0) {
            z2 = articleHeaderState.showBackButton;
        }
        return articleHeaderState.copy(i, i6, i7, i8, z3, z2);
    }

    public final int getBackgroundColor() {
        return this.backgroundColor;
    }

    public final int getButtonBackgroundColor() {
        return this.buttonBackgroundColor;
    }

    public final int getIconColor() {
        return this.iconColor;
    }

    public final int getFocusedBorderColor() {
        return this.focusedBorderColor;
    }

    public final boolean getShowShareButton() {
        return this.showShareButton;
    }

    public final boolean getShowBackButton() {
        return this.showBackButton;
    }

    public final ArticleHeaderState copy(int backgroundColor, int buttonBackgroundColor, int iconColor, int focusedBorderColor, boolean showShareButton, boolean showBackButton) {
        return new ArticleHeaderState(backgroundColor, buttonBackgroundColor, iconColor, focusedBorderColor, showShareButton, showBackButton);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ArticleHeaderState)) {
            return false;
        }
        ArticleHeaderState articleHeaderState = (ArticleHeaderState) other;
        return this.backgroundColor == articleHeaderState.backgroundColor && this.buttonBackgroundColor == articleHeaderState.buttonBackgroundColor && this.iconColor == articleHeaderState.iconColor && this.focusedBorderColor == articleHeaderState.focusedBorderColor && this.showShareButton == articleHeaderState.showShareButton && this.showBackButton == articleHeaderState.showBackButton;
    }

    public int hashCode() {
        return (((((((((this.backgroundColor * 31) + this.buttonBackgroundColor) * 31) + this.iconColor) * 31) + this.focusedBorderColor) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.showShareButton)) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.showBackButton);
    }

    public String toString() {
        return "ArticleHeaderState(backgroundColor=" + this.backgroundColor + ", buttonBackgroundColor=" + this.buttonBackgroundColor + ", iconColor=" + this.iconColor + ", focusedBorderColor=" + this.focusedBorderColor + ", showShareButton=" + this.showShareButton + ", showBackButton=" + this.showBackButton + ')';
    }

    public ArticleHeaderState(int i, int i2, int i3, int i4, boolean z, boolean z2) {
        this.backgroundColor = i;
        this.buttonBackgroundColor = i2;
        this.iconColor = i3;
        this.focusedBorderColor = i4;
        this.showShareButton = z;
        this.showBackButton = z2;
    }

    public ArticleHeaderState(int i, int i2, int i3, int i4, boolean z, boolean z2, int i5, DefaultConstructorMarker defaultConstructorMarker) {
        this((i5 & 1) != 0 ? 0 : i, (i5 & 2) != 0 ? 0 : i2, (i5 & 4) != 0 ? 0 : i3, (i5 & 8) != 0 ? 0 : i4, (i5 & 16) != 0 ? false : z, (i5 & 32) != 0 ? false : z2);
    }

    public final int getBackgroundColor$zendesk_ui_ui_android() {
        return this.backgroundColor;
    }

    public final int getButtonBackgroundColor$zendesk_ui_ui_android() {
        return this.buttonBackgroundColor;
    }

    public final int getIconColor$zendesk_ui_ui_android() {
        return this.iconColor;
    }

    public final int getFocusedBorderColor$zendesk_ui_ui_android() {
        return this.focusedBorderColor;
    }

    public final boolean getShowShareButton$zendesk_ui_ui_android() {
        return this.showShareButton;
    }

    public final boolean getShowBackButton$zendesk_ui_ui_android() {
        return this.showBackButton;
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0006\u001a\u00020\u0000J\u0006\u0010\u0007\u001a\u00020\u0003R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\b"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/articleheader/ArticleHeaderState$Builder;", "", "state", "Lzendesk/ui/android/conversation/articleviewer/articleheader/ArticleHeaderState;", "(Lzendesk/ui/android/conversation/articleviewer/articleheader/ArticleHeaderState;)V", "()V", "articleViewState", "build", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private ArticleHeaderState state;

        public Builder() {
            this.state = new ArticleHeaderState(0, 0, 0, 0, false, false, 63, null);
        }

        public Builder(ArticleHeaderState state) {
            this();
            Intrinsics.checkNotNullParameter(state, "state");
            this.state = state;
        }

        public final Builder articleViewState() {
            this.state = ArticleHeaderState.copy$default(this.state, 0, 0, 0, 0, false, false, 63, null);
            return this;
        }

        public final ArticleHeaderState getState() {
            return this.state;
        }
    }
}
