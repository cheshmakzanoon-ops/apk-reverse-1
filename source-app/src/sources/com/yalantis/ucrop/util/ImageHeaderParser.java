package com.yalantis.ucrop.util;

import android.content.Context;
import android.net.Uri;
import android.os.ParcelFileDescriptor;
import android.text.TextUtils;
import android.util.Log;
import androidx.exifinterface.media.ExifInterface;
import java.io.IOException;
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.charset.Charset;

public class ImageHeaderParser {
    private static final int EXIF_MAGIC_NUMBER = 65496;
    private static final int EXIF_SEGMENT_TYPE = 225;
    private static final int INTEL_TIFF_MAGIC_NUMBER = 18761;
    private static final int MARKER_EOI = 217;
    private static final int MOTOROLA_TIFF_MAGIC_NUMBER = 19789;
    private static final int ORIENTATION_TAG_TYPE = 274;
    private static final int SEGMENT_SOS = 218;
    private static final int SEGMENT_START_ID = 255;
    private static final String TAG = "ImageHeaderParser";
    public static final int UNKNOWN_ORIENTATION = -1;
    private final Reader reader;
    private static final String JPEG_EXIF_SEGMENT_PREAMBLE = "Exif\u0000\u0000";
    private static final byte[] JPEG_EXIF_SEGMENT_PREAMBLE_BYTES = JPEG_EXIF_SEGMENT_PREAMBLE.getBytes(Charset.forName("UTF-8"));
    private static final int[] BYTES_PER_FORMAT = {0, 1, 1, 2, 4, 8, 1, 1, 2, 4, 8, 4, 8};

    private interface Reader {
        int getUInt16() throws IOException;

        short getUInt8() throws IOException;

        int read(byte[] bArr, int i) throws IOException;

        long skip(long j) throws IOException;
    }

    private static int calcTagOffset(int i, int i2) {
        return i + 2 + (i2 * 12);
    }

    private static boolean handles(int i) {
        return (i & EXIF_MAGIC_NUMBER) == EXIF_MAGIC_NUMBER || i == MOTOROLA_TIFF_MAGIC_NUMBER || i == INTEL_TIFF_MAGIC_NUMBER;
    }

    public ImageHeaderParser(InputStream inputStream) {
        this.reader = new StreamReader(inputStream);
    }

    public int getOrientation() throws IOException {
        int uInt16 = this.reader.getUInt16();
        if (!handles(uInt16)) {
            if (Log.isLoggable(TAG, 3)) {
                Log.d(TAG, "Parser doesn't handle magic number: " + uInt16);
            }
            return -1;
        }
        int iMoveToExifSegmentAndGetLength = moveToExifSegmentAndGetLength();
        if (iMoveToExifSegmentAndGetLength == -1) {
            if (Log.isLoggable(TAG, 3)) {
                Log.d(TAG, "Failed to parse exif segment length, or exif segment not found");
            }
            return -1;
        }
        return parseExifSegment(new byte[iMoveToExifSegmentAndGetLength], iMoveToExifSegmentAndGetLength);
    }

    private int parseExifSegment(byte[] bArr, int i) throws IOException {
        int i2 = this.reader.read(bArr, i);
        if (i2 != i) {
            if (Log.isLoggable(TAG, 3)) {
                Log.d(TAG, "Unable to read exif segment data, length: " + i + ", actually read: " + i2);
            }
            return -1;
        }
        if (hasJpegExifPreamble(bArr, i)) {
            return parseExifSegment(new RandomAccessReader(bArr, i));
        }
        if (Log.isLoggable(TAG, 3)) {
            Log.d(TAG, "Missing jpeg exif preamble");
        }
        return -1;
    }

    private boolean hasJpegExifPreamble(byte[] bArr, int i) {
        boolean z = bArr != null && i > JPEG_EXIF_SEGMENT_PREAMBLE_BYTES.length;
        if (z) {
            int i2 = 0;
            while (true) {
                byte[] bArr2 = JPEG_EXIF_SEGMENT_PREAMBLE_BYTES;
                if (i2 >= bArr2.length) {
                    break;
                }
                if (bArr[i2] != bArr2[i2]) {
                    return false;
                }
                i2++;
            }
        }
        return z;
    }

    private int moveToExifSegmentAndGetLength() throws IOException {
        short uInt8;
        int uInt16;
        long j;
        long jSkip;
        do {
            short uInt9 = this.reader.getUInt8();
            if (uInt9 != SEGMENT_START_ID) {
                if (Log.isLoggable(TAG, 3)) {
                    Log.d(TAG, "Unknown segmentId=" + ((int) uInt9));
                }
                return -1;
            }
            uInt8 = this.reader.getUInt8();
            if (uInt8 == SEGMENT_SOS) {
                return -1;
            }
            if (uInt8 == MARKER_EOI) {
                if (Log.isLoggable(TAG, 3)) {
                    Log.d(TAG, "Found MARKER_EOI in exif segment");
                }
                return -1;
            }
            uInt16 = this.reader.getUInt16() - 2;
            if (uInt8 == EXIF_SEGMENT_TYPE) {
                return uInt16;
            }
            j = uInt16;
            jSkip = this.reader.skip(j);
        } while (jSkip == j);
        if (Log.isLoggable(TAG, 3)) {
            Log.d(TAG, "Unable to skip enough data, type: " + ((int) uInt8) + ", wanted to skip: " + uInt16 + ", but actually skipped: " + jSkip);
        }
        return -1;
    }

    private static int parseExifSegment(RandomAccessReader randomAccessReader) {
        ByteOrder byteOrder;
        short int16 = randomAccessReader.getInt16(6);
        if (int16 == MOTOROLA_TIFF_MAGIC_NUMBER) {
            byteOrder = ByteOrder.BIG_ENDIAN;
        } else if (int16 == INTEL_TIFF_MAGIC_NUMBER) {
            byteOrder = ByteOrder.LITTLE_ENDIAN;
        } else {
            if (Log.isLoggable(TAG, 3)) {
                Log.d(TAG, "Unknown endianness = " + ((int) int16));
            }
            byteOrder = ByteOrder.BIG_ENDIAN;
        }
        randomAccessReader.order(byteOrder);
        int int32 = randomAccessReader.getInt32(10) + 6;
        short int17 = randomAccessReader.getInt16(int32);
        for (int i = 0; i < int17; i++) {
            int iCalcTagOffset = calcTagOffset(int32, i);
            short int18 = randomAccessReader.getInt16(iCalcTagOffset);
            if (int18 == ORIENTATION_TAG_TYPE) {
                short int19 = randomAccessReader.getInt16(iCalcTagOffset + 2);
                if (int19 < 1 || int19 > 12) {
                    if (Log.isLoggable(TAG, 3)) {
                        Log.d(TAG, "Got invalid format code = " + ((int) int19));
                    }
                } else {
                    int int33 = randomAccessReader.getInt32(iCalcTagOffset + 4);
                    if (int33 < 0) {
                        if (Log.isLoggable(TAG, 3)) {
                            Log.d(TAG, "Negative tiff component count");
                        }
                    } else {
                        if (Log.isLoggable(TAG, 3)) {
                            Log.d(TAG, "Got tagIndex=" + i + " tagType=" + ((int) int18) + " formatCode=" + ((int) int19) + " componentCount=" + int33);
                        }
                        int i2 = int33 + BYTES_PER_FORMAT[int19];
                        if (i2 > 4) {
                            if (Log.isLoggable(TAG, 3)) {
                                Log.d(TAG, "Got byte count > 4, not orientation, continuing, formatCode=" + ((int) int19));
                            }
                        } else {
                            int i3 = iCalcTagOffset + 8;
                            if (i3 < 0 || i3 > randomAccessReader.length()) {
                                if (Log.isLoggable(TAG, 3)) {
                                    Log.d(TAG, "Illegal tagValueOffset=" + i3 + " tagType=" + ((int) int18));
                                }
                            } else if (i2 < 0 || i2 + i3 > randomAccessReader.length()) {
                                if (Log.isLoggable(TAG, 3)) {
                                    Log.d(TAG, "Illegal number of bytes for TI tag data tagType=" + ((int) int18));
                                }
                            } else {
                                return randomAccessReader.getInt16(i3);
                            }
                        }
                    }
                }
            }
        }
        return -1;
    }

    private static class RandomAccessReader {
        private final ByteBuffer data;

        public RandomAccessReader(byte[] bArr, int i) {
            this.data = (ByteBuffer) ByteBuffer.wrap(bArr).order(ByteOrder.BIG_ENDIAN).limit(i);
        }

        public void order(ByteOrder byteOrder) {
            this.data.order(byteOrder);
        }

        public int length() {
            return this.data.remaining();
        }

        public int getInt32(int i) {
            return this.data.getInt(i);
        }

        public short getInt16(int i) {
            return this.data.getShort(i);
        }
    }

    private static class StreamReader implements Reader {

        private final InputStream f544is;

        public StreamReader(InputStream inputStream) {
            this.f544is = inputStream;
        }

        @Override
        public int getUInt16() throws IOException {
            return ((this.f544is.read() << 8) & 65280) | (this.f544is.read() & ImageHeaderParser.SEGMENT_START_ID);
        }

        @Override
        public short getUInt8() throws IOException {
            return (short) (this.f544is.read() & ImageHeaderParser.SEGMENT_START_ID);
        }

        @Override
        public long skip(long j) throws IOException {
            if (j < 0) {
                return 0L;
            }
            long j2 = j;
            while (j2 > 0) {
                long jSkip = this.f544is.skip(j2);
                if (jSkip <= 0) {
                    if (this.f544is.read() == -1) {
                        break;
                    }
                    jSkip = 1;
                }
                j2 -= jSkip;
            }
            return j - j2;
        }

        @Override
        public int read(byte[] bArr, int i) throws IOException {
            int i2 = i;
            while (i2 > 0) {
                int i3 = this.f544is.read(bArr, i - i2, i2);
                if (i3 == -1) {
                    break;
                }
                i2 -= i3;
            }
            return i - i2;
        }
    }

    public static void copyExif(ExifInterface exifInterface, int i, int i2, String str) {
        try {
            copyExifAttributes(exifInterface, new ExifInterface(str), i, i2);
        } catch (IOException e) {
            Log.d(TAG, e.getMessage());
        }
    }

    public static void copyExif(Context context, int i, int i2, Uri uri, String str) {
        if (context == null) {
            Log.d(TAG, "context is null");
            return;
        }
        InputStream inputStreamOpenInputStream = null;
        try {
            try {
                try {
                    inputStreamOpenInputStream = context.getContentResolver().openInputStream(uri);
                    copyExifAttributes(new ExifInterface(inputStreamOpenInputStream), new ExifInterface(str), i, i2);
                    if (inputStreamOpenInputStream != null) {
                        inputStreamOpenInputStream.close();
                    }
                } catch (IOException e) {
                    Log.d(TAG, e.getMessage(), e);
                    if (inputStreamOpenInputStream == null) {
                    } else {
                        inputStreamOpenInputStream.close();
                    }
                }
            } catch (IOException e2) {
                Log.d(TAG, e2.getMessage(), e2);
            }
        } catch (Throwable th) {
            if (inputStreamOpenInputStream != null) {
                try {
                    inputStreamOpenInputStream.close();
                } catch (IOException e3) {
                    Log.d(TAG, e3.getMessage(), e3);
                }
            }
            throw th;
        }
    }

    public static void copyExif(Context context, int i, int i2, Uri uri, Uri uri2) throws Throwable {
        ParcelFileDescriptor parcelFileDescriptor;
        if (context == null) {
            Log.d(TAG, "context is null");
            return;
        }
        InputStream inputStream = null;
        parcelFileDescriptorOpenFileDescriptor = null;
        ParcelFileDescriptor parcelFileDescriptorOpenFileDescriptor = null;
        inputStream = null;
        try {
            try {
                InputStream inputStreamOpenInputStream = context.getContentResolver().openInputStream(uri);
                try {
                    ExifInterface exifInterface = new ExifInterface(inputStreamOpenInputStream);
                    parcelFileDescriptorOpenFileDescriptor = context.getContentResolver().openFileDescriptor(uri2, "rw");
                    copyExifAttributes(exifInterface, new ExifInterface(parcelFileDescriptorOpenFileDescriptor.getFileDescriptor()), i, i2);
                    if (inputStreamOpenInputStream != null) {
                        try {
                            inputStreamOpenInputStream.close();
                        } catch (IOException e) {
                            Log.d(TAG, e.getMessage(), e);
                        }
                    }
                    if (parcelFileDescriptorOpenFileDescriptor != null) {
                        parcelFileDescriptorOpenFileDescriptor.close();
                    }
                } catch (IOException e2) {
                    e = e2;
                    parcelFileDescriptor = parcelFileDescriptorOpenFileDescriptor;
                    inputStream = inputStreamOpenInputStream;
                    try {
                        Log.d(TAG, e.getMessage(), e);
                        if (inputStream != null) {
                            try {
                                inputStream.close();
                            } catch (IOException e3) {
                                Log.d(TAG, e3.getMessage(), e3);
                            }
                        }
                        if (parcelFileDescriptor == null) {
                        } else {
                            parcelFileDescriptor.close();
                        }
                    } catch (Throwable th) {
                        th = th;
                        if (inputStream != null) {
                            try {
                                inputStream.close();
                            } catch (IOException e4) {
                                Log.d(TAG, e4.getMessage(), e4);
                            }
                        }
                        if (parcelFileDescriptor != null) {
                            try {
                                parcelFileDescriptor.close();
                                throw th;
                            } catch (IOException e5) {
                                Log.d(TAG, e5.getMessage(), e5);
                                throw th;
                            }
                        }
                        throw th;
                    }
                } catch (Throwable th2) {
                    th = th2;
                    parcelFileDescriptor = parcelFileDescriptorOpenFileDescriptor;
                    inputStream = inputStreamOpenInputStream;
                    if (inputStream != null) {
                        inputStream.close();
                    }
                    if (parcelFileDescriptor != null) {
                        parcelFileDescriptor.close();
                        throw th;
                    }
                    throw th;
                }
            } catch (IOException e6) {
                Log.d(TAG, e6.getMessage(), e6);
            }
        } catch (IOException e7) {
            e = e7;
            parcelFileDescriptor = null;
        } catch (Throwable th3) {
            th = th3;
            parcelFileDescriptor = null;
        }
    }

    public static void copyExif(Context context, ExifInterface exifInterface, int i, int i2, Uri uri) {
        if (context == null) {
            Log.d(TAG, "context is null");
            return;
        }
        ParcelFileDescriptor parcelFileDescriptorOpenFileDescriptor = null;
        try {
            try {
                try {
                    parcelFileDescriptorOpenFileDescriptor = context.getContentResolver().openFileDescriptor(uri, "rw");
                    copyExifAttributes(exifInterface, new ExifInterface(parcelFileDescriptorOpenFileDescriptor.getFileDescriptor()), i, i2);
                    if (parcelFileDescriptorOpenFileDescriptor != null) {
                        parcelFileDescriptorOpenFileDescriptor.close();
                    }
                } catch (IOException e) {
                    Log.d(TAG, e.getMessage());
                    if (parcelFileDescriptorOpenFileDescriptor == null) {
                    } else {
                        parcelFileDescriptorOpenFileDescriptor.close();
                    }
                }
            } catch (IOException e2) {
                Log.d(TAG, e2.getMessage(), e2);
            }
        } catch (Throwable th) {
            if (parcelFileDescriptorOpenFileDescriptor != null) {
                try {
                    parcelFileDescriptorOpenFileDescriptor.close();
                } catch (IOException e3) {
                    Log.d(TAG, e3.getMessage(), e3);
                }
            }
            throw th;
        }
    }

    private static void copyExifAttributes(ExifInterface exifInterface, ExifInterface exifInterface2, int i, int i2) throws IOException {
        String[] strArr = {"FNumber", "DateTime", "DateTimeDigitized", "ExposureTime", "Flash", "FocalLength", "GPSAltitude", "GPSAltitudeRef", "GPSDateStamp", "GPSLatitude", "GPSLatitudeRef", "GPSLongitude", "GPSLongitudeRef", "GPSProcessingMethod", "GPSTimeStamp", "PhotographicSensitivity", "Make", "Model", "SubSecTime", "SubSecTimeDigitized", "SubSecTimeOriginal", "WhiteBalance"};
        for (int i3 = 0; i3 < 22; i3++) {
            String str = strArr[i3];
            String attribute = exifInterface.getAttribute(str);
            if (!TextUtils.isEmpty(attribute)) {
                exifInterface2.setAttribute(str, attribute);
            }
        }
        exifInterface2.setAttribute("ImageWidth", String.valueOf(i));
        exifInterface2.setAttribute("ImageLength", String.valueOf(i2));
        exifInterface2.setAttribute("Orientation", "0");
        exifInterface2.saveAttributes();
    }
}
