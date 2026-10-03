local SeasonBountyShopData = BaseClass("SeasonBountyShopData")

function SeasonBountyShopData:__init()
  self:InitVars()
end

function SeasonBountyShopData:__delete()
  self:Reset()
end

function SeasonBountyShopData:InitVars()
  self.ConditionType = {S6MilitaryLevel = 1}
end

function SeasonBountyShopData:Reset()
  self.ShopCell = nil
  self.Record = nil
end

function SeasonBountyShopData:InitData(shopId, actStartTime)
  self.ActStartTime = actStartTime
  self.ShopCell = LocalController:instance():getLine(TableName.SEASON_BOUNTY_SHOP, shopId)
  local costId, costNum = string._split_ss(self.ShopCell.currency, ";")
  self.CostId = costId
  self.CostNum = checknumber(costNum)
  local rewardId, rewardNum = string._split_ss(self.ShopCell.product, ";")
  self.RewardNum = checknumber(rewardNum)
  self.ProductType = checknumber(self.ShopCell.product_type)
  self.RewardType = RewardType.GOODS
  if self.ProductType == DataCenter.SeasonBountyShopManager.ProductType.RES or self.ProductType == DataCenter.SeasonBountyShopManager.ProductType.TITLE then
    self.RewardType = RewardType.RESOURCE_ITEM
  end
  self.ShowId = rewardId
  if checknumber(self.ShopCell.product_type) == DataCenter.SeasonBountyShopManager.ProductType.TITLE then
    local titleCell = LocalController:instance():getLine(TableName.LW_TITLE, rewardId)
    if titleCell ~= nil then
      self.ShowId = titleCell.connect_resource_item
    end
  end
end

function SeasonBountyShopData:GetName()
  if self.RewardType == RewardType.GOODS then
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.ShowId)
    if goods ~= nil then
      return DataCenter.ItemTemplateManager:GetName(goods.id)
    else
      return GetTableData(TableName.Resource, self.ShowId, "name")
    end
  elseif self.RewardType == RewardType.RESOURCE_ITEM then
    local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(self.ShowId)
    if template then
      return CS.GameEntry.Localization:GetString(template.name)
    end
  end
  return ""
end

function SeasonBountyShopData:IsValid()
  if self.ShopCell ~= nil then
    return true
  end
  return false
end

function SeasonBountyShopData:UpdateRecord(record)
  self.Record = record
end

function SeasonBountyShopData:GetOpenTime()
  if self:IsValid() then
    local openTimeOffset = checknumber(self.ShopCell.open_time) * 1000
    return openTimeOffset + self.ActStartTime
  end
  return LongMaxValue
end

function SeasonBountyShopData:IsOpen()
  if self:IsValid() then
    local now = UITimeManager:GetInstance():GetServerTime()
    local openTime = self:GetOpenTime()
    return now >= openTime, openTime
  end
  return false
end

function SeasonBountyShopData:GetNextRefreshTime()
  local isOpen, openTime = self:IsOpen()
  if not isOpen then
    return LongMaxValue
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local cycleTime = checknumber(self.ShopCell.refresh_time) * 1000
  return math.ceil((now - openTime) / cycleTime) * cycleTime + openTime
end

function SeasonBountyShopData:GetCycleStartTime()
  local startTime = self:GetOpenTime()
  local now = UITimeManager:GetInstance():GetServerTime()
  if startTime <= now then
    local cycleTime = checknumber(self.ShopCell.refresh_time) * 1000
    return startTime + math.floor((now - startTime) / cycleTime) * cycleTime
  end
  return startTime
end

function SeasonBountyShopData:GetCurCycleCount()
  local isOpen, openTime = self:IsOpen()
  if not isOpen then
    return 1
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local cycleTime = checknumber(self.ShopCell.refresh_time) * 1000
  return math.floor((now - openTime) / cycleTime) + 1
end

function SeasonBountyShopData:GetCurrencyColor()
  local itemEnough, _ = self:ItemEnough()
  if itemEnough then
    return WhiteColor
  else
    return RedColor
  end
end

function SeasonBountyShopData:ItemEnough()
  local curNum = DataCenter.ItemData:GetItemCount(self.CostId)
  return curNum >= self.CostNum, self.CostNum - curNum
end

function SeasonBountyShopData:GetBuyTimeInCycle()
  if self.Record == nil then
    return 0
  end
  if self:IsValid() then
    if self.ShopCell.add == 1 then
      return checknumber(self.Record.num)
    else
      local cycleStartTime = self:GetCycleStartTime()
      if cycleStartTime <= checknumber(self.Record.refreshTime) then
        return checknumber(self.Record.num)
      end
    end
  end
  return 0
end

function SeasonBountyShopData:GetTotalBuyTimes()
  if not self:IsValid() then
    return 0
  end
  local totalTimes = checknumber(self.ShopCell.buying_limit)
  if self.ShopCell.add == 1 then
    totalTimes = totalTimes * self:GetCurCycleCount()
  end
  return totalTimes
end

function SeasonBountyShopData:GetLeftBuyTimes()
  if self:IsValid() then
    return self:GetTotalBuyTimes() - self:GetBuyTimeInCycle()
  end
  return 0
end

function SeasonBountyShopData:PreConditionValid()
  if self:IsValid() then
    if string.IsNullOrEmpty(self.ShopCell.unlock_shop) then
      return true
    end
    local preShopData = DataCenter.SeasonBountyShopManager:GetShopData(self.ShopCell.unlock_shop)
    if preShopData == nil then
      return false
    end
    return preShopData:HasBought()
  end
  return false
end

function SeasonBountyShopData:HasBought()
  if self.Record == nil then
    return false
  end
  return checknumber(self.Record.totalNum) > 0
end

function SeasonBountyShopData:ConditionValid()
  local validInfo = {}
  validInfo.IsValid = true
  validInfo.InvalidText = ""
  validInfo.InvalidAction = nil
  validInfo.InvalidSortOrder = 0
  validInfo.ExtraParam = nil
  local conditionType = checknumber(self.ShopCell.buying_condition_type)
  if conditionType == self.ConditionType.S6MilitaryLevel then
    local conditionValue = checknumber(self.ShopCell.buying_condition_value)
    local curLevel = DataCenter.SeasonMilitaryManager:GetCurLevel()
    if 0 < checknumber(GMUtils.GetInt(GMConst.MilitaryFakeLevel, -1)) then
      curLevel = checknumber(GMUtils.GetInt(GMConst.MilitaryFakeLevel, -1))
    end
    local valid = conditionValue <= curLevel
    local invalidText = ""
    local militaryCell = DataCenter.SeasonMilitaryManager:GetLevelCellTmp(conditionValue)
    if militaryCell ~= nil then
      invalidText = CS.GameEntry.Localization:GetString("season_military_shop_unlock_desc_limit", militaryCell:GetNameLoc())
    end
    local invalidAction
    if not valid then
      function invalidAction()
        UIUtil.ShowTips(invalidText)
      end
    end
    local extraParam = {
      ShowMilitary = not valid,
      MilitaryLevel = conditionValue
    }
    validInfo.IsValid = valid
    validInfo.InvalidText = invalidText
    validInfo.InvalidAction = invalidAction
    validInfo.InvalidSortOrder = conditionValue
    validInfo.ExtraParam = extraParam
    return validInfo
  end
  return validInfo
end

function SeasonBountyShopData:CanShow()
  if self:IsValid() then
    return self:PreConditionValid()
  end
  return false
end

function SeasonBountyShopData:CanBuy()
  if not self:IsValid() then
    return
  end
  if not self:PreConditionValid() then
    return false
  end
  local isOpen, _ = self:IsOpen()
  if not isOpen then
    return false
  end
  local validInfo = self:ConditionValid()
  if not validInfo.IsValid then
    return false
  end
  if self:GetLeftBuyTimes() <= 0 then
    return false
  end
  if not self:ItemEnough() then
    return false
  end
  return true
end

function SeasonBountyShopData:GetKey()
  if self:IsValid() then
    return string.format("%s|%s", self.ShopCell.id, self:CanShow())
  end
  return ""
end

function SeasonBountyShopData:NeedConfirm()
  if self.ShopCell == nil then
    return false
  end
  return checknumber(self.ShopCell.colorful_skin) == 1
end

function SeasonBountyShopData:IsShortSale()
  if self.ShopCell == nil then
    return false
  end
  return checknumber(self.ShopCell.refresh_time) <= OneWeekTime
end

return SeasonBountyShopData
