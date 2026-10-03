package ru.mopsicus.mobileinput.p012at;

import android.text.style.ForegroundColorSpan;

public class CustomAtSpan extends ForegroundColorSpan {
    public int index;

    public CustomAtSpan(int i, int i2) {
        super(i);
        this.index = i2;
    }
}
