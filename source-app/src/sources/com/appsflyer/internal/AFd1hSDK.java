package com.appsflyer.internal;

import android.content.Context;
import android.util.Base64;
import com.appsflyer.AFLogger;
import java.io.File;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import kotlin.ExceptionsKt;
import kotlin.Unit;
import kotlin.collections.ArraysKt;
import kotlin.collections.CollectionsKt;
import kotlin.collections.SetsKt;
import kotlin.io.FilesKt;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.Charsets;

public final class AFd1hSDK implements AFd1gSDK {
    private final AFd1lSDK AFInAppEventType;

    public AFd1hSDK(AFd1lSDK aFd1lSDK) {
        Intrinsics.checkNotNullParameter(aFd1lSDK, "");
        this.AFInAppEventType = aFd1lSDK;
    }

    private final File AFKeystoreWrapper() {
        Context context = this.AFInAppEventType.AFInAppEventParameterName;
        if (context == null) {
            return null;
        }
        File file = new File(context.getFilesDir(), "AFExceptionsCache");
        if (!file.exists()) {
            file.mkdirs();
        }
        return file;
    }

    @Override
    public final String values(Throwable th, String str) {
        String str2;
        File file;
        Intrinsics.checkNotNullParameter(th, "");
        Intrinsics.checkNotNullParameter(str, "");
        synchronized (this) {
            File fileAFKeystoreWrapper = AFKeystoreWrapper();
            str2 = null;
            if (fileAFKeystoreWrapper != null) {
                file = new File(fileAFKeystoreWrapper, "6.13.0");
                if (!file.exists()) {
                    file.mkdirs();
                }
            } else {
                file = null;
            }
            if (file != null) {
                try {
                    Intrinsics.checkNotNullParameter(th, "");
                    Intrinsics.checkNotNullParameter(str, "");
                    StringBuilder sb = new StringBuilder();
                    Intrinsics.checkNotNullParameter(th, "");
                    String name = th.getClass().getName();
                    Intrinsics.checkNotNullExpressionValue(name, "");
                    sb.append(name);
                    sb.append(": ");
                    sb.append(str);
                    String string = sb.toString();
                    Intrinsics.checkNotNullParameter(th, "");
                    Intrinsics.checkNotNullParameter(th, "");
                    StringBuilder sb2 = new StringBuilder();
                    sb2.append(th);
                    sb2.append('\n');
                    sb2.append(CollectionsKt.joinToString$default(AFd1aSDK.values(th), "\n", (CharSequence) null, (CharSequence) null, 0, (CharSequence) null, AFd1aSDK.C08413.AFKeystoreWrapper, 30, (Object) null));
                    String string2 = sb2.toString();
                    Intrinsics.checkNotNullParameter(string2, "");
                    AFd1oSDK aFd1oSDK = new AFd1oSDK(string, AFe1wSDK.values(string2, "SHA-256"), ExceptionsKt.stackTraceToString(th), 0, 8, null);
                    String str3 = aFd1oSDK.AFInAppEventType;
                    File file2 = new File(file, str3);
                    if (file2.exists()) {
                        AFd1oSDK.Companion companion = AFd1oSDK.INSTANCE;
                        AFd1oSDK aFd1oSDKAFKeystoreWrapper = AFd1oSDK.Companion.AFKeystoreWrapper(FilesKt.readText$default(file2, (Charset) null, 1, (Object) null));
                        if (aFd1oSDKAFKeystoreWrapper != null) {
                            aFd1oSDKAFKeystoreWrapper.values++;
                            aFd1oSDK = aFd1oSDKAFKeystoreWrapper;
                        }
                    }
                    StringBuilder sb3 = new StringBuilder("label=");
                    String str4 = aFd1oSDK.valueOf;
                    Intrinsics.checkNotNullParameter(str4, "");
                    byte[] bytes = str4.getBytes(Charsets.UTF_8);
                    Intrinsics.checkNotNullExpressionValue(bytes, "");
                    sb3.append(Base64.encodeToString(bytes, 2));
                    sb3.append("\nhashName=");
                    String str5 = aFd1oSDK.AFInAppEventType;
                    Intrinsics.checkNotNullParameter(str5, "");
                    byte[] bytes2 = str5.getBytes(Charsets.UTF_8);
                    Intrinsics.checkNotNullExpressionValue(bytes2, "");
                    sb3.append(Base64.encodeToString(bytes2, 2));
                    sb3.append("\nstackTrace=");
                    String str6 = aFd1oSDK.AFInAppEventParameterName;
                    Intrinsics.checkNotNullParameter(str6, "");
                    byte[] bytes3 = str6.getBytes(Charsets.UTF_8);
                    Intrinsics.checkNotNullExpressionValue(bytes3, "");
                    sb3.append(Base64.encodeToString(bytes3, 2));
                    sb3.append("\nc=");
                    sb3.append(aFd1oSDK.values);
                    FilesKt.writeText$default(file2, sb3.toString(), (Charset) null, 2, (Object) null);
                    str2 = str3;
                } catch (Exception e) {
                    AFLogger aFLogger = AFLogger.INSTANCE;
                    AFg1hSDK aFg1hSDK = AFg1hSDK.EXCEPTION_MANAGER;
                    StringBuilder sb4 = new StringBuilder("Could not cache exception\n ");
                    sb4.append(e.getMessage());
                    AFg1mSDK.v$default(aFLogger, aFg1hSDK, sb4.toString(), false, 4, null);
                }
            }
        }
        return str2;
    }

    @Override
    public final List<AFd1oSDK> AFInAppEventParameterName() {
        List<AFd1oSDK> listEmptyList;
        File[] fileArrListFiles;
        ArrayList arrayList;
        synchronized (this) {
            File fileAFKeystoreWrapper = AFKeystoreWrapper();
            listEmptyList = null;
            if (fileAFKeystoreWrapper != null && (fileArrListFiles = fileAFKeystoreWrapper.listFiles()) != null) {
                ArrayList arrayList2 = new ArrayList();
                for (File file : fileArrListFiles) {
                    try {
                        File[] fileArrListFiles2 = file.listFiles();
                        if (fileArrListFiles2 != null) {
                            Intrinsics.checkNotNullExpressionValue(fileArrListFiles2, "");
                            ArrayList arrayList3 = new ArrayList();
                            for (File file2 : fileArrListFiles2) {
                                AFd1oSDK.Companion companion = AFd1oSDK.INSTANCE;
                                Intrinsics.checkNotNullExpressionValue(file2, "");
                                AFd1oSDK aFd1oSDKAFKeystoreWrapper = AFd1oSDK.Companion.AFKeystoreWrapper(FilesKt.readText$default(file2, (Charset) null, 1, (Object) null));
                                if (aFd1oSDKAFKeystoreWrapper != null) {
                                    arrayList3.add(aFd1oSDKAFKeystoreWrapper);
                                }
                            }
                            arrayList = arrayList3;
                        } else {
                            arrayList = null;
                        }
                    } catch (Throwable th) {
                        AFLogger aFLogger = AFLogger.INSTANCE;
                        AFg1hSDK aFg1hSDK = AFg1hSDK.EXCEPTION_MANAGER;
                        StringBuilder sb = new StringBuilder("Could not get stored exceptions\n ");
                        sb.append(th.getMessage());
                        AFg1mSDK.v$default(aFLogger, aFg1hSDK, sb.toString(), false, 4, null);
                    }
                    if (arrayList != null) {
                        arrayList2.add(arrayList);
                    }
                }
                listEmptyList = CollectionsKt.flatten(arrayList2);
                if (listEmptyList == null) {
                    listEmptyList = CollectionsKt.emptyList();
                }
            } else if (listEmptyList == null) {
                listEmptyList = CollectionsKt.emptyList();
            }
            throw th;
        }
        return listEmptyList;
    }

    @Override
    public final int valueOf() {
        Iterator<T> it = AFInAppEventParameterName().iterator();
        int i = 0;
        while (it.hasNext()) {
            i += ((AFd1oSDK) it.next()).values;
        }
        return i;
    }

    @Override
    public final boolean AFInAppEventType() {
        return values(new String[0]);
    }

    @Override
    public final boolean values(String... strArr) {
        boolean zDeleteRecursively;
        Intrinsics.checkNotNullParameter(strArr, "");
        synchronized (this) {
            File fileAFKeystoreWrapper = AFKeystoreWrapper();
            zDeleteRecursively = true;
            if (fileAFKeystoreWrapper != null) {
                if (strArr.length == 0) {
                    AFg1mSDK.v$default(AFLogger.INSTANCE, AFg1hSDK.EXCEPTION_MANAGER, "delete all exceptions", false, 4, null);
                    zDeleteRecursively = FilesKt.deleteRecursively(fileAFKeystoreWrapper);
                } else {
                    AFLogger aFLogger = AFLogger.INSTANCE;
                    AFg1hSDK aFg1hSDK = AFg1hSDK.EXCEPTION_MANAGER;
                    StringBuilder sb = new StringBuilder("delete all exceptions except for: ");
                    sb.append(ArraysKt.joinToString$default(strArr, ", ", (CharSequence) null, (CharSequence) null, 0, (CharSequence) null, (Function1) null, 62, (Object) null));
                    AFg1mSDK.v$default(aFLogger, aFg1hSDK, sb.toString(), false, 4, null);
                    File[] fileArrListFiles = fileAFKeystoreWrapper.listFiles();
                    if (fileArrListFiles != null) {
                        Intrinsics.checkNotNullExpressionValue(fileArrListFiles, "");
                        ArrayList arrayList = new ArrayList();
                        for (File file : fileArrListFiles) {
                            if (!ArraysKt.contains(strArr, file.getName())) {
                                arrayList.add(file);
                            }
                        }
                        ArrayList<File> arrayList2 = arrayList;
                        ArrayList arrayList3 = new ArrayList(CollectionsKt.collectionSizeOrDefault(arrayList2, 10));
                        for (File file2 : arrayList2) {
                            Intrinsics.checkNotNullExpressionValue(file2, "");
                            arrayList3.add(Boolean.valueOf(FilesKt.deleteRecursively(file2)));
                        }
                        Set set = CollectionsKt.toSet(arrayList3);
                        if (set.isEmpty()) {
                            set = SetsKt.setOf(Boolean.TRUE);
                        }
                        Set set2 = set;
                        if (set2.size() != 1 || !((Boolean) CollectionsKt.first(set2)).booleanValue()) {
                            zDeleteRecursively = false;
                        }
                    }
                }
            }
        }
        return zDeleteRecursively;
    }

    @Override
    public final void valueOf(int i, int i2) {
        File[] fileArrListFiles;
        synchronized (this) {
            File fileAFKeystoreWrapper = AFKeystoreWrapper();
            if (fileAFKeystoreWrapper != null && (fileArrListFiles = fileAFKeystoreWrapper.listFiles()) != null) {
                Intrinsics.checkNotNullExpressionValue(fileArrListFiles, "");
                ArrayList arrayList = new ArrayList();
                for (File file : fileArrListFiles) {
                    String name = file.getName();
                    Intrinsics.checkNotNullExpressionValue(name, "");
                    int iAFInAppEventParameterName = AFc1uSDK.AFInAppEventParameterName(name);
                    if (i > iAFInAppEventParameterName || iAFInAppEventParameterName > i2) {
                        arrayList.add(file);
                    }
                }
                ArrayList<File> arrayList2 = arrayList;
                ArrayList arrayList3 = new ArrayList(CollectionsKt.collectionSizeOrDefault(arrayList2, 10));
                for (File file2 : arrayList2) {
                    Intrinsics.checkNotNullExpressionValue(file2, "");
                    arrayList3.add(Boolean.valueOf(FilesKt.deleteRecursively(file2)));
                }
            }
            Unit unit = Unit.INSTANCE;
        }
    }
}
