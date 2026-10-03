package zendesk.messaging.android.internal.conversationscreen.guidearticleviewer;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.messaging.android.internal.model.MessagingTheme;
import zendesk.p026ui.android.conversation.articleviewer.articleattachmentcarousel.ArticleAttachmentItem;

@Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\bp\u0018\u00002\u00020\u0001:\u0006\u0002\u0003\u0004\u0005\u0006\u0007\u0082\u0001\u0006\b\t\n\u000b\f\r¨\u0006\u000e"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerAction;", "", "Back", "Load", "OpenAttachment", "RefreshTheme", "Reload", "Share", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerAction$Back;", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerAction$Load;", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerAction$OpenAttachment;", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerAction$RefreshTheme;", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerAction$Reload;", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerAction$Share;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface GuideArticleViewerAction {

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerAction$Back;", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerAction;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Back implements GuideArticleViewerAction {
        public static final Back INSTANCE = new Back();

        private Back() {
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerAction$Load;", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerAction;", "url", "", "(Ljava/lang/String;)V", "getUrl", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Load implements GuideArticleViewerAction {
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

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerAction$RefreshTheme;", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerAction;", "theme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "(Lzendesk/messaging/android/internal/model/MessagingTheme;)V", "getTheme", "()Lzendesk/messaging/android/internal/model/MessagingTheme;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class RefreshTheme implements GuideArticleViewerAction {
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

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerAction$Reload;", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerAction;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Reload implements GuideArticleViewerAction {
        public static final Reload INSTANCE = new Reload();

        private Reload() {
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerAction$OpenAttachment;", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerAction;", "attachment", "Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentItem;", "(Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentItem;)V", "getAttachment", "()Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentItem;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class OpenAttachment implements GuideArticleViewerAction {
        private final ArticleAttachmentItem attachment;

        public static OpenAttachment copy$default(OpenAttachment openAttachment, ArticleAttachmentItem articleAttachmentItem, int i, Object obj) {
            if ((i & 1) != 0) {
                articleAttachmentItem = openAttachment.attachment;
            }
            return openAttachment.copy(articleAttachmentItem);
        }

        public final ArticleAttachmentItem getAttachment() {
            return this.attachment;
        }

        public final OpenAttachment copy(ArticleAttachmentItem attachment) {
            Intrinsics.checkNotNullParameter(attachment, "attachment");
            return new OpenAttachment(attachment);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof OpenAttachment) && Intrinsics.areEqual(this.attachment, ((OpenAttachment) other).attachment);
        }

        public int hashCode() {
            return this.attachment.hashCode();
        }

        public String toString() {
            return "OpenAttachment(attachment=" + this.attachment + ')';
        }

        public OpenAttachment(ArticleAttachmentItem attachment) {
            Intrinsics.checkNotNullParameter(attachment, "attachment");
            this.attachment = attachment;
        }

        public final ArticleAttachmentItem getAttachment() {
            return this.attachment;
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerAction$Share;", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerAction;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Share implements GuideArticleViewerAction {
        public static final Share INSTANCE = new Share();

        private Share() {
        }
    }
}
