local PushRevivalRedPointMessage = BaseClass("PushRevivalRedPointMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushRevivalRedPointMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushRevivalRedPointMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.RevivalPlanManager:PushRevivalRedPoint(t)
  end
end

return PushRevivalRedPointMessage
