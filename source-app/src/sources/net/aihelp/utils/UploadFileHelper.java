package net.aihelp.utils;

import android.text.TextUtils;
import java.io.File;
import java.util.regex.Pattern;
import net.aihelp.common.API;
import net.aihelp.common.Const;
import net.aihelp.core.net.http.AIHelpRequest;
import net.aihelp.core.net.http.callback.BaseCallback;
import net.aihelp.core.net.http.callback.UploadCallback;
import net.aihelp.core.net.json.JsonHelper;
import net.aihelp.data.model.init.UploadEntity;
import org.json.JSONArray;
import org.json.JSONObject;
import zendesk.faye.internal.Bayeux;

public enum UploadFileHelper {
    INSTANCE;

    private OnUploadFileListener onUploadFileListener;

    public interface OnUploadFileListener {
        void onFileUploaded(String str);
    }

    public UploadFileHelper setOnUploadFileListener(OnUploadFileListener onUploadFileListener) {
        this.onUploadFileListener = onUploadFileListener;
        return this;
    }

    public void tryUploadLog(boolean z) {
        Const.TOGGLE_FETCH_MESSAGE = true;
        if (z && Const.TOGGLE_UPLOAD_LOG && !TextUtils.isEmpty(Const.LOG_UPLOAD_PATH)) {
            File file = new File(Const.LOG_UPLOAD_PATH);
            if (!file.exists() || file.isDirectory() || TextUtils.isEmpty(file.getName())) {
                return;
            }
            AIHelpRequest.getInstance().requestUpLoadFile(API.UPLOAD_LOG_URL, file, new UploadCallback<String>() {
                @Override
                public void onReqSuccess(String str) {
                    try {
                        JSONArray jSONArray = new JSONArray();
                        jSONArray.put(JsonHelper.optString(new JSONObject(str), Bayeux.KEY_DATA));
                        AIHelpRequest.getInstance().requestPostByJson(API.UPLOAD_LOG, jSONArray.toString(), (BaseCallback) null);
                    } catch (Exception unused) {
                    }
                }
            });
        }
    }

    public void performUpload(File file) {
        if (file == null) {
            return;
        }
        final String path = file.getPath();
        AIHelpRequest.getInstance().requestUpLoadFile(getUploadUrl(path), file, new UploadCallback<String>() {
            @Override
            public void onReqSuccess(String str) {
                if (TextUtils.isEmpty(str)) {
                    return;
                }
                String uploadResult = UploadFileHelper.this.getUploadResult(path, str);
                if (UploadFileHelper.this.onUploadFileListener != null) {
                    UploadFileHelper.this.onUploadFileListener.onFileUploaded(uploadResult);
                }
            }
        });
    }

    private String getUploadUrl(String str) {
        if (Pattern.compile(RegexDefinition.AIHELP_SUPPORTED_IMAGE).matcher(str).matches()) {
            return API.UPLOAD_IMAGE_URL;
        }
        if (Pattern.compile(RegexDefinition.AIHELP_SUPPORTED_VIDEO).matcher(str).matches()) {
            return API.UPLOAD_VIDEO_URL;
        }
        return API.UPLOAD_ATTACHMENT_URL;
    }

    public String getUploadResult(String str, String str2) {
        if (Pattern.compile(RegexDefinition.AIHELP_SUPPORTED_IMAGE).matcher(str).matches()) {
            UploadEntity.ImageResult imageResult = (UploadEntity.ImageResult) JsonHelper.toJavaObject(str2, UploadEntity.ImageResult.class);
            if (imageResult != null && !TextUtils.isEmpty(imageResult.getUrl())) {
                return imageResult.getUrl();
            }
            return "";
        }
        UploadEntity.FileResult fileResult = (UploadEntity.FileResult) JsonHelper.toJavaObject(str2, UploadEntity.FileResult.class);
        if (fileResult != null && !TextUtils.isEmpty(fileResult.getData())) {
            return fileResult.getData();
        }
        return "";
    }
}
