local base = UIBaseContainer
local UniqueWeaponContent = BaseClass("UniqueWeaponContent", base)
local WeaponCostGroup = require("UI.UILWHero.UIHeroDetailPanel.Component.WeaponCostGroup")
local UIHeroUniqueWeaponPreviewLine = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroUniqueWeaponPreviewLine")
local UIHeroEffectItem = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroEffectItem")
local upgradeLines_path = "CenterHeroInfo/ContentContainer/UpgradeLines"
local skillList_path = "CenterHeroInfo/ContentContainer/SkillList"
local maxLvTip_txt_path = "CenterBottomInfo/MaxLvTipText"
local btns_container_path = "CenterBottomInfo/btnLayOut"
local useComBtn_container_path = "CenterBottomInfo/btnLayOut/useComBtnContainer"
local useCom_btn_path = "CenterBottomInfo/btnLayOut/useComBtnContainer/useComBtn"
local useComCost_container_path = "CenterBottomInfo/btnLayOut/useComBtnContainer/groupLayOut"
local upgradeBtn_container_path = "CenterBottomInfo/btnLayOut/upgradeBtnContainer"
local upgrade_btn_path = "CenterBottomInfo/btnLayOut/upgradeBtnContainer/upgradeBtn"
local upgradeCost_container_path = "CenterBottomInfo/btnLayOut/upgradeBtnContainer/CostGroup"
local conditionTip_txt_path = "CenterBottomInfo/ConditionTipText"
local useComBtn_txt_path = "CenterBottomInfo/btnLayOut/useComBtnContainer/useComBtn/useComBtnText"
local upgradeBtn_txt_path = "CenterBottomInfo/btnLayOut/upgradeBtnContainer/upgradeBtn/upgradeBtnTxt"
local upgradeBtnRedPoint_path = "CenterBottomInfo/btnLayOut/upgradeBtnContainer/upgradeBtn/upgradeBtnRedPoint"
local weaponLockTip_txt_path = "CenterBottomInfo/WeaponLockTipText"
local centerHeroInfo_path = "CenterHeroInfo"
local centerBottomInfo_path = "CenterBottomInfo"
local unlockEnhance_container_path = "CenterBottomInfo/btnLayOut/unlockEnhanceContainer"
local unlockTip_txt_path = "CenterBottomInfo/btnLayOut/unlockEnhanceContainer/unlockTip_txt"
local unlock_enhance_btn_path = "CenterBottomInfo/btnLayOut/unlockEnhanceContainer/unlockEnhance_btn"

local function OnCreate(self, weaponPage)
  base.OnCreate(self)
  self:ComponentDefine(weaponPage)
  self:DataDefine()
end

local function OnDestroy(self)
  self:RemoveUpgradeCostItems()
  self:RemoveUseComCostItems()
  self:RemoveAttrs()
  self:RemoveSkills()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  if self.centerHeroInfo then
    self.centerHeroInfo:SetActive(true)
  end
  if self.centerBottomInfo then
    self.centerBottomInfo:SetActive(true)
  end
end

local function OnDisable(self)
  if self.delayUpdateView then
    self.delayUpdateView:Stop()
    self.delayUpdateView = nil
  end
  base.OnDisable(self)
end

local function ComponentDefine(self, weaponPage)
  self.upgradeLines = self:AddComponent(UIBaseContainer, upgradeLines_path)
  self.skillList = self:AddComponent(UIBaseContainer, skillList_path)
  self.maxLvTip_txt = self:AddComponent(UIText, maxLvTip_txt_path)
  self.btns_container = self:AddComponent(UIBaseContainer, btns_container_path)
  self.useComBtn_container = self:AddComponent(UIBaseContainer, useComBtn_container_path)
  self.useCom_btn = self:AddComponent(UIButton, useCom_btn_path)
  self.useComCost_container = self:AddComponent(UIBaseContainer, useComCost_container_path)
  self.upgradeBtn_container = self:AddComponent(UIBaseContainer, upgradeBtn_container_path)
  self.upgrade_btn = self:AddComponent(UIButton, upgrade_btn_path)
  self.upgradeCost_container = self:AddComponent(UIBaseContainer, upgradeCost_container_path)
  self.conditionTip_txt = self:AddComponent(UIText, conditionTip_txt_path)
  self.useComBtn_txt = self:AddComponent(UIText, useComBtn_txt_path)
  self.upgradeBtn_txt = self:AddComponent(UIText, upgradeBtn_txt_path)
  self.upgradeBtnRedPoint = self:AddComponent(UIBaseContainer, upgradeBtnRedPoint_path)
  self.weaponLockTip_txt = self:AddComponent(UIText, weaponLockTip_txt_path)
  self.centerHeroInfo = self:AddComponent(UIBaseContainer, centerHeroInfo_path)
  self.centerBottomInfo = self:AddComponent(UIBaseContainer, centerBottomInfo_path)
  self.unlockEnhance_container = self:AddComponent(UIBaseContainer, unlockEnhance_container_path)
  self.unlockTip_txt = self:AddComponent(UIText, unlockTip_txt_path)
  self.unlock_enhance_btn = self:AddComponent(UIButton, unlock_enhance_btn_path)
  self.useCom_btn:SetOnClick(function()
    self:OnUseComBtnClick()
  end)
  self.useCom_btn:SetSafeClickMode(true)
  self.upgrade_btn:SetOnClick(function()
    self:OnUpgradeBtnClick()
  end)
  self.upgrade_btn:SetSafeClickMode(true)
  local showNeedRankId = LuaEntry.DataConfig:TryGetNum("hero_unique_weapon", "k3", 0)
  self.conditionTip_txt:SetLocalText("hero_unique_weapon_tips3", DataCenter.HeroRankTemplateManager:GetRankName(showNeedRankId))
  self.weaponLockTip_txt:SetLocalText("activity_hero_change_unique_weapon_lock_tips")
  self.unlock_enhance_btn:SetOnClick(function()
    self:OnUnlockEnhanceBtnClick()
  end)
  self.weaponPage = weaponPage
end

local function ComponentDestroy(self)
  self.upgradeLines = nil
  self.skillList = nil
  self.maxLvTip_txt = nil
  self.btns_container = nil
  self.useComBtn_container = nil
  self.useCom_btn = nil
  self.useComCost_container = nil
  self.upgradeBtn_container = nil
  self.upgrade_btn = nil
  self.upgradeCost_container = nil
  self.conditionTip_txt = nil
  self.useComBtn_txt = nil
  self.upgradeBtn_txt = nil
  self.upgradeBtnRedPoint = nil
  self.weaponLockTip_txt = nil
  self.centerHeroInfo = nil
  self.centerBottomInfo = nil
  self.unlockEnhance_container = nil
  self.unlockTip_txt = nil
  self.unlock_enhance_btn = nil
  self.weaponPage = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function UniqueWeaponContent:SetParams(params)
  self.params = params
end

local function GetCommonItemId(self)
  if not self.commonItemId then
    self.commonItemId = LuaEntry.DataConfig:TryGetNum("hero_unique_weapon", "k4", 0)
  end
  return self.commonItemId
end

function UniqueWeaponContent:OnUseComBtnClick()
  if not self.curHeroData then
    return
  end
  if self.curHeroData:CheckCanUpgradeUniqueWeapon() then
    return
  end
  if not self.nextLvWeaponTemplate then
    return
  end
  local costs = self.nextLvWeaponTemplate:GetSortedCosts()
  local costData = costs[1]
  if not costData then
    return
  end
  local haveNum = DataCenter.ItemData:GetItemCount(costData.itemId)
  if haveNum >= costData.itemNum then
    return
  end
  local commonItemId = GetCommonItemId(self)
  local haveCommonNum = DataCenter.ItemData:GetItemCount(commonItemId)
  local needNum = costData.itemNum - haveNum
  if haveCommonNum < needNum then
    LWResourceLackUtil:GotoGoodsItemLack(commonItemId, needNum)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.HeroUniqueWeaponUpgrade, tonumber(self.curHeroData.uuid), true)
end

function UniqueWeaponContent:OnUpgradeBtnClick()
  if not self.curHeroData then
    return
  end
  if self.curHeroData:CheckCanUpgradeUniqueWeapon() then
    return
  end
  if not self.nextLvWeaponTemplate then
    return
  end
  local costs = self.nextLvWeaponTemplate:GetSortedCosts()
  for i, v in pairs(costs) do
    local haveNum = DataCenter.ItemData:GetItemCount(v.itemId)
    if haveNum < v.itemNum then
      LWResourceLackUtil:GotoGoodsItemLack(v.itemId, v.itemNum)
      return
    end
  end
  SFSNetwork.SendMessage(MsgDefines.HeroUniqueWeaponUpgrade, tonumber(self.curHeroData.uuid))
end

function UniqueWeaponContent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.OnItemRefresh)
  self:AddUIListener(EventId.HeroUniqueWeaponUpgrade, self.OnHeroUniqueWeaponUpdate)
  self:AddUIListener(EventId.CloseHeroExhibit, self.OnCloseHeroExhitb)
end

function UniqueWeaponContent:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.OnItemRefresh)
  self:RemoveUIListener(EventId.HeroUniqueWeaponUpgrade, self.OnHeroUniqueWeaponUpdate)
  self:RemoveUIListener(EventId.CloseHeroExhibit, self.OnCloseHeroExhitb)
end

local function RefreshUpgradeCosts(self)
  local curNum = 0
  if not self.upgradeCostReqs then
    self.upgradeCostReqs = {}
  end
  curNum = #self.upgradeCostReqs
  local needNum = #self.upgradeCost
  
  local function GetUpgradeCostItemName(index)
    return "upgradeCostItem" .. index
  end
  
  if curNum < needNum then
    for i = curNum + 1, needNum do
      local upgradeCostReq = self:GameObjectInstantiateAsync(UIAssets.WeaponCostGroup, function(request)
        local go = request.gameObject
        if IsNull(go) then
          return
        end
        go:SetActive(true)
        go.transform:SetParent(self.upgradeCost_container.transform)
        go.transform:Set_localScale(1, 1, 1)
        local name = GetUpgradeCostItemName(i)
        go.name = name
        local costItem = self.upgradeCost_container:AddComponent(WeaponCostGroup, name)
        costItem:SetData(self.upgradeCost[i].itemId, self.upgradeCost[i].itemNum, self.upgradeCost[i].whieColor)
      end)
      self.upgradeCostReqs[i] = upgradeCostReq
    end
  elseif curNum > needNum then
    for i = needNum + 1, curNum do
      self.upgradeCost_container:RemoveComponent(GetUpgradeCostItemName(i), WeaponCostGroup)
      self:GameObjectDestroy(self.upgradeCostReqs[i])
      self.upgradeCostReqs[i] = nil
    end
  end
  for i = 1, needNum do
    local costItem = self.upgradeCost_container:GetComponent(GetUpgradeCostItemName(i), WeaponCostGroup)
    if costItem then
      costItem:SetData(self.upgradeCost[i].itemId, self.upgradeCost[i].itemNum, self.upgradeCost[i].whieColor)
    end
  end
end

local function RefreshUseComCosts(self)
  local curNum = 0
  if not self.useComCostReqs then
    self.useComCostReqs = {}
  end
  curNum = #self.useComCostReqs
  local needNum = #self.useComCosts
  
  local function GetUseComCostItemName(index)
    return "useComCostItem" .. index
  end
  
  if curNum < needNum then
    for i = curNum + 1, needNum do
      local useComCostReq = self:GameObjectInstantiateAsync(UIAssets.WeaponCostGroup, function(request)
        local go = request.gameObject
        if IsNull(go) then
          return
        end
        go:SetActive(true)
        go.transform:SetParent(self.useComCost_container.transform)
        go.transform:Set_localScale(1, 1, 1)
        local name = GetUseComCostItemName(i)
        go.name = name
        local costItem = self.useComCost_container:AddComponent(WeaponCostGroup, name)
        costItem:SetData(self.useComCosts[i].itemId, self.useComCosts[i].itemNum, self.useComCosts[i].whieColor)
      end)
      self.useComCostReqs[i] = useComCostReq
    end
  elseif curNum > needNum then
    for i = needNum + 1, curNum do
      self.useComCost_container:RemoveComponent(GetUseComCostItemName(i), WeaponCostGroup)
      self:GameObjectDestroy(self.useComCostReqs[i])
      self.useComCostReqs[i] = nil
    end
  end
  for i = 1, needNum do
    local costItem = self.useComCost_container:GetComponent(GetUseComCostItemName(i), WeaponCostGroup)
    if costItem then
      costItem:SetData(self.useComCosts[i].itemId, self.useComCosts[i].itemNum, self.useComCosts[i].whieColor)
    end
  end
end

local function RefreshCosts(self)
  if self.upgradeBtn_container:GetActive() then
    RefreshUpgradeCosts(self)
  end
  if self.useComBtn_container:GetActive() then
    RefreshUseComCosts(self)
  end
end

local function RefreshCostsData(self)
  self.upgradeCost = {}
  if self.nextLvWeaponTemplate then
    self.upgradeCost = self.nextLvWeaponTemplate:GetSortedCosts()
  end
  self.useComCosts = {}
  local commonItemId = GetCommonItemId(self)
  local costData = self.upgradeCost[1]
  if costData then
    local haveNum = DataCenter.ItemData:GetItemCount(costData.itemId)
    self.useComCosts[1] = {
      itemId = commonItemId,
      itemNum = costData.itemNum - haveNum
    }
    self.useComCosts[2] = {
      itemId = costData.itemId,
      itemNum = haveNum,
      whieColor = true
    }
  end
end

local function GetAttrNameKey(attrKey)
  if not attrKey then
    return ""
  end
  local nameKey = ""
  if attrKey == HeroEffectDefine.HeroSkillMaxLevelAdd then
    nameKey = "hero_equip_1"
  else
    nameKey = DataCenter.EffectNumberTemplateManager:GetEffectNumberName(attrKey)
  end
  return nameKey
end

local function GetFormattedAttrValue(attrKey, attrValue)
  if not attrValue then
    return nil
  end
  return HeroUtils.GetFormattedPropertyValue(attrKey, attrValue)
end

local function GetAttrLineItemName(index)
  return "attrLine" .. index
end

local function RefreshAttrs(self)
  local weaponInfo = self.curHeroData:GetUniqueWeaponInfo()
  self.sortedAttrs = {}
  if weaponInfo then
    local weaponSortedAttrs = weaponInfo:GetSortedAttrs()
    for i = 1, #weaponSortedAttrs do
      local attr = weaponSortedAttrs[i]
      self.sortedAttrs[i] = {
        key = attr.key,
        value = self.curHeroData:ProcessEffectValue(attr.key, attr.value)
      }
    end
  end
  if not self.curHeroData:IsUniqueWeaponMaxLevel() and self.nextLvWeaponTemplate then
    local nextLvAttrs = self.nextLvWeaponTemplate:GetSortedAttrs()
    
    local function GetAttrFromNextLvTemplate(key)
      for k, v in pairs(nextLvAttrs) do
        if v.key == key then
          return self.curHeroData:ProcessEffectValue(v.key, v.value)
        end
      end
      return 0
    end
    
    local function HasAttrInCurLvTemplate(key)
      for k, v in pairs(self.sortedAttrs) do
        if v.key == key then
          return true
        end
      end
      return false
    end
    
    for i, v in pairs(self.sortedAttrs) do
      local nextLvValue = GetAttrFromNextLvTemplate(v.key)
      v.nextValue = nextLvValue
    end
    for i, v in pairs(nextLvAttrs) do
      local has = HasAttrInCurLvTemplate(v.key)
      if not has then
        self.sortedAttrs[#self.sortedAttrs + 1] = {
          key = v.key,
          nextValue = self.curHeroData:ProcessEffectValue(v.key, v.value)
        }
      end
    end
  end
  local curNum = 0
  if not self.attrReqs then
    self.attrReqs = {}
  end
  curNum = #self.attrReqs
  local needNum = #self.sortedAttrs
  if curNum < needNum then
    for i = curNum + 1, needNum do
      local attrReq = self:GameObjectInstantiateAsync(UIAssets.UIHeroAttrLine, function(request)
        local go = request.gameObject
        if IsNull(go) then
          return
        end
        go:SetActive(true)
        go.transform:SetParent(self.upgradeLines.transform)
        go.transform:Set_localScale(1, 1, 1)
        local name = GetAttrLineItemName(i)
        go.name = name
        local line = self.upgradeLines:AddComponent(UIHeroUniqueWeaponPreviewLine, name)
        line:SetSizeDeltaXY(577.4, 51)
        line:SetName(GetAttrNameKey(self.sortedAttrs[i].key))
        local nextValue
        if self.sortedAttrs[i].value ~= self.sortedAttrs[i].nextValue then
          nextValue = GetFormattedAttrValue(self.sortedAttrs[i].key, self.sortedAttrs[i].nextValue)
        end
        line:SetData(GetFormattedAttrValue(self.sortedAttrs[i].key, self.sortedAttrs[i].value), nextValue, i)
      end)
      self.attrReqs[i] = attrReq
    end
  elseif curNum > needNum then
    for i = needNum + 1, curNum do
      self.upgradeLines:RemoveComponent(GetAttrLineItemName(i), UIHeroUniqueWeaponPreviewLine)
      self:GameObjectDestroy(self.attrReqs[i])
      self.attrReqs[i] = nil
    end
  end
  for i, v in pairs(self.sortedAttrs) do
    local line = self.upgradeLines:GetComponent(GetAttrLineItemName(i), UIHeroUniqueWeaponPreviewLine)
    if line then
      line:SetName(GetAttrNameKey(v.key))
      local nextValue
      if v.value ~= v.nextValue then
        nextValue = GetFormattedAttrValue(v.key, v.nextValue)
      end
      line:SetData(GetFormattedAttrValue(v.key, v.value), nextValue, i)
    end
  end
end

local function GetSkillItemName(index)
  return "skillItem" .. index
end

local function RefreshSkillItem(self, skillItem, index)
  if not skillItem then
    return
  end
  local effectData = self.effectsData[index]
  if not effectData then
    return
  end
  local weaponLv = effectData.weaponLv
  if not self.clickItemCallback then
    function self.clickItemCallback(id, skillItem)
      local effectData = self.effectsData[id]
      
      local _weaponLv = effectData.weaponLv
      local desc = ""
      if _weaponLv > self.curHeroData:GetUniqueWeaponLv() then
        desc = string.format([[
%s
%s]], CS.GameEntry.Localization:GetString(effectData.desc, SafeUnpack(effectData.desc_para)), UIUtil.GetString("", "hero_unique_weapon_tips4", _weaponLv))
      else
        desc = CS.GameEntry.Localization:GetString(effectData.desc, SafeUnpack(effectData.desc_para))
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroWeaponSkillTip, {anim = true}, {
        alignObject = skillItem,
        name = effectData.name,
        desc = effectData.desc,
        skillId = effectData.displaySkillId,
        skillLv = 1,
        skillMaxLv = 0,
        heroId = self.curHeroData.heroId,
        desc = desc,
        weaponLv = _weaponLv
      })
    end
  end
  skillItem:SetData(index, effectData.icon, weaponLv > self.curHeroData:GetUniqueWeaponLv(), self.clickItemCallback)
  skillItem:ShowWillUnlockEffect(self.curHeroData:GetUniqueWeaponLv() + 1 == weaponLv)
end

local function RefreshEffects(self)
  local attr, effects, previewSkills, weapon = DataCenter.HeroUniqueWeaponTemplateManager:GetMaxLevelWeaponoEffects(self.curHeroData.heroId)
  self.effectsData = effects
  local curNum = 0
  if not self.skillReqs then
    self.skillReqs = {}
  end
  curNum = #self.skillReqs
  local needNum = #self.effectsData
  if curNum < needNum then
    for i = curNum + 1, needNum do
      local skillReq = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/UIHero/LWHero/UniqueWeapon/UIHeroEffectItem.prefab", function(request)
        local go = request.gameObject
        if IsNull(go) then
          return
        end
        go:SetActive(true)
        go.transform:SetParent(self.skillList.transform)
        go.transform:Set_localScale(1, 1, 1)
        local name = GetSkillItemName(i)
        go.name = name
        local skillItem = self.skillList:AddComponent(UIHeroEffectItem, name)
        skillItem:SetSizeDeltaXY(122, 154)
        RefreshSkillItem(self, skillItem, i)
      end)
      self.skillReqs[i] = skillReq
    end
  elseif curNum > needNum then
    for i = needNum + 1, curNum do
      self.skillList:RemoveComponent(GetSkillItemName(i), UIHeroEffectItem)
      self:GameObjectDestroy(self.skillReqs[i])
      self.skillReqs[i] = nil
    end
  end
  for i = 1, needNum do
    local skillItem = self.skillList:GetComponent(GetSkillItemName(i), UIHeroEffectItem)
    if skillItem then
      RefreshSkillItem(self, skillItem, i)
    end
  end
end

local function RefreshBtns(self)
  if self.curHeroData:IsUniqueWeaponMaxLevel() and self.curHeroData:IsUniqueWeaponOpen() then
    self.conditionTip_txt:SetActive(false)
    self.weaponLockTip_txt:SetActive(false)
    self.useComBtn_container:SetActive(false)
    self.upgradeBtn_container:SetActive(false)
    if self.curHeroData:CanUnlockEnhanceUW() and not self.curHeroData:IsUnlockedEnhanceUW() then
      self.maxLvTip_txt:SetActive(false)
      self.unlockEnhance_container:SetActive(true)
    else
      self.maxLvTip_txt:SetActive(true)
      self.unlockEnhance_container:SetActive(false)
    end
    return
  else
    self.maxLvTip_txt:SetActive(false)
    self.unlockEnhance_container:SetActive(false)
  end
  if self.curHeroData:IsUniqueWeaponOpen() then
    self.conditionTip_txt:SetActive(false)
    self.weaponLockTip_txt:SetActive(false)
    RefreshCostsData(self)
    local haveEnough = true
    for i, data in pairs(self.upgradeCost) do
      local itemId = data.itemId
      local num = data.itemNum
      local haveNum = DataCenter.ItemData:GetItemCount(itemId)
      if num > haveNum then
        haveEnough = false
        break
      end
    end
    if self.curHeroData:GetUniqueWeaponLv() > 0 then
      if haveEnough then
        self.useComBtn_container:SetActive(false)
        self.upgradeBtn_container:SetActive(true)
        self.upgradeBtnRedPoint:SetActive(true)
      else
        self.useComBtn_container:SetActive(true)
        self.upgradeBtn_container:SetActive(true)
        self.upgradeBtnRedPoint:SetActive(false)
      end
      self.upgradeBtn_txt:SetLocalText("hero_unique_weapon_button3")
    else
      self.useComBtn_container:SetActive(false)
      self.upgradeBtn_container:SetActive(true)
      self.upgradeBtnRedPoint:SetActive(haveEnough)
      self.upgradeBtn_txt:SetLocalText("hero_unique_weapon_button2")
    end
    RefreshCosts(self)
  else
    self.conditionTip_txt:SetActive(false)
    self.weaponLockTip_txt:SetActive(false)
    if self.curHeroData:IsUniqueWeaponLockState() then
      self.weaponLockTip_txt:SetActive(true)
    else
      self.conditionTip_txt:SetActive(true)
    end
    self.useComBtn_container:SetActive(false)
    self.upgradeBtn_container:SetActive(false)
  end
end

function UniqueWeaponContent:OnItemRefresh()
  RefreshCosts(self)
  RefreshBtns(self)
end

function UniqueWeaponContent:RemoveUpgradeCostItems()
  self.upgradeCost_container:RemoveComponents(WeaponCostGroup)
  if self.upgradeCostReqs then
    for i, v in pairs(self.upgradeCostReqs) do
      self:GameObjectDestroy(v)
    end
    self.upgradeCostReqs = {}
  end
end

function UniqueWeaponContent:RemoveUseComCostItems()
  self.useComCost_container:RemoveComponents(WeaponCostGroup)
  if self.useComCostReqs then
    for i, v in pairs(self.useComCostReqs) do
      self:GameObjectDestroy(v)
    end
    self.useComCostReqs = {}
  end
end

function UniqueWeaponContent:RemoveAttrs()
  self.upgradeLines:RemoveComponents(UIHeroUniqueWeaponPreviewLine)
  if self.attrReqs then
    for i, v in pairs(self.attrReqs) do
      self:GameObjectDestroy(v)
    end
    self.attrReqs = {}
  end
end

function UniqueWeaponContent:RemoveSkills()
  self.skillList:RemoveComponents(UIHeroEffectItem)
  if self.skillReqs then
    for i, v in pairs(self.skillReqs) do
      self:GameObjectDestroy(v)
    end
    self.skillReqs = {}
  end
end

function UniqueWeaponContent:UpdateViewWhenUpgrade()
  self.nextLvWeaponTemplate = nil
  if not self.curHeroData:IsUniqueWeaponMaxLevel() then
    local nextLv = self.curHeroData:GetUniqueWeaponLv() + 1
    self.nextLvWeaponTemplate = DataCenter.HeroUniqueWeaponTemplateManager:GetTemplateByHeroId(self.curHeroData.heroId, nextLv)
  end
  RefreshBtns(self)
end

function UniqueWeaponContent:UpdateView(heroData)
  self.curHeroData = heroData
  self.weaponLv = self.curHeroData:GetUniqueWeaponLv()
  self.nextLvWeaponTemplate = nil
  if not self.curHeroData:IsUniqueWeaponMaxLevel() then
    local nextLv = self.curHeroData:GetUniqueWeaponLv() + 1
    self.nextLvWeaponTemplate = DataCenter.HeroUniqueWeaponTemplateManager:GetTemplateByHeroId(self.curHeroData.heroId, nextLv)
  end
  RefreshBtns(self)
  RefreshAttrs(self)
  RefreshEffects(self)
end

local function PlayUpgradeEffect(self)
  local prevLv = self.weaponLv
  local curLv = self.curHeroData:GetUniqueWeaponLv()
  if prevLv and prevLv == curLv then
    self:UpdateView(self.curHeroData)
    return
  end
  self.weaponLv = curLv
  self:UpdateViewWhenUpgrade(self.curHeroData)
  self.weaponPage:FlushLvUpgradeEffect()
  self.weaponPage:HeroModelPlayUpgradeEffect()
  self.weaponPage:RefreshHeroModel()
  local animTime = 0
  for i = 1, #self.effectsData do
    local skillData = self.effectsData[i]
    local weaponLv = skillData.weaponLv
    if prevLv < weaponLv and curLv >= weaponLv then
      local skillItem = self.skillList:GetComponent(GetSkillItemName(i), UIHeroEffectItem)
      if skillItem then
        skillItem:PlayUnlockEffect()
        if animTime == 0 then
          animTime = 0.5
        end
      end
    end
  end
  local prevAttrs = self.sortedAttrs
  RefreshAttrs(self)
  local curAttrs = self.sortedAttrs
  
  local function GetAttrInPrev(key)
    if prevAttrs == nil then
      return nil
    end
    for i, v in pairs(prevAttrs) do
      if v.key == key then
        return v
      end
    end
    return nil
  end
  
  for i = 1, #curAttrs do
    local curAttr = curAttrs[i]
    local prevAttr = GetAttrInPrev(curAttr.key)
    if prevAttr == nil or curAttr.value ~= prevAttr.value then
      local line = self.upgradeLines:GetComponent(GetAttrLineItemName(i), UIHeroUniqueWeaponPreviewLine)
      if line then
        line:PlayeLineEffect()
        if animTime == 0 then
          animTime = 0.5
        end
      end
    end
  end
  if self.delayUpdateView then
    self.delayUpdateView:Stop()
    self.delayUpdateView = nil
  end
  if 0 < animTime then
    self.delayUpdateView = TimerManager:GetInstance():DelayInvoke(function()
      self:UpdateView(self.curHeroData)
    end, animTime)
  else
    self:UpdateView(self.curHeroData)
  end
end

function UniqueWeaponContent:OnHeroUniqueWeaponUpdate(heroUuid)
  if not self.curHeroData then
    return
  end
  if self.curHeroData.uuid ~= heroUuid then
    return
  end
  if self.delayUpdateView then
    self.delayUpdateView:Stop()
    self.delayUpdateView = nil
  end
  local heroId = self.curHeroData.heroId
  local heroUuid = self.curHeroData.uuid
  local prevLevel = self.curHeroData:GetUniqueWeaponLv() - 1
  local prevModelId = self.curHeroData.meta ~= nil and self.curHeroData.meta.appearance or 0
  if 0 < prevLevel then
    local prevLevelWepaonTemplate = DataCenter.HeroUniqueWeaponTemplateManager:GetTemplateByHeroId(heroId, prevLevel)
    if prevLevelWepaonTemplate then
      prevModelId = prevLevelWepaonTemplate.modelId
    end
  end
  local curModelId = self.curHeroData.modelId
  if prevModelId ~= curModelId then
    local prevSpinePath = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), prevModelId, "hero_showtime_name")
    local curSpinePath = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), curModelId, "hero_showtime_name")
    if prevSpinePath ~= curSpinePath then
      local prevModelPath = HeroUtils.GetHeroModelData(heroId, HeroModelType.PBR, prevLevel, self.curHeroData:GetSkinId(), self.curHeroData:GetRank())
      local curModelPath = self.curHeroData:GetHeroModelData(HeroModelType.PBR)
      
      local function aniStartCallback()
        if self.centerHeroInfo and self.centerBottomInfo then
          self.centerHeroInfo:SetActive(false)
          self.weaponPage:SetRightTopInfoActive(false)
          self.weaponPage:SetCenterInfoActive(false)
          self.weaponPage:SetMaskActive(false)
          self.centerBottomInfo:SetActive(false)
        end
        if self.params ~= nil then
          for k, v in pairs(self.params) do
            if v ~= nil then
              v:SetActive(false)
            end
          end
        end
      end
      
      local function aniFinishCallback()
        if self.centerHeroInfo and self.centerBottomInfo then
          self.centerHeroInfo:SetActive(true)
          self.weaponPage:SetRightTopInfoActive(true)
          self.weaponPage:SetCenterInfoActive(true)
          self.weaponPage:SetMaskActive(true)
          self.centerBottomInfo:SetActive(true)
        end
        if self.params ~= nil then
          for k, v in pairs(self.params) do
            if v ~= nil then
              v:SetActive(true)
            end
          end
        end
        self.weaponPage:SetHeroModelEnable(false)
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroExhibitPanel, {anim = false}, heroUuid, {heroUuid}, nil, false, nil, false, "", false)
      end
      
      self.weaponPage:SetPlatformUpgradeEffect(prevModelPath, curModelPath, aniStartCallback, aniFinishCallback)
      return
    end
  else
    PlayUpgradeEffect(self)
  end
end

function UniqueWeaponContent:OnCloseHeroExhitb(heroUuid)
  if not self.curHeroData then
    return
  end
  if self.curHeroData.uuid ~= heroUuid then
    return
  end
  self.weaponPage:SetHeroModelEnable(true)
  PlayUpgradeEffect(self)
end

function UniqueWeaponContent:OnUnlockEnhanceBtnClick()
  SFSNetwork.SendMessage(MsgDefines.UWEnhanceUnlock, tonumber(self.curHeroData.uuid))
end

UniqueWeaponContent.OnCreate = OnCreate
UniqueWeaponContent.OnDestroy = OnDestroy
UniqueWeaponContent.OnEnable = OnEnable
UniqueWeaponContent.OnDisable = OnDisable
UniqueWeaponContent.ComponentDefine = ComponentDefine
UniqueWeaponContent.ComponentDestroy = ComponentDestroy
UniqueWeaponContent.DataDefine = DataDefine
UniqueWeaponContent.DataDestroy = DataDestroy
return UniqueWeaponContent
