package com.google.android.material.datepicker;

import android.content.Context;
import android.content.res.Resources;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import androidx.core.util.Pair;
import com.google.android.material.C0017R;
import com.google.android.material.internal.ManufacturerUtils;
import com.google.android.material.resources.MaterialAttributes;
import com.google.android.material.textfield.TextInputLayout;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;

public class SingleDateSelector implements DateSelector<Long> {
    public static final Parcelable.Creator<SingleDateSelector> CREATOR = new Parcelable.Creator<SingleDateSelector>() {
        @Override
        public SingleDateSelector createFromParcel(Parcel parcel) {
            SingleDateSelector singleDateSelector = new SingleDateSelector();
            singleDateSelector.selectedItem = (Long) parcel.readValue(Long.class.getClassLoader());
            return singleDateSelector;
        }

        @Override
        public SingleDateSelector[] newArray(int i) {
            return new SingleDateSelector[i];
        }
    };
    private CharSequence error;
    private Long selectedItem;
    private SimpleDateFormat textInputFormat;

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void select(long j) {
        this.selectedItem = Long.valueOf(j);
    }

    public void clearSelection() {
        this.selectedItem = null;
    }

    @Override
    public void setSelection(Long l) {
        this.selectedItem = l == null ? null : Long.valueOf(UtcDates.canonicalYearMonthDay(l.longValue()));
    }

    @Override
    public boolean isSelectionComplete() {
        return this.selectedItem != null;
    }

    @Override
    public Collection<Pair<Long, Long>> getSelectedRanges() {
        return new ArrayList();
    }

    @Override
    public Collection<Long> getSelectedDays() {
        ArrayList arrayList = new ArrayList();
        Long l = this.selectedItem;
        if (l != null) {
            arrayList.add(l);
        }
        return arrayList;
    }

    @Override
    public Long getSelection() {
        return this.selectedItem;
    }

    @Override
    public void setTextInputFormat(SimpleDateFormat simpleDateFormat) {
        if (simpleDateFormat != null) {
            simpleDateFormat = (SimpleDateFormat) UtcDates.getNormalizedFormat(simpleDateFormat);
        }
        this.textInputFormat = simpleDateFormat;
    }

    @Override
    public View onCreateTextInputView(LayoutInflater layoutInflater, ViewGroup viewGroup, Bundle bundle, CalendarConstraints calendarConstraints, final OnSelectionChangedListener<Long> onSelectionChangedListener) {
        String defaultTextInputHint;
        View viewInflate = layoutInflater.inflate(C0017R.layout.mtrl_picker_text_input_date, viewGroup, false);
        final TextInputLayout textInputLayout = (TextInputLayout) viewInflate.findViewById(C0017R.id.mtrl_picker_text_input_date);
        EditText editText = textInputLayout.getEditText();
        if (ManufacturerUtils.isDateInputKeyboardMissingSeparatorCharacters()) {
            editText.setInputType(17);
        }
        SimpleDateFormat defaultTextInputFormat = this.textInputFormat;
        boolean z = defaultTextInputFormat != null;
        if (!z) {
            defaultTextInputFormat = UtcDates.getDefaultTextInputFormat();
        }
        SimpleDateFormat simpleDateFormat = defaultTextInputFormat;
        if (z) {
            defaultTextInputHint = simpleDateFormat.toPattern();
        } else {
            defaultTextInputHint = UtcDates.getDefaultTextInputHint(viewInflate.getResources(), simpleDateFormat);
        }
        String str = defaultTextInputHint;
        textInputLayout.setPlaceholderText(str);
        Long l = this.selectedItem;
        if (l != null) {
            editText.setText(simpleDateFormat.format(l));
        }
        editText.addTextChangedListener(new DateFormatTextWatcher(str, simpleDateFormat, textInputLayout, calendarConstraints) {
            @Override
            void onValidDate(Long l2) {
                if (l2 == null) {
                    SingleDateSelector.this.clearSelection();
                } else {
                    SingleDateSelector.this.select(l2.longValue());
                }
                SingleDateSelector.this.error = null;
                onSelectionChangedListener.onSelectionChanged(SingleDateSelector.this.getSelection());
            }

            @Override
            void onInvalidDate() {
                SingleDateSelector.this.error = textInputLayout.getError();
                onSelectionChangedListener.onIncompleteSelectionChanged();
            }
        });
        DateSelector.CC.showKeyboardWithAutoHideBehavior(editText);
        return viewInflate;
    }

    @Override
    public int getDefaultThemeResId(Context context) {
        return MaterialAttributes.resolveOrThrow(context, C0017R.attr.materialCalendarTheme, MaterialDatePicker.class.getCanonicalName());
    }

    @Override
    public String getSelectionDisplayString(Context context) {
        Resources resources = context.getResources();
        Long l = this.selectedItem;
        if (l == null) {
            return resources.getString(C0017R.string.mtrl_picker_date_header_unselected);
        }
        return resources.getString(C0017R.string.mtrl_picker_date_header_selected, DateStrings.getYearMonthDay(l.longValue()));
    }

    @Override
    public String getSelectionContentDescription(Context context) {
        String yearMonthDay;
        Resources resources = context.getResources();
        Long l = this.selectedItem;
        if (l == null) {
            yearMonthDay = resources.getString(C0017R.string.mtrl_picker_announce_current_selection_none);
        } else {
            yearMonthDay = DateStrings.getYearMonthDay(l.longValue());
        }
        return resources.getString(C0017R.string.mtrl_picker_announce_current_selection, yearMonthDay);
    }

    @Override
    public String getError() {
        if (TextUtils.isEmpty(this.error)) {
            return null;
        }
        return this.error.toString();
    }

    @Override
    public int getDefaultTitleResId() {
        return C0017R.string.mtrl_picker_date_header_title;
    }

    @Override
    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeValue(this.selectedItem);
    }
}
