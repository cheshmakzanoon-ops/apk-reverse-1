package net.aihelp.data.localize.data;

import android.text.TextUtils;
import j$.util.concurrent.ConcurrentHashMap;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import net.aihelp.common.Const;
import net.aihelp.common.CustomConfig;
import net.aihelp.common.SpKeys;
import net.aihelp.core.net.http.config.HttpConfig;
import net.aihelp.core.net.json.JsonHelper;
import net.aihelp.core.util.concurrent.ApiExecutorFactory;
import net.aihelp.data.localize.util.LocalizeUtil;
import net.aihelp.data.model.faq.FaqContentEntity;
import net.aihelp.data.model.faq.FaqListEntity;
import net.aihelp.utils.FileUtil;
import net.aihelp.utils.ListUtil;
import net.aihelp.utils.SpUtil;
import net.aihelp.utils.Styles;
import org.json.JSONArray;
import org.json.JSONObject;

public enum FaqHelper {
    INSTANCE;

    public static final String FAQ_HOT_TOPICS = "faqHotTopics";
    public static final String FAQ_NOTIFICATION = "faqNotification";
    private static boolean isDataSourcePrepared;
    private JSONArray rawFlatFaqArray = new JSONArray();
    private final Map<String, JSONArray> rawFaqMap = new ConcurrentHashMap();
    private final List<FaqListEntity> rootSections = new ArrayList();
    private final Map<String, List<FaqListEntity>> subSectionsMap = new ConcurrentHashMap();
    private final Map<String, List<FaqListEntity>> faqQuestionsMap = new ConcurrentHashMap();

    FaqHelper() {
    }

    public static boolean isFaqDataAlreadyPrepared() {
        return LocalizeUtil.isAlreadyLocalized(1001) && isDataSourcePrepared;
    }

    public JSONArray getRawFlatFaqArray() {
        return this.rawFlatFaqArray;
    }

    public JSONArray getRawNotification() {
        return this.rawFaqMap.get(FAQ_NOTIFICATION);
    }

    public JSONArray getRawHotTopics() {
        return this.rawFaqMap.get(FAQ_HOT_TOPICS);
    }

    public List<FaqListEntity> getRootSections() {
        return ListUtil.getSafeList(this.rootSections);
    }

    public List<FaqListEntity> getSubSections(String str) {
        return ListUtil.getSafeList(this.subSectionsMap.get(str));
    }

    public List<FaqListEntity> getQuestionList(String str) {
        return ListUtil.getSafeList(this.faqQuestionsMap.get(str));
    }

    public void reset() {
        this.rawFaqMap.clear();
        this.rawFlatFaqArray = new JSONArray();
        this.rootSections.clear();
        this.subSectionsMap.clear();
        this.faqQuestionsMap.clear();
        Const.FAQ_FILE = "";
        isDataSourcePrepared = false;
    }

    public synchronized void prepareDataSource() {
        prepareDataSource(null);
    }

    public synchronized void prepareDataSource(final Runnable runnable) {
        try {
            String contentFromFile = FileUtil.getContentFromFile(LocalizeUtil.getFileLocation(1001));
            if (!TextUtils.isEmpty(contentFromFile)) {
                JSONArray jsonArray = JsonHelper.getJsonArray(new JSONObject(contentFromFile), "faqlist");
                prepareRootSectionList(jsonArray);
                prepareSubSectionsMap(jsonArray);
                prepareFaqQuestionsMap(jsonArray);
                flatRawFaqJsonArray(jsonArray);
            }
            if (runnable != null) {
                ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        runnable.run();
                    }
                });
            }
            isDataSourcePrepared = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public synchronized void prepareNotificationAndHotTopics() {
        try {
            String contentFromFile = FileUtil.getContentFromFile(LocalizeUtil.getFileLocation(1009));
            if (!TextUtils.isEmpty(contentFromFile)) {
                JSONObject jSONObject = new JSONObject(contentFromFile);
                if (CustomConfig.HelpCenter.isFaqNotificationVisible) {
                    JSONArray jsonArray = JsonHelper.getJsonArray(jSONObject, "notice");
                    ArrayList arrayList = new ArrayList();
                    for (int i = 0; i < jsonArray.length(); i++) {
                        JSONObject jsonObject = JsonHelper.getJsonObject(jsonArray, i);
                        jsonObject.put("noHtmlContent", Styles.getNoTemplateFaqContent(jsonObject.optString("content")));
                        arrayList.add(getFaqListEntity(5, jsonObject));
                        this.rawFlatFaqArray.put(jsonObject);
                    }
                    this.faqQuestionsMap.put(FAQ_NOTIFICATION, arrayList);
                    this.rawFaqMap.put(FAQ_NOTIFICATION, jsonArray);
                }
                if (CustomConfig.HelpCenter.isFaqHotTopicVisible) {
                    JSONArray jsonArray2 = JsonHelper.getJsonArray(jSONObject, "faqList");
                    ArrayList arrayList2 = new ArrayList();
                    for (int i2 = 0; i2 < jsonArray2.length(); i2++) {
                        JSONObject jsonObject2 = JsonHelper.getJsonObject(jsonArray2, i2);
                        arrayList2.add(getFaqListEntity(6, jsonObject2));
                        jsonObject2.put("noHtmlContent", Styles.getNoTemplateFaqContent(jsonObject2.optString("content")));
                        this.rawFlatFaqArray.put(jsonObject2);
                    }
                    this.faqQuestionsMap.put(FAQ_HOT_TOPICS, arrayList2);
                    this.rawFaqMap.put(FAQ_HOT_TOPICS, jsonArray2);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public FaqContentEntity getFaqById(String str) {
        return getFaqById(null, str);
    }

    public FaqContentEntity getFaqById(String str, String str2) {
        if (TextUtils.isEmpty(str)) {
            return filterFaqById(this.rawFlatFaqArray, str2);
        }
        return filterFaqById(this.rawFaqMap.get(str), str2);
    }

    public void afterFaqEvaluated(String str, long j) {
        if (TextUtils.isEmpty(str)) {
            return;
        }
        SpUtil.getInstance().put(getLanguageBasedKey(), String.format("%s,%s", SpUtil.getInstance().getString(getLanguageBasedKey()), String.format("%s_%s", str, Long.valueOf(j))));
    }

    public boolean shouldShowQuestionFooter(String str, long j) {
        if (TextUtils.isEmpty(str)) {
            return false;
        }
        return true ^ SpUtil.getInstance().getString(getLanguageBasedKey()).contains(String.format("%s_%s", str, Long.valueOf(j)));
    }

    private void flatRawFaqJsonArray(JSONArray jSONArray) {
        for (int i = 0; i < jSONArray.length(); i++) {
            try {
                JSONObject jsonObject = JsonHelper.getJsonObject(jSONArray, i);
                JSONArray jsonArray = JsonHelper.getJsonArray(jsonObject, "faqs");
                if (jsonArray.length() == 0) {
                    jsonArray = JsonHelper.getJsonArray(jsonObject, "hiddenFaqs");
                }
                if (jsonArray.length() > 0) {
                    for (int i2 = 0; i2 < jsonArray.length(); i2++) {
                        JSONObject jsonObject2 = JsonHelper.getJsonObject(jsonArray, i2);
                        jsonObject2.put("noHtmlContent", Styles.getNoTemplateFaqContent(jsonObject2.optString("content")));
                        jsonObject2.put("sectionName", JsonHelper.optString(jsonObject, "sectionName"));
                        jsonObject2.put("secImgUrl", JsonHelper.optString(jsonObject, "secImgUrl"));
                        boolean z = true;
                        if (jsonObject.optInt("isSectionHidden") != 1) {
                            z = false;
                        }
                        jsonObject2.put("isHidden", z);
                        this.rawFlatFaqArray.put(jsonObject2);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                return;
            }
        }
    }

    private boolean shouldIgnoreCurrentEntity(FaqListEntity faqListEntity) {
        if (faqListEntity == null) {
            return true;
        }
        for (int i = 0; i < this.rootSections.size(); i++) {
            if (this.rootSections.get(i).getId().equals(faqListEntity.getId())) {
                return true;
            }
        }
        return false;
    }

    private void prepareRootSectionList(JSONArray jSONArray) {
        FaqListEntity faqListEntity;
        for (int i = 0; i < jSONArray.length(); i++) {
            JSONObject jsonObject = JsonHelper.getJsonObject(jSONArray, i);
            if (JsonHelper.getJsonArray(jsonObject, "faqs").length() > 0) {
                if (!TextUtils.isEmpty(jsonObject.optString("sectionBName"))) {
                    faqListEntity = new FaqListEntity(1, jsonObject.optString("sectionBId"), jsonObject.optString("sectionBName"));
                    faqListEntity.setOrder(Integer.parseInt(jsonObject.optString("sectionBOrderNo")));
                    faqListEntity.setIconUrl(jsonObject.optString("secParentImgUrl"));
                    faqListEntity.setSectionName(jsonObject.optString("sectionBName"));
                } else {
                    faqListEntity = new FaqListEntity(1, jsonObject.optString("sectionId"), jsonObject.optString("sectionName"));
                    faqListEntity.setOrder(Integer.parseInt(jsonObject.optString("orderNo")));
                    faqListEntity.setIconUrl(jsonObject.optString("secImgUrl"));
                }
                if (!shouldIgnoreCurrentEntity(faqListEntity)) {
                    this.rootSections.add(faqListEntity);
                }
            }
        }
        Collections.sort(this.rootSections);
    }

    private boolean isDuplicate(List<FaqListEntity> list, String str) {
        for (int i = 0; i < list.size(); i++) {
            FaqListEntity faqListEntity = list.get(i);
            if (faqListEntity != null && faqListEntity.getId().equals(str)) {
                return true;
            }
        }
        return false;
    }

    public void prepareSubSectionsMap(JSONArray jSONArray) {
        for (int i = 0; i < jSONArray.length(); i++) {
            JSONObject jsonObject = JsonHelper.getJsonObject(jSONArray, i);
            JSONArray jsonArray = JsonHelper.getJsonArray(jsonObject, "faqs");
            JSONArray jsonArray2 = JsonHelper.getJsonArray(jsonObject, "hiddenFaqs");
            if (jsonArray.length() > 0 || jsonArray2.length() > 0) {
                String strOptString = jsonObject.optString("sectionBId");
                String strOptString2 = jsonObject.optString("sectionBName");
                if (!TextUtils.isEmpty(strOptString2)) {
                    List<FaqListEntity> arrayList = this.subSectionsMap.get(strOptString);
                    if (arrayList == null) {
                        arrayList = new ArrayList<>();
                    }
                    if (!isDuplicate(arrayList, jsonObject.optString("sectionId"))) {
                        FaqListEntity faqListEntity = new FaqListEntity(2, jsonObject.optString("sectionId"), jsonObject.optString("sectionName"));
                        faqListEntity.setIconUrl(jsonObject.optString("secImgUrl"));
                        faqListEntity.setSectionName(strOptString2);
                        faqListEntity.setHidden(jsonObject.optInt("isSectionHidden") == 1);
                        arrayList.add(faqListEntity);
                        this.subSectionsMap.put(strOptString, arrayList);
                    }
                }
            }
        }
    }

    public boolean hasSubsections(String str) {
        Map<String, List<FaqListEntity>> map = this.subSectionsMap;
        return map != null && map.containsKey(str);
    }

    private void prepareFaqQuestionsMap(JSONArray jSONArray) {
        for (int i = 0; i < jSONArray.length(); i++) {
            JSONObject jsonObject = JsonHelper.getJsonObject(jSONArray, i);
            JSONArray jsonArray = JsonHelper.getJsonArray(jsonObject, "faqs");
            if (jsonArray.length() == 0) {
                jsonArray = JsonHelper.getJsonArray(jsonObject, "hiddenFaqs");
            }
            if (jsonArray.length() > 0) {
                String strOptString = jsonObject.optString("sectionId");
                jsonObject.optInt("isSectionHidden");
                ArrayList arrayList = new ArrayList();
                for (int i2 = 0; i2 < jsonArray.length(); i2++) {
                    FaqListEntity faqListEntity = getFaqListEntity(3, JsonHelper.getJsonObject(jsonArray, i2));
                    faqListEntity.setSectionName(jsonObject.optString("sectionName"));
                    arrayList.add(faqListEntity);
                }
                this.faqQuestionsMap.put(strOptString, arrayList);
                this.rawFaqMap.put(strOptString, jsonArray);
            }
        }
    }

    private FaqContentEntity filterFaqById(JSONArray jSONArray, String str) {
        if (jSONArray == null || jSONArray.length() <= 0) {
            return null;
        }
        for (int i = 0; i < jSONArray.length(); i++) {
            JSONObject jsonObject = JsonHelper.getJsonObject(jSONArray, i);
            String strOptString = jsonObject.optString("faqId");
            String strOptString2 = jsonObject.optString("kmMainid");
            String strOptString3 = jsonObject.optString("kmContentId");
            if (strOptString.equals(str) || strOptString2.equals(str) || strOptString3.equals(str)) {
                return getFaqContentEntity(jsonObject);
            }
        }
        return null;
    }

    private FaqListEntity getFaqListEntity(int i, JSONObject jSONObject) {
        FaqListEntity faqListEntity = new FaqListEntity(i, jSONObject.optString("kmMainid"), jSONObject.optString("question"));
        faqListEntity.setIconUrl(JsonHelper.optString(jSONObject, "imgUrl"));
        return faqListEntity;
    }

    private FaqContentEntity getFaqContentEntity(JSONObject jSONObject) {
        FaqContentEntity faqContentEntity = new FaqContentEntity();
        faqContentEntity.setSectionName(JsonHelper.optString(jSONObject, "sectionName"));
        faqContentEntity.setIconUrl(JsonHelper.optString(jSONObject, "secImgUrl"));
        faqContentEntity.setFaqMainId(jSONObject.optString("kmMainid"));
        faqContentEntity.setFaqDisplayId(jSONObject.optString("faqId"));
        faqContentEntity.setFaqContentId(jSONObject.optString("kmContentId"));
        faqContentEntity.setFaqTitle(jSONObject.optString("question"));
        faqContentEntity.setFaqKeywords(jSONObject.optString("keyWords"));
        faqContentEntity.setSimilarQuestions(jSONObject.optString("similarQuestions"));
        faqContentEntity.setFaqContent(jSONObject.optString("content"));
        faqContentEntity.setLastUpdateTime(jSONObject.optLong("lastUpdateTime", 0L));
        faqContentEntity.setFaqNoHtmlContent(Styles.getNoTemplateFaqContent(jSONObject.optString("content")));
        return faqContentEntity;
    }

    private String getLanguageBasedKey() {
        return HttpConfig.md5(String.format("%s_%s_%s", Const.APP_ID, Const.ORIGINAL_LANGUAGE, SpKeys.EVALUATED_FAQS));
    }
}
