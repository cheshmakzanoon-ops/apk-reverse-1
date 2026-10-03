package net.aihelp.data.local;

import android.content.Context;
import android.text.TextUtils;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import net.aihelp.core.mvp.AbsRepository;
import net.aihelp.core.net.json.JsonHelper;
import net.aihelp.data.localize.data.FaqHelper;
import net.aihelp.data.model.faq.FaqListEntity;
import org.json.JSONArray;
import org.json.JSONObject;

public class ElvaRepository extends AbsRepository {
    public ElvaRepository(Context context) {
        super(context);
    }

    public List<FaqListEntity> getMatchedFaqListForAlert(String str) {
        ArrayList arrayList = new ArrayList();
        HashMap map = new HashMap();
        HashMap map2 = new HashMap();
        JSONArray rawFlatFaqArray = FaqHelper.INSTANCE.getRawFlatFaqArray();
        loop0: for (int i = 0; i < rawFlatFaqArray.length(); i++) {
            JSONObject jsonObject = JsonHelper.getJsonObject(rawFlatFaqArray, i);
            String strOptString = jsonObject.optString("keyWords");
            String strOptString2 = jsonObject.optString("kmMainid");
            String strOptString3 = jsonObject.optString("question");
            String strOptString4 = jsonObject.optString("similarQuestions");
            if (!TextUtils.isEmpty(strOptString)) {
                for (String str2 : strOptString.split(",")) {
                    if (str.toLowerCase().contains(str2)) {
                        if (map.size() >= 3) {
                            break loop0;
                        }
                        Integer num = (Integer) map.get(strOptString2);
                        map.put(strOptString2, Integer.valueOf(num != null ? 1 + num.intValue() : 1));
                        map2.put(strOptString2, strOptString3);
                    }
                }
                if (map.get(strOptString2) != null) {
                    continue;
                }
            }
            if (strOptString3.toLowerCase().contains(str.toLowerCase())) {
                map.put(strOptString2, 0);
                map2.put(strOptString2, strOptString3);
                if (map.size() < 3) {
                    break;
                }
                break;
            }
            if (strOptString4.toLowerCase().contains(str.toLowerCase())) {
                map.put(strOptString2, -1);
                map2.put(strOptString2, strOptString3);
                if (map.size() >= 3) {
                    break;
                }
            } else {
                continue;
            }
        }
        ArrayList arrayList2 = new ArrayList(map.entrySet());
        Collections.sort(arrayList2, new Comparator<Map.Entry<String, Integer>>() {
            @Override
            public int compare(Map.Entry<String, Integer> entry, Map.Entry<String, Integer> entry2) {
                return -entry.getValue().compareTo(entry2.getValue());
            }
        });
        Iterator it = arrayList2.iterator();
        while (it.hasNext()) {
            String str3 = (String) ((Map.Entry) it.next()).getKey();
            arrayList.add(new FaqListEntity(0, str3, (String) map2.get(str3), str));
        }
        return arrayList;
    }
}
