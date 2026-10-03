package com.google.android.material.internal;

import android.content.Context;
import android.view.SubMenu;
import androidx.appcompat.view.menu.MenuBuilder;
import androidx.appcompat.view.menu.MenuItemImpl;
import androidx.appcompat.view.menu.SubMenuBuilder;

public class NavigationMenu extends MenuBuilder {
    public NavigationMenu(Context context) {
        super(context);
    }

    public SubMenu addSubMenu(int i, int i2, int i3, CharSequence charSequence) {
        MenuItemImpl menuItemImplAddInternal = addInternal(i, i2, i3, charSequence);
        SubMenuBuilder navigationSubMenu = new NavigationSubMenu(getContext(), this, menuItemImplAddInternal);
        menuItemImplAddInternal.setSubMenu(navigationSubMenu);
        return navigationSubMenu;
    }
}
