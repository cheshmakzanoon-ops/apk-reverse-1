local UILWTacticalWeaponLevelUpView = BaseClass("UILWTacticalWeaponLevelUpView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local TacticalWeaponAttrLineItem = require("UI.UILWTacticalWeapon.Component.BasicPage.TacticalWeaponAttrLineItem")
local TacticalWeaponCostItem = require("UI.UILWTacticalWeapon.Component.BasicPage.TacticalWeaponCostItem")
local UIHeroSkillItem = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillItem")
local attrsContianer_path = "Common_bg_orange/Common_bg_orange2/Root/Attrs"
local attrLineTemplate_path = "Common_bg_orange/Common_bg_orange2/Root/Attrs/AttrLine"
local skillUpgradeContainer_path = "Common_bg_orange/Common_bg_orange2/Root/SkillUpgrade"
local skillUpgradeItem1_path = "Common_bg_orange/Common_bg_orange2/Root/SkillUpgrade/SkillItem1"
local skillUpgradeItem2_path = "Common_bg_orange/Common_bg_orange2/Root/SkillUpgrade/SkillItem2"
local costGroupContainer_path = "Common_bg_orange/Common_bg_orange2/Root/CostGroup"
local costResourceTemplate_path = "Common_bg_orange/Common_bg_orange2/Root/CostGroup/CostResource"
local upgrade_btn_path = "Common_bg_orange/Common_bg_orange2/Root/UpgradeBtn"
local upgrade_btn_redPoint_path = "Common_bg_orange/Common_bg_orange2/Root/UpgradeBtn/UpgradeBtnRedPoint"
local close_btn_path = "Common_bg_orange/CloseBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local weaponId = self:GetUserData()
  self.weaponInfo = DataCenter.TacticalWeaponManager:GetTacticalWeaponInfo(weaponId)
  if not self.weaponInfo then
    return
  end
  self:UpdateView()
end

local function OnDestroy(self)
  self:ClearAttrs()
  self:ClearCostItems()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.bgCloseBtn = self:AddComponent(UIButton, "panel")
  self.bgCloseBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.attrsContianer = self:AddComponent(UIBaseContainer, attrsContianer_path)
  self.attrLineTemplate = self:AddComponent(UIBaseContainer, attrLineTemplate_path)
  self.attrLineTemplate.gameObject:GameObjectCreatePool()
  self.skillUpgradeContainer = self:AddComponent(UIBaseContainer, skillUpgradeContainer_path)
  self.skillUpgradeItem1 = self:AddComponent(UIHeroSkillItem, skillUpgradeItem1_path)
  self.skillUpgradeItem2 = self:AddComponent(UIHeroSkillItem, skillUpgradeItem2_path)
  self.costGroupContainer = self:AddComponent(UIBaseContainer, costGroupContainer_path)
  self.costResourceTemplate = self:AddComponent(UIBaseContainer, costResourceTemplate_path)
  self.costResourceTemplate.gameObject:GameObjectCreatePool()
  self.upgradeBtn = self:AddComponent(UIButton, upgrade_btn_path)
  self.upgradeBtnRedPoint = self:AddComponent(UIImage, upgrade_btn_redPoint_path)
  self.upgradeBtnRedPoint:SetActive(false)
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.upgradeBtn:SetOnClick(function()
    if self.weaponInfo then
      self:OnLevelUpBtnClick()
    end
  end)
end

local function DataDefine(self)
  self.attrLines = {}
  self.costItems = {}
end

local function ComponentDestroy(self)
  self.bgCloseBtn = nil
  self.attrsContianer = nil
  self.attrLineTemplate = nil
  self.skillUpgradeContainer = nil
  self.skillUpgradeItem1 = nil
  self.skillUpgradeItem2 = nil
  self.costGroupContainer = nil
  self.costResourceTemplate = nil
  self.upgradeBtn = nil
  self.upgradeBtnRedPoint = nil
  self.closeBtn = nil
end

local function DataDestroy(self)
  self.skillData = nil
  self.skillId = nil
  self.level = nil
  self.isUnlock = nil
  self.alignObject = nil
  self.nextLevelWeapon = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshResourceItem, self.OnResOrItemUpdate)
  self:AddUIListener(EventId.ResourceUpdated, self.OnResOrItemUpdate)
  self:AddUIListener(EventId.RefreshItems, self.OnResOrItemUpdate)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshResourceItem, self.OnResOrItemUpdate)
  self:RemoveUIListener(EventId.ResourceUpdated, self.OnResOrItemUpdate)
  self:RemoveUIListener(EventId.RefreshItems, self.OnResOrItemUpdate)
end

local function RefreshUpgradeBtnRedPoint(self)
  if self.upgradeBtn then
    self.upgradeBtnRedPoint:SetActive(self.weaponInfo:ShowUpgradeRedPoint())
  end
end

local function ClearAttrs(self)
  if self.attrsContianer then
    self.attrsContianer:RemoveComponents(TacticalWeaponAttrLineItem)
  end
  if self.attrLineTemplate and not IsNull(self.attrLineTemplate.gameObject) then
    self.attrLineTemplate.gameObject:GameObjectRecycleAll()
  end
  self.attrLines = {}
end

local function ClearCostItems(self)
  if self.costGroupContainer then
    self.costGroupContainer:RemoveComponents(TacticalWeaponCostItem)
  end
  if self.costResourceTemplate and not IsNull(self.costResourceTemplate.gameObject) then
    self.costResourceTemplate.gameObject:GameObjectRecycleAll()
  end
end

local function RefreshAttrs(self)
  local basicAttrs = {}
  for i = 1, #TacticalWeaponUtils.ShowEffects do
    local id = TacticalWeaponUtils.ShowEffects[i]
    local value = self.weaponInfo:GetProperty(id)
    table.insert(basicAttrs, {id = id, value = value})
  end
  local attrs = {}
  local nextLevelAttrs = {}
  if not self.weaponInfo:IsReachMaxLevel() and self.weaponInfo.template then
    nextLevelAttrs = TacticalWeaponUtils.GetNextLevelAttrs(self.weaponInfo)
  end
  for __, v in pairs(basicAttrs) do
    local attr = v
    local nextValue = nextLevelAttrs[attr.id] or 0
    if nextValue and nextValue ~= attr.value then
      attr.nextValue = nextValue
    end
    table.insert(attrs, attr)
  end
  self.nextLevelWeapon = TacticalWeaponUtils.CreateNextLevelTemplate(self.weaponInfo)
  for i = 1, #attrs do
    local attr = attrs[i]
    local rewardName = "attr_" .. attr.id
    local goItem = self.attrLineTemplate.gameObject:GameObjectSpawn(self.attrsContianer.transform)
    goItem.name = rewardName
    goItem:SetActive(true)
    local theItem = self.attrsContianer:AddComponent(TacticalWeaponAttrLineItem, rewardName)
    theItem:SetValue(attr.id, attr.value, attr.nextValue)
    theItem:SetMaster(self.nextLevelWeapon)
    self.attrLines[attr.id] = theItem
  end
end

local function RefreshCosts(self)
  if not self.weaponInfo then
    return
  end
  local costRes = {}
  if self.weaponInfo.levelTemplate then
    costRes = self.weaponInfo.levelTemplate.cost_resItem
  end
  for __, v in pairs(costRes) do
    if self.costItems[v.id] then
      self.costItems[v.id]:SetValue(v.id, v.value)
    else
      local rewardName = "cost_" .. v.id
      local goItem = self.costResourceTemplate.gameObject:GameObjectSpawn(self.costGroupContainer.transform)
      goItem.name = rewardName
      goItem:SetActive(true)
      local theItem = self.costGroupContainer:AddComponent(TacticalWeaponCostItem, rewardName)
      theItem:SetValue(v.id, v.value)
      self.costItems[v.id] = theItem
    end
  end
  
  local function containsValue(arr, id)
    for i = 1, #arr do
      local v = arr[i]
      if v.id == id then
        return true
      end
    end
    return false
  end
  
  for itemId, costItem in pairs(self.costItems) do
    if not containsValue(costRes, itemId) then
      local go = costItem.gameObject
      self.costGroupContainer:RemoveComponent(costItem:GetName(), TacticalWeaponCostItem)
      if not IsNull(go) then
        go:GameObjectRecycle()
      end
      self.costItems[itemId] = nil
    end
  end
end

local function RefreshSkill(self)
  if not self.weaponInfo then
    self.skillUpgradeContainer:SetActive(false)
    return
  end
  local level = self.weaponInfo.level
  local nextLevelTemplate = DataCenter.TacticalWeaponLevelTemplateManager:GetTemplateByLevel(level + 1)
  if not nextLevelTemplate then
    self.skillUpgradeContainer:SetActive(false)
    return
  end
  local skillInfos = self.weaponInfo:GetSkillInfos()
  if not skillInfos then
    self.skillUpgradeContainer:SetActive(false)
    return
  end
  if self.weaponInfo.levelTemplate.skillLevel ~= nextLevelTemplate.skillLevel then
    self.skillUpgradeContainer:SetActive(true)
    local nowSkillInfos = self.weaponInfo.levelTemplate:GetSkillInfos()
    local nextSkillInfos = nextLevelTemplate:GetSkillInfos()
    local nowSkillInfo = nowSkillInfos[1]
    local nextSkillInfo = nextSkillInfos[1]
    self.skillUpgradeItem1:SetData(nowSkillInfo, {
      showSkillName = false,
      showSkillLevel = false,
      showStar = true
    }, function(skillData, skillItem)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeaponSkillDetail, {anim = true}, skillData, skillItem)
    end)
    self.skillUpgradeItem2:SetData(nextSkillInfo, {
      showSkillName = false,
      showSkillLevel = false,
      showStar = true
    }, function(skillData, skillItem)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeaponSkillDetail, {anim = true}, skillData, skillItem)
    end)
  else
    self.skillUpgradeContainer:SetActive(false)
  end
end

local function UpdateView(self)
  if not self.weaponInfo then
    return
  end
  RefreshAttrs(self)
  RefreshCosts(self)
  RefreshSkill(self)
  RefreshUpgradeBtnRedPoint(self)
end

local function OnResOrItemUpdate(self)
  RefreshCosts(self)
  RefreshUpgradeBtnRedPoint(self)
end

local function OnLevelUpBtnClick(self)
  if not self.weaponInfo then
    return
  end
  local hasItemToUpgrade, lackItems = self.weaponInfo:HasResItemToUpgrade()
  if not hasItemToUpgrade then
    for id, data in pairs(lackItems) do
      LWResourceLackUtil:GotoResourceItemLack(data.id, data.count)
      break
    end
    return
  end
  self.ctrl:CloseSelf()
  SFSNetwork.SendMessage(MsgDefines.TacticalWeaponLevelUpMessage, self.weaponInfo.id, 0, self.weaponInfo.levelTemplate.upgradeType)
end

UILWTacticalWeaponLevelUpView.OnCreate = OnCreate
UILWTacticalWeaponLevelUpView.OnDestroy = OnDestroy
UILWTacticalWeaponLevelUpView.OnEnable = OnEnable
UILWTacticalWeaponLevelUpView.OnDisable = OnDisable
UILWTacticalWeaponLevelUpView.OnAddListener = OnAddListener
UILWTacticalWeaponLevelUpView.OnRemoveListener = OnRemoveListener
UILWTacticalWeaponLevelUpView.ComponentDefine = ComponentDefine
UILWTacticalWeaponLevelUpView.DataDefine = DataDefine
UILWTacticalWeaponLevelUpView.ComponentDestroy = ComponentDestroy
UILWTacticalWeaponLevelUpView.DataDestroy = DataDestroy
UILWTacticalWeaponLevelUpView.ClearAttrs = ClearAttrs
UILWTacticalWeaponLevelUpView.ClearCostItems = ClearCostItems
UILWTacticalWeaponLevelUpView.UpdateView = UpdateView
UILWTacticalWeaponLevelUpView.OnResOrItemUpdate = OnResOrItemUpdate
UILWTacticalWeaponLevelUpView.OnLevelUpBtnClick = OnLevelUpBtnClick
return UILWTacticalWeaponLevelUpView
