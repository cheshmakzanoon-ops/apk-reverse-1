local base = UIBaseContainer
local UWEnhanceContent = BaseClass("UWEnhanceContent", base)
local WeaponCostGroup = require("UI.UILWHero.UIHeroDetailPanel.Component.WeaponCostGroup")
local UWEnhanceConditionIcon = require("UI.UILWHero.UIHeroDetailPanel.Component.UniqueWeapon.UWEnhanceConditionIcon")
local WeaponEnhanceUnitIcon = require("UI.UILWHero.UIHeroDetailPanel.Component.UniqueWeapon.WeaponEnhanceUnitIcon")
local WeaponEnhanceEffectLine = require("UI.UILWHero.UIHeroDetailPanel.Component.UniqueWeapon.WeaponEnhanceEffectLine")
local weapon_unit_path = "CenterHeroInfo/parts/weapon_unit_icon"
local energy_unit_path = "CenterHeroInfo/parts/energy_unit_icon"
local armor_unit_path = "CenterHeroInfo/parts/armor_unit_icon"
local all_attr_line_path = "CenterHeroInfo/ContentContainer/all_attr_line"
local self_attr_line_path = "CenterHeroInfo/ContentContainer/self_attr_line"
local btn_container_path = "CenterBottomInfo/btnLayOut"
local useComBtn_container_path = "CenterBottomInfo/btnLayOut/useComBtnContainer"
local useComBtn_path = "CenterBottomInfo/btnLayOut/useComBtnContainer/useComBtn"
local useComBtn_costGroup_path = "CenterBottomInfo/btnLayOut/useComBtnContainer/groupLayOut"
local upgradeBtn_container_path = "CenterBottomInfo/btnLayOut/upgradeBtnContainer"
local upgradeBtn_path = "CenterBottomInfo/btnLayOut/upgradeBtnContainer/upgradeBtn"
local upgradeBtn_red_path = "CenterBottomInfo/btnLayOut/upgradeBtnContainer/upgradeBtn/upgradeBtnRedPoint"
local upgradeBtn_costGroup_path = "CenterBottomInfo/btnLayOut/upgradeBtnContainer/CostGroup"
local lockCondition_container_path = "CenterBottomInfo/lockCondition_container"
local lockCondition_tip_txt_path = "CenterBottomInfo/lockCondition_container/lockCondition_tip_txt"
local lockCondition_group_path = "CenterBottomInfo/lockCondition_container/conditions"
local upgradeBtn_txt_path = "CenterBottomInfo/btnLayOut/upgradeBtnContainer/upgradeBtn/upgradeBtnTxt"
local maxLv_tip_txt_path = "CenterBottomInfo/maxLv_tip_txt"
local decoration_icon_path = "CenterHeroInfo/bg3"
local CONDITION_ICON_PATH = "Assets/Main/Prefabs/UI/UIHero/LWHero/UniqueWeapon/UWEnhanceConditionIcon.prefab"
local decoration_icon_positions = {
  [HeroUWEnhanceUnitType.Weapon] = {-202, -532.5},
  [HeroUWEnhanceUnitType.Energy] = {-13, -532.5},
  [HeroUWEnhanceUnitType.Armor] = {202, -532.5}
}

local function OnCreate(self, weaponPage)
  base.OnCreate(self)
  self:ComponentDefine(weaponPage)
  self:DataDefine()
end

local function OnDestroy(self)
  if self.waitTimerCallback then
    self.waitTimerCallback = nil
  end
  self:DataDestroy()
  self:ClearAllEffects()
  self:ComponentDestroy()
  self.weaponPage = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:InitUnitList()
  self:StopWaitingForMsg()
end

local function OnDisable(self)
  base.OnDisable(self)
  self:StopWaitingForMsg()
end

local function ComponentDefine(self, weaponPage)
  self.weapon_unit = self:AddComponent(WeaponEnhanceUnitIcon, weapon_unit_path)
  self.energy_unit = self:AddComponent(WeaponEnhanceUnitIcon, energy_unit_path)
  self.armor_unit = self:AddComponent(WeaponEnhanceUnitIcon, armor_unit_path)
  self.all_attr_line = self:AddComponent(WeaponEnhanceEffectLine, all_attr_line_path)
  self.self_attr_line = self:AddComponent(WeaponEnhanceEffectLine, self_attr_line_path)
  self.btn_container = self:AddComponent(UIBaseContainer, btn_container_path)
  self.useComBtn_container = self:AddComponent(UIBaseContainer, useComBtn_container_path)
  self.useComBtn = self:AddComponent(UIButton, useComBtn_path)
  self.useComBtn_costGroup = self:AddComponent(UIBaseContainer, useComBtn_costGroup_path)
  self.upgradeBtn_container = self:AddComponent(UIBaseContainer, upgradeBtn_container_path)
  self.upgradeBtn = self:AddComponent(UIButton, upgradeBtn_path)
  self.upgradeBtn_red = self:AddComponent(UIBaseContainer, upgradeBtn_red_path)
  self.upgradeBtn_costGroup = self:AddComponent(UIBaseContainer, upgradeBtn_costGroup_path)
  self.lockCondition_container = self:AddComponent(UIBaseContainer, lockCondition_container_path)
  self.lockCondition_tip_txt = self:AddComponent(UIText, lockCondition_tip_txt_path)
  self.lockCondition_group = self:AddComponent(UIBaseContainer, lockCondition_group_path)
  self.upgradeBtn_txt = self:AddComponent(UIText, upgradeBtn_txt_path)
  self.maxLv_tip_txt = self:AddComponent(UIText, maxLv_tip_txt_path)
  self.decoration_icon = self:AddComponent(UIBaseContainer, decoration_icon_path)
  self.useComBtn:SetOnClick(function()
    self:OnUseComBtnClick()
  end)
  self.upgradeBtn:SetOnClick(function()
    self:OnUpgradeBtnClick()
  end)
  self:InitUnitList()
  self.weaponPage = weaponPage
end

local function ComponentDestroy(self)
  self.weapon_unit = nil
  self.energy_unit = nil
  self.armor_unit = nil
  self.all_attr_line = nil
  self.self_attr_line = nil
  self.btn_container = nil
  self.useComBtn_container = nil
  self.useComBtn = nil
  self.useComBtn_costGroup = nil
  self.upgradeBtn_container = nil
  self.upgradeBtn = nil
  self.upgradeBtn_red = nil
  self.upgradeBtn_costGroup = nil
  self.lockCondition_container = nil
  self.lockCondition_tip_txt = nil
  self.lockCondition_group = nil
  self.upgradeBtn_txt = nil
  self.maxLv_tip_txt = nil
  self.decoration_icon = nil
end

local function DataDefine(self)
  self.currentSelectedUnit = nil
  self.unitList = {}
end

local function DataDestroy(self)
  self.currentSelectedUnit = nil
  self.unitList = nil
  self:ClearAllEffects()
end

function UWEnhanceContent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.OnItemRefresh)
  self:AddUIListener(EventId.HeroUWEnhanceUnitUpgrade, self.OnHeroUWUnitUpdate)
end

function UWEnhanceContent:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.OnItemRefresh)
  self:RemoveUIListener(EventId.HeroUWEnhanceUnitUpgrade, self.OnHeroUWUnitUpdate)
end

local function InitUnitList(self)
  self.unitList = {
    self.weapon_unit,
    self.energy_unit,
    self.armor_unit
  }
  self.weapon_unit:SetUnitType(HeroUWEnhanceUnitType.Weapon)
  self.energy_unit:SetUnitType(HeroUWEnhanceUnitType.Energy)
  self.armor_unit:SetUnitType(HeroUWEnhanceUnitType.Armor)
  for i, unit in ipairs(self.unitList) do
    unit:SetClickCallback(function(unitType)
      self:OnUnitSelected(i)
    end)
  end
  self:OnUnitSelected(HeroUWEnhanceUnitType.Weapon)
end

local function OnUnitSelected(self, index)
  if self.currentSelectedUnit == self.unitList[index] then
    return
  end
  self:StopWaitingForMsg()
  for i, unit in ipairs(self.unitList) do
    unit:SetSelected(i == index)
  end
  self.currentSelectedUnit = self.unitList[index]
  if not self.heroData then
    return
  end
  self:UpdateAttributeLines()
  self:RefreshBtns()
  self:StopAllEffects()
  self.decoration_icon:SetAnchoredPositionXY(decoration_icon_positions[index][1], decoration_icon_positions[index][2])
end

local function UpdateAttributeLines(self)
  if not self.currentSelectedUnit then
    return
  end
  local attrs = self.currentSelectedUnit:GetAttributes()
  self.all_attr_line:SetAllAttributes(attrs.allAttr or attrs.nextAllAttr, attrs.allValue, attrs.nextAllValue)
  self.self_attr_line:SetSelfAttributes(attrs.selfAttr or attrs.nextSelfAttr, attrs.selfValue, attrs.nextSelfValue, attrs.nextUnlockLv, attrs.nextUnlockValue)
end

function UWEnhanceContent:SetParams(params)
  self.params = params
end

function UWEnhanceContent:UpdateView(heroData)
  self.heroData = heroData
  self.weapon_unit:SetHeroData(heroData)
  self.energy_unit:SetHeroData(heroData)
  self.armor_unit:SetHeroData(heroData)
  self:StopAllEffects()
  self:RefreshView()
  local prewarmIds = {}
  for i = HeroUWEnhanceUnitType.Weapon, HeroUWEnhanceUnitType.Armor do
    if not heroData:IsUWUnitMaxLv(i) then
      table.insert(prewarmIds, i)
    end
  end
  self.weaponPage:PrewarmEnhanceEffects(prewarmIds)
  self:StopWaitingForMsg()
end

function UWEnhanceContent:RefreshView()
  self:RefreshBtns()
  self:UpdateAttributeLines()
end

local function GetCommonItemId(self)
  if not self.commonItemId then
    self.commonItemId = LuaEntry.DataConfig:TryGetNum("hero_unique_weapon", "k4", 0)
  end
  return self.commonItemId
end

function UWEnhanceContent:OnUseComBtnClick()
  if not self.heroData then
    return
  end
  if self._waitingForMsg then
    return
  end
  local fragId, costNum = self.currentSelectedUnit:GetUpgradeCost()
  if not fragId or not costNum then
    return
  end
  local haveNum = DataCenter.ItemData:GetItemCount(fragId)
  if costNum <= haveNum then
    return
  end
  local commonItemId = GetCommonItemId(self)
  local haveCommonNum = DataCenter.ItemData:GetItemCount(commonItemId)
  local needNum = costNum - haveNum
  if haveCommonNum < needNum then
    LWResourceLackUtil:GotoGoodsItemLack(commonItemId, needNum)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.UWEnhanceUpgrade, tonumber(self.heroData.uuid), self.currentSelectedUnit:GetUnitType(), true)
  self:StartWaitingForMsg()
end

function UWEnhanceContent:OnUpgradeBtnClick()
  if not self.heroData then
    return
  end
  if self._waitingForMsg then
    return
  end
  local fragId, costNum = self.currentSelectedUnit:GetUpgradeCost()
  if not fragId or not costNum then
    return
  end
  local haveNum = DataCenter.ItemData:GetItemCount(fragId)
  if costNum > haveNum then
    LWResourceLackUtil:GotoGoodsItemLack(fragId, costNum)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.UWEnhanceUpgrade, tonumber(self.heroData.uuid), self.currentSelectedUnit:GetUnitType(), false)
  self:StartWaitingForMsg()
end

function UWEnhanceContent:StartWaitingForMsg()
  self._waitingForMsg = true
  if self.waitTimer then
    self.waitTimer:Stop()
    self.waitTimer = nil
  end
  if not self.waitTimerCallback then
    function self.waitTimerCallback()
      self._waitingForMsg = false
    end
  end
  self.waitTimer = TimerManager:GetInstance():DelayInvoke(self.waitTimerCallback, 2)
end

function UWEnhanceContent:StopWaitingForMsg()
  self._waitingForMsg = false
  if self.waitTimer then
    self.waitTimer:Stop()
    self.waitTimer = nil
  end
end

function UWEnhanceContent:ClearUpgradeCost()
  if self.upgradeCost then
    self.upgradeCost:Destroy()
    self.upgradeCost = nil
  end
end

function UWEnhanceContent:ClearUseComCost()
  if self.useComCost then
    self.useComCost:Destroy()
    self.useComCost = nil
  end
end

function UWEnhanceContent:RefreshUpgradeCosts()
  local function GetUpgradeCostItemName(index)
    return "upgradeCostItem" .. index
  end
  
  if self.upgradeCost then
    local fragId, costNum = self.currentSelectedUnit:GetUpgradeCost()
    if not fragId or not costNum then
      return
    end
    self.upgradeCost:SetData(fragId, costNum, false)
    return
  end
  if not self.upgradeCostReq then
    self.upgradeCostReq = self:GameObjectInstantiateAsync(UIAssets.WeaponCostGroup, function(request)
      local go = request.gameObject
      if IsNull(go) then
        return
      end
      go:SetActive(true)
      go.transform:SetParent(self.upgradeBtn_costGroup.transform)
      go.transform:Set_localScale(1, 1, 1)
      local name = GetUpgradeCostItemName(1)
      go.name = name
      self.upgradeCost = self.upgradeBtn_costGroup:AddComponent(WeaponCostGroup, name)
      local fragId, costNum = self.currentSelectedUnit:GetUpgradeCost()
      if not fragId or not costNum then
        return
      end
      self.upgradeCost:SetData(fragId, costNum, false)
    end)
  end
end

local function RefreshUseComCosts(self)
  local curNum = 0
  if not self.useComCostReqs then
    self.useComCostReqs = {}
  end
  curNum = #self.useComCostReqs
  local needNum = 0
  
  local function GetUseComCostItemName(index)
    return "useComCostItem" .. index
  end
  
  local fragId, costNum = self.currentSelectedUnit:GetUpgradeCost()
  local costs = {}
  local commonItemId = GetCommonItemId(self)
  local haveNum = DataCenter.ItemData:GetItemCount(fragId)
  local needFragNum = costNum - haveNum
  costs[1] = {
    itemId = commonItemId,
    itemNum = needFragNum,
    whieColor = false
  }
  needNum = 1
  costs[2] = {
    itemId = fragId,
    itemNum = haveNum,
    whieColor = haveNum <= 0
  }
  needNum = 2
  if curNum < needNum then
    for i = curNum + 1, needNum do
      local useComCostReq = self:GameObjectInstantiateAsync(UIAssets.WeaponCostGroup, function(request)
        local go = request.gameObject
        if IsNull(go) then
          return
        end
        go:SetActive(true)
        go.transform:SetParent(self.useComBtn_costGroup.transform)
        go.transform:Set_localScale(1, 1, 1)
        local name = GetUseComCostItemName(i)
        go.name = name
        local costItem = self.useComBtn_costGroup:AddComponent(WeaponCostGroup, name)
        costItem:SetData(costs[i].itemId, costs[i].itemNum, costs[i].whieColor)
      end)
      self.useComCostReqs[i] = useComCostReq
    end
  elseif curNum > needNum then
    for i = needNum + 1, curNum do
      self.useComBtn_costGroup:RemoveComponent(GetUseComCostItemName(i), WeaponCostGroup)
      self:GameObjectDestroy(self.useComCostReqs[i])
      self.useComCostReqs[i] = nil
    end
  end
  for i = 1, needNum do
    local costItem = self.useComBtn_costGroup:GetComponent(GetUseComCostItemName(i), WeaponCostGroup)
    if costItem then
      costItem:SetData(costs[i].itemId, costs[i].itemNum, costs[i].whieColor)
    end
  end
end

function UWEnhanceContent:RefreshCosts()
  if self.upgradeBtn_container:GetActive() then
    self:RefreshUpgradeCosts()
  end
  if self.useComBtn_container:GetActive() then
    RefreshUseComCosts(self)
  end
end

function UWEnhanceContent:RefreshConditions()
  if not self.currentSelectedUnit then
    return
  end
  local unlockCondition = self.currentSelectedUnit:GetUpgradeCondition()
  self.unlock_conditions = unlockCondition
  local needComps = #self.unlock_conditions
  if not self.conditionIcons then
    self.conditionIcons = {}
  end
  local curComps = #self.conditionIcons
  if needComps < curComps then
    for i = needComps + 1, curComps do
      self.conditionIcons[i]:SetActive(false)
    end
  end
  
  local function SetUnitIcon(self, icon, i)
    local unitType = self.unlock_conditions[i].type
    local needLv = self.unlock_conditions[i].level
    local curLv = self.heroData:GetUWUnitLv(unitType)
    icon:SetData(unitType, needLv, needLv <= curLv)
  end
  
  for i = 1, needComps do
    if not self.conditionIcons[i] then
      self.conditionIcons[i] = self:LoadComponentAsync(UWEnhanceConditionIcon, CONDITION_ICON_PATH, self.lockCondition_group, function(view, go, self, callback_param)
        if view.unlock_conditions[i] then
          SetUnitIcon(view, self, i)
        else
          self:SetActive(false)
        end
      end)
    elseif self.conditionIcons[i] then
      self.conditionIcons[i]:SetActive(true)
      SetUnitIcon(self, self.conditionIcons[i], i)
    end
  end
end

function UWEnhanceContent:RefreshBtns()
  if self.heroData:IsUWUnitMaxLv(self.currentSelectedUnit:GetUnitType()) then
    self.btn_container:SetActive(false)
    self.lockCondition_container:SetActive(false)
    self.maxLv_tip_txt:SetActive(true)
    return
  end
  self.maxLv_tip_txt:SetActive(false)
  local unlockCondition = self.currentSelectedUnit:GetUpgradeCondition()
  if not table.IsNullOrEmpty(unlockCondition) then
    local heroData = self.heroData
    for _, unlockCondition in pairs(unlockCondition) do
      local curUnitLv = heroData:GetUWUnitLv(unlockCondition.type)
      if curUnitLv < unlockCondition.level then
        self.btn_container:SetActive(false)
        self.lockCondition_container:SetActive(true)
        self:RefreshConditions()
        return
      end
    end
  end
  self:RefreshConditions()
  self.btn_container:SetActive(true)
  self.lockCondition_container:SetActive(false)
  local showUseComBtn = false
  local fragId, costNum = self.currentSelectedUnit:GetUpgradeCost()
  if fragId and costNum then
    local haveNum = DataCenter.ItemData:GetItemCount(fragId)
    if costNum > haveNum then
      showUseComBtn = true
    end
  end
  self.useComBtn_container:SetActive(showUseComBtn)
  local curUnitLv = self.heroData:GetUWUnitLv(self.currentSelectedUnit:GetUnitType())
  if 0 <= curUnitLv then
    self.upgradeBtn_txt:SetLocalText("hero_unique_weapon_button3")
  else
    self.upgradeBtn_txt:SetLocalText("hero_unique_weapon_button4")
  end
  self.upgradeBtn_red:SetActive(not showUseComBtn)
  self:RefreshCosts()
end

function UWEnhanceContent:OnItemRefresh()
  self:RefreshBtns()
end

function UWEnhanceContent:OnHeroUWUnitUpdate(data)
  local curUuid = self.heroData.uuid
  local uuid = data.uuid
  local unitType = data.unitType
  if uuid ~= curUuid then
    return
  end
  self:StopWaitingForMsg()
  if self.currentSelectedUnit:GetUnitType() ~= unitType then
    self:RefreshView()
    return
  end
  self:RefreshBtns()
  local displaySelfValue = self.self_attr_line:GetCurrentValue()
  local displayOverallValue = self.all_attr_line:GetCurrentValue()
  local attrs = self.currentSelectedUnit:GetAttributes()
  local nextSelfValue = attrs.selfValue
  local nextOverallValue = attrs.allValue
  self.upgradeAttrs = 0
  if displaySelfValue < nextSelfValue then
    self.upgradeAttrs = self.upgradeAttrs + 1
  end
  if displayOverallValue < nextOverallValue then
    self.upgradeAttrs = self.upgradeAttrs + 1
  end
  self:PlayEffects()
  self.weaponPage:PlayEnhanceEffects(self.currentSelectedUnit:GetUnitType())
end

local UPGRADE_EFFECT_PATH = "Assets/_Art_LastWar/Effect/Prefab/UI/2025/Eff_UI_enhance/Eff_UI_enhance_UP_001.prefab"
local TRAIL_EFFECT_PATH = "Assets/_Art_LastWar/Effect/Prefab/UI/2025/Eff_UI_enhance/Eff_UI_enhance_Trail_001.prefab"
local REFRESH_EFFECT_PATH = "Assets/_Art_LastWar/Effect/Prefab/UI/2025/Eff_UI_enhance/Eff_UI_enhance_Seeep_001.prefab"

function UWEnhanceContent:LoadAllEffects()
  if self.hasLoadAllEffects then
    return
  end
  self.hasLoadAllEffects = true
  self.effectReqs = {}
  self.effects = {}
  self.upgradeEffectReq = self:GameObjectInstantiateAsync(UPGRADE_EFFECT_PATH, function(request)
    local go = request.gameObject
    if IsNull(go) then
      return
    end
    self.upgradeEffect = go
    local transform = go.transform
    transform:SetParent(self.transform)
    transform:Set_localScale(1, 1, 1)
    transform:Set_localPosition(0, 0, 0)
    go:SetActive(false)
    table.insert(self.effects, self.upgradeEffect)
    self:OnLoadedEffect()
  end)
  table.insert(self.effectReqs, self.upgradeEffectReq)
  self.trailEffectReq = {}
  self.trailEffect = {}
  self.trailEffectReq[1] = self:GameObjectInstantiateAsync(TRAIL_EFFECT_PATH, function(request)
    local go = request.gameObject
    if IsNull(go) then
      return
    end
    self.trailEffect[1] = go
    local transform = go.transform
    transform:SetParent(self.transform)
    transform:Set_localScale(1, 1, 1)
    transform:Set_localPosition(0, 0, 0)
    go:SetActive(false)
    table.insert(self.effects, self.trailEffect[1])
    self:OnLoadedEffect()
  end)
  table.insert(self.effectReqs, self.trailEffectReq[1])
  self.trailEffectReq[2] = self:GameObjectInstantiateAsync(TRAIL_EFFECT_PATH, function(request)
    local go = request.gameObject
    if IsNull(go) then
      return
    end
    self.trailEffect[2] = go
    local transform = go.transform
    transform:SetParent(self.transform)
    transform:Set_localScale(1, 1, 1)
    transform:Set_localPosition(0, 0, 0)
    go:SetActive(false)
    table.insert(self.effects, self.trailEffect[2])
    self:OnLoadedEffect()
  end)
  table.insert(self.effectReqs, self.trailEffectReq[2])
  self.refreshEffectReq = {}
  self.refreshEffect = {}
  self.refreshEffectReq[1] = self:GameObjectInstantiateAsync(REFRESH_EFFECT_PATH, function(request)
    local go = request.gameObject
    if IsNull(go) then
      return
    end
    self.refreshEffect[1] = go
    local transform = go.transform
    transform:SetParent(self.transform)
    transform:Set_localScale(1, 1, 1)
    transform:Set_localPosition(0, 0, 0)
    go:SetActive(false)
    table.insert(self.effects, self.refreshEffect[1])
    self:OnLoadedEffect()
  end)
  table.insert(self.effectReqs, self.refreshEffectReq[1])
  self.refreshEffectReq[2] = self:GameObjectInstantiateAsync(REFRESH_EFFECT_PATH, function(request)
    local go = request.gameObject
    if IsNull(go) then
      return
    end
    self.refreshEffect[2] = go
    local transform = go.transform
    transform:SetParent(self.transform)
    transform:Set_localScale(1, 1, 1)
    transform:Set_localPosition(0, 0, 0)
    go:SetActive(false)
    table.insert(self.effects, self.refreshEffect[2])
    self:OnLoadedEffect()
  end)
  table.insert(self.effectReqs, self.refreshEffectReq[2])
end

function UWEnhanceContent:ClearAllEffects()
  if self.hasLoadAllEffects then
    self.hasLoadAllEffects = false
    self.upgradeEffectReq:Destroy()
    for _, req in pairs(self.trailEffectReq) do
      req:Destroy()
    end
    for _, req in pairs(self.refreshEffectReq) do
      req:Destroy()
    end
    self.upgradeEffect = nil
    self.trailEffect = nil
    self.refreshEffect = nil
  end
  self.playUpgradeEffect = false
end

function UWEnhanceContent:StopAllEffects()
  if not self.hasLoadAllEffects then
    return
  end
  if self.upgradeSequence then
    self.upgradeSequence:Kill()
  end
  if self.upgradeEffect then
    self.upgradeEffect:SetActive(false)
  end
  if self.trailEffect then
    for _, effect in pairs(self.trailEffect) do
      effect:SetActive(false)
    end
  end
  if self.refreshEffect then
    for _, effect in pairs(self.refreshEffect) do
      effect:SetActive(false)
    end
  end
  self.playUpgradeEffect = false
end

function UWEnhanceContent:OnLoadedEffect()
  self:PlayEffectSequence()
end

local ControlPointOffset = Vector3.New(0, 80, 0)
local MinRange = -50.0
local MaxRange = 50.0

function UWEnhanceContent:PlayEffectSequence()
  if #self.effects >= #self.effectReqs then
    if not self.playUpgradeEffect then
      return
    end
    self:StopAllEffects()
    self.upgradeSequence = DOTween.Sequence()
    local worldX, worldY, worldZ = self.currentSelectedUnit:GetPositionXYZ()
    self.upgradeSequence:AppendCallback(function()
      self.upgradeEffect:SetActive(true)
      self.upgradeEffect.transform:Set_position(worldX, worldY, worldZ)
    end)
    self.upgradeSequence:AppendInterval(0.85)
    self.upgradeSequence:AppendCallback(function()
      self.upgradeEffect:SetActive(false)
    end)
    self.upgradeSequence:InsertCallback(0.1, function()
      self.trailEffect[1]:SetActive(true)
      self.trailEffect[1].transform:Set_position(worldX, worldY, worldZ)
    end)
    if self.upgradeAttrs > 1 then
      self.upgradeSequence:InsertCallback(0.1, function()
        self.trailEffect[2]:SetActive(true)
        self.trailEffect[2].transform:Set_position(worldX, worldY, worldZ)
      end)
    end
    local overaAnchorllPos = self.all_attr_line:GetEffectAnchorWorldPos()
    local selfAnchorPos = self.self_attr_line:GetEffectAnchorWorldPos()
    local startPos = Vector3.New(worldX, worldY, worldZ)
    
    local function getBezierPath(startPos, destPos)
      local cross = Vector3.Cross(startPos, destPos)
      local controlPos = Vector3.zero
      if cross.y > 0 then
        controlPos = (startPos + destPos) * 0.5 + ControlPointOffset + Vector3.New(math.random(MinRange, MaxRange), math.random(MinRange, MaxRange), 0)
      else
        controlPos = (startPos + destPos) * 0.5 - ControlPointOffset + Vector3.New(math.random(MinRange, MaxRange), math.random(MinRange, MaxRange), 0)
      end
      local pathVec = DataCenter.FlyController.Bezier2Path(startPos, controlPos, destPos)
      return pathVec
    end
    
    self.upgradeSequence:Insert(0.1, self.trailEffect[1].transform:DOPath(getBezierPath(startPos, overaAnchorllPos), 0.5))
    if self.upgradeAttrs > 1 then
      self.upgradeSequence:Insert(0.1, self.trailEffect[2].transform:DOPath(getBezierPath(startPos, selfAnchorPos), 0.5))
    end
    local overallPosX, overallPosY, overallPosZ = self.all_attr_line:GetPositionXYZ()
    local selfPosX, selfPosY, selfPosZ = self.self_attr_line:GetPositionXYZ()
    self.upgradeSequence:InsertCallback(0.55, function()
      self.refreshEffect[1]:SetActive(true)
      self.refreshEffect[1].transform:Set_position(overallPosX, overallPosY, overallPosZ)
    end)
    if self.upgradeAttrs > 1 then
      self.upgradeSequence:InsertCallback(0.55, function()
        self.refreshEffect[2]:SetActive(true)
        self.refreshEffect[2].transform:Set_position(selfPosX, selfPosY, selfPosZ)
      end)
    end
    self.upgradeSequence:AppendInterval(0.1)
    self.upgradeSequence:AppendCallback(function()
      self:RefreshView()
    end)
  end
end

function UWEnhanceContent:PlayEffects()
  self.playUpgradeEffect = true
  if not self.hasLoadAllEffects then
    self:LoadAllEffects()
    return
  end
  self:PlayEffectSequence()
end

UWEnhanceContent.OnCreate = OnCreate
UWEnhanceContent.OnDestroy = OnDestroy
UWEnhanceContent.OnEnable = OnEnable
UWEnhanceContent.OnDisable = OnDisable
UWEnhanceContent.ComponentDefine = ComponentDefine
UWEnhanceContent.ComponentDestroy = ComponentDestroy
UWEnhanceContent.DataDefine = DataDefine
UWEnhanceContent.DataDestroy = DataDestroy
UWEnhanceContent.InitUnitList = InitUnitList
UWEnhanceContent.OnUnitSelected = OnUnitSelected
UWEnhanceContent.UpdateAttributeLines = UpdateAttributeLines
return UWEnhanceContent
