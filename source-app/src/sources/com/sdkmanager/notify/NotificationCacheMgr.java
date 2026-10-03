package com.sdkmanager.notify;

import android.content.Context;
import com.sdkmanager.PushUtilManager;

public class NotificationCacheMgr {
    private static NotificationCacheMgr _inst;
    private Context _context = null;

    public Context getContext() {
        return this._context;
    }

    public void Init(Context context) {
        this._context = context;
    }

    public static NotificationCacheMgr getInstance() {
        if (_inst == null) {
            synchronized (PushUtilManager.class) {
                if (_inst == null) {
                    _inst = new NotificationCacheMgr();
                }
            }
        }
        return _inst;
    }
}
