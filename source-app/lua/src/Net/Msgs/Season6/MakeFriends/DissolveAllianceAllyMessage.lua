local DissolveAllianceAllyMessage = BaseClass("DissolveAllianceAllyMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DissolveAllianceAllyMessage:OnCreate()
  base.OnCreate(self)
end

function DissolveAllianceAllyMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.success then
    DataCenter.SeasonAllyFriendManager:CleanData()
  end
end

return DissolveAllianceAllyMessage
