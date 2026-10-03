package ru.mopsicus.mobileinput;

import android.content.ClipboardManager;
import android.content.Context;
import android.os.Build;
import android.util.AttributeSet;
import android.util.Log;
import android.view.KeyEvent;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputConnection;
import android.view.inputmethod.InputConnectionWrapper;
import android.widget.EditText;
import com.sdkmanager.utils.Udid$;
import ru.mopsicus.mobileinput.p012at.KeyCodeDeleteHelper;

public class CustomEditText extends EditText {
    private static final String TAG = "CustomEditText";
    private OnSelectionChangeListener selectionChangeListener;
    public boolean useNewDeleteLogic;

    public interface OnSelectionChangeListener {
        void onSelectionChanged(int i, int i2);
    }

    private static class MentionInputConnection extends InputConnectionWrapper {
        private CustomEditText editText;

        MentionInputConnection(InputConnection inputConnection, boolean z, CustomEditText customEditText) {
            super(inputConnection, z);
            this.editText = customEditText;
        }

        @Override
        public boolean deleteSurroundingText(int i, int i2) {
            if (i == 1 && i2 == 0) {
                if (!this.editText.useNewDeleteLogic) {
                    return sendKeyEvent(new KeyEvent(0, 67)) && sendKeyEvent(new KeyEvent(1, 67));
                }
                if (KeyCodeDeleteHelper.onDelDown(this.editText.getText())) {
                    return true;
                }
            }
            return super.deleteSurroundingText(i, i2);
        }
    }

    public CustomEditText(Context context) {
        super(context);
        this.useNewDeleteLogic = false;
        init();
    }

    public CustomEditText(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
        this.useNewDeleteLogic = false;
        init();
    }

    public CustomEditText(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        this.useNewDeleteLogic = false;
        init();
    }

    @Override
    public InputConnection onCreateInputConnection(EditorInfo editorInfo) {
        InputConnection inputConnectionOnCreateInputConnection = super.onCreateInputConnection(editorInfo);
        if (inputConnectionOnCreateInputConnection == null) {
            return null;
        }
        return new MentionInputConnection(inputConnectionOnCreateInputConnection, true, this);
    }

    private void init() {
        fixLineHeightIssue();
    }

    private void fixLineHeightIssue() {
        if (Build.VERSION.SDK_INT >= 35) {
            try {
                Udid$.ExternalSyntheticApiModelOutline0.m(this, false);
            } catch (NoSuchMethodError e) {
                Log.w(TAG, "setLocalePreferredLineHeightForMinimumUsed not available on this ROM.", e);
            }
        }
    }

    public void setOnSelectionChangeListener(OnSelectionChangeListener onSelectionChangeListener) {
        this.selectionChangeListener = onSelectionChangeListener;
    }

    @Override
    protected void onSelectionChanged(int i, int i2) {
        super.onSelectionChanged(i, i2);
        OnSelectionChangeListener onSelectionChangeListener = this.selectionChangeListener;
        if (onSelectionChangeListener != null) {
            onSelectionChangeListener.onSelectionChanged(i, i2);
        }
    }

    @Override
    public boolean onTextContextMenuItem(int i) {
        ClipboardManager clipboardManager;
        if (i == 16908322 && (clipboardManager = (ClipboardManager) getContext().getSystemService("clipboard")) != null && clipboardManager.hasPrimaryClip()) {
            getText().replace(getSelectionStart(), getSelectionEnd(), clipboardManager.getPrimaryClip().getItemAt(0).coerceToText(getContext()).toString());
            return true;
        }
        return super.onTextContextMenuItem(i);
    }
}
