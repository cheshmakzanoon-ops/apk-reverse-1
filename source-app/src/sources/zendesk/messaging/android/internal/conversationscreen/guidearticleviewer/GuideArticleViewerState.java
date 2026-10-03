package zendesk.messaging.android.internal.conversationscreen.guidearticleviewer;

import java.util.List;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.messaging.android.internal.model.MessagingTheme;
import zendesk.p026ui.android.conversation.articleviewer.articleattachmentcarousel.ArticleAttachmentItem;

@Metadata(m17d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010 \n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b0\u0018\u00002\u00020\u0001:\u0004\u0010\u0011\u0012\u0013B%\b\u0004\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0004\u0012\u0006\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJ,\u0010\u000f\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00042\b\b\u0002\u0010\u0006\u001a\u00020\u0007H&R\u001a\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u0014\u0010\u0006\u001a\u00020\u0007X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0014\u0010\u0005\u001a\u00020\u0004X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000e\u0082\u0001\u0004\u0014\u0015\u0016\u0017¨\u0006\u0018"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerState;", "", "backStack", "", "", "url", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "(Ljava/util/List;Ljava/lang/String;Lzendesk/messaging/android/internal/model/MessagingTheme;)V", "getBackStack", "()Ljava/util/List;", "getMessagingTheme", "()Lzendesk/messaging/android/internal/model/MessagingTheme;", "getUrl", "()Ljava/lang/String;", "sealedCopy", "Error", "Idle", "Loading", "SuccessGuideArticle", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerState$Error;", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerState$Idle;", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerState$Loading;", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerState$SuccessGuideArticle;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class GuideArticleViewerState {
    private final List<String> backStack;
    private final MessagingTheme messagingTheme;
    private final String url;

    public GuideArticleViewerState(List list, String str, MessagingTheme messagingTheme, DefaultConstructorMarker defaultConstructorMarker) {
        this(list, str, messagingTheme);
    }

    public abstract GuideArticleViewerState sealedCopy(List<String> backStack, String url, MessagingTheme messagingTheme);

    private GuideArticleViewerState(List<String> list, String str, MessagingTheme messagingTheme) {
        this.backStack = list;
        this.url = str;
        this.messagingTheme = messagingTheme;
    }

    public List<String> getBackStack() {
        return this.backStack;
    }

    public String getUrl() {
        return this.url;
    }

    public MessagingTheme getMessagingTheme() {
        return this.messagingTheme;
    }

    public static GuideArticleViewerState sealedCopy$default(GuideArticleViewerState guideArticleViewerState, List list, String str, MessagingTheme messagingTheme, int i, Object obj) {
        if (obj != null) {
            throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: sealedCopy");
        }
        if ((i & 1) != 0) {
            list = guideArticleViewerState.getBackStack();
        }
        if ((i & 2) != 0) {
            str = guideArticleViewerState.getUrl();
        }
        if ((i & 4) != 0) {
            messagingTheme = guideArticleViewerState.getMessagingTheme();
        }
        return guideArticleViewerState.sealedCopy(list, str, messagingTheme);
    }

    @Metadata(m17d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\f\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\b\u0086\b\u0018\u00002\u00020\u0001B#\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0004\u0012\u0006\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJ\u000f\u0010\u000f\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\t\u0010\u0010\u001a\u00020\u0004HÆ\u0003J\t\u0010\u0011\u001a\u00020\u0007HÆ\u0003J-\u0010\u0012\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00042\b\b\u0002\u0010\u0006\u001a\u00020\u0007HÆ\u0001J\u0013\u0010\u0013\u001a\u00020\u00142\b\u0010\u0015\u001a\u0004\u0018\u00010\u0016HÖ\u0003J\t\u0010\u0017\u001a\u00020\u0018HÖ\u0001J&\u0010\u0019\u001a\u00020\u00012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\u0006\u0010\u0005\u001a\u00020\u00042\u0006\u0010\u0006\u001a\u00020\u0007H\u0016J\t\u0010\u001a\u001a\u00020\u0004HÖ\u0001R\u001a\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u0014\u0010\u0006\u001a\u00020\u0007X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0014\u0010\u0005\u001a\u00020\u0004X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000e¨\u0006\u001b"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerState$Idle;", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerState;", "backStack", "", "", "url", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "(Ljava/util/List;Ljava/lang/String;Lzendesk/messaging/android/internal/model/MessagingTheme;)V", "getBackStack", "()Ljava/util/List;", "getMessagingTheme", "()Lzendesk/messaging/android/internal/model/MessagingTheme;", "getUrl", "()Ljava/lang/String;", "component1", "component2", "component3", "copy", "equals", "", "other", "", "hashCode", "", "sealedCopy", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Idle extends GuideArticleViewerState {
        private final List<String> backStack;
        private final MessagingTheme messagingTheme;
        private final String url;

        public static Idle copy$default(Idle idle, List list, String str, MessagingTheme messagingTheme, int i, Object obj) {
            if ((i & 1) != 0) {
                list = idle.backStack;
            }
            if ((i & 2) != 0) {
                str = idle.url;
            }
            if ((i & 4) != 0) {
                messagingTheme = idle.messagingTheme;
            }
            return idle.copy(list, str, messagingTheme);
        }

        public final List<String> component1() {
            return this.backStack;
        }

        public final String getUrl() {
            return this.url;
        }

        public final MessagingTheme getMessagingTheme() {
            return this.messagingTheme;
        }

        public final Idle copy(List<String> backStack, String url, MessagingTheme messagingTheme) {
            Intrinsics.checkNotNullParameter(backStack, "backStack");
            Intrinsics.checkNotNullParameter(url, "url");
            Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
            return new Idle(backStack, url, messagingTheme);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Idle)) {
                return false;
            }
            Idle idle = (Idle) other;
            return Intrinsics.areEqual(this.backStack, idle.backStack) && Intrinsics.areEqual(this.url, idle.url) && Intrinsics.areEqual(this.messagingTheme, idle.messagingTheme);
        }

        public int hashCode() {
            return (((this.backStack.hashCode() * 31) + this.url.hashCode()) * 31) + this.messagingTheme.hashCode();
        }

        public String toString() {
            return "Idle(backStack=" + this.backStack + ", url=" + this.url + ", messagingTheme=" + this.messagingTheme + ')';
        }

        @Override
        public List<String> getBackStack() {
            return this.backStack;
        }

        @Override
        public String getUrl() {
            return this.url;
        }

        @Override
        public MessagingTheme getMessagingTheme() {
            return this.messagingTheme;
        }

        public Idle(List<String> backStack, String url, MessagingTheme messagingTheme) {
            super(backStack, url, messagingTheme, null);
            Intrinsics.checkNotNullParameter(backStack, "backStack");
            Intrinsics.checkNotNullParameter(url, "url");
            Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
            this.backStack = backStack;
            this.url = url;
            this.messagingTheme = messagingTheme;
        }

        @Override
        public GuideArticleViewerState sealedCopy(List<String> backStack, String url, MessagingTheme messagingTheme) {
            Intrinsics.checkNotNullParameter(backStack, "backStack");
            Intrinsics.checkNotNullParameter(url, "url");
            Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
            return copy(backStack, url, messagingTheme);
        }
    }

    @Metadata(m17d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\f\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\b\u0086\b\u0018\u00002\u00020\u0001B#\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0004\u0012\u0006\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJ\u000f\u0010\u000f\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\t\u0010\u0010\u001a\u00020\u0004HÆ\u0003J\t\u0010\u0011\u001a\u00020\u0007HÆ\u0003J-\u0010\u0012\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00042\b\b\u0002\u0010\u0006\u001a\u00020\u0007HÆ\u0001J\u0013\u0010\u0013\u001a\u00020\u00142\b\u0010\u0015\u001a\u0004\u0018\u00010\u0016HÖ\u0003J\t\u0010\u0017\u001a\u00020\u0018HÖ\u0001J&\u0010\u0019\u001a\u00020\u00012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\u0006\u0010\u0005\u001a\u00020\u00042\u0006\u0010\u0006\u001a\u00020\u0007H\u0016J\t\u0010\u001a\u001a\u00020\u0004HÖ\u0001R\u001a\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u0014\u0010\u0006\u001a\u00020\u0007X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0014\u0010\u0005\u001a\u00020\u0004X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000e¨\u0006\u001b"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerState$Loading;", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerState;", "backStack", "", "", "url", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "(Ljava/util/List;Ljava/lang/String;Lzendesk/messaging/android/internal/model/MessagingTheme;)V", "getBackStack", "()Ljava/util/List;", "getMessagingTheme", "()Lzendesk/messaging/android/internal/model/MessagingTheme;", "getUrl", "()Ljava/lang/String;", "component1", "component2", "component3", "copy", "equals", "", "other", "", "hashCode", "", "sealedCopy", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Loading extends GuideArticleViewerState {
        private final List<String> backStack;
        private final MessagingTheme messagingTheme;
        private final String url;

        public static Loading copy$default(Loading loading, List list, String str, MessagingTheme messagingTheme, int i, Object obj) {
            if ((i & 1) != 0) {
                list = loading.backStack;
            }
            if ((i & 2) != 0) {
                str = loading.url;
            }
            if ((i & 4) != 0) {
                messagingTheme = loading.messagingTheme;
            }
            return loading.copy(list, str, messagingTheme);
        }

        public final List<String> component1() {
            return this.backStack;
        }

        public final String getUrl() {
            return this.url;
        }

        public final MessagingTheme getMessagingTheme() {
            return this.messagingTheme;
        }

        public final Loading copy(List<String> backStack, String url, MessagingTheme messagingTheme) {
            Intrinsics.checkNotNullParameter(backStack, "backStack");
            Intrinsics.checkNotNullParameter(url, "url");
            Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
            return new Loading(backStack, url, messagingTheme);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Loading)) {
                return false;
            }
            Loading loading = (Loading) other;
            return Intrinsics.areEqual(this.backStack, loading.backStack) && Intrinsics.areEqual(this.url, loading.url) && Intrinsics.areEqual(this.messagingTheme, loading.messagingTheme);
        }

        public int hashCode() {
            return (((this.backStack.hashCode() * 31) + this.url.hashCode()) * 31) + this.messagingTheme.hashCode();
        }

        public String toString() {
            return "Loading(backStack=" + this.backStack + ", url=" + this.url + ", messagingTheme=" + this.messagingTheme + ')';
        }

        @Override
        public List<String> getBackStack() {
            return this.backStack;
        }

        @Override
        public String getUrl() {
            return this.url;
        }

        @Override
        public MessagingTheme getMessagingTheme() {
            return this.messagingTheme;
        }

        public Loading(List<String> backStack, String url, MessagingTheme messagingTheme) {
            super(backStack, url, messagingTheme, null);
            Intrinsics.checkNotNullParameter(backStack, "backStack");
            Intrinsics.checkNotNullParameter(url, "url");
            Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
            this.backStack = backStack;
            this.url = url;
            this.messagingTheme = messagingTheme;
        }

        @Override
        public GuideArticleViewerState sealedCopy(List<String> backStack, String url, MessagingTheme messagingTheme) {
            Intrinsics.checkNotNullParameter(backStack, "backStack");
            Intrinsics.checkNotNullParameter(url, "url");
            Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
            return copy(backStack, url, messagingTheme);
        }
    }

    @Metadata(m17d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\f\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\b\u0086\b\u0018\u00002\u00020\u0001B#\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0004\u0012\u0006\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJ\u000f\u0010\u000f\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\t\u0010\u0010\u001a\u00020\u0004HÆ\u0003J\t\u0010\u0011\u001a\u00020\u0007HÆ\u0003J-\u0010\u0012\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00042\b\b\u0002\u0010\u0006\u001a\u00020\u0007HÆ\u0001J\u0013\u0010\u0013\u001a\u00020\u00142\b\u0010\u0015\u001a\u0004\u0018\u00010\u0016HÖ\u0003J\t\u0010\u0017\u001a\u00020\u0018HÖ\u0001J&\u0010\u0019\u001a\u00020\u00012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\u0006\u0010\u0005\u001a\u00020\u00042\u0006\u0010\u0006\u001a\u00020\u0007H\u0016J\t\u0010\u001a\u001a\u00020\u0004HÖ\u0001R\u001a\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u0014\u0010\u0006\u001a\u00020\u0007X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0014\u0010\u0005\u001a\u00020\u0004X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000e¨\u0006\u001b"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerState$Error;", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerState;", "backStack", "", "", "url", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "(Ljava/util/List;Ljava/lang/String;Lzendesk/messaging/android/internal/model/MessagingTheme;)V", "getBackStack", "()Ljava/util/List;", "getMessagingTheme", "()Lzendesk/messaging/android/internal/model/MessagingTheme;", "getUrl", "()Ljava/lang/String;", "component1", "component2", "component3", "copy", "equals", "", "other", "", "hashCode", "", "sealedCopy", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Error extends GuideArticleViewerState {
        private final List<String> backStack;
        private final MessagingTheme messagingTheme;
        private final String url;

        public static Error copy$default(Error error, List list, String str, MessagingTheme messagingTheme, int i, Object obj) {
            if ((i & 1) != 0) {
                list = error.backStack;
            }
            if ((i & 2) != 0) {
                str = error.url;
            }
            if ((i & 4) != 0) {
                messagingTheme = error.messagingTheme;
            }
            return error.copy(list, str, messagingTheme);
        }

        public final List<String> component1() {
            return this.backStack;
        }

        public final String getUrl() {
            return this.url;
        }

        public final MessagingTheme getMessagingTheme() {
            return this.messagingTheme;
        }

        public final Error copy(List<String> backStack, String url, MessagingTheme messagingTheme) {
            Intrinsics.checkNotNullParameter(backStack, "backStack");
            Intrinsics.checkNotNullParameter(url, "url");
            Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
            return new Error(backStack, url, messagingTheme);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Error)) {
                return false;
            }
            Error error = (Error) other;
            return Intrinsics.areEqual(this.backStack, error.backStack) && Intrinsics.areEqual(this.url, error.url) && Intrinsics.areEqual(this.messagingTheme, error.messagingTheme);
        }

        public int hashCode() {
            return (((this.backStack.hashCode() * 31) + this.url.hashCode()) * 31) + this.messagingTheme.hashCode();
        }

        public String toString() {
            return "Error(backStack=" + this.backStack + ", url=" + this.url + ", messagingTheme=" + this.messagingTheme + ')';
        }

        @Override
        public List<String> getBackStack() {
            return this.backStack;
        }

        @Override
        public String getUrl() {
            return this.url;
        }

        @Override
        public MessagingTheme getMessagingTheme() {
            return this.messagingTheme;
        }

        public Error(List<String> backStack, String url, MessagingTheme messagingTheme) {
            super(backStack, url, messagingTheme, null);
            Intrinsics.checkNotNullParameter(backStack, "backStack");
            Intrinsics.checkNotNullParameter(url, "url");
            Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
            this.backStack = backStack;
            this.url = url;
            this.messagingTheme = messagingTheme;
        }

        @Override
        public GuideArticleViewerState sealedCopy(List<String> backStack, String url, MessagingTheme messagingTheme) {
            Intrinsics.checkNotNullParameter(backStack, "backStack");
            Intrinsics.checkNotNullParameter(url, "url");
            Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
            return copy(backStack, url, messagingTheme);
        }
    }

    @Metadata(m17d1 = {"\u00008\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0012\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\b\u0086\b\u0018\u00002\u00020\u0001BA\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0004\u0012\u0006\u0010\u0006\u001a\u00020\u0004\u0012\u0006\u0010\u0007\u001a\u00020\u0004\u0012\f\u0010\b\u001a\b\u0012\u0004\u0012\u00020\t0\u0003\u0012\u0006\u0010\n\u001a\u00020\u000b¢\u0006\u0002\u0010\fJ\u000f\u0010\u0016\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\t\u0010\u0017\u001a\u00020\u0004HÆ\u0003J\t\u0010\u0018\u001a\u00020\u0004HÆ\u0003J\t\u0010\u0019\u001a\u00020\u0004HÆ\u0003J\u000f\u0010\u001a\u001a\b\u0012\u0004\u0012\u00020\t0\u0003HÆ\u0003J\t\u0010\u001b\u001a\u00020\u000bHÆ\u0003JQ\u0010\u001c\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00042\b\b\u0002\u0010\u0006\u001a\u00020\u00042\b\b\u0002\u0010\u0007\u001a\u00020\u00042\u000e\b\u0002\u0010\b\u001a\b\u0012\u0004\u0012\u00020\t0\u00032\b\b\u0002\u0010\n\u001a\u00020\u000bHÆ\u0001J\u0013\u0010\u001d\u001a\u00020\u001e2\b\u0010\u001f\u001a\u0004\u0018\u00010 HÖ\u0003J\t\u0010!\u001a\u00020\"HÖ\u0001J&\u0010#\u001a\u00020\u00012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\u0006\u0010\u0005\u001a\u00020\u00042\u0006\u0010\n\u001a\u00020\u000bH\u0016J\t\u0010$\u001a\u00020\u0004HÖ\u0001R\u0017\u0010\b\u001a\b\u0012\u0004\u0012\u00020\t0\u0003¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u001a\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u000eR\u0011\u0010\u0007\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0011R\u0014\u0010\n\u001a\u00020\u000bX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0013R\u0011\u0010\u0006\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0011R\u0014\u0010\u0005\u001a\u00020\u0004X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0011¨\u0006%"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerState$SuccessGuideArticle;", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerState;", "backStack", "", "", "url", "title", "htmlBody", "attachments", "Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentItem;", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "(Ljava/util/List;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/List;Lzendesk/messaging/android/internal/model/MessagingTheme;)V", "getAttachments", "()Ljava/util/List;", "getBackStack", "getHtmlBody", "()Ljava/lang/String;", "getMessagingTheme", "()Lzendesk/messaging/android/internal/model/MessagingTheme;", "getTitle", "getUrl", "component1", "component2", "component3", "component4", "component5", "component6", "copy", "equals", "", "other", "", "hashCode", "", "sealedCopy", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class SuccessGuideArticle extends GuideArticleViewerState {
        private final List<ArticleAttachmentItem> attachments;
        private final List<String> backStack;
        private final String htmlBody;
        private final MessagingTheme messagingTheme;
        private final String title;
        private final String url;

        public static SuccessGuideArticle copy$default(SuccessGuideArticle successGuideArticle, List list, String str, String str2, String str3, List list2, MessagingTheme messagingTheme, int i, Object obj) {
            if ((i & 1) != 0) {
                list = successGuideArticle.backStack;
            }
            if ((i & 2) != 0) {
                str = successGuideArticle.url;
            }
            String str4 = str;
            if ((i & 4) != 0) {
                str2 = successGuideArticle.title;
            }
            String str5 = str2;
            if ((i & 8) != 0) {
                str3 = successGuideArticle.htmlBody;
            }
            String str6 = str3;
            if ((i & 16) != 0) {
                list2 = successGuideArticle.attachments;
            }
            List list3 = list2;
            if ((i & 32) != 0) {
                messagingTheme = successGuideArticle.messagingTheme;
            }
            return successGuideArticle.copy(list, str4, str5, str6, list3, messagingTheme);
        }

        public final List<String> component1() {
            return this.backStack;
        }

        public final String getUrl() {
            return this.url;
        }

        public final String getTitle() {
            return this.title;
        }

        public final String getHtmlBody() {
            return this.htmlBody;
        }

        public final List<ArticleAttachmentItem> component5() {
            return this.attachments;
        }

        public final MessagingTheme getMessagingTheme() {
            return this.messagingTheme;
        }

        public final SuccessGuideArticle copy(List<String> backStack, String url, String title, String htmlBody, List<ArticleAttachmentItem> attachments, MessagingTheme messagingTheme) {
            Intrinsics.checkNotNullParameter(backStack, "backStack");
            Intrinsics.checkNotNullParameter(url, "url");
            Intrinsics.checkNotNullParameter(title, "title");
            Intrinsics.checkNotNullParameter(htmlBody, "htmlBody");
            Intrinsics.checkNotNullParameter(attachments, "attachments");
            Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
            return new SuccessGuideArticle(backStack, url, title, htmlBody, attachments, messagingTheme);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof SuccessGuideArticle)) {
                return false;
            }
            SuccessGuideArticle successGuideArticle = (SuccessGuideArticle) other;
            return Intrinsics.areEqual(this.backStack, successGuideArticle.backStack) && Intrinsics.areEqual(this.url, successGuideArticle.url) && Intrinsics.areEqual(this.title, successGuideArticle.title) && Intrinsics.areEqual(this.htmlBody, successGuideArticle.htmlBody) && Intrinsics.areEqual(this.attachments, successGuideArticle.attachments) && Intrinsics.areEqual(this.messagingTheme, successGuideArticle.messagingTheme);
        }

        public int hashCode() {
            return (((((((((this.backStack.hashCode() * 31) + this.url.hashCode()) * 31) + this.title.hashCode()) * 31) + this.htmlBody.hashCode()) * 31) + this.attachments.hashCode()) * 31) + this.messagingTheme.hashCode();
        }

        public String toString() {
            return "SuccessGuideArticle(backStack=" + this.backStack + ", url=" + this.url + ", title=" + this.title + ", htmlBody=" + this.htmlBody + ", attachments=" + this.attachments + ", messagingTheme=" + this.messagingTheme + ')';
        }

        @Override
        public List<String> getBackStack() {
            return this.backStack;
        }

        @Override
        public String getUrl() {
            return this.url;
        }

        public final String getTitle() {
            return this.title;
        }

        public final String getHtmlBody() {
            return this.htmlBody;
        }

        public final List<ArticleAttachmentItem> getAttachments() {
            return this.attachments;
        }

        @Override
        public MessagingTheme getMessagingTheme() {
            return this.messagingTheme;
        }

        public SuccessGuideArticle(List<String> backStack, String url, String title, String htmlBody, List<ArticleAttachmentItem> attachments, MessagingTheme messagingTheme) {
            super(backStack, url, messagingTheme, null);
            Intrinsics.checkNotNullParameter(backStack, "backStack");
            Intrinsics.checkNotNullParameter(url, "url");
            Intrinsics.checkNotNullParameter(title, "title");
            Intrinsics.checkNotNullParameter(htmlBody, "htmlBody");
            Intrinsics.checkNotNullParameter(attachments, "attachments");
            Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
            this.backStack = backStack;
            this.url = url;
            this.title = title;
            this.htmlBody = htmlBody;
            this.attachments = attachments;
            this.messagingTheme = messagingTheme;
        }

        @Override
        public GuideArticleViewerState sealedCopy(List<String> backStack, String url, MessagingTheme messagingTheme) {
            Intrinsics.checkNotNullParameter(backStack, "backStack");
            Intrinsics.checkNotNullParameter(url, "url");
            Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
            return copy$default(this, backStack, url, null, null, null, messagingTheme, 28, null);
        }
    }
}
