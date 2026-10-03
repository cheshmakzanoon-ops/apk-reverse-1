package net.aihelp.core.p004ui.glide.manager;

import java.util.Set;
import net.aihelp.core.p004ui.glide.RequestManager;

public interface RequestManagerTreeNode {
    Set<RequestManager> getDescendants();
}
