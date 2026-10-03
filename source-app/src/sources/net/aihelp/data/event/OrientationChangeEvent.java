package net.aihelp.data.event;

import net.aihelp.core.util.bus.event.EventCenter;

public class OrientationChangeEvent extends EventCenter<Integer> {
    public OrientationChangeEvent(Integer num) {
        super(num);
    }
}
