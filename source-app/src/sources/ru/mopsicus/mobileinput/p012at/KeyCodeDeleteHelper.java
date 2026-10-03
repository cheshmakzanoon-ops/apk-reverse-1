package ru.mopsicus.mobileinput.p012at;

import android.text.Selection;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import java.util.ArrayList;
import java.util.List;

public class KeyCodeDeleteHelper {
    public static List<Integer> deleteMentions = new ArrayList();

    public static boolean onDelDown(Spannable spannable) {
        int selectionStart = Selection.getSelectionStart(spannable);
        int selectionEnd = Selection.getSelectionEnd(spannable);
        CustomAtSpan[] customAtSpanArr = (CustomAtSpan[]) spannable.getSpans(selectionStart, selectionEnd, CustomAtSpan.class);
        deleteMentions.clear();
        for (CustomAtSpan customAtSpan : customAtSpanArr) {
            deleteMentions.add(Integer.valueOf(customAtSpan.index));
        }
        for (CustomAtSpan customAtSpan2 : customAtSpanArr) {
            int spanEnd = spannable.getSpanEnd(customAtSpan2);
            if (spanEnd == selectionStart && selectionStart == selectionEnd) {
                ((SpannableStringBuilder) spannable).delete(spannable.getSpanStart(customAtSpan2), spanEnd);
                return true;
            }
        }
        return false;
    }
}
