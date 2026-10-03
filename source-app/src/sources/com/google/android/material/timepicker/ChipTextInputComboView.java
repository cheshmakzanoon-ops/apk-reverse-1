package com.google.android.material.timepicker;

import android.content.Context;
import android.content.res.Configuration;
import android.os.Build;
import android.text.Editable;
import android.text.InputFilter;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Checkable;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.TextView;
import androidx.activity.ComponentDialog$;
import androidx.core.view.AccessibilityDelegateCompat;
import androidx.core.view.ViewCompat;
import com.google.android.material.C0017R;
import com.google.android.material.chip.Chip;
import com.google.android.material.internal.TextWatcherAdapter;
import com.google.android.material.internal.ViewUtils;
import com.google.android.material.textfield.TextInputLayout;
import java.util.Arrays;

class ChipTextInputComboView extends FrameLayout implements Checkable {
    private final Chip chip;
    private final EditText editText;
    private TextView label;
    private final TextInputLayout textInputLayout;
    private TextWatcher watcher;

    public ChipTextInputComboView(Context context) {
        this(context, null);
    }

    public ChipTextInputComboView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0);
    }

    public ChipTextInputComboView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        LayoutInflater layoutInflaterFrom = LayoutInflater.from(context);
        ?? r5 = (Chip) layoutInflaterFrom.inflate(C0017R.layout.material_time_chip, (ViewGroup) this, false);
        this.chip = r5;
        r5.setAccessibilityClassName("android.view.View");
        TextInputLayout textInputLayout = (TextInputLayout) layoutInflaterFrom.inflate(C0017R.layout.material_time_input, (ViewGroup) this, false);
        this.textInputLayout = textInputLayout;
        EditText editText = textInputLayout.getEditText();
        this.editText = editText;
        editText.setVisibility(4);
        TextFormatter textFormatter = new TextFormatter();
        this.watcher = textFormatter;
        editText.addTextChangedListener(textFormatter);
        updateHintLocales();
        addView(r5);
        addView(textInputLayout);
        this.label = (TextView) findViewById(C0017R.id.material_label);
        editText.setId(ViewCompat.generateViewId());
        ViewCompat.setLabelFor(this.label, editText.getId());
        editText.setSaveEnabled(false);
        editText.setLongClickable(false);
    }

    private void updateHintLocales() {
        if (Build.VERSION.SDK_INT >= 24) {
            this.editText.setImeHintLocales(ComponentDialog$.ExternalSyntheticApiModelOutline0.m(getContext().getResources().getConfiguration()));
        }
    }

    @Override
    public boolean isChecked() {
        return this.chip.isChecked();
    }

    @Override
    public void setChecked(boolean z) {
        this.chip.setChecked(z);
        this.editText.setVisibility(z ? 0 : 4);
        this.chip.setVisibility(z ? 8 : 0);
        if (isChecked()) {
            ViewUtils.requestFocusAndShowKeyboard(this.editText, false);
        }
    }

    @Override
    public void toggle() {
        this.chip.toggle();
    }

    public void setText(CharSequence charSequence) {
        String text = formatText(charSequence);
        this.chip.setText(text);
        if (TextUtils.isEmpty(text)) {
            return;
        }
        this.editText.removeTextChangedListener(this.watcher);
        this.editText.setText(text);
        this.editText.addTextChangedListener(this.watcher);
    }

    CharSequence getChipText() {
        return this.chip.getText();
    }

    public String formatText(CharSequence charSequence) {
        return TimeModel.formatText(getResources(), charSequence);
    }

    @Override
    public void setOnClickListener(View.OnClickListener onClickListener) {
        this.chip.setOnClickListener(onClickListener);
    }

    @Override
    public void setTag(int i, Object obj) {
        this.chip.setTag(i, obj);
    }

    public void setHelperText(CharSequence charSequence) {
        this.label.setText(charSequence);
    }

    public void setCursorVisible(boolean z) {
        this.editText.setCursorVisible(z);
    }

    public void addInputFilter(InputFilter inputFilter) {
        InputFilter[] filters = this.editText.getFilters();
        InputFilter[] inputFilterArr = (InputFilter[]) Arrays.copyOf(filters, filters.length + 1);
        inputFilterArr[filters.length] = inputFilter;
        this.editText.setFilters(inputFilterArr);
    }

    public TextInputLayout getTextInput() {
        return this.textInputLayout;
    }

    public void setChipDelegate(AccessibilityDelegateCompat accessibilityDelegateCompat) {
        ViewCompat.setAccessibilityDelegate(this.chip, accessibilityDelegateCompat);
    }

    private class TextFormatter extends TextWatcherAdapter {
        private static final String DEFAULT_TEXT = "00";

        private TextFormatter() {
        }

        @Override
        public void afterTextChanged(Editable editable) {
            if (TextUtils.isEmpty(editable)) {
                ChipTextInputComboView.this.chip.setText(ChipTextInputComboView.this.formatText(DEFAULT_TEXT));
                return;
            }
            String text = ChipTextInputComboView.this.formatText(editable);
            Chip chip = ChipTextInputComboView.this.chip;
            if (TextUtils.isEmpty(text)) {
                text = ChipTextInputComboView.this.formatText(DEFAULT_TEXT);
            }
            chip.setText(text);
        }
    }

    @Override
    protected void onConfigurationChanged(Configuration configuration) {
        super.onConfigurationChanged(configuration);
        updateHintLocales();
    }
}
