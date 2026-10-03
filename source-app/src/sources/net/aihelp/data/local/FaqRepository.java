package net.aihelp.data.local;

import android.content.Context;
import java.util.ArrayList;
import java.util.List;
import net.aihelp.core.mvp.AbsRepository;
import net.aihelp.core.net.json.JsonHelper;
import net.aihelp.data.localize.data.FaqHelper;
import net.aihelp.data.model.faq.FaqListEntity;
import org.json.JSONArray;
import org.json.JSONObject;

public class FaqRepository extends AbsRepository {
    public FaqRepository(Context context) {
        super(context);
    }

    public boolean shouldShowQuestionFooter(String str, long j) {
        return FaqHelper.INSTANCE.shouldShowQuestionFooter(str, j);
    }

    public boolean checkWhetherHasSubSection(String str) {
        return FaqHelper.INSTANCE.hasSubsections(str);
    }

    public ArrayList<FaqListEntity> getMatchedFaqList(String str) {
        JSONArray rawNotification = FaqHelper.INSTANCE.getRawNotification();
        JSONArray rawHotTopics = FaqHelper.INSTANCE.getRawHotTopics();
        JSONArray rawFlatFaqArray = FaqHelper.INSTANCE.getRawFlatFaqArray();
        ArrayList<FaqListEntity> arrayList = new ArrayList<>();
        StringBuilder sb = new StringBuilder();
        arrayList.addAll(iteratorFaqList(rawNotification, str, sb));
        arrayList.addAll(iteratorFaqList(rawHotTopics, str, sb));
        arrayList.addAll(iteratorFaqList(rawFlatFaqArray, str, sb));
        return arrayList;
    }

    public List<FaqListEntity> iteratorFaqList(JSONArray jSONArray, String str, StringBuilder sb) {
        ArrayList arrayList = new ArrayList();
        ArrayList arrayList2 = new ArrayList();
        if (jSONArray != null && jSONArray.length() > 0) {
            for (int i = 0; i < jSONArray.length(); i++) {
                JSONObject jsonObject = JsonHelper.getJsonObject(jSONArray, i);
                boolean zOptBoolean = jsonObject.optBoolean("isHidden");
                String strOptString = jsonObject.optString("kmMainid");
                String strOptString2 = jsonObject.optString("question");
                String strOptString3 = jsonObject.optString("noHtmlContent");
                if (!zOptBoolean && strOptString2.toLowerCase().contains(str.toLowerCase())) {
                    if (!sb.toString().contains(strOptString)) {
                        arrayList.add(new FaqListEntity(4, strOptString, strOptString2, str));
                        sb.append(String.format("%s,", strOptString));
                    }
                } else if (!zOptBoolean && strOptString3.toLowerCase().contains(str.toLowerCase()) && !sb.toString().contains(strOptString)) {
                    arrayList2.add(new FaqListEntity(4, strOptString, strOptString2, str));
                    sb.append(String.format("%s,", strOptString));
                }
            }
        }
        ArrayList arrayList3 = new ArrayList();
        arrayList3.addAll(arrayList2);
        arrayList3.addAll(0, arrayList);
        return arrayList3;
    }
}
