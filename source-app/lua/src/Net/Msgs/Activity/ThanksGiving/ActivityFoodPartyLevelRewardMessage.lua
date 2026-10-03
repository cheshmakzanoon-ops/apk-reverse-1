local ActivityFoodPartyLevelRewardMessage = BaseClass("ActivityFoodPartyLevelRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, param)
  base.OnCreate(self)
  if param then
    self.sfsObj:PutInt("aid", param.aid)
    self.sfsObj:PutInt("id", param.id)
    self.sfsObj:PutInt("level", param.level)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActBanquetData:GetLevelRewardHandle(t)
  end
end

ActivityFoodPartyLevelRewardMessage.OnCreate = OnCreate
ActivityFoodPartyLevelRewardMessage.HandleMessage = HandleMessage
return ActivityFoodPartyLevelRewardMessage
