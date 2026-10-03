local ActivityFoodPartyV2RewardFreeMessage = BaseClass("ActivityFoodPartyV2RewardFreeMessage", SFSBaseMessage)
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
    DataCenter.ActBanquetV2Data:GetFreeRewardHandle(t)
  end
end

ActivityFoodPartyV2RewardFreeMessage.OnCreate = OnCreate
ActivityFoodPartyV2RewardFreeMessage.HandleMessage = HandleMessage
return ActivityFoodPartyV2RewardFreeMessage
