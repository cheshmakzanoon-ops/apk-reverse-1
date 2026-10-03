package cz.msebera.android.httpclient.conn.ssl;

import cz.msebera.android.httpclient.conn.util.InetAddressUtils;
import cz.msebera.android.httpclient.extras.HttpClientAndroidLog;
import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.security.cert.CertificateParsingException;
import java.security.cert.X509Certificate;
import java.util.Arrays;
import java.util.Collection;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.StringTokenizer;
import javax.net.ssl.SSLException;
import javax.net.ssl.SSLSession;
import javax.net.ssl.SSLSocket;
import kotlin.text.Typography;

public abstract class AbstractVerifier implements X509HostnameVerifier {
    private static final String[] BAD_COUNTRY_2LDS;
    public HttpClientAndroidLog log = new HttpClientAndroidLog(getClass());

    static {
        String[] strArr = {"ac", "co", "com", "ed", "edu", "go", "gouv", "gov", "info", "lg", "ne", "net", "or", "org"};
        BAD_COUNTRY_2LDS = strArr;
        Arrays.sort(strArr);
    }

    @Override
    public final void verify(String str, SSLSocket sSLSocket) throws IOException {
        if (str == null) {
            throw new NullPointerException("host to verify is null");
        }
        SSLSession session = sSLSocket.getSession();
        if (session == null) {
            sSLSocket.getInputStream().available();
            session = sSLSocket.getSession();
            if (session == null) {
                sSLSocket.startHandshake();
                session = sSLSocket.getSession();
            }
        }
        verify(str, (X509Certificate) session.getPeerCertificates()[0]);
    }

    @Override
    public final boolean verify(String str, SSLSession sSLSession) {
        try {
            verify(str, (X509Certificate) sSLSession.getPeerCertificates()[0]);
            return true;
        } catch (SSLException unused) {
            return false;
        }
    }

    @Override
    public final void verify(String str, X509Certificate x509Certificate) throws SSLException {
        verify(str, getCNs(x509Certificate), getSubjectAlts(x509Certificate, str));
    }

    public final void verify(String str, String[] strArr, String[] strArr2, boolean z) throws SSLException {
        boolean zEndsWith;
        String str2;
        LinkedList linkedList = new LinkedList();
        if (strArr != null && strArr.length > 0 && (str2 = strArr[0]) != null) {
            linkedList.add(str2);
        }
        if (strArr2 != null) {
            for (String str3 : strArr2) {
                if (str3 != null) {
                    linkedList.add(str3);
                }
            }
        }
        if (linkedList.isEmpty()) {
            throw new SSLException("Certificate for <" + str + "> doesn't contain CN or DNS subjectAlt");
        }
        StringBuilder sb = new StringBuilder();
        String strNormaliseIPv6Address = normaliseIPv6Address(str.trim().toLowerCase(Locale.ENGLISH));
        Iterator it = linkedList.iterator();
        boolean zEquals = false;
        while (it.hasNext()) {
            String lowerCase = ((String) it.next()).toLowerCase(Locale.ENGLISH);
            sb.append(" <");
            sb.append(lowerCase);
            sb.append(Typography.greater);
            if (it.hasNext()) {
                sb.append(" OR");
            }
            String[] strArrSplit = lowerCase.split("\\.");
            if (strArrSplit.length >= 3 && strArrSplit[0].endsWith("*") && validCountryWildcard(lowerCase) && !isIPAddress(str)) {
                String str4 = strArrSplit[0];
                if (str4.length() > 1) {
                    String strSubstring = str4.substring(0, str4.length() - 1);
                    zEndsWith = strNormaliseIPv6Address.startsWith(strSubstring) && strNormaliseIPv6Address.substring(strSubstring.length()).endsWith(lowerCase.substring(str4.length()));
                } else {
                    zEndsWith = strNormaliseIPv6Address.endsWith(lowerCase.substring(1));
                }
                if (zEndsWith && z) {
                    zEndsWith = countDots(strNormaliseIPv6Address) == countDots(lowerCase);
                }
                zEquals = zEndsWith;
            } else {
                zEquals = strNormaliseIPv6Address.equals(normaliseIPv6Address(lowerCase));
            }
            if (zEquals) {
                break;
            }
        }
        if (zEquals) {
            return;
        }
        throw new SSLException("hostname in certificate didn't match: <" + str + "> !=" + ((Object) sb));
    }

    @Deprecated
    public static boolean acceptableCountryWildcard(String str) {
        String[] strArrSplit = str.split("\\.");
        return (strArrSplit.length == 3 && strArrSplit[2].length() == 2 && Arrays.binarySearch(BAD_COUNTRY_2LDS, strArrSplit[1]) >= 0) ? false : true;
    }

    boolean validCountryWildcard(String str) {
        String[] strArrSplit = str.split("\\.");
        return (strArrSplit.length == 3 && strArrSplit[2].length() == 2 && Arrays.binarySearch(BAD_COUNTRY_2LDS, strArrSplit[1]) >= 0) ? false : true;
    }

    public static String[] getCNs(X509Certificate x509Certificate) {
        try {
            return extractCNs(x509Certificate.getSubjectX500Principal().toString());
        } catch (SSLException unused) {
            return null;
        }
    }

    static String[] extractCNs(String str) throws SSLException {
        if (str == null) {
            return null;
        }
        LinkedList linkedList = new LinkedList();
        StringTokenizer stringTokenizer = new StringTokenizer(str, ",");
        while (stringTokenizer.hasMoreTokens()) {
            String strNextToken = stringTokenizer.nextToken();
            int iIndexOf = strNextToken.indexOf("CN=");
            if (iIndexOf >= 0) {
                linkedList.add(strNextToken.substring(iIndexOf + 3));
            }
        }
        if (linkedList.isEmpty()) {
            return null;
        }
        String[] strArr = new String[linkedList.size()];
        linkedList.toArray(strArr);
        return strArr;
    }

    private static String[] getSubjectAlts(X509Certificate x509Certificate, String str) {
        Collection<List<?>> subjectAlternativeNames;
        int i = isIPAddress(str) ? 7 : 2;
        LinkedList linkedList = new LinkedList();
        try {
            subjectAlternativeNames = x509Certificate.getSubjectAlternativeNames();
        } catch (CertificateParsingException unused) {
            subjectAlternativeNames = null;
        }
        if (subjectAlternativeNames != null) {
            for (List<?> list : subjectAlternativeNames) {
                if (((Integer) list.get(0)).intValue() == i) {
                    linkedList.add((String) list.get(1));
                }
            }
        }
        if (linkedList.isEmpty()) {
            return null;
        }
        String[] strArr = new String[linkedList.size()];
        linkedList.toArray(strArr);
        return strArr;
    }

    public static String[] getDNSSubjectAlts(X509Certificate x509Certificate) {
        return getSubjectAlts(x509Certificate, null);
    }

    public static int countDots(String str) {
        int i = 0;
        for (int i2 = 0; i2 < str.length(); i2++) {
            if (str.charAt(i2) == '.') {
                i++;
            }
        }
        return i;
    }

    private static boolean isIPAddress(String str) {
        return str != null && (InetAddressUtils.isIPv4Address(str) || InetAddressUtils.isIPv6Address(str));
    }

    private String normaliseIPv6Address(String str) {
        if (str != null && InetAddressUtils.isIPv6Address(str)) {
            try {
                return InetAddress.getByName(str).getHostAddress();
            } catch (UnknownHostException e) {
                this.log.error("Unexpected error converting " + str, e);
            }
        }
        return str;
    }
}
