local ActivityRebateNewReceiveInfoMessage = BaseClass("ActivityRebateNewReceiveInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityRebateNewManager:OnReceiveInfo(t)
  end
end

ActivityRebateNewReceiveInfoMessage.OnCreate = OnCreate
ActivityRebateNewReceiveInfoMessage.HandleMessage = HandleMessage
return ActivityRebateNewReceiveInfoMessage
