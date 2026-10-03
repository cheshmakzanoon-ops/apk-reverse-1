package com.sdkmanager.utils;

import android.graphics.Color;
import android.text.SpannableStringBuilder;
import android.text.style.ForegroundColorSpan;
import android.text.style.RelativeSizeSpan;
import android.text.style.StyleSpan;

public class PackingTextStyle extends SpannableStringBuilder {
    private PackingTextStyle() {
    }

    public PackingTextStyle(String str) {
        super(str);
    }

    public PackingTextStyle setTextColor(String str) {
        if (str != null && str.length() > 0 && !str.trim().equals("")) {
            setSpan(new ForegroundColorSpan(Color.parseColor(str)), 0, length(), 33);
        }
        return this;
    }

    public PackingTextStyle setRelativeSizeSpan(float f) {
        setSpan(new RelativeSizeSpan(f), 0, length(), 33);
        return this;
    }

    public PackingTextStyle setTypeFace(int i) {
        setSpan(new StyleSpan(i), i, length(), 33);
        return this;
    }

    public PackingTextStyle(String str, String str2, float f, int i) {
        super(str);
        if (str2 != null && str2.length() > 0 && !str2.trim().equals("")) {
            setSpan(new ForegroundColorSpan(Color.parseColor(str2)), 0, length(), 33);
        }
        setSpan(new RelativeSizeSpan(f), 0, length(), 33);
        setSpan(new StyleSpan(i), i, length(), 33);
    }
}
