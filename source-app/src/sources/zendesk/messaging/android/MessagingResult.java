package zendesk.messaging.android;

import kotlin.Deprecated;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Deprecated(message = "Please use Zendesk SDK")
@Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b7\u0018\u0000*\u0006\b\u0000\u0010\u0001 \u00012\u00020\u0002:\u0002\u0004\u0005B\u0007\b\u0004¢\u0006\u0002\u0010\u0003\u0082\u0001\u0002\u0006\u0007¨\u0006\b"}, m18d2 = {"Lzendesk/messaging/android/MessagingResult;", "T", "", "()V", "Failure", "Success", "Lzendesk/messaging/android/MessagingResult$Failure;", "Lzendesk/messaging/android/MessagingResult$Success;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class MessagingResult<T> {
    public MessagingResult(DefaultConstructorMarker defaultConstructorMarker) {
        this();
    }

    private MessagingResult() {
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u0000*\u0004\b\u0001\u0010\u00012\b\u0012\u0004\u0012\u0002H\u00010\u0002B\r\u0012\u0006\u0010\u0003\u001a\u00028\u0001¢\u0006\u0002\u0010\u0004J\u000e\u0010\b\u001a\u00028\u0001HÆ\u0003¢\u0006\u0002\u0010\u0006J\u001e\u0010\t\u001a\b\u0012\u0004\u0012\u00028\u00010\u00002\b\b\u0002\u0010\u0003\u001a\u00028\u0001HÆ\u0001¢\u0006\u0002\u0010\nJ\u0013\u0010\u000b\u001a\u00020\f2\b\u0010\r\u001a\u0004\u0018\u00010\u000eHÖ\u0003J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001J\t\u0010\u0011\u001a\u00020\u0012HÖ\u0001R\u0013\u0010\u0003\u001a\u00028\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0013"}, m18d2 = {"Lzendesk/messaging/android/MessagingResult$Success;", "T", "Lzendesk/messaging/android/MessagingResult;", "value", "(Ljava/lang/Object;)V", "getValue", "()Ljava/lang/Object;", "Ljava/lang/Object;", "component1", "copy", "(Ljava/lang/Object;)Lzendesk/messaging/android/MessagingResult$Success;", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Success<T> extends MessagingResult<T> {
        private final T value;

        public static Success copy$default(Success success, Object obj, int i, Object obj2) {
            if ((i & 1) != 0) {
                obj = success.value;
            }
            return success.copy(obj);
        }

        public final T component1() {
            return this.value;
        }

        public final Success<T> copy(T value) {
            return new Success<>(value);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof Success) && Intrinsics.areEqual(this.value, ((Success) other).value);
        }

        public int hashCode() {
            T t = this.value;
            if (t == null) {
                return 0;
            }
            return t.hashCode();
        }

        public String toString() {
            return "Success(value=" + this.value + ')';
        }

        public Success(T t) {
            super(null);
            this.value = t;
        }

        public final T getValue() {
            return this.value;
        }
    }

    @Metadata(m17d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0001\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000e\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0011\u0012\n\b\u0002\u0010\u0003\u001a\u0004\u0018\u00010\u0004¢\u0006\u0002\u0010\u0005J\u000b\u0010\f\u001a\u0004\u0018\u00010\u0004HÆ\u0003J\u0015\u0010\r\u001a\u00020\u00002\n\b\u0002\u0010\u0003\u001a\u0004\u0018\u00010\u0004HÆ\u0001J\u0013\u0010\u000e\u001a\u00020\u000f2\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011HÖ\u0003J\t\u0010\u0012\u001a\u00020\u0013HÖ\u0001J\t\u0010\u0014\u001a\u00020\tHÖ\u0001R\u0013\u0010\u0003\u001a\u0004\u0018\u00010\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007R\u0011\u0010\b\u001a\u00020\t¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000b¨\u0006\u0015"}, m18d2 = {"Lzendesk/messaging/android/MessagingResult$Failure;", "Lzendesk/messaging/android/MessagingResult;", "", "cause", "Lzendesk/messaging/android/MessagingError;", "(Lzendesk/messaging/android/MessagingError;)V", "getCause", "()Lzendesk/messaging/android/MessagingError;", "message", "", "getMessage", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Failure extends MessagingResult {
        private final MessagingError cause;
        private final String message;

        public Failure() {
            this(null, 1, 0 == true ? 1 : 0);
        }

        public static Failure copy$default(Failure failure, MessagingError messagingError, int i, Object obj) {
            if ((i & 1) != 0) {
                messagingError = failure.cause;
            }
            return failure.copy(messagingError);
        }

        public final MessagingError getCause() {
            return this.cause;
        }

        public final Failure copy(MessagingError cause) {
            return new Failure(cause);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof Failure) && Intrinsics.areEqual(this.cause, ((Failure) other).cause);
        }

        public int hashCode() {
            MessagingError messagingError = this.cause;
            if (messagingError == null) {
                return 0;
            }
            return messagingError.hashCode();
        }

        public String toString() {
            return "Failure(cause=" + this.cause + ')';
        }

        public Failure(MessagingError messagingError, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this((i & 1) != 0 ? null : messagingError);
        }

        public final MessagingError getCause() {
            return this.cause;
        }

        public Failure(MessagingError messagingError) {
            String message;
            super(null);
            this.cause = messagingError;
            this.message = (messagingError == null || (message = messagingError.getMessage()) == null) ? "" : message;
        }

        public final String getMessage() {
            return this.message;
        }
    }
}
