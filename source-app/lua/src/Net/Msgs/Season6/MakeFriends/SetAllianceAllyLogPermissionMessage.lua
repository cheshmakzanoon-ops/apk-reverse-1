local SetAllianceAllyLogPermissionMessage = BaseClass("SetAllianceAllyLogPermissionMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SetAllianceAllyLogPermissionMessage:OnCreate(eventType, logPublic)
  base.OnCreate(self)
  self.sfsObj:PutInt("eventType", eventType)
  self.sfsObj:PutInt("logPublic", logPublic)
end

function SetAllianceAllyLogPermissionMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.lastLogOpUser ~= nil and t.eventType ~= nil then
    DataCenter.SeasonAllyFriendManager:SetAllyLogPermission(t.eventType, t)
  end
end

return SetAllianceAllyLogPermissionMessage
