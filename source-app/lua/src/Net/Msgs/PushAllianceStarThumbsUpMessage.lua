local PushAllianceStarThumbsUpMessage = BaseClass("PushAllianceStarThumbsUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceStarThumbsUpMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAllianceStarThumbsUpMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceStarManager:RefreshMailThumbsUpDataItem(t)
  end
end

return PushAllianceStarThumbsUpMessage
