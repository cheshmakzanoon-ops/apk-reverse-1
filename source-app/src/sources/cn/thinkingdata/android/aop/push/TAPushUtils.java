package cn.thinkingdata.android.aop.push;

public class TAPushUtils {
    public static String getJPushSource(int i) {
        if (i == 1) {
            return "Xiaomi";
        }
        if (i == 2) {
            return "HUAWEI";
        }
        if (i == 3) {
            return "Meizu";
        }
        if (i == 4) {
            return "OPPO";
        }
        if (i != 5) {
            return null;
        }
        return "vivo";
    }
}
