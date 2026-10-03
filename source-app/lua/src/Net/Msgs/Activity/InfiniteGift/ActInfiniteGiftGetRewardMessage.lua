local ActInfiniteGiftGetRewardMessage = BaseClass("ActInfiniteGiftGetRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, aid, gid, index)
  base.OnCreate(self)
  self.sfsObj:PutInt("aid", aid)
  self.sfsObj:PutInt("gid", gid)
  self.sfsObj:PutInt("index", index)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.reward ~= nil then
    DataCenter.RewardManager:ShowCommonReward(t)
    DataCenter.RewardManager:AddRewardsAndRes(t)
  end
end

ActInfiniteGiftGetRewardMessage.OnCreate = OnCreate
ActInfiniteGiftGetRewardMessage.HandleMessage = HandleMessage
return ActInfiniteGiftGetRewardMessage
