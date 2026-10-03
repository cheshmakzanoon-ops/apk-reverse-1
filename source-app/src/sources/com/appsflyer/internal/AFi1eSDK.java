package com.appsflyer.internal;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import kotlin.collections.CollectionsKt;
import kotlin.collections.IntIterator;
import kotlin.jvm.internal.Intrinsics;
import kotlin.ranges.RangesKt;
import kotlin.sequences.Sequence;
import kotlin.sequences.SequencesKt;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public final class AFi1eSDK {
    public static final Map<String, Object> AFInAppEventType(JSONObject jSONObject) throws JSONException {
        Intrinsics.checkNotNullParameter(jSONObject, "");
        Iterator<String> itKeys = jSONObject.keys();
        Intrinsics.checkNotNullExpressionValue(itKeys, "");
        Sequence sequenceAsSequence = SequencesKt.asSequence(itKeys);
        LinkedHashMap linkedHashMap = new LinkedHashMap();
        for (Object obj : sequenceAsSequence) {
            Object obj2 = jSONObject.get((String) obj);
            Intrinsics.checkNotNullExpressionValue(obj2, "");
            linkedHashMap.put(obj, AFInAppEventType(obj2));
        }
        return linkedHashMap;
    }

    private static final List<Object> AFKeystoreWrapper(JSONArray jSONArray) throws JSONException {
        Iterable iterableUntil = RangesKt.until(0, jSONArray.length());
        ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(iterableUntil, 10));
        IntIterator it = iterableUntil.iterator();
        while (it.hasNext()) {
            Object obj = jSONArray.get(it.nextInt());
            Intrinsics.checkNotNullExpressionValue(obj, "");
            arrayList.add(AFInAppEventType(obj));
        }
        return arrayList;
    }

    private static final Object AFInAppEventType(Object obj) {
        if (obj instanceof JSONArray) {
            return AFKeystoreWrapper((JSONArray) obj);
        }
        if (obj instanceof JSONObject) {
            return AFInAppEventType((JSONObject) obj);
        }
        if (Intrinsics.areEqual(obj, JSONObject.NULL)) {
            return null;
        }
        return obj;
    }
}
