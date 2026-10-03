package zendesk.messaging.android.internal.conversationscreen.conversationextension;

import cz.msebera.android.httpclient.protocol.HTTP;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.messaging.android.internal.model.MessagingTheme;

@Metadata(m17d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\bp\u0018\u00002\u00020\u0001:\t\u0002\u0003\u0004\u0005\u0006\u0007\b\t\n\u0082\u0001\t\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013¨\u0006\u0014"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction;", "", "Back", HTTP.CONN_CLOSE, "Load", "LoadingComplete", "RefreshTheme", "Reload", "UpdateTitle", "UpdateUrl", "WebViewError", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction$Back;", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction$Close;", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction$Load;", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction$LoadingComplete;", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction$RefreshTheme;", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction$Reload;", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction$UpdateTitle;", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction$UpdateUrl;", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction$WebViewError;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface ConversationExtensionAction {

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction$Load;", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction;", "url", "", "(Ljava/lang/String;)V", "getUrl", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Load implements ConversationExtensionAction {
        private final String url;

        public static Load copy$default(Load load, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = load.url;
            }
            return load.copy(str);
        }

        public final String getUrl() {
            return this.url;
        }

        public final Load copy(String url) {
            Intrinsics.checkNotNullParameter(url, "url");
            return new Load(url);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof Load) && Intrinsics.areEqual(this.url, ((Load) other).url);
        }

        public int hashCode() {
            return this.url.hashCode();
        }

        public String toString() {
            return "Load(url=" + this.url + ')';
        }

        public Load(String url) {
            Intrinsics.checkNotNullParameter(url, "url");
            this.url = url;
        }

        public final String getUrl() {
            return this.url;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction$RefreshTheme;", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction;", "theme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "(Lzendesk/messaging/android/internal/model/MessagingTheme;)V", "getTheme", "()Lzendesk/messaging/android/internal/model/MessagingTheme;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class RefreshTheme implements ConversationExtensionAction {
        private final MessagingTheme theme;

        public static RefreshTheme copy$default(RefreshTheme refreshTheme, MessagingTheme messagingTheme, int i, Object obj) {
            if ((i & 1) != 0) {
                messagingTheme = refreshTheme.theme;
            }
            return refreshTheme.copy(messagingTheme);
        }

        public final MessagingTheme getTheme() {
            return this.theme;
        }

        public final RefreshTheme copy(MessagingTheme theme) {
            Intrinsics.checkNotNullParameter(theme, "theme");
            return new RefreshTheme(theme);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof RefreshTheme) && Intrinsics.areEqual(this.theme, ((RefreshTheme) other).theme);
        }

        public int hashCode() {
            return this.theme.hashCode();
        }

        public String toString() {
            return "RefreshTheme(theme=" + this.theme + ')';
        }

        public RefreshTheme(MessagingTheme theme) {
            Intrinsics.checkNotNullParameter(theme, "theme");
            this.theme = theme;
        }

        public final MessagingTheme getTheme() {
            return this.theme;
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction$Reload;", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Reload implements ConversationExtensionAction {
        public static final Reload INSTANCE = new Reload();

        private Reload() {
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u000f\u0012\b\u0010\u0002\u001a\u0004\u0018\u00010\u0003¢\u0006\u0002\u0010\u0004J\u000b\u0010\u0007\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\u0015\u0010\b\u001a\u00020\u00002\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001R\u0013\u0010\u0002\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction$UpdateTitle;", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction;", "title", "", "(Ljava/lang/String;)V", "getTitle", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class UpdateTitle implements ConversationExtensionAction {
        private final String title;

        public static UpdateTitle copy$default(UpdateTitle updateTitle, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = updateTitle.title;
            }
            return updateTitle.copy(str);
        }

        public final String getTitle() {
            return this.title;
        }

        public final UpdateTitle copy(String title) {
            return new UpdateTitle(title);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof UpdateTitle) && Intrinsics.areEqual(this.title, ((UpdateTitle) other).title);
        }

        public int hashCode() {
            String str = this.title;
            if (str == null) {
                return 0;
            }
            return str.hashCode();
        }

        public String toString() {
            return "UpdateTitle(title=" + this.title + ')';
        }

        public UpdateTitle(String str) {
            this.title = str;
        }

        public final String getTitle() {
            return this.title;
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction$WebViewError;", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class WebViewError implements ConversationExtensionAction {
        public static final WebViewError INSTANCE = new WebViewError();

        private WebViewError() {
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction$Close;", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Close implements ConversationExtensionAction {
        public static final Close INSTANCE = new Close();

        private Close() {
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction$UpdateUrl;", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction;", "url", "", "(Ljava/lang/String;)V", "getUrl", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class UpdateUrl implements ConversationExtensionAction {
        private final String url;

        public static UpdateUrl copy$default(UpdateUrl updateUrl, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = updateUrl.url;
            }
            return updateUrl.copy(str);
        }

        public final String getUrl() {
            return this.url;
        }

        public final UpdateUrl copy(String url) {
            Intrinsics.checkNotNullParameter(url, "url");
            return new UpdateUrl(url);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof UpdateUrl) && Intrinsics.areEqual(this.url, ((UpdateUrl) other).url);
        }

        public int hashCode() {
            return this.url.hashCode();
        }

        public String toString() {
            return "UpdateUrl(url=" + this.url + ')';
        }

        public UpdateUrl(String url) {
            Intrinsics.checkNotNullParameter(url, "url");
            this.url = url;
        }

        public final String getUrl() {
            return this.url;
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction$LoadingComplete;", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class LoadingComplete implements ConversationExtensionAction {
        public static final LoadingComplete INSTANCE = new LoadingComplete();

        private LoadingComplete() {
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction$Back;", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Back implements ConversationExtensionAction {
        public static final Back INSTANCE = new Back();

        private Back() {
        }
    }
}
