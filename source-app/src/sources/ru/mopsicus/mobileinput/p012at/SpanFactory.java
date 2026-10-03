package ru.mopsicus.mobileinput.p012at;

import android.text.Spannable;
import android.text.SpannableString;

public class SpanFactory {
    public static Spannable newSpannable(CharSequence charSequence, Object... objArr) {
        SpannableString spannableStringValueOf = SpannableString.valueOf(charSequence);
        for (Object obj : objArr) {
            spannableStringValueOf.setSpan(obj, 0, spannableStringValueOf.length(), 33);
        }
        return spannableStringValueOf;
    }
}
