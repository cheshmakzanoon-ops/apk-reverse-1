package net.aihelp.core.util.permission;

public interface IPermissionCallback {
    void onPermissionDenied();

    void onPermissionIgnored();

    void onPermissionRational();
}
