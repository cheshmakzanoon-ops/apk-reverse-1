local TacticalWeaponSkillChipPage = BaseClass("TacticalWeaponSkillChipPage", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local SkillChipSetToggle = require("UI.UILWTacticalWeapon.Component.SkillChipPage.SkillChipSetToggle")
local SkillChipAttrLineItem = require("UI.UILWTacticalWeapon.Component.SkillChipPage.SkillChipAttrLineItem")
local SkillChipItem = require("UI.UILWTacticalWeapon.Component.SkillChipPage.SkillChipPageItem")
local UIHeroSimpleTipView = require("UI.UILWHero.UIHeroSimpleTip.View.UIHeroSimpleTipView")
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local illustrated_book_btn_path = "LeftTopBtns/IllustratedBookBtn"
local reset_btn_path = "LeftTopBtns/ResetBtn"
local quick_equip_btn_path = "Btns/QuickEquipBtn"
local quick_equip_btn_red_point_path = "Btns/QuickEquipBtn/Btn/QuickEquipBtnRedPoint"
local quick_unequip_btn_path = "Btns/QuickUnequipBtn"
local quick_unequip_btn_red_point_path = "Btns/QuickUnequipBtn/Btn/QuickUnequipBtnRedPoint"
local toggles_path = "Toggles"
local toggle_path = "Toggles/Toggle%d"
local power_info_path = "PowerInfo"
local skill_chips_path = "SkillChips"
local skill_chip_path = "SkillChips/SkillChip%d"
local attrs_path = "Attrs"
local attr_line_path = "Attrs/AttrLine%d"
local guarant_box_btn_path = "RightTopBtns/GuarantBoxBtn"
local guarant_box_red_point_path = "RightTopBtns/GuarantBoxBtn/GuarantBoxRedPoint"
local reward_icon_path = "RightTopBtns/GuarantBoxBtn/RewardIcon"
local score_progress_text_path = "RightTopBtns/GuarantBoxBtn/ScoreProgressText"
local progress_foreground_path = "RightTopBtns/GuarantBoxBtn/ProgressForeground"
local glow_path = "SkillChips/Glow%d"
local tip_btn_path = "Attrs/AttrDesc/tipBtn"
local bg_path = "bg"
local TacticalChipPlanTabItem = require("UI.UILWTacticalWeaponChip.Component.TacticalChipPlanTabItem")
local TacticalChipStatsAttriItem = require("UI.UILWTacticalWeaponChip.Component.TacticalChipStatsAttriItem")
local SkillChipSmallItem = require("UI.UILWTWSkillChip.UILWTWSkillChipManage.Component.SkillChipSmallItem")
local TacticalChipItem = require("UI.UILWTacticalWeaponChip.Component.TacticalChipItem")
local TacticalChipOpenPreTipItem = require("UI.UILWTacticalWeapon.Component.SkillChipPage.TacticalChipOpenPreTipItem")
local FOCUS_PART_NAME = "battlesystem_part_name%s"
local CAMERA_VIRTUAL_POS_NAME = "camPos%s"
local TO_PLAN_POS_NODE = "toPlanPos"
local CAMERA_MOVE_DURATION = 0.75
local PLAN_OPEN_WAIT_TIME = 0.2
local AIR_PART_VFX_WAIT_TIME = 0.5
local LEVEL_UP_EFFECT_WAIT_TIME = 0.5
local SceneVfxPaths = {
  [TacticalChipFocusType.YinQing] = "Eff_yinqing",
  [TacticalChipFocusType.DianChi] = "Eff_dianchi",
  [TacticalChipFocusType.LeiDa] = "Eff_leida",
  [TacticalChipFocusType.XinPian] = "Eff_xinpian"
}
local QUALITY_BAR_PATH = "Assets/Main/Sprites/UI/LWUITacticalWeaponChip/%s"
local TAB_COUNT = 4
local AnimationNames = {
  Open = "V_ui_skillchippage_in",
  Close = "V_ui_skillchippage_out",
  DescOpen = "V_ui_detailitem_in",
  DescClose = "V_ui_detailitem_out",
  StatsOpen = "V_ui_stats_open",
  StatsClose = "V_ui_stats_close"
}
local TabAnimationName = "V_ui_skillchippage_tabroot_in"
local AnimationDuration = {
  DescOpen = 1.1,
  DescClose = 0.2,
  Tab = 1,
  StatsOpen = 1,
  StatsClose = 1
}
local quality_title_bg_path = "mainNode/Middle/levelInfoPanel/levelInfoBaseRoot/qualityTitleBg"
local level_info_title_path = "mainNode/Middle/levelInfoPanel/levelInfoBaseRoot/levelInfoTitle"
local cur_level_value_path = "mainNode/Middle/levelInfoPanel/levelInfoBaseRoot/curLevelValue"
local arrow_path = "mainNode/Middle/levelInfoPanel/levelInfoBaseRoot/curLevelValue/arrow"
local next_level_value_path = "mainNode/Middle/levelInfoPanel/levelInfoBaseRoot/curLevelValue/nextLevelValue"
local quality_up_tip_path = "mainNode/Middle/levelInfoPanel/levelInfoBaseRoot/qualityUpTip"
local level_progress_path = "mainNode/Middle/levelInfoPanel/levelInfoBaseRoot/levelProgress"
local level_progress_fill_pre_path = "mainNode/Middle/levelInfoPanel/levelInfoBaseRoot/levelProgress/Bg/levelProgressFillPre"
local level_progress_fill_path = "mainNode/Middle/levelInfoPanel/levelInfoBaseRoot/levelProgress/Bg/levelProgressFill"
local level_progress_value_path = "mainNode/Middle/levelInfoPanel/levelInfoBaseRoot/levelProgress/levelProgressValue"
local level_info_btn_path = "mainNode/Middle/levelInfoPanel/levelInfoBtn"
local use_exp_props_tip_path = "mainNode/Middle/levelInfoPanel/levelInfoPropsFillRoot/useExpPropsTip"
local add_exp_props_btn_path = "mainNode/Middle/levelInfoPanel/levelInfoPropsFillRoot/addExpPropsBtn"
local props_list_scroll_path = "mainNode/Middle/levelInfoPanel/levelInfoPropsFillRoot/propsListScroll"
local content_path = "mainNode/Middle/levelInfoPanel/levelInfoPropsFillRoot/propsListScroll/Viewport/Content"
local auto_add_exp_props_btn_path = "mainNode/Btns/autoAddExpPropsBtn"
local upgrade_btn_path = "mainNode/Btns/upgradeBtn"
local attribute_list_node_path = "mainNode/LeftTopBtns/statsRoot/statsFoldPanel/foldBg/attributeListNode"
local tab_root_path = "mainNode/Middle/tabRoot"
local auto_add_exp_props_btn_text_path = "mainNode/Btns/autoAddExpPropsBtn/Btn/autoAddExpPropsBtnText"
local upgrade_btn_text_path = "mainNode/Btns/upgradeBtn/Btn/upgradeBtnText"
local level_up_vfx_node_path = "mainNode/Middle/levelInfoPanel/levelInfoBaseRoot/curLevelValue/levelUpVfxNode"
local air_r_t_path = "airRT"
local part_detail_item_path = "mainNode/Middle/partDetailItem"
local part_detail_item_desc_path = "mainNode/Middle/partDetailItem/partDetailItemDesc"
local power_number_text_path = "mainNode/Middle/PowerInfo/PowerNumberText"

local function OnCreate(self)
  base.OnCreate(self)
  local skillChipManager = DataCenter.TWSkillChipManager
  self:ComponentDefine()
  self:DataDefine()
  self:InitVfx()
  self:RefreshLevelInfo()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
  self:InitBg()
  local isSystemOpen = DataCenter.TacticalChipManager:IsFunctionOpen()
  if isSystemOpen then
    self:RefreshChipBoxProps()
    self:RefreshLevelInfo()
    self:RefreshSystemTier()
    self:RefreshFeedList()
    self:RefreshAttributeList()
    self:RefreshCurExpProgressForce()
    self:RefreshPreExpProgressForce()
    self:RefreshBtnStatus()
    self:RefreshRedPoints()
    self:ForceRefreshTabUnlockStatus()
    self.animator:Play(AnimationNames.Open)
  else
    self:RefreshPreOpenStatus()
  end
  self.compMainNode:SetActive(isSystemOpen)
  self.compLockNode:SetActive(not isSystemOpen)
end

local function OnDisable(self)
  DataCenter.TacticalChipManager:ClearUpgradeFeedCache()
  self:RevertCameraFocus()
  self:OutFocusChipPart()
  self.active = false
  base.OnDisable(self)
end

local function GetQuickEquipOptions(self)
  if self.curSetId then
    return TacticalWeaponUtils.GetQuickEquipOptions(self.curSetId)
  else
    return {}
  end
end

local function ComponentDefine(self)
  self.powerNumberText = self:AddComponent(UIText, power_number_text_path)
  self.compStatsArrow = self:AddComponent(UIBaseContainer, "mainNode/LeftTopBtns/statsRoot/statsArrow")
  self.detailBtn = self:AddComponent(UIButton, "mainNode/RightTopBtns/detailBtn")
  self.detailBtn:SetOnClick(function()
    self:OnBtnDetailClick()
  end)
  self.textStatsTitle = self:AddComponent(UIText, "mainNode/LeftTopBtns/statsRoot/statsTitle")
  self.textStatsTitle:SetLocalText("battlesystem_main_desc1")
  self.btnStats = self:AddComponent(UIButton, "mainNode/LeftTopBtns/statsRoot/statsBtn")
  self.btnStats:SetOnClick(function()
    self:OnBtnStatsClick()
  end)
  self.compStatsFoldPanel = self:AddComponent(UIBaseContainer, "mainNode/LeftTopBtns/statsRoot/statsFoldPanel")
  self.attribute_list_node = self:AddComponent(UIBaseContainer, attribute_list_node_path)
  self.qualityTitleBg = self:AddComponent(UIImage, quality_title_bg_path)
  self.qualityTitleBgNode = self:AddComponent(UIVfx, quality_title_bg_path)
  self.levelInfoTitle = self:AddComponent(UITextMeshProUGUIEx, level_info_title_path)
  self.curLevelValue = self:AddComponent(UITextMeshProUGUIEx, cur_level_value_path)
  self.arrowObj = self:AddComponent(UIBaseContainer, arrow_path)
  self.nextLevelValue = self:AddComponent(UITextMeshProUGUIEx, next_level_value_path)
  self.quality_up_tip = self:AddComponent(UITextMeshProUGUIEx, quality_up_tip_path)
  self.levelProgressRoot = self:AddComponent(UIBaseContainer, level_progress_path)
  self.progressDefaultFill = self.levelProgressRoot.rectTransform.sizeDelta.x
  self.levelProgressFillPre = self:AddComponent(UIBaseContainer, level_progress_fill_pre_path)
  self.levelProgressFill = self:AddComponent(UIBaseContainer, level_progress_fill_path)
  self.levelProgressValue = self:AddComponent(UITextMeshProUGUIEx, level_progress_value_path)
  self.level_info_btn = self:AddComponent(UIButton, level_info_btn_path)
  self.level_info_btn:SetOnClick(function()
    self:OnTierInfoBtnClick()
  end)
  self.props_list_scroll = self:AddComponent(UILoopListView2, props_list_scroll_path)
  self.props_list_scroll:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.propsListContent = self:AddComponent(UIBaseContainer, content_path)
  self.use_exp_props_tip = self:AddComponent(UITextMeshProUGUIEx, use_exp_props_tip_path)
  self.use_exp_props_tip:SetLocalText("battlesystem_main_desc4")
  self.add_exp_props_btn = self:AddComponent(UIButton, add_exp_props_btn_path)
  self.add_exp_props_btn:SetOnClick(function()
    self:OnUsePropsBtnClick()
  end)
  self.auto_add_exp_props_btn = self:AddComponent(UIButton, auto_add_exp_props_btn_path)
  self.auto_add_exp_props_btn:SetOnClick(function()
    self:OnAutoSelectBtnClick()
  end)
  self.autoAddExpPropsBtnRedPoint = self:AddComponent(UIButton, "mainNode/Btns/autoAddExpPropsBtn/autoAddExpPropsBtnRedPoint")
  self.autoAddExpPropsBtnRedPoint:SetActive(false)
  self.upgrade_btn = self:AddComponent(UIButton, upgrade_btn_path)
  self.upgrade_btn:SetOnClick(function()
    self:OnUpgradeBtnClick()
  end)
  self.auto_add_exp_props_btn_text = self:AddComponent(UITextMeshProUGUIEx, auto_add_exp_props_btn_text_path)
  self.auto_add_exp_props_btn_text:SetLocalText("battlesystem_main_button2")
  self.upgrade_btn_text = self:AddComponent(UITextMeshProUGUIEx, upgrade_btn_text_path)
  self.upgrade_btn_text:SetLocalText("battlesystem_main_button3")
  self.level_up_vfx_node = self:AddComponent(UIVfx, level_up_vfx_node_path)
  self.airRT = self:AddComponent(UIRawImage, air_r_t_path)
  self.part_detail_item = self:AddComponent(UIBaseContainer, part_detail_item_path)
  self.part_detail_item_desc = self:AddComponent(UITextMeshProUGUIEx, part_detail_item_desc_path)
  self.animator = self:AddComponent(UIAnimator, "")
  self.compMainNode = self:AddComponent(UIBaseContainer, "mainNode")
  self.compLockNode = self:AddComponent(UIBaseContainer, "lockNode")
  self.compSystemOpenTipItemLayoutNode = self:AddComponent(UIBaseContainer, "lockNode/systemOpenTipItemLayoutNode")
  self.textSystemOpenDesc = self:AddComponent(UIText, "lockNode/systemOpenDesc")
  self.textSystemOpenResidueTime = self:AddComponent(UIText, "lockNode/systemOpenResidueTime")
  self.btnSystemEnter = self:AddComponent(UIButton, "lockNode/systemEnterBtn")
  self.btnSystemEnter:SetOnClick(function()
    self:OnBtnSystemEnterClick()
  end)
  self.textSystemEnterBtn = self:AddComponent(UIText, "lockNode/systemEnterBtn/Btn/systemEnterBtnText")
  self.textSystemEnterBtn:SetLocalText("battlesystem_previewing_button1")
  self.compBoxPropsBtnRedPoint = self:AddComponent(UIBaseContainer, "mainNode/RightTopBtns/boxPropsBtn/boxPropsBtnRedPoint")
  self.btnBoxProps = self:AddComponent(UIButton, "mainNode/RightTopBtns/boxPropsBtn")
  self.btnBoxProps:SetOnClick(function()
    self:OnBtnBoxPropsClick()
  end)
  self.powerVfxNode = self:AddComponent(UIVfx, "mainNode/Middle/PowerInfo/powerVfxNode")
  self.systemOpenTipDescPanel = self:AddComponent(UIBaseContainer, "lockNode/systemOpenTipDescPanel")
  self.systemOpenTipDetailDesc = self:AddComponent(UIText, "lockNode/systemOpenTipDescPanel/textScroll/viewport/content/systemOpenTipDetailDesc")
  self.systemOpenTipDescPanelCloseBtn = self:AddComponent(UIButton, "lockNode/systemOpenTipDescPanel/systemOpenTipDescPanelCloseBtn")
  self.systemOpenTipDescPanelCloseBtn:SetOnClick(function()
    self.systemOpenTipDescPanel:SetActive(false)
  end)
end

local function ComponentDestroy(self)
  self:RemoveChipFuncUnlockTimer()
  self.part_detail_item:SetActive(false)
  self.part_detail_item = nil
  self.attribute_list_node:RemoveComponents(TacticalChipStatsAttriItem)
  self.propsListContent:RemoveComponents(TacticalChipItem)
  self.props_list_scroll:ClearAllItems()
  self.illustratedBookBtn = nil
  self.resetBtn = nil
  self.quickEquipBtn = nil
  self.quickEquipBtnRedPoint = nil
  self.quickUnEquipBtn = nil
  self.quickUnEquipBtnRedPoint = nil
  self.togglesContainer = nil
  self.toggles = nil
  self.powerNumberText = nil
  self.skillChipsContainer = nil
  self.skillChips = nil
  self.attrsContainer = nil
  self.attrs = nil
  self.compMainNode = nil
  self.compLockNode = nil
  self.compSystemOpenTipItemLayoutNode = nil
  self.textSystemOpenDesc = nil
  self.textSystemOpenResidueTime = nil
  self.btnSystemEnter = nil
  self.textSystemEnterBtn = nil
  self.compBoxPropsBtnRedPoint = nil
  self.btnBoxProps = nil
  self.systemOpenTipDescPanel = nil
  self.systemOpenTipDetailDesc = nil
  self.systemOpenTipDescPanelCloseBtn = nil
end

local function DataDefine(self)
  self.isFocus = false
  self.chipSetupNodeMap = {}
  self.chipSetupNodeMap[TacticalChipFocusType.LeiDa] = {}
  self.chipSetupNodeMap[TacticalChipFocusType.YinQing] = {}
  self.chipSetupNodeMap[TacticalChipFocusType.DianChi] = {}
  self.chipSetupNodeMap[TacticalChipFocusType.XinPian] = {}
  self.itemIndex = 0
  self.curSetChips = {}
  self.curSetId = nil
  self.tabReqList = {}
  self.tabItemList = {}
  self.attributeItemList = {}
  self.defaultTabId = 1
  self.isUnFoldStats = true
end

local function DataDestroy(self)
  self.isFocus = nil
  DataCenter.TacticalChipManager:ClearUpgradeFeedCache()
  if self.airVfxPlayTimer then
    self.airVfxPlayTimer:Stop()
    self.airVfxPlayTimer = nil
  end
  if self.levelUpTimer then
    self.levelUpTimer:Stop()
    self.levelUpTimer = nil
  end
  if self.toPlanViewTimer then
    self.toPlanViewTimer:Stop()
    self.toPlanViewTimer = nil
  end
  if self.focusChipPartTimer then
    self.focusChipPartTimer:Stop()
    self.focusChipPartTimer = nil
  end
  if self.upgradeSeq then
    self.upgradeSeq:Kill()
    self.upgradeSeq = nil
  end
  for i, v in pairs(self.chipSetupNodeMap) do
    v.node = nil
    v.vfxCpt = nil
  end
  self.chipSetupNodeMap = nil
  self.itemIndex = nil
  self.tabReqList = nil
  self.curSetChips = nil
  self.curSetId = nil
  self.tabItemList = nil
  self.attributeItemList = nil
  self.defaultTabId = nil
  self.isUnFoldStats = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.TWSkillUpdate, self.OnChipDataUpdate)
  self:AddUIListener(EventId.RefreshItems, self.RefreshChipBoxProps)
  self:AddUIListener(EventId.TacticalWeaponUpdate, self.OnTacticalWeaponUpdate)
  self:AddUIListener(EventId.TacticalChipStageUpgradeUIClose, self.OnStageUpgradeUIClose)
  self:AddUIListener(EventId.TacticalChipSaveFeed, self.OnFeedUpdate)
  self:AddUIListener(EventId.TWSkillChipFunctionUnlock, self.OnChipFunctionUnlock)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.TWSkillUpdate, self.OnChipDataUpdate)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshChipBoxProps)
  self:RemoveUIListener(EventId.TacticalWeaponUpdate, self.OnTacticalWeaponUpdate)
  self:RemoveUIListener(EventId.TacticalChipStageUpgradeUIClose, self.OnStageUpgradeUIClose)
  self:RemoveUIListener(EventId.TacticalChipSaveFeed, self.OnFeedUpdate)
  self:RemoveUIListener(EventId.TWSkillChipFunctionUnlock, self.OnChipFunctionUnlock)
end

function TacticalWeaponSkillChipPage:OnStageUpgradeUIClose()
  if self.reUpgradeAfterStageUpgrade then
    local oldLv = self.curLv
    local oldExp = self.curExp
    self:OnChipSystemUpgrade(oldLv, oldExp)
    self.reUpgradeAfterStageUpgrade = false
    if self.levelUpTimer then
      self.levelUpTimer:Stop()
    end
    self.levelUpTimer = TimerManager:GetInstance():DelayInvoke(function()
      local showTabLevel = DataCenter.TacticalChipManager:GetPlanUnlockLevel(1)
      if showTabLevel > oldLv and showTabLevel <= self.curLv then
        self:CheckFirstChipPlanShowGuide()
      end
      self:RefreshSystemTier()
      self.qualityTitleBgNode:Play(VfxAssets.TacticalChipTierUp)
    end, LEVEL_UP_EFFECT_WAIT_TIME)
  end
end

function TacticalWeaponSkillChipPage:OnFeedUpdate()
  self:RefreshFeedList()
  self:RefreshAttributeListPre()
  self:RefreshPreExpProgressForce()
  self:RefreshCameraFocus()
  self:RefreshBtnStatus()
end

function TacticalWeaponSkillChipPage:OnTacticalWeaponUpdate()
  if self.curLv == nil or self.curExp == nil then
    Logger.LogError("data is not init !")
    return
  end
  if not DataCenter.TacticalChipManager:IsFunctionOpen() then
    return
  end
  local newWeaponInfo = DataCenter.TacticalWeaponManager:GetFirstWeaponInfo()
  if newWeaponInfo.chipLv ~= self.curLv or newWeaponInfo.chipExp ~= self.curExp then
    local oldLv = self.curLv
    local oldExp = self.curExp
    local oldTier = self.curLevelTemplate.system_tier
    local newLvTemplate = DataCenter.TacticalChipManager:GetLevelTemplate(newWeaponInfo.chipLv)
    if oldTier == newLvTemplate.system_tier then
      if self.airVfxPlayTimer then
        self.airVfxPlayTimer:Stop()
      end
      self:PlayAirPartVfx()
      self.airVfxPlayTimer = TimerManager:GetInstance():DelayInvoke(function()
        self:OnChipSystemUpgrade(oldLv, oldExp)
        local showTabLevel = DataCenter.TacticalChipManager:GetPlanUnlockLevel(1)
        if showTabLevel > oldLv and showTabLevel <= self.curLv then
          self:CheckFirstChipPlanShowGuide()
        end
      end, AIR_PART_VFX_WAIT_TIME)
    else
      self.reUpgradeAfterStageUpgrade = true
    end
  end
end

function TacticalWeaponSkillChipPage:OnChipDataUpdate()
  self:RefreshRedPoints()
end

function TacticalWeaponSkillChipPage:OnChipFunctionUnlock()
  self:RefreshLevelInfo()
  self:RefreshSystemTier()
  self:RefreshFeedList()
  self:RefreshAttributeList()
  self:RefreshCurExpProgressForce()
  self:RefreshPreExpProgressForce()
  self:RefreshBtnStatus()
  self.compMainNode:SetActive(true)
  self.compLockNode:SetActive(false)
  self:CheckFirstEnterSystemGuide()
  self:RemoveChipFuncUnlockTimer()
end

local function SetData(self, weaponInfo)
end

function TacticalWeaponSkillChipPage:InitVfx()
end

function TacticalWeaponSkillChipPage:InitBg()
  if self.holder then
    if not self.holder:IsModelViewSceneLoaded(SceneAssets.TacticalChipAir) then
      self.holder:RegisterOnSceneLoadCallback(TacticalWeaponPageType.SkillChip, Bind(self, self.OnSceneLoadComplete))
    else
      self:OnSceneLoadComplete()
    end
  end
end

function TacticalWeaponSkillChipPage:InitTabList()
  self.tabReqList = self:CreateTabItem(i)
  for i = 1, TAB_COUNT do
  end
end

function TacticalWeaponSkillChipPage:InitStatsAttributeList()
  self.attributeList = DataCenter.TacticalChipManager:GetStatsAttributeList(self.curLv)
  for i = 1, #self.attributeList do
    self.attributeReqList = self:CreateAttributeItem(i, self.attributeList[i])
  end
end

function TacticalWeaponSkillChipPage:OnChipSystemUpgrade(oldLv, oldExp)
  self:RefreshLevelInfo()
  self:PlayCombatPowerUpVfx(oldLv, self.curLv)
  self:RefreshFeedList()
  self:RefreshAttributeList()
  self:PlayAniCurExpProgress(oldLv, self.curLv, oldExp, self.curExp)
  self:OutFocusChipPart()
  self:RefreshBtnStatus()
end

function TacticalWeaponSkillChipPage:RefreshPreOpenStatus()
  if self.preOpenItemReqList == nil then
    self:CreatePreOpenTipItemList()
  end
  self:RefreshChipFuncUnlock()
end

function TacticalWeaponSkillChipPage:RefreshChipFuncUnlockTime()
  local remainTime = DataCenter.TWSkillChipManager:GetSkillChipUnlockRemainTime()
  if 0 < remainTime then
    self.textSystemOpenResidueTime:SetText(UITimeManager:GetInstance():SecondToFmtString(remainTime))
  else
    self:RefreshChipFuncUnlock()
  end
end

function TacticalWeaponSkillChipPage:RefreshChipFuncUnlock()
  local functionUnlock = DataCenter.TWSkillChipManager:IsFunctionUnlock()
  self:RemoveChipFuncUnlockTimer()
  if not functionUnlock then
    local remainTime = DataCenter.TWSkillChipManager:GetSkillChipUnlockRemainTime()
    if 0 < remainTime then
      self.textSystemOpenResidueTime:SetText(UITimeManager:GetInstance():SecondToFmtString(remainTime))
      self:AddChipFuncUnlockTimer()
    end
    self.btnSystemEnter:SetActive(remainTime <= 0)
    self.textSystemOpenResidueTime:SetActive(0 < remainTime)
    if 0 < remainTime then
      self.textSystemOpenDesc:SetLocalText("battlesystem_previewing_desc6")
    else
      self.textSystemOpenDesc:SetLocalText("battlesystem_previewing_desc7")
    end
  else
    self:OnChipFunctionUnlock()
  end
end

function TacticalWeaponSkillChipPage:RefreshLevelInfo()
  local weaponInfo = DataCenter.TacticalWeaponManager:GetFirstWeaponInfo()
  if weaponInfo == nil then
    Logger.LogError("weaponInfo is nil!!!")
    return
  end
  self.curLv = weaponInfo.chipLv
  self.curExp = weaponInfo.chipExp
  self.curLevelTemplate = DataCenter.TacticalChipManager:GetLevelTemplate(self.curLv)
  self.curLevelValue:SetText(string.format("Lv.%s", self.curLv))
  local totalPower = DataCenter.TacticalWeaponManager:GetWeaponTotalPower()
  self.powerNumberText:SetText(totalPower)
end

function TacticalWeaponSkillChipPage:RefreshSystemTier()
  local tier = self.curLevelTemplate.system_tier
  self.curTierTemplate = DataCenter.TacticalChipManager:GetTierTemplate(tier)
  self.levelInfoTitle:SetLocalText(self.curTierTemplate.tier_name)
  self.qualityTitleBg:LoadSprite(string.format(QUALITY_BAR_PATH, self.curTierTemplate.tier_banner))
  if not DataCenter.TacticalChipManager:IsMaxTier(tier) then
    local nextTier = tier + 1
    local nextTierTemplate = DataCenter.TacticalChipManager:GetTierTemplate(nextTier)
    self.quality_up_tip:SetLocalText("battlesystem_main_desc3", nextTierTemplate.tier_level)
    self.quality_up_tip:SetActive(true)
  else
    self.quality_up_tip:SetActive(false)
  end
end

function TacticalWeaponSkillChipPage:RefreshFeedList()
  self.usePropsList = DataCenter.TacticalChipManager:GetUpgradeFeedListCache()
  local noProps = self.usePropsList == nil or #self.usePropsList == 0
  self.props_list_scroll:SetActive(not noProps)
  self.use_exp_props_tip:SetActive(noProps)
  if not noProps then
    self.props_list_scroll:SetListItemCount(#self.usePropsList, false, false)
    self.props_list_scroll:RefreshAllShownItem()
  end
end

function TacticalWeaponSkillChipPage:RefreshAttributeList()
  self.attributeList = DataCenter.TacticalChipManager:GetStatsAttributeList(self.curLv)
  if self.attributeItemList and #self.attributeItemList > 0 then
    for i, v in ipairs(self.attributeItemList) do
      if v then
        v:SetData(self.attributeList[i])
      end
    end
  else
    for i = 1, #self.attributeList do
      self.attributeReqList = self:CreateAttributeItem(i, self.attributeList[i])
    end
  end
end

function TacticalWeaponSkillChipPage:RefreshCurExpProgressForce(curLv, curExp)
  curLv = curLv or self.curLv
  curExp = curExp or self.curExp
  self.arrowObj:SetActive(false)
  self.nextLevelValue:SetActive(false)
  if DataCenter.TacticalChipManager:IsMaxLevel(curLv) then
    self:RefreshExpFill(self.levelProgressFill.rectTransform, 1, 1)
    self.levelProgressValue:SetLocalText("battlesystem_main_desc6")
    return
  end
  local toNextExp = self.curLevelTemplate.exp_cost
  self:RefreshExpFill(self.levelProgressFill.rectTransform, curExp, toNextExp)
end

function TacticalWeaponSkillChipPage:RefreshPreExpProgressForce(curLv, curExp)
  curLv = curLv or self.curLv
  curExp = curExp or self.curExp
  local preLv, preEx = DataCenter.TacticalChipManager:GetPreLvByUpgradeFeedCache(curLv, curExp)
  local addTotalExp = DataCenter.TacticalChipManager:GetFeedTotalExpCache()
  if DataCenter.TacticalChipManager:IsMaxLevel(curLv) then
    self:RefreshExpFill(self.levelProgressFillPre.rectTransform, 1, 1)
  else
    self:RefreshExpFill(self.levelProgressFillPre.rectTransform, self.curExp + addTotalExp, self.curLevelTemplate.exp_cost)
    self.levelProgressValue:SetText(string.format("%s/%s", curExp + addTotalExp, self.curLevelTemplate.exp_cost))
  end
  if curLv < preLv then
    self.nextLevelValue:SetText(string.format("Lv.%s", preLv))
  end
  self.arrowObj:SetActive(curLv < preLv)
  self.nextLevelValue:SetActive(curLv < preLv)
end

function TacticalWeaponSkillChipPage:RefreshAttributeListPre()
  local preLv, preEx = DataCenter.TacticalChipManager:GetPreLvByUpgradeFeedCache(self.curLv, self.curExp)
  self.attributeList = DataCenter.TacticalChipManager:GetStatsAttributeList(preLv)
  if self.attributeItemList then
    for i, v in ipairs(self.attributeItemList) do
      if v then
        if preLv > self.curLv then
          v:ShowPreData(self.attributeList[i])
        else
          v:RefreshUI()
        end
      end
    end
  end
end

function TacticalWeaponSkillChipPage:RefreshTabStatus()
  local showTabLevel = DataCenter.TacticalChipManager:GetPlanUnlockLevel(1)
  if showTabLevel <= self.curLv then
    self.compTabRoot:SetActive(true)
    self:PlayTabShowAni()
    self:CheckFirstChipPlanShowGuide()
  else
    self.compTabRoot:SetActive(false)
  end
end

function TacticalWeaponSkillChipPage:RefreshBtnStatus()
  local addTotalExp = DataCenter.TacticalChipManager:GetFeedTotalExpCache()
  UIGray.SetGray(self.upgrade_btn.transform, addTotalExp <= 0, 0 < addTotalExp)
  self.autoAddExpPropsBtnRedPoint:SetActive(DataCenter.TacticalChipManager:CheckCanUpgrade())
end

local expAniDuration = 0.32
local progressAnimScale = 1.2

function TacticalWeaponSkillChipPage:PlayAniCurExpProgress(oldLv, newLv, oldExp, newExp)
  if self.upgradeSeq then
    self.upgradeSeq:Kill()
  end
  self.upgradeSeq = CS.DG.Tweening.DOTween.Sequence()
  local time = expAniDuration * 0.5
  local oldTemplate = DataCenter.TacticalChipManager:GetLevelTemplate(oldLv)
  local newTemplate = DataCenter.TacticalChipManager:GetLevelTemplate(newLv)
  local expOrigin = oldExp
  local toNextExp = oldTemplate.exp_cost
  if oldLv < newLv then
    expOrigin = 0
    toNextExp = newTemplate.exp_cost
    self.upgradeSeq:Append(DOTween.To(function(x)
      self:RefreshExpFill(self.levelProgressFill.rectTransform, x, oldTemplate.exp_cost)
    end, oldExp, oldTemplate.exp_cost, expAniDuration):SetEase(CS.DG.Tweening.Ease.OutCubic):OnComplete(function()
      self:RefreshCurExpProgressForce(newLv, 0)
      self:RefreshPreExpProgressForce(newLv, newExp)
    end))
    self.level_up_vfx_node:PlayByOnce(VfxAssets.CombatUpgradeEffect)
    DataCenter.LWSoundManager:PlaySound(62275, false)
  end
  if newExp > expOrigin then
    self.upgradeSeq:Append(DOTween.To(function(x)
      self:RefreshExpFill(self.levelProgressFill.rectTransform, x, toNextExp)
    end, expOrigin, newExp, expAniDuration):SetEase(CS.DG.Tweening.Ease.OutCubic):OnComplete(function()
      self:RefreshCurExpProgressForce()
    end))
  end
  self.upgradeSeq:Insert(time, self.levelProgressValue.transform:DOScale(Vector3.New(progressAnimScale, progressAnimScale, progressAnimScale), 0.15))
  time = time + expAniDuration
  self.upgradeSeq:Insert(time, self.levelProgressValue.transform:DOScale(Vector3.one, expAniDuration * 0.5))
end

function TacticalWeaponSkillChipPage:RefreshRedPoints()
  for planId = 1, 4 do
    local existRedDot = false
    local planDataGroup = DataCenter.TacticalChipManager:GetPlanChips(planId)
    for pos = 1, 4 do
      local skillInfo = planDataGroup[pos]
      if skillInfo then
        local replaceRedDot = TacticalWeaponUtils.SkillChipCanReplace(skillInfo)
        local starUpRedDot = TacticalWeaponUtils.SkillChipCanStarUp(skillInfo)
        existRedDot = existRedDot or replaceRedDot or starUpRedDot
      else
        local list = TacticalWeaponUtils.GetFreeChipsByType(pos)
        existRedDot = existRedDot or 0 < #list
      end
    end
    if self.tabItemList then
      for _, tabItem in ipairs(self.tabItemList) do
        if tabItem and tabItem.tabId == planId then
          local isUnlock = DataCenter.TacticalChipManager:IsPlanUnlock(tabItem.tabId)
          tabItem:SetRedDotVisible(isUnlock and existRedDot)
        end
      end
    end
  end
end

function TacticalWeaponSkillChipPage:PlayAniPreExpProgress()
  local newLv, newExp = DataCenter.TacticalChipManager:GetPreLvByUpgradeFeedCache(self.curLv, self.curExp)
  if self.upgradeSeq then
    self.upgradeSeq:Kill()
  end
  self.upgradeSeq = CS.DG.Tweening.DOTween.Sequence()
  local time = 0
  self.upgradeSeq:Insert(time, self.levelProgressValue.transform:DOScale(Vector3.New(progressAnimScale, progressAnimScale, progressAnimScale), 0.15))
  time = time + expAniDuration * 0.5
  self.upgradeSeq:Insert(time, self.levelProgressValue.transform:DOScale(Vector3.one, expAniDuration / 2))
  local newTemplate = DataCenter.TacticalChipManager:GetLevelTemplate(newLv)
  local expOrigin = oldExp
  local toNextExp = self.curLevelTemplate.exp_cost
  if newLv > oldLv then
    expOrigin = 0
    toNextExp = newTemplate.exp_cost
    self.upgradeSeq:Append(DOTween.To(function(x)
      self:RefreshExpFill(self.levelProgressFillPre.rectTransform, x, toNextExp)
    end, oldExp, toNextExp, expAniDuration):SetEase(CS.DG.Tweening.Ease.OutCubic))
  end
  if newExp > expOrigin then
    self.upgradeSeq:Append(DOTween.To(function(x)
      self:RefreshExpFill(self.levelProgressFillPre.rectTransform, x, toNextExp)
    end, expOrigin, newExp, expAniDuration):SetEase(CS.DG.Tweening.Ease.OutCubic))
  end
end

function TacticalWeaponSkillChipPage:RefreshExpFill(rectTrans, curValue, totalValue)
  local showProgress = math.min(curValue / totalValue, 1)
  if showProgress < 0 then
    showProgress = 0
  end
  local sizeDelta = rectTrans.sizeDelta
  sizeDelta.x = self.progressDefaultFill * showProgress
  rectTrans.sizeDelta = sizeDelta
end

function TacticalWeaponSkillChipPage:RefreshCameraFocus()
  local addExp = DataCenter.TacticalChipManager:GetFeedTotalExpCache()
  local isLevelUp = self.curExp + addExp >= self.curLevelTemplate.exp_cost and not DataCenter.TacticalChipManager:IsMaxLevel(self.curLv)
  if isLevelUp then
    self:FocusChipPart()
  else
    self:OutFocusChipPart()
  end
end

function TacticalWeaponSkillChipPage:FocusChipPart()
  if self.isFocus then
    return
  end
  self.isFocus = true
  if self.focusChipPartTimer then
    self.focusChipPartTimer:Stop()
    self.focusChipPartTimer = nil
  end
  local focusId = self.curLevelTemplate.level_focus
  self.chipSetupNodeMap[focusId].node:SetActive(true)
  self.part_detail_item_desc:SetLocalText(string.format(FOCUS_PART_NAME, focusId))
  self.focusChipPartTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.part_detail_item:SetActive(true)
    self.animator:Play(AnimationNames.DescOpen)
  end, CAMERA_MOVE_DURATION)
  DataCenter.LWSoundManager:PlaySound(62276, false)
end

function TacticalWeaponSkillChipPage:OutFocusChipPart()
  if not self.isFocus then
    return
  end
  self.isFocus = false
  if self.focusChipPartTimer then
    self.focusChipPartTimer:Stop()
    self.focusChipPartTimer = nil
  end
  self:RevertCameraFocus()
  self.animator:Play(AnimationNames.DescClose)
  self.focusChipPartTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.part_detail_item:SetActive(false)
  end, AnimationDuration.DescClose)
end

function TacticalWeaponSkillChipPage:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.usePropsList then
    return nil
  end
  local usePropsData = self.usePropsList[index]
  local item = loopScroll:NewListViewItem("TacticalChipItem")
  local script = self.propsListContent:GetComponent(item.gameObject.name, TacticalChipItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.propsListContent:AddComponent(TacticalChipItem, objectName)
  end
  script:SetLocalScaleXYZ(0.7, 0.7, 0.7)
  script:SetItemInfo(usePropsData)
  script:SetActive(true)
  return item
end

function TacticalWeaponSkillChipPage:CreateTabItem(index)
  return self:GameObjectInstantiateAsync(UIAssets.TacticalChipPlanTabItem, function(request)
    local go = request.gameObject
    if IsNull(go) then
      return
    end
    go.gameObject:SetActive(false)
    go.transform:SetParent(self.compTabRoot.transform)
    go.transform:Set_localScale(1, 1, 1)
    go.name = "TacticalChipPlanTabItem" .. index
    local cell = self.compTabRoot:AddComponent(TacticalChipPlanTabItem, go.name)
    local param = {}
    param.tabId = index
    param.title = index
    param.clickHandler = self.OnTabClick
    param.customHolder = self
    param.level = self.curLv
    cell:ReInit(param)
    cell:SetSelect(false)
    cell:BindUnlockVfx()
    local showTabLevel = DataCenter.TacticalChipManager:GetPlanUnlockLevel(1)
    cell:SetActive(showTabLevel <= self.curLv)
    table.insert(self.tabItemList, cell)
    if self.tabItemList and #self.tabItemList == TAB_COUNT and showTabLevel <= self.curLv then
      self:RefreshRedPoints()
      self.tabRootAni:Rebind()
      self.tabRootAni:Play(TabAnimationName)
    end
  end)
end

function TacticalWeaponSkillChipPage:CreateAttributeItem(index, data)
  return self:GameObjectInstantiateAsync(UIAssets.TacticalChipStatsAttriItem, function(request)
    local go = request.gameObject
    if IsNull(go) then
      return
    end
    go.gameObject:SetActive(true)
    go.transform:SetParent(self.attribute_list_node.transform)
    go.transform:Set_localScale(1, 1, 1)
    go.name = "TacticalChipStatsAttriItem" .. index
    local cell = self.attribute_list_node:AddComponent(TacticalChipStatsAttriItem, go.name)
    cell:SetData(data)
    table.insert(self.attributeItemList, cell)
  end)
end

function TacticalWeaponSkillChipPage:CreatePreOpenTipItemList()
  self.preOpenItemReqList = {}
  local dataList = DataCenter.TacticalChipManager:GetPreOpenDataList()
  if dataList and 0 < #dataList then
    for i, v in ipairs(dataList) do
      if v then
        self.preOpenItemReqList = self:CreatePreOpenTipItem(i, v)
      end
    end
  end
end

function TacticalWeaponSkillChipPage:CreatePreOpenTipItem(index, data)
  return self:GameObjectInstantiateAsync(UIAssets.TacticalChipOpenPreTipItem, function(request)
    local go = request.gameObject
    if IsNull(go) then
      return
    end
    go.gameObject:SetActive(true)
    go.transform:SetParent(self.compSystemOpenTipItemLayoutNode.transform)
    go.transform:Set_localScale(1, 1, 1)
    go.name = "preOpenTipItem" .. index
    local cell = self.compSystemOpenTipItemLayoutNode:AddComponent(TacticalChipOpenPreTipItem, go.name)
    cell:SetData(data)
    cell:SetOnClick(function(desc)
      self.systemOpenTipDescPanel:SetActive(true)
      self.systemOpenTipDetailDesc:SetLocalText(desc)
    end)
  end)
end

function TacticalWeaponSkillChipPage:PlayTabShowAni()
  for i, v in ipairs(self.tabItemList) do
    if v then
      v:SetActive(true)
    end
  end
  self.tabRootAni:Play(TabAnimationName)
end

function TacticalWeaponSkillChipPage:ForceRefreshTabUnlockStatus()
  for i, v in ipairs(self.tabItemList) do
    if v then
      v:ForceRefreshUnlockStatus()
    end
  end
end

function TacticalWeaponSkillChipPage:CheckTabUnlock()
  for i, v in ipairs(self.tabItemList) do
    if v then
      v:TryUnlock()
    end
  end
end

function TacticalWeaponSkillChipPage:PlayCombatPowerUpVfx(oldLv, newLv)
  if oldLv < newLv then
    self.powerVfxNode:PlayByOnce(VfxAssets.CombatUpgradeEffect_Big)
  end
end

function TacticalWeaponSkillChipPage:OnSceneLoadComplete()
  self:RegisterCinemachineNode()
  self:RegisterVfxNode()
end

function TacticalWeaponSkillChipPage:RegisterCinemachineNode()
  if not self.holder then
    return
  end
  for k, v in pairs(self.chipSetupNodeMap) do
    if v then
      v.node = self.holder:GetModelViewSceneNode(string.format(CAMERA_VIRTUAL_POS_NAME, k))
    end
  end
  self.toPlanViewPos = self.holder:GetModelViewSceneNode(TO_PLAN_POS_NODE)
  if self.toPlanViewPos then
    self.toPlanViewPos:SetActive(false)
  end
end

function TacticalWeaponSkillChipPage:RegisterVfxNode()
  if not self.holder then
    return
  end
  for k, v in pairs(self.chipSetupNodeMap) do
    if v then
      local vfxNode = self.holder:GetModelViewSceneNode(SceneVfxPaths[k])
      if vfxNode then
        v.vfxCpt = vfxNode:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
      end
      if v.vfxCpt == nil then
        Logger.LogError("not find partical cpt,  path" .. SceneVfxPaths[k])
      end
    end
  end
end

function TacticalWeaponSkillChipPage:PlayAirPartVfx()
  local focusId = self.curLevelTemplate.level_focus
  local setup = self.chipSetupNodeMap[focusId]
  if setup == nil then
    return
  end
  if setup.vfxCpt then
    for i = 0, setup.vfxCpt.Length - 1 do
      setup.vfxCpt[i]:Play()
    end
  end
  DataCenter.LWSoundManager:PlaySound(62277, false)
end

function TacticalWeaponSkillChipPage:RevertCameraFocus()
  for k, v in pairs(self.chipSetupNodeMap) do
    if v and v.node then
      v.node:SetActive(false)
    end
  end
end

function TacticalWeaponSkillChipPage:AddChipFuncUnlockTimer()
  if self.chipFuncUnlockTimer then
    return
  end
  self.chipFuncUnlockTimer = TimerManager:GetInstance():GetTimer(1, self.RefreshChipFuncUnlockTime, self, false, false, false)
  self.chipFuncUnlockTimer:Start()
end

function TacticalWeaponSkillChipPage:RemoveChipFuncUnlockTimer()
  if self.chipFuncUnlockTimer then
    self.chipFuncUnlockTimer:Stop()
    self.chipFuncUnlockTimer = nil
  end
end

function TacticalWeaponSkillChipPage:OnUsePropsBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalWeaponChipChooseFeed, id)
end

function TacticalWeaponSkillChipPage:OnTierInfoBtnClick()
  if self.curLevelTemplate then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalChipTierDisplay, self.curLevelTemplate.system_tier)
  end
end

function TacticalWeaponSkillChipPage:OnAutoSelectBtnClick()
  if DataCenter.TacticalChipManager:IsMaxLevel(self.curLv) then
    return
  end
  local addExp = DataCenter.TacticalChipManager:GenerateUpgradeFeedAuto()
  if 0 < addExp then
    self:RefreshFeedList()
    self:RefreshPreExpProgressForce()
    self:RefreshAttributeListPre()
    self:FocusChipPart()
  else
    UIUtil.ShowTipsId("battlesystem_error1")
    TacticalWeaponUtils.ShowSkillChipExpLackWindow()
  end
  self:RefreshBtnStatus()
end

function TacticalWeaponSkillChipPage:OnUpgradeBtnClick()
  local chips = DataCenter.TacticalChipManager:GetUpgradeFeedChipsCache()
  local goods = DataCenter.TacticalChipManager:GetUpgradeFeedGoodsCache()
  SFSNetwork.SendMessage(MsgDefines.TacticalChipUpgrade, chips, goods)
end

function TacticalWeaponSkillChipPage:OnTabClick(tabItem)
  local id = tabItem.tabId
  self.toPlanViewPos:SetActive(true)
  self.animator:Play(AnimationNames.Close)
  if self.toPlanViewTimer then
    self.toPlanViewTimer:Stop()
    self.toPlanViewTimer = nil
  end
  self.toPlanViewTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.holder:SelectPage(TacticalWeaponPageType.ChipPlan, id)
  end, PLAN_OPEN_WAIT_TIME)
end

function TacticalWeaponSkillChipPage:OnBtnStatsClick()
  if self.isUnFoldStats then
    self.animator:Play(AnimationNames.StatsClose)
  else
    self.animator:Play(AnimationNames.StatsOpen)
  end
  self.isUnFoldStats = not self.isUnFoldStats
end

function TacticalWeaponSkillChipPage:OnBtnSystemEnterClick()
  local functionUnlock = DataCenter.TWSkillChipManager:IsFunctionUnlock()
  if functionUnlock then
    return
  end
  local remainTime = DataCenter.TWSkillChipManager:GetSkillChipUnlockRemainTime()
  if remainTime <= 0 then
    SFSNetwork.SendMessage(MsgDefines.TWSkillChipFunctionUnlock)
  end
end

function TacticalWeaponSkillChipPage:OnBtnBoxPropsClick()
  local data = DataCenter.TWSkillChipManager:GetGuaranteedBoxData()
  if data then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWGuarantBox, {anim = true}, data.id)
  end
end

function TacticalWeaponSkillChipPage:OnBtnDetailClick()
  UIUtil.ShowIntro(Localization:GetString(170001), nil, Localization:GetString(141150))
end

function TacticalWeaponSkillChipPage:CheckFirstEnterSystemGuide()
  if DataCenter.LWGuideFlowManager.Runner:IsRun() then
    return
  end
  if not DataCenter.LWGuideFlowManager:ReadDone(4002) then
    DataCenter.LWGuideFlowManager.Runner:Run(4002)
  end
end

function TacticalWeaponSkillChipPage:CheckFirstChipPlanShowGuide()
  if DataCenter.LWGuideFlowManager.Runner:IsRun() then
    return
  end
  if not DataCenter.LWGuideFlowManager:ReadDone(4004) then
    DataCenter.LWGuideFlowManager.Runner:Run(4004)
  end
end

local function RefreshChipBoxProps(self)
  self.compBoxPropsBtnRedPoint:SetActive(TacticalWeaponUtils.GuarantBoxShowRedPoint())
end

TacticalWeaponSkillChipPage.OnCreate = OnCreate
TacticalWeaponSkillChipPage.OnDestroy = OnDestroy
TacticalWeaponSkillChipPage.OnEnable = OnEnable
TacticalWeaponSkillChipPage.OnDisable = OnDisable
TacticalWeaponSkillChipPage.OnAddListener = OnAddListener
TacticalWeaponSkillChipPage.OnRemoveListener = OnRemoveListener
TacticalWeaponSkillChipPage.ComponentDefine = ComponentDefine
TacticalWeaponSkillChipPage.DataDefine = DataDefine
TacticalWeaponSkillChipPage.ComponentDestroy = ComponentDestroy
TacticalWeaponSkillChipPage.DataDestroy = DataDestroy
TacticalWeaponSkillChipPage.SetData = SetData
TacticalWeaponSkillChipPage.RefreshChipBoxProps = RefreshChipBoxProps
return TacticalWeaponSkillChipPage
