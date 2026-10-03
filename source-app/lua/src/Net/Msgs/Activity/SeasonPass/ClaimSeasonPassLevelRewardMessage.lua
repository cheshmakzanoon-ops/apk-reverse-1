local ClaimSeasonPassLevelRewardMessage = BaseClass("ClaimSeasonPassLevelRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, level, type)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("level", level)
  self.sfsObj:PutInt("type", type)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonPassManager:OnRecvClaimLevelRewardResp(t)
  end
end

ClaimSeasonPassLevelRewardMessage.OnCreate = OnCreate
ClaimSeasonPassLevelRewardMessage.HandleMessage = HandleMessage
return ClaimSeasonPassLevelRewardMessage
