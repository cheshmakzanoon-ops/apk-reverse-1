local ActivityFoodPartyRewardFreeMessage = BaseClass("ActivityFoodPartyRewardFreeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param then
    self.sfsObj:PutInt("aid", param.aid)
    self.sfsObj:PutInt("id", param.id)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActBanquetData:GetFreeRewardHandle(t)
  end
end

ActivityFoodPartyRewardFreeMessage.OnCreate = OnCreate
ActivityFoodPartyRewardFreeMessage.HandleMessage = HandleMessage
return ActivityFoodPartyRewardFreeMessage
