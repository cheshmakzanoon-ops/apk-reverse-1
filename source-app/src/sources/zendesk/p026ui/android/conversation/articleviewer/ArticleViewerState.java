package zendesk.p026ui.android.conversation.articleviewer;

import java.util.List;
import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import okhttp3.internal.http2.Settings;
import zendesk.p026ui.android.conversation.articleviewer.articleattachmentcarousel.ArticleAttachmentItem;
import zendesk.p026ui.android.conversation.articleviewer.articlecontent.ArticleContentState;
import zendesk.p026ui.android.conversation.quickreply.QuickReplyOption;

@Metadata(m17d1 = {"\u0000H\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b9\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\b\u0087\b\u0018\u00002\u00020\u0001:\u0001TB·\u0001\b\u0000\u0012\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0003\u0010\u0006\u001a\u00020\u0007\u0012\b\b\u0003\u0010\b\u001a\u00020\u0007\u0012\b\b\u0003\u0010\t\u001a\u00020\u0007\u0012\b\b\u0003\u0010\n\u001a\u00020\u0007\u0012\b\b\u0003\u0010\u000b\u001a\u00020\u0007\u0012\b\b\u0003\u0010\f\u001a\u00020\u0007\u0012\b\b\u0002\u0010\r\u001a\u00020\u000e\u0012\b\b\u0002\u0010\u000f\u001a\u00020\u000e\u0012\u000e\b\u0002\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\u00120\u0011\u0012\b\b\u0003\u0010\u0013\u001a\u00020\u0007\u0012\b\b\u0003\u0010\u0014\u001a\u00020\u0007\u0012\b\b\u0003\u0010\u0015\u001a\u00020\u0007\u0012\u0010\b\u0002\u0010\u0016\u001a\n\u0012\u0004\u0012\u00020\u0017\u0018\u00010\u0011\u0012\b\b\u0002\u0010\u0018\u001a\u00020\u000e¢\u0006\u0002\u0010\u0019J\u0010\u0010/\u001a\u0004\u0018\u00010\u0003HÀ\u0003¢\u0006\u0002\b0J\u000e\u00101\u001a\u00020\u000eHÀ\u0003¢\u0006\u0002\b2J\u0014\u00103\u001a\b\u0012\u0004\u0012\u00020\u00120\u0011HÀ\u0003¢\u0006\u0002\b4J\t\u00105\u001a\u00020\u0007HÆ\u0003J\t\u00106\u001a\u00020\u0007HÆ\u0003J\t\u00107\u001a\u00020\u0007HÆ\u0003J\u0016\u00108\u001a\n\u0012\u0004\u0012\u00020\u0017\u0018\u00010\u0011HÀ\u0003¢\u0006\u0002\b9J\u000e\u0010:\u001a\u00020\u000eHÀ\u0003¢\u0006\u0002\b;J\u000e\u0010<\u001a\u00020\u0005HÀ\u0003¢\u0006\u0002\b=J\u000e\u0010>\u001a\u00020\u0007HÀ\u0003¢\u0006\u0002\b?J\u000e\u0010@\u001a\u00020\u0007HÀ\u0003¢\u0006\u0002\bAJ\u000e\u0010B\u001a\u00020\u0007HÀ\u0003¢\u0006\u0002\bCJ\u000e\u0010D\u001a\u00020\u0007HÀ\u0003¢\u0006\u0002\bEJ\u000e\u0010F\u001a\u00020\u0007HÀ\u0003¢\u0006\u0002\bGJ\u000e\u0010H\u001a\u00020\u0007HÀ\u0003¢\u0006\u0002\bIJ\u000e\u0010J\u001a\u00020\u000eHÀ\u0003¢\u0006\u0002\bKJ¹\u0001\u0010L\u001a\u00020\u00002\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0003\u0010\u0006\u001a\u00020\u00072\b\b\u0003\u0010\b\u001a\u00020\u00072\b\b\u0003\u0010\t\u001a\u00020\u00072\b\b\u0003\u0010\n\u001a\u00020\u00072\b\b\u0003\u0010\u000b\u001a\u00020\u00072\b\b\u0003\u0010\f\u001a\u00020\u00072\b\b\u0002\u0010\r\u001a\u00020\u000e2\b\b\u0002\u0010\u000f\u001a\u00020\u000e2\u000e\b\u0002\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\u00120\u00112\b\b\u0003\u0010\u0013\u001a\u00020\u00072\b\b\u0003\u0010\u0014\u001a\u00020\u00072\b\b\u0003\u0010\u0015\u001a\u00020\u00072\u0010\b\u0002\u0010\u0016\u001a\n\u0012\u0004\u0012\u00020\u0017\u0018\u00010\u00112\b\b\u0002\u0010\u0018\u001a\u00020\u000eHÆ\u0001J\u0013\u0010M\u001a\u00020\u000e2\b\u0010N\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010O\u001a\u00020\u0007HÖ\u0001J\u0006\u0010P\u001a\u00020QJ\t\u0010R\u001a\u00020SHÖ\u0001R\u0016\u0010\u0002\u001a\u0004\u0018\u00010\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u001bR\u001a\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\u00120\u0011X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001c\u0010\u001dR\u0011\u0010\u0013\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u001e\u0010\u001fR\u0014\u0010\b\u001a\u00020\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b \u0010\u001fR\u0014\u0010\t\u001a\u00020\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b!\u0010\u001fR\u0014\u0010\u000b\u001a\u00020\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\"\u0010\u001fR\u0014\u0010\u0004\u001a\u00020\u0005X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b#\u0010$R\u001c\u0010\u0016\u001a\n\u0012\u0004\u0012\u00020\u0017\u0018\u00010\u0011X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b%\u0010\u001dR\u0011\u0010\u0015\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b&\u0010\u001fR\u0014\u0010\u0006\u001a\u00020\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b'\u0010\u001fR\u0014\u0010\f\u001a\u00020\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b(\u0010\u001fR\u0011\u0010\u0014\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b)\u0010\u001fR\u0014\u0010\u0018\u001a\u00020\u000eX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b*\u0010+R\u0014\u0010\r\u001a\u00020\u000eX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b,\u0010+R\u0014\u0010\u000f\u001a\u00020\u000eX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b-\u0010+R\u0014\u0010\n\u001a\u00020\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b.\u0010\u001f¨\u0006U"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/ArticleViewerState;", "", "articleData", "Lzendesk/ui/android/conversation/articleviewer/articlecontent/ArticleContentState$ArticleData;", "contentState", "Lzendesk/ui/android/conversation/articleviewer/articlecontent/ArticleContentState$ArticleLoadingStatus;", "iconColor", "", "backgroundColor", "buttonBackgroundColor", "textColor", "buttonColor", "indicatorColor", "showBackButton", "", "showShareButton", "attachmentList", "", "Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentItem;", "attachmentListTextColor", "navigationButtonBackgroundColor", "focusedStateBorderColor", "feedBackBannerOptions", "Lzendesk/ui/android/conversation/quickreply/QuickReplyOption;", "shouldShowFeedbackBanner", "(Lzendesk/ui/android/conversation/articleviewer/articlecontent/ArticleContentState$ArticleData;Lzendesk/ui/android/conversation/articleviewer/articlecontent/ArticleContentState$ArticleLoadingStatus;IIIIIIZZLjava/util/List;IIILjava/util/List;Z)V", "getArticleData$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/articleviewer/articlecontent/ArticleContentState$ArticleData;", "getAttachmentList$zendesk_ui_ui_android", "()Ljava/util/List;", "getAttachmentListTextColor", "()I", "getBackgroundColor$zendesk_ui_ui_android", "getButtonBackgroundColor$zendesk_ui_ui_android", "getButtonColor$zendesk_ui_ui_android", "getContentState$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/articleviewer/articlecontent/ArticleContentState$ArticleLoadingStatus;", "getFeedBackBannerOptions$zendesk_ui_ui_android", "getFocusedStateBorderColor", "getIconColor$zendesk_ui_ui_android", "getIndicatorColor$zendesk_ui_ui_android", "getNavigationButtonBackgroundColor", "getShouldShowFeedbackBanner$zendesk_ui_ui_android", "()Z", "getShowBackButton$zendesk_ui_ui_android", "getShowShareButton$zendesk_ui_ui_android", "getTextColor$zendesk_ui_ui_android", "component1", "component1$zendesk_ui_ui_android", "component10", "component10$zendesk_ui_ui_android", "component11", "component11$zendesk_ui_ui_android", "component12", "component13", "component14", "component15", "component15$zendesk_ui_ui_android", "component16", "component16$zendesk_ui_ui_android", "component2", "component2$zendesk_ui_ui_android", "component3", "component3$zendesk_ui_ui_android", "component4", "component4$zendesk_ui_ui_android", "component5", "component5$zendesk_ui_ui_android", "component6", "component6$zendesk_ui_ui_android", "component7", "component7$zendesk_ui_ui_android", "component8", "component8$zendesk_ui_ui_android", "component9", "component9$zendesk_ui_ui_android", "copy", "equals", "other", "hashCode", "toBuilder", "Lzendesk/ui/android/conversation/articleviewer/ArticleViewerState$Builder;", "toString", "", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ArticleViewerState {
    public static final int $stable = 8;
    private final ArticleContentState.ArticleData articleData;
    private final List<ArticleAttachmentItem> attachmentList;
    private final int attachmentListTextColor;
    private final int backgroundColor;
    private final int buttonBackgroundColor;
    private final int buttonColor;
    private final ArticleContentState.ArticleLoadingStatus contentState;
    private final List<QuickReplyOption> feedBackBannerOptions;
    private final int focusedStateBorderColor;
    private final int iconColor;
    private final int indicatorColor;
    private final int navigationButtonBackgroundColor;
    private final boolean shouldShowFeedbackBanner;
    private final boolean showBackButton;
    private final boolean showShareButton;
    private final int textColor;

    public ArticleViewerState() {
        this(null, null, 0, 0, 0, 0, 0, 0, false, false, null, 0, 0, 0, null, false, Settings.DEFAULT_INITIAL_WINDOW_SIZE, null);
    }

    public static ArticleViewerState copy$default(ArticleViewerState articleViewerState, ArticleContentState.ArticleData articleData, ArticleContentState.ArticleLoadingStatus articleLoadingStatus, int i, int i2, int i3, int i4, int i5, int i6, boolean z, boolean z2, List list, int i7, int i8, int i9, List list2, boolean z3, int i10, Object obj) {
        return articleViewerState.copy((i10 & 1) != 0 ? articleViewerState.articleData : articleData, (i10 & 2) != 0 ? articleViewerState.contentState : articleLoadingStatus, (i10 & 4) != 0 ? articleViewerState.iconColor : i, (i10 & 8) != 0 ? articleViewerState.backgroundColor : i2, (i10 & 16) != 0 ? articleViewerState.buttonBackgroundColor : i3, (i10 & 32) != 0 ? articleViewerState.textColor : i4, (i10 & 64) != 0 ? articleViewerState.buttonColor : i5, (i10 & 128) != 0 ? articleViewerState.indicatorColor : i6, (i10 & 256) != 0 ? articleViewerState.showBackButton : z, (i10 & 512) != 0 ? articleViewerState.showShareButton : z2, (i10 & 1024) != 0 ? articleViewerState.attachmentList : list, (i10 & 2048) != 0 ? articleViewerState.attachmentListTextColor : i7, (i10 & 4096) != 0 ? articleViewerState.navigationButtonBackgroundColor : i8, (i10 & 8192) != 0 ? articleViewerState.focusedStateBorderColor : i9, (i10 & 16384) != 0 ? articleViewerState.feedBackBannerOptions : list2, (i10 & 32768) != 0 ? articleViewerState.shouldShowFeedbackBanner : z3);
    }

    public final ArticleContentState.ArticleData getArticleData() {
        return this.articleData;
    }

    public final boolean getShowShareButton() {
        return this.showShareButton;
    }

    public final List<ArticleAttachmentItem> component11$zendesk_ui_ui_android() {
        return this.attachmentList;
    }

    public final int getAttachmentListTextColor() {
        return this.attachmentListTextColor;
    }

    public final int getNavigationButtonBackgroundColor() {
        return this.navigationButtonBackgroundColor;
    }

    public final int getFocusedStateBorderColor() {
        return this.focusedStateBorderColor;
    }

    public final List<QuickReplyOption> component15$zendesk_ui_ui_android() {
        return this.feedBackBannerOptions;
    }

    public final boolean getShouldShowFeedbackBanner() {
        return this.shouldShowFeedbackBanner;
    }

    public final ArticleContentState.ArticleLoadingStatus getContentState() {
        return this.contentState;
    }

    public final int getIconColor() {
        return this.iconColor;
    }

    public final int getBackgroundColor() {
        return this.backgroundColor;
    }

    public final int getButtonBackgroundColor() {
        return this.buttonBackgroundColor;
    }

    public final int getTextColor() {
        return this.textColor;
    }

    public final int getButtonColor() {
        return this.buttonColor;
    }

    public final int getIndicatorColor() {
        return this.indicatorColor;
    }

    public final boolean getShowBackButton() {
        return this.showBackButton;
    }

    public final ArticleViewerState copy(ArticleContentState.ArticleData articleData, ArticleContentState.ArticleLoadingStatus contentState, int iconColor, int backgroundColor, int buttonBackgroundColor, int textColor, int buttonColor, int indicatorColor, boolean showBackButton, boolean showShareButton, List<ArticleAttachmentItem> attachmentList, int attachmentListTextColor, int navigationButtonBackgroundColor, int focusedStateBorderColor, List<QuickReplyOption> feedBackBannerOptions, boolean shouldShowFeedbackBanner) {
        Intrinsics.checkNotNullParameter(contentState, "contentState");
        Intrinsics.checkNotNullParameter(attachmentList, "attachmentList");
        return new ArticleViewerState(articleData, contentState, iconColor, backgroundColor, buttonBackgroundColor, textColor, buttonColor, indicatorColor, showBackButton, showShareButton, attachmentList, attachmentListTextColor, navigationButtonBackgroundColor, focusedStateBorderColor, feedBackBannerOptions, shouldShowFeedbackBanner);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ArticleViewerState)) {
            return false;
        }
        ArticleViewerState articleViewerState = (ArticleViewerState) other;
        return Intrinsics.areEqual(this.articleData, articleViewerState.articleData) && this.contentState == articleViewerState.contentState && this.iconColor == articleViewerState.iconColor && this.backgroundColor == articleViewerState.backgroundColor && this.buttonBackgroundColor == articleViewerState.buttonBackgroundColor && this.textColor == articleViewerState.textColor && this.buttonColor == articleViewerState.buttonColor && this.indicatorColor == articleViewerState.indicatorColor && this.showBackButton == articleViewerState.showBackButton && this.showShareButton == articleViewerState.showShareButton && Intrinsics.areEqual(this.attachmentList, articleViewerState.attachmentList) && this.attachmentListTextColor == articleViewerState.attachmentListTextColor && this.navigationButtonBackgroundColor == articleViewerState.navigationButtonBackgroundColor && this.focusedStateBorderColor == articleViewerState.focusedStateBorderColor && Intrinsics.areEqual(this.feedBackBannerOptions, articleViewerState.feedBackBannerOptions) && this.shouldShowFeedbackBanner == articleViewerState.shouldShowFeedbackBanner;
    }

    public int hashCode() {
        ArticleContentState.ArticleData articleData = this.articleData;
        int iHashCode = (((((((((((((((((((((((((((articleData == null ? 0 : articleData.hashCode()) * 31) + this.contentState.hashCode()) * 31) + this.iconColor) * 31) + this.backgroundColor) * 31) + this.buttonBackgroundColor) * 31) + this.textColor) * 31) + this.buttonColor) * 31) + this.indicatorColor) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.showBackButton)) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.showShareButton)) * 31) + this.attachmentList.hashCode()) * 31) + this.attachmentListTextColor) * 31) + this.navigationButtonBackgroundColor) * 31) + this.focusedStateBorderColor) * 31;
        List<QuickReplyOption> list = this.feedBackBannerOptions;
        return ((iHashCode + (list != null ? list.hashCode() : 0)) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.shouldShowFeedbackBanner);
    }

    public String toString() {
        return "ArticleViewerState(articleData=" + this.articleData + ", contentState=" + this.contentState + ", iconColor=" + this.iconColor + ", backgroundColor=" + this.backgroundColor + ", buttonBackgroundColor=" + this.buttonBackgroundColor + ", textColor=" + this.textColor + ", buttonColor=" + this.buttonColor + ", indicatorColor=" + this.indicatorColor + ", showBackButton=" + this.showBackButton + ", showShareButton=" + this.showShareButton + ", attachmentList=" + this.attachmentList + ", attachmentListTextColor=" + this.attachmentListTextColor + ", navigationButtonBackgroundColor=" + this.navigationButtonBackgroundColor + ", focusedStateBorderColor=" + this.focusedStateBorderColor + ", feedBackBannerOptions=" + this.feedBackBannerOptions + ", shouldShowFeedbackBanner=" + this.shouldShowFeedbackBanner + ')';
    }

    public ArticleViewerState(ArticleContentState.ArticleData articleData, ArticleContentState.ArticleLoadingStatus contentState, int i, int i2, int i3, int i4, int i5, int i6, boolean z, boolean z2, List<ArticleAttachmentItem> attachmentList, int i7, int i8, int i9, List<QuickReplyOption> list, boolean z3) {
        Intrinsics.checkNotNullParameter(contentState, "contentState");
        Intrinsics.checkNotNullParameter(attachmentList, "attachmentList");
        this.articleData = articleData;
        this.contentState = contentState;
        this.iconColor = i;
        this.backgroundColor = i2;
        this.buttonBackgroundColor = i3;
        this.textColor = i4;
        this.buttonColor = i5;
        this.indicatorColor = i6;
        this.showBackButton = z;
        this.showShareButton = z2;
        this.attachmentList = attachmentList;
        this.attachmentListTextColor = i7;
        this.navigationButtonBackgroundColor = i8;
        this.focusedStateBorderColor = i9;
        this.feedBackBannerOptions = list;
        this.shouldShowFeedbackBanner = z3;
    }

    public final ArticleContentState.ArticleData getArticleData$zendesk_ui_ui_android() {
        return this.articleData;
    }

    public final ArticleContentState.ArticleLoadingStatus getContentState$zendesk_ui_ui_android() {
        return this.contentState;
    }

    public ArticleViewerState(ArticleContentState.ArticleData articleData, ArticleContentState.ArticleLoadingStatus articleLoadingStatus, int i, int i2, int i3, int i4, int i5, int i6, boolean z, boolean z2, List list, int i7, int i8, int i9, List list2, boolean z3, int i10, DefaultConstructorMarker defaultConstructorMarker) {
        this((i10 & 1) != 0 ? null : articleData, (i10 & 2) != 0 ? ArticleContentState.ArticleLoadingStatus.IDLE : articleLoadingStatus, (i10 & 4) != 0 ? 0 : i, (i10 & 8) != 0 ? 0 : i2, (i10 & 16) != 0 ? 0 : i3, (i10 & 32) != 0 ? 0 : i4, (i10 & 64) != 0 ? 0 : i5, (i10 & 128) != 0 ? 0 : i6, (i10 & 256) != 0 ? false : z, (i10 & 512) != 0 ? false : z2, (i10 & 1024) != 0 ? CollectionsKt.emptyList() : list, (i10 & 2048) != 0 ? 0 : i7, (i10 & 4096) != 0 ? 0 : i8, (i10 & 8192) != 0 ? 0 : i9, (i10 & 16384) != 0 ? null : list2, (i10 & 32768) != 0 ? false : z3);
    }

    public final int getIconColor$zendesk_ui_ui_android() {
        return this.iconColor;
    }

    public final int getBackgroundColor$zendesk_ui_ui_android() {
        return this.backgroundColor;
    }

    public final int getButtonBackgroundColor$zendesk_ui_ui_android() {
        return this.buttonBackgroundColor;
    }

    public final int getTextColor$zendesk_ui_ui_android() {
        return this.textColor;
    }

    public final int getButtonColor$zendesk_ui_ui_android() {
        return this.buttonColor;
    }

    public final int getIndicatorColor$zendesk_ui_ui_android() {
        return this.indicatorColor;
    }

    public final boolean getShowBackButton$zendesk_ui_ui_android() {
        return this.showBackButton;
    }

    public final boolean getShowShareButton$zendesk_ui_ui_android() {
        return this.showShareButton;
    }

    public final List<ArticleAttachmentItem> getAttachmentList$zendesk_ui_ui_android() {
        return this.attachmentList;
    }

    public final int getAttachmentListTextColor() {
        return this.attachmentListTextColor;
    }

    public final int getNavigationButtonBackgroundColor() {
        return this.navigationButtonBackgroundColor;
    }

    public final int getFocusedStateBorderColor() {
        return this.focusedStateBorderColor;
    }

    public final List<QuickReplyOption> getFeedBackBannerOptions$zendesk_ui_ui_android() {
        return this.feedBackBannerOptions;
    }

    public final boolean getShouldShowFeedbackBanner$zendesk_ui_ui_android() {
        return this.shouldShowFeedbackBanner;
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0006\u001a\u00020\u0000J\u0006\u0010\u0007\u001a\u00020\u0003R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\b"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/ArticleViewerState$Builder;", "", "state", "Lzendesk/ui/android/conversation/articleviewer/ArticleViewerState;", "(Lzendesk/ui/android/conversation/articleviewer/ArticleViewerState;)V", "()V", "articleViewState", "build", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private ArticleViewerState state;

        public Builder() {
            this.state = new ArticleViewerState(null, null, 0, 0, 0, 0, 0, 0, false, false, null, 0, 0, 0, null, false, Settings.DEFAULT_INITIAL_WINDOW_SIZE, null);
        }

        public Builder(ArticleViewerState state) {
            this();
            Intrinsics.checkNotNullParameter(state, "state");
            this.state = state;
        }

        public final Builder articleViewState() {
            this.state = ArticleViewerState.copy$default(this.state, null, null, 0, 0, 0, 0, 0, 0, false, false, null, 0, 0, 0, null, false, Settings.DEFAULT_INITIAL_WINDOW_SIZE, null);
            return this;
        }

        public final ArticleViewerState getState() {
            return this.state;
        }
    }
}
