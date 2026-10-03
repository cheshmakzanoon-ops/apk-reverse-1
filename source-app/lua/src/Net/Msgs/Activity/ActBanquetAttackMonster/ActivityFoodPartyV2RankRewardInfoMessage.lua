local ActivityFoodPartyV2RankRewardInfoMessage = BaseClass("ActivityFoodPartyV2RankRewardInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, param)
  base.OnCreate(self)
  if param then
    self.sfsObj:PutInt("aid", param.aid)
    self.sfsObj:PutInt("id", param.id)
    self.sfsObj:PutInt("type", param.type)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActBanquetV2Data:GetRankRewardHandle(t)
  end
end

ActivityFoodPartyV2RankRewardInfoMessage.OnCreate = OnCreate
ActivityFoodPartyV2RankRewardInfoMessage.HandleMessage = HandleMessage
return ActivityFoodPartyV2RankRewardInfoMessage
