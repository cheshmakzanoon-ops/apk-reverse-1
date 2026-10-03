package net.aihelp.data.event;

import net.aihelp.core.util.bus.event.EventCenter;

public class SupportActionEvent extends EventCenter<Integer> {
    public SupportActionEvent(int i) {
        super(i);
    }

    public SupportActionEvent(int i, int i2) {
        super(i, Integer.valueOf(i2));
    }

    public int getSupportAction() {
        return ((Integer) super.getEvent()).intValue();
    }
}
