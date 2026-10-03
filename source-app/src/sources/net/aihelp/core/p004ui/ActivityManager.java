package net.aihelp.core.p004ui;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public enum ActivityManager {
    INSTANCE;

    private final List<WeakReference<BaseActivity>> sActivityList = new ArrayList();

    ActivityManager() {
    }

    public void register(BaseActivity baseActivity) {
        this.sActivityList.add(new WeakReference<>(baseActivity));
    }

    public void unregister(BaseActivity baseActivity) {
        Iterator<WeakReference<BaseActivity>> it = this.sActivityList.iterator();
        while (it.hasNext()) {
            WeakReference<BaseActivity> next = it.next();
            if (next != null && next.get() != null && next.get() == baseActivity) {
                it.remove();
            }
        }
    }

    public void finishAll() {
        for (int size = this.sActivityList.size() - 1; size >= 0; size--) {
            WeakReference<BaseActivity> weakReference = this.sActivityList.get(size);
            if (weakReference != null && weakReference.get() != null) {
                weakReference.get().finish();
            }
        }
    }
}
