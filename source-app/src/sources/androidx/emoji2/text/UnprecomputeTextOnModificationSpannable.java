package androidx.emoji2.text;

import android.os.Build;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.Spanned;
import androidx.core.text.PrecomputedTextCompat;
import androidx.core.util.HalfKt$$ExternalSyntheticApiModelOutline0;
import java.util.stream.IntStream;

class UnprecomputeTextOnModificationSpannable implements Spannable {
    private Spannable mDelegate;
    private boolean mSafeToWrite = false;

    @Override
    public IntStream chars() {
        return j$.util.stream.IntStream.Wrapper.convert(chars());
    }

    @Override
    public IntStream codePoints() {
        return j$.util.stream.IntStream.Wrapper.convert(codePoints());
    }

    UnprecomputeTextOnModificationSpannable(Spannable spannable) {
        this.mDelegate = spannable;
    }

    UnprecomputeTextOnModificationSpannable(Spanned spanned) {
        this.mDelegate = new SpannableString(spanned);
    }

    UnprecomputeTextOnModificationSpannable(CharSequence charSequence) {
        this.mDelegate = new SpannableString(charSequence);
    }

    private void ensureSafeWrites() {
        Spannable spannable = this.mDelegate;
        if (!this.mSafeToWrite && precomputedTextDetector().isPrecomputedText(spannable)) {
            this.mDelegate = new SpannableString(spannable);
        }
        this.mSafeToWrite = true;
    }

    Spannable getUnwrappedSpannable() {
        return this.mDelegate;
    }

    @Override
    public void setSpan(Object obj, int i, int i2, int i3) {
        ensureSafeWrites();
        this.mDelegate.setSpan(obj, i, i2, i3);
    }

    @Override
    public void removeSpan(Object obj) {
        ensureSafeWrites();
        this.mDelegate.removeSpan(obj);
    }

    @Override
    public <T> T[] getSpans(int i, int i2, Class<T> cls) {
        return (T[]) this.mDelegate.getSpans(i, i2, cls);
    }

    @Override
    public int getSpanStart(Object obj) {
        return this.mDelegate.getSpanStart(obj);
    }

    @Override
    public int getSpanEnd(Object obj) {
        return this.mDelegate.getSpanEnd(obj);
    }

    @Override
    public int getSpanFlags(Object obj) {
        return this.mDelegate.getSpanFlags(obj);
    }

    @Override
    public int nextSpanTransition(int i, int i2, Class cls) {
        return this.mDelegate.nextSpanTransition(i, i2, cls);
    }

    @Override
    public int length() {
        return this.mDelegate.length();
    }

    @Override
    public char charAt(int i) {
        return this.mDelegate.charAt(i);
    }

    @Override
    public CharSequence subSequence(int i, int i2) {
        return this.mDelegate.subSequence(i, i2);
    }

    @Override
    public String toString() {
        return this.mDelegate.toString();
    }

    @Override
    public j$.util.stream.IntStream chars() {
        return CharSequenceHelper_API24.chars(this.mDelegate);
    }

    @Override
    public j$.util.stream.IntStream codePoints() {
        return CharSequenceHelper_API24.codePoints(this.mDelegate);
    }

    private static class CharSequenceHelper_API24 {
        private CharSequenceHelper_API24() {
        }

        static j$.util.stream.IntStream codePoints(CharSequence charSequence) {
            return j$.util.stream.IntStream.VivifiedWrapper.convert(charSequence.codePoints());
        }

        static j$.util.stream.IntStream chars(CharSequence charSequence) {
            return j$.util.stream.IntStream.VivifiedWrapper.convert(charSequence.chars());
        }
    }

    static PrecomputedTextDetector precomputedTextDetector() {
        return Build.VERSION.SDK_INT < 28 ? new PrecomputedTextDetector() : new PrecomputedTextDetector_28();
    }

    static class PrecomputedTextDetector {
        PrecomputedTextDetector() {
        }

        boolean isPrecomputedText(CharSequence charSequence) {
            return charSequence instanceof PrecomputedTextCompat;
        }
    }

    static class PrecomputedTextDetector_28 extends PrecomputedTextDetector {
        PrecomputedTextDetector_28() {
        }

        @Override
        boolean isPrecomputedText(CharSequence charSequence) {
            return HalfKt$$ExternalSyntheticApiModelOutline0.m244m((Object) charSequence) || (charSequence instanceof PrecomputedTextCompat);
        }
    }
}
