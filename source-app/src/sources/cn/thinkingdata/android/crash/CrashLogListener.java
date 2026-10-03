package cn.thinkingdata.android.crash;

import java.io.File;

public interface CrashLogListener {
    void onFile(File file);
}
