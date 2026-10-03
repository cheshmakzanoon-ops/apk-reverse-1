package net.aihelp.data.event;

import net.aihelp.core.util.bus.event.EventCenter;

public class OperatePagerEvent extends EventCenter<Boolean> {
    public OperatePagerEvent(Boolean bool) {
        super(bool);
    }
}
