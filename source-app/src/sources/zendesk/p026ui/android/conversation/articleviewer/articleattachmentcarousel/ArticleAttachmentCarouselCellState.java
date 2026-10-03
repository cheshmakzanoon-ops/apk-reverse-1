package zendesk.p026ui.android.conversation.articleviewer.articleattachmentcarousel;

import java.util.List;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u000f\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0000\b\u0087\b\u0018\u00002\u00020\u0001B3\u0012\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\b\b\u0003\u0010\u0005\u001a\u00020\u0006\u0012\b\b\u0003\u0010\u0007\u001a\u00020\u0006\u0012\b\b\u0003\u0010\b\u001a\u00020\u0006¢\u0006\u0002\u0010\tJ\u000f\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\t\u0010\u0011\u001a\u00020\u0006HÆ\u0003J\t\u0010\u0012\u001a\u00020\u0006HÆ\u0003J\t\u0010\u0013\u001a\u00020\u0006HÆ\u0003J7\u0010\u0014\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\b\u0003\u0010\u0005\u001a\u00020\u00062\b\b\u0003\u0010\u0007\u001a\u00020\u00062\b\b\u0003\u0010\b\u001a\u00020\u0006HÆ\u0001J\u0013\u0010\u0015\u001a\u00020\u00162\b\u0010\u0017\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0018\u001a\u00020\u0006HÖ\u0001J\t\u0010\u0019\u001a\u00020\u001aHÖ\u0001R\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u0011\u0010\b\u001a\u00020\u0006¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\rR\u0011\u0010\u0007\u001a\u00020\u0006¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\rR\u0011\u0010\u0005\u001a\u00020\u0006¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\r¨\u0006\u001b"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentCarouselCellState;", "", "attachmentListData", "", "Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentItem;", "textColor", "", "navigationButtonBackgroundColor", "focusedStateBorderColor", "(Ljava/util/List;III)V", "getAttachmentListData", "()Ljava/util/List;", "getFocusedStateBorderColor", "()I", "getNavigationButtonBackgroundColor", "getTextColor", "component1", "component2", "component3", "component4", "copy", "equals", "", "other", "hashCode", "toString", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ArticleAttachmentCarouselCellState {
    public static final int $stable = 8;
    private final List<ArticleAttachmentItem> attachmentListData;
    private final int focusedStateBorderColor;
    private final int navigationButtonBackgroundColor;
    private final int textColor;

    public ArticleAttachmentCarouselCellState() {
        this(null, 0, 0, 0, 15, null);
    }

    public static ArticleAttachmentCarouselCellState copy$default(ArticleAttachmentCarouselCellState articleAttachmentCarouselCellState, List list, int i, int i2, int i3, int i4, Object obj) {
        if ((i4 & 1) != 0) {
            list = articleAttachmentCarouselCellState.attachmentListData;
        }
        if ((i4 & 2) != 0) {
            i = articleAttachmentCarouselCellState.textColor;
        }
        if ((i4 & 4) != 0) {
            i2 = articleAttachmentCarouselCellState.navigationButtonBackgroundColor;
        }
        if ((i4 & 8) != 0) {
            i3 = articleAttachmentCarouselCellState.focusedStateBorderColor;
        }
        return articleAttachmentCarouselCellState.copy(list, i, i2, i3);
    }

    public final List<ArticleAttachmentItem> component1() {
        return this.attachmentListData;
    }

    public final int getTextColor() {
        return this.textColor;
    }

    public final int getNavigationButtonBackgroundColor() {
        return this.navigationButtonBackgroundColor;
    }

    public final int getFocusedStateBorderColor() {
        return this.focusedStateBorderColor;
    }

    public final ArticleAttachmentCarouselCellState copy(List<ArticleAttachmentItem> attachmentListData, int textColor, int navigationButtonBackgroundColor, int focusedStateBorderColor) {
        Intrinsics.checkNotNullParameter(attachmentListData, "attachmentListData");
        return new ArticleAttachmentCarouselCellState(attachmentListData, textColor, navigationButtonBackgroundColor, focusedStateBorderColor);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ArticleAttachmentCarouselCellState)) {
            return false;
        }
        ArticleAttachmentCarouselCellState articleAttachmentCarouselCellState = (ArticleAttachmentCarouselCellState) other;
        return Intrinsics.areEqual(this.attachmentListData, articleAttachmentCarouselCellState.attachmentListData) && this.textColor == articleAttachmentCarouselCellState.textColor && this.navigationButtonBackgroundColor == articleAttachmentCarouselCellState.navigationButtonBackgroundColor && this.focusedStateBorderColor == articleAttachmentCarouselCellState.focusedStateBorderColor;
    }

    public int hashCode() {
        return (((((this.attachmentListData.hashCode() * 31) + this.textColor) * 31) + this.navigationButtonBackgroundColor) * 31) + this.focusedStateBorderColor;
    }

    public String toString() {
        return "ArticleAttachmentCarouselCellState(attachmentListData=" + this.attachmentListData + ", textColor=" + this.textColor + ", navigationButtonBackgroundColor=" + this.navigationButtonBackgroundColor + ", focusedStateBorderColor=" + this.focusedStateBorderColor + ')';
    }

    public ArticleAttachmentCarouselCellState(List<ArticleAttachmentItem> attachmentListData, int i, int i2, int i3) {
        Intrinsics.checkNotNullParameter(attachmentListData, "attachmentListData");
        this.attachmentListData = attachmentListData;
        this.textColor = i;
        this.navigationButtonBackgroundColor = i2;
        this.focusedStateBorderColor = i3;
    }

    public ArticleAttachmentCarouselCellState(List list, int i, int i2, int i3, int i4, DefaultConstructorMarker defaultConstructorMarker) {
        this((i4 & 1) != 0 ? CollectionsKt.emptyList() : list, (i4 & 2) != 0 ? 0 : i, (i4 & 4) != 0 ? 0 : i2, (i4 & 8) != 0 ? 0 : i3);
    }

    public final List<ArticleAttachmentItem> getAttachmentListData() {
        return this.attachmentListData;
    }

    public final int getTextColor() {
        return this.textColor;
    }

    public final int getNavigationButtonBackgroundColor() {
        return this.navigationButtonBackgroundColor;
    }

    public final int getFocusedStateBorderColor() {
        return this.focusedStateBorderColor;
    }
}
