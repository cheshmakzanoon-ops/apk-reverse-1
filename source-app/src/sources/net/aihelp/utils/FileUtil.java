package net.aihelp.utils;

import android.content.Context;
import android.net.Uri;
import android.os.ParcelFileDescriptor;
import java.io.Closeable;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.RandomAccessFile;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import net.aihelp.config.AIHelpContext;

public class FileUtil {
    private static final HashSet<String> imageMimeTypes = new HashSet<>(Arrays.asList("image/jpeg", "image/png", "image/gif", "image/x-png", "image/x-citrix-pjpeg", "image/x-citrix-gif", "image/pjpeg"));
    private static final Set<String> resizableImageMimeTypes = new HashSet(Arrays.asList("image/jpeg", "image/png", "image/x-png", "image/x-citrix-pjpeg", "image/pjpeg"));

    public static boolean isSupportedMimeType(String str) {
        return imageMimeTypes.contains(str);
    }

    public static void saveFile(URL url, File file) throws Throwable {
        FileOutputStream fileOutputStream;
        InputStream inputStream = null;
        try {
            InputStream inputStreamOpenStream = url.openStream();
            try {
                fileOutputStream = new FileOutputStream(file);
                try {
                    byte[] bArr = new byte[500];
                    while (true) {
                        int i = inputStreamOpenStream.read(bArr, 0, 500);
                        if (i < 0) {
                            break;
                        } else {
                            fileOutputStream.write(bArr, 0, i);
                        }
                    }
                    closeQuietly(inputStreamOpenStream);
                } catch (Exception e) {
                    e = e;
                    inputStream = inputStreamOpenStream;
                    try {
                        e.printStackTrace();
                        closeQuietly(inputStream);
                    } catch (Throwable th) {
                        th = th;
                        closeQuietly(inputStream);
                        closeQuietly(fileOutputStream);
                        throw th;
                    }
                } catch (Throwable th2) {
                    th = th2;
                    inputStream = inputStreamOpenStream;
                    closeQuietly(inputStream);
                    closeQuietly(fileOutputStream);
                    throw th;
                }
            } catch (Exception e2) {
                e = e2;
                fileOutputStream = null;
            } catch (Throwable th3) {
                th = th3;
                fileOutputStream = null;
            }
        } catch (Exception e3) {
            e = e3;
            fileOutputStream = null;
        } catch (Throwable th4) {
            th = th4;
            fileOutputStream = null;
        }
        closeQuietly(fileOutputStream);
    }

    private static void closeQuietly(Closeable closeable) {
        if (closeable != null) {
            try {
                closeable.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public static String getMimeType(URL url) {
        try {
            return url.openConnection().getContentType();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static String getMimeType(String str) {
        try {
            return getMimeType(new URL("file://" + str));
        } catch (MalformedURLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static boolean doesFileFromUriExistAndCanRead(Uri uri, Context context) {
        try {
            ParcelFileDescriptor parcelFileDescriptorOpenFileDescriptor = context.getContentResolver().openFileDescriptor(uri, "r");
            boolean z = parcelFileDescriptorOpenFileDescriptor != null;
            if (parcelFileDescriptorOpenFileDescriptor != null) {
                try {
                    parcelFileDescriptorOpenFileDescriptor.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            return z;
        } catch (Exception e2) {
            e2.printStackTrace();
            TLog.m138d("doesFileFromUriExistAndCanRead exception " + e2.toString());
            return false;
        }
    }

    public static synchronized String getContentFromFile(String str) {
        try {
            File file = new File(str);
            if (file.exists()) {
                RandomAccessFile randomAccessFile = new RandomAccessFile(file, "r");
                byte[] bArr = new byte[(int) randomAccessFile.length()];
                randomAccessFile.readFully(bArr);
                randomAccessFile.close();
                return new String(bArr);
            }
            return "";
        } catch (Exception unused) {
            return "";
        }
    }

    public static synchronized boolean writeFileToDisk(InputStream inputStream, String str) {
        if (AIHelpContext.getInstance().getContext() != null) {
            try {
                File file = new File(str);
                if (file.exists()) {
                    file.delete();
                }
                FileOutputStream fileOutputStream = null;
                try {
                    byte[] bArr = new byte[8192];
                    try {
                        FileOutputStream fileOutputStream2 = new FileOutputStream(file);
                        while (true) {
                            try {
                                int i = inputStream.read(bArr);
                                if (i == -1) {
                                    break;
                                }
                                fileOutputStream2.write(bArr, 0, i);
                            } catch (Exception unused) {
                                fileOutputStream = fileOutputStream2;
                                if (inputStream != null) {
                                    inputStream.close();
                                }
                                if (fileOutputStream != null) {
                                    fileOutputStream.close();
                                }
                                return false;
                            } catch (Throwable th) {
                                th = th;
                                fileOutputStream = fileOutputStream2;
                                if (inputStream != null) {
                                    inputStream.close();
                                }
                                if (fileOutputStream != null) {
                                    fileOutputStream.close();
                                }
                                throw th;
                            }
                        }
                        fileOutputStream2.flush();
                        if (inputStream != null) {
                            inputStream.close();
                        }
                        fileOutputStream2.close();
                        return true;
                    } catch (Exception unused2) {
                    } catch (Throwable th2) {
                        th = th2;
                    }
                } catch (Exception unused3) {
                    inputStream = null;
                } catch (Throwable th3) {
                    th = th3;
                    inputStream = null;
                }
            } catch (Exception unused4) {
            }
        }
        return false;
    }

    private static boolean createOrExistsDir(File file) {
        return file != null && (!file.exists() ? !file.mkdirs() : !file.isDirectory());
    }
}
