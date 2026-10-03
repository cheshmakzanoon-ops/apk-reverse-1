package net.aihelp.core.net.http.callback;

import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.HashMap;

public abstract class BaseCallback<T> {
    private HashMap<String, String> paramsMap;
    private String requestUrl;
    private Type type;

    public abstract void onAsyncFailure(String str, int i, String str2);

    public abstract void onAsyncReqProgress(long j, long j2, int i);

    public abstract void onAsyncReqSuccess(T t);

    public abstract void onFailure(String str, int i, String str2);

    public abstract void onReqProgress(long j, long j2, int i);

    public abstract void onReqSuccess(T t);

    public String getRequestUrl() {
        return this.requestUrl;
    }

    public void setRequestUrl(String str) {
        this.requestUrl = str;
    }

    public HashMap<String, String> getParamsMap() {
        return this.paramsMap;
    }

    public void setParamsMap(HashMap<String, String> map) {
        this.paramsMap = map;
    }

    public Type getType() {
        return this.type;
    }

    public void setType(Type type) {
        this.type = type;
    }

    public BaseCallback() {
        Type type = ((ParameterizedType) getClass().getGenericSuperclass()).getActualTypeArguments()[0];
        this.type = type;
        if (type == null) {
            throw new IllegalArgumentException("ReqCallBack must have a generic type!");
        }
    }
}
