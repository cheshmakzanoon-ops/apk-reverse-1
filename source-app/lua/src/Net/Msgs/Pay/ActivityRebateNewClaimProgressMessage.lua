local ActivityRebateNewClaimProgressMessage = BaseClass("ActivityRebateNewClaimProgressMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", param.activityId)
  self.sfsObj:PutInt("index", param.index - 1)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityRebateNewManager:OnClaimProgress(t)
  end
end

ActivityRebateNewClaimProgressMessage.OnCreate = OnCreate
ActivityRebateNewClaimProgressMessage.HandleMessage = HandleMessage
return ActivityRebateNewClaimProgressMessage
