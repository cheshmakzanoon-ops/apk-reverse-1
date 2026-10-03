local PushActivityMultipleDropMessage = BaseClass("PushActivityMultipleDropMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushActivityMultipleDropMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushActivityMultipleDropMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.MultiRewardDropManager:UpdateMsg(t)
  end
end

return PushActivityMultipleDropMessage
