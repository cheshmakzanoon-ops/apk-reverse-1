local RichManShopBuyMessage = BaseClass("RichManShopBuyMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, storeKey, shopId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutUtfString("storeKey", storeKey)
  self.sfsObj:PutUtfString("shopId", shopId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local reward = t.reward
    if reward and 0 < #reward then
      DataCenter.RewardManager:AddRewards(reward)
      DataCenter.RewardManager:ShowCommonReward(t)
    end
    if t.remainGold then
      LuaEntry.Player.gold = t.remainGold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
  end
end

RichManShopBuyMessage.OnCreate = OnCreate
RichManShopBuyMessage.HandleMessage = HandleMessage
return RichManShopBuyMessage
