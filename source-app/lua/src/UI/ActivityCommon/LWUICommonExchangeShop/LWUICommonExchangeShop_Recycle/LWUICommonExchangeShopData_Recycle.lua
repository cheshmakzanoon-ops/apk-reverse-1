local base = require("UI/ActivityCommon/LWUICommonExchangeShop/LWUICommonExchangeShopData/LWUICommonExchangeShopData_Base")
local LWUICommonExchangeShopData_Recycle = BaseClass("LWUICommonExchangeShopData_Recycle", base)
local Localization = CS.GameEntry.Localization
local RewardUtil = require("Util.RewardUtil")

function LWUICommonExchangeShopData_Recycle:__init(id, activityId)
  self.id = id
  self.activityId = activityId
  self.template = DataCenter.ActRecycleManager:GetActivityCycleShopTemplateById(self.id)
end

function LWUICommonExchangeShopData_Recycle:__delete()
  self.id = nil
  self.activityId = nil
end

function LWUICommonExchangeShopData_Recycle:GetRewardData()
  if self.template then
    local res = RewardUtil.GetRewardItem(self.template.reward_id)
    return res[1]
  end
end

function LWUICommonExchangeShopData_Recycle:GetCostRewardData()
  return self:GetCostData()
end

function LWUICommonExchangeShopData_Recycle:GetExchangedTimes()
  local actData = DataCenter.ActRecycleManager:GetData(self.activityId)
  if actData then
    local shopServerData = actData:GetShopServerData(self.id)
    if shopServerData then
      return checknumber(shopServerData.curNum)
    end
  end
  return 0
end

function LWUICommonExchangeShopData_Recycle:GetExchangeBtnText()
  if self.activityId ~= nil then
    local actData = DataCenter.ActRecycleManager:GetData(self.activityId)
    if actData then
      local shopServerData = actData:GetShopServerData(self.id)
      if shopServerData then
        if shopServerData.shopType == 1 then
          return Localization:GetString("activity_99165_train1_6_btn")
        elseif shopServerData.shopType == 2 then
          return Localization:GetString("activity_99165_train2_2_btn")
        end
      end
    end
  end
  return Localization:GetString("activity_99165_train1_6_btn")
end

function LWUICommonExchangeShopData_Recycle:GetExchangeTimesLimit()
  local actData = DataCenter.ActRecycleManager:GetData(self.activityId)
  if actData then
    local shopServerData = actData:GetShopServerData(self.id)
    if shopServerData then
      return checknumber(shopServerData.buyTimeLimit)
    end
  end
  return 0
end

function LWUICommonExchangeShopData_Recycle:GetExchangeTimesLeft()
  local limit = self:GetExchangeTimesLimit()
  if limit < 0 then
    return -1
  end
  local exchangedTimes = self:GetExchangedTimes()
  return limit - exchangedTimes
end

function LWUICommonExchangeShopData_Recycle:GetExchangeTimesText()
  if self.template == nil then
    return nil
  end
  local limit = self:GetExchangeTimesLimit()
  if 0 < limit then
    local curTime = self:GetExchangedTimes()
    return Localization:GetString("activity_99165_train1_5_task", limit - curTime)
  end
end

function LWUICommonExchangeShopData_Recycle:IsSoldOut()
  local limit = self:GetExchangeTimesLimit()
  local isLimit = 0 < limit
  if isLimit and 0 >= self:GetExchangeTimesLeft() then
    return true
  end
  return false
end

function LWUICommonExchangeShopData_Recycle:GetCostData()
  if self.template == nil then
    return nil
  end
  return self.template:GetCost()
end

function LWUICommonExchangeShopData_Recycle:GetCostCurCount()
  local cost = self:GetCostData()
  if cost == nil then
    return 0
  end
  if cost.rewardType == RewardType.GOODS then
    return DataCenter.ItemData:GetItemCount(cost.itemId)
  elseif cost.rewardType == RewardType.RESOURCE_ITEM then
    return DataCenter.ResourceItemDataManager:GetCountByItemId(cost.itemId)
  elseif RewardToResType[cost.rewardType] then
    return LuaEntry.Resource:GetCntByResType(RewardToResType[cost.rewardType])
  end
  return 0
end

function LWUICommonExchangeShopData_Recycle:OnExchangeClick()
  local reward = self:GetRewardData()
  if reward == nil then
    return
  end
  local cost = self:GetCostData()
  if cost == nil then
    return
  end
  local actData = DataCenter.ActRecycleManager:GetData(self.activityId)
  if not actData then
    return
  end
  local shopServerData = actData:GetShopServerData(self.id)
  if not shopServerData then
    return
  end
  local param = {}
  param.reward = reward
  param.activityId = self.activityId
  local limitTimes = self:GetExchangeTimesLimit()
  local isTimeLimit = 0 < limitTimes
  if isTimeLimit then
    param.leftExchangeTime = self:GetExchangeTimesLeft()
    if 0 >= param.leftExchangeTime then
      if shopServerData.shopType == 1 then
        UIUtil.ShowTipsId("activity_99165_tips_2")
      else
        UIUtil.ShowTipsId("activity_99165_tips_4")
      end
      return
    end
  else
    param.leftExchangeTime = nil
  end
  param.cost = cost
  local curNum = self:GetCostCurCount()
  if curNum < checknumber(cost.count) * 1 then
    local costNum = checknumber(cost.count) * 1
    local need = costNum - curNum
    if cost.rewardType == RewardType.GOODS then
      LWResourceLackUtil:GotoGoodsItemLack(cost.itemId, costNum, nil, function()
        EventManager:GetInstance():Broadcast(EventId.RefreshCommonExchangeShopPanel)
      end)
    elseif cost.rewardType == RewardType.RESOURCE_ITEM then
      LWResourceLackUtil:GotoResourceItemLack(cost.itemId, costNum)
    elseif RewardToResType[cost.rewardType] then
      LWResourceLackUtil:GotoResLack({
        {
          resType = RewardToResType[cost.rewardType],
          need = costNum
        }
      })
    end
    return
  end
  
  function param.callback(exchangeCount)
    self:ProcessExchange(exchangeCount)
  end
  
  param.shop_type = shopServerData.shopType
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActRecycleExchangeConfirm, {anim = true}, param)
end

function LWUICommonExchangeShopData_Recycle:ProcessExchange(exchangeCount)
  local costData = self:GetCostData()
  local isFree = costData == nil or costData.count <= 0
  if not isFree then
    local curNum = self:GetCostCurCount()
    if curNum < checknumber(costData.count) * exchangeCount then
      UIUtil.ShowTipsId(GameDialogDefine.NO_ITEM)
      return
    end
  end
  local reward = self:GetRewardData()
  if reward == nil then
    return
  end
  local actData = DataCenter.ActRecycleManager:GetData(self.activityId)
  if not actData then
    return
  end
  local shopServerData = actData:GetShopServerData(self.id)
  if shopServerData and shopServerData.shopType == 1 then
    local getRewardCount = reward.count * exchangeCount
    local todayNum = actData:GetExchangeDailyLimitTodayNum()
    local totalNum = actData:GetExchangeDailyLimitTotalNum()
    if totalNum < todayNum + getRewardCount then
      UIUtil.ShowTipsId("activity_99165_tips_1")
      return
    end
  end
  self:SendExchangeMessage(exchangeCount)
end

function LWUICommonExchangeShopData_Recycle:SendExchangeMessage(exchangeCount)
  if self.activityId ~= nil then
    local actData = DataCenter.ActRecycleManager:GetData(self.activityId)
    if actData then
      local shopServerData = actData:GetShopServerData(self.id)
      if shopServerData then
        if shopServerData.shopType == 1 then
          DataCenter.ActRecycleManager:SendExchangeShopConsume(self.activityId, self.id, exchangeCount)
        elseif shopServerData.shopType == 2 then
          DataCenter.ActRecycleManager:SendExchangeShopBuy(self.activityId, self.id, exchangeCount)
        end
      end
    end
  end
end

function LWUICommonExchangeShopData_Recycle:IsShowRed()
  local curBuy = self:GetExchangedTimes()
  local maxBuy = self:GetExchangeTimesLimit()
  local isTimeLimit = 0 < maxBuy
  local canBuy = not isTimeLimit or 0 < maxBuy - curBuy
  if canBuy then
    local actData = DataCenter.ActRecycleManager:GetData(self.activityId)
    if not actData then
      return false
    end
    local shopType = self:GetShopType()
    if shopType == 1 then
      local reward = self:GetRewardData()
      if reward == nil then
        return false
      end
      local getRewardCount = reward.count * 1
      local todayNum = actData:GetExchangeDailyLimitTodayNum()
      local totalNum = actData:GetExchangeDailyLimitTotalNum()
      if totalNum < todayNum + getRewardCount then
        return false
      end
    end
    local costData = self:GetCostData()
    local isFree = costData == nil or 0 >= costData.count
    if isFree then
      return true
    else
      local curNum = self:GetCostCurCount()
      if curNum >= checknumber(costData.count) then
        return true
      end
    end
  end
  return false
end

function LWUICommonExchangeShopData_Recycle:GetDisplayOrder()
  if self.template then
    return self.template.display_order
  end
  return 0
end

function LWUICommonExchangeShopData_Recycle:GetArrowImagePath()
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if activityInfo == nil then
    return UIAssets.ActRecycleExchangeArrowDefaultImage
  end
  local mainTemplate = DataCenter.ActRecycleManager:GetActivityCycleTemplateById(activityInfo.subType)
  if mainTemplate == nil then
    return UIAssets.ActRecycleExchangeArrowDefaultImage
  end
  return mainTemplate.res_aro
end

function LWUICommonExchangeShopData_Recycle:GetShopType()
  local actData = DataCenter.ActRecycleManager:GetData(self.activityId)
  if not actData then
    return nil
  end
  local shopServerData = actData:GetShopServerData(self.id)
  if shopServerData then
    return shopServerData.shopType
  end
end

function LWUICommonExchangeShopData_Recycle:GetTagTextYellow()
  if self.template == nil then
    return nil
  end
  local tagIndex = checknumber(self.template.extra_display)
  if tagIndex == 1 then
    return Localization:GetString("activity_convert_tipstype2")
  end
end

function LWUICommonExchangeShopData_Recycle:GetTagTextRed()
  if self.template == nil then
    return nil
  end
  local tagIndex = checknumber(self.template.extra_display)
  if tagIndex == 2 then
    return Localization:GetString("activity_hunter_shoptips1")
  end
end

return LWUICommonExchangeShopData_Recycle
