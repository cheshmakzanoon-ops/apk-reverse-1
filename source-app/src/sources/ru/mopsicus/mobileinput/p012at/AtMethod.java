package ru.mopsicus.mobileinput.p012at;

import android.text.Spannable;
import android.widget.EditText;

public class AtMethod {
    public void init(EditText editText) {
        editText.setEditableFactory(new NoCopySpanEditableFactory(new SelectionSpanWatcher(DataBindingSpan.class)));
    }

    public Spannable newSpannable(AtUser atUser) {
        return SpanFactory.newSpannable(atUser.getSpannedName(), atUser);
    }
}
