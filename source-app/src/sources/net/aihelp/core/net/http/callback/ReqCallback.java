package net.aihelp.core.net.http.callback;

import net.aihelp.utils.TLog;

public abstract class ReqCallback<T> extends BaseCallback<T> {
    @Override
    public void onAsyncFailure(String str, int i, String str2) {
    }

    @Override
    public void onAsyncReqProgress(long j, long j2, int i) {
    }

    @Override
    public void onAsyncReqSuccess(T t) {
    }

    @Override
    public void onReqProgress(long j, long j2, int i) {
    }

    @Override
    public void onReqSuccess(T t) {
    }

    @Override
    public void onFailure(String str, int i, String str2) {
        TLog.m138d("ReqCallback onFailure: " + str + ", errorMsg: " + str2);
    }
}
