package net.aihelp.data.localize.config;

import android.text.TextUtils;
import j$.util.concurrent.ConcurrentHashMap;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import net.aihelp.common.UserProfile;
import net.aihelp.core.net.json.JsonHelper;
import net.aihelp.data.localize.LocalizeHelper;
import net.aihelp.data.localize.util.LocalizeUtil;
import net.aihelp.data.model.config.IntentEntity;
import net.aihelp.data.model.config.ProcessEntity;
import net.aihelp.data.track.AIHelpEventTracker;
import net.aihelp.init.InitHelper;
import net.aihelp.utils.FileUtil;
import net.aihelp.utils.TLog;
import org.json.JSONArray;
import org.json.JSONObject;

public enum ProcessEntranceHelper {
    INSTANCE;

    private ProcessEntity currentProcess;
    private final Map<String, ProcessEntity> processMap = new ConcurrentHashMap();

    ProcessEntranceHelper() {
    }

    public void reset() {
        this.processMap.clear();
        this.currentProcess = null;
    }

    public void prepareDataSource() {
        String contentFromFile = FileUtil.getContentFromFile(LocalizeUtil.getFileLocation(LocalizeHelper.FLAG_PROCESS));
        if (TextUtils.isEmpty(contentFromFile)) {
            return;
        }
        JSONArray jsonArray = JsonHelper.getJsonArray(contentFromFile);
        for (int i = 0; i < jsonArray.length(); i++) {
            JSONObject jsonObject = JsonHelper.getJsonObject(jsonArray, i);
            String strOptString = JsonHelper.optString(jsonObject, "processId");
            ProcessEntity processEntity = new ProcessEntity();
            processEntity.setEntranceId(strOptString);
            processEntity.setIntent(jsonObject.optInt("homeSettings"));
            processEntity.setFaqId(JsonHelper.optString(jsonObject, "faqId"));
            processEntity.setSectionId(JsonHelper.optString(jsonObject, "faqId"));
            processEntity.setVisitId(JsonHelper.optString(jsonObject, "id"));
            processEntity.setTags(JsonHelper.getJsonArray(jsonObject, "tags"));
            processEntity.setFaqEntrances(JsonHelper.getJsonArray(jsonObject, "location"));
            JSONObject jsonObject2 = JsonHelper.getJsonObject(jsonObject, "intentsMenu");
            processEntity.setEnableInteraction(jsonObject2.optBoolean("alwaysShow"));
            processEntity.setSmartIntentName(JsonHelper.optString(jsonObject2, "menuText"));
            processEntity.setSmartIntentList(getBindingIntent(jsonObject2));
            this.processMap.put(strOptString, processEntity);
        }
        InitHelper.getInstance().onAIHelpInitializedCallback(true, "");
    }

    public ProcessEntity getCurrentProcess() {
        ProcessEntity processEntity = this.currentProcess;
        return processEntity == null ? new ProcessEntity() : processEntity;
    }

    private List<IntentEntity> getBindingIntent(JSONObject jSONObject) {
        ArrayList arrayList = new ArrayList();
        JSONArray jsonArray = JsonHelper.getJsonArray(jSONObject, "intentsList");
        if (jsonArray.length() > 0) {
            for (int i = 0; i < jsonArray.length(); i++) {
                JSONObject jsonObject = JsonHelper.getJsonObject(jsonArray, i);
                IntentEntity intentEntity = new IntentEntity();
                intentEntity.setIntentId(jsonObject.optInt("intentsId"));
                intentEntity.setIntentName(JsonHelper.optString(jsonObject, "name"));
                intentEntity.setIntentList(getBindingIntent(jsonObject));
                arrayList.add(intentEntity);
            }
        }
        return arrayList;
    }

    public ProcessEntity getProcess(String str) {
        ProcessEntity processEntity = this.processMap.get(str);
        if (processEntity == null) {
            processEntity = new ProcessEntity();
            processEntity.setEntranceId(str);
            if ("test001".equals(str)) {
                processEntity.setIntent(1);
            } else if ("test002".equals(str)) {
                processEntity.setIntent(2);
            } else if ("test003".equals(str)) {
                processEntity.setIntent(3);
            } else if ("test004".equals(str)) {
                processEntity.setIntent(4);
            } else {
                TLog.m138d("No related process was found, please check your process id.");
            }
        }
        processEntity.setTrackActiveId(UUID.randomUUID().toString());
        UserProfile.ENTRANCE_TAGS = processEntity.getTags();
        this.currentProcess = processEntity;
        handleTrackLogic(processEntity);
        return processEntity;
    }

    private void handleTrackLogic(ProcessEntity processEntity) {
        if (processEntity != null) {
            AIHelpEventTracker aIHelpEventTracker = AIHelpEventTracker.getInstance();
            aIHelpEventTracker.setupTrackHandler(processEntity.getEntranceId(), processEntity.getTrackActiveId());
            int intent = processEntity.getIntent();
            if (intent == 1 || intent == 2 || intent == 3) {
                aIHelpEventTracker.showAIHelp();
                aIHelpEventTracker.showHelpCenter();
            } else {
                if (intent != 4) {
                    return;
                }
                aIHelpEventTracker.showAIHelp();
                aIHelpEventTracker.showCustomerService(true);
            }
        }
    }
}
