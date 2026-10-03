package com.gme.p007av.utils;

import android.content.Intent;
import com.gme.TMG.ITMGType;
import java.util.HashMap;

public class EventHelper {
    public static final String TAG = "EventHelper";
    private static final HashMap<Integer, ITMGType.ITMG_MAIN_EVENT_TYPE> allTypeMaps;

    static {
        ITMGType.ITMG_MAIN_EVENT_TYPE[] itmg_main_event_typeArrValues = ITMGType.ITMG_MAIN_EVENT_TYPE.values();
        allTypeMaps = new HashMap<>(itmg_main_event_typeArrValues.length);
        for (ITMGType.ITMG_MAIN_EVENT_TYPE itmg_main_event_type : itmg_main_event_typeArrValues) {
            allTypeMaps.put(Integer.valueOf(itmg_main_event_type.getNativeValue()), itmg_main_event_type);
        }
    }

    public static ITMGType.ITMG_MAIN_EVENT_TYPE idToEvent(int i) {
        return allTypeMaps.get(Integer.valueOf(i));
    }

    public static Intent parserEvent(String str) {
        return JsonParser.ParseJsonString(str);
    }
}
