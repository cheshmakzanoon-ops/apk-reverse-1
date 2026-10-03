local PushAllianceStarThumbsUpInfoChangeNewMessage = BaseClass("PushAllianceStarThumbsUpInfoChangeNewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceStarThumbsUpInfoChangeNewMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAllianceStarThumbsUpInfoChangeNewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceStarManager:OnPushAllianceStarThumbsUpInfoChangeNew(t)
  end
end

return PushAllianceStarThumbsUpInfoChangeNewMessage
