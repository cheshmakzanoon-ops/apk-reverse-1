package com.appsflyer.internal;

import java.util.ArrayList;
import java.util.List;
import kotlin.Result;
import kotlin.ResultKt;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.Intrinsics;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public final class AFh1mSDK {
    public AFh1jSDK AFInAppEventType;
    public final AFh1lSDK valueOf;
    public final AFh1kSDK values;

    public AFh1mSDK(JSONObject jSONObject) {
        Intrinsics.checkNotNullParameter(jSONObject, "");
        this.AFInAppEventType = AFInAppEventType(jSONObject);
        this.valueOf = AFKeystoreWrapper(jSONObject);
        this.values = AFInAppEventParameterName(jSONObject);
    }

    private static AFh1kSDK AFInAppEventParameterName(JSONObject jSONObject) {
        Object obj;
        try {
            Result.Companion companion = Result.Companion;
            JSONObject jSONObjectAFInAppEventParameterName = AFInAppEventParameterName(jSONObject, "meta_data");
            obj = Result.constructor-impl(jSONObjectAFInAppEventParameterName != null ? new AFh1kSDK(jSONObjectAFInAppEventParameterName.optDouble("send_rate", 1.0d)) : null);
        } catch (Throwable th) {
            Result.Companion companion2 = Result.Companion;
            obj = Result.constructor-impl(ResultKt.createFailure(th));
        }
        return (AFh1kSDK) (Result.isFailure-impl(obj) ? null : obj);
    }

    private static AFh1lSDK AFKeystoreWrapper(JSONObject jSONObject) {
        Object obj;
        try {
            Result.Companion companion = Result.Companion;
            JSONObject jSONObjectAFInAppEventParameterName = AFInAppEventParameterName(jSONObject, "exc_mngr");
            obj = Result.constructor-impl(jSONObjectAFInAppEventParameterName != null ? new AFh1lSDK(jSONObjectAFInAppEventParameterName.getString("sdk_ver"), jSONObjectAFInAppEventParameterName.optInt("min", -1), jSONObjectAFInAppEventParameterName.optInt("expire", -1), jSONObjectAFInAppEventParameterName.optLong("ttl", -1L)) : null);
        } catch (Throwable th) {
            Result.Companion companion2 = Result.Companion;
            obj = Result.constructor-impl(ResultKt.createFailure(th));
        }
        return (AFh1lSDK) (Result.isFailure-impl(obj) ? null : obj);
    }

    private static AFh1jSDK AFInAppEventType(JSONObject jSONObject) {
        Object obj;
        AFh1jSDK aFh1jSDK;
        List listEmptyList;
        try {
            Result.Companion companion = Result.Companion;
            JSONObject jSONObjectAFInAppEventParameterName = AFInAppEventParameterName(jSONObject, "r_debugger");
            if (jSONObjectAFInAppEventParameterName != null) {
                long j = jSONObjectAFInAppEventParameterName.getLong("ttl");
                int i = jSONObjectAFInAppEventParameterName.getInt("counter");
                String strOptString = jSONObjectAFInAppEventParameterName.optString("app_ver", "");
                String strOptString2 = jSONObjectAFInAppEventParameterName.optString("sdk_ver", "");
                float fOptDouble = (float) jSONObjectAFInAppEventParameterName.optDouble("ratio", 1.0d);
                JSONArray jSONArrayOptJSONArray = jSONObjectAFInAppEventParameterName.optJSONArray("tags");
                if (jSONArrayOptJSONArray != null) {
                    Intrinsics.checkNotNullExpressionValue(jSONArrayOptJSONArray, "");
                    ArrayList arrayList = new ArrayList();
                    int length = jSONArrayOptJSONArray.length();
                    for (int i2 = 0; i2 < length; i2++) {
                        String string = jSONArrayOptJSONArray.getString(i2);
                        Intrinsics.checkNotNullExpressionValue(string, "");
                        arrayList.add(string);
                    }
                    listEmptyList = arrayList;
                } else {
                    listEmptyList = CollectionsKt.emptyList();
                }
                Intrinsics.checkNotNullExpressionValue(strOptString, "");
                Intrinsics.checkNotNullExpressionValue(strOptString2, "");
                aFh1jSDK = new AFh1jSDK(j, fOptDouble, listEmptyList, i, strOptString, strOptString2);
            } else {
                aFh1jSDK = null;
            }
            obj = Result.constructor-impl(aFh1jSDK);
        } catch (Throwable th) {
            Result.Companion companion2 = Result.Companion;
            obj = Result.constructor-impl(ResultKt.createFailure(th));
        }
        return (AFh1jSDK) (Result.isFailure-impl(obj) ? null : obj);
    }

    private static JSONObject AFInAppEventParameterName(JSONObject jSONObject, String str) throws JSONException, NullPointerException {
        JSONObject jSONObjectOptJSONObject;
        if (!jSONObject.has(str) || (jSONObjectOptJSONObject = jSONObject.getJSONArray(str).optJSONObject(0).optJSONObject("data")) == null) {
            return null;
        }
        return jSONObjectOptJSONObject.optJSONObject("v1");
    }

    public final boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (!Intrinsics.areEqual(getClass(), obj != null ? obj.getClass() : null)) {
            return false;
        }
        if (obj != null) {
            AFh1mSDK aFh1mSDK = (AFh1mSDK) obj;
            return Intrinsics.areEqual(this.valueOf, aFh1mSDK.valueOf) && Intrinsics.areEqual(this.values, aFh1mSDK.values) && Intrinsics.areEqual(this.AFInAppEventType, aFh1mSDK.AFInAppEventType);
        }
        throw new NullPointerException("null cannot be cast to non-null type com.appsflyer.internal.model.rc.Features");
    }

    public final int hashCode() {
        AFh1lSDK aFh1lSDK = this.valueOf;
        int iHashCode = (aFh1lSDK != null ? aFh1lSDK.hashCode() : 0) * 31;
        AFh1kSDK aFh1kSDK = this.values;
        int iHashCode2 = (iHashCode + (aFh1kSDK != null ? aFh1kSDK.hashCode() : 0)) * 31;
        AFh1jSDK aFh1jSDK = this.AFInAppEventType;
        return iHashCode2 + (aFh1jSDK != null ? aFh1jSDK.hashCode() : 0);
    }
}
