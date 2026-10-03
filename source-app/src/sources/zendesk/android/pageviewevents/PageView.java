package zendesk.android.pageviewevents;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003¢\u0006\u0002\u0010\u0005J\t\u0010\t\u001a\u00020\u0003HÆ\u0003J\t\u0010\n\u001a\u00020\u0003HÆ\u0003J\u001d\u0010\u000b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\f\u001a\u00020\r2\b\u0010\u000e\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001J\t\u0010\u0011\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0004\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\u0007¨\u0006\u0012"}, m18d2 = {"Lzendesk/android/pageviewevents/PageView;", "", "url", "", "pageTitle", "(Ljava/lang/String;Ljava/lang/String;)V", "getPageTitle", "()Ljava/lang/String;", "getUrl", "component1", "component2", "copy", "equals", "", "other", "hashCode", "", "toString", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class PageView {
    private final String pageTitle;
    private final String url;

    public static PageView copy$default(PageView pageView, String str, String str2, int i, Object obj) {
        if ((i & 1) != 0) {
            str = pageView.url;
        }
        if ((i & 2) != 0) {
            str2 = pageView.pageTitle;
        }
        return pageView.copy(str, str2);
    }

    public final String getUrl() {
        return this.url;
    }

    public final String getPageTitle() {
        return this.pageTitle;
    }

    public final PageView copy(String url, String pageTitle) {
        Intrinsics.checkNotNullParameter(url, "url");
        Intrinsics.checkNotNullParameter(pageTitle, "pageTitle");
        return new PageView(url, pageTitle);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof PageView)) {
            return false;
        }
        PageView pageView = (PageView) other;
        return Intrinsics.areEqual(this.url, pageView.url) && Intrinsics.areEqual(this.pageTitle, pageView.pageTitle);
    }

    public int hashCode() {
        return (this.url.hashCode() * 31) + this.pageTitle.hashCode();
    }

    public String toString() {
        return "PageView(url=" + this.url + ", pageTitle=" + this.pageTitle + ')';
    }

    public PageView(String url, String pageTitle) {
        Intrinsics.checkNotNullParameter(url, "url");
        Intrinsics.checkNotNullParameter(pageTitle, "pageTitle");
        this.url = url;
        this.pageTitle = pageTitle;
    }

    public final String getPageTitle() {
        return this.pageTitle;
    }

    public final String getUrl() {
        return this.url;
    }
}
