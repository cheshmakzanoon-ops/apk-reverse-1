local TacticalWeaponEquipPage = BaseClass("TacticalWeaponEquipPage", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UILWSquadEquipItem = require("UI.UILWSquadEquipPanel.Component.UILWSquadEquipItem")
local ResourceManager = CS.GameEntry.Resource
local TacticalWeaponEquipAttrLineItem = require("UI.UILWTacticalWeapon.Component.EquipPage.TacticalWeaponEquipAttrLineItem")
local equip_path = "MiddleContentContainer/SquadDetail/Line%d/SquadEquipItem%d"
local line_path = "MiddleContentContainer/SquadDetail/Line%d"
local middle_content_container_path = "MiddleContentContainer"
local quick_equip_btn_path = "QuickEquipBtn"
local additionAttrContainer_path = "MiddleContentContainer/AdditionAttr"
local additionAttr_scroll_path = "MiddleContentContainer/AdditionAttr/AdditionAttrScroll"
local additionAttr_scrollContent_path = "MiddleContentContainer/AdditionAttr/AdditionAttrScroll/Viewport/Content"
local additionAttr_lineItem_path = "MiddleContentContainer/AdditionAttr/AdditionAttrScroll/Viewport/Content/AttrLineItem"
local powerInfo_path = "PowerInfo"
local powerInfo_icon_path = "PowerInfo/PowerIcon"
local powerNumber_text_path = "PowerInfo/PowerNumberText"
local bag_btn_path = "bagBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearAdditionEffects()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function OnQuickEquipBtn(self)
  if table.IsNullOrEmpty(self.quickPutOnEquips) then
    return
  end
  local msgData = {}
  for i, v in pairs(self.quickPutOnEquips) do
    msgData[i] = v.uuid
  end
  SFSNetwork.SendMessage(MsgDefines.CommonEquipPutOn, tostring(self.uuid), msgData)
end

local function ComponentDefine(self)
  self.equips = {}
  self.lines = {}
  for i = 1, 6 do
    local equip = self:AddComponent(UILWSquadEquipItem, string.format(equip_path, i, i))
    local line = self:AddComponent(UIImage, string.format(line_path, i))
    table.insert(self.equips, equip)
    table.insert(self.lines, line)
  end
  self.middleContentContainer = self:AddComponent(UIBaseContainer, middle_content_container_path)
  self.quickEquipBtn = self:AddComponent(UIButton, quick_equip_btn_path)
  self.quickEquipBtn:SetOnClick(function()
    OnQuickEquipBtn(self)
  end)
  self.additionAttrContainer = self:AddComponent(UIBaseContainer, additionAttrContainer_path)
  self.additionAttr_scroll = self:AddComponent(UIScrollRect, additionAttr_scroll_path)
  self.additionAttr_scrollContent = self:AddComponent(UIBaseContainer, additionAttr_scrollContent_path)
  self.additionAttr_lineItem = self:AddComponent(UIBaseContainer, additionAttr_lineItem_path)
  self.additionAttr_lineItem:SetActive(false)
  self.additionAttr_lineItem.gameObject:GameObjectCreatePool()
  self.powerInfo = self:AddComponent(UIBaseContainer, powerInfo_path)
  self.powerIcon = self:AddComponent(UIImage, powerInfo_icon_path)
  self.powerNumberText = self:AddComponent(UIText, powerNumber_text_path)
  self.bag_btn = self:AddComponent(UIButton, bag_btn_path)
  self.bag_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalEquipBag, {anim = true})
  end)
end

local function ComponentDestroy(self)
  self.equips = nil
  self.lines = nil
  self.middleContentContainer = nil
  self.quickEquipBtn = nil
  self.additionAttrContainer = nil
  self.additionAttr_scroll = nil
  self.additionAttr_scrollContent = nil
  self.additionAttr_lineItem = nil
  self.powerInfo = nil
  self.powerIcon = nil
  self.powerNumberText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEquipDataChange(self)
  self:RefreshSquadDetail()
end

local function OnRefreshWeaponInfo(self)
  self:RefreshBaseInfo()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.PutonCommonEquip, self.OnEquipDataChange)
  self:AddUIListener(EventId.PutoffCommonEquip, self.OnEquipDataChange)
  self:AddUIListener(EventId.CommonEquipDataChanged, self.OnEquipDataChange)
  self:AddUIListener(EventId.TacticalWeaponUpdate, self.OnRefreshWeaponInfo)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.PutonCommonEquip, self.OnEquipDataChange)
  self:RemoveUIListener(EventId.PutoffCommonEquip, self.OnEquipDataChange)
  self:RemoveUIListener(EventId.CommonEquipDataChanged, self.OnEquipDataChange)
  self:RemoveUIListener(EventId.TacticalWeaponUpdate, self.OnRefreshWeaponInfo)
end

local function RefreshBaseInfo(self)
  if self.weaponInfo then
    self.powerInfo:SetActive(true)
    self.powerNumberText:SetText(DataCenter.TacticalWeaponManager:GetWeaponTotalPower())
  else
    self.powerInfo:SetActive(false)
  end
end

local function RefreshSquadDetail(self)
  self.uuid = BuildingTypes.LW_BUILD_TACTICAL_CENTER
  if self.uuid then
    for i, v in pairs(self.equips) do
      v:SetActive(true)
      v:SetData(self.uuid, i)
    end
    for i, v in pairs(self.lines) do
      v:SetActive(true)
    end
    self.quickPutOnEquips = DataCenter.TacticalWeaponManager:IsSelfHasBetterEquip()
    self.quickEquipBtn:SetActive(not table.IsNullOrEmpty(self.quickPutOnEquips))
  else
    for i, v in pairs(self.equips) do
      v:SetActive(false)
    end
    for i, v in pairs(self.lines) do
      v:SetActive(false)
    end
    self.quickEquipBtn:SetActive(false)
  end
  self:RefreshEffects()
  self:RefreshBaseInfo()
end

local function SetData(self, weaponInfo)
  self.weaponInfo = weaponInfo
  self:RefreshSquadDetail()
end

local function ClearAdditionEffects(self)
  self.additionAttr_scrollContent:RemoveComponents(TacticalWeaponEquipAttrLineItem)
  if self.additionAttr_lineItem and not IsNull(self.additionAttr_lineItem) then
    self.additionAttr_lineItem.gameObject:GameObjectRecycleAll()
  end
  self.additionAttrItems = {}
end

local function GetEffects(self)
  local result = {}
  if not self.uuid then
    return result
  end
  local effects = DataCenter.CommonEquipDataManager:CollectEquipsEffectByOwnerUid(CommonEquipType.SquadEquip, self.uuid)
  for k, v in pairs(effects) do
    local effectId = k
    local value = v
    local nameStr = HeroUtils.GetHeroPropertyNameId(effectId)
    local addValue = HeroUtils:GetFormattedPropertyValueColored(effectId, value)
    local para = {}
    para.name = nameStr
    para.value = addValue
    para.effectId = effectId
    table.insert(result, para)
  end
  table.sort(result, function(a, b)
    local aSequence = DataCenter.EffectNumberTemplateManager:GetEffectNumberTemplateSequence(a.effectId)
    local bSequence = DataCenter.EffectNumberTemplateManager:GetEffectNumberTemplateSequence(b.effectId)
    if aSequence == bSequence then
      return a.effectId < b.effectId
    else
      return aSequence < bSequence
    end
  end)
  return result
end

local function RefreshEffects(self)
  local effects = GetEffects(self)
  self:ClearAdditionEffects()
  if table.IsNullOrEmpty(effects) then
    self.additionAttrContainer:SetActive(false)
    return
  else
    self.additionAttrContainer:SetActive(true)
    for i, v in pairs(effects) do
      local item = self.additionAttr_lineItem.gameObject:GameObjectSpawn(self.additionAttr_scrollContent.transform)
      item.name = "item" .. i
      local obj = self.additionAttr_scrollContent:AddComponent(TacticalWeaponEquipAttrLineItem, item.name)
      obj:SetData(v.name, v.value)
      table.insert(self.additionAttrItems, obj)
    end
  end
end

TacticalWeaponEquipPage.OnCreate = OnCreate
TacticalWeaponEquipPage.OnDestroy = OnDestroy
TacticalWeaponEquipPage.OnEnable = OnEnable
TacticalWeaponEquipPage.OnDisable = OnDisable
TacticalWeaponEquipPage.OnAddListener = OnAddListener
TacticalWeaponEquipPage.OnRemoveListener = OnRemoveListener
TacticalWeaponEquipPage.ComponentDefine = ComponentDefine
TacticalWeaponEquipPage.DataDefine = DataDefine
TacticalWeaponEquipPage.ComponentDestroy = ComponentDestroy
TacticalWeaponEquipPage.DataDestroy = DataDestroy
TacticalWeaponEquipPage.OnQuickEquipBtn = OnQuickEquipBtn
TacticalWeaponEquipPage.SetData = SetData
TacticalWeaponEquipPage.RefreshSquadDetail = RefreshSquadDetail
TacticalWeaponEquipPage.OnEquipDataChange = OnEquipDataChange
TacticalWeaponEquipPage.ClearAdditionEffects = ClearAdditionEffects
TacticalWeaponEquipPage.RefreshEffects = RefreshEffects
TacticalWeaponEquipPage.RefreshBaseInfo = RefreshBaseInfo
TacticalWeaponEquipPage.OnRefreshWeaponInfo = OnRefreshWeaponInfo
return TacticalWeaponEquipPage
