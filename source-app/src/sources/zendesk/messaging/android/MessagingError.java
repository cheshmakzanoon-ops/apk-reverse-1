package zendesk.messaging.android;

import kotlin.Deprecated;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Deprecated(message = "Please use Zendesk SDK")
@Metadata(m17d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0010\u0003\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b7\u0018\u00002\u00020\u0001:\b\u0007\b\t\n\u000b\f\r\u000eB\u000f\b\u0004\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006\u0082\u0001\b\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016¨\u0006\u0017"}, m18d2 = {"Lzendesk/messaging/android/MessagingError;", "", "message", "", "(Ljava/lang/String;)V", "getMessage", "()Ljava/lang/String;", "AccountNotFound", "ConversationNotFound", "FailedToInitialize", "InvalidChannelKey", "MissingConfiguration", "NoResultReceived", "NotInitialized", "SdkNotEnabled", "Lzendesk/messaging/android/MessagingError$AccountNotFound;", "Lzendesk/messaging/android/MessagingError$ConversationNotFound;", "Lzendesk/messaging/android/MessagingError$FailedToInitialize;", "Lzendesk/messaging/android/MessagingError$InvalidChannelKey;", "Lzendesk/messaging/android/MessagingError$MissingConfiguration;", "Lzendesk/messaging/android/MessagingError$NoResultReceived;", "Lzendesk/messaging/android/MessagingError$NotInitialized;", "Lzendesk/messaging/android/MessagingError$SdkNotEnabled;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class MessagingError extends Throwable {
    private final String message;

    public MessagingError(String str, DefaultConstructorMarker defaultConstructorMarker) {
        this(str);
    }

    private MessagingError(String str) {
        super(str);
        this.message = str;
    }

    @Override
    public String getMessage() {
        return this.message;
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/MessagingError$InvalidChannelKey;", "Lzendesk/messaging/android/MessagingError;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class InvalidChannelKey extends MessagingError {
        public static final InvalidChannelKey INSTANCE = new InvalidChannelKey();

        private InvalidChannelKey() {
            super("The provided channelKey is invalid.", null);
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/MessagingError$NoResultReceived;", "Lzendesk/messaging/android/MessagingError;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class NoResultReceived extends MessagingError {
        public static final NoResultReceived INSTANCE = new NoResultReceived();

        private NoResultReceived() {
            super("No MessagingResult to return for this call.", null);
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/MessagingError$NotInitialized;", "Lzendesk/messaging/android/MessagingError;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class NotInitialized extends MessagingError {
        public static final NotInitialized INSTANCE = new NotInitialized();

        private NotInitialized() {
            super("Messaging.instance() was called before initialization was completed.", null);
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/MessagingError$SdkNotEnabled;", "Lzendesk/messaging/android/MessagingError;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class SdkNotEnabled extends MessagingError {
        public static final SdkNotEnabled INSTANCE = new SdkNotEnabled();

        private SdkNotEnabled() {
            super("The SDK is not enabled for this integration.", null);
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/MessagingError$AccountNotFound;", "Lzendesk/messaging/android/MessagingError;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class AccountNotFound extends MessagingError {
        public static final AccountNotFound INSTANCE = new AccountNotFound();

        private AccountNotFound() {
            super("No account found for the provided credentials.", null);
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/MessagingError$MissingConfiguration;", "Lzendesk/messaging/android/MessagingError;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class MissingConfiguration extends MessagingError {
        public static final MissingConfiguration INSTANCE = new MissingConfiguration();

        private MissingConfiguration() {
            super("The configuration for this Messaging integration could not be retrieved.", null);
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0003\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\u0011\u0012\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u0003¢\u0006\u0002\u0010\u0004J\u000b\u0010\u0007\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\u0015\u0010\b\u001a\u00020\u00002\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0016\u0010\u0002\u001a\u0004\u0018\u00010\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/messaging/android/MessagingError$FailedToInitialize;", "Lzendesk/messaging/android/MessagingError;", "cause", "", "(Ljava/lang/Throwable;)V", "getCause", "()Ljava/lang/Throwable;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class FailedToInitialize extends MessagingError {
        private final Throwable cause;

        public FailedToInitialize() {
            this(null, 1, 0 == true ? 1 : 0);
        }

        public static FailedToInitialize copy$default(FailedToInitialize failedToInitialize, Throwable th, int i, Object obj) {
            if ((i & 1) != 0) {
                th = failedToInitialize.cause;
            }
            return failedToInitialize.copy(th);
        }

        public final Throwable getCause() {
            return this.cause;
        }

        public final FailedToInitialize copy(Throwable cause) {
            return new FailedToInitialize(cause);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof FailedToInitialize) && Intrinsics.areEqual(this.cause, ((FailedToInitialize) other).cause);
        }

        public int hashCode() {
            Throwable th = this.cause;
            if (th == null) {
                return 0;
            }
            return th.hashCode();
        }

        @Override
        public String toString() {
            return "FailedToInitialize(cause=" + this.cause + ')';
        }

        public FailedToInitialize(Throwable th, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this((i & 1) != 0 ? null : th);
        }

        @Override
        public Throwable getCause() {
            return this.cause;
        }

        public FailedToInitialize(Throwable th) {
            super("Messaging failed to initialize.", null);
            this.cause = th;
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/MessagingError$ConversationNotFound;", "Lzendesk/messaging/android/MessagingError;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ConversationNotFound extends MessagingError {
        public static final ConversationNotFound INSTANCE = new ConversationNotFound();

        private ConversationNotFound() {
            super("There was a problem retrieving the conversation.", null);
        }
    }
}
