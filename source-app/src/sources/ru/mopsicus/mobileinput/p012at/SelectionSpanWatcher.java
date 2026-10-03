package ru.mopsicus.mobileinput.p012at;

import android.text.Selection;
import android.text.Spannable;

public class SelectionSpanWatcher<T> extends SpanWatcherAdapter {
    private final Class<T> clazz;
    private int selStart = 0;
    private int selEnd = 0;

    public SelectionSpanWatcher(Class<T> cls) {
        this.clazz = cls;
    }

    @Override
    public void onSpanChanged(Spannable spannable, Object obj, int i, int i2, int i3, int i4) {
        if (obj == Selection.SELECTION_END && this.selEnd != i3) {
            this.selEnd = i3;
            Object[] spans = spannable.getSpans(i3, i4, this.clazz);
            if (spans != null && spans.length > 0) {
                Object obj2 = spans[0];
                int spanStart = spannable.getSpanStart(obj2);
                int spanEnd = spannable.getSpanEnd(obj2);
                if (Math.abs(this.selEnd - spanEnd) <= Math.abs(this.selEnd - spanStart)) {
                    spanStart = spanEnd;
                }
                Selection.setSelection(spannable, Selection.getSelectionStart(spannable), spanStart);
            }
        }
        if (obj != Selection.SELECTION_START || this.selStart == i3) {
            return;
        }
        this.selStart = i3;
        Object[] spans2 = spannable.getSpans(i3, i4, this.clazz);
        if (spans2 == null || spans2.length <= 0) {
            return;
        }
        Object obj3 = spans2[0];
        int spanStart2 = spannable.getSpanStart(obj3);
        int spanEnd2 = spannable.getSpanEnd(obj3);
        if (Math.abs(this.selStart - spanEnd2) <= Math.abs(this.selStart - spanStart2)) {
            spanStart2 = spanEnd2;
        }
        Selection.setSelection(spannable, spanStart2, Selection.getSelectionEnd(spannable));
    }
}
