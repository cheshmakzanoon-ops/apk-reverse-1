package zendesk.messaging.android.internal.validation;

import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0003\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b0\u0018\u00002\u00020\u0001:\u0002\u0003\u0004B\u0007\b\u0004¢\u0006\u0002\u0010\u0002\u0082\u0001\u0002\u0005\u0006¨\u0006\u0007"}, m18d2 = {"Lzendesk/messaging/android/internal/validation/ValidationError;", "", "()V", "FieldRetrievalFailed", "FieldValidationFailed", "Lzendesk/messaging/android/internal/validation/ValidationError$FieldRetrievalFailed;", "Lzendesk/messaging/android/internal/validation/ValidationError$FieldValidationFailed;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class ValidationError extends Throwable {
    public ValidationError(DefaultConstructorMarker defaultConstructorMarker) {
        this();
    }

    private ValidationError() {
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0080\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003¢\u0006\u0002\u0010\u0005J\t\u0010\t\u001a\u00020\u0003HÆ\u0003J\t\u0010\n\u001a\u00020\u0003HÆ\u0003J\u001d\u0010\u000b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\f\u001a\u00020\r2\b\u0010\u000e\u001a\u0004\u0018\u00010\u000fHÖ\u0003J\t\u0010\u0010\u001a\u00020\u0011HÖ\u0001J\t\u0010\u0012\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007R\u0014\u0010\u0004\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\u0007¨\u0006\u0013"}, m18d2 = {"Lzendesk/messaging/android/internal/validation/ValidationError$FieldValidationFailed;", "Lzendesk/messaging/android/internal/validation/ValidationError;", "id", "", "message", "(Ljava/lang/String;Ljava/lang/String;)V", "getId", "()Ljava/lang/String;", "getMessage", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class FieldValidationFailed extends ValidationError {
        private final String id;
        private final String message;

        public static FieldValidationFailed copy$default(FieldValidationFailed fieldValidationFailed, String str, String str2, int i, Object obj) {
            if ((i & 1) != 0) {
                str = fieldValidationFailed.id;
            }
            if ((i & 2) != 0) {
                str2 = fieldValidationFailed.message;
            }
            return fieldValidationFailed.copy(str, str2);
        }

        public final String getId() {
            return this.id;
        }

        public final String getMessage() {
            return this.message;
        }

        public final FieldValidationFailed copy(String id, String message) {
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(message, "message");
            return new FieldValidationFailed(id, message);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof FieldValidationFailed)) {
                return false;
            }
            FieldValidationFailed fieldValidationFailed = (FieldValidationFailed) other;
            return Intrinsics.areEqual(this.id, fieldValidationFailed.id) && Intrinsics.areEqual(this.message, fieldValidationFailed.message);
        }

        public int hashCode() {
            return (this.id.hashCode() * 31) + this.message.hashCode();
        }

        @Override
        public String toString() {
            return "FieldValidationFailed(id=" + this.id + ", message=" + this.message + ')';
        }

        public final String getId() {
            return this.id;
        }

        @Override
        public String getMessage() {
            return this.message;
        }

        public FieldValidationFailed(String id, String message) {
            super(null);
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(message, "message");
            this.id = id;
            this.message = message;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0080\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/messaging/android/internal/validation/ValidationError$FieldRetrievalFailed;", "Lzendesk/messaging/android/internal/validation/ValidationError;", "message", "", "(Ljava/lang/String;)V", "getMessage", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class FieldRetrievalFailed extends ValidationError {
        private final String message;

        public static FieldRetrievalFailed copy$default(FieldRetrievalFailed fieldRetrievalFailed, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = fieldRetrievalFailed.message;
            }
            return fieldRetrievalFailed.copy(str);
        }

        public final String getMessage() {
            return this.message;
        }

        public final FieldRetrievalFailed copy(String message) {
            Intrinsics.checkNotNullParameter(message, "message");
            return new FieldRetrievalFailed(message);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof FieldRetrievalFailed) && Intrinsics.areEqual(this.message, ((FieldRetrievalFailed) other).message);
        }

        public int hashCode() {
            return this.message.hashCode();
        }

        @Override
        public String toString() {
            return "FieldRetrievalFailed(message=" + this.message + ')';
        }

        @Override
        public String getMessage() {
            return this.message;
        }

        public FieldRetrievalFailed(String message) {
            super(null);
            Intrinsics.checkNotNullParameter(message, "message");
            this.message = message;
        }
    }
}
