local PushWorldFlagRemoveMessage = BaseClass("PushWorldFlagRemoveMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushWorldFlagRemoveMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushWorldFlagRemoveMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.uuid then
    DataCenter.WarFlagDataManager:HandleOneFlagRemove(t.uuid)
  end
end

return PushWorldFlagRemoveMessage
