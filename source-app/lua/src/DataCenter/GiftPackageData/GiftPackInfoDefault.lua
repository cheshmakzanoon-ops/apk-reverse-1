local GiftPackInfoBase = require("DataCenter.GiftPackageData.GiftPackInfoBase")
local Localization = CS.GameEntry.Localization
local GiftPackInfoDefault = BaseClass("GiftPackInfoDefault", GiftPackInfoBase)
local M = GiftPackInfoDefault

function M:__init()
  GiftPackInfoBase.__init(self)
  self._itemsParsed = false
end

function M:getItems(containAllianceGift)
  self:_tryParseItems()
  local items = {}
  for _, v in ipairs(self._items) do
    if v.rewardType == RewardType.ALLIANCE_GIFT and containAllianceGift then
      table.insert(items, v)
    elseif v.rewardType ~= RewardType.ALLIANCE_GIFT then
      table.insert(items, v)
    end
  end
  return items
end

function M:getFreeAndGoldBuyReward()
  if not self._tableData or string.IsNullOrEmpty(self._tableData.buy_reward) then
    return nil
  end
  if not self.freeAndGoldBuyRewardList then
    self.freeAndGoldBuyRewardList = {}
    self:_parseDiamond(self.freeAndGoldBuyRewardList)
    local paramStrList = string.split(self._tableData.buy_reward, "|")
    if paramStrList then
      for i, v in ipairs(paramStrList) do
        local paramList = string.split(v, ";")
        if #paramList == 3 then
          local reward = {}
          reward.rewardType = tonumber(paramList[1])
          reward.itemId = tonumber(paramList[2])
          reward.count = tonumber(paramList[3])
          table.insert(self.freeAndGoldBuyRewardList, reward)
        else
          Logger.LogError("\231\173\150\229\136\146\233\133\141\233\148\153\228\186\134  id:" .. tostring(self._tableData.id))
        end
      end
    end
  end
  return self.freeAndGoldBuyRewardList
end

function M:getItem(index)
  self:_tryParseItems()
  if self._items == nil or index > #self._items then
    return nil
  end
  return self._items[index]
end

function M:getCombs()
  self:_tryParseItems()
  return self._combItems
end

function M:getComb(index)
  self:_tryParseItems()
  if self._combItems == nil or index > #self._combItems then
    return nil
  end
  return self._combItems[index]
end

function M:hasComb()
  return self._combItems and #self._combItems > 0
end

function M:_tryParseItems()
  if self._itemsParsed then
    return
  end
  self._itemsParsed = true
  self._items = {}
  if self._serverData == nil then
    logErrorWithTag("GiftPackInfoDefault", "Server data null")
    return
  end
  if self._tableData == nil then
    logErrorWithTag("GiftPackInfoDefault", "Table data null")
    return
  end
  self:_parseDiamond(self._items)
  self:_parseGoldBrick(self._items)
  self:_parseItems(self._items, self._tableData.item_use)
  self._parseHeroes(self._items, self._tableData.hero)
  self:_parseItems(self._items, self._tableData.item)
  self:_parseResourceItem(self._items, self._tableData.resource_item)
  self:_parseEquip(self._items, self._tableData.equip)
  self:_parseAllianceGift(self._items, self._tableData.giftData)
  self._combItems = {}
  self:_parseCombItems(self._combItems, self._tableData.item_combine, self._tableData.hero_combine)
end

function M:_parseEquip(t, data)
  if string.IsNullOrEmpty(data) then
    return
  end
  local arr1 = string.split(data, "|")
  for _, v in ipairs(arr1) do
    if not string.IsNullOrEmpty(v) then
      local arr2 = string.split(v, ";")
      if #arr2 == 2 then
        local id = arr2[1]
        local config = DataCenter.EquipTemplateManager:GetTemplate(id)
        if config then
          table.insert(t, {
            id = id,
            itemId = tonumber(id),
            count = tonumber(arr2[2]),
            rewardType = RewardType.EQUIP
          })
        end
      end
    end
  end
end

function M:_parseResourceItem(t, data)
  if string.IsNullOrEmpty(data) then
    return
  end
  local arr1 = string.split(data, "|")
  for _, v in ipairs(arr1) do
    if not string.IsNullOrEmpty(v) then
      local arr2 = string.split(v, ";")
      if #arr2 == 2 then
        local id = arr2[1]
        local config = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(id)
        if config then
          table.insert(t, {
            id = id,
            itemId = tonumber(id),
            count = tonumber(arr2[2]),
            rewardType = RewardType.RESOURCE_ITEM
          })
        end
      end
    end
  end
end

function M:_parseDiamond(t)
  local diamondWorth = tonumber(self:getDiamond())
  if diamondWorth and 0 < diamondWorth then
    local param = {}
    param.rewardType = RewardType.GOLD
    param.count = diamondWorth
    table.insert(t, param)
  end
end

function M:_parseGoldBrick(t)
  local goldBrickWorth = tonumber(self:getGoldBrick())
  if goldBrickWorth and 0 < goldBrickWorth then
    local param = {}
    param.rewardType = RewardType.GOODS
    param.itemId = GoldBrickConst.ItemId
    param.count = goldBrickWorth
    table.insert(t, param)
  end
end

function M:_parseItems(t, data)
  if string.IsNullOrEmpty(data) then
    return
  end
  local arr1 = string.split(data, "|")
  for _, v in ipairs(arr1) do
    if not string.IsNullOrEmpty(v) then
      local arr2 = string.split(v, ";")
      if #arr2 == 2 then
        local id = arr2[1]
        local config = DataCenter.ItemTemplateManager:GetItemTemplate(id)
        if config then
          table.insert(t, {
            id = id,
            itemId = tonumber(id),
            count = tonumber(arr2[2]),
            rewardType = RewardType.GOODS
          })
        end
      end
    end
  end
end

function M._parseHeroes(t, data)
  if string.IsNullOrEmpty(data) then
    return
  end
  local arr1 = string.split(data, "|")
  for _, v in ipairs(arr1) do
    if not string.IsNullOrEmpty(v) then
      local arr2 = string.split(v, ";")
      if #arr2 == 2 then
        local id = arr2[1]
        local config = LocalController:instance():getLine(TableName.LW_Hero, id)
        if config then
          table.insert(t, {
            id = id,
            itemId = tonumber(id),
            count = tonumber(arr2[2]),
            rewardType = RewardType.HERO
          })
        end
      end
    end
  end
end

function M:_parseAllianceGift(t, data)
  if table.IsNullOrEmpty(data) then
    return
  end
  if data ~= nil and 0 < #data then
    for k, v in ipairs(data) do
      local arr = string.split(v, ";")
      if 4 < #arr then
        local param = {}
        param.iconName = string.format(LoadPath.UIAllianceGift, arr[1])
        param.itemName = Localization:GetString(arr[2])
        param.itemDesc = Localization:GetString(arr[3])
        param.isLocal = true
        param.count = tonumber(arr[4])
        param.itemColor = tonumber(arr[5])
        param.rewardType = RewardType.ALLIANCE_GIFT
        param.itemId = arr[1]
        local numCount = tonumber(arr[4])
        param.count = string.GetFormattedSeperatorNum(numCount)
        table.insert(t, param)
      end
    end
  end
end

function M:_parseCombItems(t, itemData, heroData)
  if string.IsNullOrEmpty(itemData) then
    return
  end
  local itemPacks = string.split(itemData, "@")
  for i, v in ipairs(itemPacks) do
    local arrItems = {}
    if v ~= "N" then
      self:_parseItems(arrItems, v)
    end
    if arrItems ~= nil and 0 < #arrItems then
      table.insert(t, arrItems)
    end
  end
end

function M:isSpecialShowHero(id)
  self:tryParseSpecialShowHeros()
  if self.specialHeros == nil or #self.specialHeros < 1 then
    return false
  end
  for _, v in ipairs(self.specialHeros) do
    if id == v then
      return true
    end
  end
  return false
end

function M:tryParseSpecialShowHeros()
  if self.specialHeros ~= nil then
    return
  end
  self.specialHeros = {}
  local info = self:getShowType("66")
  if not string.IsNullOrEmpty(info) then
    local arr = string.split(info, ",")
    if arr == nil or #arr < 1 then
      return
    end
    for _, v in ipairs(arr) do
      table.insert(self.specialHeros, v)
    end
  end
end

function M:isSpecialShowItem(id)
  self:tryParseSpecialShowItems()
  if self.specialItems == nil or #self.specialItems < 1 then
    return false
  end
  for _, v in ipairs(self.specialItems) do
    if id == v then
      return true
    end
  end
  return false
end

function M:tryParseSpecialShowItems()
  if self.specialItems ~= nil then
    return
  end
  self.specialItems = {}
  local info = self:getShowType("65")
  if not string.IsNullOrEmpty(info) then
    local arr = string.split(info, ",")
    if arr == nil or #arr < 1 then
      return
    end
    for _, v in ipairs(arr) do
      table.insert(self.specialItems, v)
    end
  end
end

function M:dispose()
  self._itemsParsed = false
  self._items = nil
  self._combItems = nil
  self.specialHeros = nil
  self.specialItems = nil
  self.freeAndGoldBuyRewardList = nil
  GiftPackInfoBase.dispose(self)
end

function M:getParsedBuyCondition()
  return DataCenter.RewardManager:ParseBuyConditionStr(GiftPackInfoBase.getBuyCondition(self))
end

function M:getParsedAlertCondition()
  return DataCenter.RewardManager:ParseBuyConditionStr(GiftPackInfoBase.getAlertCondition(self))
end

function M:getInconsistentAlertConditions()
  local alertConditions = self:getParsedAlertCondition()
  if not table.IsNullOrEmpty(alertConditions) then
    return DataCenter.RewardManager:GetInconsistentBuyConditions(alertConditions)
  end
end

function M:tryShowBuyAlertCondition(confirmCallback)
  local inconsistentAlertConditions = self:getInconsistentAlertConditions()
  if inconsistentAlertConditions and inconsistentAlertConditions[1] then
    local condition = inconsistentAlertConditions[1]
    local tipText = ""
    local titleText = ""
    local isSupportType = false
    if condition.conditionType == BuyConditionType.MainBuildingLevel then
      local mainBuildingName = ""
      local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.FUN_BUILD_MAIN)
      if buildTemplate ~= nil then
        mainBuildingName = Localization:GetString(buildTemplate.name)
      end
      tipText = Localization:GetString("bp_buy_alert_desc3", mainBuildingName, condition.conditionParam)
      titleText = Localization:GetString("bp_buy_alert_title3")
      isSupportType = true
    elseif condition.conditionType == BuyConditionType.HeroUniqueWeaponLevel then
      local heroName = ""
      local heroId = tonumber(condition.conditionParam[1])
      local uniqueWeaponLevel = tonumber(condition.conditionParam[2])
      local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(heroId)
      if heroTemplate then
        heroName = Localization:GetString(heroTemplate.name)
      end
      tipText = Localization:GetString("bp_buy_alert_desc1", heroName, uniqueWeaponLevel)
      titleText = Localization:GetString("bp_buy_alert_title1")
      isSupportType = true
    elseif condition.conditionType == BuyConditionType.DominatorMainTrainGroupLevel then
      local dominatorName = Localization:GetString("dominator_truck_title_name")
      local trainLevelName = ""
      local requireTemplate = DataCenter.DominatorTemplateManager:GetTrainLevelTemplateById(condition.conditionParam)
      if requireTemplate then
        trainLevelName = requireTemplate:GetName(true)
      end
      tipText = Localization:GetString("bp_buy_alert_desc2", dominatorName, trainLevelName)
      titleText = Localization:GetString("bp_buy_alert_title2")
      isSupportType = true
    end
    if isSupportType then
      UIUtil.ShowSecondMessageByParam({
        tipText = tipText,
        btnNum = 2,
        showToggle = false,
        sureAction = function()
          if confirmCallback then
            confirmCallback()
          end
        end,
        titleText = titleText
      })
    elseif confirmCallback then
      confirmCallback()
    end
  elseif confirmCallback then
    confirmCallback()
  end
end

function M:getInconsistentBuyConditions()
  local buyConditions = self:getParsedBuyCondition()
  if not table.IsNullOrEmpty(buyConditions) then
    return DataCenter.RewardManager:GetInconsistentBuyConditions(buyConditions)
  end
end

return M
