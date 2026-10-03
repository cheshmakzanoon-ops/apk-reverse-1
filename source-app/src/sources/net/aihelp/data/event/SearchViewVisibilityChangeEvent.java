package net.aihelp.data.event;

import net.aihelp.core.util.bus.event.EventCenter;

public class SearchViewVisibilityChangeEvent extends EventCenter<Boolean> {
    public SearchViewVisibilityChangeEvent(boolean z) {
        super(Boolean.valueOf(z));
    }
}
