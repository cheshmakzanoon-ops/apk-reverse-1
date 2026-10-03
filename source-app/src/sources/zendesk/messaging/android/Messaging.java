package zendesk.messaging.android;

import android.content.Context;
import kotlin.Deprecated;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.Intrinsics;
import zendesk.android.Zendesk;
import zendesk.android.internal.ZendeskError;
import zendesk.messaging.android.internal.WrapperMessaging;

@Deprecated(message = "Use Zendesk SDK to obtain an instance of Messaging", replaceWith = @ReplaceWith(expression = "Messaging", imports = {"zendesk.android.messaging.Messaging"}))
@Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bg\u0018\u0000 \u00022\u00020\u0001:\u0001\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/Messaging;", "Lzendesk/android/messaging/Messaging;", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface Messaging extends zendesk.android.messaging.Messaging {

    public static final Companion INSTANCE = Companion.$$INSTANCE;

    public final class CC {
        static {
            Companion companion = Messaging.INSTANCE;
        }

        @Deprecated(message = "Please use Zendesk.initialize instead", replaceWith = @ReplaceWith(expression = "Zendesk.initialize(context, channelKey, successCallback, failureCallback,\n DefaultMessagingFactory())", imports = {"zendesk.android.Zendesk"}))
        @JvmStatic
        public static void initialize(Context context, String str, SuccessCallback<Messaging> successCallback, FailureCallback<MessagingError> failureCallback) {
            Messaging.INSTANCE.initialize(context, str, successCallback, failureCallback);
        }

        @Deprecated(message = "Please use Zendesk#messaging instead", replaceWith = @ReplaceWith(expression = "Zendesk.instance().messaging()", imports = {"zendesk.android.Zendesk"}))
        @JvmStatic
        public static Messaging instance() {
            return Messaging.INSTANCE.instance();
        }

        @Deprecated(message = "Please use Zendesk.invalidate instead", replaceWith = @ReplaceWith(expression = "Zendesk.invalidate()", imports = {"zendesk.android.Zendesk"}))
        @JvmStatic
        public static void invalidate() {
            Messaging.INSTANCE.invalidate();
        }

        @Deprecated(message = "Please use Messaging.setDelegate", replaceWith = @ReplaceWith(expression = "Messaging.setDelegate(messagingDelegate)", imports = {"zendesk.android.messaging.Messaging"}))
        @JvmStatic
        public static void setDelegate(MessagingDelegate messagingDelegate) {
            Messaging.INSTANCE.setDelegate(messagingDelegate);
        }
    }

    @Metadata(m17d1 = {"\u0000:\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J4\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\b2\f\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u000b0\n2\f\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u000e0\rH\u0007J\b\u0010\u000f\u001a\u00020\u000bH\u0007J\b\u0010\u0010\u001a\u00020\u0004H\u0007J\u0012\u0010\u0011\u001a\u00020\u00042\b\u0010\u0012\u001a\u0004\u0018\u00010\u0013H\u0007¨\u0006\u0014"}, m18d2 = {"Lzendesk/messaging/android/Messaging$Companion;", "", "()V", "initialize", "", "context", "Landroid/content/Context;", "channelKey", "", "successCallback", "Lzendesk/messaging/android/SuccessCallback;", "Lzendesk/messaging/android/Messaging;", "failureCallback", "Lzendesk/messaging/android/FailureCallback;", "Lzendesk/messaging/android/MessagingError;", "instance", "invalidate", "setDelegate", "messagingDelegate", "Lzendesk/messaging/android/MessagingDelegate;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        static final Companion $$INSTANCE = new Companion();

        private Companion() {
        }

        @Deprecated(message = "Please use Zendesk.initialize instead", replaceWith = @ReplaceWith(expression = "Zendesk.initialize(context, channelKey, successCallback, failureCallback,\n DefaultMessagingFactory())", imports = {"zendesk.android.Zendesk"}))
        @JvmStatic
        public final void initialize(Context context, String channelKey, final SuccessCallback<Messaging> successCallback, final FailureCallback<MessagingError> failureCallback) {
            Intrinsics.checkNotNullParameter(context, "context");
            Intrinsics.checkNotNullParameter(channelKey, "channelKey");
            Intrinsics.checkNotNullParameter(successCallback, "successCallback");
            Intrinsics.checkNotNullParameter(failureCallback, "failureCallback");
            Zendesk.INSTANCE.initialize(context, channelKey, new zendesk.android.SuccessCallback() {
                @Override
                public final void onSuccess(Object obj) {
                    Messaging.Companion.initialize$lambda$0(successCallback, (Zendesk) obj);
                }
            }, new zendesk.android.FailureCallback() {
                @Override
                public final void onFailure(Throwable th) {
                    Messaging.Companion.initialize$lambda$1(failureCallback, th);
                }
            }, new DefaultMessagingFactory(null, 0 == true ? 1 : 0, 3, 0 == true ? 1 : 0));
        }

        public static final void initialize$lambda$0(SuccessCallback successCallback, Zendesk it) {
            Intrinsics.checkNotNullParameter(successCallback, "$successCallback");
            Intrinsics.checkNotNullParameter(it, "it");
            successCallback.onSuccess(new WrapperMessaging(it));
        }

        public static final void initialize$lambda$1(FailureCallback failureCallback, Throwable it) {
            MessagingError.SdkNotEnabled failedToInitialize;
            Intrinsics.checkNotNullParameter(failureCallback, "$failureCallback");
            Intrinsics.checkNotNullParameter(it, "it");
            if (Intrinsics.areEqual(it, ZendeskError.AccountNotFound.INSTANCE)) {
                failedToInitialize = MessagingError.AccountNotFound.INSTANCE;
            } else if (it instanceof ZendeskError.FailedToInitialize) {
                failedToInitialize = new MessagingError.FailedToInitialize(it.getCause());
            } else if (Intrinsics.areEqual(it, ZendeskError.InvalidChannelKey.INSTANCE)) {
                failedToInitialize = MessagingError.InvalidChannelKey.INSTANCE;
            } else if (Intrinsics.areEqual(it, ZendeskError.MissingConfiguration.INSTANCE)) {
                failedToInitialize = MessagingError.MissingConfiguration.INSTANCE;
            } else if (Intrinsics.areEqual(it, ZendeskError.NotInitialized.INSTANCE)) {
                failedToInitialize = MessagingError.NotInitialized.INSTANCE;
            } else {
                failedToInitialize = Intrinsics.areEqual(it, ZendeskError.SdkNotEnabled.INSTANCE) ? MessagingError.SdkNotEnabled.INSTANCE : null;
            }
            failureCallback.onFailure(failedToInitialize);
        }

        @Deprecated(message = "Please use Zendesk#messaging instead", replaceWith = @ReplaceWith(expression = "Zendesk.instance().messaging()", imports = {"zendesk.android.Zendesk"}))
        @JvmStatic
        public final Messaging instance() {
            return new WrapperMessaging(Zendesk.INSTANCE.getInstance());
        }

        @Deprecated(message = "Please use Zendesk.invalidate instead", replaceWith = @ReplaceWith(expression = "Zendesk.invalidate()", imports = {"zendesk.android.Zendesk"}))
        @JvmStatic
        public final void invalidate() {
            Zendesk.INSTANCE.invalidate();
        }

        @Deprecated(message = "Please use Messaging.setDelegate", replaceWith = @ReplaceWith(expression = "Messaging.setDelegate(messagingDelegate)", imports = {"zendesk.android.messaging.Messaging"}))
        @JvmStatic
        public final void setDelegate(MessagingDelegate messagingDelegate) {
            zendesk.android.messaging.Messaging.INSTANCE.setDelegate(messagingDelegate);
        }
    }
}
