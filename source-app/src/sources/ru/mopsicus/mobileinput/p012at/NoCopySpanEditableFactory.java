package ru.mopsicus.mobileinput.p012at;

import android.text.Editable;
import android.text.NoCopySpan;
import android.text.SpannableStringBuilder;

public class NoCopySpanEditableFactory extends Editable.Factory {
    private final NoCopySpan[] spans;

    public NoCopySpanEditableFactory(NoCopySpan... noCopySpanArr) {
        this.spans = noCopySpanArr;
    }

    @Override
    public Editable newEditable(CharSequence charSequence) {
        SpannableStringBuilder spannableStringBuilderValueOf = SpannableStringBuilder.valueOf(charSequence);
        for (NoCopySpan noCopySpan : this.spans) {
            spannableStringBuilderValueOf.setSpan(noCopySpan, 0, charSequence.length(), 18);
        }
        return spannableStringBuilderValueOf;
    }
}
