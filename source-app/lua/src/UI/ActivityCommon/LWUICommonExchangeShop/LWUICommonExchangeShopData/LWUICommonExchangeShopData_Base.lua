local LWUICommonExchangeShopData_Base = BaseClass("LWUICommonExchangeShopData_Base")
local Localization = CS.GameEntry.Localization

function LWUICommonExchangeShopData_Base:__init()
end

function LWUICommonExchangeShopData_Base:__delete()
end

function LWUICommonExchangeShopData_Base:GetRewardData()
  return nil
end

function LWUICommonExchangeShopData_Base:GetCostRewardData()
  return nil
end

function LWUICommonExchangeShopData_Base:GetBackgroundImage()
end

function LWUICommonExchangeShopData_Base:GetExchangedTimes()
  return 0
end

function LWUICommonExchangeShopData_Base:GetExchangeBtnText()
end

function LWUICommonExchangeShopData_Base:GetExchangeTimesLimit()
  return 0
end

function LWUICommonExchangeShopData_Base:GetExchangeTimesLeft()
  local limit = self:GetExchangeTimesLimit()
  if limit < 0 then
    return -1
  end
  local exchangedTimes = self:GetExchangedTimes()
  return limit - exchangedTimes
end

function LWUICommonExchangeShopData_Base:GetExchangeTimesText()
end

function LWUICommonExchangeShopData_Base:GetTagTextYellow()
end

function LWUICommonExchangeShopData_Base:GetTagTextRed()
end

function LWUICommonExchangeShopData_Base:GetTagTextPurple()
end

function LWUICommonExchangeShopData_Base:IsShowCost()
  return true
end

function LWUICommonExchangeShopData_Base:GetSoldText()
end

function LWUICommonExchangeShopData_Base:GetCostData()
end

function LWUICommonExchangeShopData_Base:GetCostItemImage()
  local costData = self:GetCostData()
  if costData then
    return DataCenter.RewardManager:GetPicByType(RewardType.GOODS, checknumber(costData.itemId))
  end
end

function LWUICommonExchangeShopData_Base:GetCostItemCountText()
  local costData = self:GetCostData()
  if costData then
    local curNum = DataCenter.ItemData:GetItemCount(checknumber(costData.itemId))
    local showStr = ""
    if curNum >= costData.count then
      showStr = costData.count
    else
      showStr = string.format("<color=#dd2828> %s</color>", costData.count)
    end
    return showStr
  else
    return Localization:GetString("total_mobilization_desc16")
  end
end

function LWUICommonExchangeShopData_Base:GetBuyConditions()
end

function LWUICommonExchangeShopData_Base:GetInconsistentConditions()
  local conditions = self:GetBuyConditions()
  return DataCenter.RewardManager:GetInconsistentBuyConditions(conditions)
end

function LWUICommonExchangeShopData_Base:GetBuyConditionText()
  local inconsistentConditions = self:GetInconsistentConditions()
  if not table.IsNullOrEmpty(inconsistentConditions) then
    return DataCenter.RewardManager:ConvertBuyConditionToText(inconsistentConditions[1])
  end
end

function LWUICommonExchangeShopData_Base:IsShowMask()
  return false
end

function LWUICommonExchangeShopData_Base:OnExchangeClick()
  local inconsistentConditions = self:GetInconsistentConditions()
  if not table.IsNullOrEmpty(inconsistentConditions) then
    return
  end
  local reward = self:GetRewardData()
  if reward == nil then
    return
  end
  local param = {}
  param.goodsInfo = {}
  param.goodsInfo.rewardType = reward.rewardType
  param.goodsInfo.itemId = reward.itemId
  param.goodsInfo.count = reward.count
  local limitTimes = self:GetExchangeTimesLimit()
  local isTimeLimit = 0 <= limitTimes
  if isTimeLimit then
    param.goodsInfo.limitCount = self:GetExchangeTimesLeft()
    if 0 >= self:GetExchangeTimesLeft() then
      UIUtil.ShowTipsId("season_s3_activity_1000072_desc51")
      return
    end
  else
    param.goodsInfo.limitCount = -1
  end
  param.consumeInfo = {}
  local cost = self:GetCostData()
  local isFree = cost == nil
  if not isFree then
    local curNum = DataCenter.ItemData:GetItemCount(cost.itemId)
    if curNum < checknumber(cost.count) * 1 then
      local need = checknumber(cost.count) * 1 - curNum
      LWResourceLackUtil:GotoGoodsItemLack(cost.itemId, need, nil, function()
        EventManager:GetInstance():Broadcast(EventId.RefreshCommonExchangeShopPanel)
      end)
      return
    end
  end
  if isFree then
    param.goodsInfo.eachPrice = 0
  else
    local costNum = cost.count
    local costId = cost.itemId
    param.goodsInfo.eachPrice = costNum
    param.consumeInfo.currencyType = RewardType.GOODS
    param.consumeInfo.currencyId = costId
  end
  
  function param.callback(exchangeCount)
    self:ProcessExchange(exchangeCount)
  end
  
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIMultiBuy, {anim = true}, param)
end

function LWUICommonExchangeShopData_Base:ProcessExchange(exchangeCount)
  local costData = self:GetCostData()
  local isFree = costData == nil or costData.count <= 0
  if not isFree then
    local curNum = DataCenter.ItemData:GetItemCount(costData.itemId)
    if curNum < checknumber(costData.count) * exchangeCount then
      UIUtil.ShowTipsId(GameDialogDefine.NO_ITEM)
      return
    end
  end
  self:SendExchangeMessage(exchangeCount)
end

function LWUICommonExchangeShopData_Base:SendExchangeMessage(exchangeCount)
end

return LWUICommonExchangeShopData_Base
