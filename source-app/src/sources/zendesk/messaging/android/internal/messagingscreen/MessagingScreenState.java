package zendesk.messaging.android.internal.messagingscreen;

import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\bp\u0018\u00002\u00020\u0001:\u0004\u0002\u0003\u0004\u0005\u0082\u0001\u0004\u0006\u0007\b\t¨\u0006\n"}, m18d2 = {"Lzendesk/messaging/android/internal/messagingscreen/MessagingScreenState;", "", "Error", "Idle", "Loading", "Success", "Lzendesk/messaging/android/internal/messagingscreen/MessagingScreenState$Error;", "Lzendesk/messaging/android/internal/messagingscreen/MessagingScreenState$Idle;", "Lzendesk/messaging/android/internal/messagingscreen/MessagingScreenState$Loading;", "Lzendesk/messaging/android/internal/messagingscreen/MessagingScreenState$Success;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface MessagingScreenState {

    @Metadata(m17d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\bÆ\n\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0013\u0010\u0003\u001a\u00020\u00042\b\u0010\u0005\u001a\u0004\u0018\u00010\u0006HÖ\u0003J\t\u0010\u0007\u001a\u00020\bHÖ\u0001J\t\u0010\t\u001a\u00020\nHÖ\u0001¨\u0006\u000b"}, m18d2 = {"Lzendesk/messaging/android/internal/messagingscreen/MessagingScreenState$Idle;", "Lzendesk/messaging/android/internal/messagingscreen/MessagingScreenState;", "()V", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Idle implements MessagingScreenState {
        public static final Idle INSTANCE = new Idle();

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Idle)) {
                return false;
            }
            return true;
        }

        public int hashCode() {
            return 1751627725;
        }

        public String toString() {
            return "Idle";
        }

        private Idle() {
        }
    }

    @Metadata(m17d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\bÆ\n\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0013\u0010\u0003\u001a\u00020\u00042\b\u0010\u0005\u001a\u0004\u0018\u00010\u0006HÖ\u0003J\t\u0010\u0007\u001a\u00020\bHÖ\u0001J\t\u0010\t\u001a\u00020\nHÖ\u0001¨\u0006\u000b"}, m18d2 = {"Lzendesk/messaging/android/internal/messagingscreen/MessagingScreenState$Loading;", "Lzendesk/messaging/android/internal/messagingscreen/MessagingScreenState;", "()V", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Loading implements MessagingScreenState {
        public static final Loading INSTANCE = new Loading();

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Loading)) {
                return false;
            }
            return true;
        }

        public int hashCode() {
            return 1856256675;
        }

        public String toString() {
            return "Loading";
        }

        private Loading() {
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\u0017\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\t\u0010\n\u001a\u00020\u0003HÆ\u0003J\t\u0010\u000b\u001a\u00020\u0005HÆ\u0003J\u001d\u0010\f\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\r\u001a\u00020\u00032\b\u0010\u000e\u001a\u0004\u0018\u00010\u000fHÖ\u0003J\t\u0010\u0010\u001a\u00020\u0011HÖ\u0001J\t\u0010\u0012\u001a\u00020\u0013HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0002\u0010\u0007R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\t¨\u0006\u0014"}, m18d2 = {"Lzendesk/messaging/android/internal/messagingscreen/MessagingScreenState$Success;", "Lzendesk/messaging/android/internal/messagingscreen/MessagingScreenState;", "isPushNotification", "", "screen", "Lzendesk/messaging/android/internal/messagingscreen/MessagingFragmentScreen;", "(ZLzendesk/messaging/android/internal/messagingscreen/MessagingFragmentScreen;)V", "()Z", "getScreen", "()Lzendesk/messaging/android/internal/messagingscreen/MessagingFragmentScreen;", "component1", "component2", "copy", "equals", "other", "", "hashCode", "", "toString", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Success implements MessagingScreenState {
        private final boolean isPushNotification;
        private final MessagingFragmentScreen screen;

        public static Success copy$default(Success success, boolean z, MessagingFragmentScreen messagingFragmentScreen, int i, Object obj) {
            if ((i & 1) != 0) {
                z = success.isPushNotification;
            }
            if ((i & 2) != 0) {
                messagingFragmentScreen = success.screen;
            }
            return success.copy(z, messagingFragmentScreen);
        }

        public final boolean getIsPushNotification() {
            return this.isPushNotification;
        }

        public final MessagingFragmentScreen getScreen() {
            return this.screen;
        }

        public final Success copy(boolean isPushNotification, MessagingFragmentScreen screen) {
            Intrinsics.checkNotNullParameter(screen, "screen");
            return new Success(isPushNotification, screen);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Success)) {
                return false;
            }
            Success success = (Success) other;
            return this.isPushNotification == success.isPushNotification && Intrinsics.areEqual(this.screen, success.screen);
        }

        public int hashCode() {
            return (UByte$$ExternalSyntheticBackport0.m30m(this.isPushNotification) * 31) + this.screen.hashCode();
        }

        public String toString() {
            return "Success(isPushNotification=" + this.isPushNotification + ", screen=" + this.screen + ')';
        }

        public Success(boolean z, MessagingFragmentScreen screen) {
            Intrinsics.checkNotNullParameter(screen, "screen");
            this.isPushNotification = z;
            this.screen = screen;
        }

        public Success(boolean z, MessagingFragmentScreen messagingFragmentScreen, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this((i & 1) != 0 ? false : z, messagingFragmentScreen);
        }

        public final boolean isPushNotification() {
            return this.isPushNotification;
        }

        public final MessagingFragmentScreen getScreen() {
            return this.screen;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0003\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/messaging/android/internal/messagingscreen/MessagingScreenState$Error;", "Lzendesk/messaging/android/internal/messagingscreen/MessagingScreenState;", "error", "", "(Ljava/lang/Throwable;)V", "getError", "()Ljava/lang/Throwable;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Error implements MessagingScreenState {
        private final Throwable error;

        public static Error copy$default(Error error, Throwable th, int i, Object obj) {
            if ((i & 1) != 0) {
                th = error.error;
            }
            return error.copy(th);
        }

        public final Throwable getError() {
            return this.error;
        }

        public final Error copy(Throwable error) {
            Intrinsics.checkNotNullParameter(error, "error");
            return new Error(error);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof Error) && Intrinsics.areEqual(this.error, ((Error) other).error);
        }

        public int hashCode() {
            return this.error.hashCode();
        }

        public String toString() {
            return "Error(error=" + this.error + ')';
        }

        public Error(Throwable error) {
            Intrinsics.checkNotNullParameter(error, "error");
            this.error = error;
        }

        public final Throwable getError() {
            return this.error;
        }
    }
}
