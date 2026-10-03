local BuyCommonShopGoodsMessage = BaseClass("BuyCommonShopGoodsMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, goodsId, goodsArr, num)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", goodsId)
  if num then
    self.sfsObj:PutInt("num", num)
  end
  if goodsArr then
    local resources = SFSArray.New()
    for k, v in pairs(goodsArr) do
      local obj = SFSObject.New()
      obj:PutUtfString("goodId", k)
      obj:PutInt("num", v)
      resources:AddSFSObject(obj)
    end
    self.sfsObj:PutSFSArray("goodsArr", resources)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.remainGold ~= nil then
      LuaEntry.Player.gold = t.remainGold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    if t.resource then
      LuaEntry.Resource:UpdateResource(t.resource)
    end
    if t.accPoint ~= nil then
      DataCenter.AllianceBaseDataManager:UpdateAccPoint(t.accPoint)
    end
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
      local goodsId = t.goodsId
      local shopGoodsTemp = LocalController:instance():getLine(TableName.LW_Shop, goodsId)
      if shopGoodsTemp and shopGoodsTemp.shop_id == CommonShopType.GiftShop and itemTemplate.type == 161 then
        EventManager:GetInstance():Broadcast(EventId.BuyCommonShopGoods_Gift)
      else
        UIUtil.ShowTipsId(120120)
        local msg = {
          reward = {}
        }
        table.insert(msg.reward, reward)
        DataCenter.RewardManager:ShowCommonReward(msg)
      end
    elseif t.resource_items then
      DataCenter.ResourceItemDataManager:RefreshItemList(t)
      local resource_items = t.resource_items
      local msg = {
        reward = {}
      }
      for i, v in ipairs(resource_items) do
        local _reward = {
          type = RewardType.RESOURCE_ITEM,
          value = {
            id = v.itemId,
            uuid = v.uuid,
            num = v.addNum
          }
        }
        table.insert(msg.reward, _reward)
      end
      DataCenter.RewardManager:ShowCommonReward(msg)
    elseif t.heroes and #t.heroes > 0 then
      for i, v in ipairs(t.heroes) do
        v.type = RewardType.HERO
        v.value = {
          heroId = v.heroId,
          uuid = v.uuid,
          num = 1
        }
        DataCenter.HeroDataManager:UpdateOneHero(v)
      end
      t.reward = {}
      t.reward = t.heroes
      DataCenter.RewardManager:ShowCommonReward(t)
      UIUtil.ShowTipsId(120120)
    elseif t.equipid then
      local msg = {
        reward = {}
      }
      msg.reward = {
        [1] = {
          type = RewardType.EQUIP,
          value = {
            id = t.equipid,
            num = t.add
          }
        }
      }
      DataCenter.RewardManager:ShowCommonReward(msg)
    end
    if t.buyLimit then
      DataCenter.CommonShopManager:UpdateOneGoodsInfo(nil, t.buyLimit, true)
    end
  end
end

BuyCommonShopGoodsMessage.OnCreate = OnCreate
BuyCommonShopGoodsMessage.HandleMessage = HandleMessage
return BuyCommonShopGoodsMessage
