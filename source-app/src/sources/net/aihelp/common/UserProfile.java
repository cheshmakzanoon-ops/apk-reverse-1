package net.aihelp.common;

import android.content.Context;
import net.aihelp.utils.DeviceUuidFactory;

public class UserProfile {
    public static String CUSTOM_DATA = "{\"elva-custom-metadata\":{}}";
    public static String ENTRANCE_TAGS = "";
    public static int PUSH_PLATFORM = 0;
    public static String PUSH_TOKEN = "";
    public static String SERVER_ID = "";
    public static String USER_ID = "";
    public static String USER_NAME = "";

    public static void resetUserProfile(Context context) {
        USER_ID = DeviceUuidFactory.m137id(context);
        USER_NAME = "anonymous";
        SERVER_ID = "-1";
        CUSTOM_DATA = "{\"elva-custom-metadata\":{}}";
        PUSH_TOKEN = "";
        PUSH_PLATFORM = 0;
        ENTRANCE_TAGS = "";
    }
}
