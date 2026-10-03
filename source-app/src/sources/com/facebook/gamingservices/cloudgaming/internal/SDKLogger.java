package com.facebook.gamingservices.cloudgaming.internal;

import android.content.Context;
import android.os.Bundle;
import com.facebook.FacebookRequestError;
import com.facebook.appevents.InternalAppEventsLogger;
import j$.util.concurrent.ConcurrentHashMap;
import j$.util.concurrent.ConcurrentMap;
import org.json.JSONObject;

public class SDKLogger {
    private static SDKLogger instance;
    private final InternalAppEventsLogger logger;
    private String appID = null;
    private String userID = null;
    private String sessionID = null;
    private ConcurrentHashMap<String, String> requestIDToFunctionTypeMap = new ConcurrentHashMap<>();

    private SDKLogger(Context context) {
        this.logger = new InternalAppEventsLogger(context);
    }

    public static synchronized SDKLogger getInstance(Context context) {
        if (instance == null) {
            instance = new SDKLogger(context);
        }
        return instance;
    }

    public static void logInternalError(Context context, SDKMessageEnum functionType, Exception e) {
        getInstance(context).logInternalError(functionType, e);
    }

    public void logPreparingRequest(String functionType, String requestID, JSONObject payloads) {
        Bundle parametersWithRequestIDAndFunctionType = getParametersWithRequestIDAndFunctionType(requestID, functionType);
        parametersWithRequestIDAndFunctionType.putString("payload", payloads.toString());
        this.logger.logEventImplicitly(SDKAnalyticsEvents.EVENT_PREPARING_REQUEST, parametersWithRequestIDAndFunctionType);
    }

    public void logSentRequest(String functionType, String requestID, JSONObject payloads) {
        Bundle parametersWithRequestIDAndFunctionType = getParametersWithRequestIDAndFunctionType(requestID, functionType);
        this.requestIDToFunctionTypeMap.put(requestID, functionType);
        parametersWithRequestIDAndFunctionType.putString("payload", payloads.toString());
        this.logger.logEventImplicitly(SDKAnalyticsEvents.EVENT_SENT_REQUEST, parametersWithRequestIDAndFunctionType);
    }

    public void logSendingSuccessResponse(String requestID) {
        this.logger.logEventImplicitly(SDKAnalyticsEvents.EVENT_SENDING_SUCCESS_RESPONSE, getParametersWithRequestIDAndFunctionType(requestID));
    }

    public void logSendingErrorResponse(FacebookRequestError error, String requestID) {
        Bundle parametersWithRequestIDAndFunctionType = getParametersWithRequestIDAndFunctionType(requestID);
        parametersWithRequestIDAndFunctionType.putString("error_code", Integer.toString(error.getErrorCode()));
        parametersWithRequestIDAndFunctionType.putString("error_type", error.getErrorType());
        parametersWithRequestIDAndFunctionType.putString("error_message", error.getErrorMessage());
        this.logger.logEventImplicitly(SDKAnalyticsEvents.EVENT_SENDING_ERROR_RESPONSE, parametersWithRequestIDAndFunctionType);
    }

    public void logLoginSuccess() {
        this.logger.logEventImplicitly(SDKAnalyticsEvents.EVENT_LOGIN_SUCCESS, getInitParameters());
    }

    public void logGameLoadComplete() {
        this.logger.logEventImplicitly(SDKAnalyticsEvents.EVENT_GAME_LOAD_COMPLETE, getInitParameters());
    }

    public void logInternalError(SDKMessageEnum functionType, Exception e) {
        Bundle initParameters = getInitParameters();
        initParameters.putString(SDKAnalyticsEvents.PARAMETER_FUNCTION_TYPE, functionType.toString());
        initParameters.putString("error_type", e.getClass().getName());
        initParameters.putString("error_message", e.getMessage());
        this.logger.logEventImplicitly(SDKAnalyticsEvents.EVENT_INTERNAL_ERROR, initParameters);
    }

    public void setAppID(String appID) {
        this.appID = appID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public void setSessionID(String sessionID) {
        this.sessionID = sessionID;
    }

    private Bundle getParametersWithRequestIDAndFunctionType(String requestID) {
        Bundle initParameters = getInitParameters();
        if (requestID != null) {
            String str = (String) ConcurrentMap.-EL.getOrDefault(this.requestIDToFunctionTypeMap, requestID, (Object) null);
            initParameters.putString(SDKAnalyticsEvents.PARAMETER_REQUEST_ID, requestID);
            if (str != null) {
                initParameters.putString(SDKAnalyticsEvents.PARAMETER_FUNCTION_TYPE, str);
                this.requestIDToFunctionTypeMap.remove(requestID);
            }
        }
        return initParameters;
    }

    private Bundle getParametersWithRequestIDAndFunctionType(String requestID, String functionType) {
        Bundle initParameters = getInitParameters();
        initParameters.putString(SDKAnalyticsEvents.PARAMETER_REQUEST_ID, requestID);
        initParameters.putString(SDKAnalyticsEvents.PARAMETER_FUNCTION_TYPE, functionType);
        return initParameters;
    }

    private Bundle getInitParameters() {
        Bundle bundle = new Bundle();
        String str = this.appID;
        if (str != null) {
            bundle.putString("app_id", str);
        }
        String str2 = this.sessionID;
        if (str2 != null) {
            bundle.putString(SDKAnalyticsEvents.PARAMETER_SESSION_ID, str2);
        }
        return bundle;
    }
}
