package com.facebook.gamingservices.cloudgaming;

import android.content.Context;
import android.content.Intent;
import cn.thinkingdata.android.j$$ExternalSyntheticApiModelOutline0;
import com.facebook.FacebookRequestError;
import com.facebook.GraphResponse;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import com.facebook.gamingservices.cloudgaming.internal.SDKLogger;
import com.facebook.gamingservices.cloudgaming.internal.SDKMessageEnum;
import j$.util.concurrent.ConcurrentHashMap;
import java.util.Iterator;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;
import java.util.function.Consumer;
import java.util.function.Supplier;
import org.json.JSONException;
import org.json.JSONObject;

public class DaemonRequest {
    private Callback mCallback;
    private Context mContext;
    private SDKLogger mLogger;
    private JSONObject mParameters;
    private ConcurrentHashMap<String, CompletableFuture<GraphResponse>> mRequestStore;

    public interface Callback {
        void onCompleted(GraphResponse response);
    }

    DaemonRequest(Context context, JSONObject parameters, Callback callback) {
        this.mContext = context;
        this.mParameters = parameters;
        this.mCallback = callback;
        this.mRequestStore = DaemonReceiver.getInstance(context).getRequestStore();
        this.mLogger = SDKLogger.getInstance(context);
    }

    private void executeAsync() throws ExecutionException, InterruptedException {
        createRequest().thenAccept((Consumer<? super GraphResponse>) new Consumer<GraphResponse>() {
            @Override
            public Consumer<GraphResponse> andThen(Consumer<? super GraphResponse> consumer) {
                return j$.util.function.Consumer.-CC.$default$andThen(this, consumer);
            }

            @Override
            public void accept(GraphResponse response) {
                if (DaemonRequest.this.mCallback != null) {
                    DaemonRequest.this.mCallback.onCompleted(response);
                }
            }
        });
    }

    private GraphResponse executeAndWait() throws ExecutionException, InterruptedException {
        return (GraphResponse) createRequest().get();
    }

    private GraphResponse executeAndWait(int timeout) throws ExecutionException, InterruptedException, TimeoutException {
        return (GraphResponse) createRequest().get(timeout, TimeUnit.SECONDS);
    }

    private CompletableFuture<GraphResponse> createRequest() {
        return CompletableFuture.supplyAsync(new Supplier<GraphResponse>() {
            @Override
            public GraphResponse get() {
                String string = UUID.randomUUID().toString();
                try {
                    DaemonRequest.this.mParameters.put(SDKConstants.REQUEST_ID, string);
                    Intent intent = new Intent();
                    String string2 = DaemonRequest.this.mParameters.getString("type");
                    DaemonRequest.this.mLogger.logPreparingRequest(string2, string, DaemonRequest.this.mParameters);
                    if (!string2.equals(SDKMessageEnum.GET_ACCESS_TOKEN.toString()) && !string2.equals(SDKMessageEnum.IS_ENV_READY.toString())) {
                        String string3 = DaemonRequest.this.mContext.getSharedPreferences(SDKConstants.PREF_DAEMON_PACKAGE_NAME, 0).getString(SDKConstants.PARAM_DAEMON_PACKAGE_NAME, null);
                        if (string3 == null) {
                            return DaemonReceiver.createErrorResponse(new FacebookRequestError(-1, "DAEMON_REQUEST_EXECUTE_ASYNC_FAILED", "Unable to correctly create the request with a secure connection"), string);
                        }
                        intent.setPackage(string3);
                    }
                    intent.setAction(SDKConstants.REQUEST_ACTION);
                    Iterator<String> itKeys = DaemonRequest.this.mParameters.keys();
                    while (itKeys.hasNext()) {
                        String next = itKeys.next();
                        intent.putExtra(next, DaemonRequest.this.mParameters.getString(next));
                    }
                    j$$ExternalSyntheticApiModelOutline0.m615m();
                    CompletableFuture completableFutureM611m = j$$ExternalSyntheticApiModelOutline0.m611m();
                    DaemonRequest.this.mRequestStore.put(string, completableFutureM611m);
                    DaemonRequest.this.mContext.sendBroadcast(intent);
                    DaemonRequest.this.mLogger.logSentRequest(string2, string, DaemonRequest.this.mParameters);
                    return (GraphResponse) completableFutureM611m.get();
                } catch (InterruptedException | ExecutionException | JSONException unused) {
                    return DaemonReceiver.createErrorResponse(new FacebookRequestError(-1, "DAEMON_REQUEST_EXECUTE_ASYNC_FAILED", "Unable to correctly create the request or obtain response"), string);
                }
            }
        });
    }

    public static void executeAsync(Context context, JSONObject parameters, Callback callback, SDKMessageEnum type) {
        try {
            new DaemonRequest(context, parameters == null ? new JSONObject().put("type", type.toString()) : parameters.put("type", type.toString()), callback).executeAsync();
        } catch (InterruptedException | ExecutionException | JSONException unused) {
            if (callback != null) {
                callback.onCompleted(DaemonReceiver.createErrorResponse(new FacebookRequestError(-1, "DAEMON_REQUEST_EXECUTE_ASYNC_FAILED", "Unable to correctly create the request or obtain response"), (String) null));
            }
        }
    }

    public static GraphResponse executeAndWait(Context context, JSONObject parameters, SDKMessageEnum type) {
        try {
            return new DaemonRequest(context, parameters == null ? new JSONObject().put("type", type.toString()) : parameters.put("type", type.toString()), null).executeAndWait();
        } catch (InterruptedException | ExecutionException | JSONException unused) {
            return DaemonReceiver.createErrorResponse(new FacebookRequestError(-1, "DAEMON_REQUEST_EXECUTE_ASYNC_FAILED", "Unable to correctly create the request or obtain response"), (String) null);
        }
    }

    public static GraphResponse executeAndWait(Context context, JSONObject parameters, SDKMessageEnum type, int timeout) {
        try {
            return new DaemonRequest(context, parameters == null ? new JSONObject().put("type", type.toString()) : parameters.put("type", type.toString()), null).executeAndWait(timeout);
        } catch (InterruptedException | ExecutionException | TimeoutException | JSONException unused) {
            return DaemonReceiver.createErrorResponse(new FacebookRequestError(-1, "DAEMON_REQUEST_EXECUTE_ASYNC_FAILED", "Unable to correctly create the request or obtain response"), (String) null);
        }
    }

    public static void executeAsync(Context context, JSONObject parameters, Callback callback, String type) {
        JSONObject jSONObjectPut;
        try {
            if (parameters == null) {
                jSONObjectPut = new JSONObject().put("type", type);
            } else {
                jSONObjectPut = parameters.put("type", type);
            }
            new DaemonRequest(context, jSONObjectPut, callback).executeAsync();
        } catch (InterruptedException | ExecutionException | JSONException unused) {
            if (callback != null) {
                callback.onCompleted(DaemonReceiver.createErrorResponse(new FacebookRequestError(-1, "DAEMON_REQUEST_EXECUTE_ASYNC_FAILED", "Unable to correctly create the request or obtain response"), (String) null));
            }
        }
    }
}
