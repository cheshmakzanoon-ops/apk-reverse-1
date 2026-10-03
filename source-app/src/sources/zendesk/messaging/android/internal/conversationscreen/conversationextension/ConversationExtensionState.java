package zendesk.messaging.android.internal.conversationscreen.conversationextension;

import java.util.List;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.messaging.android.internal.model.MessagingTheme;

@Metadata(m17d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010 \n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u000f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b0\u0018\u00002\u00020\u0001:\u0004\u0014\u0015\u0016\u0017B5\b\u0004\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0004\u0012\u0006\u0010\u0006\u001a\u00020\u0004\u0012\u0006\u0010\u0007\u001a\u00020\b\u0012\u0006\u0010\t\u001a\u00020\u0004¢\u0006\u0002\u0010\nJ@\u0010\u0013\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00042\b\b\u0002\u0010\u0006\u001a\u00020\u00042\b\b\u0002\u0010\u0007\u001a\u00020\b2\b\b\u0002\u0010\t\u001a\u00020\u0004H&R\u001a\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0014\u0010\u0007\u001a\u00020\bX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u0014\u0010\u0006\u001a\u00020\u0004X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u0014\u0010\t\u001a\u00020\u0004X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0010R\u0014\u0010\u0005\u001a\u00020\u0004X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0010\u0082\u0001\u0004\u0018\u0019\u001a\u001b¨\u0006\u001c"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionState;", "", "backStack", "", "", "url", "size", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "title", "(Ljava/util/List;Ljava/lang/String;Ljava/lang/String;Lzendesk/messaging/android/internal/model/MessagingTheme;Ljava/lang/String;)V", "getBackStack", "()Ljava/util/List;", "getMessagingTheme", "()Lzendesk/messaging/android/internal/model/MessagingTheme;", "getSize", "()Ljava/lang/String;", "getTitle", "getUrl", "sealedCopy", "Error", "Idle", "Loading", "Success", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionState$Error;", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionState$Idle;", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionState$Loading;", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionState$Success;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class ConversationExtensionState {
    private final List<String> backStack;
    private final MessagingTheme messagingTheme;
    private final String size;
    private final String title;
    private final String url;

    public ConversationExtensionState(List list, String str, String str2, MessagingTheme messagingTheme, String str3, DefaultConstructorMarker defaultConstructorMarker) {
        this(list, str, str2, messagingTheme, str3);
    }

    public abstract ConversationExtensionState sealedCopy(List<String> backStack, String url, String size, MessagingTheme messagingTheme, String title);

    private ConversationExtensionState(List<String> list, String str, String str2, MessagingTheme messagingTheme, String str3) {
        this.backStack = list;
        this.url = str;
        this.size = str2;
        this.messagingTheme = messagingTheme;
        this.title = str3;
    }

    public List<String> getBackStack() {
        return this.backStack;
    }

    public String getUrl() {
        return this.url;
    }

    public String getSize() {
        return this.size;
    }

    public MessagingTheme getMessagingTheme() {
        return this.messagingTheme;
    }

    public String getTitle() {
        return this.title;
    }

    public static ConversationExtensionState sealedCopy$default(ConversationExtensionState conversationExtensionState, List list, String str, String str2, MessagingTheme messagingTheme, String str3, int i, Object obj) {
        if (obj != null) {
            throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: sealedCopy");
        }
        if ((i & 1) != 0) {
            list = conversationExtensionState.getBackStack();
        }
        if ((i & 2) != 0) {
            str = conversationExtensionState.getUrl();
        }
        String str4 = str;
        if ((i & 4) != 0) {
            str2 = conversationExtensionState.getSize();
        }
        String str5 = str2;
        if ((i & 8) != 0) {
            messagingTheme = conversationExtensionState.getMessagingTheme();
        }
        MessagingTheme messagingTheme2 = messagingTheme;
        if ((i & 16) != 0) {
            str3 = conversationExtensionState.getTitle();
        }
        return conversationExtensionState.sealedCopy(list, str4, str5, messagingTheme2, str3);
    }

    @Metadata(m17d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0011\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\b\u0086\b\u0018\u00002\u00020\u0001B3\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0004\u0012\u0006\u0010\u0006\u001a\u00020\u0004\u0012\u0006\u0010\u0007\u001a\u00020\b\u0012\u0006\u0010\t\u001a\u00020\u0004¢\u0006\u0002\u0010\nJ\u000f\u0010\u0013\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\t\u0010\u0014\u001a\u00020\u0004HÆ\u0003J\t\u0010\u0015\u001a\u00020\u0004HÆ\u0003J\t\u0010\u0016\u001a\u00020\bHÆ\u0003J\t\u0010\u0017\u001a\u00020\u0004HÆ\u0003JA\u0010\u0018\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00042\b\b\u0002\u0010\u0006\u001a\u00020\u00042\b\b\u0002\u0010\u0007\u001a\u00020\b2\b\b\u0002\u0010\t\u001a\u00020\u0004HÆ\u0001J\u0013\u0010\u0019\u001a\u00020\u001a2\b\u0010\u001b\u001a\u0004\u0018\u00010\u001cHÖ\u0003J\t\u0010\u001d\u001a\u00020\u001eHÖ\u0001J6\u0010\u001f\u001a\u00020\u00012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\u0006\u0010\u0005\u001a\u00020\u00042\u0006\u0010\u0006\u001a\u00020\u00042\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\u0004H\u0016J\t\u0010 \u001a\u00020\u0004HÖ\u0001R\u001a\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0014\u0010\u0007\u001a\u00020\bX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u0014\u0010\u0006\u001a\u00020\u0004X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u0014\u0010\t\u001a\u00020\u0004X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0010R\u0014\u0010\u0005\u001a\u00020\u0004X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0010¨\u0006!"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionState$Idle;", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionState;", "backStack", "", "", "url", "size", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "title", "(Ljava/util/List;Ljava/lang/String;Ljava/lang/String;Lzendesk/messaging/android/internal/model/MessagingTheme;Ljava/lang/String;)V", "getBackStack", "()Ljava/util/List;", "getMessagingTheme", "()Lzendesk/messaging/android/internal/model/MessagingTheme;", "getSize", "()Ljava/lang/String;", "getTitle", "getUrl", "component1", "component2", "component3", "component4", "component5", "copy", "equals", "", "other", "", "hashCode", "", "sealedCopy", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Idle extends ConversationExtensionState {
        private final List<String> backStack;
        private final MessagingTheme messagingTheme;
        private final String size;
        private final String title;
        private final String url;

        public static Idle copy$default(Idle idle, List list, String str, String str2, MessagingTheme messagingTheme, String str3, int i, Object obj) {
            if ((i & 1) != 0) {
                list = idle.backStack;
            }
            if ((i & 2) != 0) {
                str = idle.url;
            }
            String str4 = str;
            if ((i & 4) != 0) {
                str2 = idle.size;
            }
            String str5 = str2;
            if ((i & 8) != 0) {
                messagingTheme = idle.messagingTheme;
            }
            MessagingTheme messagingTheme2 = messagingTheme;
            if ((i & 16) != 0) {
                str3 = idle.title;
            }
            return idle.copy(list, str4, str5, messagingTheme2, str3);
        }

        public final List<String> component1() {
            return this.backStack;
        }

        public final String getUrl() {
            return this.url;
        }

        public final String getSize() {
            return this.size;
        }

        public final MessagingTheme getMessagingTheme() {
            return this.messagingTheme;
        }

        public final String getTitle() {
            return this.title;
        }

        public final Idle copy(List<String> backStack, String url, String size, MessagingTheme messagingTheme, String title) {
            Intrinsics.checkNotNullParameter(backStack, "backStack");
            Intrinsics.checkNotNullParameter(url, "url");
            Intrinsics.checkNotNullParameter(size, "size");
            Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
            Intrinsics.checkNotNullParameter(title, "title");
            return new Idle(backStack, url, size, messagingTheme, title);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Idle)) {
                return false;
            }
            Idle idle = (Idle) other;
            return Intrinsics.areEqual(this.backStack, idle.backStack) && Intrinsics.areEqual(this.url, idle.url) && Intrinsics.areEqual(this.size, idle.size) && Intrinsics.areEqual(this.messagingTheme, idle.messagingTheme) && Intrinsics.areEqual(this.title, idle.title);
        }

        public int hashCode() {
            return (((((((this.backStack.hashCode() * 31) + this.url.hashCode()) * 31) + this.size.hashCode()) * 31) + this.messagingTheme.hashCode()) * 31) + this.title.hashCode();
        }

        public String toString() {
            return "Idle(backStack=" + this.backStack + ", url=" + this.url + ", size=" + this.size + ", messagingTheme=" + this.messagingTheme + ", title=" + this.title + ')';
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
        public String getSize() {
            return this.size;
        }

        @Override
        public MessagingTheme getMessagingTheme() {
            return this.messagingTheme;
        }

        @Override
        public String getTitle() {
            return this.title;
        }

        public Idle(List<String> backStack, String url, String size, MessagingTheme messagingTheme, String title) {
            super(backStack, url, size, messagingTheme, title, null);
            Intrinsics.checkNotNullParameter(backStack, "backStack");
            Intrinsics.checkNotNullParameter(url, "url");
            Intrinsics.checkNotNullParameter(size, "size");
            Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
            Intrinsics.checkNotNullParameter(title, "title");
            this.backStack = backStack;
            this.url = url;
            this.size = size;
            this.messagingTheme = messagingTheme;
            this.title = title;
        }

        @Override
        public ConversationExtensionState sealedCopy(List<String> backStack, String url, String size, MessagingTheme messagingTheme, String title) {
            Intrinsics.checkNotNullParameter(backStack, "backStack");
            Intrinsics.checkNotNullParameter(url, "url");
            Intrinsics.checkNotNullParameter(size, "size");
            Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
            Intrinsics.checkNotNullParameter(title, "title");
            return copy(backStack, url, size, messagingTheme, title);
        }
    }

    @Metadata(m17d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0011\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\b\u0086\b\u0018\u00002\u00020\u0001B3\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0004\u0012\u0006\u0010\u0006\u001a\u00020\u0004\u0012\u0006\u0010\u0007\u001a\u00020\b\u0012\u0006\u0010\t\u001a\u00020\u0004¢\u0006\u0002\u0010\nJ\u000f\u0010\u0013\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\t\u0010\u0014\u001a\u00020\u0004HÆ\u0003J\t\u0010\u0015\u001a\u00020\u0004HÆ\u0003J\t\u0010\u0016\u001a\u00020\bHÆ\u0003J\t\u0010\u0017\u001a\u00020\u0004HÆ\u0003JA\u0010\u0018\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00042\b\b\u0002\u0010\u0006\u001a\u00020\u00042\b\b\u0002\u0010\u0007\u001a\u00020\b2\b\b\u0002\u0010\t\u001a\u00020\u0004HÆ\u0001J\u0013\u0010\u0019\u001a\u00020\u001a2\b\u0010\u001b\u001a\u0004\u0018\u00010\u001cHÖ\u0003J\t\u0010\u001d\u001a\u00020\u001eHÖ\u0001J6\u0010\u001f\u001a\u00020\u00012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\u0006\u0010\u0005\u001a\u00020\u00042\u0006\u0010\u0006\u001a\u00020\u00042\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\u0004H\u0016J\t\u0010 \u001a\u00020\u0004HÖ\u0001R\u001a\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0014\u0010\u0007\u001a\u00020\bX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u0014\u0010\u0006\u001a\u00020\u0004X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u0014\u0010\t\u001a\u00020\u0004X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0010R\u0014\u0010\u0005\u001a\u00020\u0004X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0010¨\u0006!"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionState$Error;", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionState;", "backStack", "", "", "url", "size", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "title", "(Ljava/util/List;Ljava/lang/String;Ljava/lang/String;Lzendesk/messaging/android/internal/model/MessagingTheme;Ljava/lang/String;)V", "getBackStack", "()Ljava/util/List;", "getMessagingTheme", "()Lzendesk/messaging/android/internal/model/MessagingTheme;", "getSize", "()Ljava/lang/String;", "getTitle", "getUrl", "component1", "component2", "component3", "component4", "component5", "copy", "equals", "", "other", "", "hashCode", "", "sealedCopy", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Error extends ConversationExtensionState {
        private final List<String> backStack;
        private final MessagingTheme messagingTheme;
        private final String size;
        private final String title;
        private final String url;

        public static Error copy$default(Error error, List list, String str, String str2, MessagingTheme messagingTheme, String str3, int i, Object obj) {
            if ((i & 1) != 0) {
                list = error.backStack;
            }
            if ((i & 2) != 0) {
                str = error.url;
            }
            String str4 = str;
            if ((i & 4) != 0) {
                str2 = error.size;
            }
            String str5 = str2;
            if ((i & 8) != 0) {
                messagingTheme = error.messagingTheme;
            }
            MessagingTheme messagingTheme2 = messagingTheme;
            if ((i & 16) != 0) {
                str3 = error.title;
            }
            return error.copy(list, str4, str5, messagingTheme2, str3);
        }

        public final List<String> component1() {
            return this.backStack;
        }

        public final String getUrl() {
            return this.url;
        }

        public final String getSize() {
            return this.size;
        }

        public final MessagingTheme getMessagingTheme() {
            return this.messagingTheme;
        }

        public final String getTitle() {
            return this.title;
        }

        public final Error copy(List<String> backStack, String url, String size, MessagingTheme messagingTheme, String title) {
            Intrinsics.checkNotNullParameter(backStack, "backStack");
            Intrinsics.checkNotNullParameter(url, "url");
            Intrinsics.checkNotNullParameter(size, "size");
            Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
            Intrinsics.checkNotNullParameter(title, "title");
            return new Error(backStack, url, size, messagingTheme, title);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Error)) {
                return false;
            }
            Error error = (Error) other;
            return Intrinsics.areEqual(this.backStack, error.backStack) && Intrinsics.areEqual(this.url, error.url) && Intrinsics.areEqual(this.size, error.size) && Intrinsics.areEqual(this.messagingTheme, error.messagingTheme) && Intrinsics.areEqual(this.title, error.title);
        }

        public int hashCode() {
            return (((((((this.backStack.hashCode() * 31) + this.url.hashCode()) * 31) + this.size.hashCode()) * 31) + this.messagingTheme.hashCode()) * 31) + this.title.hashCode();
        }

        public String toString() {
            return "Error(backStack=" + this.backStack + ", url=" + this.url + ", size=" + this.size + ", messagingTheme=" + this.messagingTheme + ", title=" + this.title + ')';
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
        public String getSize() {
            return this.size;
        }

        @Override
        public MessagingTheme getMessagingTheme() {
            return this.messagingTheme;
        }

        @Override
        public String getTitle() {
            return this.title;
        }

        public Error(List<String> backStack, String url, String size, MessagingTheme messagingTheme, String title) {
            super(backStack, url, size, messagingTheme, title, null);
            Intrinsics.checkNotNullParameter(backStack, "backStack");
            Intrinsics.checkNotNullParameter(url, "url");
            Intrinsics.checkNotNullParameter(size, "size");
            Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
            Intrinsics.checkNotNullParameter(title, "title");
            this.backStack = backStack;
            this.url = url;
            this.size = size;
            this.messagingTheme = messagingTheme;
            this.title = title;
        }

        @Override
        public ConversationExtensionState sealedCopy(List<String> backStack, String url, String size, MessagingTheme messagingTheme, String title) {
            Intrinsics.checkNotNullParameter(backStack, "backStack");
            Intrinsics.checkNotNullParameter(url, "url");
            Intrinsics.checkNotNullParameter(size, "size");
            Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
            Intrinsics.checkNotNullParameter(title, "title");
            return copy(backStack, url, size, messagingTheme, title);
        }
    }

    @Metadata(m17d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0011\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\b\u0086\b\u0018\u00002\u00020\u0001B3\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0004\u0012\u0006\u0010\u0006\u001a\u00020\u0004\u0012\u0006\u0010\u0007\u001a\u00020\b\u0012\u0006\u0010\t\u001a\u00020\u0004¢\u0006\u0002\u0010\nJ\u000f\u0010\u0013\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\t\u0010\u0014\u001a\u00020\u0004HÆ\u0003J\t\u0010\u0015\u001a\u00020\u0004HÆ\u0003J\t\u0010\u0016\u001a\u00020\bHÆ\u0003J\t\u0010\u0017\u001a\u00020\u0004HÆ\u0003JA\u0010\u0018\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00042\b\b\u0002\u0010\u0006\u001a\u00020\u00042\b\b\u0002\u0010\u0007\u001a\u00020\b2\b\b\u0002\u0010\t\u001a\u00020\u0004HÆ\u0001J\u0013\u0010\u0019\u001a\u00020\u001a2\b\u0010\u001b\u001a\u0004\u0018\u00010\u001cHÖ\u0003J\t\u0010\u001d\u001a\u00020\u001eHÖ\u0001J6\u0010\u001f\u001a\u00020\u00012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\u0006\u0010\u0005\u001a\u00020\u00042\u0006\u0010\u0006\u001a\u00020\u00042\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\u0004H\u0016J\t\u0010 \u001a\u00020\u0004HÖ\u0001R\u001a\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0014\u0010\u0007\u001a\u00020\bX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u0014\u0010\u0006\u001a\u00020\u0004X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u0014\u0010\t\u001a\u00020\u0004X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0010R\u0014\u0010\u0005\u001a\u00020\u0004X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0010¨\u0006!"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionState$Success;", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionState;", "backStack", "", "", "url", "size", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "title", "(Ljava/util/List;Ljava/lang/String;Ljava/lang/String;Lzendesk/messaging/android/internal/model/MessagingTheme;Ljava/lang/String;)V", "getBackStack", "()Ljava/util/List;", "getMessagingTheme", "()Lzendesk/messaging/android/internal/model/MessagingTheme;", "getSize", "()Ljava/lang/String;", "getTitle", "getUrl", "component1", "component2", "component3", "component4", "component5", "copy", "equals", "", "other", "", "hashCode", "", "sealedCopy", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Success extends ConversationExtensionState {
        private final List<String> backStack;
        private final MessagingTheme messagingTheme;
        private final String size;
        private final String title;
        private final String url;

        public static Success copy$default(Success success, List list, String str, String str2, MessagingTheme messagingTheme, String str3, int i, Object obj) {
            if ((i & 1) != 0) {
                list = success.backStack;
            }
            if ((i & 2) != 0) {
                str = success.url;
            }
            String str4 = str;
            if ((i & 4) != 0) {
                str2 = success.size;
            }
            String str5 = str2;
            if ((i & 8) != 0) {
                messagingTheme = success.messagingTheme;
            }
            MessagingTheme messagingTheme2 = messagingTheme;
            if ((i & 16) != 0) {
                str3 = success.title;
            }
            return success.copy(list, str4, str5, messagingTheme2, str3);
        }

        public final List<String> component1() {
            return this.backStack;
        }

        public final String getUrl() {
            return this.url;
        }

        public final String getSize() {
            return this.size;
        }

        public final MessagingTheme getMessagingTheme() {
            return this.messagingTheme;
        }

        public final String getTitle() {
            return this.title;
        }

        public final Success copy(List<String> backStack, String url, String size, MessagingTheme messagingTheme, String title) {
            Intrinsics.checkNotNullParameter(backStack, "backStack");
            Intrinsics.checkNotNullParameter(url, "url");
            Intrinsics.checkNotNullParameter(size, "size");
            Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
            Intrinsics.checkNotNullParameter(title, "title");
            return new Success(backStack, url, size, messagingTheme, title);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Success)) {
                return false;
            }
            Success success = (Success) other;
            return Intrinsics.areEqual(this.backStack, success.backStack) && Intrinsics.areEqual(this.url, success.url) && Intrinsics.areEqual(this.size, success.size) && Intrinsics.areEqual(this.messagingTheme, success.messagingTheme) && Intrinsics.areEqual(this.title, success.title);
        }

        public int hashCode() {
            return (((((((this.backStack.hashCode() * 31) + this.url.hashCode()) * 31) + this.size.hashCode()) * 31) + this.messagingTheme.hashCode()) * 31) + this.title.hashCode();
        }

        public String toString() {
            return "Success(backStack=" + this.backStack + ", url=" + this.url + ", size=" + this.size + ", messagingTheme=" + this.messagingTheme + ", title=" + this.title + ')';
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
        public String getSize() {
            return this.size;
        }

        @Override
        public MessagingTheme getMessagingTheme() {
            return this.messagingTheme;
        }

        @Override
        public String getTitle() {
            return this.title;
        }

        public Success(List<String> backStack, String url, String size, MessagingTheme messagingTheme, String title) {
            super(backStack, url, size, messagingTheme, title, null);
            Intrinsics.checkNotNullParameter(backStack, "backStack");
            Intrinsics.checkNotNullParameter(url, "url");
            Intrinsics.checkNotNullParameter(size, "size");
            Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
            Intrinsics.checkNotNullParameter(title, "title");
            this.backStack = backStack;
            this.url = url;
            this.size = size;
            this.messagingTheme = messagingTheme;
            this.title = title;
        }

        @Override
        public ConversationExtensionState sealedCopy(List<String> backStack, String url, String size, MessagingTheme messagingTheme, String title) {
            Intrinsics.checkNotNullParameter(backStack, "backStack");
            Intrinsics.checkNotNullParameter(url, "url");
            Intrinsics.checkNotNullParameter(size, "size");
            Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
            Intrinsics.checkNotNullParameter(title, "title");
            return copy(backStack, url, size, messagingTheme, title);
        }
    }

    @Metadata(m17d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0011\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\b\u0086\b\u0018\u00002\u00020\u0001B3\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0004\u0012\u0006\u0010\u0006\u001a\u00020\u0004\u0012\u0006\u0010\u0007\u001a\u00020\b\u0012\u0006\u0010\t\u001a\u00020\u0004¢\u0006\u0002\u0010\nJ\u000f\u0010\u0013\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\t\u0010\u0014\u001a\u00020\u0004HÆ\u0003J\t\u0010\u0015\u001a\u00020\u0004HÆ\u0003J\t\u0010\u0016\u001a\u00020\bHÆ\u0003J\t\u0010\u0017\u001a\u00020\u0004HÆ\u0003JA\u0010\u0018\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00042\b\b\u0002\u0010\u0006\u001a\u00020\u00042\b\b\u0002\u0010\u0007\u001a\u00020\b2\b\b\u0002\u0010\t\u001a\u00020\u0004HÆ\u0001J\u0013\u0010\u0019\u001a\u00020\u001a2\b\u0010\u001b\u001a\u0004\u0018\u00010\u001cHÖ\u0003J\t\u0010\u001d\u001a\u00020\u001eHÖ\u0001J6\u0010\u001f\u001a\u00020\u00012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\u0006\u0010\u0005\u001a\u00020\u00042\u0006\u0010\u0006\u001a\u00020\u00042\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\u0004H\u0016J\t\u0010 \u001a\u00020\u0004HÖ\u0001R\u001a\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0014\u0010\u0007\u001a\u00020\bX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u0014\u0010\u0006\u001a\u00020\u0004X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u0014\u0010\t\u001a\u00020\u0004X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0010R\u0014\u0010\u0005\u001a\u00020\u0004X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0010¨\u0006!"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionState$Loading;", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionState;", "backStack", "", "", "url", "size", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "title", "(Ljava/util/List;Ljava/lang/String;Ljava/lang/String;Lzendesk/messaging/android/internal/model/MessagingTheme;Ljava/lang/String;)V", "getBackStack", "()Ljava/util/List;", "getMessagingTheme", "()Lzendesk/messaging/android/internal/model/MessagingTheme;", "getSize", "()Ljava/lang/String;", "getTitle", "getUrl", "component1", "component2", "component3", "component4", "component5", "copy", "equals", "", "other", "", "hashCode", "", "sealedCopy", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Loading extends ConversationExtensionState {
        private final List<String> backStack;
        private final MessagingTheme messagingTheme;
        private final String size;
        private final String title;
        private final String url;

        public static Loading copy$default(Loading loading, List list, String str, String str2, MessagingTheme messagingTheme, String str3, int i, Object obj) {
            if ((i & 1) != 0) {
                list = loading.backStack;
            }
            if ((i & 2) != 0) {
                str = loading.url;
            }
            String str4 = str;
            if ((i & 4) != 0) {
                str2 = loading.size;
            }
            String str5 = str2;
            if ((i & 8) != 0) {
                messagingTheme = loading.messagingTheme;
            }
            MessagingTheme messagingTheme2 = messagingTheme;
            if ((i & 16) != 0) {
                str3 = loading.title;
            }
            return loading.copy(list, str4, str5, messagingTheme2, str3);
        }

        public final List<String> component1() {
            return this.backStack;
        }

        public final String getUrl() {
            return this.url;
        }

        public final String getSize() {
            return this.size;
        }

        public final MessagingTheme getMessagingTheme() {
            return this.messagingTheme;
        }

        public final String getTitle() {
            return this.title;
        }

        public final Loading copy(List<String> backStack, String url, String size, MessagingTheme messagingTheme, String title) {
            Intrinsics.checkNotNullParameter(backStack, "backStack");
            Intrinsics.checkNotNullParameter(url, "url");
            Intrinsics.checkNotNullParameter(size, "size");
            Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
            Intrinsics.checkNotNullParameter(title, "title");
            return new Loading(backStack, url, size, messagingTheme, title);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Loading)) {
                return false;
            }
            Loading loading = (Loading) other;
            return Intrinsics.areEqual(this.backStack, loading.backStack) && Intrinsics.areEqual(this.url, loading.url) && Intrinsics.areEqual(this.size, loading.size) && Intrinsics.areEqual(this.messagingTheme, loading.messagingTheme) && Intrinsics.areEqual(this.title, loading.title);
        }

        public int hashCode() {
            return (((((((this.backStack.hashCode() * 31) + this.url.hashCode()) * 31) + this.size.hashCode()) * 31) + this.messagingTheme.hashCode()) * 31) + this.title.hashCode();
        }

        public String toString() {
            return "Loading(backStack=" + this.backStack + ", url=" + this.url + ", size=" + this.size + ", messagingTheme=" + this.messagingTheme + ", title=" + this.title + ')';
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
        public String getSize() {
            return this.size;
        }

        @Override
        public MessagingTheme getMessagingTheme() {
            return this.messagingTheme;
        }

        @Override
        public String getTitle() {
            return this.title;
        }

        public Loading(List<String> backStack, String url, String size, MessagingTheme messagingTheme, String title) {
            super(backStack, url, size, messagingTheme, title, null);
            Intrinsics.checkNotNullParameter(backStack, "backStack");
            Intrinsics.checkNotNullParameter(url, "url");
            Intrinsics.checkNotNullParameter(size, "size");
            Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
            Intrinsics.checkNotNullParameter(title, "title");
            this.backStack = backStack;
            this.url = url;
            this.size = size;
            this.messagingTheme = messagingTheme;
            this.title = title;
        }

        @Override
        public ConversationExtensionState sealedCopy(List<String> backStack, String url, String size, MessagingTheme messagingTheme, String title) {
            Intrinsics.checkNotNullParameter(backStack, "backStack");
            Intrinsics.checkNotNullParameter(url, "url");
            Intrinsics.checkNotNullParameter(size, "size");
            Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
            Intrinsics.checkNotNullParameter(title, "title");
            return copy(backStack, url, size, messagingTheme, title);
        }
    }
}
