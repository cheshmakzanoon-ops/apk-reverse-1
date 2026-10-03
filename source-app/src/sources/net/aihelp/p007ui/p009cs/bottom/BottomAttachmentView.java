package net.aihelp.p007ui.p009cs.bottom;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.view.View;
import androidx.fragment.app.Fragment;
import java.io.File;
import java.lang.reflect.Method;
import java.util.regex.Pattern;
import net.aihelp.common.CustomConfig;
import net.aihelp.common.IntentValues;
import net.aihelp.core.util.luban.Luban;
import net.aihelp.core.util.luban.OnCompressListener;
import net.aihelp.core.util.permission.AIHelpPermissions;
import net.aihelp.data.attachment.AttachmentPicker;
import net.aihelp.data.attachment.IAttachmentPickerListener;
import net.aihelp.data.model.rpa.msg.FileMessage;
import net.aihelp.data.model.rpa.msg.UserMessage;
import net.aihelp.data.model.rpa.step.RPAStep;
import net.aihelp.p007ui.p009cs.IServiceEventListener;
import net.aihelp.p007ui.preview.PreviewActivity;
import net.aihelp.p007ui.preview.data.PreviewInfo;
import net.aihelp.p007ui.widget.AIHelpButton;
import net.aihelp.utils.AppInfoUtil;
import net.aihelp.utils.MediaUtils;
import net.aihelp.utils.RegexDefinition;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.ToastUtil;
import net.aihelp.utils.UploadFileHelper;
import org.json.JSONObject;

public class BottomAttachmentView extends BottomBaseView implements View.OnClickListener, IAttachmentPickerListener {
    public BottomAttachmentView(Context context) {
        this(context, null);
    }

    public BottomAttachmentView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0);
    }

    public BottomAttachmentView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        View.inflate(context, ResResolver.getLayoutId("aihelp_bottom_attachment"), this);
        AIHelpButton aIHelpButton = (AIHelpButton) findViewById(ResResolver.getViewId("aihelp_btn_add_attachment"));
        aIHelpButton.setText(ResResolver.getString("aihelp_upload_attachment"));
        aIHelpButton.setOnClickListener(this);
    }

    @Override
    public void onClick(View view) {
        Fragment hostFragment;
        if (!AppInfoUtil.validateNetwork(getContext()) || view.getId() != ResResolver.getViewId("aihelp_btn_add_attachment") || this.mListener == null || (hostFragment = this.mListener.getHostFragment()) == null) {
            return;
        }
        String[] strArr = {"android.permission.READ_EXTERNAL_STORAGE"};
        if (Build.VERSION.SDK_INT >= 33) {
            strArr = new String[]{"android.permission.READ_MEDIA_IMAGES", "android.permission.READ_MEDIA_VIDEO"};
        }
        AIHelpPermissions.getInstance().setHost(hostFragment).setRequestCode(1000).setRequestPermission(strArr).request(getContext(), 3);
    }

    @Override
    public void setBottomViewEventListener(Bundle bundle, RPAStep rPAStep, IServiceEventListener iServiceEventListener) {
        super.setBottomViewEventListener(bundle, rPAStep, iServiceEventListener);
        if (rPAStep != null) {
            CustomConfig.UploadLimit.rpaAttachmentTypes = rPAStep.getAttachmentTypes();
        }
    }

    @Override
    public void onPickSuccess(File file) {
        Fragment hostFragment;
        String absolutePath = file.getAbsolutePath();
        if (TextUtils.isEmpty(absolutePath)) {
            ToastUtil.INSTANCE.makeText(getContext(), "Failed to get file path", false);
        } else {
            if (this.mListener == null || (hostFragment = this.mListener.getHostFragment()) == null) {
                return;
            }
            PreviewActivity.startAct(hostFragment, PreviewInfo.get(absolutePath, file.getName(), file.length(), true));
        }
    }

    @Override
    public void onPickFailure(int i) {
        ToastUtil.INSTANCE.makeRawToast(getContext(), ResResolver.getString("aihelp_resource_not_support"));
    }

    @Override
    public void onPreviewCanceled(int i) {
        Fragment hostFragment;
        if (this.mListener == null || (hostFragment = this.mListener.getHostFragment()) == null) {
            return;
        }
        AttachmentPicker.INSTANCE.setPickerHost(hostFragment).setAttachmentPickerListener(this).launchPicker(i);
    }

    @Override
    public void onPreviewConfirmed(String str) {
        if (CustomConfig.UploadLimit.isImageEnableUploading && Pattern.compile(RegexDefinition.ANDROID_SUPPORTED_IMAGE).matcher(str).matches()) {
            if (str.endsWith(".gif") || str.endsWith(".GIF")) {
                uploadFile(11, new File(str));
                return;
            } else {
                compressImage(str);
                return;
            }
        }
        if (CustomConfig.UploadLimit.isVideoEnableUploading && Pattern.compile(RegexDefinition.ANDROID_SUPPORTED_VIDEO).matcher(str).matches()) {
            uploadFile(12, new File(str));
        } else if (CustomConfig.UploadLimit.isFileEnableUploading) {
            uploadFile(14, new File(str));
        } else {
            ToastUtil.INSTANCE.makeRawToast(getContext(), ResResolver.getString("aihelp_resource_not_support"));
        }
    }

    private void compressImage(final String str) {
        Luban.with(getContext()).load(str).setCompressListener(new OnCompressListener() {
            @Override
            public void onStart() {
            }

            @Override
            public void onSuccess(File file) {
                BottomAttachmentView.this.uploadFile(11, file);
            }

            @Override
            public void onError(Throwable th) {
                BottomAttachmentView.this.uploadFile(11, new File(str));
            }
        }).launch();
    }

    public void uploadFile(final int i, final File file) {
        if (this.mListener == null || file == null) {
            return;
        }
        final FileMessage fileMessage = new FileMessage(i, file.getPath());
        fileMessage.setFileInfo(file.getName(), file.length());
        fileMessage.setMsgStatus(2);
        fileMessage.setDuringRPAProcedure(this.bundle.getBoolean(IntentValues.BOTTOM_DURING_PROCEDURE, true));
        this.mListener.onUserAction(fileMessage);
        UploadFileHelper.INSTANCE.setOnUploadFileListener(new UploadFileHelper.OnUploadFileListener() {
            @Override
            public void onFileUploaded(String str) {
                fileMessage.setMsgStatus(!TextUtils.isEmpty(str) ? 1 : 3);
                fileMessage.setDuringRPAProcedure(BottomAttachmentView.this.bundle.getBoolean(IntentValues.BOTTOM_DURING_PROCEDURE, true));
                fileMessage.setRequestParams(BottomAttachmentView.this.getUploadRequestParams(i, str, file));
                if (BottomAttachmentView.this.mListener != null) {
                    BottomAttachmentView.this.mListener.onUserAction(fileMessage);
                }
            }
        }).performUpload(file);
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        UploadFileHelper.INSTANCE.setOnUploadFileListener(null);
    }

    public JSONObject getUploadRequestParams(int i, String str, File file) {
        if (i == 11) {
            Bitmap bitmapDecodeFile = BitmapFactory.decodeFile(file.getPath());
            return UserMessage.getRequestParams(str, file.getName(), file.length(), ((Integer) getSafeValue(bitmapDecodeFile, "getWidth", 0)).intValue(), ((Integer) getSafeValue(bitmapDecodeFile, "getHeight", 0)).intValue());
        }
        if (i == 12) {
            Bitmap bitmapDecodeFile2 = BitmapFactory.decodeFile(MediaUtils.getImageForVideoSync(file.getPath()));
            return UserMessage.getRequestParams(str, file.getName(), file.length(), ((Integer) getSafeValue(bitmapDecodeFile2, "getWidth", 0)).intValue(), ((Integer) getSafeValue(bitmapDecodeFile2, "getHeight", 0)).intValue());
        }
        if (i != 14) {
            return null;
        }
        return UserMessage.getRequestParams(str, file.getName(), file.length(), 0.0f, 0.0f);
    }

    private <In, Out> Out getSafeValue(In in, String str, Out out) {
        if (in == null) {
            return out;
        }
        try {
            Method declaredMethod = in.getClass().getDeclaredMethod(str, null);
            declaredMethod.setAccessible(true);
            return (Out) declaredMethod.invoke(in, null);
        } catch (Exception unused) {
            return out;
        }
    }
}
