package com.facebook.internal;

import android.os.Bundle;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import kotlin.Metadata;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.Intrinsics;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

@Metadata(d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010%\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\bÆ\u0002\u0018\u00002\u00020\u0001:\u0001\rB\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\nH\u0007J\u0010\u0010\u000b\u001a\u00020\n2\u0006\u0010\f\u001a\u00020\bH\u0007R\u001e\u0010\u0003\u001a\u0012\u0012\b\u0012\u0006\u0012\u0002\b\u00030\u0005\u0012\u0004\u0012\u00020\u00060\u0004X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u000e"}, d2 = {"Lcom/facebook/internal/BundleJSONConverter;", "", "()V", "SETTERS", "", "Ljava/lang/Class;", "Lcom/facebook/internal/BundleJSONConverter$Setter;", "convertToBundle", "Landroid/os/Bundle;", "jsonObject", "Lorg/json/JSONObject;", "convertToJSON", "bundle", "Setter", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class BundleJSONConverter {
    public static final BundleJSONConverter INSTANCE = new BundleJSONConverter();
    private static final Map<Class<?>, Setter> SETTERS;

    @Metadata(d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\bf\u0018\u00002\u00020\u0001J \u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u00072\u0006\u0010\b\u001a\u00020\u0001H&J \u0010\t\u001a\u00020\u00032\u0006\u0010\n\u001a\u00020\u000b2\u0006\u0010\u0006\u001a\u00020\u00072\u0006\u0010\b\u001a\u00020\u0001H&¨\u0006\f"}, d2 = {"Lcom/facebook/internal/BundleJSONConverter$Setter;", "", "setOnBundle", "", "bundle", "Landroid/os/Bundle;", SDKConstants.PARAM_KEY, "", SDKConstants.PARAM_VALUE, "setOnJSON", "json", "Lorg/json/JSONObject;", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public interface Setter {
        void setOnBundle(Bundle bundle, String key, Object value) throws JSONException;

        void setOnJSON(JSONObject json, String key, Object value) throws JSONException;
    }

    private BundleJSONConverter() {
    }

    static {
        HashMap map = new HashMap();
        SETTERS = map;
        map.put(Boolean.class, new Setter() {
            @Override
            public void setOnBundle(Bundle bundle, String key, Object value) throws JSONException {
                Intrinsics.checkNotNullParameter(bundle, "bundle");
                Intrinsics.checkNotNullParameter(key, SDKConstants.PARAM_KEY);
                Intrinsics.checkNotNullParameter(value, SDKConstants.PARAM_VALUE);
                bundle.putBoolean(key, ((Boolean) value).booleanValue());
            }

            @Override
            public void setOnJSON(JSONObject json, String key, Object value) throws JSONException {
                Intrinsics.checkNotNullParameter(json, "json");
                Intrinsics.checkNotNullParameter(key, SDKConstants.PARAM_KEY);
                Intrinsics.checkNotNullParameter(value, SDKConstants.PARAM_VALUE);
                json.put(key, value);
            }
        });
        map.put(Integer.class, new Setter() {
            @Override
            public void setOnBundle(Bundle bundle, String key, Object value) throws JSONException {
                Intrinsics.checkNotNullParameter(bundle, "bundle");
                Intrinsics.checkNotNullParameter(key, SDKConstants.PARAM_KEY);
                Intrinsics.checkNotNullParameter(value, SDKConstants.PARAM_VALUE);
                bundle.putInt(key, ((Integer) value).intValue());
            }

            @Override
            public void setOnJSON(JSONObject json, String key, Object value) throws JSONException {
                Intrinsics.checkNotNullParameter(json, "json");
                Intrinsics.checkNotNullParameter(key, SDKConstants.PARAM_KEY);
                Intrinsics.checkNotNullParameter(value, SDKConstants.PARAM_VALUE);
                json.put(key, value);
            }
        });
        map.put(Long.class, new Setter() {
            @Override
            public void setOnBundle(Bundle bundle, String key, Object value) throws JSONException {
                Intrinsics.checkNotNullParameter(bundle, "bundle");
                Intrinsics.checkNotNullParameter(key, SDKConstants.PARAM_KEY);
                Intrinsics.checkNotNullParameter(value, SDKConstants.PARAM_VALUE);
                bundle.putLong(key, ((Long) value).longValue());
            }

            @Override
            public void setOnJSON(JSONObject json, String key, Object value) throws JSONException {
                Intrinsics.checkNotNullParameter(json, "json");
                Intrinsics.checkNotNullParameter(key, SDKConstants.PARAM_KEY);
                Intrinsics.checkNotNullParameter(value, SDKConstants.PARAM_VALUE);
                json.put(key, value);
            }
        });
        map.put(Double.class, new Setter() {
            @Override
            public void setOnBundle(Bundle bundle, String key, Object value) throws JSONException {
                Intrinsics.checkNotNullParameter(bundle, "bundle");
                Intrinsics.checkNotNullParameter(key, SDKConstants.PARAM_KEY);
                Intrinsics.checkNotNullParameter(value, SDKConstants.PARAM_VALUE);
                bundle.putDouble(key, ((Double) value).doubleValue());
            }

            @Override
            public void setOnJSON(JSONObject json, String key, Object value) throws JSONException {
                Intrinsics.checkNotNullParameter(json, "json");
                Intrinsics.checkNotNullParameter(key, SDKConstants.PARAM_KEY);
                Intrinsics.checkNotNullParameter(value, SDKConstants.PARAM_VALUE);
                json.put(key, value);
            }
        });
        map.put(String.class, new Setter() {
            @Override
            public void setOnBundle(Bundle bundle, String key, Object value) throws JSONException {
                Intrinsics.checkNotNullParameter(bundle, "bundle");
                Intrinsics.checkNotNullParameter(key, SDKConstants.PARAM_KEY);
                Intrinsics.checkNotNullParameter(value, SDKConstants.PARAM_VALUE);
                bundle.putString(key, (String) value);
            }

            @Override
            public void setOnJSON(JSONObject json, String key, Object value) throws JSONException {
                Intrinsics.checkNotNullParameter(json, "json");
                Intrinsics.checkNotNullParameter(key, SDKConstants.PARAM_KEY);
                Intrinsics.checkNotNullParameter(value, SDKConstants.PARAM_VALUE);
                json.put(key, value);
            }
        });
        map.put(String[].class, new Setter() {
            @Override
            public void setOnBundle(Bundle bundle, String key, Object value) throws JSONException {
                Intrinsics.checkNotNullParameter(bundle, "bundle");
                Intrinsics.checkNotNullParameter(key, SDKConstants.PARAM_KEY);
                Intrinsics.checkNotNullParameter(value, SDKConstants.PARAM_VALUE);
                throw new IllegalArgumentException("Unexpected type from JSON");
            }

            @Override
            public void setOnJSON(JSONObject json, String key, Object value) throws JSONException {
                Intrinsics.checkNotNullParameter(json, "json");
                Intrinsics.checkNotNullParameter(key, SDKConstants.PARAM_KEY);
                Intrinsics.checkNotNullParameter(value, SDKConstants.PARAM_VALUE);
                JSONArray jSONArray = new JSONArray();
                String[] strArr = (String[]) value;
                int length = strArr.length;
                int i = 0;
                while (i < length) {
                    String str = strArr[i];
                    i++;
                    jSONArray.put(str);
                }
                json.put(key, jSONArray);
            }
        });
        map.put(JSONArray.class, new Setter() {
            @Override
            public void setOnBundle(Bundle bundle, String key, Object value) throws JSONException {
                Intrinsics.checkNotNullParameter(bundle, "bundle");
                Intrinsics.checkNotNullParameter(key, SDKConstants.PARAM_KEY);
                Intrinsics.checkNotNullParameter(value, SDKConstants.PARAM_VALUE);
                JSONArray jSONArray = (JSONArray) value;
                ArrayList arrayList = new ArrayList();
                if (jSONArray.length() == 0) {
                    bundle.putStringArrayList(key, arrayList);
                    return;
                }
                int length = jSONArray.length();
                if (length > 0) {
                    int i = 0;
                    while (true) {
                        int i2 = i + 1;
                        Object obj = jSONArray.get(i);
                        if (obj instanceof String) {
                            arrayList.add(obj);
                            if (i2 < length) {
                                i = i2;
                            }
                        } else {
                            throw new IllegalArgumentException(Intrinsics.stringPlus("Unexpected type in an array: ", obj.getClass()));
                        }
                    }
                }
                bundle.putStringArrayList(key, arrayList);
            }

            @Override
            public void setOnJSON(JSONObject json, String key, Object value) throws JSONException {
                Intrinsics.checkNotNullParameter(json, "json");
                Intrinsics.checkNotNullParameter(key, SDKConstants.PARAM_KEY);
                Intrinsics.checkNotNullParameter(value, SDKConstants.PARAM_VALUE);
                throw new IllegalArgumentException("JSONArray's are not supported in bundles.");
            }
        });
    }

    @JvmStatic
    public static final JSONObject convertToJSON(Bundle bundle) throws JSONException {
        Intrinsics.checkNotNullParameter(bundle, "bundle");
        JSONObject jSONObject = new JSONObject();
        for (String str : bundle.keySet()) {
            Object obj = bundle.get(str);
            if (obj != null) {
                if (obj instanceof List) {
                    JSONArray jSONArray = new JSONArray();
                    Iterator it = ((List) obj).iterator();
                    while (it.hasNext()) {
                        jSONArray.put((String) it.next());
                    }
                    jSONObject.put(str, jSONArray);
                } else if (obj instanceof Bundle) {
                    jSONObject.put(str, convertToJSON((Bundle) obj));
                } else {
                    Setter setter = SETTERS.get(obj.getClass());
                    if (setter == null) {
                        throw new IllegalArgumentException(Intrinsics.stringPlus("Unsupported type: ", obj.getClass()));
                    }
                    Intrinsics.checkNotNullExpressionValue(str, SDKConstants.PARAM_KEY);
                    setter.setOnJSON(jSONObject, str, obj);
                }
            }
        }
        return jSONObject;
    }

    @JvmStatic
    public static final Bundle convertToBundle(JSONObject jsonObject) throws JSONException {
        Intrinsics.checkNotNullParameter(jsonObject, "jsonObject");
        Bundle bundle = new Bundle();
        Iterator<String> itKeys = jsonObject.keys();
        while (itKeys.hasNext()) {
            String next = itKeys.next();
            Object obj = jsonObject.get(next);
            if (obj != JSONObject.NULL) {
                if (obj instanceof JSONObject) {
                    bundle.putBundle(next, convertToBundle((JSONObject) obj));
                } else {
                    Setter setter = SETTERS.get(obj.getClass());
                    if (setter == null) {
                        throw new IllegalArgumentException(Intrinsics.stringPlus("Unsupported type: ", obj.getClass()));
                    }
                    Intrinsics.checkNotNullExpressionValue(next, SDKConstants.PARAM_KEY);
                    Intrinsics.checkNotNullExpressionValue(obj, SDKConstants.PARAM_VALUE);
                    setter.setOnBundle(bundle, next, obj);
                }
            }
        }
        return bundle;
    }
}
