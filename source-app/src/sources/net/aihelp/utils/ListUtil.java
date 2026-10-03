package net.aihelp.utils;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class ListUtil {
    public static <T> List<T> getSafeList(List<T> list) {
        return isListEmpty(list) ? new ArrayList() : list;
    }

    public static boolean isMapEmpty(Map map) {
        return map == null || map.size() == 0;
    }

    public static boolean isListEmpty(List list) {
        return list == null || list.size() == 0;
    }

    public static boolean isArrayEmpty(Object[] objArr) {
        return objArr == null || objArr.length == 0;
    }

    public static <T> List<T> deepCopy(List<T> list) {
        try {
            ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            new ObjectOutputStream(byteArrayOutputStream).writeObject(list);
            return (List) new ObjectInputStream(new ByteArrayInputStream(byteArrayOutputStream.toByteArray())).readObject();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList();
        }
    }
}
