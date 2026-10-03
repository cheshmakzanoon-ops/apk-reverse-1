package zendesk.messaging.android.internal;

import java.util.Collection;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010#\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010\"\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0002\b\u0007\bÀ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\r\u0010\u0006\u001a\u00020\u0007H\u0000¢\u0006\u0002\b\bJ\u0013\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u00050\nH\u0000¢\u0006\u0002\b\u000bJ\r\u0010\f\u001a\u00020\rH\u0000¢\u0006\u0002\b\u000eJ\u0015\u0010\u000f\u001a\u00020\r2\u0006\u0010\u0010\u001a\u00020\u0011H\u0000¢\u0006\u0002\b\u0012J\u0015\u0010\u0013\u001a\u00020\u00072\u0006\u0010\u0014\u001a\u00020\u0005H\u0000¢\u0006\u0002\b\u0015J\u0015\u0010\u0016\u001a\u00020\u00072\u0006\u0010\u0014\u001a\u00020\u0005H\u0000¢\u0006\u0002\b\u0017R\u0014\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0018"}, m18d2 = {"Lzendesk/messaging/android/internal/VisibleScreenTracker;", "", "()V", "visibleScreens", "", "Lzendesk/messaging/android/internal/VisibleScreen;", "clearVisibleScreens", "", "clearVisibleScreens$zendesk_messaging_messaging_android", "getVisibleScreens", "", "getVisibleScreens$zendesk_messaging_messaging_android", "hasVisibleScreen", "", "hasVisibleScreen$zendesk_messaging_messaging_android", "isConversationVisibleOnScreen", "conversationId", "", "isConversationVisibleOnScreen$zendesk_messaging_messaging_android", "setHiddenScreen", "screen", "setHiddenScreen$zendesk_messaging_messaging_android", "setShownScreen", "setShownScreen$zendesk_messaging_messaging_android", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class VisibleScreenTracker {
    public static final VisibleScreenTracker INSTANCE = new VisibleScreenTracker();
    private static final Set<VisibleScreen> visibleScreens = new LinkedHashSet();

    private VisibleScreenTracker() {
    }

    public final void setShownScreen$zendesk_messaging_messaging_android(VisibleScreen screen) {
        Intrinsics.checkNotNullParameter(screen, "screen");
        Set<VisibleScreen> set = visibleScreens;
        set.remove(screen);
        set.add(screen);
    }

    public final void setHiddenScreen$zendesk_messaging_messaging_android(VisibleScreen screen) {
        Intrinsics.checkNotNullParameter(screen, "screen");
        visibleScreens.remove(screen);
    }

    public final Set<VisibleScreen> getVisibleScreens$zendesk_messaging_messaging_android() {
        return visibleScreens;
    }

    public final void clearVisibleScreens$zendesk_messaging_messaging_android() {
        visibleScreens.clear();
    }

    public final boolean hasVisibleScreen$zendesk_messaging_messaging_android() {
        return !visibleScreens.isEmpty();
    }

    public final boolean m228x7fb2d242(String conversationId) {
        Intrinsics.checkNotNullParameter(conversationId, "conversationId");
        List listFilterIsInstance = CollectionsKt.filterIsInstance(getVisibleScreens$zendesk_messaging_messaging_android(), VisibleScreen.ConversationScreen.class);
        if ((listFilterIsInstance instanceof Collection) && listFilterIsInstance.isEmpty()) {
            return false;
        }
        Iterator it = listFilterIsInstance.iterator();
        while (it.hasNext()) {
            if (Intrinsics.areEqual(((VisibleScreen.ConversationScreen) it.next()).getConversationId(), conversationId)) {
                return true;
            }
        }
        return false;
    }
}
