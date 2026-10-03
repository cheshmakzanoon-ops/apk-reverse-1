package com.google.android.material.textfield;

import android.text.method.PasswordTransformationMethod;
import android.view.View;
import android.widget.EditText;
import com.google.android.material.C0017R;

class PasswordToggleEndIconDelegate extends EndIconDelegate {
    private EditText editText;
    private int iconResId;
    private final View.OnClickListener onIconClickListener;

    @Override
    boolean isIconCheckable() {
        return true;
    }

    void m119x4cc26475(View view) {
        EditText editText = this.editText;
        if (editText == null) {
            return;
        }
        int selectionEnd = editText.getSelectionEnd();
        if (hasPasswordTransformation()) {
            this.editText.setTransformationMethod(null);
        } else {
            this.editText.setTransformationMethod(PasswordTransformationMethod.getInstance());
        }
        if (selectionEnd >= 0) {
            this.editText.setSelection(selectionEnd);
        }
        refreshIconState();
    }

    PasswordToggleEndIconDelegate(EndCompoundLayout endCompoundLayout, int i) {
        super(endCompoundLayout);
        this.iconResId = C0017R.drawable.design_password_eye;
        this.onIconClickListener = new View.OnClickListener() {
            @Override
            public final void onClick(View view) {
                this.f$0.m119x4cc26475(view);
            }
        };
        if (i != 0) {
            this.iconResId = i;
        }
    }

    @Override
    void setUp() {
        if (isInputTypePassword(this.editText)) {
            this.editText.setTransformationMethod(PasswordTransformationMethod.getInstance());
        }
    }

    @Override
    void tearDown() {
        EditText editText = this.editText;
        if (editText != null) {
            editText.setTransformationMethod(PasswordTransformationMethod.getInstance());
        }
    }

    @Override
    int getIconDrawableResId() {
        return this.iconResId;
    }

    @Override
    int getIconContentDescriptionResId() {
        return C0017R.string.password_toggle_content_description;
    }

    @Override
    boolean isIconChecked() {
        return !hasPasswordTransformation();
    }

    @Override
    View.OnClickListener getOnIconClickListener() {
        return this.onIconClickListener;
    }

    @Override
    void onEditTextAttached(EditText editText) {
        this.editText = editText;
        refreshIconState();
    }

    @Override
    void beforeEditTextChanged(CharSequence charSequence, int i, int i2, int i3) {
        refreshIconState();
    }

    private boolean hasPasswordTransformation() {
        EditText editText = this.editText;
        return editText != null && (editText.getTransformationMethod() instanceof PasswordTransformationMethod);
    }

    private static boolean isInputTypePassword(EditText editText) {
        return editText != null && (editText.getInputType() == 16 || editText.getInputType() == 128 || editText.getInputType() == 144 || editText.getInputType() == 224);
    }
}
