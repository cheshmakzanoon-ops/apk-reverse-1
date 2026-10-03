local ActBlackMarketDataManager = BaseClass("ActBlackMarketDataManager")
local ActBlackMarketInfo = require("DataCenter.ActBlackMarketDataManager.ActBlackMarketInfo")

function ActBlackMarketDataManager:__init()
  self.actDetails = {}
end

function ActBlackMarketDataManager:__delete()
  if self.hasAddListener then
    self:RemoveListener()
  end
end

function ActBlackMarketDataManager:AddListener()
  if not self.hasAddListener then
    self.hasAddListener = true
  end
end

function ActBlackMarketDataManager:RemoveListener()
  if self.hasAddListener then
    self.hasAddListener = false
  end
end

function ActBlackMarketDataManager:ParseActInfoMessage(msg)
  if not msg then
    return
  end
  local actId
  if msg.id then
    actId = msg.id
  elseif msg.activityId then
    actId = msg.activityId
  end
  if not actId then
    return
  end
  actId = tostring(actId)
  local actInfo = self.actDetails[actId]
  if not self.actDetails[actId] then
    actInfo = ActBlackMarketInfo.New()
    self.actDetails[actId] = actInfo
  end
  actInfo:ParseData(msg)
  self:AddListener()
  EventManager:GetInstance():Broadcast(EventId.BlackMarketInfoUpdate, actId)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ActBlackMarketDataManager:GetActDetail(aid)
  return self.actDetails[tostring(aid)]
end

function ActBlackMarketDataManager:TryExchangeItem(aid, productId, count)
  local actInfo = self:GetActDetail(aid)
  if not actInfo then
    return
  end
  local product = actInfo:GetProductInfo(productId)
  if not product then
    return
  end
  local productUuid = product.shopUuid
  local needItemId = product.costItem or 0
  local needItemNum = product.costNum or 0
  if 0 < needItemId and 0 < needItemNum then
    local haveCount = DataCenter.ItemData:GetItemCount(needItemId)
    if needItemNum > haveCount then
      return
    end
  end
  if product.num + count > product.buyTimeLimit then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.BlackMarketBuy, tonumber(aid), productUuid, count)
end

function ActBlackMarketDataManager:OnItemBought(msg)
  if not msg then
    return
  end
  local actId = msg.activityId
  if not actId then
    return
  end
  local actInfo = self:GetActDetail(actId)
  if not actInfo then
    return
  end
  actInfo:UpdateProductRemainTimes(msg.shopUuid, msg.buyTimes, msg.buyTimeLimit)
  EventManager:GetInstance():Broadcast(EventId.BlackMarketInfoUpdate, actId)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ActBlackMarketDataManager:TryRequestRefresh(actId)
  if not actId then
    return
  end
  local detailInfo = self:GetActDetail(actId)
  if not detailInfo then
    return
  end
  local actBaseInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tonumber(actId))
  if not actBaseInfo then
    return
  end
  local remainRefreshTimes = detailInfo:GetRefreshRemainCount()
  if remainRefreshTimes <= 0 then
    return
  end
  local cost = detailInfo:GetRefreshCost()
  local haveDiamond = CommonUtil.GetResOrItemCount(ResourceType.Gold)
  if cost > haveDiamond then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.BlackMarketRefresh, tonumber(actId))
end

function ActBlackMarketDataManager:GetRedPoint(aid)
  local actInfo = self:GetActDetail(aid)
  if not actInfo then
    return 0
  end
  return 0
end

function ActBlackMarketDataManager:GetOpenActRemainRefreshCount()
  local actId = DataCenter.ActivityListDataManager:GetOpenIdByType(EnumActivity.BlackMarket.Type)
  if actId and tonumber(actId) > 0 then
    local detailInfo = DataCenter.ActBlackMarketDataManager:GetActDetail(actId)
    if detailInfo then
      return detailInfo:GetRefreshRemainCount()
    end
  end
  return 0
end

function ActBlackMarketDataManager:OnActPassDay(actInfo)
  if not actInfo then
    return
  end
  DataCenter.BuildManager:RefreshBuildingStateByType(BuildingTypes.LW_BUILD_BLACKMARKET)
  if actInfo:IsValid() then
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.BlackMarket)
  end
end

return ActBlackMarketDataManager
