package net.aihelp.core.net.http.callback;

import net.aihelp.config.AIHelpContext;
import net.aihelp.utils.TLog;

public abstract class UploadCallback<T> extends BaseCallback<T> {
    @Override
    public void onAsyncFailure(String str, int i, String str2) {
    }

    @Override
    public void onAsyncReqProgress(long j, long j2, int i) {
    }

    @Override
    public void onAsyncReqSuccess(T t) {
    }

    public boolean onFailure(int i, String str) {
        return true;
    }

    @Override
    public void onReqProgress(long j, long j2, int i) {
    }

    @Override
    public void onReqSuccess(T t) {
    }

    @Override
    public void onFailure(String str, int i, String str2) {
        TLog.m138d("UploadCallback onFailure: " + str + " : " + i + " <-> " + str2);
        if (onFailure(i, str2) || i != 200) {
            AIHelpContext.getInstance().getContext();
        }
    }
}
