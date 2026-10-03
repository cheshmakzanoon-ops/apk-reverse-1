package zendesk.p026ui.android.conversation.articleviewer.articlecontent;

import android.net.Uri;
import java.util.List;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.enums.EnumEntries;
import kotlin.enums.EnumEntriesKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.p026ui.android.conversation.articleviewer.articleattachmentcarousel.ArticleAttachmentItem;

@Metadata(m17d1 = {"\u0000@\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\"\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0004\b\u0087\b\u0018\u00002\u00020\u0001:\u0003678Bi\b\u0000\u0012\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u0003\u0012\b\b\u0003\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0003\u0010\u0006\u001a\u00020\u0005\u0012\b\b\u0003\u0010\u0007\u001a\u00020\u0005\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\u000e\b\u0002\u0010\n\u001a\b\u0012\u0004\u0012\u00020\f0\u000b\u0012\b\b\u0003\u0010\r\u001a\u00020\u0005\u0012\b\b\u0003\u0010\u000e\u001a\u00020\u0005\u0012\b\b\u0003\u0010\u000f\u001a\u00020\u0005¢\u0006\u0002\u0010\u0010J\u0010\u0010\u001e\u001a\u0004\u0018\u00010\u0003HÀ\u0003¢\u0006\u0002\b\u001fJ\u000e\u0010 \u001a\u00020\u0005HÀ\u0003¢\u0006\u0002\b!J\u000e\u0010\"\u001a\u00020\u0005HÀ\u0003¢\u0006\u0002\b#J\u000e\u0010$\u001a\u00020\u0005HÀ\u0003¢\u0006\u0002\b%J\u000e\u0010&\u001a\u00020\tHÀ\u0003¢\u0006\u0002\b'J\u0014\u0010(\u001a\b\u0012\u0004\u0012\u00020\f0\u000bHÀ\u0003¢\u0006\u0002\b)J\t\u0010*\u001a\u00020\u0005HÆ\u0003J\t\u0010+\u001a\u00020\u0005HÆ\u0003J\t\u0010,\u001a\u00020\u0005HÆ\u0003Jk\u0010-\u001a\u00020\u00002\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u00032\b\b\u0003\u0010\u0004\u001a\u00020\u00052\b\b\u0003\u0010\u0006\u001a\u00020\u00052\b\b\u0003\u0010\u0007\u001a\u00020\u00052\b\b\u0002\u0010\b\u001a\u00020\t2\u000e\b\u0002\u0010\n\u001a\b\u0012\u0004\u0012\u00020\f0\u000b2\b\b\u0003\u0010\r\u001a\u00020\u00052\b\b\u0003\u0010\u000e\u001a\u00020\u00052\b\b\u0003\u0010\u000f\u001a\u00020\u0005HÆ\u0001J\u0013\u0010.\u001a\u00020/2\b\u00100\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u00101\u001a\u00020\u0005HÖ\u0001J\u0006\u00102\u001a\u000203J\t\u00104\u001a\u000205HÖ\u0001R\u0016\u0010\u0002\u001a\u0004\u0018\u00010\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012R\u001a\u0010\n\u001a\b\u0012\u0004\u0012\u00020\f0\u000bX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014R\u0011\u0010\r\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016R\u0014\u0010\u0006\u001a\u00020\u0005X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0016R\u0011\u0010\u000f\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u0016R\u0014\u0010\u0007\u001a\u00020\u0005X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u0016R\u0011\u0010\u000e\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u0016R\u0014\u0010\b\u001a\u00020\tX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u001cR\u0014\u0010\u0004\u001a\u00020\u0005X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001d\u0010\u0016¨\u00069"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/articlecontent/ArticleContentState;", "", "articleData", "Lzendesk/ui/android/conversation/articleviewer/articlecontent/ArticleContentState$ArticleData;", "textColor", "", "backgroundColor", "indicatorColor", "status", "Lzendesk/ui/android/conversation/articleviewer/articlecontent/ArticleContentState$ArticleLoadingStatus;", "attachmentList", "", "Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentItem;", "attachmentListTextColor", "navigationButtonBackgroundColor", "focusedStateBorderColor", "(Lzendesk/ui/android/conversation/articleviewer/articlecontent/ArticleContentState$ArticleData;IIILzendesk/ui/android/conversation/articleviewer/articlecontent/ArticleContentState$ArticleLoadingStatus;Ljava/util/List;III)V", "getArticleData$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/articleviewer/articlecontent/ArticleContentState$ArticleData;", "getAttachmentList$zendesk_ui_ui_android", "()Ljava/util/List;", "getAttachmentListTextColor", "()I", "getBackgroundColor$zendesk_ui_ui_android", "getFocusedStateBorderColor", "getIndicatorColor$zendesk_ui_ui_android", "getNavigationButtonBackgroundColor", "getStatus$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/articleviewer/articlecontent/ArticleContentState$ArticleLoadingStatus;", "getTextColor$zendesk_ui_ui_android", "component1", "component1$zendesk_ui_ui_android", "component2", "component2$zendesk_ui_ui_android", "component3", "component3$zendesk_ui_ui_android", "component4", "component4$zendesk_ui_ui_android", "component5", "component5$zendesk_ui_ui_android", "component6", "component6$zendesk_ui_ui_android", "component7", "component8", "component9", "copy", "equals", "", "other", "hashCode", "toBuilder", "Lzendesk/ui/android/conversation/articleviewer/articlecontent/ArticleContentState$Builder;", "toString", "", "ArticleData", "ArticleLoadingStatus", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ArticleContentState {
    public static final int $stable = 8;
    private final ArticleData articleData;
    private final List<ArticleAttachmentItem> attachmentList;
    private final int attachmentListTextColor;
    private final int backgroundColor;
    private final int focusedStateBorderColor;
    private final int indicatorColor;
    private final int navigationButtonBackgroundColor;
    private final ArticleLoadingStatus status;
    private final int textColor;

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\b\u0006\b\u0086\u0081\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00000\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002j\u0002\b\u0003j\u0002\b\u0004j\u0002\b\u0005j\u0002\b\u0006¨\u0006\u0007"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/articlecontent/ArticleContentState$ArticleLoadingStatus;", "", "(Ljava/lang/String;I)V", "IDLE", "LOADING", "FAILED", "SUCCESS", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public enum ArticleLoadingStatus {
        IDLE,
        LOADING,
        FAILED,
        SUCCESS;

        private static final EnumEntries $ENTRIES = EnumEntriesKt.enumEntries(values());

        public static EnumEntries<ArticleLoadingStatus> getEntries() {
            return $ENTRIES;
        }
    }

    public ArticleContentState() {
        this(null, 0, 0, 0, null, null, 0, 0, 0, 511, null);
    }

    public static ArticleContentState copy$default(ArticleContentState articleContentState, ArticleData articleData, int i, int i2, int i3, ArticleLoadingStatus articleLoadingStatus, List list, int i4, int i5, int i6, int i7, Object obj) {
        return articleContentState.copy((i7 & 1) != 0 ? articleContentState.articleData : articleData, (i7 & 2) != 0 ? articleContentState.textColor : i, (i7 & 4) != 0 ? articleContentState.backgroundColor : i2, (i7 & 8) != 0 ? articleContentState.indicatorColor : i3, (i7 & 16) != 0 ? articleContentState.status : articleLoadingStatus, (i7 & 32) != 0 ? articleContentState.attachmentList : list, (i7 & 64) != 0 ? articleContentState.attachmentListTextColor : i4, (i7 & 128) != 0 ? articleContentState.navigationButtonBackgroundColor : i5, (i7 & 256) != 0 ? articleContentState.focusedStateBorderColor : i6);
    }

    public final ArticleData getArticleData() {
        return this.articleData;
    }

    public final int getTextColor() {
        return this.textColor;
    }

    public final int getBackgroundColor() {
        return this.backgroundColor;
    }

    public final int getIndicatorColor() {
        return this.indicatorColor;
    }

    public final ArticleLoadingStatus getStatus() {
        return this.status;
    }

    public final List<ArticleAttachmentItem> component6$zendesk_ui_ui_android() {
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

    public final ArticleContentState copy(ArticleData articleData, int textColor, int backgroundColor, int indicatorColor, ArticleLoadingStatus status, List<ArticleAttachmentItem> attachmentList, int attachmentListTextColor, int navigationButtonBackgroundColor, int focusedStateBorderColor) {
        Intrinsics.checkNotNullParameter(status, "status");
        Intrinsics.checkNotNullParameter(attachmentList, "attachmentList");
        return new ArticleContentState(articleData, textColor, backgroundColor, indicatorColor, status, attachmentList, attachmentListTextColor, navigationButtonBackgroundColor, focusedStateBorderColor);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ArticleContentState)) {
            return false;
        }
        ArticleContentState articleContentState = (ArticleContentState) other;
        return Intrinsics.areEqual(this.articleData, articleContentState.articleData) && this.textColor == articleContentState.textColor && this.backgroundColor == articleContentState.backgroundColor && this.indicatorColor == articleContentState.indicatorColor && this.status == articleContentState.status && Intrinsics.areEqual(this.attachmentList, articleContentState.attachmentList) && this.attachmentListTextColor == articleContentState.attachmentListTextColor && this.navigationButtonBackgroundColor == articleContentState.navigationButtonBackgroundColor && this.focusedStateBorderColor == articleContentState.focusedStateBorderColor;
    }

    public int hashCode() {
        ArticleData articleData = this.articleData;
        return ((((((((((((((((articleData == null ? 0 : articleData.hashCode()) * 31) + this.textColor) * 31) + this.backgroundColor) * 31) + this.indicatorColor) * 31) + this.status.hashCode()) * 31) + this.attachmentList.hashCode()) * 31) + this.attachmentListTextColor) * 31) + this.navigationButtonBackgroundColor) * 31) + this.focusedStateBorderColor;
    }

    public String toString() {
        return "ArticleContentState(articleData=" + this.articleData + ", textColor=" + this.textColor + ", backgroundColor=" + this.backgroundColor + ", indicatorColor=" + this.indicatorColor + ", status=" + this.status + ", attachmentList=" + this.attachmentList + ", attachmentListTextColor=" + this.attachmentListTextColor + ", navigationButtonBackgroundColor=" + this.navigationButtonBackgroundColor + ", focusedStateBorderColor=" + this.focusedStateBorderColor + ')';
    }

    public ArticleContentState(ArticleData articleData, int i, int i2, int i3, ArticleLoadingStatus status, List<ArticleAttachmentItem> attachmentList, int i4, int i5, int i6) {
        Intrinsics.checkNotNullParameter(status, "status");
        Intrinsics.checkNotNullParameter(attachmentList, "attachmentList");
        this.articleData = articleData;
        this.textColor = i;
        this.backgroundColor = i2;
        this.indicatorColor = i3;
        this.status = status;
        this.attachmentList = attachmentList;
        this.attachmentListTextColor = i4;
        this.navigationButtonBackgroundColor = i5;
        this.focusedStateBorderColor = i6;
    }

    public final ArticleData getArticleData$zendesk_ui_ui_android() {
        return this.articleData;
    }

    public final int getTextColor$zendesk_ui_ui_android() {
        return this.textColor;
    }

    public final int getBackgroundColor$zendesk_ui_ui_android() {
        return this.backgroundColor;
    }

    public final int getIndicatorColor$zendesk_ui_ui_android() {
        return this.indicatorColor;
    }

    public ArticleContentState(ArticleData articleData, int i, int i2, int i3, ArticleLoadingStatus articleLoadingStatus, List list, int i4, int i5, int i6, int i7, DefaultConstructorMarker defaultConstructorMarker) {
        this((i7 & 1) != 0 ? null : articleData, (i7 & 2) != 0 ? 0 : i, (i7 & 4) != 0 ? 0 : i2, (i7 & 8) != 0 ? 0 : i3, (i7 & 16) != 0 ? ArticleLoadingStatus.IDLE : articleLoadingStatus, (i7 & 32) != 0 ? CollectionsKt.emptyList() : list, (i7 & 64) != 0 ? 0 : i4, (i7 & 128) != 0 ? 0 : i5, (i7 & 256) == 0 ? i6 : 0);
    }

    public final ArticleLoadingStatus getStatus$zendesk_ui_ui_android() {
        return this.status;
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

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0006\u001a\u00020\u0000J\u0006\u0010\u0007\u001a\u00020\u0003R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\b"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/articlecontent/ArticleContentState$Builder;", "", "state", "Lzendesk/ui/android/conversation/articleviewer/articlecontent/ArticleContentState;", "(Lzendesk/ui/android/conversation/articleviewer/articlecontent/ArticleContentState;)V", "()V", "articleViewState", "build", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private ArticleContentState state;

        public Builder() {
            this.state = new ArticleContentState(null, 0, 0, 0, null, null, 0, 0, 0, 511, null);
        }

        public Builder(ArticleContentState state) {
            this();
            Intrinsics.checkNotNullParameter(state, "state");
            this.state = state;
        }

        public final Builder articleViewState() {
            this.state = ArticleContentState.copy$default(this.state, null, 0, 0, 0, null, null, 0, 0, 0, 511, null);
            return this;
        }

        public final ArticleContentState getState() {
            return this.state;
        }
    }

    @Metadata(m17d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u000f\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\b\u0087\b\u0018\u00002\u00020\u0001B%\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\u0006\u0010\u0007\u001a\u00020\u0005¢\u0006\u0002\u0010\bJ\t\u0010\u000f\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0010\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0011\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0012\u001a\u00020\u0005HÆ\u0003J1\u0010\u0013\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00052\b\b\u0002\u0010\u0007\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u0014\u001a\u00020\u00152\b\u0010\u0016\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0017\u001a\u00020\u0018HÖ\u0001J\t\u0010\u0019\u001a\u00020\u0005HÖ\u0001R\u0011\u0010\u0007\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u0011\u0010\u0006\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\nR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\rR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\n¨\u0006\u001a"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/articlecontent/ArticleContentState$ArticleData;", "", "htmlUrl", "Landroid/net/Uri;", "title", "", "htmlBody", "baseUrl", "(Landroid/net/Uri;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", "getBaseUrl", "()Ljava/lang/String;", "getHtmlBody", "getHtmlUrl", "()Landroid/net/Uri;", "getTitle", "component1", "component2", "component3", "component4", "copy", "equals", "", "other", "hashCode", "", "toString", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ArticleData {
        public static final int $stable = 8;
        private final String baseUrl;
        private final String htmlBody;
        private final Uri htmlUrl;
        private final String title;

        public static ArticleData copy$default(ArticleData articleData, Uri uri, String str, String str2, String str3, int i, Object obj) {
            if ((i & 1) != 0) {
                uri = articleData.htmlUrl;
            }
            if ((i & 2) != 0) {
                str = articleData.title;
            }
            if ((i & 4) != 0) {
                str2 = articleData.htmlBody;
            }
            if ((i & 8) != 0) {
                str3 = articleData.baseUrl;
            }
            return articleData.copy(uri, str, str2, str3);
        }

        public final Uri getHtmlUrl() {
            return this.htmlUrl;
        }

        public final String getTitle() {
            return this.title;
        }

        public final String getHtmlBody() {
            return this.htmlBody;
        }

        public final String getBaseUrl() {
            return this.baseUrl;
        }

        public final ArticleData copy(Uri htmlUrl, String title, String htmlBody, String baseUrl) {
            Intrinsics.checkNotNullParameter(htmlUrl, "htmlUrl");
            Intrinsics.checkNotNullParameter(title, "title");
            Intrinsics.checkNotNullParameter(htmlBody, "htmlBody");
            Intrinsics.checkNotNullParameter(baseUrl, "baseUrl");
            return new ArticleData(htmlUrl, title, htmlBody, baseUrl);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof ArticleData)) {
                return false;
            }
            ArticleData articleData = (ArticleData) other;
            return Intrinsics.areEqual(this.htmlUrl, articleData.htmlUrl) && Intrinsics.areEqual(this.title, articleData.title) && Intrinsics.areEqual(this.htmlBody, articleData.htmlBody) && Intrinsics.areEqual(this.baseUrl, articleData.baseUrl);
        }

        public int hashCode() {
            return (((((this.htmlUrl.hashCode() * 31) + this.title.hashCode()) * 31) + this.htmlBody.hashCode()) * 31) + this.baseUrl.hashCode();
        }

        public String toString() {
            return "ArticleData(htmlUrl=" + this.htmlUrl + ", title=" + this.title + ", htmlBody=" + this.htmlBody + ", baseUrl=" + this.baseUrl + ')';
        }

        public ArticleData(Uri htmlUrl, String title, String htmlBody, String baseUrl) {
            Intrinsics.checkNotNullParameter(htmlUrl, "htmlUrl");
            Intrinsics.checkNotNullParameter(title, "title");
            Intrinsics.checkNotNullParameter(htmlBody, "htmlBody");
            Intrinsics.checkNotNullParameter(baseUrl, "baseUrl");
            this.htmlUrl = htmlUrl;
            this.title = title;
            this.htmlBody = htmlBody;
            this.baseUrl = baseUrl;
        }

        public final Uri getHtmlUrl() {
            return this.htmlUrl;
        }

        public final String getTitle() {
            return this.title;
        }

        public final String getHtmlBody() {
            return this.htmlBody;
        }

        public final String getBaseUrl() {
            return this.baseUrl;
        }
    }
}
