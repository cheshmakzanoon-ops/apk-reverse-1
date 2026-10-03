package net.aihelp.core.util.crash;

import android.content.Context;

public interface OnExceptionCaughtListener {
    void onExceptionCaught(Context context, Throwable th);
}
