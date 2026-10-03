package net.aihelp.data.attachment;

import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.net.Uri;
import android.text.TextUtils;
import androidx.fragment.app.Fragment;
import java.io.File;
import java.io.Serializable;
import java.lang.ref.WeakReference;
import net.aihelp.common.IntentValues;
import net.aihelp.config.AIHelpContext;
import net.aihelp.p007ui.preview.data.PreviewInfo;

public enum AttachmentPicker {
    INSTANCE;

    public static final int ATTACHMENT_FILE_NOT_FOUND = -1;
    public static final int ATTACHMENT_FILE_SIZE_LIMIT_EXCEEDED = -2;
    public static final int ATTACHMENT_TYPE_FILE = 2;
    public static final int ATTACHMENT_TYPE_MEDIA = 1;
    public static final int ATTACHMENT_TYPE_RPA = 3;
    public static final int INVALID_URI = -4;
    private static final long MAX_ATTACHMENT_FILE_SIZE_LIMIT = 26214400;
    public static final int NO_APPS_TO_OPEN_ATTACHMENTS_INTENT = -3;
    private WeakReference<IAttachmentPickerListener> attachmentPickerListenerRef;
    private int attachmentType;
    private WeakReference<Fragment> pickerHostRef;

    public <T extends Fragment> AttachmentPicker setPickerHost(T t) {
        this.pickerHostRef = new WeakReference<>(t);
        return this;
    }

    public <T extends IAttachmentPickerListener> AttachmentPicker setAttachmentPickerListener(T t) {
        if (t != null) {
            this.attachmentPickerListenerRef = new WeakReference<>(t);
        }
        return this;
    }

    public void launchPicker(int i) {
        Fragment fragment;
        this.attachmentType = i;
        try {
            WeakReference<Fragment> weakReference = this.pickerHostRef;
            if (weakReference == null || (fragment = weakReference.get()) == null || fragment.getActivity() == null) {
                return;
            }
            fragment.startActivityForResult(AttachmentHelper.getIntentForMedia(i), 1001);
        } catch (ActivityNotFoundException unused) {
            sendPickFailure(-3);
        }
    }

    public void onAttachmentRequestResult(int i, int i2, Intent intent) {
        if (i != 1001) {
            if (i != 1002) {
                return;
            }
            onPreviewResult(i2, intent);
        } else {
            if (i2 != -1 || intent == null) {
                return;
            }
            onConfirmResult(intent.getData());
        }
    }

    private void onConfirmResult(Uri uri) {
        if (uri != null) {
            File copiedUriFile = AttachmentHelper.getCopiedUriFile(AIHelpContext.getInstance().getContext(), uri);
            if (copiedUriFile != null) {
                sendPickSuccess(copiedUriFile);
                return;
            } else {
                sendPickFailure(-1);
                return;
            }
        }
        sendPickFailure(-4);
    }

    private void onPreviewResult(int i, Intent intent) {
        IAttachmentPickerListener iAttachmentPickerListener;
        WeakReference<IAttachmentPickerListener> weakReference = this.attachmentPickerListenerRef;
        if (weakReference == null || (iAttachmentPickerListener = weakReference.get()) == null) {
            return;
        }
        if (i == -1 && intent != null) {
            Serializable serializableExtra = intent.getSerializableExtra(IntentValues.PREVIEW_INFO);
            if (serializableExtra instanceof PreviewInfo) {
                String filePath = ((PreviewInfo) serializableExtra).getFilePath();
                if (TextUtils.isEmpty(filePath)) {
                    return;
                }
                iAttachmentPickerListener.onPreviewConfirmed(filePath);
                return;
            }
            return;
        }
        iAttachmentPickerListener.onPreviewCanceled(this.attachmentType);
    }

    private void sendPickSuccess(File file) {
        IAttachmentPickerListener iAttachmentPickerListener;
        WeakReference<IAttachmentPickerListener> weakReference = this.attachmentPickerListenerRef;
        if (weakReference == null || (iAttachmentPickerListener = weakReference.get()) == null) {
            return;
        }
        iAttachmentPickerListener.onPickSuccess(file);
    }

    private void sendPickFailure(int i) {
        IAttachmentPickerListener iAttachmentPickerListener;
        WeakReference<IAttachmentPickerListener> weakReference = this.attachmentPickerListenerRef;
        if (weakReference == null || (iAttachmentPickerListener = weakReference.get()) == null) {
            return;
        }
        iAttachmentPickerListener.onPickFailure(i);
    }
}
