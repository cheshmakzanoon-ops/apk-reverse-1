local DecorationShopDirectPurchaseManager = BaseClass("DecorationShopDirectPurchaseManager")

function DecorationShopDirectPurchaseManager:__init()
end

function DecorationShopDirectPurchaseManager:__delete()
end

function DecorationShopDirectPurchaseManager:GetDecorationShopInfo(type)
  if type == DirectPurchaseType.DecorationShopMainCity then
    return DataCenter.CommonShopManager:GetDecorationShopInfo(CommonShopType.DecorationShop)
  end
  return nil
end

function DecorationShopDirectPurchaseManager:GetCostItemId(type)
  local decorationShopInfo = self:GetDecorationShopInfo(type)
  if not decorationShopInfo then
    return 0
  end
  return decorationShopInfo.cost_item
end

function DecorationShopDirectPurchaseManager:GetFreeRewardId(type)
  local decorationShopInfo = self:GetDecorationShopInfo(type)
  if not decorationShopInfo then
    return 0
  end
  return decorationShopInfo.freeRewardId
end

function DecorationShopDirectPurchaseManager:GetCountDown(type)
  local decorationShopInfo = self:GetDecorationShopInfo(type)
  if not decorationShopInfo then
    return 0
  end
  local lastRefreshTime = decorationShopInfo.lastRefreshTime
  local cd = decorationShopInfo.cd
  return lastRefreshTime + cd * OneDayTime * 1000 - UITimeManager:GetInstance():GetServerTime()
end

function DecorationShopDirectPurchaseManager:GetCountDownOverAction(type)
  if type == DirectPurchaseType.DecorationShopMainCity then
    return function()
      SFSNetwork.SendMessage(MsgDefines.DecorationShopGiftRequestInfo)
    end
  end
  return nil
end

function DecorationShopDirectPurchaseManager:GetPackGroup(type)
  local decorationShopInfo = self:GetDecorationShopInfo(type)
  if not decorationShopInfo then
    return 0
  end
  return decorationShopInfo.exchangeGroupId
end

function DecorationShopDirectPurchaseManager:GetIfCanFreeReward(type)
  local decorationShopInfo = self:GetDecorationShopInfo(type)
  if not decorationShopInfo then
    return false
  end
  return decorationShopInfo.freeCount > 0
end

function DecorationShopDirectPurchaseManager:GetIconPath(type)
  local decorationShopInfo = self:GetDecorationShopInfo(type)
  if not decorationShopInfo then
    return 0
  end
  local costItem = decorationShopInfo.cost_item
  return DataCenter.ItemTemplateManager:GetIconPath(costItem)
end

function DecorationShopDirectPurchaseManager:GetId(type)
  local decorationShopInfo = self:GetDecorationShopInfo(type)
  if not decorationShopInfo then
    return 0
  end
  return decorationShopInfo.id
end

function DecorationShopDirectPurchaseManager:RequestGetFreeReward(id)
  SFSNetwork.SendMessage(MsgDefines.DecorationShopReceiveFreeReward, {id = id})
end

function DecorationShopDirectPurchaseManager:OnHandleFreeReward(msg)
  if msg.reward then
    DataCenter.RewardManager:AddRewards(msg.reward)
    DataCenter.RewardManager:ShowCommonReward(msg)
  end
  if msg.giftInfo then
    DataCenter.CommonShopManager:UpdateDecorationShopMessage(msg.giftInfo)
  end
end

function DecorationShopDirectPurchaseManager:GetGiftRefreshInfo(type, giftId)
  local decorationShopInfo = self:GetDecorationShopInfo(type)
  if not decorationShopInfo then
    return {}
  end
  return decorationShopInfo:GetRefreshInfo(giftId)
end

function DecorationShopDirectPurchaseManager:GetGiftFreeRefreshInfo(type)
  local decorationShopInfo = self:GetDecorationShopInfo(type)
  if not decorationShopInfo then
    return {}
  end
  return decorationShopInfo:GetFreeRefreshInfo()
end

function DecorationShopDirectPurchaseManager:GetPackIfNew(packId)
  return Setting:GetPrivateInt(SettingKeys.DecorationShopDirectPurchase_GIFT_NEW .. packId, 0) == 0
end

function DecorationShopDirectPurchaseManager:SetPackNotNew(packId)
  Setting:SetPrivateInt(SettingKeys.DecorationShopDirectPurchase_GIFT_NEW .. packId, 1)
end

function DecorationShopDirectPurchaseManager:GetTitleAndDesc(type)
  local decorationShopInfo = self:GetDecorationShopInfo(type)
  if not decorationShopInfo then
    return {}
  end
  return decorationShopInfo:GetTitleAndDesc()
end

function DecorationShopDirectPurchaseManager:GetGiftRefreshDateInfo(type)
  local decorationShopInfo = self:GetDecorationShopInfo(type)
  if not decorationShopInfo then
    return {}
  end
  return decorationShopInfo.giftRefreshType, decorationShopInfo.giftRefreshInfo
end

return DecorationShopDirectPurchaseManager
