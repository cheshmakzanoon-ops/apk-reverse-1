package zendesk.android;

import java.lang.Throwable;
import kotlin.Metadata;

@Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0003\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0003\bæ\u0080\u0001\u0018\u0000*\b\b\u0000\u0010\u0001*\u00020\u00022\u00020\u0003J\u0015\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00028\u0000H&¢\u0006\u0002\u0010\u0007¨\u0006\b"}, m18d2 = {"Lzendesk/android/FailureCallback;", "E", "", "", "onFailure", "", "error", "(Ljava/lang/Throwable;)V", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface FailureCallback<E extends Throwable> {
    void onFailure(E error);
}
