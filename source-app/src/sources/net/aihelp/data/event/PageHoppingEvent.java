package net.aihelp.data.event;

import android.os.Bundle;
import net.aihelp.core.util.bus.event.EventCenter;

public class PageHoppingEvent extends EventCenter<Bundle> {
    public PageHoppingEvent(int i) {
        super(i);
    }

    public PageHoppingEvent(int i, Bundle bundle) {
        super(i, bundle);
    }
}
