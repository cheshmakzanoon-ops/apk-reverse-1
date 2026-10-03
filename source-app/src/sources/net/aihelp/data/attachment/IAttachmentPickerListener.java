package net.aihelp.data.attachment;

import java.io.File;

public interface IAttachmentPickerListener {
    void onPickFailure(int i);

    void onPickSuccess(File file);

    void onPreviewCanceled(int i);

    void onPreviewConfirmed(String str);
}
