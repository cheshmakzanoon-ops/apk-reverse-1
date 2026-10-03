package net.aihelp.data.localize.config;

import android.text.TextUtils;
import net.aihelp.common.CustomConfig;
import net.aihelp.data.localize.LocalizeHelper;
import net.aihelp.data.localize.util.LocalizeUtil;
import net.aihelp.utils.FileUtil;
import org.json.JSONObject;

public enum UploadLimitHelper {
    INSTANCE;

    public void reset() {
        CustomConfig.UploadLimit.isImageEnableUploading = false;
        CustomConfig.UploadLimit.isVideoEnableUploading = false;
        CustomConfig.UploadLimit.isFileEnableUploading = false;
        CustomConfig.UploadLimit.imageTypes = "";
        CustomConfig.UploadLimit.videoTypes = "";
        CustomConfig.UploadLimit.fileTypes = "";
    }

    public void prepareDataSource() {
        try {
            String contentFromFile = FileUtil.getContentFromFile(LocalizeUtil.getFileLocation(LocalizeHelper.FLAG_UPLOAD_LIMIT));
            if (TextUtils.isEmpty(contentFromFile)) {
                return;
            }
            JSONObject jSONObject = new JSONObject(contentFromFile);
            String strOptString = jSONObject.optString("imageTypes");
            String strOptString2 = jSONObject.optString("videoTypes");
            String strOptString3 = jSONObject.optString("fileTypes");
            CustomConfig.UploadLimit.imageTypes = strOptString.replace("\\.", "");
            CustomConfig.UploadLimit.isImageEnableUploading = isToggleOpen(jSONObject, "imageStatus");
            CustomConfig.UploadLimit.videoTypes = strOptString2.replace("\\.", "");
            CustomConfig.UploadLimit.isVideoEnableUploading = isToggleOpen(jSONObject, "videoStatus");
            CustomConfig.UploadLimit.fileTypes = String.format("%s,%s,%s", strOptString, strOptString2, strOptString3);
            CustomConfig.UploadLimit.isFileEnableUploading = isToggleOpen(jSONObject, "fileStatus");
            CustomConfig.UploadLimit.imageMaxSize = jSONObject.optInt("imageMaxSize", CustomConfig.UploadLimit.imageMaxSize);
            CustomConfig.UploadLimit.videoMaxSize = jSONObject.optInt("videoMaxSize", CustomConfig.UploadLimit.videoMaxSize);
            CustomConfig.UploadLimit.fileMaxSize = jSONObject.optInt("fileMaxSize", CustomConfig.UploadLimit.fileMaxSize);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private boolean isToggleOpen(JSONObject jSONObject, String str) {
        return jSONObject != null && jSONObject.optInt(str) == 1;
    }
}
