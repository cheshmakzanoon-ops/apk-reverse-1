package net.aihelp.data.model.rpa.step;

import java.util.List;
import net.aihelp.core.net.json.JsonHelper;
import org.json.JSONObject;

public class RPAStep {
    public static final int STEP_ACTION_PICKER = 4;
    public static final int STEP_ADDING_ATTACHMENT = 6;
    public static final int STEP_BOT_INPUT_MAIL = 2;
    public static final int STEP_BOT_INPUT_NUMBER = 3;
    public static final int STEP_BOT_INPUT_TEXT = 1;
    public static final int STEP_DATE_PICKER = 5;
    public static final int STEP_EVALUATE_FAQ = 9;
    public static final int STEP_EVALUATE_SERVICE = 101;
    public static final int STEP_FILLING_FORM = 7;
    public static final int STEP_IGNORE_THIS = 104;
    public static final int STEP_MANUAL_INPUT = 100;
    public static final int STEP_NEW_CONVERSATION = 102;
    public static final int STEP_SELF_SERVICE = 8;
    public static final int STEP_STOP_AND_WAIT = 103;
    private List<Action> actionList;
    private String attachmentTypes;
    private boolean enableActionInput;
    private boolean enablePrevStep;
    private boolean enableSkip;
    private boolean enableUpload;
    private int nextStep = 1;
    private String prevStepHint;
    private String skipHint;
    private String stepId;

    public boolean isEnablePrevStep() {
        return this.enablePrevStep;
    }

    public void setEnablePrevStep(boolean z) {
        this.enablePrevStep = z;
    }

    public String getPrevStepHint() {
        return this.prevStepHint;
    }

    public void setPrevStepHint(String str) {
        this.prevStepHint = str;
    }

    public String getSkipHint() {
        return this.skipHint;
    }

    public void setSkipHint(String str) {
        this.skipHint = str;
    }

    public boolean isEnableSkip() {
        return this.enableSkip;
    }

    public void setEnableSkip(boolean z) {
        this.enableSkip = z;
    }

    public boolean isEnableUpload() {
        return this.enableUpload;
    }

    public void setEnableUpload(boolean z) {
        this.enableUpload = z;
    }

    public boolean isEnableActionInput() {
        return this.enableActionInput;
    }

    public void setEnableActionInput(boolean z) {
        this.enableActionInput = z;
    }

    public int getNextStep() {
        return this.nextStep;
    }

    public void setNextStep(int i) {
        this.nextStep = i;
    }

    public String getStepId() {
        return this.stepId;
    }

    public void setStepId(String str) {
        this.stepId = str;
    }

    public List<Action> getActionList() {
        return this.actionList;
    }

    public void setActionList(List<Action> list) {
        this.actionList = list;
    }

    public String getAttachmentTypes() {
        return this.attachmentTypes;
    }

    public void setAttachmentTypes(String str) {
        JSONObject jsonObject = JsonHelper.getJsonObject(str);
        String str2 = String.format("%s,%s,%s", JsonHelper.optString(jsonObject, "imageTypes"), JsonHelper.optString(jsonObject, "videoTypes"), JsonHelper.optString(jsonObject, "fileTypes"));
        this.attachmentTypes = str2;
        this.attachmentTypes = str2.replaceAll("\\.", "");
    }

    public static class Action implements Comparable<Action> {
        private String content;

        private String f102id;
        private int order;

        public static Action getInstance(int i, String str, String str2) {
            Action action = new Action();
            action.setOrder(i);
            action.setId(str);
            action.setContent(str2);
            return action;
        }

        public void setOrder(int i) {
            this.order = i;
        }

        public int getOrder() {
            return this.order;
        }

        public String getId() {
            return this.f102id;
        }

        public void setId(String str) {
            this.f102id = str;
        }

        public String getContent() {
            return this.content;
        }

        public void setContent(String str) {
            this.content = str;
        }

        @Override
        public int compareTo(Action action) {
            return this.order - action.getOrder();
        }
    }
}
