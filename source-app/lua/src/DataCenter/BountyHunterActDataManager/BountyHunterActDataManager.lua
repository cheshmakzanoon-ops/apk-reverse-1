local BountyHunterActDataManager = BaseClass("BountyHunterActDataManager")
local Localization = CS.GameEntry.Localization
local BountyHunterActData = require("DataCenter.BountyHunterActDataManager.BountyHunterActData")
local Const = require("UI/UIActivityCenterTable/Component/ActBountyHunter/BountyHunterConstant")

local function __init(self)
  self:InitData()
end

local function __delete(self)
  self.allActDataDic = nil
end

function BountyHunterActDataManager:InitData()
  self.allActDataDic = {}
end

function BountyHunterActDataManager:UpdateActData(msg)
  if not msg.activityId then
    return
  end
  local activityId = toInt(msg.activityId)
  local actData = self.allActDataDic[activityId]
  if not actData then
    actData = BountyHunterActData.New()
    self.allActDataDic[activityId] = actData
  end
  actData:UpdateData(activityId, msg)
end

function BountyHunterActDataManager:GetActData(activityId)
  return self.allActDataDic[activityId]
end

function BountyHunterActDataManager:GetActRed(activityId)
  local actData = self:GetActData(activityId)
  if not actData then
    return 0
  end
  return actData:GetActRed()
end

function BountyHunterActDataManager:SendExchangeShopBuy(activityId, shopId, num)
  SFSNetwork.SendMessage(MsgDefines.BountyHunterBuyShopItem, {
    activityId = activityId,
    shopId = tostring(shopId),
    num = num
  })
end

function BountyHunterActDataManager:OnExchangeShopBuySuccess(msg)
  if msg == nil or table.IsNullOrEmpty(msg.reward) then
    return
  end
  DataCenter.RewardManager:AddRewardsAndRes(msg)
  DataCenter.RewardManager:ShowCommonReward(msg)
  if msg.shopChange and msg.activityId then
    local actData = self:GetActData(msg.activityId)
    if actData then
      actData:UpdateExchangeShopBuyTimes(msg.shopChange.id, msg.shopChange.buyTimes)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshCommonExchangeShopPanel)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function BountyHunterActDataManager:OnBountyHunterGetShopInfoSuccess(msg)
  if msg == nil or table.IsNullOrEmpty(msg.shopKey) then
    return
  end
  if msg.shopKey and msg.activityId then
    local actData = self:GetActData(msg.activityId)
    if actData then
      for _, shopInfo in ipairs(msg.shopKey) do
        actData:UpdateExchangeShopBuyTimes(shopInfo.id, shopInfo.buyTimes)
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshCommonExchangeShopPanel)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function BountyHunterActDataManager:UpdateDailyRewardData(message)
  local activityId = message.activityId
  if self.allActDataDic[activityId] == nil then
    return
  end
  self.allActDataDic[activityId]:UpdateDailyRewardData(message)
end

function BountyHunterActDataManager:ShowHunterLog(info)
  if CS.UnityEngine.Application.isEditor and Const.IS_SHOW_SCENE_DEBUG_LOG then
    Logger.LogCustom(string.format("[bounty hunter] %s", info))
  end
end

BountyHunterActDataManager.__init = __init
BountyHunterActDataManager.__delete = __delete
return BountyHunterActDataManager
