local AlliancePostEventLog = {}
AlliancePostEventLog.FirstJoinAction = {
  Open = "open",
  Close = "close",
  List = "list",
  Join = "join",
  Creat = "creat"
}
AlliancePostEventLog.JoinAction = {
  Open = "open",
  Close = "close",
  Creat = "creat",
  QuickJoin = "quickJoin",
  Join = "join",
  Apply = "apply",
  CancelApply = "cancelApply"
}
AlliancePostEventLog.CreatAction = {
  Open = "open",
  Close = "close",
  Creat = "creat",
  Join = "join"
}
AlliancePostEventLog.InviteAction = {
  Open = "open",
  Close = "close",
  List = "list",
  Join = "join",
  Dm = "dm"
}
AlliancePostEventLog.NoticeAction = {
  Open = "open",
  Reply = "reply",
  Like = "like",
  Unlike = "unlike"
}
AlliancePostEventLog.NoticeSendType = {New = "new", Resend = "resend"}
AlliancePostEventLog.NoticeContentType = {Normal = "normal", Vote = "vote"}
AlliancePostEventLog.MailAction = {Open = "open", Like = "like"}

function AlliancePostEventLog.PostEventLog_FirstJoin_Action(action)
  PostEventLog.Track(PostEventLog.Defines.C_ALLIANCEFIRSTJOIN, {action = action})
end

function AlliancePostEventLog.PostEventLog_ListJoin_Action(action)
  PostEventLog.Track(PostEventLog.Defines.C_ALLIANCELIST_JOIN, {action = action})
end

function AlliancePostEventLog.PostEventLog_ListCreat_Action(action)
  PostEventLog.Track(PostEventLog.Defines.C_ALLIANCELIST_CREAT, {action = action})
end

function AlliancePostEventLog.PostEventLog_Invite_Action(action)
  PostEventLog.Track(PostEventLog.Defines.C_ALLIANCEINVITE, {action = action})
end

function AlliancePostEventLog.PostEventLog_Notice_Action(action)
  PostEventLog.Track(PostEventLog.Defines.C_ALLIANCENOTICE, {action = action})
end

function AlliancePostEventLog.PostEventLog_Mail_Action(action)
  PostEventLog.Track(PostEventLog.Defines.C_ALLIANCEMAIL, {action = action})
end

function AlliancePostEventLog.PostEventLog_Declaration()
  PostEventLog.Track(PostEventLog.Defines.C_ALLIANCEDECLARATION, {is_assign = true})
end

function AlliancePostEventLog.PostEventLog_Notice_Send(sendType, contentType, str, isImage)
  str = str or ""
  PostEventLog.Track(PostEventLog.Defines.C_ALLIANCENOTICE, {
    event_type = sendType,
    s_type = contentType,
    total_num = string.len(str),
    is_assign = isImage
  })
end

function AlliancePostEventLog.PostEventLog_Mail_Send(str)
  str = str or ""
  PostEventLog.Track(PostEventLog.Defines.C_ALLIANCEMAIL, {
    total_num = string.len(str)
  })
end

return AlliancePostEventLog
