local SeasonTradeShopDataManager = BaseClass("SeasonTradeShopDataManager")
local TradeData = require("DataCenter.SeasonManager.Trade.TradeData")
local TradeRedPacketData = require("DataCenter.SeasonManager.Trade.TradeRedPacketData")
local MyInsert = table.insert
local MyTbNull = table.IsNullOrEmpty
local MyStr2Array = string.string2array_i_oneSep
local __ConfigKey = {
  [SeasonMapType.NineNation] = "s5_trading_post_shop",
  [SeasonMapType.Darkness] = "s4_trading_post_shop",
  [SeasonMapType.Mummy] = "s3_trading_post_shop",
  [SeasonMapType.NineNationRainforest] = "s6_trading_post_shop"
}

function SeasonTradeShopDataManager:__init()
  self.templates = nil
  self.curTrade = TradeData.New()
  self.redPackets = {}
  self.shopGoodsList = {}
end

function SeasonTradeShopDataManager:__delete()
  self.templates = nil
  self.curTrade = nil
  self.redPackets = {}
  self.shopGoodsList = {}
end

local function SortShopGoods(a, b)
  return a.order < b.order
end

function SeasonTradeShopDataManager:InitTemplate()
  self.templates = {}
  LocalController:instance():visitTable("season_trading_post_shop", function(id, lineData)
    local shop_id = lineData:getIntValue("shop_id")
    local list = self.templates[shop_id] or {}
    local item = {}
    item.id = id
    local itemId = lineData:getIntValue("goods")
    if itemId == 0 then
      item.rewardType = RewardType.RESOURCE_ITEM
      item.itemId = lineData:getIntValue("resourceitem_id")
      item.count = lineData:getIntValue("resourceitem_num")
      item.itemName = DataCenter.ResourceItemDataManager:GetName(item.itemId)
    else
      item.rewardType = RewardType.GOODS
      item.itemId = itemId
      item.count = lineData:getIntValue("goods_num")
      local goods = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
      item.itemName = DataCenter.ItemTemplateManager:GetName(itemId)
    end
    local currency = MyStr2Array(lineData:getValue("currency"), ";")
    item.currency_type = currency[1]
    item.currency_id = currency[2]
    item.currency_num = lineData:getIntValue("currency_num")
    item.cycle_times = lineData:getIntValue("cycle_times")
    item.goods_num = lineData:getIntValue("goods_num")
    item.order = lineData:getIntValue("order")
    item.exclusive_flag = lineData:getIntValue("exclusive_flag") == 1
    item.level_low = lineData:getIntValue("level_low")
    item.daily_limit = lineData:getIntValue("daily_limit")
    MyInsert(list, item)
    self.templates[shop_id] = list
  end)
  for _, v in pairs(self.templates) do
    table.sort(v, SortShopGoods)
  end
end

function SeasonTradeShopDataManager:GetItemsByShopId(shopId)
  if MyTbNull(self.templates) then
    self:InitTemplate()
  end
  return self.templates[shopId] or {}
end

function SeasonTradeShopDataManager:GetShopType()
  if DataCenter.BloodyNightDataManager:IsBloodyNight() then
    return TradeShopType.NIGHT
  end
  return TradeShopType.NORMAL
end

function SeasonTradeShopDataManager:GetTradePostShopValue(key, default)
  local seasonType = SeasonUtil.GetSeasonType(true, true)
  local key1 = __ConfigKey[seasonType] or __ConfigKey[SeasonMapType.Mummy]
  if self:GetShopType() == TradeShopType.NIGHT then
    key = "k8"
  end
  return LuaEntry.DataConfig:TryGetNum(key1, key, default or 0)
end

function SeasonTradeShopDataManager:InitAssignationRedPacketData(obj)
  local array = obj ~= nil and obj.assignationRedPacketArray or nil
  if array == nil then
    return
  end
  self.redPackets = {}
  for _, v in ipairs(array) do
    self:HandleOneRedPacket(v, false)
  end
end

function SeasonTradeShopDataManager:GetRedPacketList()
  return self.redPackets
end

function SeasonTradeShopDataManager:SetRedPackRedDot()
  for _, v in ipairs(self.redPackets) do
    v:SetNewCount(0)
  end
end

function SeasonTradeShopDataManager:GetRedPackRedDot()
  local cnt = 0
  for _, v in ipairs(self.redPackets) do
    cnt = cnt + v.newCount
  end
  return cnt
end

function SeasonTradeShopDataManager:HandleOneRedPacket(obj, notify)
  local data = TradeRedPacketData.New()
  data:ParseData(obj)
  table.insert(self.redPackets, data)
  if notify then
    UIUtil.ShowTipsId("season_s3_activity_1000072_desc55")
  end
end

function SeasonTradeShopDataManager:ReqUseRedPacket(uuid, chatType, copy, copyChatType)
  SFSNetwork.SendMessage(MsgDefines.UseAssignRedPacketMessage, uuid, chatType, copy, copyChatType)
end

function SeasonTradeShopDataManager:HandleUseRedPacket(obj)
  local uuid = obj.redPacketUuid
  if uuid then
    for i, v in ipairs(self.redPackets) do
      if v.uuid == uuid then
        table.remove(self.redPackets, i)
        break
      end
    end
  end
  if obj.itemEffectObj and obj.itemEffectObj.redPackets then
    DataCenter.RedPacketManager:UpdateRedPacket(obj.itemEffectObj)
  elseif obj.reward then
    DataCenter.RewardManager:AddRewardsAndRes(obj)
  end
  local item = DataCenter.ItemData:GetItemById(obj.itemId)
  if item ~= nil then
    EventManager:GetInstance():Broadcast(EventId.CLICK_RESOURCE_ITEM)
  else
    EventManager:GetInstance():Broadcast(EventId.REFRESH_RESOURCE_BAG)
  end
end

function SeasonTradeShopDataManager:ReqTradeDetail(tradeId, serverId)
  SFSNetwork.SendMessage(MsgDefines.GetTradeDetailMessage, tradeId, serverId)
end

function SeasonTradeShopDataManager:HandleTradeInfo(obj, notify)
  local info = obj ~= nil and obj.worldCityTradeInfo or nil
  if info == nil then
    return
  end
  self.curTrade:ParseData(info)
  if notify then
    EventManager:GetInstance():Broadcast(EventId.GetTradeDetail, self.curTrade)
  end
end

function SeasonTradeShopDataManager:CleanShopInfo()
  self.shopGoodsList = {}
  self.buyNumber = nil
  self.buyRefreshTime = nil
end

function SeasonTradeShopDataManager:EnterShop(tradeId, serverId)
  local sId = serverId == nil and LuaEntry.Player:GetCurServerId() or serverId
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonTradeShop, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, tradeId, sId)
end

function SeasonTradeShopDataManager:ReqTradeShopGoodsInfo(tradeId, serverId, shopType)
  SFSNetwork.SendMessage(MsgDefines.GetTradeShopGoodsInfoMessage, tradeId, serverId, shopType)
end

function SeasonTradeShopDataManager:NotifyServerCloseShopUI(tradeId, serverId)
  SFSNetwork.SendMessage(MsgDefines.LeaveTradeShopMessage, tradeId, serverId)
end

function SeasonTradeShopDataManager:HandleShopGoodsInfo(obj)
  local array = obj ~= nil and obj.goodsArray or nil
  if array == nil then
    return
  end
  local list = {}
  for _, v in ipairs(array) do
    list[v.configId] = DeepCopy(v)
  end
  self.shopGoodsList = list
  self.shopType = obj.shopType
  self.buyNumber = obj.buyNumber
  self.buyRefreshTime = obj.buyRefreshTime
  self.nextRefreshLimitTime = obj.nextRefreshLimitTime
  EventManager:GetInstance():Broadcast(EventId.GetTradeShopGoodsInfo)
end

function SeasonTradeShopDataManager:HandlePushUpdateTradeShopGoodsInfo(t)
  if LuaEntry.Player:GetCurServerId() == t.serverId and LuaEntry.Player:GetCurWorldId() == t.worldId and t.tradeId == self.curTrade.tradeId then
    local data = self.shopGoodsList[t.configId]
    if data then
      data.exchangeNum = t.exchangeNum
      EventManager:GetInstance():Broadcast(EventId.GetTradeShopGoodsInfo, t.configId)
    end
  end
end

function SeasonTradeShopDataManager:GetShopGoodsExchangeNum(configId)
  local goodsInfo = self.shopGoodsList[configId]
  return goodsInfo and goodsInfo.exchangeNum or -1, goodsInfo and goodsInfo.selfBuyNum or 0
end

function SeasonTradeShopDataManager:ReqTradeShopGoodsExchange(tradeId, configId, num, serverId, shopType)
  self.preExchangeNum = num
  SFSNetwork.SendMessage(MsgDefines.TradeShopGoodsExchangeMessage, tradeId, configId, num, serverId, shopType)
end

function SeasonTradeShopDataManager:HandleTradeShopGoodsExchange(obj)
  if obj.remainGold ~= nil then
    LuaEntry.Player.gold = obj.remainGold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
  local reward = obj ~= nil and obj.reward or nil
  if reward == nil then
    return
  end
  local configId = obj.configId
  local info = self.shopGoodsList[configId] or {}
  info.shopType = obj.shopType
  info.selfBuyNum = obj.selfBuyNum
  info.exchangeNum = obj.exchangeNum
  self.shopGoodsList[configId] = info
  self.buyNumber = (self.buyNumber or 0) + self.preExchangeNum
  EventManager:GetInstance():Broadcast(EventId.GetTradeShopGoodsInfo, configId)
  DataCenter.RewardManager:AddRewards(reward)
  DataCenter.RewardManager:ShowCommonReward(obj)
end

local GOLD_PATH = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_gold.png"
local PREFAB_PATH = "Assets/Main/SeasonRes/Shared/Prefabs/UI/TradeStation/ThumbsUpMessageTip.prefab"

function SeasonTradeShopDataManager:HandleWorldTradeExchangeInfo(obj)
  if obj == nil or CS.SceneManager.World == nil then
    return
  end
  local sender = {
    uid = obj.uid,
    pic = obj.pic,
    picVer = obj.picVer,
    headSkinId = obj.headSkinId,
    headSkinET = obj.headSkinET
  }
  local str = CS.GameEntry.Localization:GetString("season_s3_trading_post_desc10")
  local exStr = "\195\151" .. toInt(obj.costGold)
  local iconPath = GOLD_PATH
  local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(obj.tradeId, obj.serverId)
  local shopId = cityTemplate ~= nil and cityTemplate:GetShopId()
  local list = shopId and DataCenter.SeasonTradeShopDataManager:GetItemsByShopId(shopId)
  local item = list and list[1]
  if item then
    iconPath = CommonUtil.GetResOrItemIcon(item.currency_id)
  end
  UIUtil.ShowThumbsUpBroadcastPopUI(obj.serverId, obj.pointId, sender, str, iconPath, PREFAB_PATH, exStr)
end

function SeasonTradeShopDataManager:ReqTradeShopRefreshGoods(tradeId, shopType)
  SFSNetwork.SendMessage(MsgDefines.TradeShopRefreshGoodsMessage, tradeId, shopType)
end

function SeasonTradeShopDataManager:HandleTradeShopRefreshGoods(obj)
  if obj == nil then
    return
  end
  if obj.shopRefreshNum then
    self.curTrade:SetShopRefreshNum(obj.shopRefreshNum, obj.shopType)
  end
  if obj.shopState then
    self.curTrade:SetShopState(obj.shopState, obj.shopType)
  end
  UIUtil.ShowTipsId("season_s3_activity_1000072_desc56")
end

return SeasonTradeShopDataManager
