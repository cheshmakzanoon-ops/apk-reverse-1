package zendesk.android.internal.frontendevents.pageviewevents;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import zendesk.android.ZendeskResult;
import zendesk.android.internal.ZendeskError;
import zendesk.android.pageviewevents.PageView;

@Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0010\u0003\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÀ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\"\u0010\u0003\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00060\u00042\u0006\u0010\u0007\u001a\u00020\bH\u0096@¢\u0006\u0002\u0010\t¨\u0006\n"}, m18d2 = {"Lzendesk/android/internal/frontendevents/pageviewevents/NotInitializedPageViewEvents;", "Lzendesk/android/internal/frontendevents/pageviewevents/PageViewEvents;", "()V", "sendPageViewEvent", "Lzendesk/android/ZendeskResult;", "", "", "pageView", "Lzendesk/android/pageviewevents/PageView;", "(Lzendesk/android/pageviewevents/PageView;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class NotInitializedPageViewEvents implements PageViewEvents {
    public static final NotInitializedPageViewEvents INSTANCE = new NotInitializedPageViewEvents();

    private NotInitializedPageViewEvents() {
    }

    @Override
    public Object sendPageViewEvent(PageView pageView, Continuation<? super ZendeskResult<Unit, ? extends Throwable>> continuation) {
        return new ZendeskResult.Failure(ZendeskError.NotInitialized.INSTANCE);
    }
}
