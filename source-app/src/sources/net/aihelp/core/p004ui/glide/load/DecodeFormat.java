package net.aihelp.core.p004ui.glide.load;

public enum DecodeFormat {
    ALWAYS_ARGB_8888,
    PREFER_ARGB_8888,
    PREFER_RGB_565;

    public static final DecodeFormat DEFAULT = PREFER_RGB_565;
}
