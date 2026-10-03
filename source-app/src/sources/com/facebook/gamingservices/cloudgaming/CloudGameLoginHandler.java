package com.facebook.gamingservices.cloudgaming;

import android.content.Context;
import android.content.SharedPreferences;
import com.facebook.AccessToken;
import com.facebook.AccessTokenSource;
import com.facebook.FacebookException;
import com.facebook.GraphResponse;
import com.facebook.Profile;
import com.facebook.gamingservices.GamingPayload;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import com.facebook.gamingservices.cloudgaming.internal.SDKLogger;
import com.facebook.gamingservices.cloudgaming.internal.SDKMessageEnum;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class CloudGameLoginHandler {
    private static final int DEFAULT_TIMEOUT_IN_SEC = 5;
    private static boolean IS_RUNNING_IN_CLOUD = false;
    private static SDKLogger mLogger;

    public static synchronized AccessToken init(Context context) throws FacebookException {
        return init(context, 5);
    }

    public static synchronized AccessToken init(Context context, int timeoutInSec) throws FacebookException {
        AccessToken currentAccessToken;
        if (timeoutInSec <= 0) {
            timeoutInSec = 5;
        }
        if (!isCloudEnvReady(context, timeoutInSec)) {
            throw new FacebookException("Not running in Cloud environment.");
        }
        mLogger = SDKLogger.getInstance(context);
        GraphResponse graphResponseExecuteAndWait = DaemonRequest.executeAndWait(context, null, SDKMessageEnum.GET_ACCESS_TOKEN, timeoutInSec);
        if (graphResponseExecuteAndWait == null || graphResponseExecuteAndWait.getGraphObject() == null) {
            throw new FacebookException("Cannot receive response.");
        }
        if (graphResponseExecuteAndWait.getError() != null) {
            throw new FacebookException(graphResponseExecuteAndWait.getError().getErrorMessage());
        }
        setPackageName(graphResponseExecuteAndWait.getGraphObject(), context);
        try {
            currentAccessToken = setCurrentAccessToken(graphResponseExecuteAndWait.getGraphObject());
            GamingPayload.loadPayloadFromCloudGame(graphResponseExecuteAndWait.getGraphObject().optString("payload"));
            Profile.fetchProfileForCurrentAccessToken();
            IS_RUNNING_IN_CLOUD = true;
            mLogger.logLoginSuccess();
        } catch (JSONException e) {
            throw new FacebookException("Cannot properly handle response.", e);
        }
        return currentAccessToken;
    }

    public static boolean isRunningInCloud() {
        return IS_RUNNING_IN_CLOUD;
    }

    private static boolean isCloudEnvReady(Context context, int timeoutInSec) {
        GraphResponse graphResponseExecuteAndWait = DaemonRequest.executeAndWait(context, null, SDKMessageEnum.IS_ENV_READY, timeoutInSec);
        return (graphResponseExecuteAndWait == null || graphResponseExecuteAndWait.getGraphObject() == null || graphResponseExecuteAndWait.getError() != null) ? false : true;
    }

    public static void gameLoadComplete(Context context, DaemonRequest.Callback callback) {
        DaemonRequest.executeAsync(context, (JSONObject) null, callback, SDKMessageEnum.MARK_GAME_LOADED);
    }

    private static void setPackageName(JSONObject jsonObject, Context context) {
        String strOptString = jsonObject.optString(SDKConstants.PARAM_DAEMON_PACKAGE_NAME);
        if (strOptString.isEmpty()) {
            throw new FacebookException("Could not establish a secure connection.");
        }
        SharedPreferences.Editor editorEdit = context.getSharedPreferences(SDKConstants.PREF_DAEMON_PACKAGE_NAME, 0).edit();
        editorEdit.putString(SDKConstants.PARAM_DAEMON_PACKAGE_NAME, strOptString);
        editorEdit.commit();
    }

    private static AccessToken setCurrentAccessToken(JSONObject jsonObject) throws JSONException {
        String strOptString = jsonObject.optString(SDKConstants.PARAM_ACCESS_TOKEN);
        String strOptString2 = jsonObject.optString(SDKConstants.PARAM_ACCESS_TOKEN_SOURCE);
        String strOptString3 = jsonObject.optString(SDKConstants.PARAM_APP_ID);
        String strOptString4 = jsonObject.optString(SDKConstants.PARAM_DECLINED_PERMISSIONS);
        String strOptString5 = jsonObject.optString(SDKConstants.PARAM_EXPIRED_PERMISSIONS);
        String strOptString6 = jsonObject.optString(SDKConstants.PARAM_EXPIRATION_TIME);
        String strOptString7 = jsonObject.optString(SDKConstants.PARAM_DATA_ACCESS_EXPIRATION_TIME);
        String strOptString8 = jsonObject.optString(SDKConstants.PARAM_GRAPH_DOMAIN);
        String strOptString9 = jsonObject.optString(SDKConstants.PARAM_LAST_REFRESH_TIME);
        String strOptString10 = jsonObject.optString("permissions");
        String strOptString11 = jsonObject.optString(SDKConstants.PARAM_USER_ID);
        String strOptString12 = jsonObject.optString(SDKConstants.PARAM_SESSION_ID);
        if (strOptString.isEmpty() || strOptString3.isEmpty() || strOptString11.isEmpty()) {
            return null;
        }
        SDKLogger sDKLogger = mLogger;
        if (sDKLogger != null) {
            sDKLogger.setAppID(strOptString3);
            mLogger.setUserID(strOptString11);
            mLogger.setSessionID(strOptString12);
        }
        AccessToken accessToken = new AccessToken(strOptString, strOptString3, strOptString11, convertPermissionsStringIntoPermissionsList(strOptString10), convertPermissionsStringIntoPermissionsList(strOptString4), convertPermissionsStringIntoPermissionsList(strOptString5), !strOptString2.isEmpty() ? AccessTokenSource.valueOf(strOptString2) : null, !strOptString6.isEmpty() ? new Date(((long) Integer.parseInt(strOptString6)) * 1000) : null, !strOptString9.isEmpty() ? new Date(((long) Integer.parseInt(strOptString9)) * 1000) : null, !strOptString7.isEmpty() ? new Date(((long) Integer.parseInt(strOptString7)) * 1000) : null, strOptString8.isEmpty() ? null : strOptString8);
        AccessToken.setCurrentAccessToken(accessToken);
        return accessToken;
    }

    private static List<String> convertPermissionsStringIntoPermissionsList(String permissionsString) throws JSONException {
        ArrayList arrayList = new ArrayList();
        if (!permissionsString.isEmpty()) {
            JSONArray jSONArray = new JSONArray(permissionsString);
            for (int i = 0; i < jSONArray.length(); i++) {
                arrayList.add(jSONArray.get(i).toString());
            }
        }
        return arrayList;
    }
}
