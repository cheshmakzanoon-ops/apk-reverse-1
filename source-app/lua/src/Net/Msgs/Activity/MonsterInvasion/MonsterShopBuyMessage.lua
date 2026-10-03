local MonsterShopBuyMessage = BaseClass("MonsterShopBuyMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, id, count)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("id", id)
  self.sfsObj:PutInt("count", count)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if not string.IsNullOrEmpty(t.itemId) then
      local curNum = DataCenter.ItemData:GetItemCount(t.itemId)
      local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(t.itemId)
      itemTemplate.itemId = t.itemId
      itemTemplate.count = curNum + t.itemAddNum
      itemTemplate.rewardAdd = t.itemAddNum
      itemTemplate.uuid = t.itemUuid
      local reward = {
        type = RewardType.GOODS,
        value = itemTemplate
      }
      local rewardList = {}
      table.insert(rewardList, reward)
      DataCenter.RewardManager:AddRewards(rewardList)
      local msg = {
        reward = {}
      }
      table.insert(msg.reward, reward)
      DataCenter.RewardManager:ShowCommonReward(msg)
    end
    DataCenter.ActivityMonsterInvasionDataManager:UpdateActShopDataByBuy(t)
    EventManager:GetInstance():Broadcast(EventId.MonsterInvasionShopDataUpdate)
  end
end

MonsterShopBuyMessage.OnCreate = OnCreate
MonsterShopBuyMessage.HandleMessage = HandleMessage
return MonsterShopBuyMessage
