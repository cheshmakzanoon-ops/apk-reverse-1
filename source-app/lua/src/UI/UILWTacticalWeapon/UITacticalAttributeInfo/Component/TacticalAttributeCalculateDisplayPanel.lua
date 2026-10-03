local TacticalAttributeCalculateDisplayPanel = BaseClass("TacticalAttributeCalculateDisplayPanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local DisplayItem = require("UI.UILWTacticalWeapon.UITacticalAttributeInfo.Component.TacticalAttributeCalculateDisplayItem")
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local item_scroll_path = "itemScroll"
local content_path = "itemScroll/Viewport/Content"
local desc_path = "desc"

function TacticalAttributeCalculateDisplayPanel:OnCreate()
  base.OnCreate(self)
  self.item_scroll = self:AddComponent(UILoopListView2, item_scroll_path)
  self.item_scroll:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.itemDataList = {}
  self.itemIndex = 0
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  if DataCenter.DominatorManager:IsDominatorFunctionOn() then
    self.desc:SetLocalText("new_uav_level_desc6_new")
  else
    self.desc:SetLocalText("new_uav_level_desc6")
  end
end

function TacticalAttributeCalculateDisplayPanel:OnDestroy()
  self.weaponInfo = nil
  self.content:RemoveComponents(DisplayItem)
  self.item_scroll:ClearAllItems()
  self.item_scroll = nil
  self.content = nil
  self.itemIndex = nil
  self.itemDataList = nil
  base.OnDestroy(self)
end

function TacticalAttributeCalculateDisplayPanel:OnEnable()
  base.OnEnable(self)
end

function TacticalAttributeCalculateDisplayPanel:OnDisable()
  base.OnDisable(self)
end

function TacticalAttributeCalculateDisplayPanel:ReInit(param)
  local weapons = DataCenter.TacticalWeaponManager:GetTacticalWeaponInfos()
  if not table.IsNullOrEmpty(weapons) then
    for i, v in pairs(weapons) do
      self.weaponInfo = v
      break
    end
  end
  if not self.weaponInfo then
    Logger.LogError("[Tactical] \230\178\161\230\156\137\230\151\160\228\186\186\230\156\186\230\149\176\230\141\174\239\188\129")
    return
  end
  self:RefreshTaskList()
end

function TacticalAttributeCalculateDisplayPanel:RefreshTaskList()
  self.itemDataList = self:GetParamList()
  local noTask = self.itemDataList == nil or #self.itemDataList == 0
  self.item_scroll:SetActive(not noTask)
  if not noTask then
    self.item_scroll:SetListItemCount(#self.itemDataList, false, false)
    self.item_scroll:RefreshAllShownItem()
  end
end

function TacticalAttributeCalculateDisplayPanel:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.itemDataList then
    return nil
  end
  local data = self.itemDataList[index]
  local item = loopScroll:NewListViewItem("TacticalAttributeCalculateDisplayItem")
  local script = self.content:GetComponent(item.gameObject.name, DisplayItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.content:AddComponent(DisplayItem, objectName)
  end
  script:SetActive(true)
  script:SetData(data)
  return item
end

function TacticalAttributeCalculateDisplayPanel:GetParamList()
  local paramList = {}
  local hpParam = self:GetParam(TacticalWeaponUtils.ShowEffectId.HpBase, TacticalWeaponUtils.ShowEffectId.HpRate, "new_uav_level_desc7", TacticalWeaponUtils.ShowEffectId.HpHero)
  table.insert(paramList, hpParam)
  local attackParam = self:GetParam(TacticalWeaponUtils.ShowEffectId.AttackBase, TacticalWeaponUtils.ShowEffectId.AttackRate, "new_uav_level_desc7", TacticalWeaponUtils.ShowEffectId.AttackHero)
  table.insert(paramList, attackParam)
  local defendParam = self:GetParam(TacticalWeaponUtils.ShowEffectId.DefendBase, TacticalWeaponUtils.ShowEffectId.DefendRate, "new_uav_level_desc7", TacticalWeaponUtils.ShowEffectId.DefendHero)
  table.insert(paramList, defendParam)
  return paramList
end

function TacticalAttributeCalculateDisplayPanel:GetParam(id, rateId, rateName, heroEffectId)
  local param = {}
  local valueConfig = DataCenter.EffectNumberTemplateManager:GetEffectNumberTemplateById(id)
  param.originName = Localization:GetString(DataCenter.EffectNumberTemplateManager:GetEffectNumberName(id))
  param.originValue = HeroUtils.GetFormattedValue(valueConfig.type, self.weaponInfo:GetProperty(id))
  local rateConfig = DataCenter.EffectNumberTemplateManager:GetEffectNumberTemplateById(rateId)
  param.rateName = Localization:GetString(rateName)
  param.rateValue = self.weaponInfo:GetProperty(rateId)
  local baseRateValue = self.weaponInfo:GetProperty(50090)
  param.resultName = Localization:GetString((DataCenter.EffectNumberTemplateManager:GetEffectNumberName(heroEffectId)))
  param.resultValue = string.GetFormattedSeperatorNum(HeroUtils.GetFormattedValue(0, param.originValue * param.rateValue * 1.0E-4))
  param.originValue = string.GetFormattedSeperatorNum(param.originValue)
  local rate = self.weaponInfo:GetProperty(rateId)
  param.rateValue = HeroUtils.GetFormattedValue(rateConfig.type, rate + baseRateValue * 10000)
  return param
end

return TacticalAttributeCalculateDisplayPanel
