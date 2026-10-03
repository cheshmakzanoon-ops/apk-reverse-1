package zendesk.p026ui.android.conversation.articleviewer.feedbackbanner;

import java.util.List;
import kotlin.Metadata;
import kotlin.enums.EnumEntries;
import kotlin.enums.EnumEntriesKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.p026ui.android.conversation.quickreply.QuickReplyOption;

@Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0011\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0002\b\u0002\b\u0087\b\u0018\u00002\u00020\u0001:\u0001\u001fB7\b\u0000\u0012\b\b\u0003\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0003\u0010\u0004\u001a\u00020\u0003\u0012\b\b\u0003\u0010\u0005\u001a\u00020\u0003\u0012\u0010\b\u0002\u0010\u0006\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u0007¢\u0006\u0002\u0010\tJ\u000e\u0010\u0010\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\u0011J\u000e\u0010\u0012\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\u0013J\u000e\u0010\u0014\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\u0015J\u0016\u0010\u0016\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u0007HÀ\u0003¢\u0006\u0002\b\u0017J9\u0010\u0018\u001a\u00020\u00002\b\b\u0003\u0010\u0002\u001a\u00020\u00032\b\b\u0003\u0010\u0004\u001a\u00020\u00032\b\b\u0003\u0010\u0005\u001a\u00020\u00032\u0010\b\u0002\u0010\u0006\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u0007HÆ\u0001J\u0013\u0010\u0019\u001a\u00020\u001a2\b\u0010\u001b\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u001c\u001a\u00020\u0003HÖ\u0001J\t\u0010\u001d\u001a\u00020\u001eHÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u0014\u0010\u0005\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\u000bR\u001c\u0010\u0006\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u0014\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u000b¨\u0006 "}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/feedbackbanner/ArticleFeedbackBannerState;", "", "textColor", "", "backgroundColor", "buttonColor", "options", "", "Lzendesk/ui/android/conversation/quickreply/QuickReplyOption;", "(IIILjava/util/List;)V", "getBackgroundColor$zendesk_ui_ui_android", "()I", "getButtonColor$zendesk_ui_ui_android", "getOptions$zendesk_ui_ui_android", "()Ljava/util/List;", "getTextColor$zendesk_ui_ui_android", "component1", "component1$zendesk_ui_ui_android", "component2", "component2$zendesk_ui_ui_android", "component3", "component3$zendesk_ui_ui_android", "component4", "component4$zendesk_ui_ui_android", "copy", "equals", "", "other", "hashCode", "toString", "", "FeedbackOptionStatus", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ArticleFeedbackBannerState {
    public static final int $stable = 8;
    private final int backgroundColor;
    private final int buttonColor;
    private final List<QuickReplyOption> options;
    private final int textColor;

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\b\u0004\b\u0086\u0081\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00000\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002j\u0002\b\u0003j\u0002\b\u0004¨\u0006\u0005"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/feedbackbanner/ArticleFeedbackBannerState$FeedbackOptionStatus;", "", "(Ljava/lang/String;I)V", "YES", "NO", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public enum FeedbackOptionStatus {
        YES,
        NO;

        private static final EnumEntries $ENTRIES = EnumEntriesKt.enumEntries(values());

        public static EnumEntries<FeedbackOptionStatus> getEntries() {
            return $ENTRIES;
        }
    }

    public ArticleFeedbackBannerState() {
        this(0, 0, 0, null, 15, null);
    }

    public static ArticleFeedbackBannerState copy$default(ArticleFeedbackBannerState articleFeedbackBannerState, int i, int i2, int i3, List list, int i4, Object obj) {
        if ((i4 & 1) != 0) {
            i = articleFeedbackBannerState.textColor;
        }
        if ((i4 & 2) != 0) {
            i2 = articleFeedbackBannerState.backgroundColor;
        }
        if ((i4 & 4) != 0) {
            i3 = articleFeedbackBannerState.buttonColor;
        }
        if ((i4 & 8) != 0) {
            list = articleFeedbackBannerState.options;
        }
        return articleFeedbackBannerState.copy(i, i2, i3, list);
    }

    public final int getTextColor() {
        return this.textColor;
    }

    public final int getBackgroundColor() {
        return this.backgroundColor;
    }

    public final int getButtonColor() {
        return this.buttonColor;
    }

    public final List<QuickReplyOption> component4$zendesk_ui_ui_android() {
        return this.options;
    }

    public final ArticleFeedbackBannerState copy(int textColor, int backgroundColor, int buttonColor, List<QuickReplyOption> options) {
        return new ArticleFeedbackBannerState(textColor, backgroundColor, buttonColor, options);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ArticleFeedbackBannerState)) {
            return false;
        }
        ArticleFeedbackBannerState articleFeedbackBannerState = (ArticleFeedbackBannerState) other;
        return this.textColor == articleFeedbackBannerState.textColor && this.backgroundColor == articleFeedbackBannerState.backgroundColor && this.buttonColor == articleFeedbackBannerState.buttonColor && Intrinsics.areEqual(this.options, articleFeedbackBannerState.options);
    }

    public int hashCode() {
        int i = ((((this.textColor * 31) + this.backgroundColor) * 31) + this.buttonColor) * 31;
        List<QuickReplyOption> list = this.options;
        return i + (list == null ? 0 : list.hashCode());
    }

    public String toString() {
        return "ArticleFeedbackBannerState(textColor=" + this.textColor + ", backgroundColor=" + this.backgroundColor + ", buttonColor=" + this.buttonColor + ", options=" + this.options + ')';
    }

    public ArticleFeedbackBannerState(int i, int i2, int i3, List<QuickReplyOption> list) {
        this.textColor = i;
        this.backgroundColor = i2;
        this.buttonColor = i3;
        this.options = list;
    }

    public ArticleFeedbackBannerState(int i, int i2, int i3, List list, int i4, DefaultConstructorMarker defaultConstructorMarker) {
        this((i4 & 1) != 0 ? 0 : i, (i4 & 2) != 0 ? 0 : i2, (i4 & 4) != 0 ? 0 : i3, (i4 & 8) != 0 ? null : list);
    }

    public final int getTextColor$zendesk_ui_ui_android() {
        return this.textColor;
    }

    public final int getBackgroundColor$zendesk_ui_ui_android() {
        return this.backgroundColor;
    }

    public final int getButtonColor$zendesk_ui_ui_android() {
        return this.buttonColor;
    }

    public final List<QuickReplyOption> getOptions$zendesk_ui_ui_android() {
        return this.options;
    }
}
