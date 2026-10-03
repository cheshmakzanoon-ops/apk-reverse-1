local UIPveTriggerItemBuyCtrl = BaseClass("UIPveTriggerItemBuyCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local UIHeroInfoView = require("UI.UIHero2.UIHeroInfo.View.UIHeroInfoView")

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPveTriggerItemBuy)
end

local function GetPanelData(self, triggerData)
  local data = {}
  local list = {}
  data.isAllDone = true
  data.list = list
  data.name = ""
  local totalDiamond = 0
  local config = triggerData.config
  local battleLevel = DataCenter.BattleLevel
  local submitText = 371064
  if config ~= nil and battleLevel ~= nil then
    if triggerData:IsTypeGainArmy() then
      local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(config.armsId)
      if template then
        data.icon = string.format(LoadPath.PVETriggerIcons, template.icon)
        data.desc = 339009
        data.name = template.name
        data.count = config.count
        data.soldierLevel = tostring(template.level)
      end
    elseif triggerData:IsTypeHireHero() then
      local heroData = HeroUtils.GetHireHeroDataByBattleBuff(triggerData.config.battleBuffId)
      if heroData then
        data.name = heroData.name
        data.heroData = heroData
      end
    else
      if config.triggerIcon ~= nil then
        if string.contains(config.triggerIcon, "_2_free") then
          data.icon = string.format(LoadPath.BuildIconOutCity, config.triggerIcon)
        else
          data.icon = string.format(LoadPath.PVETriggerIcons, config.triggerIcon)
        end
      end
      data.desc = config.description
      data.name = config.name
    end
    local canBuy = config.canBuy or {}
    if config.needBubbleSubmit ~= nil then
      for k, v in ipairs(config.needBubbleSubmit) do
        local temp = {}
        local has = 0
        local need = v.needCount
        local itemId = v.needId
        local diamond = 0
        local name = ""
        local icon = ""
        if v.needType == TriggerNeedType.Goods then
          name = DataCenter.ItemTemplateManager:GetName(itemId)
          icon = DataCenter.ItemTemplateManager:GetIconPath(itemId)
          has = DataCenter.ItemData:GetItemCount(itemId)
          if need > has then
            local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
            if itemTemplate ~= nil then
              diamond = (need - has) * itemTemplate.price
            end
          end
        elseif v.needType == TriggerNeedType.ResourceItem then
          local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(itemId)
          if template ~= nil then
            name = Localization:GetString(template.name)
            icon = template:GetIconPath()
          end
          local resourceItem = DataCenter.ResourceItemDataManager:GetItemDataByItemId(itemId)
          if resourceItem ~= nil then
            has = resourceItem.number
          end
          local _, diamondNum = DataCenter.ResourceItemDataManager:GetResourceItemBuyPriceTotal(itemId, need)
          diamond = diamondNum
          temp.isResourceItem = true
        elseif v.needType == TriggerNeedType.Resource then
          local template = DataCenter.ResourceTemplateManager:GetResourceTemplate(itemId)
          if template ~= nil then
            name = Localization:GetString(template.name)
            icon = string.format(LoadPath.LWCommonPath, template.icon)
          end
          has = DataCenter.BattleLevel:GetResourceCount(itemId)
          if need > has then
            diamond = CommonUtil.GetResGoldByType(itemId, need - has)
          end
          temp.isResource = true
        end
        temp.has = has
        temp.need = need
        temp.itemId = itemId
        temp.diamond = diamond
        temp.name = name
        temp.icon = icon
        temp.index = k
        temp.canBuy = canBuy[k] == 1
        if config.gotoTriggerIds ~= nil and not string.IsNullOrEmpty(config.gotoTriggerIds[k]) then
          local triggerIds = string.split(config.gotoTriggerIds[k], ";")
          for _, id in ipairs(triggerIds) do
            local tId = toInt(id)
            if not battleLevel:IsFinishTrigger(tId) then
              temp.gotoTriggerId = tId
              break
            end
          end
        end
        temp.triggerId = triggerData.triggerId
        temp.level = triggerData.battleLevel.levelId
        temp.isSubmit = battleLevel:IsItemSubmit(temp.triggerId, temp.index)
        temp.submitText = submitText
        data.isAllDone = data.isAllDone and temp.isSubmit
        totalDiamond = totalDiamond + diamond
        table.insert(list, temp)
      end
    end
  end
  data.cost = totalDiamond
  return data
end

UIPveTriggerItemBuyCtrl.CloseSelf = CloseSelf
UIPveTriggerItemBuyCtrl.GetPanelData = GetPanelData
return UIPveTriggerItemBuyCtrl
