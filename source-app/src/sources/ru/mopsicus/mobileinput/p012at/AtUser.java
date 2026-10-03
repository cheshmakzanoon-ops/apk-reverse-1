package ru.mopsicus.mobileinput.p012at;

import android.text.Spannable;
import android.text.SpannableString;

public class AtUser implements DataBindingSpan {
    private final int color;
    private final int index;
    private String name;

    public AtUser(String str, int i, int i2) {
        this.name = str;
        this.color = i;
        this.index = i2;
    }

    public Spannable getSpannedName() {
        SpannableString spannableString = new SpannableString(this.name);
        spannableString.setSpan(new CustomAtSpan(this.color, this.index), 0, spannableString.length(), 33);
        return spannableString;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String str) {
        this.name = str;
    }
}
