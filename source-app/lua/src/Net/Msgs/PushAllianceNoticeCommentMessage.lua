local PushAllianceNoticeCommentMessage = BaseClass("PushAllianceNoticeCommentMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, notice, isAdv, uid)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceNoticeManager:RefreshOneNoticeData(t, 2)
  end
end

PushAllianceNoticeCommentMessage.OnCreate = OnCreate
PushAllianceNoticeCommentMessage.HandleMessage = HandleMessage
return PushAllianceNoticeCommentMessage
