package com.example.updateandinstall;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.util.Log;
import android.widget.ProgressBar;
import android.widget.Toast;
import androidx.core.app.ActivityCompat;
import com.facebook.internal.ServerProtocol;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import org.json.JSONException;
import org.json.JSONObject;

public class UpdateManager {
    private static final int DOWNLOAD = 1;
    public static final int DOWNLOAD_APK_CODE = 190;
    private static final int DOWNLOAD_FINISH = 2;
    private static volatile UpdateManager Instance;
    public String bufferStr;
    private String downLoadURL;
    private String localName;
    private String mChannel;
    private Context mContext;
    private Dialog mDownloadDialog;
    HashMap<String, String> mHashMap;
    private ProgressBar mProgress;
    private String mSavePath;
    private int progress;
    private boolean cancelUpdate = false;
    private Handler mHandler = new Handler() {
        @Override
        public void handleMessage(Message message) {
            if (message.what != 2) {
                return;
            }
            UpdateManager.this.installApk();
        }
    };

    public void InitContext(Context context, String str) {
        this.mChannel = str;
        this.mContext = context;
    }

    public static UpdateManager getInstance() {
        UpdateManager updateManager = Instance;
        if (updateManager == null) {
            synchronized (UpdateManager.class) {
                updateManager = Instance;
                if (updateManager == null) {
                    updateManager = new UpdateManager();
                    Instance = updateManager;
                }
            }
        }
        return updateManager;
    }

    public String GetPackageName() {
        try {
            return this.mContext.getPackageName();
        } catch (Throwable unused) {
            return "";
        }
    }

    public void CheckCnApkDownload(int i) {
        if (GetPackageName().equals("com.readygo.aps.gp")) {
            String string = SpUtils.getInstance(this.mContext).getString("curversion", "");
            if (i == 0 && string.equals(GetVersionName())) {
                return;
            }
            checkUpdate();
        }
    }

    public void checkUpdate() {
        Log.d(">>>> lsz checkupdate: ", ">>>> lsz checkupdate: ");
        execPHP(String.format("%s?ch=%s", "http://upload-img-aps.readygo.tech/get_apk_ver.php", this.mChannel));
    }

    public void execPHP(final String str) {
        new Thread(new Runnable() {
            @Override
            public void run() throws Throwable {
                Throwable th;
                HttpURLConnection httpURLConnection;
                IOException e;
                HttpURLConnection httpURLConnection2 = null;
                try {
                    try {
                        httpURLConnection = (HttpURLConnection) new URL(str).openConnection();
                        try {
                            httpURLConnection.connect();
                            if (httpURLConnection.getResponseCode() == 200) {
                                BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(httpURLConnection.getInputStream()));
                                StringBuffer stringBuffer = new StringBuffer();
                                while (true) {
                                    String line = bufferedReader.readLine();
                                    if (line == null) {
                                        break;
                                    } else {
                                        stringBuffer.append(line);
                                    }
                                }
                                UpdateManager.this.bufferStr = stringBuffer.toString();
                                if (UpdateManager.this.isUpdate()) {
                                    UpdateManager.this.showNoticeDialog();
                                }
                            }
                            if (httpURLConnection == null) {
                                return;
                            }
                        } catch (IOException e2) {
                            e = e2;
                            e.printStackTrace();
                            if (httpURLConnection == null) {
                                return;
                            }
                        }
                    } catch (Throwable th2) {
                        th = th2;
                        if (0 != 0) {
                            httpURLConnection2.disconnect();
                        }
                        throw th;
                    }
                } catch (IOException e3) {
                    httpURLConnection = null;
                    e = e3;
                } catch (Throwable th3) {
                    th = th3;
                    if (0 != 0) {
                        httpURLConnection2.disconnect();
                    }
                    throw th;
                }
                httpURLConnection.disconnect();
            }
        }).start();
    }

    private int GetVersionCode() {
        try {
            try {
                PackageInfo packageInfo = this.mContext.getPackageManager().getPackageInfo(this.mContext.getPackageName(), 16384);
                if (packageInfo != null) {
                    return packageInfo.versionCode;
                }
                return 0;
            } catch (PackageManager.NameNotFoundException e) {
                e.printStackTrace();
                return 0;
            }
        } catch (Throwable unused) {
        }
        return 0;
    }

    private String GetVersionName() {
        try {
            try {
                PackageInfo packageInfo = this.mContext.getPackageManager().getPackageInfo(this.mContext.getPackageName(), 16384);
                if (packageInfo == null) {
                    return "";
                }
                return packageInfo.versionName;
            } catch (PackageManager.NameNotFoundException e) {
                e.printStackTrace();
                return "";
            }
        } catch (Throwable unused) {
        }
        return "";
    }

    public boolean isUpdate() {
        int iGetVersionCode = GetVersionCode();
        Integer numValueOf = Integer.valueOf(iGetVersionCode);
        try {
            String str = this.bufferStr;
            if (str != null && str != "") {
                JSONObject jSONObject = new JSONObject(new JSONObject(this.bufferStr).getString("update"));
                String string = jSONObject.getString(ServerProtocol.FALLBACK_DIALOG_PARAM_VERSION);
                Integer.valueOf(0);
                try {
                    int i = Integer.parseInt(string);
                    Integer numValueOf2 = Integer.valueOf(i);
                    this.localName = jSONObject.getString("name");
                    this.downLoadURL = jSONObject.getString("url");
                    numValueOf.getClass();
                    numValueOf2.getClass();
                    if (iGetVersionCode < i) {
                        return true;
                    }
                } catch (NumberFormatException unused) {
                    return false;
                }
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void showNoticeDialog() {
        showDownloadDialog();
    }

    private void showDownloadDialog() {
        ((Activity) this.mContext).runOnUiThread(new Runnable() {
            @Override
            public void run() {
                AlertDialog.Builder builder = new AlertDialog.Builder(UpdateManager.this.mContext);
                builder.setTitle("New version detected.");
                builder.setMessage("Download the latest version?");
                builder.setPositiveButton("Download", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        Toast.makeText(UpdateManager.this.mContext, "Starts downloading the game. You may view the progress in the status bar.", 1).show();
                        UpdateManager.this.downloadApk();
                    }
                });
                builder.create().show();
            }
        });
    }

    public void downloadApk() {
        if (this.mContext.checkSelfPermission("android.permission.WRITE_EXTERNAL_STORAGE") != 0) {
            ActivityCompat.requestPermissions((Activity) this.mContext, new String[]{"android.permission.WRITE_EXTERNAL_STORAGE"}, 190);
        } else if (canDownloadState()) {
            new Thread(new Runnable() {
                @Override
                public void run() {
                    try {
                        Log.d("download->", "download-> to downloadApk 2");
                        ApkUpdateUtils.download(UpdateManager.this.mContext, UpdateManager.this.downLoadURL, "City On Mars");
                    } catch (Exception unused) {
                        new downloadApkThread().run();
                    }
                }
            }).start();
        } else {
            new downloadApkThread().start();
        }
    }

    private class downloadApkThread extends Thread {
        private downloadApkThread() {
        }

        @Override
        public void run() {
            try {
                if (TextUtils.isEmpty(UpdateManager.this.downLoadURL)) {
                    return;
                }
                if (Environment.getExternalStorageState().equals("mounted")) {
                    String str = Environment.getExternalStorageDirectory() + "/";
                    UpdateManager.this.mSavePath = str + "download";
                    HttpURLConnection httpURLConnection = (HttpURLConnection) new URL(UpdateManager.this.downLoadURL).openConnection();
                    httpURLConnection.connect();
                    int contentLength = httpURLConnection.getContentLength();
                    InputStream inputStream = httpURLConnection.getInputStream();
                    File file = new File(UpdateManager.this.mSavePath);
                    if (!file.exists()) {
                        file.mkdir();
                    }
                    File file2 = new File(UpdateManager.this.mSavePath, UpdateManager.this.localName);
                    FileOutputStream fileOutputStream = new FileOutputStream(file2);
                    byte[] bArr = new byte[1024];
                    int i = 0;
                    do {
                        int i2 = inputStream.read(bArr);
                        i += i2;
                        UpdateManager.this.progress = (int) ((i / contentLength) * 100.0f);
                        UpdateManager.this.mHandler.sendEmptyMessage(1);
                        if (i2 <= 0) {
                            PackageManager packageManager = UpdateManager.this.mContext.getPackageManager();
                            PackageInfo packageArchiveInfo = packageManager.getPackageArchiveInfo(file2.getPath(), 64);
                            if (packageArchiveInfo != null && packageArchiveInfo.signatures != null && packageArchiveInfo.signatures.length > 0) {
                                String charsString = packageArchiveInfo.signatures[0].toCharsString();
                                try {
                                    PackageInfo packageInfo = packageManager.getPackageInfo(UpdateManager.this.mContext.getPackageName(), 64);
                                    if (packageInfo == null || packageInfo.signatures == null || packageInfo.signatures.length <= 0 || !charsString.equals(packageInfo.signatures[0].toCharsString())) {
                                        break;
                                        break;
                                        break;
                                        break;
                                    }
                                    UpdateManager.this.mHandler.sendEmptyMessage(2);
                                    break;
                                } catch (PackageManager.NameNotFoundException unused) {
                                    break;
                                }
                            }
                            break;
                            break;
                            break;
                        }
                        fileOutputStream.write(bArr, 0, i2);
                    } while (!UpdateManager.this.cancelUpdate);
                    fileOutputStream.close();
                    inputStream.close();
                }
            } catch (MalformedURLException e) {
                e.printStackTrace();
            } catch (IOException e2) {
                e2.printStackTrace();
            } catch (Exception e3) {
                e3.printStackTrace();
            }
            if (UpdateManager.this.mDownloadDialog != null) {
                UpdateManager.this.mDownloadDialog.dismiss();
            }
        }
    }

    public void installApk() {
        File file = new File(this.mSavePath, this.localName);
        if (file.exists()) {
            Intent intent = new Intent("android.intent.action.VIEW");
            intent.setDataAndType(Uri.parse("file://" + file.toString()), "application/vnd.android.package-archive");
            this.mContext.startActivity(intent);
        }
    }

    private boolean canDownloadState() {
        try {
            int applicationEnabledSetting = this.mContext.getPackageManager().getApplicationEnabledSetting("com.android.providers.downloads");
            return (applicationEnabledSetting == 2 || applicationEnabledSetting == 3 || applicationEnabledSetting == 4) ? false : true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
