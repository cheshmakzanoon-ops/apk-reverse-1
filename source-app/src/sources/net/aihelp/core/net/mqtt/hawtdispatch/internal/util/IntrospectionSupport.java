package net.aihelp.core.net.mqtt.hawtdispatch.internal.util;

import java.lang.reflect.Array;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;

public final class IntrospectionSupport {
    public static String convertToString(Object obj, Class<?> cls) {
        return null;
    }

    private static boolean isSettableType(Class<?> cls) {
        return false;
    }

    static {
        new String[]{"org.springframework.beans.propertyeditors", "org.apache.activemq.util"};
    }

    private IntrospectionSupport() {
    }

    public static boolean getProperties(Object obj, Map map, String str) {
        String strConvertToString;
        if (obj == null) {
            throw new IllegalArgumentException("target was null.");
        }
        if (map == null) {
            throw new IllegalArgumentException("props was null.");
        }
        if (str == null) {
            str = "";
        }
        boolean z = false;
        for (Method method : obj.getClass().getMethods()) {
            String name = method.getName();
            Class<?> returnType = method.getReturnType();
            Class<?>[] parameterTypes = method.getParameterTypes();
            if ((name.startsWith("is") || name.startsWith("get")) && parameterTypes.length == 0 && returnType != null && isSettableType(returnType)) {
                try {
                    Object objInvoke = method.invoke(obj, null);
                    if (objInvoke != null && (strConvertToString = convertToString(objInvoke, returnType)) != null) {
                        map.put(str + (name.startsWith("get") ? name.substring(3, 4).toLowerCase() + name.substring(4) : name.substring(2, 3).toLowerCase() + name.substring(3)), strConvertToString);
                        z = true;
                    }
                } catch (Throwable unused) {
                }
            }
        }
        return z;
    }

    public static boolean setProperties(Object obj, Map<String, ?> map, String str) {
        if (obj == null) {
            throw new IllegalArgumentException("target was null.");
        }
        if (map == null) {
            throw new IllegalArgumentException("props was null.");
        }
        Iterator<String> it = map.keySet().iterator();
        boolean z = false;
        while (it.hasNext()) {
            String next = it.next();
            if (next.startsWith(str)) {
                if (setProperty(obj, next.substring(str.length()), map.get(next))) {
                    it.remove();
                    z = true;
                }
            }
        }
        return z;
    }

    public static Map<String, Object> extractProperties(Map map, String str) {
        if (map == null) {
            throw new IllegalArgumentException("props was null.");
        }
        HashMap map2 = new HashMap(map.size());
        Iterator it = map.keySet().iterator();
        while (it.hasNext()) {
            String str2 = (String) it.next();
            if (str2.startsWith(str)) {
                map2.put(str2.substring(str.length()), map.get(str2));
                it.remove();
            }
        }
        return map2;
    }

    public static boolean setProperties(Object obj, Map map) {
        if (obj == null) {
            throw new IllegalArgumentException("target was null.");
        }
        if (map == null) {
            throw new IllegalArgumentException("props was null.");
        }
        Iterator it = map.entrySet().iterator();
        boolean z = false;
        while (it.hasNext()) {
            Map.Entry entry = (Map.Entry) it.next();
            if (setProperty(obj, (String) entry.getKey(), entry.getValue())) {
                it.remove();
                z = true;
            }
        }
        return z;
    }

    public static Class<?> getPropertyType(Object obj, String str) {
        Method methodFindSetterMethod = findSetterMethod(obj.getClass(), str);
        if (methodFindSetterMethod == null) {
            return null;
        }
        return methodFindSetterMethod.getParameterTypes()[0];
    }

    public static boolean setProperty(Object obj, String str, Object obj2) {
        try {
            Method methodFindSetterMethod = findSetterMethod(obj.getClass(), str);
            if (methodFindSetterMethod == null) {
                return false;
            }
            if (obj2 == null || obj2.getClass() == methodFindSetterMethod.getParameterTypes()[0]) {
                methodFindSetterMethod.invoke(obj, obj2);
            } else {
                methodFindSetterMethod.invoke(obj, convert(obj2, methodFindSetterMethod.getParameterTypes()[0]));
            }
            return true;
        } catch (Throwable unused) {
            return false;
        }
    }

    private static Object convert(Object obj, Class<?> cls) {
        if (!cls.isArray() || !obj.getClass().isArray()) {
            return null;
        }
        int length = Array.getLength(obj);
        Class<?> componentType = cls.getComponentType();
        Object objNewInstance = Array.newInstance(componentType, length);
        for (int i = 0; i < length; i++) {
            Array.set(objNewInstance, i, convert(Array.get(obj, i), componentType));
        }
        return objNewInstance;
    }

    private static Method findSetterMethod(Class<?> cls, String str) {
        StringBuilder sb = new StringBuilder("set");
        sb.append(str.substring(0, 1).toUpperCase());
        sb.append(str.substring(1));
        String string = sb.toString();
        for (Method method : cls.getMethods()) {
            Class<?>[] parameterTypes = method.getParameterTypes();
            if (method.getName().equals(string) && parameterTypes.length == 1) {
                return method;
            }
        }
        return null;
    }

    public static String toString(Object obj) {
        return toString(obj, Object.class, null, null);
    }

    public static String toString(Object obj, String... strArr) {
        return toString(obj, Object.class, null, strArr);
    }

    public static String toString(Object obj, Class<?> cls) {
        return toString(obj, cls, null, null);
    }

    public static String toString(Object obj, Map<String, Object> map, String... strArr) {
        return toString(obj, Object.class, map, strArr);
    }

    public static String toString(Object obj, Class<?> cls, Map<String, Object> map, String[] strArr) {
        boolean z;
        String string;
        try {
            LinkedHashMap linkedHashMap = new LinkedHashMap();
            addFields(obj, obj.getClass(), cls, linkedHashMap);
            if (map != null) {
                for (String str : map.keySet()) {
                    linkedHashMap.put(str, map.get(str));
                }
            }
            if (strArr != null) {
                linkedHashMap.keySet().retainAll(Arrays.asList(strArr));
            }
            LinkedHashMap linkedHashMap2 = new LinkedHashMap();
            Iterator it = linkedHashMap.entrySet().iterator();
            boolean z2 = false;
            while (true) {
                z = true;
                if (!it.hasNext()) {
                    break;
                }
                Map.Entry entry = (Map.Entry) it.next();
                String str2 = (String) entry.getKey();
                if (entry.getValue() != null) {
                    string = entry.getValue().toString();
                    if (string != null && (string.indexOf(10) >= 0 || str2.length() + string.length() > 70)) {
                        z2 = true;
                    }
                } else {
                    string = null;
                }
                linkedHashMap2.put(str2, string);
            }
            StringBuffer stringBuffer = new StringBuffer();
            if (z2) {
                stringBuffer.append("{\n");
                for (Map.Entry entry2 : linkedHashMap2.entrySet()) {
                    if (z) {
                        z = false;
                    } else {
                        stringBuffer.append(",\n");
                    }
                    stringBuffer.append("  ");
                    stringBuffer.append((String) entry2.getKey());
                    stringBuffer.append(": ");
                    stringBuffer.append(StringSupport.indent((String) entry2.getValue(), 2));
                }
                stringBuffer.append("\n}");
            } else {
                stringBuffer.append("{");
                for (Map.Entry entry3 : linkedHashMap2.entrySet()) {
                    if (z) {
                        z = false;
                    } else {
                        stringBuffer.append(", ");
                    }
                    stringBuffer.append((String) entry3.getKey());
                    stringBuffer.append(": ");
                    stringBuffer.append((String) entry3.getValue());
                }
                stringBuffer.append("}");
            }
            return stringBuffer.toString();
        } catch (Throwable th) {
            Thread threadCurrentThread = Thread.currentThread();
            threadCurrentThread.getUncaughtExceptionHandler().uncaughtException(threadCurrentThread, th);
            return "Could not toString: " + th.toString();
        }
    }

    public static String simpleName(Class<?> cls) {
        String name = cls.getName();
        int iLastIndexOf = name.lastIndexOf(".");
        return iLastIndexOf >= 0 ? name.substring(iLastIndexOf + 1) : name;
    }

    private static void addFields(Object obj, Class<?> cls, Class<?> cls2, LinkedHashMap<String, Object> linkedHashMap) {
        if (cls != cls2) {
            addFields(obj, cls.getSuperclass(), cls2, linkedHashMap);
        }
        for (Field field : cls.getDeclaredFields()) {
            if (!Modifier.isStatic(field.getModifiers())) {
                try {
                    field.setAccessible(true);
                    Object objAsList = field.get(obj);
                    if (objAsList != null && objAsList.getClass().isArray()) {
                        try {
                            objAsList = Arrays.asList((Object[]) objAsList);
                        } catch (Throwable unused) {
                        }
                    }
                    linkedHashMap.put(field.getName(), objAsList);
                } catch (Throwable th) {
                    Thread threadCurrentThread = Thread.currentThread();
                    threadCurrentThread.getUncaughtExceptionHandler().uncaughtException(threadCurrentThread, th);
                }
            }
        }
    }
}
