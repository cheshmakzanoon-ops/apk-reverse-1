package zendesk.messaging.android;

import kotlin.Deprecated;
import kotlin.Metadata;

@Deprecated(message = "Please use Zendesk SDK")
@Metadata(m17d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0003\bç\u0080\u0001\u0018\u0000*\u0004\b\u0000\u0010\u00012\u00020\u0002J\u0015\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00028\u0000H&¢\u0006\u0002\u0010\u0006¨\u0006\u0007"}, m18d2 = {"Lzendesk/messaging/android/SuccessCallback;", "T", "", "onSuccess", "", "value", "(Ljava/lang/Object;)V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface SuccessCallback<T> {
    void onSuccess(T value);
}
