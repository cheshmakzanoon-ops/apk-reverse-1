package androidx.appcompat.widget;

import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.content.res.ColorStateList;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.content.res.TypedArray;
import android.content.res.XmlResourceParser;
import android.graphics.Movie;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.util.AttributeSet;
import android.util.DisplayMetrics;
import android.util.TypedValue;
import java.io.IOException;
import java.io.InputStream;
import java.lang.ref.WeakReference;
import org.xmlpull.v1.XmlPullParserException;

public class VectorEnabledTintResources extends ResourcesWrapper {
    public static final int MAX_SDK_WHERE_REQUIRED = 20;
    private static boolean sCompatVectorFromResourcesEnabled;
    private final WeakReference<Context> mContextRef;

    @Override
    public XmlResourceParser getAnimation(int i) throws Resources.NotFoundException {
        return super.getAnimation(i);
    }

    @Override
    public boolean getBoolean(int i) throws Resources.NotFoundException {
        return super.getBoolean(i);
    }

    @Override
    public int getColor(int i) throws Resources.NotFoundException {
        return super.getColor(i);
    }

    @Override
    public ColorStateList getColorStateList(int i) throws Resources.NotFoundException {
        return super.getColorStateList(i);
    }

    @Override
    public Configuration getConfiguration() {
        return super.getConfiguration();
    }

    @Override
    public float getDimension(int i) throws Resources.NotFoundException {
        return super.getDimension(i);
    }

    @Override
    public int getDimensionPixelOffset(int i) throws Resources.NotFoundException {
        return super.getDimensionPixelOffset(i);
    }

    @Override
    public int getDimensionPixelSize(int i) throws Resources.NotFoundException {
        return super.getDimensionPixelSize(i);
    }

    @Override
    public DisplayMetrics getDisplayMetrics() {
        return super.getDisplayMetrics();
    }

    @Override
    public Drawable getDrawable(int i, Resources.Theme theme) throws Resources.NotFoundException {
        return super.getDrawable(i, theme);
    }

    @Override
    public Drawable getDrawableForDensity(int i, int i2) throws Resources.NotFoundException {
        return super.getDrawableForDensity(i, i2);
    }

    @Override
    public Drawable getDrawableForDensity(int i, int i2, Resources.Theme theme) {
        return super.getDrawableForDensity(i, i2, theme);
    }

    @Override
    public float getFraction(int i, int i2, int i3) {
        return super.getFraction(i, i2, i3);
    }

    @Override
    public int getIdentifier(String str, String str2, String str3) {
        return super.getIdentifier(str, str2, str3);
    }

    @Override
    public int[] getIntArray(int i) throws Resources.NotFoundException {
        return super.getIntArray(i);
    }

    @Override
    public int getInteger(int i) throws Resources.NotFoundException {
        return super.getInteger(i);
    }

    @Override
    public XmlResourceParser getLayout(int i) throws Resources.NotFoundException {
        return super.getLayout(i);
    }

    @Override
    public Movie getMovie(int i) throws Resources.NotFoundException {
        return super.getMovie(i);
    }

    @Override
    public String getQuantityString(int i, int i2) throws Resources.NotFoundException {
        return super.getQuantityString(i, i2);
    }

    @Override
    public String getQuantityString(int i, int i2, Object[] objArr) throws Resources.NotFoundException {
        return super.getQuantityString(i, i2, objArr);
    }

    @Override
    public CharSequence getQuantityText(int i, int i2) throws Resources.NotFoundException {
        return super.getQuantityText(i, i2);
    }

    @Override
    public String getResourceEntryName(int i) throws Resources.NotFoundException {
        return super.getResourceEntryName(i);
    }

    @Override
    public String getResourceName(int i) throws Resources.NotFoundException {
        return super.getResourceName(i);
    }

    @Override
    public String getResourcePackageName(int i) throws Resources.NotFoundException {
        return super.getResourcePackageName(i);
    }

    @Override
    public String getResourceTypeName(int i) throws Resources.NotFoundException {
        return super.getResourceTypeName(i);
    }

    @Override
    public String getString(int i) throws Resources.NotFoundException {
        return super.getString(i);
    }

    @Override
    public String getString(int i, Object[] objArr) throws Resources.NotFoundException {
        return super.getString(i, objArr);
    }

    @Override
    public String[] getStringArray(int i) throws Resources.NotFoundException {
        return super.getStringArray(i);
    }

    @Override
    public CharSequence getText(int i) throws Resources.NotFoundException {
        return super.getText(i);
    }

    @Override
    public CharSequence getText(int i, CharSequence charSequence) {
        return super.getText(i, charSequence);
    }

    @Override
    public CharSequence[] getTextArray(int i) throws Resources.NotFoundException {
        return super.getTextArray(i);
    }

    @Override
    public void getValue(int i, TypedValue typedValue, boolean z) throws Resources.NotFoundException {
        super.getValue(i, typedValue, z);
    }

    @Override
    public void getValue(String str, TypedValue typedValue, boolean z) throws Resources.NotFoundException {
        super.getValue(str, typedValue, z);
    }

    @Override
    public void getValueForDensity(int i, int i2, TypedValue typedValue, boolean z) throws Resources.NotFoundException {
        super.getValueForDensity(i, i2, typedValue, z);
    }

    @Override
    public XmlResourceParser getXml(int i) throws Resources.NotFoundException {
        return super.getXml(i);
    }

    @Override
    public TypedArray obtainAttributes(AttributeSet attributeSet, int[] iArr) {
        return super.obtainAttributes(attributeSet, iArr);
    }

    @Override
    public TypedArray obtainTypedArray(int i) throws Resources.NotFoundException {
        return super.obtainTypedArray(i);
    }

    @Override
    public InputStream openRawResource(int i) throws Resources.NotFoundException {
        return super.openRawResource(i);
    }

    @Override
    public InputStream openRawResource(int i, TypedValue typedValue) throws Resources.NotFoundException {
        return super.openRawResource(i, typedValue);
    }

    @Override
    public AssetFileDescriptor openRawResourceFd(int i) throws Resources.NotFoundException {
        return super.openRawResourceFd(i);
    }

    @Override
    public void parseBundleExtra(String str, AttributeSet attributeSet, Bundle bundle) throws XmlPullParserException {
        super.parseBundleExtra(str, attributeSet, bundle);
    }

    @Override
    public void parseBundleExtras(XmlResourceParser xmlResourceParser, Bundle bundle) throws XmlPullParserException, IOException {
        super.parseBundleExtras(xmlResourceParser, bundle);
    }

    @Override
    public void updateConfiguration(Configuration configuration, DisplayMetrics displayMetrics) {
        super.updateConfiguration(configuration, displayMetrics);
    }

    public static boolean shouldBeUsed() {
        isCompatVectorFromResourcesEnabled();
        return false;
    }

    public VectorEnabledTintResources(Context context, Resources resources) {
        super(resources);
        this.mContextRef = new WeakReference<>(context);
    }

    @Override
    public Drawable getDrawable(int i) throws Resources.NotFoundException {
        Context context = this.mContextRef.get();
        if (context != null) {
            return ResourceManagerInternal.get().onDrawableLoadedFromResources(context, this, i);
        }
        return getDrawableCanonical(i);
    }

    public static void setCompatVectorFromResourcesEnabled(boolean z) {
        sCompatVectorFromResourcesEnabled = z;
    }

    public static boolean isCompatVectorFromResourcesEnabled() {
        return sCompatVectorFromResourcesEnabled;
    }
}
