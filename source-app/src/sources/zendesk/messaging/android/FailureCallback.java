package zendesk.messaging.android;

import java.lang.Throwable;
import kotlin.Deprecated;
import kotlin.Metadata;

@Deprecated(message = "Please use Zendesk SDK")
@Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0003\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0003\bç\u0080\u0001\u0018\u0000*\b\b\u0000\u0010\u0001*\u00020\u00022\u00020\u0003J\u0017\u0010\u0004\u001a\u00020\u00052\b\u0010\u0006\u001a\u0004\u0018\u00018\u0000H&¢\u0006\u0002\u0010\u0007¨\u0006\b"}, m18d2 = {"Lzendesk/messaging/android/FailureCallback;", "E", "", "", "onFailure", "", "cause", "(Ljava/lang/Throwable;)V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface FailureCallback<E extends Throwable> {
    void onFailure(E cause);
}
