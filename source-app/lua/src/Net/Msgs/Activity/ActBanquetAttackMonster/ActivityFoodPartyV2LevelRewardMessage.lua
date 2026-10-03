local ActivityFoodPartyV2LevelRewardMessage = BaseClass("ActivityFoodPartyV2LevelRewardMessage", SFSBaseMessage)
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
    DataCenter.ActBanquetV2Data:GetLevelRewardHandle(t)
  end
end

ActivityFoodPartyV2LevelRewardMessage.OnCreate = OnCreate
ActivityFoodPartyV2LevelRewardMessage.HandleMessage = HandleMessage
return ActivityFoodPartyV2LevelRewardMessage
