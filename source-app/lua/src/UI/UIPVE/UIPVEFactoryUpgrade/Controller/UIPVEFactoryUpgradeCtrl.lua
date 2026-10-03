local UIPVEFactoryUpgradeCtrl = BaseClass("UIPVEFactoryUpgradeCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEFactoryUpgrade)
end

local function GetPanelData(self, triggerData)
  local data = {}
  local list = {}
  data.isAllDone = true
  data.list = list
  data.name = ""
  data.desc = ""
  local totalDiamond = 0
  local config = triggerData.config
  local battleLevel = DataCenter.BattleLevel
  if config ~= nil and battleLevel ~= nil then
    data.name = config.name
    data.desc = config.description
    if config.triggerIcon ~= nil then
      data.icon = string.format(LoadPath.PVETriggerIcons, config.triggerIcon)
    end
    local conditions = triggerData:GetPVEFactoryUpgradeCondition()
    local canBuy = config.canBuy or {}
    if conditions ~= nil then
      for k, v in ipairs(conditions) do
        local temp = {}
        local has = 0
        local need = v.num
        local itemId = v.id
        local diamond = 0
        local name = ""
        local icon = ""
        if v.type == TriggerNeedType.Goods then
          name = DataCenter.ItemTemplateManager:GetName(itemId)
          icon = DataCenter.ItemTemplateManager:GetIconPath(itemId)
          has = DataCenter.ItemData:GetItemCount(itemId)
          if need > has then
            local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
            if itemTemplate ~= nil then
              diamond = (need - has) * itemTemplate.price
            end
          end
        elseif v.type == TriggerNeedType.ResourceItem then
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
        elseif v.type == TriggerNeedType.Resource then
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
        data.isAllDone = data.isAllDone and temp.isSubmit
        totalDiamond = totalDiamond + diamond
        table.insert(list, temp)
      end
    end
  end
  data.cost = totalDiamond
  return data
end

UIPVEFactoryUpgradeCtrl.CloseSelf = CloseSelf
UIPVEFactoryUpgradeCtrl.GetPanelData = GetPanelData
return UIPVEFactoryUpgradeCtrl
