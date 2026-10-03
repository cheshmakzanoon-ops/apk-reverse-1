package com.unity.androidnotifications;

import android.app.Notification;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.os.Build;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;
import android.util.Base64;
import android.util.Log;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;

public class UnityNotificationUtilities {
    private static final int INTENT_SERIALIZATION_VERSION = 0;
    private static final int NOTIFICATION_SERIALIZATION_VERSION = 0;
    private static final String SAVED_NOTIFICATION_FALLBACK_KEY = "fallback.data";
    private static final String SAVED_NOTIFICATION_PRIMARY_KEY = "data";
    private static final byte[] UNITY_MAGIC_NUMBER = {85, 77, 78, 78};
    private static final byte[] UNITY_MAGIC_NUMBER_PARCELLED = {85, 77, 78, 80};

    protected static int findResourceIdInContextByName(Context context, String str) {
        if (str == null) {
            return 0;
        }
        try {
            Resources resources = context.getResources();
            if (resources != null) {
                int identifier = resources.getIdentifier(str, "mipmap", context.getPackageName());
                return identifier == 0 ? resources.getIdentifier(str, "drawable", context.getPackageName()) : identifier;
            }
        } catch (Resources.NotFoundException unused) {
        }
        return 0;
    }

    protected static void serializeNotification(SharedPreferences sharedPreferences, Notification notification) {
        String strEncodeToString;
        String strEncodeToString2;
        try {
            ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            DataOutputStream dataOutputStream = new DataOutputStream(byteArrayOutputStream);
            if (serializeNotificationCustom(notification, dataOutputStream)) {
                dataOutputStream.flush();
                byte[] byteArray = byteArrayOutputStream.toByteArray();
                strEncodeToString = Base64.encodeToString(byteArray, 0, byteArray.length, 0);
            } else {
                strEncodeToString = null;
            }
            byteArrayOutputStream.reset();
            Intent intent = new Intent();
            intent.putExtra("unityNotification", notification);
            if (serializeNotificationParcel(intent, dataOutputStream)) {
                dataOutputStream.close();
                byte[] byteArray2 = byteArrayOutputStream.toByteArray();
                strEncodeToString2 = Base64.encodeToString(byteArray2, 0, byteArray2.length, 0);
            } else {
                strEncodeToString2 = strEncodeToString;
            }
            SharedPreferences.Editor editorClear = sharedPreferences.edit().clear();
            editorClear.putString("data", strEncodeToString2);
            editorClear.putString(SAVED_NOTIFICATION_FALLBACK_KEY, strEncodeToString);
            editorClear.apply();
        } catch (Exception e) {
            Log.e("UnityNotifications", "Failed to serialize notification", e);
        }
    }

    private static boolean serializeNotificationParcel(Intent intent, DataOutputStream dataOutputStream) {
        try {
            byte[] bArrSerializeParcelable = serializeParcelable(intent);
            if (bArrSerializeParcelable != null && bArrSerializeParcelable.length != 0) {
                dataOutputStream.write(UNITY_MAGIC_NUMBER_PARCELLED);
                dataOutputStream.writeInt(0);
                dataOutputStream.writeInt(bArrSerializeParcelable.length);
                dataOutputStream.write(bArrSerializeParcelable);
                return true;
            }
            return false;
        } catch (Exception e) {
            Log.e("UnityNotifications", "Failed to serialize notification as Parcel", e);
            return false;
        } catch (OutOfMemoryError e2) {
            Log.e("UnityNotifications", "Failed to serialize notification as Parcel", e2);
            return false;
        }
    }

    private static boolean serializeNotificationCustom(Notification notification, DataOutputStream dataOutputStream) {
        try {
            dataOutputStream.write(UNITY_MAGIC_NUMBER);
            dataOutputStream.writeInt(0);
            boolean z = notification.extras.getBoolean("android.showWhen", false);
            byte[] bArrSerializeParcelable = serializeParcelable(notification.extras);
            dataOutputStream.writeInt(bArrSerializeParcelable == null ? 0 : bArrSerializeParcelable.length);
            if (bArrSerializeParcelable != null && bArrSerializeParcelable.length > 0) {
                dataOutputStream.write(bArrSerializeParcelable);
            } else {
                dataOutputStream.writeInt(notification.extras.getInt("id"));
                serializeString(dataOutputStream, notification.extras.getString("android.title"));
                serializeString(dataOutputStream, notification.extras.getString("android.text"));
                serializeString(dataOutputStream, notification.extras.getString("smallIcon"));
                serializeString(dataOutputStream, notification.extras.getString("largeIcon"));
                dataOutputStream.writeLong(notification.extras.getLong("fireTime", -1L));
                dataOutputStream.writeLong(notification.extras.getLong("repeatInterval", -1L));
                serializeString(dataOutputStream, notification.extras.getString("android.bigText"));
                dataOutputStream.writeBoolean(notification.extras.getBoolean("android.showChronometer", false));
                dataOutputStream.writeBoolean(z);
                serializeString(dataOutputStream, notification.extras.getString("data"));
            }
            serializeString(dataOutputStream, Build.VERSION.SDK_INT < 26 ? null : notification.getChannelId());
            Integer notificationColor = UnityNotificationManager.getNotificationColor(notification);
            dataOutputStream.writeBoolean(notificationColor != null);
            if (notificationColor != null) {
                dataOutputStream.writeInt(notificationColor.intValue());
            }
            dataOutputStream.writeInt(notification.number);
            dataOutputStream.writeBoolean((notification.flags & 16) != 0);
            serializeString(dataOutputStream, notification.getGroup());
            dataOutputStream.writeBoolean((notification.flags & 512) != 0);
            dataOutputStream.writeInt(UnityNotificationManager.getNotificationGroupAlertBehavior(notification));
            serializeString(dataOutputStream, notification.getSortKey());
            if (z) {
                dataOutputStream.writeLong(notification.when);
            }
            return true;
        } catch (Exception e) {
            Log.e("UnityNotifications", "Failed to serialize notification", e);
            return false;
        }
    }

    private static void serializeString(DataOutputStream dataOutputStream, String str) throws IOException {
        if (str == null || str.length() == 0) {
            dataOutputStream.writeInt(0);
            return;
        }
        byte[] bytes = str.getBytes(StandardCharsets.UTF_8);
        dataOutputStream.writeInt(bytes.length);
        dataOutputStream.write(bytes);
    }

    private static byte[] serializeParcelable(Parcelable parcelable) {
        try {
            Parcel parcelObtain = Parcel.obtain();
            Bundle bundle = new Bundle();
            bundle.putParcelable("obj", parcelable);
            parcelObtain.writeParcelable(bundle, 0);
            byte[] bArrMarshall = parcelObtain.marshall();
            parcelObtain.recycle();
            return bArrMarshall;
        } catch (Exception e) {
            Log.e("UnityNotifications", "Failed to serialize Parcelable", e);
            return null;
        } catch (OutOfMemoryError e2) {
            Log.e("UnityNotifications", "Failed to serialize Parcelable", e2);
            return null;
        }
    }

    protected static Object deserializeNotification(Context context, SharedPreferences sharedPreferences) {
        String string = sharedPreferences.getString("data", "");
        if (string != null && string.length() > 0) {
            Object objDeserializeNotification = deserializeNotification(context, Base64.decode(string, 0));
            if (objDeserializeNotification != null) {
                return objDeserializeNotification;
            }
            String string2 = sharedPreferences.getString(SAVED_NOTIFICATION_FALLBACK_KEY, "");
            if (string2 != null && string2.length() > 0) {
                return deserializeNotification(context, Base64.decode(string2, 0));
            }
        }
        return null;
    }

    private static Object deserializeNotification(Context context, byte[] bArr) {
        ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(bArr);
        DataInputStream dataInputStream = new DataInputStream(byteArrayInputStream);
        Notification notificationDeserializeNotificationParcelable = deserializeNotificationParcelable(dataInputStream);
        if (notificationDeserializeNotificationParcelable != null) {
            return notificationDeserializeNotificationParcelable;
        }
        byteArrayInputStream.reset();
        Notification.Builder builderDeserializeNotificationCustom = deserializeNotificationCustom(dataInputStream);
        return builderDeserializeNotificationCustom == null ? deserializedFromOldIntent(bArr) : builderDeserializeNotificationCustom;
    }

    private static boolean readAndCheckMagicNumber(DataInputStream dataInputStream, byte[] bArr) {
        for (byte b : bArr) {
            try {
                if (dataInputStream.readByte() != b) {
                    return false;
                }
            } catch (Exception unused) {
                return false;
            }
        }
        return true;
    }

    private static Notification deserializeNotificationParcelable(DataInputStream dataInputStream) {
        int i;
        try {
            if (readAndCheckMagicNumber(dataInputStream, UNITY_MAGIC_NUMBER_PARCELLED) && (i = dataInputStream.readInt()) >= 0 && i <= 0) {
                return (Notification) ((Intent) deserializeParcelable(dataInputStream)).getParcelableExtra("unityNotification");
            }
            return null;
        } catch (Exception e) {
            Log.e("UnityNotifications", "Failed to deserialize notification intent", e);
            return null;
        } catch (OutOfMemoryError e2) {
            Log.e("UnityNotifications", "Failed to deserialize notification intent", e2);
            return null;
        }
    }

    private static Notification.Builder deserializeNotificationCustom(DataInputStream dataInputStream) {
        String str;
        String str2;
        String str3;
        String str4;
        String str5;
        Bundle bundle;
        String string;
        String string2;
        String string3;
        String string4;
        long j;
        long j2;
        String string5;
        boolean z;
        boolean z2;
        String string6;
        int i;
        String str6 = "Failed to deserialize notification";
        try {
            try {
                try {
                    if (!readAndCheckMagicNumber(dataInputStream, UNITY_MAGIC_NUMBER)) {
                        return null;
                    }
                    int i2 = dataInputStream.readInt();
                    if (i2 < 0 || i2 > 0) {
                        return null;
                    }
                    try {
                        try {
                            bundle = (Bundle) deserializeParcelable(dataInputStream);
                        } catch (ClassCastException e) {
                            Log.e("UnityNotifications", "Unexpect type of deserialized object", e);
                            bundle = null;
                        }
                        if (bundle == null) {
                            i = dataInputStream.readInt();
                            string = deserializeString(dataInputStream);
                            string2 = deserializeString(dataInputStream);
                            string3 = deserializeString(dataInputStream);
                            string4 = deserializeString(dataInputStream);
                            j = dataInputStream.readLong();
                            j2 = dataInputStream.readLong();
                            string5 = deserializeString(dataInputStream);
                            z = dataInputStream.readBoolean();
                            z2 = dataInputStream.readBoolean();
                            string6 = deserializeString(dataInputStream);
                        } else {
                            string = bundle.getString("android.title");
                            string2 = bundle.getString("android.text");
                            string3 = bundle.getString("smallIcon");
                            string4 = bundle.getString("largeIcon");
                            j = bundle.getLong("fireTime", -1L);
                            j2 = bundle.getLong("repeatInterval", -1L);
                            string5 = bundle.getString("android.bigText");
                            z = bundle.getBoolean("android.showChronometer", false);
                            z2 = bundle.getBoolean("android.showWhen", false);
                            string6 = bundle.getString("data");
                            i = 0;
                        }
                        String str7 = string3;
                        String str8 = string4;
                        long j3 = j;
                        long j4 = j2;
                        String str9 = string5;
                        boolean z3 = z;
                        String str10 = string6;
                        String strDeserializeString = deserializeString(dataInputStream);
                        boolean z4 = dataInputStream.readBoolean();
                        int i3 = z4 ? dataInputStream.readInt() : 0;
                        try {
                            int i4 = dataInputStream.readInt();
                            str3 = "UnityNotifications";
                            try {
                                boolean z5 = dataInputStream.readBoolean();
                                String strDeserializeString2 = deserializeString(dataInputStream);
                                boolean z6 = dataInputStream.readBoolean();
                                int i5 = dataInputStream.readInt();
                                String strDeserializeString3 = deserializeString(dataInputStream);
                                long j5 = z2 ? dataInputStream.readLong() : 0L;
                                Notification.Builder builderCreateNotificationBuilder = UnityNotificationManager.mUnityNotificationManager.createNotificationBuilder(strDeserializeString);
                                if (bundle != null) {
                                    builderCreateNotificationBuilder.setExtras(bundle);
                                } else {
                                    builderCreateNotificationBuilder.getExtras().putInt("id", i);
                                    UnityNotificationManager.setNotificationIcon(builderCreateNotificationBuilder, "smallIcon", str7);
                                    UnityNotificationManager.setNotificationIcon(builderCreateNotificationBuilder, "largeIcon", str8);
                                    if (j3 != -1) {
                                        builderCreateNotificationBuilder.getExtras().putLong("fireTime", j3);
                                    }
                                    if (j4 != -1) {
                                        builderCreateNotificationBuilder.getExtras().putLong("repeatInterval", j4);
                                    }
                                    if (str10 != null) {
                                        builderCreateNotificationBuilder.getExtras().putString("data", str10);
                                    }
                                }
                                if (string != null) {
                                    builderCreateNotificationBuilder.setContentTitle(string);
                                }
                                if (string2 != null) {
                                    builderCreateNotificationBuilder.setContentText(string2);
                                }
                                if (str9 != null) {
                                    builderCreateNotificationBuilder.setStyle(new Notification.BigTextStyle().bigText(str9));
                                }
                                if (z4) {
                                    UnityNotificationManager.setNotificationColor(builderCreateNotificationBuilder, i3);
                                }
                                if (i4 >= 0) {
                                    builderCreateNotificationBuilder.setNumber(i4);
                                }
                                builderCreateNotificationBuilder.setAutoCancel(z5);
                                UnityNotificationManager.setNotificationUsesChronometer(builderCreateNotificationBuilder, z3);
                                if (strDeserializeString2 != null && strDeserializeString2.length() > 0) {
                                    builderCreateNotificationBuilder.setGroup(strDeserializeString2);
                                }
                                builderCreateNotificationBuilder.setGroupSummary(z6);
                                UnityNotificationManager.setNotificationGroupAlertBehavior(builderCreateNotificationBuilder, i5);
                                if (strDeserializeString3 != null && strDeserializeString3.length() > 0) {
                                    builderCreateNotificationBuilder.setSortKey(strDeserializeString3);
                                }
                                if (z2) {
                                    builderCreateNotificationBuilder.setShowWhen(true);
                                    builderCreateNotificationBuilder.setWhen(j5);
                                }
                                return builderCreateNotificationBuilder;
                            } catch (Exception e2) {
                                e = e2;
                            } catch (OutOfMemoryError e3) {
                                e = e3;
                                str4 = str6;
                                str5 = str3;
                                Log.e(str5, str4, e);
                                return null;
                            }
                        } catch (Exception e4) {
                            e = e4;
                            str3 = "UnityNotifications";
                        } catch (OutOfMemoryError e5) {
                            e = e5;
                            str3 = "UnityNotifications";
                            str4 = str6;
                            str5 = str3;
                            Log.e(str5, str4, e);
                            return null;
                        }
                    } catch (OutOfMemoryError e6) {
                        e = e6;
                        str4 = "Failed to deserialize notification";
                        str5 = "UnityNotifications";
                        Log.e(str5, str4, e);
                        return null;
                    }
                } catch (Exception e7) {
                    e = e7;
                    str6 = "Failed to deserialize notification";
                }
                str3 = "UnityNotifications";
                str = str6;
                str2 = str3;
            } catch (OutOfMemoryError e8) {
                e = e8;
                str6 = "Failed to deserialize notification";
            }
        } catch (Exception e9) {
            e = e9;
            str = "Failed to deserialize notification";
            str2 = "UnityNotifications";
        }
        Log.e(str2, str, e);
        return null;
    }

    private static Notification.Builder deserializedFromOldIntent(byte[] bArr) {
        String str;
        String str2;
        String str3;
        String str4;
        try {
            try {
                Parcel parcelObtain = Parcel.obtain();
                try {
                    parcelObtain.unmarshall(bArr, 0, bArr.length);
                    parcelObtain.setDataPosition(0);
                    Bundle bundle = new Bundle();
                    bundle.readFromParcel(parcelObtain);
                    int i = bundle.getInt("id", -1);
                    String string = bundle.getString("channelID");
                    String string2 = bundle.getString("textTitle");
                    String string3 = bundle.getString("textContent");
                    String string4 = bundle.getString("smallIconStr");
                    boolean z = bundle.getBoolean("autoCancel", false);
                    boolean z2 = bundle.getBoolean("usesChronometer", false);
                    long j = bundle.getLong("fireTime", -1L);
                    long j2 = bundle.getLong("repeatInterval", -1L);
                    str = "Failed to deserialize old style notification";
                    try {
                        String string5 = bundle.getString("largeIconStr");
                        str4 = "UnityNotifications";
                        try {
                            int i2 = bundle.getInt("style", -1);
                            int i3 = bundle.getInt("color", 0);
                            int i4 = bundle.getInt("number", 0);
                            String string6 = bundle.getString("data");
                            String string7 = bundle.getString("group");
                            boolean z3 = bundle.getBoolean("groupSummary", false);
                            String string8 = bundle.getString("sortKey");
                            int i5 = bundle.getInt("groupAlertBehaviour", -1);
                            boolean z4 = bundle.getBoolean("showTimestamp", false);
                            Notification.Builder builderCreateNotificationBuilder = UnityNotificationManager.mUnityNotificationManager.createNotificationBuilder(string);
                            builderCreateNotificationBuilder.getExtras().putInt("id", i);
                            builderCreateNotificationBuilder.setContentTitle(string2);
                            builderCreateNotificationBuilder.setContentText(string3);
                            UnityNotificationManager.setNotificationIcon(builderCreateNotificationBuilder, "smallIcon", string4);
                            builderCreateNotificationBuilder.setAutoCancel(z);
                            builderCreateNotificationBuilder.setUsesChronometer(z2);
                            builderCreateNotificationBuilder.getExtras().putLong("fireTime", j);
                            builderCreateNotificationBuilder.getExtras().putLong("repeatInterval", j2);
                            UnityNotificationManager.setNotificationIcon(builderCreateNotificationBuilder, "largeIcon", string5);
                            if (i2 == 2) {
                                builderCreateNotificationBuilder.setStyle(new Notification.BigTextStyle().bigText(string3));
                            }
                            if (i3 != 0) {
                                UnityNotificationManager.setNotificationColor(builderCreateNotificationBuilder, i3);
                            }
                            if (i4 >= 0) {
                                builderCreateNotificationBuilder.setNumber(i4);
                            }
                            if (string6 != null) {
                                builderCreateNotificationBuilder.getExtras().putString("data", string6);
                            }
                            if (string7 != null && string7.length() > 0) {
                                builderCreateNotificationBuilder.setGroup(string7);
                            }
                            builderCreateNotificationBuilder.setGroupSummary(z3);
                            if (string8 != null && string8.length() > 0) {
                                builderCreateNotificationBuilder.setSortKey(string8);
                            }
                            UnityNotificationManager.setNotificationGroupAlertBehavior(builderCreateNotificationBuilder, i5);
                            builderCreateNotificationBuilder.setShowWhen(z4);
                            return builderCreateNotificationBuilder;
                        } catch (Exception e) {
                            e = e;
                            str2 = str;
                            str3 = str4;
                            Log.e(str3, str2, e);
                            return null;
                        } catch (OutOfMemoryError e2) {
                            e = e2;
                            Log.e(str4, str, e);
                            return null;
                        }
                    } catch (Exception e3) {
                        e = e3;
                        str4 = "UnityNotifications";
                        str2 = str;
                        str3 = str4;
                        Log.e(str3, str2, e);
                        return null;
                    } catch (OutOfMemoryError e4) {
                        e = e4;
                        str4 = "UnityNotifications";
                        Log.e(str4, str, e);
                        return null;
                    }
                } catch (Exception e5) {
                    e = e5;
                    str = "Failed to deserialize old style notification";
                }
            } catch (Exception e6) {
                e = e6;
                str2 = "Failed to deserialize old style notification";
                str3 = "UnityNotifications";
            }
        } catch (OutOfMemoryError e7) {
            e = e7;
            str = "Failed to deserialize old style notification";
        }
    }

    private static String deserializeString(DataInputStream dataInputStream) throws IOException {
        int i = dataInputStream.readInt();
        if (i <= 0) {
            return null;
        }
        byte[] bArr = new byte[i];
        if (dataInputStream.read(bArr) != i) {
            throw new IOException("Insufficient amount of bytes read");
        }
        return new String(bArr, StandardCharsets.UTF_8);
    }

    private static <T extends Parcelable> T deserializeParcelable(DataInputStream dataInputStream) throws IOException {
        int i = dataInputStream.readInt();
        if (i <= 0) {
            return null;
        }
        byte[] bArr = new byte[i];
        if (dataInputStream.read(bArr) != i) {
            throw new IOException("Insufficient amount of bytes read");
        }
        try {
            Parcel parcelObtain = Parcel.obtain();
            parcelObtain.unmarshall(bArr, 0, i);
            parcelObtain.setDataPosition(0);
            Bundle bundle = (Bundle) parcelObtain.readParcelable(UnityNotificationUtilities.class.getClassLoader());
            parcelObtain.recycle();
            if (bundle != null) {
                return (T) bundle.getParcelable("obj");
            }
        } catch (Exception e) {
            Log.e("UnityNotifications", "Failed to deserialize parcelable", e);
        } catch (OutOfMemoryError e2) {
            Log.e("UnityNotifications", "Failed to deserialize parcelable", e2);
        }
        return null;
    }

    protected static Class<?> getOpenAppActivity(Context context, boolean z) {
        ApplicationInfo applicationInfo;
        Class<?> cls = null;
        try {
            applicationInfo = context.getPackageManager().getApplicationInfo(context.getPackageName(), 128);
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
            applicationInfo = null;
        }
        Bundle bundle = applicationInfo.metaData;
        if (bundle.containsKey("custom_notification_android_activity")) {
            try {
                cls = Class.forName(bundle.getString("custom_notification_android_activity"));
            } catch (ClassNotFoundException unused) {
            }
        }
        if (cls == null && z) {
            Log.w("UnityNotifications", "No custom_notification_android_activity found, attempting to find app activity class");
            try {
                return Class.forName("com.unity3d.player.UnityPlayerActivity");
            } catch (ClassNotFoundException unused2) {
                Log.w("UnityNotifications", String.format("Attempting to find : %s, failed!", "com.unity3d.player.UnityPlayerActivity"));
                String str = String.format("%s.UnityPlayerActivity", context.getPackageName());
                try {
                    return Class.forName(str);
                } catch (ClassNotFoundException unused3) {
                    Log.w("UnityNotifications", String.format("Attempting to find class based on package name: %s, failed!", str));
                }
            }
        }
        return cls;
    }

    protected static Notification.Builder recoverBuilder(Context context, Notification notification) {
        if (Build.VERSION.SDK_INT >= 24) {
            Notification.Builder builderRecoverBuilder = Notification.Builder.recoverBuilder(context, notification);
            builderRecoverBuilder.setExtras(notification.extras);
            return builderRecoverBuilder;
        }
        return recoverBuilderPreNougat(context, notification);
    }

    private static Notification.Builder recoverBuilderPreNougat(Context context, Notification notification) {
        Notification.Builder builderCreateNotificationBuilder = UnityNotificationManager.createNotificationBuilder(context, notification.extras.getString("channelID"));
        UnityNotificationManager.setNotificationIcon(builderCreateNotificationBuilder, "smallIcon", notification.extras.getString("smallIcon"));
        String string = notification.extras.getString("largeIcon");
        if (string != null && !string.isEmpty()) {
            UnityNotificationManager.setNotificationIcon(builderCreateNotificationBuilder, "largeIcon", string);
        }
        builderCreateNotificationBuilder.setContentTitle(notification.extras.getString("android.title"));
        builderCreateNotificationBuilder.setContentText(notification.extras.getString("android.text"));
        builderCreateNotificationBuilder.setAutoCancel((notification.flags & 16) != 0);
        if (notification.number >= 0) {
            builderCreateNotificationBuilder.setNumber(notification.number);
        }
        String string2 = notification.extras.getString("android.bigText");
        if (string2 != null) {
            builderCreateNotificationBuilder.setStyle(new Notification.BigTextStyle().bigText(string2));
        }
        builderCreateNotificationBuilder.setWhen(notification.when);
        String group = notification.getGroup();
        if (group != null && !group.isEmpty()) {
            builderCreateNotificationBuilder.setGroup(group);
        }
        builderCreateNotificationBuilder.setGroupSummary((notification.flags & 512) != 0);
        String sortKey = notification.getSortKey();
        if (sortKey != null && !sortKey.isEmpty()) {
            builderCreateNotificationBuilder.setSortKey(sortKey);
        }
        builderCreateNotificationBuilder.setShowWhen(notification.extras.getBoolean("android.showWhen", false));
        Integer notificationColor = UnityNotificationManager.getNotificationColor(notification);
        if (notificationColor != null) {
            UnityNotificationManager.setNotificationColor(builderCreateNotificationBuilder, notificationColor.intValue());
        }
        UnityNotificationManager.setNotificationUsesChronometer(builderCreateNotificationBuilder, notification.extras.getBoolean("android.showChronometer", false));
        UnityNotificationManager.setNotificationGroupAlertBehavior(builderCreateNotificationBuilder, UnityNotificationManager.getNotificationGroupAlertBehavior(notification));
        builderCreateNotificationBuilder.getExtras().putInt("id", notification.extras.getInt("id", 0));
        builderCreateNotificationBuilder.getExtras().putLong("repeatInterval", notification.extras.getLong("repeatInterval", 0L));
        builderCreateNotificationBuilder.getExtras().putLong("fireTime", notification.extras.getLong("fireTime", 0L));
        String string3 = notification.extras.getString("data");
        if (string3 != null && !string3.isEmpty()) {
            builderCreateNotificationBuilder.getExtras().putString("data", string3);
        }
        return builderCreateNotificationBuilder;
    }
}
