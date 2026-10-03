package zendesk.messaging.android.internal;

import android.content.Intent;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.properties.ReadWriteProperty;
import kotlin.reflect.KProperty;

@Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b0\u0018\u0000*\u0004\b\u0000\u0010\u00012\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u0002H\u00010\u0002:\u0005\t\n\u000b\f\rB\u000f\b\u0004\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006R\u0014\u0010\u0004\u001a\u00020\u0005X\u0084\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\b\u0082\u0001\u0005\u000e\u000f\u0010\u0011\u0012¨\u0006\u0013"}, m18d2 = {"Lzendesk/messaging/android/internal/IntentDelegate;", "T", "Lkotlin/properties/ReadWriteProperty;", "Landroid/content/Intent;", "key", "", "(Ljava/lang/String;)V", "getKey", "()Ljava/lang/String;", "Boolean", "Int", "Parcelable", "Serializable", "String", "Lzendesk/messaging/android/internal/IntentDelegate$Boolean;", "Lzendesk/messaging/android/internal/IntentDelegate$Int;", "Lzendesk/messaging/android/internal/IntentDelegate$Parcelable;", "Lzendesk/messaging/android/internal/IntentDelegate$Serializable;", "Lzendesk/messaging/android/internal/IntentDelegate$String;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class IntentDelegate<T> implements ReadWriteProperty<Intent, T> {
    private final java.lang.String key;

    public IntentDelegate(java.lang.String str, DefaultConstructorMarker defaultConstructorMarker) {
        this(str);
    }

    private IntentDelegate(java.lang.String str) {
        this.key = str;
    }

    protected final java.lang.String getKey() {
        return this.key;
    }

    @Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0015\u0012\u0006\u0010\u0003\u001a\u00020\u0004\u0012\u0006\u0010\u0005\u001a\u00020\u0002¢\u0006\u0002\u0010\u0006J\"\u0010\u0007\u001a\u00020\u00022\u0006\u0010\b\u001a\u00020\t2\n\u0010\n\u001a\u0006\u0012\u0002\b\u00030\u000bH\u0096\u0002¢\u0006\u0002\u0010\fJ%\u0010\r\u001a\u00020\u000e2\u0006\u0010\b\u001a\u00020\t2\n\u0010\n\u001a\u0006\u0012\u0002\b\u00030\u000b2\u0006\u0010\u000f\u001a\u00020\u0002H\u0096\u0002R\u000e\u0010\u0005\u001a\u00020\u0002X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0010"}, m18d2 = {"Lzendesk/messaging/android/internal/IntentDelegate$Int;", "Lzendesk/messaging/android/internal/IntentDelegate;", "", "key", "", "defaultValue", "(Ljava/lang/String;I)V", "getValue", "thisRef", "Landroid/content/Intent;", "property", "Lkotlin/reflect/KProperty;", "(Landroid/content/Intent;Lkotlin/reflect/KProperty;)Ljava/lang/Integer;", "setValue", "", "value", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Int extends IntentDelegate<Integer> {
        private final int defaultValue;

        public Int(java.lang.String key, int i) {
            super(key, null);
            Intrinsics.checkNotNullParameter(key, "key");
            this.defaultValue = i;
        }

        @Override
        public Object getValue(Object obj, KProperty kProperty) {
            return getValue((Intent) obj, (KProperty<?>) kProperty);
        }

        @Override
        public void setValue(Intent intent, KProperty kProperty, Object obj) {
            setValue(intent, (KProperty<?>) kProperty, ((Number) obj).intValue());
        }

        public Integer getValue(Intent thisRef, KProperty<?> property) {
            Intrinsics.checkNotNullParameter(thisRef, "thisRef");
            Intrinsics.checkNotNullParameter(property, "property");
            return Integer.valueOf(thisRef.getIntExtra(getKey(), this.defaultValue));
        }

        public void setValue(Intent thisRef, KProperty<?> property, int value) {
            Intrinsics.checkNotNullParameter(thisRef, "thisRef");
            Intrinsics.checkNotNullParameter(property, "property");
            thisRef.putExtra(getKey(), value);
        }
    }

    @Metadata(m17d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\r\u0012\u0006\u0010\u0003\u001a\u00020\u0002¢\u0006\u0002\u0010\u0004J\u001d\u0010\u0005\u001a\u00020\u00022\u0006\u0010\u0006\u001a\u00020\u00072\n\u0010\b\u001a\u0006\u0012\u0002\b\u00030\tH\u0096\u0002J%\u0010\n\u001a\u00020\u000b2\u0006\u0010\u0006\u001a\u00020\u00072\n\u0010\b\u001a\u0006\u0012\u0002\b\u00030\t2\u0006\u0010\f\u001a\u00020\u0002H\u0096\u0002¨\u0006\r"}, m18d2 = {"Lzendesk/messaging/android/internal/IntentDelegate$String;", "Lzendesk/messaging/android/internal/IntentDelegate;", "", "key", "(Ljava/lang/String;)V", "getValue", "thisRef", "Landroid/content/Intent;", "property", "Lkotlin/reflect/KProperty;", "setValue", "", "value", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class String extends IntentDelegate<java.lang.String> {
        public String(java.lang.String key) {
            super(key, null);
            Intrinsics.checkNotNullParameter(key, "key");
        }

        @Override
        public Object getValue(Object obj, KProperty kProperty) {
            return getValue((Intent) obj, (KProperty<?>) kProperty);
        }

        @Override
        public void setValue(Intent intent, KProperty kProperty, Object obj) {
            setValue(intent, (KProperty<?>) kProperty, (java.lang.String) obj);
        }

        public java.lang.String getValue(Intent thisRef, KProperty<?> property) {
            Intrinsics.checkNotNullParameter(thisRef, "thisRef");
            Intrinsics.checkNotNullParameter(property, "property");
            java.lang.String stringExtra = thisRef.getStringExtra(getKey());
            return stringExtra == null ? "" : stringExtra;
        }

        public void setValue(Intent thisRef, KProperty<?> property, java.lang.String value) {
            Intrinsics.checkNotNullParameter(thisRef, "thisRef");
            Intrinsics.checkNotNullParameter(property, "property");
            Intrinsics.checkNotNullParameter(value, "value");
            thisRef.putExtra(getKey(), value);
        }
    }

    @Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0015\u0012\u0006\u0010\u0003\u001a\u00020\u0004\u0012\u0006\u0010\u0005\u001a\u00020\u0002¢\u0006\u0002\u0010\u0006J\"\u0010\u0007\u001a\u00020\u00022\u0006\u0010\b\u001a\u00020\t2\n\u0010\n\u001a\u0006\u0012\u0002\b\u00030\u000bH\u0096\u0002¢\u0006\u0002\u0010\fJ%\u0010\r\u001a\u00020\u000e2\u0006\u0010\b\u001a\u00020\t2\n\u0010\n\u001a\u0006\u0012\u0002\b\u00030\u000b2\u0006\u0010\u000f\u001a\u00020\u0002H\u0096\u0002R\u000e\u0010\u0005\u001a\u00020\u0002X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0010"}, m18d2 = {"Lzendesk/messaging/android/internal/IntentDelegate$Boolean;", "Lzendesk/messaging/android/internal/IntentDelegate;", "", "key", "", "defaultValue", "(Ljava/lang/String;Z)V", "getValue", "thisRef", "Landroid/content/Intent;", "property", "Lkotlin/reflect/KProperty;", "(Landroid/content/Intent;Lkotlin/reflect/KProperty;)Ljava/lang/Boolean;", "setValue", "", "value", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Boolean extends IntentDelegate<java.lang.Boolean> {
        private final boolean defaultValue;

        public Boolean(java.lang.String key, boolean z) {
            super(key, null);
            Intrinsics.checkNotNullParameter(key, "key");
            this.defaultValue = z;
        }

        @Override
        public Object getValue(Object obj, KProperty kProperty) {
            return getValue((Intent) obj, (KProperty<?>) kProperty);
        }

        @Override
        public void setValue(Intent intent, KProperty kProperty, Object obj) {
            setValue(intent, (KProperty<?>) kProperty, ((java.lang.Boolean) obj).booleanValue());
        }

        public java.lang.Boolean getValue(Intent thisRef, KProperty<?> property) {
            Intrinsics.checkNotNullParameter(thisRef, "thisRef");
            Intrinsics.checkNotNullParameter(property, "property");
            return java.lang.Boolean.valueOf(thisRef.getBooleanExtra(getKey(), this.defaultValue));
        }

        public void setValue(Intent thisRef, KProperty<?> property, boolean value) {
            Intrinsics.checkNotNullParameter(thisRef, "thisRef");
            Intrinsics.checkNotNullParameter(property, "property");
            thisRef.putExtra(getKey(), value);
        }
    }

    @Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0003\u0018\u0000*\b\b\u0001\u0010\u0001*\u00020\u00022\n\u0012\u0006\u0012\u0004\u0018\u0001H\u00010\u0003B\r\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J$\u0010\u0007\u001a\u0004\u0018\u00018\u00012\u0006\u0010\b\u001a\u00020\t2\n\u0010\n\u001a\u0006\u0012\u0002\b\u00030\u000bH\u0096\u0002¢\u0006\u0002\u0010\fJ,\u0010\r\u001a\u00020\u000e2\u0006\u0010\b\u001a\u00020\t2\n\u0010\n\u001a\u0006\u0012\u0002\b\u00030\u000b2\b\u0010\u000f\u001a\u0004\u0018\u00018\u0001H\u0096\u0002¢\u0006\u0002\u0010\u0010¨\u0006\u0011"}, m18d2 = {"Lzendesk/messaging/android/internal/IntentDelegate$Serializable;", "T", "Ljava/io/Serializable;", "Lzendesk/messaging/android/internal/IntentDelegate;", "key", "", "(Ljava/lang/String;)V", "getValue", "thisRef", "Landroid/content/Intent;", "property", "Lkotlin/reflect/KProperty;", "(Landroid/content/Intent;Lkotlin/reflect/KProperty;)Ljava/io/Serializable;", "setValue", "", "value", "(Landroid/content/Intent;Lkotlin/reflect/KProperty;Ljava/io/Serializable;)V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Serializable<T extends java.io.Serializable> extends IntentDelegate<T> {
        public Serializable(java.lang.String key) {
            super(key, null);
            Intrinsics.checkNotNullParameter(key, "key");
        }

        @Override
        public Object getValue(Object obj, KProperty kProperty) {
            return getValue((Intent) obj, (KProperty<?>) kProperty);
        }

        @Override
        public void setValue(Intent intent, KProperty kProperty, Object obj) {
            setValue(intent, (KProperty<?>) kProperty, (java.io.Serializable) obj);
        }

        public T getValue(Intent thisRef, KProperty<?> property) {
            Intrinsics.checkNotNullParameter(thisRef, "thisRef");
            Intrinsics.checkNotNullParameter(property, "property");
            T t = (T) thisRef.getSerializableExtra(getKey());
            if (t instanceof java.io.Serializable) {
                return t;
            }
            return null;
        }

        public void setValue(Intent thisRef, KProperty<?> property, T value) {
            Intrinsics.checkNotNullParameter(thisRef, "thisRef");
            Intrinsics.checkNotNullParameter(property, "property");
            thisRef.putExtra(getKey(), value);
        }
    }

    @Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0003\u0018\u0000*\b\b\u0001\u0010\u0001*\u00020\u00022\n\u0012\u0006\u0012\u0004\u0018\u0001H\u00010\u0003B\r\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J$\u0010\u0007\u001a\u0004\u0018\u00018\u00012\u0006\u0010\b\u001a\u00020\t2\n\u0010\n\u001a\u0006\u0012\u0002\b\u00030\u000bH\u0096\u0002¢\u0006\u0002\u0010\fJ,\u0010\r\u001a\u00020\u000e2\u0006\u0010\b\u001a\u00020\t2\n\u0010\n\u001a\u0006\u0012\u0002\b\u00030\u000b2\b\u0010\u000f\u001a\u0004\u0018\u00018\u0001H\u0096\u0002¢\u0006\u0002\u0010\u0010¨\u0006\u0011"}, m18d2 = {"Lzendesk/messaging/android/internal/IntentDelegate$Parcelable;", "T", "Landroid/os/Parcelable;", "Lzendesk/messaging/android/internal/IntentDelegate;", "key", "", "(Ljava/lang/String;)V", "getValue", "thisRef", "Landroid/content/Intent;", "property", "Lkotlin/reflect/KProperty;", "(Landroid/content/Intent;Lkotlin/reflect/KProperty;)Landroid/os/Parcelable;", "setValue", "", "value", "(Landroid/content/Intent;Lkotlin/reflect/KProperty;Landroid/os/Parcelable;)V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Parcelable<T extends android.os.Parcelable> extends IntentDelegate<T> {
        public Parcelable(java.lang.String key) {
            super(key, null);
            Intrinsics.checkNotNullParameter(key, "key");
        }

        @Override
        public Object getValue(Object obj, KProperty kProperty) {
            return getValue((Intent) obj, (KProperty<?>) kProperty);
        }

        @Override
        public void setValue(Intent intent, KProperty kProperty, Object obj) {
            setValue(intent, (KProperty<?>) kProperty, (android.os.Parcelable) obj);
        }

        public T getValue(Intent thisRef, KProperty<?> property) {
            Intrinsics.checkNotNullParameter(thisRef, "thisRef");
            Intrinsics.checkNotNullParameter(property, "property");
            return (T) thisRef.getParcelableExtra(getKey());
        }

        public void setValue(Intent thisRef, KProperty<?> property, T value) {
            Intrinsics.checkNotNullParameter(thisRef, "thisRef");
            Intrinsics.checkNotNullParameter(property, "property");
            thisRef.putExtra(getKey(), value);
        }
    }
}
