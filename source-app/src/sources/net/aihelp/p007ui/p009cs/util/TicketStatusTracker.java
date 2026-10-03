package net.aihelp.p007ui.p009cs.util;

import java.util.List;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.utils.ListUtil;

public class TicketStatusTracker {
    public static int TICKET_ASSIGNED_TO_AGENT = 1;
    public static int TICKET_ASSIGNED_TO_RPA_BOT = 2;
    public static int TICKET_UNASSIGNED_WITH_AGENT = 11;
    public static int TICKET_UNASSIGNED_WITH_BOT = 12;
    public static String currentTicketId = null;
    public static long firstMessageTimeStampInList = 0;
    public static boolean hasUnreadMsg = false;
    public static boolean isAppRatable = false;
    public static boolean isTicketActive = false;
    public static boolean isTicketFinished = false;
    public static boolean isTicketRejected = false;
    public static boolean isTicketWaitForAskingResolveStatus = false;
    public static boolean isTicketWaitForRating = false;
    public static int ticketAssignType = 0;
    public static int ticketPollInterval = 60;

    public static boolean isTicketServingByNobody() {
        return ticketAssignType == TICKET_UNASSIGNED_WITH_AGENT;
    }

    public static boolean isTicketServingByAgent() {
        int i = ticketAssignType;
        return i == TICKET_ASSIGNED_TO_AGENT || i == TICKET_UNASSIGNED_WITH_AGENT;
    }

    public static boolean isTicketServingByRPA() {
        return ticketAssignType == TICKET_ASSIGNED_TO_RPA_BOT;
    }

    public static boolean isTicketServingByAnswerBot() {
        return ticketAssignType == TICKET_UNASSIGNED_WITH_BOT;
    }

    public static void setFirstMessageTimeStampInList(List<Message> list) {
        Message message;
        if (ListUtil.isListEmpty(list) || (message = list.get(0)) == null) {
            return;
        }
        firstMessageTimeStampInList = message.getTimestamp();
    }

    public static void updateAssignTypeWithActiveStatus(boolean z, int i) {
        isTicketActive = z;
        hasUnreadMsg = false;
        ticketAssignType = i;
        if (z) {
            return;
        }
        ticketAssignType = TICKET_UNASSIGNED_WITH_BOT;
    }

    public static void resetTicketStatusFlags() {
        hasUnreadMsg = false;
        isTicketActive = false;
        isTicketWaitForAskingResolveStatus = false;
        isTicketWaitForRating = false;
        isTicketRejected = false;
        isTicketFinished = false;
    }
}
