package kotlin.p002io.path;

import java.nio.file.DirectoryStream;
import java.nio.file.FileSystemException;
import java.nio.file.FileSystemLoopException;
import java.nio.file.FileVisitResult;
import java.nio.file.FileVisitor;
import java.nio.file.NoSuchFileException;
import java.nio.file.Path;
import java.nio.file.SecureDirectoryStream;
import java.nio.file.attribute.BasicFileAttributeView;
import java.nio.file.attribute.BasicFileAttributes;
import java.nio.file.attribute.FileAttributeView;

public final class PathTreeWalk$$ExternalSyntheticApiModelOutline0 {
    public static Class m51m() {
        return BasicFileAttributes.class;
    }

    public static DirectoryStream m56m(Object obj) {
        return (DirectoryStream) obj;
    }

    public static FileSystemException m61m(Object obj) {
        return (FileSystemException) obj;
    }

    public static FileSystemException m62m(String str) {
        return new FileSystemException(str);
    }

    public static FileSystemException m63m(String str, String str2, String str3) {
        return new FileSystemException(str, str2, str3);
    }

    public static FileSystemLoopException m64m(String str) {
        return new FileSystemLoopException(str);
    }

    public static FileVisitResult m67m(Object obj) {
        return (FileVisitResult) obj;
    }

    public static FileVisitor m68m(Object obj) {
        return (FileVisitor) obj;
    }

    public static NoSuchFileException m70m(String str, String str2, String str3) {
        return new NoSuchFileException(str, str2, str3);
    }

    public static Path m71m(Object obj) {
        return (Path) obj;
    }

    public static SecureDirectoryStream m94m(Object obj) {
        return (SecureDirectoryStream) obj;
    }

    public static BasicFileAttributeView m98m(Object obj) {
        return (BasicFileAttributeView) obj;
    }

    public static BasicFileAttributes m99m(Object obj) {
        return (BasicFileAttributes) obj;
    }

    public static FileAttributeView m102m(Object obj) {
        return (FileAttributeView) obj;
    }

    public static void m112m() {
    }

    public static boolean m115m(Object obj) {
        return obj instanceof SecureDirectoryStream;
    }

    public static Class m$1() {
        return BasicFileAttributeView.class;
    }

    public static void m1518m$1() {
    }

    public static Class m$2() {
        return FileAttributeView.class;
    }

    public static void m1522m$2() {
    }
}
