package zendesk.storage.android.internal;

import android.content.Context;
import android.content.SharedPreferences;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import zendesk.logger.Logger;
import zendesk.storage.android.Storage;

@Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0007\b\u0000\u0018\u0000 \u00172\u00020\u0001:\u0001\u0017B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\b\u0010\u000b\u001a\u00020\fH\u0016J+\u0010\r\u001a\u0004\u0018\u0001H\u000e\"\u0004\b\u0000\u0010\u000e2\u0006\u0010\u000f\u001a\u00020\u00032\f\u0010\u0010\u001a\b\u0012\u0004\u0012\u0002H\u000e0\u0011H\u0016¢\u0006\u0002\u0010\u0012J\u0010\u0010\u0013\u001a\u00020\f2\u0006\u0010\u000f\u001a\u00020\u0003H\u0016J3\u0010\u0014\u001a\u00020\f\"\u0004\b\u0000\u0010\u000e2\u0006\u0010\u000f\u001a\u00020\u00032\b\u0010\u0015\u001a\u0004\u0018\u0001H\u000e2\f\u0010\u0010\u001a\b\u0012\u0004\u0012\u0002H\u000e0\u0011H\u0016¢\u0006\u0002\u0010\u0016R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u000e\u0010\t\u001a\u00020\nX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0018"}, m18d2 = {"Lzendesk/storage/android/internal/BasicStorage;", "Lzendesk/storage/android/Storage;", "namespace", "", "context", "Landroid/content/Context;", "(Ljava/lang/String;Landroid/content/Context;)V", "getNamespace", "()Ljava/lang/String;", "sharedPreferences", "Landroid/content/SharedPreferences;", "clear", "", "get", "T", "key", "type", "Ljava/lang/Class;", "(Ljava/lang/String;Ljava/lang/Class;)Ljava/lang/Object;", "remove", "set", "value", "(Ljava/lang/String;Ljava/lang/Object;Ljava/lang/Class;)V", "Companion", "zendesk.storage_storage-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class BasicStorage implements Storage {
    private static final String LOG_TAG = "SimpleStorage";
    private final String namespace;
    private final SharedPreferences sharedPreferences;

    public BasicStorage(String namespace, Context context) {
        Intrinsics.checkNotNullParameter(namespace, "namespace");
        Intrinsics.checkNotNullParameter(context, "context");
        this.namespace = namespace;
        SharedPreferences sharedPreferences = context.getSharedPreferences(getNamespace(), 0);
        Intrinsics.checkNotNullExpressionValue(sharedPreferences, "getSharedPreferences(...)");
        this.sharedPreferences = sharedPreferences;
    }

    @Override
    public String getNamespace() {
        return this.namespace;
    }

    @Override
    public <T> T get(String key, Class<T> type) {
        Object objValueOf;
        Intrinsics.checkNotNullParameter(key, "key");
        Intrinsics.checkNotNullParameter(type, "type");
        if (!this.sharedPreferences.contains(key)) {
            Logger.m225w(LOG_TAG, "There is no stored data for the given key", new Object[0]);
            return null;
        }
        try {
            if (Intrinsics.areEqual(type, String.class)) {
                objValueOf = this.sharedPreferences.getString(key, null);
            } else if (Intrinsics.areEqual(type, Integer.TYPE)) {
                objValueOf = Integer.valueOf(this.sharedPreferences.getInt(key, 0));
            } else if (Intrinsics.areEqual(type, Boolean.TYPE)) {
                objValueOf = Boolean.valueOf(this.sharedPreferences.getBoolean(key, false));
            } else if (Intrinsics.areEqual(type, Float.TYPE)) {
                objValueOf = Float.valueOf(this.sharedPreferences.getFloat(key, 0.0f));
            } else {
                if (!Intrinsics.areEqual(type, Long.TYPE)) {
                    return null;
                }
                objValueOf = Long.valueOf(this.sharedPreferences.getLong(key, 0L));
            }
            return (T) objValueOf;
        } catch (ClassCastException e) {
            Logger.m218e(LOG_TAG, "The stored data did not match the requested type", e, new Object[0]);
            return null;
        }
    }

    @Override
    public <T> void set(final String key, final T value, Class<T> type) {
        Intrinsics.checkNotNullParameter(key, "key");
        Intrinsics.checkNotNullParameter(type, "type");
        BasicStorageKt.edit(this.sharedPreferences, new Function1<SharedPreferences.Editor, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(SharedPreferences.Editor editor) {
                invoke2(editor);
                return Unit.INSTANCE;
            }

            public final void invoke2(SharedPreferences.Editor edit) {
                Intrinsics.checkNotNullParameter(edit, "$this$edit");
                T t = value;
                if (t == 0) {
                    edit.remove(key);
                    return;
                }
                if (t instanceof String) {
                    edit.putString(key, (String) t);
                    return;
                }
                if (t instanceof Integer) {
                    edit.putInt(key, ((Number) t).intValue());
                    return;
                }
                if (t instanceof Boolean) {
                    edit.putBoolean(key, ((Boolean) t).booleanValue());
                    return;
                }
                if (t instanceof Float) {
                    edit.putFloat(key, ((Number) t).floatValue());
                } else if (t instanceof Long) {
                    edit.putLong(key, ((Number) t).longValue());
                } else {
                    Logger.m219e(BasicStorage.LOG_TAG, "Unable to store the value provided as it is not a supported type", new Object[0]);
                }
            }
        });
    }

    @Override
    public void remove(final String key) {
        Intrinsics.checkNotNullParameter(key, "key");
        BasicStorageKt.edit(this.sharedPreferences, new Function1<SharedPreferences.Editor, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(SharedPreferences.Editor editor) {
                invoke2(editor);
                return Unit.INSTANCE;
            }

            public final void invoke2(SharedPreferences.Editor edit) {
                Intrinsics.checkNotNullParameter(edit, "$this$edit");
                edit.remove(key);
            }
        });
    }

    @Override
    public void clear() {
        BasicStorageKt.edit(this.sharedPreferences, new Function1<SharedPreferences.Editor, Unit>() {
            @Override
            public Unit invoke(SharedPreferences.Editor editor) {
                invoke2(editor);
                return Unit.INSTANCE;
            }

            public final void invoke2(SharedPreferences.Editor edit) {
                Intrinsics.checkNotNullParameter(edit, "$this$edit");
                edit.clear();
            }
        });
    }
}
