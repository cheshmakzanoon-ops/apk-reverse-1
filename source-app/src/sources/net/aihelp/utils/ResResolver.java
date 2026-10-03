package net.aihelp.utils;

import android.content.Context;
import android.text.TextUtils;
import net.aihelp.BuildConfig;
import net.aihelp.config.AIHelpContext;
import net.aihelp.data.localize.data.LocaleStringHelper;

public final class ResResolver {
    private static String removeOneSuffix(String str) {
        int iLastIndexOf;
        if (str == null || (iLastIndexOf = str.lastIndexOf(46)) == -1) {
            return null;
        }
        return str.substring(0, iLastIndexOf);
    }

    private static Class<?> loadClazz(String str, String str2) throws ClassNotFoundException {
        return AIHelpContext.getInstance().getContext().getClassLoader().loadClass(str + ".R$" + str2);
    }

    private static Class<?> getCorrectResourceClass(String str) throws ClassNotFoundException {
        try {
            return loadClazz(BuildConfig.LIBRARY_PACKAGE_NAME, str);
        } catch (ClassNotFoundException unused) {
            String packageName = AIHelpContext.getInstance().getContext().getPackageName();
            try {
                return loadClazz(packageName, str);
            } catch (ClassNotFoundException e) {
                Class<?> clsLoadClazz = null;
                while (clsLoadClazz == null) {
                    packageName = removeOneSuffix(packageName);
                    if (packageName == null) {
                        throw e;
                    }
                    try {
                        clsLoadClazz = loadClazz(packageName, str);
                    } catch (ClassNotFoundException unused2) {
                    }
                }
                return clsLoadClazz;
            }
        }
    }

    public static int[] getStyleable(String str) {
        try {
            return (int[]) getCorrectResourceClass("styleable").getField(str).get(null);
        } catch (Throwable unused) {
            return null;
        }
    }

    public static int getStyleableFieldIndex(String str, String str2) {
        try {
            return getCorrectResourceClass("styleable").getField(str + "_" + str2).getInt(null);
        } catch (Throwable unused) {
            return 0;
        }
    }

    public static int getViewId(String str) {
        return getIdentifier(str, "id");
    }

    public static int getLayoutId(String str) {
        return getIdentifier(str, "layout");
    }

    public static int getAnimId(String str) {
        return getIdentifier(str, "anim");
    }

    public static int getColorId(String str) {
        return getIdentifier(str, "color");
    }

    public static int getStringId(String str) {
        return getIdentifier(str, "string");
    }

    public static String getString(String str) {
        String string = LocaleStringHelper.INSTANCE.getString(str);
        if (!TextUtils.isEmpty(string)) {
            return string;
        }
        Context context = AIHelpContext.getInstance().getContext();
        int stringId = getStringId(str);
        if (stringId == 0) {
            return "";
        }
        return context.getResources().getString(stringId);
    }

    public static int getStyleId(String str) {
        return getIdentifier(str, "style");
    }

    public static int getAttrId(String str) {
        return getIdentifier(str, "attr");
    }

    public static int getDrawableId(String str) {
        return getIdentifier(str, "drawable");
    }

    public static int getIdentifier(String str, String str2) {
        Context context = AIHelpContext.getInstance().getContext();
        int identifier = context.getResources().getIdentifier(str, str2, context.getPackageName());
        if (identifier != 0) {
            return identifier;
        }
        try {
            return getCorrectResourceClass(str2).getField(str).getInt(null);
        } catch (Exception unused) {
            return 0;
        }
    }
}
