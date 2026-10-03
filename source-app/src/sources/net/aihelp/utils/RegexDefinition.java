package net.aihelp.utils;

import android.text.TextUtils;
import java.util.regex.Pattern;

public class RegexDefinition {
    public static final String AIHELP_SUPPORTED_IMAGE = "(?i).+\\.(png|jpg|jpeg|gif|heic|bmp)$";
    public static final String AIHELP_SUPPORTED_VIDEO = "(?i).+\\.(mp4|avi|3gp|mov|mpeg|mpg|m4v|webm|mkv|rmvb|mov|wmv|flv)$";
    public static final String ANDROID_SUPPORTED_IMAGE = "(?i).+\\.(png|jpg|jpeg|gif)$";
    public static final String ANDROID_SUPPORTED_IMAGE_SUFFIX = "(?i)(png|jpg|jpeg|gif)";
    public static final String ANDROID_SUPPORTED_VIDEO = "(?i).+\\.(mp4|3gp|mkv|webm)$";
    public static final String ANDROID_SUPPORTED_VIDEO_SUFFIX = "(?i)(mp4|3gp|mkv|webm)";
    public static final String REGEX_IMAGE = "(?i)(http:|https:)(//)((?!\").)*?\\.(png|jpg|jpeg|gif)";
    public static final String REGEX_RICH_TEXT = "(?i)(https?://\\S*?((?=\\s+http)|\\.(png|jpg|jpeg|gif|mp4|3gp|mkv|webm))|https?://((?!\").)*)";
    public static final String REGEX_VIDEO = "(?i)(http:|https:)(//)((?!\").)*?\\.(mp4|3gp|mkv|webm)";

    public static boolean isVideoFile(String str) {
        if (TextUtils.isEmpty(str)) {
            return false;
        }
        return Pattern.compile(ANDROID_SUPPORTED_VIDEO).matcher(str).matches();
    }

    public static boolean isGifFile(String str) {
        if (TextUtils.isEmpty(str)) {
            return false;
        }
        return str.endsWith("gif") || str.endsWith("GIF");
    }

    public static boolean isLocalMediaFile(String str) {
        if (TextUtils.isEmpty(str)) {
            return false;
        }
        boolean zStartsWith = str.startsWith("/");
        boolean zMatches = Pattern.compile(ANDROID_SUPPORTED_IMAGE).matcher(str).matches();
        boolean zMatches2 = Pattern.compile(ANDROID_SUPPORTED_VIDEO).matcher(str).matches();
        if (zStartsWith) {
            return zMatches || zMatches2;
        }
        return false;
    }

    public static boolean isLocalFile(String str) {
        if (TextUtils.isEmpty(str)) {
            return false;
        }
        return str.startsWith("/");
    }
}
