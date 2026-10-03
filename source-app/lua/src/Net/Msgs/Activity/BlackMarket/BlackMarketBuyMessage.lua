local BlackMarketBuyMessage = BaseClass("BlackMarketBuyMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, aid, uuid, num)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", aid)
  self.sfsObj:PutUtfString("shopUuid", uuid)
  self.sfsObj:PutInt("num", num)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward ~= nil then
      DataCenter.RewardManager:ShowCommonReward(t)
      DataCenter.RewardManager:AddRewardsAndRes(t)
    end
    DataCenter.ActBlackMarketDataManager:OnItemBought(t)
  end
end

BlackMarketBuyMessage.OnCreate = OnCreate
BlackMarketBuyMessage.HandleMessage = HandleMessage
return BlackMarketBuyMessage
