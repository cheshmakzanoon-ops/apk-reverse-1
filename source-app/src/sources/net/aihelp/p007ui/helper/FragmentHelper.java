package net.aihelp.p007ui.helper;

import android.text.TextUtils;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;
import java.util.List;
import net.aihelp.p007ui.SupportFragment;
import net.aihelp.utils.ResResolver;

public class FragmentHelper {
    public static void startFragment(FragmentManager fragmentManager, int i, Fragment fragment, String str, String str2, boolean z, boolean z2) {
        loadFragment(fragmentManager, i, fragment, str, str2, z, z2);
    }

    public static void startFragmentWithBackStack(FragmentManager fragmentManager, int i, Fragment fragment, String str, boolean z) {
        loadFragment(fragmentManager, i, fragment, str, fragment.getClass().getName(), z, false);
    }

    public static void startFragmentWithoutBackStack(FragmentManager fragmentManager, int i, Fragment fragment, String str, boolean z) {
        loadFragment(fragmentManager, i, fragment, str, null, z, false);
    }

    public static void popBackStack(FragmentManager fragmentManager, String str) {
        fragmentManager.popBackStack(str, 1);
    }

    public static void popBackStackImmediate(FragmentManager fragmentManager, String str) {
        fragmentManager.popBackStackImmediate(str, 1);
    }

    public static void removeFragment(FragmentManager fragmentManager, Fragment fragment) {
        fragmentManager.beginTransaction().remove(fragment).commitAllowingStateLoss();
    }

    private static <T extends Fragment> T getFragment(FragmentManager fragmentManager, Class<T> cls) {
        for (T t : fragmentManager.getFragments()) {
            if (cls.isInstance(t)) {
                return t;
            }
        }
        return null;
    }

    public static SupportFragment getSupportFragment(Fragment fragment) {
        Fragment parentFragment;
        if (fragment instanceof SupportFragment) {
            return (SupportFragment) fragment;
        }
        if (fragment == null || (parentFragment = fragment.getParentFragment()) == null) {
            return null;
        }
        return parentFragment instanceof SupportFragment ? (SupportFragment) parentFragment : getSupportFragment(parentFragment);
    }

    private static void loadFragment(FragmentManager fragmentManager, int i, Fragment fragment, String str, String str2, boolean z, boolean z2) {
        FragmentTransaction fragmentTransactionBeginTransaction = fragmentManager.beginTransaction();
        if (fragmentManager.findFragmentById(i) != null && !z2) {
            fragmentTransactionBeginTransaction.setCustomAnimations(ResResolver.getAnimId("aihelp_slide_in_from_right"), ResResolver.getAnimId("aihelp_slide_out_to_left"), ResResolver.getAnimId("aihelp_slide_in_from_left"), ResResolver.getAnimId("aihelp_slide_out_to_right"));
        } else {
            fragmentTransactionBeginTransaction.setCustomAnimations(0, 0, 0, 0);
        }
        fragmentTransactionBeginTransaction.replace(i, fragment, str);
        if (!TextUtils.isEmpty(str2)) {
            fragmentTransactionBeginTransaction.addToBackStack(str2);
        }
        fragmentTransactionBeginTransaction.commitAllowingStateLoss();
        if (z) {
            fragmentManager.executePendingTransactions();
        }
    }

    public static Fragment getTopMostFragment(FragmentManager fragmentManager) {
        List fragments = fragmentManager.getFragments();
        if (fragments.size() > 0) {
            return (Fragment) fragments.get(fragments.size() - 1);
        }
        return null;
    }
}
