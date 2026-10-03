local TacticalWeaponBasicPage = BaseClass("TacticalWeaponBasicPage", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local UIHeroSimpleTipView = require("UI.UILWHero.UIHeroSimpleTip.View.UIHeroSimpleTipView")
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local TacticalWeaponAttrLineItem = require("UI.UILWTacticalWeapon.Component.BasicPage.TacticalWeaponAttrLineItem")
local TacticalWeaponCostItem = require("UI.UILWTacticalWeapon.Component.BasicPage.TacticalWeaponCostItem")
local UIHeroSkillItem = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillItem")
local TacticalWeaponCriticalItem = require("UI.UILWTacticalWeapon.Component.TacticalWeaponCriticalItem")
local upgrade_btn_path = "Btns/UpgradeBtn"
local upgrade_btn_redPoint_path = "Btns/UpgradeBtn/UpgradeBtnRedPoint"
local autoUpgrade_btn_path = "Btns/AutoUpgradeBtn"
local autoUpgrade_btn_redPoint_path = "Btns/AutoUpgradeBtn/AutoUpgradeBtnRedPoint"
local attrs_path = "Attrs"
local attrLineTemplate_path = "Attrs/AttrLine"
local upgradeContainer_path = "UpgradeContainer"
local levelText_path = "UpgradeContainer/LevelBg/LevelText"
local levelProgress_text_path = "UpgradeContainer/ProgressText"
local level_display_btn_path = "levelDisplayBtnRoot/levelDisplayBtn"
local level_display_btn_name_path = "levelDisplayBtnRoot/levelDisplayBtnName"
local level_display_btn_root_path = "levelDisplayBtnRoot"
local title_skill_path = "attBg/titleSkill"
local title_attribute_path = "attBg/titleAttribute"
local normal_level_progress_root_path = "UpgradeContainer/normalLevelProgressRoot"
local sub_level_progress_root_path = "UpgradeContainer/subLevelProgressRoot"
local level_progress_fill_path = "UpgradeContainer/normalLevelProgressRoot/LevelProgress/Bg/levelProgressFill"
local level_sub_fill_root_path = "UpgradeContainer/subLevelProgressRoot/levelSubFillRoot"
local btns_path = "Btns"
local costGroup_path = "Btns/UpgradeBtn/CostGroup"
local costResourceTemplate_path = "Btns/UpgradeBtn/CostGroup/CostResource"
local promoteTips_text_path = "PromoteTipsText"
local go_btn_path = "Btns/GoBtn"
local go_btn_text_path = "Btns/GoBtn/GoBtnText"
local upgradeCondition_path = "Btns/GoBtn/UpgradeCondition"
local upgradeCondition_icon_path = "Btns/GoBtn/UpgradeCondition/UpgradeConditionIcon"
local upgradeCondition_text_path = "Btns/GoBtn/UpgradeCondition/UpgradeConditionText"
local skillItem_path = "SkillItem"
local powerInfo_path = "PowerInfo"
local powerInfo_icon_path = "PowerInfo/PowerIcon"
local powerNumber_text_path = "PowerInfo/PowerNumberText"
local combat_effect_path = "PowerInfo/combatEffect"
local hitItem_path = "HitItem"
local hitItemContainer_path = "HitItemContainer"
local heroAdd_btn_path = "HeroAddBtn"
local skill_chip_function_unlock_btn_path = "SkillChipFuncUnlockBtn"
local count_down_time_text_path = "SkillChipFuncUnlockBtn/CountDownTimeText"
local upgrade_btn_text_path = "Btns/UpgradeBtn/UpgradeBtnText"
local effect_fly_born_node_path = "UpgradeContainer/effectFlyBornNode"
local air_point_path = "airPoint"
local anim1Time = 0.32
local progressAnimScale = 1.2
local SubLevel_AniTime = 0.3
local UPGRADE_GOLD_LIGHT_DURATION = 1
local UPGRADE_CAMERA_ANI_DURATION = 8.2
local UPGRADE_SUPER_SECOND_DURATION = 3

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearHitItems()
  self:ClearAttrs()
  self:ClearCostItems()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function TryPlayGuide(self)
  if not DataCenter.LWGuideFlowManager:IsRunning() and self.replaceModelGuideId and self.replaceModelGuideId > 0 and not DataCenter.LWGuideFlowManager:ReadDone(self.replaceModelGuideId) then
    DataCenter.LWGuideFlowManager.Runner:Run(self.replaceModelGuideId)
  end
end

local function ComponentDefine(self)
  self.upgradeBtn = self:AddComponent(UIButton, upgrade_btn_path)
  self.upgradeBtn:SetOnClick(function()
    if not self.weaponInfo then
      return
    end
    if not self.canUpgradeClick then
      return
    end
    if self.weaponInfo:GetRealTemplate().upgradeType == 1 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeaponLevelUp, {anim = true}, self.weaponInfo.id)
    else
      self:UpgradeWeapon(false)
    end
  end)
  self.upgradeBtnRedPoint = self:AddComponent(UIButton, upgrade_btn_redPoint_path)
  self.attrs = self:AddComponent(UIBaseContainer, attrs_path)
  self.attrLineTemplate = self:AddComponent(UIBaseContainer, attrLineTemplate_path)
  self.attrLineTemplate.gameObject:GameObjectCreatePool()
  self.upgradeContainer = self:AddComponent(UIBaseContainer, upgradeContainer_path)
  self.upgradeContainerPos = self.upgradeContainer:GetPosition()
  self.levelText = self:AddComponent(UIText, levelText_path)
  self.levelTextPosition = self.levelText:GetPosition()
  self.levelProgress_text = self:AddComponent(UIText, levelProgress_text_path)
  self.levelProgress_text:SetLocalScaleXYZ(1, 1, 1)
  self.btns = self:AddComponent(UIBaseContainer, btns_path)
  self.costGroup = self:AddComponent(UIBaseContainer, costGroup_path)
  self.costResourceTemplate = self:AddComponent(UIBaseContainer, costResourceTemplate_path)
  self.costResourceTemplate.gameObject:GameObjectCreatePool()
  self.promoteTips_text = self:AddComponent(UIText, promoteTips_text_path)
  self.goBtn = self:AddComponent(UIButton, go_btn_path)
  self.goBtn:SetOnClick(function()
    local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_MAIN)
    if not table.IsNullOrEmpty(buildList) then
      local buildingData = buildList[1]
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(buildingData.pointId, ForceChangeScene.City), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
        TimerManager:GetInstance():DelayInvoke(function()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, tostring(buildingData.uuid))
        end, 0.15)
      end)
    end
  end)
  self.goBtn_text = self:AddComponent(UIText, go_btn_text_path)
  self.upgradeCondition = self:AddComponent(UIBaseContainer, upgradeCondition_path)
  self.upgradeCondition_icon = self:AddComponent(UIImage, upgradeCondition_icon_path)
  self.upgradeCondition_text = self:AddComponent(UIText, upgradeCondition_text_path)
  self.skillItem = self:AddComponent(UIHeroSkillItem, skillItem_path)
  self.powerInfo = self:AddComponent(UIBaseContainer, powerInfo_path)
  self.combat_effect = self:AddComponent(UIBaseContainer, combat_effect_path)
  self.powerInfo_icon = self:AddComponent(UIImage, powerInfo_icon_path)
  self.powerNumber_text = self:AddComponent(UIText, powerNumber_text_path)
  self.powerNumber_text_transform = self.powerNumber_text.transform
  self.powerNumber_text:SetLocalPositionXYZ(29, 39, 0)
  self.powerNumberTextPos = self.powerNumber_text:GetPosition()
  self.hitItem = self:AddComponent(UIBaseContainer, hitItem_path)
  self.hitItem:SetActive(false)
  self.hitItemObj = self.hitItem.gameObject
  self.hitItemObj.gameObject:GameObjectCreatePool()
  self.hitItemContainer = self:AddComponent(UIBaseContainer, hitItemContainer_path)
  self.heroAdd_btn = self:AddComponent(UIButton, heroAdd_btn_path)
  self.heroAdd_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalAttributeInfo)
  end)
  self.skill_chip_function_unlock_btn = self:AddComponent(UIButton, skill_chip_function_unlock_btn_path)
  self.skill_chip_function_unlock_btn:SetActive(false)
  self.count_down_time_text = self:AddComponent(UIText, count_down_time_text_path)
  self.upgrade_btn_text = self:AddComponent(UIText, upgrade_btn_text_path)
  self.normal_level_progress_root = self:AddComponent(UIBaseContainer, normal_level_progress_root_path)
  self.sub_level_progress_root = self:AddComponent(UIBaseContainer, sub_level_progress_root_path)
  self.level_progress_fill = self:AddComponent(UIBaseContainer, level_progress_fill_path)
  self.level_sub_fill_root = self:AddComponent(UIBaseContainer, level_sub_fill_root_path)
  self.maxLevelProgressWidth = 736
  self.subLevelFillTransList = {}
  local childCount = self.level_sub_fill_root.transform.childCount
  for i = 0, childCount - 1 do
    local child = self.level_sub_fill_root.transform:GetChild(i).gameObject
    local rectTransformCpt = child:GetComponent(typeof(CS.UnityEngine.RectTransform))
    table.insert(self.subLevelFillTransList, rectTransformCpt)
  end
  self.maxSubLevelProgressWidth = 140.5
  self.level_display_btn = self:AddComponent(UIButton, level_display_btn_path)
  self.level_display_btn:SetOnClick(function()
    DataCenter.TacticalWeaponManager:SetPreviewPageRedPoint()
    self.compLevelDisplayBtnRedPoint:SetActive(false)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalWeaponLevelDisplay)
  end)
  self.level_display_btn_name = self:AddComponent(UITextMeshProUGUIEx, level_display_btn_name_path)
  self.level_display_btn_name:SetLocalText("new_uav_level_button1")
  self.title_skill = self:AddComponent(UITextMeshProUGUIEx, title_skill_path)
  self.title_skill:SetLocalText("new_uav_level_desc1")
  self.title_attribute = self:AddComponent(UITextMeshProUGUIEx, title_attribute_path)
  self.title_attribute:SetLocalText("new_uav_level_desc2")
  self.air_point = self:AddComponent(UIBaseContainer, air_point_path)
  self.effect_fly_born_node = self:AddComponent(UIBaseContainer, effect_fly_born_node_path)
  self.level_display_btn_root = self:AddComponent(UIBaseContainer, level_display_btn_root_path)
  self.level_display_btn_root:SetActive(LuaEntry.DataConfig:TryGetNum("uav_level_preview_config", "k2") == 1)
  self.compSkinPageBtnRoot = self:AddComponent(UIBaseContainer, "skinPageBtnRoot")
  self.btnSkinPage = self:AddComponent(UIButton, "skinPageBtnRoot/skinPageBtn")
  self.btnSkinPage:SetOnClick(function()
    DataCenter.TacticalWeaponManager:SetSkinPageRedPoint()
    self.compSkinPageBtnRedPoint:SetActive(false)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalWeaponSkinPage, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllHide
    })
  end)
  self.textSkinPageBtnName = self:AddComponent(UIText, "skinPageBtnRoot/skinPageBtnName")
  self.textSkinPageBtnName:SetLocalText(141146)
  self.compLevelDisplayBtnRedPoint = self:AddComponent(UIBaseContainer, "levelDisplayBtnRoot/levelDisplayBtnRedPoint")
  self.compSkinPageBtnRedPoint = self:AddComponent(UIBaseContainer, "skinPageBtnRoot/skinPageBtnRedPoint")
  self:InitRedPoint()
end

function TacticalWeaponBasicPage:SetUpgradeBtnEnable(enable)
  self.canUpgradeClick = enable
end

local function DataDefine(self)
  self.attrLines = {}
  self.autoUpgradeSpeed = 1
  self.critItemFinshCallback = BindCallback(self, self.OnCriticalItemFinish)
  self.costItems = {}
  self.uiScale = UIManager:GetInstance():GetScaleFactor()
  self.effectIndex = 0
  self.effectMap = {}
  if self.delayPlaySubLvUpEffect then
    self.delayPlaySubLvUpEffect:Stop()
    self.delayPlaySubLvUpEffect = nil
  end
  self.combatEffectCpts = self.combat_effect.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
end

local function ComponentDestroy(self)
  if self.director then
    self.director:stopped("-", self.timelinePlayEndHandler)
    self.director = nil
    self.timelinePlayEndHandler = nil
  end
  self:ClearMPB()
  self.compLevelDisplayBtnRedPoint = nil
  self.compSkinPageBtnRedPoint = nil
  self.upgradeBtn = nil
  self.upgradeBtnRedPoint = nil
  self.attrs = nil
  self.attrLineTemplate = nil
  self.upgradeContainer = nil
  self.levelText = nil
  self.levelProgress_slider = nil
  self.levelProgress_text = nil
  self.btns = nil
  self.costGroup = nil
  self.costResourceTemplate = nil
  self.promoteTips_text = nil
  self.goBtn = nil
  self.goBtn_text = nil
  self.upgradeCondition = nil
  self.upgradeCondition_icon = nil
  self.upgradeCondition_text = nil
  self.skillItem = nil
  self.powerInfo = nil
  self.powerInfo_icon = nil
  self.powerNumber_text = nil
  self.powerNumber_text_transform = nil
  self.hitItem = nil
  self.hitItemObj = nil
  self.hitItemContainer = nil
  self.normal_level_progress_root = nil
  self.sub_level_progress_root = nil
  self.level_progress_fill = nil
  self.level_sub_fill_root = nil
  self.air_point = nil
  self.level_display_btn_root = nil
  self.effect_fly_born_node = nil
end

local function DataDestroy(self)
  if self.normalStageUpgradeTimer then
    self.normalStageUpgradeTimer:Stop()
    self.normalStageUpgradeTimer = nil
  end
  self:DestroySuperUpgradeTemporaryObj()
  self:DestroyNormalUpgradeTemporaryObj()
  self.oldModelObj = nil
  self.upgradeReqCount = nil
  self.upgradeReqTargetCount = nil
  self.bulletLoadNum = nil
  self.UpgradeLightEnd = nil
  self.weaponInfo = nil
  self.progress = nil
  self.critItemFinshCallback = nil
  self.replaceModelGuideId = nil
  self.subLevelFillTransList = nil
  self.maxLevelProgressWidth = nil
  self.maxSubLevelProgressWidth = nil
  self.effectIndex = nil
  self.effectMap = nil
  self.combatEffectCpts = nil
  self:TryStopProgressSound()
end

local function ClearAttrs(self)
  if self.attrs then
    self.attrs:RemoveComponents(TacticalWeaponAttrLineItem)
  end
  if self.attrLineTemplate and not IsNull(self.attrLineTemplate.gameObject) then
    self.attrLineTemplate.gameObject:GameObjectRecycleAll()
  end
  self.attrLines = {}
end

local function ClearCostItems(self)
  if self.costGroup then
    self.costGroup:RemoveComponents(TacticalWeaponCostItem)
  end
  if self.costResourceTemplate and not IsNull(self.costResourceTemplate.gameObject) then
    self.costResourceTemplate.gameObject:GameObjectRecycleAll()
  end
  self.costItems = {}
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
  self.isAutoUpgrading = false
  self:SetUpgradeBtnEnable(true)
end

function TacticalWeaponBasicPage:InitRedPoint()
  local showSkinRed = DataCenter.TacticalWeaponManager:GetSkinPageRedPoint()
  self.compSkinPageBtnRedPoint:SetActive(showSkinRed)
  local showPreviewRed = DataCenter.TacticalWeaponManager:GetPreviewPageRedPoint()
  self.compLevelDisplayBtnRedPoint:SetActive(showPreviewRed)
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
  if self.levelUpEffectReq then
    self.levelUpEffectReq:Destroy()
    self.levelUpEffectReq = nil
    self.levelUpEffectCpts = nil
  end
  self:StopPowerAnim()
  self:StopUpgradeAnim()
  self:RemoveChipFuncUnlockTimer()
  self.isAutoUpgrading = false
end

local function OnResOrItemUpdate(self)
  self:RefreshUpgradeBtnRedPoint()
  self:RefreshCosts()
end

local function OnChipFunctionUnlock(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTWSkillChipUnlockSuccess, {anim = true})
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshResourceItem, OnResOrItemUpdate)
  self:AddUIListener(EventId.ResourceUpdated, OnResOrItemUpdate)
  self:AddUIListener(EventId.RefreshItems, OnResOrItemUpdate)
  self:AddUIListener(EventId.TacticalWeaponLevelUp, self.OnWeaponUpgrade)
  self:AddUIListener(EventId.TacticalWeaponNormalUpgradeViewClose, self.OnTacticalWeaponNormalUpgradeViewClose)
  self:AddUIListener(EventId.TacticalWeaponSuperUpgradeViewClose, self.OnTacticalWeaponSuperUpgradeViewClose)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshResourceItem, OnResOrItemUpdate)
  self:RemoveUIListener(EventId.ResourceUpdated, OnResOrItemUpdate)
  self:RemoveUIListener(EventId.RefreshItems, OnResOrItemUpdate)
  self:RemoveUIListener(EventId.TacticalWeaponLevelUp, self.OnWeaponUpgrade)
  self:RemoveUIListener(EventId.TacticalWeaponNormalUpgradeViewClose, self.OnTacticalWeaponNormalUpgradeViewClose)
  self:RemoveUIListener(EventId.TacticalWeaponSuperUpgradeViewClose, self.OnTacticalWeaponSuperUpgradeViewClose)
end

function TacticalWeaponBasicPage:OnTacticalWeaponNormalUpgradeViewClose()
  self.holder:SetRootVisible(true)
  if self.cacheSkillInfo then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalWeaponSkillLevelUp, {anim = true}, self.cacheSkillInfo)
    self.cacheSkillInfo = nil
  end
end

function TacticalWeaponBasicPage:OnTacticalWeaponSuperUpgradeViewClose()
  self.holder:SetRootVisible(true)
  if self.cacheSkillInfo then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalWeaponSkillLevelUp, {anim = true}, self.cacheSkillInfo)
    self.cacheSkillInfo = nil
  end
end

local function RefreshUpgradeBtn(self)
  if not self.weaponInfo then
    self.btns:SetActive(false)
    self.upgradeContainer:SetActive(false)
    return
  end
  self.btns:SetActive(true)
  self.upgradeBtn:SetActive(true)
  local isReachMax = self.weaponInfo:IsReachMaxLevel()
  if isReachMax then
    self.upgradeBtn:SetActive(false)
    self.goBtn:SetActive(true)
    if self.weaponInfo:GetRealTemplate() and self.weaponInfo:GetRealTemplate().upgradeType == 2 then
      self.goBtn_text:SetLocalText(151038)
    else
      self.goBtn_text:SetLocalText(141147)
    end
    self.upgradeCondition:SetActive(true)
    self.upgradeCondition_icon:SetActive(false)
    self.upgradeCondition_text:SetLocalText(150027)
    UIGray.SetGray(self.goBtn.transform, true, false)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.upgradeCondition.transform)
    return
  end
  local reachLevelLimit, needBuildingType, needBuildingLevel = self.weaponInfo:IsReachLevelLimit()
  if reachLevelLimit then
    self.upgradeBtn:SetActive(false)
    self.goBtn:SetActive(true)
    self.goBtn_text:SetLocalText(110003)
    self.upgradeCondition:SetActive(true)
    self.upgradeCondition_icon:SetActive(true)
    self.upgradeCondition_text:SetLocalText(800377, needBuildingLevel)
    UIGray.SetGray(self.goBtn.transform, false, true)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.upgradeCondition.transform)
    return
  end
  self.goBtn:SetActive(false)
  self.upgradeBtn:SetActive(true)
  if self.weaponInfo:GetRealTemplate() and self.weaponInfo:GetRealTemplate().upgradeType == 2 then
    self.upgrade_btn_text:SetLocalText(151038)
  else
    self.upgrade_btn_text:SetLocalText(141147)
  end
  UIGray.SetGray(self.upgradeBtn.transform, false, true)
  self:RefreshUpgradeBtnRedPoint()
end

local function RefreshAttrs(self, anim)
  if not self.weaponInfo then
    return
  end
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
    local nextValue = nextLevelAttrs[attr.id]
    if nextValue and nextValue ~= attr.value then
      attr.nextValue = nextValue
    end
    table.insert(attrs, attr)
  end
  local toAddAttrs = {}
  local toRefreshAttrs = {}
  local toRemoveAttrs = {}
  for i = 1, #attrs do
    local attr = attrs[i]
    local attrtLine = self.attrLines[attr.id]
    if attrtLine then
      table.insert(toRefreshAttrs, attr)
    else
      table.insert(toAddAttrs, attr)
    end
  end
  for id, attrLine in pairs(self.attrLines) do
    local isExist = false
    for i = 1, #attrs do
      local attr = attrs[i]
      if attr.id == id then
        isExist = true
        break
      end
    end
    if not isExist then
      table.insert(toRemoveAttrs, attrLine)
    end
  end
  for i = 1, #toRemoveAttrs do
    local attrLine = toRemoveAttrs[i]
    if attrLine then
      local go = attrLine.gameObject
      self.attrs:RemoveComponent(attrLine:GetName(), TacticalWeaponAttrLineItem)
      if not IsNull(go) then
        go:GameObjectRecycle()
      end
    end
    self.attrLines[attrLine.id] = nil
  end
  for i = 1, #toAddAttrs do
    local attr = toAddAttrs[i]
    local rewardName = "attr_" .. attr.id
    local goItem = self.attrLineTemplate.gameObject:GameObjectSpawn(self.attrs.transform)
    goItem.name = rewardName
    goItem:SetActive(true)
    local theItem = self.attrs:AddComponent(TacticalWeaponAttrLineItem, rewardName)
    theItem:SetMaster(self.weaponInfo)
    if anim then
      theItem:AnimValue(attr.id, attr.value, attr.nextValue)
    else
      theItem:SetValue(attr.id, attr.value, attr.nextValue)
    end
    self.attrLines[attr.id] = theItem
  end
  for i = 1, #toRefreshAttrs do
    local attr = toRefreshAttrs[i]
    local attrLine = self.attrLines[attr.id]
    if attrLine then
      if anim then
        attrLine:AnimValue(attr.id, attr.value, attr.nextValue)
      else
        attrLine:SetValue(attr.id, attr.value, attr.nextValue)
      end
    end
  end
  for id, attrLine in pairs(self.attrLines) do
    local index = 1
    for i = 1, #attrs do
      local attr = attrs[i]
      if attr.id == id then
        index = i
        break
      end
    end
    attrLine:SetSiblingIndex(index - 1)
  end
end

local function RefreshCosts(self)
  if not self.weaponInfo then
    return
  end
  local costRes = {}
  if self.weaponInfo:GetRealTemplate() then
    costRes = self.weaponInfo:GetRealTemplate().cost_resItem
  end
  for __, v in pairs(costRes) do
    if self.costItems[v.id] then
      self.costItems[v.id]:SetValue(v.id, v.value)
    else
      local rewardName = "cost_" .. v.id
      local goItem = self.costResourceTemplate.gameObject:GameObjectSpawn(self.costGroup.transform)
      goItem.name = rewardName
      goItem:SetActive(true)
      local theItem = self.costGroup:AddComponent(TacticalWeaponCostItem, rewardName)
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
      self.costGroup:RemoveComponent(costItem:GetName(), TacticalWeaponCostItem)
      if not IsNull(go) then
        go:GameObjectRecycle()
      end
      self.costItems[itemId] = nil
    end
  end
end

local function StopPowerAnim(self)
  if self.powerSeq then
    self.powerSeq:Kill()
    self.powerSeq = nil
  end
  if self.powerNumber_text then
    self.powerNumber_text:SetLocalPositionXYZ(29, 39, 0)
  end
end

local function RefreshBaseInfo(self, anim)
  if not self.weaponInfo then
    return
  end
  local level = self.weaponInfo.level
  self.levelText:SetText(string.format("Lv.%s", level))
  local progress = self.weaponInfo.progress
  local maxProgress = 0
  if self.weaponInfo:GetRealTemplate() then
    maxProgress = self.weaponInfo:GetRealTemplate().progress_total
  end
  local percent = 0
  self:ResetSubLevelRectTransList()
  local isSubLevel, curLevelSubLevelDic = DataCenter.TacticalWeaponLevelTemplateManager:TryGetSubLevelDic(level)
  if isSubLevel then
    local curProgressIndex = 0
    for i, v in pairs(curLevelSubLevelDic) do
      local index = v.sub_level + 1
      local sizeDelta = self.subLevelFillTransList[index].sizeDelta
      if progress >= v.progress_total then
        sizeDelta.x = self.maxSubLevelProgressWidth
        self.subLevelFillTransList[index].sizeDelta = sizeDelta
        if v.progress_total == progress then
          curProgressIndex = index
        end
      else
        sizeDelta.x = 0
        self.subLevelFillTransList[index].sizeDelta = sizeDelta
      end
    end
    self.levelProgress_text:SetLocalText("new_uav_level_desc9", curProgressIndex, 5)
    self.levelProgress_text:SetLocalScaleXYZ(1, 1, 1)
  else
    if 0 < maxProgress and 0 < progress then
      percent = progress / maxProgress
    end
    local levelProgressSizeDelta = self.level_progress_fill.rectTransform.sizeDelta
    levelProgressSizeDelta.x = self.maxLevelProgressWidth * percent
    self.level_progress_fill.rectTransform.sizeDelta = levelProgressSizeDelta
    self.levelProgress_text:SetLocalText("new_uav_level_desc8", progress, maxProgress)
    self.levelProgress_text:SetLocalScaleXYZ(1, 1, 1)
  end
  self.normal_level_progress_root:SetActive(not isSubLevel)
  self.sub_level_progress_root:SetActive(isSubLevel)
  self.progress = progress
  self.promoteTips_text:SetLocalText(self.weaponInfo:GetRealTemplate().promote_tips)
  StopPowerAnim(self)
  local power = DataCenter.TacticalWeaponManager:GetWeaponTotalPower()
  if anim and power ~= self.weaponPower then
    self.powerSeq = CS.DG.Tweening.DOTween.Sequence()
    self.powerSeq:Append(DOTween.To(function(x)
      self.powerNumber_text:SetText(math.floor(x))
    end, self.weaponPower, power, anim1Time):SetEase(CS.DG.Tweening.Ease.InCirc))
    local time = 0
    local round = 4
    local part1Time = anim1Time / 3 / round
    local part2Time = anim1Time / 3 * 2 / round
    local halfRoundTime = anim1Time / round
    for i = 1, round do
      self.powerSeq:Insert(time, self.powerNumber_text_transform:DOLocalMoveY(80, part1Time):SetEase(CS.DG.Tweening.Ease.OutCubic))
      time = time + part1Time
      self.powerSeq:InsertCallback(time, function()
        self.powerNumber_text:SetLocalPositionXYZ(29, 0, 0)
        local easeType = CS.DG.Tweening.Ease.OutCubic
        if i == round then
          easeType = CS.DG.Tweening.Ease.InOutBack
        end
        self.powerNumber_text_transform:DOLocalMoveY(39, part2Time):SetEase(easeType)
      end)
      self.powerSeq:AppendInterval(part2Time)
      time = time + part2Time
    end
    self.powerSeq:InsertCallback(time * 0.5, function()
      local srcPos = Vector3.New(self.powerNumberTextPos.x, self.powerNumberTextPos.y, self.powerNumberTextPos.z)
      local endPos = Vector3.New(self.powerNumberTextPos.x, self.powerNumberTextPos.y + 100 * self.uiScale, self.powerNumberTextPos.z)
      local context = FlyTextContext.New()
      local scale = 1.3
      context:SetIcon("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_shengji_jiantou_1.png")
      context:SetText(string.format("<color=#5fef87>+%s</color>", power - self.weaponPower))
      context:SetSrcPos(srcPos)
      context:SetDstPos(endPos)
      context:SetSrcScale(scale)
      context:SetDstScale(scale + 0.1)
      context:SetFontSize(42)
      context:SetMoveTime(4)
      context:SetStartDelayTime(0)
      context:SetIconIsLeft(false)
      UIUtil.DoFlyText(context, UILayer.Normal.Name)
    end)
    self.powerSeq:AppendCallback(function()
      self.weaponPower = power
    end)
  else
    if self.weaponPower ~= nil and self.weaponPower ~= 0 and self.weaponPower ~= power and not IsNull(self.combatEffectCpts) then
      for i = 0, self.combatEffectCpts.Length - 1 do
        self.combatEffectCpts[i]:Play()
      end
    end
    self.powerNumber_text:SetText(power)
    self.weaponPower = power
  end
end

local function RefreshSkillInfo(self, isInit)
  if not self.weaponInfo then
    return
  end
  self.weaponInfo:UpdateSkillInfoExtra()
  local skillInfos = self.weaponInfo:GetSkillInfos()
  local skillInfo
  if not table.IsNullOrEmpty(skillInfos) then
    skillInfo = skillInfos[1]
  end
  if skillInfo then
    local curStar = 0
    if self.skillItem.skillData ~= nil then
      curStar = self.skillItem.skillData:GetStar()
    end
    local nextStar = skillInfo:GetStar()
    if curStar ~= nextStar and not isInit then
      local isSpecialLv = self.weaponInfo.level % 10 == 0
      if not isSpecialLv then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalWeaponSkillLevelUp, {anim = true}, skillInfo)
      else
        self.cacheSkillInfo = skillInfo
      end
    end
    self.skillItem:SetActive(true)
    self.skillItem:SetData(skillInfo, {
      showSkillName = false,
      showSkillLevel = false,
      showStar = true
    }, function(skillData, skillItem)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeaponSkillDetail, {anim = true}, skillData, skillItem)
    end)
  else
    self.skillItem:SetActive(false)
  end
end

local function RemoveChipFuncUnlockTimer(self)
  if self.chipFuncUnlockTimer then
    self.chipFuncUnlockTimer:Stop()
    self.chipFuncUnlockTimer = nil
  end
end

local function RefreshChipFuncUnlockTime(self)
  local remainTime = DataCenter.TWSkillChipManager:GetSkillChipUnlockRemainTime()
  if 0 < remainTime then
    self.count_down_time_text:SetText(UITimeManager:GetInstance():SecondToFmtString(remainTime))
  else
    self:RefreshChipFuncUnlock()
  end
end

local function AddChipFuncUnlockTimer(self)
  if self.chipFuncUnlockTimer then
    return
  end
  self.chipFuncUnlockTimer = TimerManager:GetInstance():GetTimer(1, RefreshChipFuncUnlockTime, self, false, false, false)
  self.chipFuncUnlockTimer:Start()
end

local function RefreshChipFuncUnlock(self)
  local functionUnlock = DataCenter.TWSkillChipManager:IsFunctionUnlock()
  RemoveChipFuncUnlockTimer(self)
  if functionUnlock then
    self.skill_chip_function_unlock_btn:SetActive(false)
  else
    self.skill_chip_function_unlock_btn:SetActive(true)
    local previewTime = DataCenter.TWSkillChipManager:GetChipPreviewTime()
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    if previewTime < curTime then
      self.skill_chip_function_unlock_btn:SetActive(true)
      local remainTime = DataCenter.TWSkillChipManager:GetSkillChipUnlockRemainTime()
      if 0 < remainTime then
        self.count_down_time_text:SetText(UITimeManager:GetInstance():SecondToFmtString(remainTime))
        AddChipFuncUnlockTimer(self)
      else
        self.count_down_time_text:SetLocalText("drone_skillChip_Btn_6")
      end
    else
      self.skill_chip_function_unlock_btn:SetActive(false)
    end
  end
end

local function RefreshAll(self, anim, isInit)
  self:RefreshUpgradeBtn()
  self:RefreshAttrs(anim)
  self:RefreshCosts()
  self:RefreshBaseInfo(anim)
  self:RefreshSkillInfo(isInit)
end

local function SetData(self, weaponInfo, param1)
  self.lastUpgradeLv = nil
  self.lastUpgradeProgress = nil
  self.weaponInfo = weaponInfo
  self.initWeaponLevel = weaponInfo.level
  if not self.weaponInfo then
    return
  end
  self.holder:SetRootVisible(true)
  self:CheckFirstEnterTimeline()
  self:RefreshAll(false, true)
  if param1 then
  else
  end
end

local function UpgradeWeapon(self, isAuto)
  if not self.weaponInfo then
    return
  end
  if self.weaponInfo:IsReachMaxLevel() then
    return
  end
  if self.weaponInfo:IsReachLevelLimit() then
    return
  end
  if self.weaponInfo:GetRealTemplate().upgradeType == 1 then
    return
  end
  self:StopUpgradeAnim()
  self:RefreshBaseInfo()
  local canUpgrade, lackResItems = self.weaponInfo:HasResItemToUpgrade()
  if not canUpgrade then
    if not isAuto then
      for id, v in pairs(lackResItems) do
        LWResourceLackUtil:GotoResourceItemLack(v.id, v.count)
        break
      end
    end
    return
  end
  if self.lastUpgradeLv == self.weaponInfo.level and self.lastUpgradeProgress == self.weaponInfo.progress then
    return
  end
  self.lastUpgradeLv = self.weaponInfo.level
  self.lastUpgradeProgress = self.weaponInfo.progress
  SFSNetwork.SendMessage(MsgDefines.TacticalWeaponLevelUpMessage, self.weaponInfo.id, isAuto and 1 or 0, self.weaponInfo:GetRealTemplate().upgradeType)
end

local function StopUpgradeAnim(self)
  if self.upgradeSeq then
    self.upgradeSeq:Kill()
    self.upgradeSeq = nil
  end
  if self.levelProgress_text then
    self.levelProgress_text:SetLocalScaleXYZ(1, 1, 1)
  end
end

local function TryShowSubLevelProgressAnim(self, lvUpMsg)
  local curLevel = self.weaponInfo.level
  local hasCurLvDic, curLvDic = DataCenter.TacticalWeaponLevelTemplateManager:TryGetSubLevelDic(curLevel)
  if hasCurLvDic and lvUpMsg.weapon.exp > 0 then
    for i, v in pairs(curLvDic) do
      if v.progress_total == lvUpMsg.weapon.exp then
        self:PlaySubLevelAnim(lvUpMsg, v.sub_level + 1)
      end
    end
    return true
  end
  local hasLastLvDic, lastLvDic = DataCenter.TacticalWeaponLevelTemplateManager:TryGetSubLevelDic(curLevel - 1)
  if hasLastLvDic and lvUpMsg.weapon.exp == 0 then
    self:PlaySubLevelAnim(lvUpMsg, #self.subLevelFillTransList, true)
    return true
  end
  return false
end

local function PlaySubLevelAnim(self, lvUpMsg, index, playFullFillEffect)
  local time = 0
  local targetTrans = self.subLevelFillTransList[index]
  self.upgradeSeq = CS.DG.Tweening.DOTween.Sequence()
  self.upgradeSeq:Insert(time, self.levelProgress_text.transform:DOScale(Vector3.New(progressAnimScale, progressAnimScale, progressAnimScale), SubLevel_AniTime / 2))
  time = time + SubLevel_AniTime / 2
  self.upgradeSeq:Insert(time, self.levelProgress_text.transform:DOScale(Vector3.one, SubLevel_AniTime / 2))
  self.upgradeSeq:Append(DOTween.To(function(x)
    local showProgress = x / self.maxSubLevelProgressWidth
    local sizeDelta = targetTrans.sizeDelta
    sizeDelta.x = self.maxSubLevelProgressWidth * showProgress
    targetTrans.sizeDelta = sizeDelta
  end, 0, self.maxSubLevelProgressWidth, SubLevel_AniTime):SetEase(CS.DG.Tweening.Ease.OutCubic):OnComplete(function()
    local effectParam = {}
    effectParam.path = EffectAssets.TacticalSubLevelUpOneFillEffect
    effectParam.parent = targetTrans.transform.parent
    effectParam.pos = Vector3.New(targetTrans.sizeDelta.x * 0.5 * CommonUtil.ArabicAutoMirrorFactor() + targetTrans.anchoredPosition.x, 0, 0)
    self:PlayEffect(effectParam)
    DataCenter.LWSoundManager:PlaySound(62275, false)
    if playFullFillEffect == true then
      local param = {}
      param.path = EffectAssets.TacticalSubLevelUpAllFillEffect
      param.parent = self.upgradeContainer.transform
      param.pos = Vector3.New(0, -23, 0)
      param.scale = ResetScale
      self:PlayEffect(param)
    end
  end))
  local path = EffectAssets.TacticalLevelUpFlyEffect
  local src = targetTrans.transform:GetChild(0).position
  local dest = self.air_point.transform.position
  local parent = UIManager:GetInstance():GetLayer(UILayer.TopMost.Name).transform
  local isLvUp = lvUpMsg.upLv == 1
  
  local function func()
    self:OnFlyBezierCallback()
  end
  
  DataCenter.FlyController.DoFlyWithBezierFunc(path, src, dest, 0.6, parent, func)
  self.upgradeSeq:AppendInterval(0.2)
  self.upgradeSeq:AppendCallback(function()
    self:RefreshAll(true)
    local srcPos = Vector3.New(self.upgradeContainerPos.x, self.upgradeContainerPos.y, self.upgradeContainerPos.z)
    local endPos = Vector3.New(self.upgradeContainerPos.x, self.upgradeContainerPos.y + 40 * self.uiScale, self.upgradeContainerPos.z)
    local context = FlyTextContext.New()
    context:SetText(string.format("<color=#5fef87>+%s</color>", lvUpMsg.addExp))
    context:SetSrcPos(srcPos)
    context:SetDstPos(endPos)
    context:SetSrcScale(1.2)
    context:SetDstScale(1.2)
    context:SetFontSize(32)
    context:SetMoveTime(1.6)
    context:SetStartDelayTime(0.1)
    context:SetIconIsLeft(true)
    UIUtil.DoFlyText(context)
  end)
  self.upgradeSeq:OnKill(function()
    self.upgradeSeq = nil
    if self and self:GetActiveInHierarchy() then
      self:RefreshAll(false)
      self:PlayStageUpgradeEffect()
    end
  end)
end

function TacticalWeaponBasicPage:OnFlyBezierCallback(isLvUp)
  if not self.weaponInfo or not self.holder then
    return
  end
  if self.weaponInfo.level % 10 == 0 and self.weaponInfo.progress == 0 then
    self.holder:SetRootVisible(false)
  else
    self:PlayLevelUpEffect()
  end
end

local function ShowProgressAnim(self, lvUpMsg)
  if not self.weaponInfo or not lvUpMsg then
    return
  end
  self:StopUpgradeAnim()
  if lvUpMsg.upLv == 1 and self.weaponInfo.level % 10 == 0 then
    self:SetUpgradeBtnEnable(false)
  end
  if self:TryShowSubLevelProgressAnim(lvUpMsg) then
    return
  end
  self.upgradeSeq = CS.DG.Tweening.DOTween.Sequence()
  local time = 0
  local hasLevelUp = lvUpMsg.upLv == 1
  if hasLevelUp then
    local lastLevelTemplate = self.weaponInfo:GetRealTemplateStatic(self.weaponInfo.level - 1, 4)
    if not lastLevelTemplate then
      return
    end
    local lastLevelTotalProgress = lastLevelTemplate.progress_total
    if lastLevelTotalProgress <= self.progress then
      self:RefreshBaseInfo()
      return
    end
    self:PlayProgressSound()
    local curProgress = self.progress
    self.upgradeSeq:Append(DOTween.To(function(x)
      local showProgress = x / lastLevelTotalProgress
      local levelProgressSizeDelta = self.level_progress_fill.rectTransform.sizeDelta
      levelProgressSizeDelta.x = self.maxLevelProgressWidth * showProgress
      self.level_progress_fill.rectTransform.sizeDelta = levelProgressSizeDelta
      self.levelProgress_text:SetLocalText("new_uav_level_desc8", math.floor(x), lastLevelTotalProgress)
      self.progress = math.floor(x)
    end, curProgress, lastLevelTotalProgress, anim1Time):SetEase(CS.DG.Tweening.Ease.OutCubic):OnComplete(function()
      if hasLevelUp then
        local param = {}
        param.path = EffectAssets.TacticalLevelUpExpFullEffect
        param.parent = self.upgradeContainer.transform
        param.pos = Vector3.New(0, -23, 0)
        self:PlayEffect(param)
        local path = EffectAssets.TacticalLevelUpFlyEffect
        local src = self.effect_fly_born_node.transform.position
        local dest = self.air_point.transform.position
        local parent = UIManager:GetInstance():GetLayer(UILayer.TopMost.Name).transform
        
        local function func()
          if self.weaponInfo == nil then
            return
          end
          self:OnFlyBezierCallback()
        end
        
        DataCenter.FlyController.DoFlyWithBezierFunc(path, src, dest, 0.6, parent, func)
      end
    end))
    self.upgradeSeq:Insert(time, self.levelProgress_text.transform:DOScale(Vector3.New(progressAnimScale, progressAnimScale, progressAnimScale), anim1Time / 2))
    time = time + anim1Time / 2
    self.upgradeSeq:Insert(time, self.levelProgress_text.transform:DOScale(Vector3.one, anim1Time / 2))
    time = time + anim1Time / 2
    self.upgradeSeq:AppendInterval(0.2)
  else
    local curProgress = self.progress
    local levelTotalProgress = 1
    if self.weaponInfo:GetRealTemplate() then
      levelTotalProgress = self.weaponInfo:GetRealTemplate().progress_total
    end
    self:PlayProgressSound()
    self.upgradeSeq:Append(DOTween.To(function(x)
      local showProgress = x / levelTotalProgress
      local levelProgressSizeDelta = self.level_progress_fill.rectTransform.sizeDelta
      levelProgressSizeDelta.x = self.maxLevelProgressWidth * showProgress
      self.level_progress_fill.rectTransform.sizeDelta = levelProgressSizeDelta
      self.levelProgress_text:SetLocalText("new_uav_level_desc8", math.floor(x), levelTotalProgress)
    end, curProgress, self.weaponInfo.progress, anim1Time))
    self.upgradeSeq:Insert(time, self.levelProgress_text.transform:DOScale(Vector3.New(progressAnimScale, progressAnimScale, progressAnimScale), anim1Time / 2))
    time = time + anim1Time / 2
    self.upgradeSeq:Insert(time, self.levelProgress_text.transform:DOScale(Vector3.one, anim1Time / 2))
    time = time + anim1Time / 2
  end
  self.upgradeSeq:AppendCallback(function()
    self:RefreshAll(true)
    local srcPos = Vector3.New(self.upgradeContainerPos.x, self.upgradeContainerPos.y, self.upgradeContainerPos.z)
    local endPos = Vector3.New(self.upgradeContainerPos.x, self.upgradeContainerPos.y + 40 * self.uiScale, self.upgradeContainerPos.z)
    local context = FlyTextContext.New()
    context:SetText(string.format("<color=#5fef87>+%s</color>", lvUpMsg.addExp))
    context:SetSrcPos(srcPos)
    context:SetDstPos(endPos)
    context:SetSrcScale(1.2)
    context:SetDstScale(1.2)
    context:SetFontSize(32)
    context:SetMoveTime(1.6)
    context:SetStartDelayTime(0.1)
    context:SetIconIsLeft(true)
    UIUtil.DoFlyText(context)
  end)
  self.upgradeSeq:OnKill(function()
    self.upgradeSeq = nil
    if self and self:GetActiveInHierarchy() then
      self:RefreshAll(false)
      self:PlayStageUpgradeEffect()
    end
  end)
end

local function OnWeaponUpgrade(self, message)
  if not message or not self.weaponInfo then
    return
  end
  if message.weapon == nil or message.weapon.id ~= self.weaponInfo.id then
    return
  end
  if message.upLv == 1 then
    local showPreviewRed = DataCenter.TacticalWeaponManager:RefreshPreviewPageRedPoint()
    if showPreviewRed then
      self.compLevelDisplayBtnRedPoint:SetActive(true)
    end
  end
  self:ShowProgressAnim(message)
  self:ShowHitItem(message.rateType)
end

function TacticalWeaponBasicPage:SetUpgradeAniFlag(status)
  if self.holder and self.holder.ctrl then
    self.holder.ctrl:SetAnimationFlag(status)
  end
end

function TacticalWeaponBasicPage:PlayStageUpgradeEffect()
  if self.weaponInfo.progress == 0 then
    if self.weaponInfo.level % 50 == 0 and self.weaponInfo.level ~= 300 then
      self:SetUpgradeAniFlag(true)
      self:PlaySuperStageUpgradeAni(self.weaponInfo.level)
    elseif self.weaponInfo.level % 10 == 0 then
      self:SetUpgradeAniFlag(true)
      self:PlayNormalStageUpgradeAni()
    end
  end
end

function TacticalWeaponBasicPage:PlayNormalStageUpgradeAni()
  local MPB = CS.UnityEngine.MaterialPropertyBlock()
  MPB:SetFloat("_USERIM", 1)
  self.Upgrade_MPB = MPB
  self.Upgrade_MPB_Value = 0
  local modelRoot = self.holder:GetModelViewSceneNode("Model")
  self.oldModelObj = modelRoot.transform:GetChild(0).gameObject
  self.oldModelRender = self:GetModelRender(self.oldModelObj.transform)
  self.upgradeReqCount = 0
  self.upgradeReqTargetCount = 0
  self:LoadNextStageWeapon(modelRoot.transform)
  self:LoadNextStageWeaponBulletHolder(modelRoot.transform)
end

function TacticalWeaponBasicPage:LoadNextStageWeapon(parent)
  self.isLoadNextStageWeapon = false
  local weaponInfo = DataCenter.TacticalWeaponManager:GetFirstWeaponInfo()
  if weaponInfo and weaponInfo.level > 250 then
    self.newModelRender = self.oldModelRender
    return
  end
  self.upgradeReqTargetCount = self.upgradeReqTargetCount + 1
  self.isLoadNextStageWeapon = true
  local modelPath = DataCenter.TacticalWeaponManager:GetCurDefaultSkinPath()
  self.newModelShowReq = self:GameObjectInstantiateAsync(modelPath, function(request)
    if IsNull(request.gameObject) then
      return
    end
    local go = request.gameObject
    go:SetActive(false)
    go.transform:SetParent(parent)
    go.transform:Set_localPosition(0, 0, 0)
    go.transform:Set_localScale(1, 1, 1)
    go.transform:Set_localEulerAngles(0, 0, 0)
    self.newModelRender = self:GetModelRender(go)
    self:CheckPlayNormalStageUpgradeAniReal()
  end)
end

function TacticalWeaponBasicPage:LoadNextStageWeaponBulletHolder(parent)
  local lvTemplate = self.weaponInfo.levelTemplate
  if lvTemplate == nil then
    return
  end
  self.upgradeReqTargetCount = self.upgradeReqTargetCount + 1
  local upgradeId = lvTemplate.upgrade_id
  local upgradeTemplate = DataCenter.TacticalWeaponTemplateManager:GetNormalStageUpgradeTemplate(upgradeId)
  local bulletHolderPath = string.format("Assets/Main/Prefabs/PrefabsIncrement/Character/Vehicle/UAV/A_Hero_wurenji_shengji/prefab/prefab_zhijia/%s.prefab", upgradeTemplate.missile_rack)
  self.bulletHolderShowReq = self:GameObjectInstantiateAsync(bulletHolderPath, function(request)
    if IsNull(request.gameObject) then
      return
    end
    local go = request.gameObject
    go:SetActive(false)
    go.transform:SetParent(parent)
    go.transform:Set_localPosition(0, 0, 0)
    go.transform:Set_localScale(1, 1, 1)
    go.transform:Set_localEulerAngles(0, 0, 0)
    self.newModelBulletHolderAni = go:GetComponent(typeof(CS.UnityEngine.Animator))
    self:CheckPlayNormalStageUpgradeAniReal()
    local str = LuaEntry.DataConfig:TryGetStr("uav_level_missile_rack_anchor", upgradeTemplate.missile_anchor)
    local pointPathList = string.split(str, ";")
    local needLoadNum = 1
    if 4 <= #pointPathList then
      needLoadNum = 4
    elseif 2 <= #pointPathList then
      needLoadNum = 2
    end
    self.bulletLoadNum = 0
    for i, v in ipairs(pointPathList) do
      if not string.IsNullOrEmpty(v) then
        local bulletParent = go.transform:GetChild(0):Find(v)
        local bulletPath = string.format("Assets/Main/Prefabs/PrefabsIncrement/Character/Vehicle/UAV/A_Hero_wurenji_shengji/prefab/prefab_daodan/%s.prefab", upgradeTemplate.missile)
        self:LoadUpgradeBullet(bulletPath, bulletParent, needLoadNum)
      end
    end
  end)
end

function TacticalWeaponBasicPage:LoadUpgradeBullet(path, parent)
  self:GameObjectInstantiateAsync(path, function(request)
    if IsNull(request.gameObject) then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(parent)
    go.transform:Set_localPosition(0, 0, 0)
    go.transform:Set_localScale(1, 1, 1)
    go.transform:Set_localEulerAngles(0, 0, 0)
  end)
end

function TacticalWeaponBasicPage:LoadSceneEffect(path)
  return self:GameObjectInstantiateAsync(path, function(request)
    if IsNull(request.gameObject) then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.holder:GetModelViewSceneRoot().transform)
    go.transform:Set_localPosition(0, 0, 0)
    go.transform:Set_localScale(1, 1, 1)
    go.transform:Set_localEulerAngles(0, 0, 0)
  end)
end

function TacticalWeaponBasicPage:CheckPlayNormalStageUpgradeAniReal()
  self.upgradeReqCount = self.upgradeReqCount + 1
  if self.upgradeReqCount == self.upgradeReqTargetCount then
    self.UpgradeLightEnd = Time.time + UPGRADE_GOLD_LIGHT_DURATION
    self.normalUpgradeModelGoldLightTimer = TimerManager:GetInstance():GetTimer(0, self.UpdateUpgradeGoldLight, self, false, true, false)
    self.normalUpgradeModelGoldLightTimer:Start()
    self:PlayNormalStageSwitchSound()
    self.upgradeSceneEffectList = {
      self:LoadSceneEffect("Assets/_Art_LastWar/Effect/Prefab/build/wurenji/Eff_z_wurenji_shengji_01.prefab"),
      self:LoadSceneEffect("Assets/_Art_LastWar/Effect/Prefab/build/wurenji/Eff_z_wurenji_guangxiao_01.prefab")
    }
  end
end

function TacticalWeaponBasicPage:PlayNormalStageSwitchSound()
  DataCenter.LWSoundManager:PlaySound(62273, false)
  local appearance = DataCenter.TacticalWeaponManager:GetCurDefaultSkinAppearanceId()
  if appearance then
    local appearanceTemplate = DataCenter.AppearanceTemplateManager:GetTemplate(appearance)
    if appearanceTemplate then
      DataCenter.LWSoundManager:PlaySound(appearanceTemplate.sound_lvlup_TL, false)
    end
  end
end

function TacticalWeaponBasicPage:UpdateUpgradeGoldLight()
  if self.UpgradeLightEnd == nil then
    return
  end
  if self.UpgradeLightEnd >= Time.time then
    if self.UpgradeLightEnd - Time.time <= UPGRADE_GOLD_LIGHT_DURATION * 0.5 then
      self:OnUpgradeAniChangeModel()
      self.Upgrade_MPB_Value = self.Upgrade_MPB_Value - 5 / (UPGRADE_GOLD_LIGHT_DURATION * 0.5) * Time.deltaTime
      self.Upgrade_MPB:SetFloat("_RimPow", self.Upgrade_MPB_Value)
      for _, v in ipairs(self.newModelRender) do
        v:SetPropertyBlock(self.Upgrade_MPB)
      end
      Logger.Log("self.Upgrade_MPB_Value 2:" .. self.Upgrade_MPB_Value)
    elseif self.UpgradeLightEnd - Time.time <= UPGRADE_GOLD_LIGHT_DURATION then
      self.Upgrade_MPB_Value = self.Upgrade_MPB_Value + 5 / (UPGRADE_GOLD_LIGHT_DURATION * 0.5) * Time.deltaTime
      Logger.Log("self.Upgrade_MPB_Value 1:" .. self.Upgrade_MPB_Value)
      self.Upgrade_MPB:SetFloat("_RimPow", self.Upgrade_MPB_Value)
      for _, v in ipairs(self.oldModelRender) do
        v:SetPropertyBlock(self.Upgrade_MPB)
      end
    end
  else
    self:SetUpgradeBtnEnable(true)
    if self.normalUpgradeModelGoldLightTimer then
      self.normalUpgradeModelGoldLightTimer:Stop()
      self.normalUpgradeModelGoldLightTimer = nil
    end
    self:ClearMPB()
    self.UpgradeLightEnd = nil
  end
end

function TacticalWeaponBasicPage:ClearMPB()
  if self.Upgrade_MPB then
    self.Upgrade_MPB:SetFloat("_USERIM", 0)
    if self.oldModelRender then
      for _, v in ipairs(self.oldModelRender) do
        v:SetPropertyBlock(nil)
      end
    end
    if self.newModelRender then
      for _, v in ipairs(self.newModelRender) do
        v:SetPropertyBlock(nil)
      end
    end
  end
  self.oldModelRender = nil
  self.newModelRender = nil
  self.Upgrade_MPB = nil
end

function TacticalWeaponBasicPage:OnUpgradeAniChangeModel()
  if self.isLoadNextStageWeapon == true then
    if not self.newModelShowReq or IsNull(self.newModelShowReq.gameObject) then
      return
    end
    if self.newModelShowReq.gameObject.activeSelf == true then
      return
    end
  end
  if self.oldModelRender then
    for _, v in ipairs(self.oldModelRender) do
      v:SetPropertyBlock(nil)
    end
  end
  if self.isLoadNextStageWeapon == true then
    self.oldModelObj:SetActive(false)
    self.newModelShowReq.gameObject:SetActive(true)
    local ani = self.newModelShowReq.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation))
    if ani then
      ani:Stop()
      ani:Play("uiUpgrade")
      ani:PlayQueued("uiIdle")
    end
  else
    local ani = self.oldModelObj:GetComponentInChildren(typeof(CS.SimpleAnimation))
    if ani then
      ani:Stop()
      ani:Play("uiUpgrade")
      ani:PlayQueued("uiIdle")
    end
  end
  local building = self.holder:GetModelViewSceneNode("Building")
  if building then
    local buildingAni = building:GetComponentInChildren(typeof(CS.SimpleAnimation))
    if buildingAni then
      buildingAni:Stop()
      buildingAni:Play("upgrade")
    end
  end
  if self.bulletHolderShowReq and not IsNull(self.bulletHolderShowReq.gameObject) then
    self.bulletHolderShowReq.gameObject:SetActive(true)
  end
  local camera = self.holder:GetModelViewSceneNode("Camera")
  if camera then
    local cameraAni = camera:GetComponent(typeof(CS.UnityEngine.Animator))
    if cameraAni then
      cameraAni:Play("upgrade")
    end
  end
  if self.isLoadNextStageWeapon then
    self.normalStageUpgradeTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.holder:ResetToDefaultModel(function()
        self:DestroyNormalUpgradeTemporaryObj()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalWeaponNormalStageUp)
        self:SetUpgradeAniFlag(false)
      end)
    end, UPGRADE_CAMERA_ANI_DURATION)
  else
    self.normalStageUpgradeTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:DestroyNormalUpgradeTemporaryObj()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalWeaponNormalStageUp)
    end, UPGRADE_CAMERA_ANI_DURATION)
  end
end

function TacticalWeaponBasicPage:DestroyNormalUpgradeTemporaryObj()
  if self.normalUpgradeModelGoldLightTimer then
    self.normalUpgradeModelGoldLightTimer:Stop()
    self.normalUpgradeModelGoldLightTimer = nil
  end
  if self.newModelShowReq then
    self.newModelShowReq:Destroy()
    self.newModelShowReq = nil
  end
  if self.bulletHolderShowReq then
    self.bulletHolderShowReq:Destroy()
    self.bulletHolderShowReq = nil
  end
  if self.normalStageUpgradeTimer then
    self.normalStageUpgradeTimer:Stop()
    self.normalStageUpgradeTimer = nil
  end
  if self.upgradeSceneEffectList then
    for i, v in ipairs(self.upgradeSceneEffectList) do
      if v then
        v:Destroy()
        self.upgradeSceneEffectList[i] = nil
      end
    end
    self.upgradeSceneEffectList = nil
  end
end

function TacticalWeaponBasicPage:GetModelRender(gameObject)
  local renders = {}
  local skinnedMeshRenderer = gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.SkinnedMeshRenderer))
  local meshRenderer = gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.MeshRenderer))
  if skinnedMeshRenderer then
    local length = skinnedMeshRenderer.Length
    for i = 0, length - 1 do
      table.insert(renders, skinnedMeshRenderer[i])
    end
  end
  if meshRenderer then
    local length = meshRenderer.Length
    for i = 0, length - 1 do
      table.insert(renders, meshRenderer[i])
    end
  end
  return renders
end

function TacticalWeaponBasicPage:PlaySuperStageUpgradeAni(level)
  self:LoadTimeline(level)
end

function TacticalWeaponBasicPage:LoadTimeline(level)
  local path = "Assets/Main/Prefabs/PrefabsIncrement/Character/Vehicle/UAV/A_Hero_wurenji_shengji/prefab/animation/wurenjishengji_timeline_prefab.prefab"
  self.superStageUpTimelineReq = self:GameObjectInstantiateAsync(path, function(request)
    if IsNull(request.gameObject) then
      self:SetUpgradeBtnEnable(true)
      return
    end
    local go = request.gameObject
    local director = go:GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
    local trackMap = {}
    local arr = director.playableAsset:GetOutputTracks()
    for i = 0, arr.Length - 1 do
      local output = arr[i]
      trackMap[output.name] = output
    end
    local lastLevel = level - 1
    
    local function _getAirFunc(lv)
      local childPath = string.format("wurenji/air%s", lv)
      local trans = go.transform:Find(childPath)
      if trans ~= nil then
        return trans:GetChild(0).gameObject
      end
      Logger.LogError("path not be find in timeline prefab.   path:" .. childPath)
      return nil
    end
    
    local curAir = _getAirFunc(level)
    local lastAor = _getAirFunc(lastLevel)
    self:SetTrackDynamic("before_anim", lastAor, director, trackMap)
    self:SetTrackDynamic("after_anim", curAir, director, trackMap)
    self:SetTrackDynamic("before_feiji", lastAor, director, trackMap)
    self:SetTrackDynamic("after_feiji", curAir, director, trackMap)
    local camera = self.holder:GetModelViewSceneNode("Camera")
    if camera then
      camera:SetActive(false)
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalWeaponSuperStageUpMask, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllHide
    })
    self.director = director
    self.timelinePlayEndHandler = Bind(self, self.OnTimelinePlayEndHandler)
    self.director:stopped("+", self.timelinePlayEndHandler)
    self.director:Play()
    if self.holder then
      self.holder:ResetToDefaultModel()
    end
  end)
end

function TacticalWeaponBasicPage:OnTimelinePlayEndHandler()
  if self.director then
    self.director:stopped("-", self.timelinePlayEndHandler)
    self.director = nil
    self.timelinePlayEndHandler = nil
  end
  self:SetUpgradeBtnEnable(true)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITacticalWeaponSuperStageUpMask)
  local cameraA = self.holder:GetModelViewSceneNode("Camera")
  if cameraA then
    cameraA:SetActive(true)
  end
  self:OnSuperUpgradeTimelinePlayEnd()
end

function TacticalWeaponBasicPage:SetTrackDynamic(name, gameObject, director, trackMap)
  if trackMap[name] == nil then
    Logger.LogError("track not found,  name:" .. name)
    return
  end
  director:SetGenericBinding(trackMap[name], gameObject)
end

function TacticalWeaponBasicPage:OnSuperUpgradeTimelinePlayEnd()
  if self.superStageUpTimelineReq then
    self.superStageUpTimelineReq.gameObject:SetActive(false)
  end
  local modelRoot = self.holder:GetModelViewSceneNode("Model")
  if modelRoot then
    local ani = modelRoot:GetComponentInChildren(typeof(CS.SimpleAnimation))
    if ani then
      ani:Rewind("uiLand")
      ani:Play("uiLand")
      ani:PlayQueued("uiIdle")
    end
  end
  self.upgradeSceneEffectList = {
    self:LoadSceneEffect("Assets/_Art_LastWar/Effect/Prefab/wurenji/Eff_wurenji_luodiqiliu_01.prefab")
  }
  if self.normalStageUpgradeTimer then
    self.normalStageUpgradeTimer:Stop()
  end
  self.normalStageUpgradeTimer = TimerManager:GetInstance():DelayInvoke(function()
    DataCenter.TacticalWeaponManager:OpenSuperUpgradeView()
    self:DestroySuperUpgradeTemporaryObj()
    self:SetUpgradeAniFlag(false)
  end, UPGRADE_SUPER_SECOND_DURATION)
  self:PlaySuperUpgradeSound()
end

function TacticalWeaponBasicPage:PlaySuperUpgradeSound()
  local appearance = DataCenter.TacticalWeaponManager:GetCurDefaultSkinAppearanceId()
  if appearance then
    local appearanceTemplate = DataCenter.AppearanceTemplateManager:GetTemplate(appearance)
    if appearanceTemplate then
      DataCenter.LWSoundManager:PlaySound(appearanceTemplate.sound_lvlup_TL, false)
    end
  end
end

function TacticalWeaponBasicPage:DestroySuperUpgradeTemporaryObj()
  if self.superStageUpTimelineReq then
    self.superStageUpTimelineReq:Destroy()
    self.superStageUpTimelineReq = nil
  end
  if self.upgradeSceneEffectList then
    for i, v in ipairs(self.upgradeSceneEffectList) do
      if v then
        v:Destroy()
        self.upgradeSceneEffectList[i] = nil
      end
    end
    self.upgradeSceneEffectList = nil
  end
end

local function GetIndex(self)
  if self.itemIndex == nil then
    self.itemIndex = 0
  else
    self.itemIndex = self.itemIndex + 1
  end
  return self.itemIndex
end

local function GetHitItem(self)
  if self.cachedItems and #self.cachedItems > 0 then
    local item = self.cachedItems[1]
    table.remove(self.cachedItems, 1)
    return item
  end
  local item = self.hitItemObj:GameObjectSpawn(self.hitItemContainer.transform)
  item.name = "item_gold_hit" .. GetIndex(self)
  local hit = self.hitItemContainer:AddComponent(TacticalWeaponCriticalItem, item.name)
  return hit
end

local function ShowHitItem(self, type)
  if type == 0 then
    return
  end
  local item = GetHitItem(self)
  if item and not IsNull(item.transform) then
    item.transform:SetAsLastSibling()
  end
  item:Show(type, self.critItemFinshCallback)
  DataCenter.LWSoundManager:PlaySound(62271, false)
end

local function ClearHitItems(self)
  self.hitItemContainer:RemoveComponents(TacticalWeaponCriticalItem)
  if not IsNull(self.hitItemObj) then
    self.hitItemObj.gameObject:GameObjectRecycleAll()
  end
  self.cachedItems = {}
end

local function OnCriticalItemFinish(self, item)
  if self.cachedItems == nil then
    self.cachedItems = {}
  end
  table.insert(self.cachedItems, item)
end

local function RefreshUpgradeBtnRedPoint(self)
  if self.upgradeBtn then
    self.upgradeBtnRedPoint:SetActive(self.weaponInfo:ShowUpgradeRedPoint())
  end
end

local function ResetSubLevelRectTransList(self)
  if not self.subLevelFillTransList then
    return
  end
  for i, v in ipairs(self.subLevelFillTransList) do
    local sizeDelta = v.sizeDelta
    sizeDelta.x = 0
    v.sizeDelta = sizeDelta
  end
end

local function PlayEffect(self, param)
  if param == nil then
    Logger.LogError("[PlayEffect] \230\178\161\228\188\160\229\143\130")
    return
  end
  if string.IsNullOrEmpty(param.path) then
    Logger.LogError("[PlayEffect] \230\178\161\228\188\160\229\143\130")
  end
  self:CreateEffect(param, self.effectIndex)
  self.effectIndex = self.effectIndex + 1
end

local function CreateEffect(self, param, index)
  self:GameObjectInstantiateAsync(param.path, function(request)
    if request.gameObject == nil then
      return
    end
    local go = request.gameObject
    if param.parent then
      go.transform:SetParent(param.parent)
    end
    if param.pos then
      go.transform:Set_localPosition(param.pos.x, param.pos.y, param.pos.z)
    end
    if param.eulerAngle then
      go.transform:Set_localEulerAngles(param.eulerAngle.x, param.eulerAngle.y, param.eulerAngle.z)
    end
    if param.scale then
      go.transform:Set_localScale(param.scale.x, param.scale.y, param.scale.z)
    end
    go.gameObject:SetActive(true)
    param.duration = param.duration or 1
    local data = {}
    data.id = index
    data.req = request
    data.name = go.name
    data.endTime = Time.time + param.duration
    self.effectMap[data.id] = data
  end)
end

local function Update100MS(self)
  self:CheckEffectLive()
end

local function CheckEffectLive(self)
  if not self.effectMap then
    return
  end
  for k, v in pairs(self.effectMap) do
    if v and Time.time > v.endTime then
      v.req.gameObject:SetActive(false)
      v.req:Destroy()
      self.effectMap[k] = nil
    end
  end
end

function TacticalWeaponBasicPage:PlayLevelUpEffect()
  DataCenter.LWSoundManager:PlaySound(62272, false)
  if not self.levelUpEffectReq then
    local path = "Assets/_Art_LastWar/Effect/Prefab/build/wurenji/Eff_z_wurenji_shengji_02.prefab"
    self.levelUpEffectReq = self:GameObjectInstantiateAsync(path, function(request)
      if IsNull(request.gameObject) then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.holder:GetModelViewSceneRoot().transform)
      go.transform:Set_localPosition(0, 0, 0)
      go.transform:Set_localScale(1, 1, 1)
      go.transform:Set_localEulerAngles(0, 0, 0)
    end)
  elseif self.levelUpEffectReq.isDone then
    if not self.levelUpEffectCpts then
      self.levelUpEffectCpts = self.levelUpEffectReq.gameObject.transform:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
    end
    if not IsNull(self.levelUpEffectCpts) then
      for i = 0, self.levelUpEffectCpts.Length - 1 do
        self.levelUpEffectCpts[i]:Play()
      end
    end
  end
end

function TacticalWeaponBasicPage:CheckFirstEnterTimeline()
  if DataCenter.LWGuideFlowManager.Runner:IsRun() then
    return
  end
  if self.weaponInfo.level < 50 then
    DataCenter.LWGuideFlowManager:WriteDone(4006)
    return
  end
  if not DataCenter.LWGuideFlowManager:ReadDone(4006) then
    local curNewLv = self.weaponInfo.level // 50 * 50
    self.holder:SetRootVisible(false)
    self:PlaySuperStageUpgradeAni(curNewLv)
    DataCenter.LWGuideFlowManager:WriteDone(4006)
  end
end

function TacticalWeaponBasicPage:PlayProgressSound()
  self:TryStopProgressSound()
  self.playingSubLevelProgressSound = DataCenter.LWSoundManager:PlaySound(62291, false)
end

function TacticalWeaponBasicPage:TryStopProgressSound()
  if self.playingSubLevelProgressSound then
    DataCenter.LWSoundManager:StopSound(self.playingSubLevelProgressSound)
    self.playingSubLevelProgressSound = nil
  end
end

TacticalWeaponBasicPage.OnCreate = OnCreate
TacticalWeaponBasicPage.OnDestroy = OnDestroy
TacticalWeaponBasicPage.OnEnable = OnEnable
TacticalWeaponBasicPage.OnDisable = OnDisable
TacticalWeaponBasicPage.OnAddListener = OnAddListener
TacticalWeaponBasicPage.OnRemoveListener = OnRemoveListener
TacticalWeaponBasicPage.ComponentDefine = ComponentDefine
TacticalWeaponBasicPage.DataDefine = DataDefine
TacticalWeaponBasicPage.ComponentDestroy = ComponentDestroy
TacticalWeaponBasicPage.DataDestroy = DataDestroy
TacticalWeaponBasicPage.ClearAttrs = ClearAttrs
TacticalWeaponBasicPage.ClearCostItems = ClearCostItems
TacticalWeaponBasicPage.SetData = SetData
TacticalWeaponBasicPage.RefreshAll = RefreshAll
TacticalWeaponBasicPage.RefreshAttrs = RefreshAttrs
TacticalWeaponBasicPage.RefreshCosts = RefreshCosts
TacticalWeaponBasicPage.RefreshBaseInfo = RefreshBaseInfo
TacticalWeaponBasicPage.RefreshUpgradeBtn = RefreshUpgradeBtn
TacticalWeaponBasicPage.UpgradeWeapon = UpgradeWeapon
TacticalWeaponBasicPage.OnWeaponUpgrade = OnWeaponUpgrade
TacticalWeaponBasicPage.StopUpgradeAnim = StopUpgradeAnim
TacticalWeaponBasicPage.ShowProgressAnim = ShowProgressAnim
TacticalWeaponBasicPage.RefreshSkillInfo = RefreshSkillInfo
TacticalWeaponBasicPage.StopPowerAnim = StopPowerAnim
TacticalWeaponBasicPage.ShowHitItem = ShowHitItem
TacticalWeaponBasicPage.ClearHitItems = ClearHitItems
TacticalWeaponBasicPage.OnCriticalItemFinish = OnCriticalItemFinish
TacticalWeaponBasicPage.RefreshUpgradeBtnRedPoint = RefreshUpgradeBtnRedPoint
TacticalWeaponBasicPage.RemoveChipFuncUnlockTimer = RemoveChipFuncUnlockTimer
TacticalWeaponBasicPage.RefreshChipFuncUnlockTime = RefreshChipFuncUnlockTime
TacticalWeaponBasicPage.AddChipFuncUnlockTimer = AddChipFuncUnlockTimer
TacticalWeaponBasicPage.RefreshChipFuncUnlock = RefreshChipFuncUnlock
TacticalWeaponBasicPage.OnChipFunctionUnlock = OnChipFunctionUnlock
TacticalWeaponBasicPage.PlaySubLevelAnim = PlaySubLevelAnim
TacticalWeaponBasicPage.TryShowSubLevelProgressAnim = TryShowSubLevelProgressAnim
TacticalWeaponBasicPage.ResetSubLevelRectTransList = ResetSubLevelRectTransList
TacticalWeaponBasicPage.PlayEffect = PlayEffect
TacticalWeaponBasicPage.Update100MS = Update100MS
TacticalWeaponBasicPage.CreateEffect = CreateEffect
TacticalWeaponBasicPage.CheckEffectLive = CheckEffectLive
return TacticalWeaponBasicPage
