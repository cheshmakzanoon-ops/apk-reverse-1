package net.aihelp.core.net.json;

import android.text.TextUtils;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import net.aihelp.core.util.logger.AIHelpLogger;
import org.json.JSONArray;
import org.json.JSONObject;

public class JsonHelper {
    public static <T> T toJavaObject(String str, Type type) {
        try {
            return (T) toJavaObject(str, (Class) Class.forName(type.toString().split(" ")[1].trim()));
        } catch (Throwable th) {
            th.printStackTrace();
            AIHelpLogger.error("JsonHelper toJavaObject#30", th);
            return null;
        }
    }

    public static <T> T toJavaObject(String str, Class<T> cls) {
        if (TextUtils.isEmpty(str)) {
            return null;
        }
        if (cls == String.class || cls == Integer.class || cls == Double.class || cls == Float.class) {
            return str;
        }
        try {
            T tNewInstance = cls.newInstance();
            JSONObject jSONObject = new JSONObject(str);
            for (Field field : cls.getDeclaredFields()) {
                field.setAccessible(true);
                Object objOpt = jSONObject.opt(field.getName());
                if (objOpt instanceof JSONObject) {
                    field.set(tNewInstance, toJavaObject(objOpt.toString(), (Class) field.getType()));
                } else if ((objOpt instanceof JSONArray) && "List".equals(field.getType().getSimpleName())) {
                    GenericType genericType = (GenericType) field.getAnnotation(GenericType.class);
                    if (genericType != null) {
                        field.set(tNewInstance, toJavaList(objOpt.toString(), genericType.value()));
                    }
                } else if ("String".equals(field.getType().getSimpleName())) {
                    field.set(tNewInstance, (objOpt == null || objOpt == JSONObject.NULL) ? "" : String.valueOf(objOpt));
                } else if (objOpt != null && objOpt != JSONObject.NULL) {
                    field.set(tNewInstance, objOpt);
                }
            }
            return tNewInstance;
        } catch (Exception e) {
            e.printStackTrace();
            AIHelpLogger.error("JsonHelper toJavaObject#66", e);
            return null;
        }
    }

    public static <T> List<T> toJavaList(String str, Class<T> cls) {
        ArrayList arrayList = new ArrayList();
        if (cls != null) {
            try {
                JSONArray jSONArray = new JSONArray(str);
                for (int i = 0; i < jSONArray.length(); i++) {
                    arrayList.add(toJavaObject(getJsonObject(jSONArray, i).toString(), (Class) cls));
                }
            } catch (Exception e) {
                e.printStackTrace();
                AIHelpLogger.error("JsonHelper toJavaList#82", e);
            }
        }
        return arrayList;
    }

    public static JSONObject getJsonObject(JSONArray jSONArray, int i) {
        if (jSONArray == null) {
            return new JSONObject();
        }
        JSONObject jSONObjectOptJSONObject = jSONArray.optJSONObject(i);
        return jSONObjectOptJSONObject == null ? new JSONObject() : jSONObjectOptJSONObject;
    }

    public static JSONObject getJsonObject(JSONObject jSONObject, String str) {
        if (jSONObject == null) {
            return new JSONObject();
        }
        JSONObject jSONObjectOptJSONObject = jSONObject.optJSONObject(str);
        return jSONObjectOptJSONObject == null ? new JSONObject() : jSONObjectOptJSONObject;
    }

    public static JSONArray getJsonArray() {
        return new JSONArray();
    }

    public static JSONArray getJsonArray(JSONObject jSONObject, String str) {
        if (jSONObject == null) {
            return new JSONArray();
        }
        JSONArray jSONArrayOptJSONArray = jSONObject.optJSONArray(str);
        return jSONArrayOptJSONArray == null ? new JSONArray() : jSONArrayOptJSONArray;
    }

    public static String optString(JSONObject jSONObject, String str) {
        if (jSONObject == null) {
            return "";
        }
        String strOptString = jSONObject.optString(str);
        return (TextUtils.isEmpty(strOptString) || strOptString.equals(JSONObject.NULL.toString())) ? "" : strOptString;
    }

    public static JSONArray wrap(Collection<? extends Jsonable> collection) {
        JSONArray jSONArray = new JSONArray();
        if (collection != null) {
            for (Jsonable jsonable : collection) {
                if (jsonable != null) {
                    jSONArray.put(jsonable.toJsonObject());
                }
            }
        }
        return jSONArray;
    }

    public static JSONObject getJsonObject() {
        return new JSONObject();
    }

    public static JSONObject getJsonObject(String str) {
        if (!TextUtils.isEmpty(str)) {
            try {
                return new JSONObject(str);
            } catch (Exception unused) {
            }
        }
        return new JSONObject();
    }

    public static JSONArray getJsonArray(String str) {
        if (!TextUtils.isEmpty(str)) {
            try {
                return new JSONArray(str);
            } catch (Exception unused) {
            }
        }
        return new JSONArray();
    }

    public static <T> T opt(JSONObject jSONObject, String str, T t) {
        if (jSONObject == null) {
            return t;
        }
        try {
            try {
                String str2 = String.format("opt%s", t.getClass().getSimpleName());
                if ("optString".equals(str2)) {
                    return (T) optString(jSONObject, str);
                }
                Method declaredMethod = jSONObject.getClass().getDeclaredMethod(str2, String.class, t.getClass());
                declaredMethod.setAccessible(true);
                return (T) declaredMethod.invoke(jSONObject, str, t);
            } catch (Exception unused) {
                return t;
            }
        } catch (Exception unused2) {
            if ("optInteger".equals(String.format("opt%s", t.getClass().getSimpleName()))) {
                Method declaredMethod2 = jSONObject.getClass().getDeclaredMethod("optInt", String.class);
                declaredMethod2.setAccessible(true);
                return (T) declaredMethod2.invoke(jSONObject, str);
            }
            return t;
        }
    }

    public static boolean hasKey(JSONObject jSONObject, String str) {
        if (jSONObject == null || !jSONObject.has(str)) {
            return false;
        }
        return !TextUtils.isEmpty(jSONObject.optString(str));
    }

    public static void put(JSONObject jSONObject, String str, Object obj) {
        if (jSONObject != null) {
            try {
                jSONObject.put(str, obj);
            } catch (Exception unused) {
            }
        }
    }
}
