package androidx.core.app;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.job.JobWorkItem;
import android.content.Intent;
import android.content.res.AssetManager;
import android.graphics.Point;
import android.graphics.Rect;
import android.graphics.Typeface;
import android.graphics.fonts.FontVariationAxis;
import android.graphics.text.LineBreakConfig;
import android.os.LocaleList;
import android.text.BoringLayout;
import android.text.GraphemeClusterSegmentFinder;
import android.text.Layout;
import android.text.SegmentFinder;
import android.text.TextPaint;
import android.text.TextUtils;
import android.text.style.LocaleSpan;
import android.view.ScrollCaptureCallback;
import android.view.ScrollCaptureSession;
import android.view.ScrollCaptureTarget;
import android.view.View;
import android.view.autofill.AutofillId;
import android.view.contentcapture.ContentCaptureSession;
import java.io.File;
import java.io.FileDescriptor;

public final class NotificationCompat$$ExternalSyntheticApiModelOutline0 {
    public static Notification.MessagingStyle m10m(Object obj) {
        return (Notification.MessagingStyle) obj;
    }

    public static NotificationChannel m11m(Object obj) {
        return (NotificationChannel) obj;
    }

    public static android.app.Person m12m(Object obj) {
        return (android.app.Person) obj;
    }

    public static JobWorkItem m14m(Intent intent) {
        return new JobWorkItem(intent);
    }

    public static Typeface.Builder m16m(AssetManager assetManager, String str) {
        return new Typeface.Builder(assetManager, str);
    }

    public static Typeface.Builder m18m(File file) {
        return new Typeface.Builder(file);
    }

    public static Typeface.Builder m19m(FileDescriptor fileDescriptor) {
        return new Typeface.Builder(fileDescriptor);
    }

    public static FontVariationAxis m22m(String str, float f) {
        return new FontVariationAxis(str, f);
    }

    public static LineBreakConfig.Builder m23m() {
        return new LineBreakConfig.Builder();
    }

    public static BoringLayout m29m(CharSequence charSequence, TextPaint textPaint, int i, Layout.Alignment alignment, float f, float f2, BoringLayout.Metrics metrics, boolean z, TextUtils.TruncateAt truncateAt, int i2, boolean z2) {
        return new BoringLayout(charSequence, textPaint, i, alignment, f, f2, metrics, z, truncateAt, i2, z2);
    }

    public static GraphemeClusterSegmentFinder m30m(CharSequence charSequence, TextPaint textPaint) {
        return new GraphemeClusterSegmentFinder(charSequence, textPaint);
    }

    public static SegmentFinder m31m(Object obj) {
        return (SegmentFinder) obj;
    }

    public static LocaleSpan m35m(LocaleList localeList) {
        return new LocaleSpan(localeList);
    }

    public static ScrollCaptureCallback m36m(Object obj) {
        return (ScrollCaptureCallback) obj;
    }

    public static ScrollCaptureSession m37m(Object obj) {
        return (ScrollCaptureSession) obj;
    }

    public static ScrollCaptureTarget m38m(View view, Rect rect, Point point, ScrollCaptureCallback scrollCaptureCallback) {
        return new ScrollCaptureTarget(view, rect, point, scrollCaptureCallback);
    }

    public static AutofillId m40m(Object obj) {
        return (AutofillId) obj;
    }

    public static ContentCaptureSession m41m(Object obj) {
        return (ContentCaptureSession) obj;
    }

    public static Class m42m() {
        return Notification.MessagingStyle.class;
    }

    public static void m43m() {
    }

    public static Class m$1() {
        return Notification.DecoratedCustomViewStyle.class;
    }

    public static void m2133m$1() {
    }

    public static void m$2() {
    }
}
