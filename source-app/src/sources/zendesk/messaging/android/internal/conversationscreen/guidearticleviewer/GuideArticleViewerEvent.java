package zendesk.messaging.android.internal.conversationscreen.guidearticleviewer;

import cz.msebera.android.httpclient.protocol.HTTP;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\bp\u0018\u00002\u00020\u0001:\u0003\u0002\u0003\u0004\u0082\u0001\u0003\u0005\u0006\u0007¨\u0006\b"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerEvent;", "", HTTP.CONN_CLOSE, "LoadUrlInBrowser", "ShareUrl", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerEvent$Close;", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerEvent$LoadUrlInBrowser;", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerEvent$ShareUrl;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface GuideArticleViewerEvent {

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerEvent$LoadUrlInBrowser;", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerEvent;", "url", "", "(Ljava/lang/String;)V", "getUrl", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class LoadUrlInBrowser implements GuideArticleViewerEvent {
        private final String url;

        public static LoadUrlInBrowser copy$default(LoadUrlInBrowser loadUrlInBrowser, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = loadUrlInBrowser.url;
            }
            return loadUrlInBrowser.copy(str);
        }

        public final String getUrl() {
            return this.url;
        }

        public final LoadUrlInBrowser copy(String url) {
            Intrinsics.checkNotNullParameter(url, "url");
            return new LoadUrlInBrowser(url);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof LoadUrlInBrowser) && Intrinsics.areEqual(this.url, ((LoadUrlInBrowser) other).url);
        }

        public int hashCode() {
            return this.url.hashCode();
        }

        public String toString() {
            return "LoadUrlInBrowser(url=" + this.url + ')';
        }

        public LoadUrlInBrowser(String url) {
            Intrinsics.checkNotNullParameter(url, "url");
            this.url = url;
        }

        public final String getUrl() {
            return this.url;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerEvent$ShareUrl;", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerEvent;", "url", "", "(Ljava/lang/String;)V", "getUrl", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ShareUrl implements GuideArticleViewerEvent {
        private final String url;

        public static ShareUrl copy$default(ShareUrl shareUrl, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = shareUrl.url;
            }
            return shareUrl.copy(str);
        }

        public final String getUrl() {
            return this.url;
        }

        public final ShareUrl copy(String url) {
            Intrinsics.checkNotNullParameter(url, "url");
            return new ShareUrl(url);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof ShareUrl) && Intrinsics.areEqual(this.url, ((ShareUrl) other).url);
        }

        public int hashCode() {
            return this.url.hashCode();
        }

        public String toString() {
            return "ShareUrl(url=" + this.url + ')';
        }

        public ShareUrl(String url) {
            Intrinsics.checkNotNullParameter(url, "url");
            this.url = url;
        }

        public final String getUrl() {
            return this.url;
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerEvent$Close;", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerEvent;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Close implements GuideArticleViewerEvent {
        public static final Close INSTANCE = new Close();

        private Close() {
        }
    }
}
