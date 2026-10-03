local UIDecorationAdvanceUpgrade = BaseClass("UIDecorationAdvanceUpgrade", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIDesCell_New = require("UI.UIBuildUpgrade.Component.UIDesCell_New")
local UIDecorateItemCell = require("UI.UIBuildUpgrade.Component.UIDecorateProgressCell")
local ExpProgress = require("UI.UIBuildUpgrade.Component.DecoUpgradeProgress")
local UnlockStarTipPanel = require("UI.UIBuildUpgrade.Component.DecoUnlockStar")
local DecoUpgradePropIcon = require("UI.UIBuildUpgrade.Component.DecoUpgradePropIcon")
local SeasonCallbackInfo = require("UI.LWSeason.LWSeasonMain.Component.SeasonCallback.SeasonCallbackInfo")
local close_btn_path = "TopArea/CloseBtn"
local u_i_build_icon_path = "TopArea/UIBuild_icon"
local cur_level_text_path = "TopArea/BaseInfoArea/LevelInfo/CurLevelText"
local next_level_text_path = "TopArea/BaseInfoArea/LevelInfo/NextLevelText"
local add_dur_path = "TopArea/BaseInfoArea/LevelInfo/AddDur"
local max_img_path = "TopArea/BaseInfoArea/LevelInfo/MaxImg"
local next_lv_preview_btn_path = "TopArea/BaseInfoArea/LevelInfo/NextLvPreviewBtn"
local max_lv_tip_obj_path = "DecorateInfo/MaxLvTipObj"
local placed_title_path = "TopArea/BaseInfoArea/placedTitle"
local title_text_path = "TopArea/BaseInfoArea/titleText"
local desc_text_path = "TopArea/BaseInfoArea/DescText"
local info_path = "DecorateInfo/InfoScrollView/ViewPort/info"
local cant_use_glue_text_path = "DecorateInfo/CantUseGlueText"
local no_have_text_path = "DecorateInfo/NoHaveText"
local max_tip_path = "DecorateInfo/MaxLvTipObj"
local decorate_list_path = "DecorateInfo/CostArea/decorateList"
local level_up_btn_path = "DecorateInfo/LevelUpBtn"
local goto_btn_path = "TopArea/BaseInfoArea/GotoBtn"
local need_glue_text_path = "DecorateInfo/LevelUpBtn/Content/ItemContent/NeedGlueText"
local upgrade_progress_area_path = "DecorateInfo/UpgradeProgressArea"
local cost_area_path = "DecorateInfo/CostArea"
local info_btn_path = "TopArea/InfoBtn"
local unlock_star_info_area_path = "UnlockStarInfoArea"
local eff_ui_wurenji_shengji_trail_path = "Eff_ui_deco_shengji_trail"
local clock_area_obj_path = "ClockAreaObj"
local root_path = "TopArea/UIBuild_icon/Root"
local upgrade_info_icon_path = "TopArea/UIBuild_icon/UpgradeInfoIcon"
local bubble_tips_content_path = "DecorateInfo/LevelUpBtn/BubbleTipsContent"
local upgrade_path = "DecorateInfo/LevelUpBtn/Content/Upgrade"
local UISeasonCallbackInfoPath = "DecorateInfo/UISeasonCallbackInfo"
local to_build_btn_path = "DecorateInfo/ToBuildBtn"
local l_w_btn_info_path = "DecorateInfo/LW_Btn_Info"
local info_tips_path = "DecorateInfo/LW_Btn_Info/InfoTips"
local tip_close_btn_path = "DecorateInfo/LW_Btn_Info/InfoTips/TipCloseBtn"
local slot_path = "TopArea/UIBuild_icon/Root/PropIconSlotRoot/Slot%s"
local triggerLongPressTime = 0.5
local longPressInterval = 0.04
local longPressMinInterval = 0.03
local longPressIntervalAccTime = 1
local SHOW_PROP_ICON_INTERVAL = 0.5
local SEGMENT_COUNT = 20
local SHOW_TIP_WHEN_SINGLE_CLICK_COUNT = 3
local IS_CAN_REPEAT_SHOW_4_LONG_PRESS_TIP = false
local paths = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Vector3), SEGMENT_COUNT)

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  if self.upgradeIconAniObj then
    self.upgradeIconAniObj:SetActive(false)
  end
  if self.longPressTipObj then
    self.longPressTipObj:SetActive(false)
  end
  self.isAlreadyShowLongPress = false
  self.curSingleClickCount = 0
end

local function OnDisable(self)
  base.OnDisable(self)
  if self.upgradeIconAniObj then
    self.upgradeIconAniObj:SetActive(false)
  end
end

local function ComponentDefine(self)
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.closeBtn:SetOnClick(function()
    if self.closePanelFunc then
      self.closePanelFunc()
    end
  end)
  self.buildIcon = self:AddComponent(UIImage, u_i_build_icon_path)
  self.curLevelText = self:AddComponent(UIText, cur_level_text_path)
  self.nextLevelText = self:AddComponent(UIText, next_level_text_path)
  self.lvArrObj = self:AddComponent(UIBaseContainer, add_dur_path)
  self.maxImgObj = self:AddComponent(UIBaseContainer, max_img_path)
  self.placedTitle = self:AddComponent(UIText, placed_title_path)
  self.nameText = self:AddComponent(UIText, title_text_path)
  self.descText = self:AddComponent(UIText, desc_text_path)
  self.des_content = self:AddComponent(UIBaseContainer, info_path)
  self.cantUseGlueText = self:AddComponent(UIText, cant_use_glue_text_path)
  self.noHaveText = self:AddComponent(UIText, no_have_text_path)
  self.maxTip = self:AddComponent(UIText, max_tip_path)
  self.LevelUpBtn = self:AddComponent(UIButton, level_up_btn_path)
  self.LevelUpBtn:SetOnClick(function()
    self:OnLevelUpClick()
  end)
  self.GotoBtn = self:AddComponent(UIButton, goto_btn_path)
  self.UpLevelBtnNeedGlueText = self:AddComponent(UIText, need_glue_text_path)
  self.expProgress = self:AddComponent(ExpProgress, upgrade_progress_area_path)
  self.decorateList = self:AddComponent(UIScrollView, decorate_list_path)
  self.decorateList:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.decorateList:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.compMaxLvRemainingShow = self:AddComponent(UIBaseComponent, "DecorateInfo/MaxLvRemainingShow")
  self.textRemainingDesc = self:AddComponent(UITextMeshProUGUIEx, "DecorateInfo/MaxLvRemainingShow/ShowNum/RemainingDesc")
  self.textRemainingNum = self:AddComponent(UITextMeshProUGUIEx, "DecorateInfo/MaxLvRemainingShow/ShowNum/RemainingNum")
  self.scrollViewMaxLevelDecoration = self:AddComponent(UIScrollView, "DecorateInfo/MaxLvRemainingShow/MaxLvDecoration")
  self.scrollViewMaxLevelDecoration:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell_MaxDecoration(itemObj, index)
  end)
  self.scrollViewMaxLevelDecoration:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell_MaxDecoration(itemObj, index)
  end)
  self.GotoBtn:SetOnClick(function()
    self:OnClickGoto()
  end)
  self.nextLvPreviewBtn = self:AddComponent(UIButton, next_lv_preview_btn_path)
  self.nextLvPreviewBtn:SetOnClick(function()
    self:OpenNextLvPropertyPanel()
  end)
  self.bottomMaxTipObj = self:AddComponent(UIBaseContainer, max_lv_tip_obj_path)
  self.costAreaObj = self:AddComponent(UIBaseContainer, cost_area_path)
  self.InfoBtn = self:AddComponent(UIButton, info_btn_path)
  self.InfoBtn:SetOnClick(function()
    self:OnClickInfo()
  end)
  self.unlockStarInfoPanel = self:AddComponent(UnlockStarTipPanel, unlock_star_info_area_path)
  self.upgradeBallEffObj = self.transform:Find(eff_ui_wurenji_shengji_trail_path).gameObject
  self.upgradeBallEffObj:GameObjectCreatePool()
  self.blockClickAreaObj = self:AddComponent(UIBaseContainer, clock_area_obj_path)
  self.upgradeIconAniObj = self:AddComponent(UIBaseContainer, root_path)
  self.propIconObj = self.transform:Find(upgrade_info_icon_path).gameObject
  self.propIconObj:GameObjectCreatePool()
  self.longPressTipObj = self:AddComponent(UIBaseContainer, bubble_tips_content_path)
  self.upgradeBtnText = self:AddComponent(UIText, upgrade_path)
  self.toBuildBtn = self:AddComponent(UIButton, to_build_btn_path)
  self.toBuildBtn:SetOnClick(function()
    self:ClickToBuildBtn()
  end)
  self.moreInfoBtn = self:AddComponent(UIButton, l_w_btn_info_path)
  self.moreInfoBtn:SetOnClick(function()
    self:ClickMoreInfoBtn()
  end)
  self.moreInfoCloseBtn = self:AddComponent(UIButton, tip_close_btn_path)
  self.moreInfoCloseBtn:SetOnClick(function()
    self:ClickMoreInfoCloseBtn()
  end)
  self.moreInfoTipObj = self:AddComponent(UIBaseContainer, info_tips_path)
  self.propIconSlotList = {}
  for i = 1, 5 do
    local propIconPath = string.format(slot_path, i)
    local propIconSlot = self:AddComponent(UIBaseContainer, propIconPath)
    self.propIconSlotList[i] = propIconSlot
  end
  self.seasonCallbackInfo = self:AddComponent(SeasonCallbackInfo, UISeasonCallbackInfoPath)
  self.toBuildBtnTop = self:AddComponent(UIButton, "TopArea/BaseInfoArea/ToBuildBtnTop")
  self.toBuildBtnTop:SetOnClick(function()
    self:ClickToBuildBtn()
  end)
  self.btnLeftShortcutKey = self:AddComponent(UIButton, "ShortcutKeyRoot/LeftShortcutKey")
  self.btnLeftShortcutKey:SetOnClick(function()
    if self.OnBtnLeftShortcutKeyClick then
      self:OnBtnLeftShortcutKeyClick()
    end
  end)
  self.btnRightShortcutKey = self:AddComponent(UIButton, "ShortcutKeyRoot/RightShortcutKey")
  self.btnRightShortcutKey:SetOnClick(function()
    if self.OnBtnRightShortcutKeyClick then
      self:OnBtnRightShortcutKeyClick()
    end
  end)
  self.compShortcutKeyRoot = self:AddComponent(UIBaseContainer, "ShortcutKeyRoot")
  self.compLeftShortcutKeyRedPoint = self:AddComponent(UIBaseComponent, "ShortcutKeyRoot/LeftShortcutKey/LeftShortcutKeyRedPoint")
  self.compRightShortcutKeyRedPoint = self:AddComponent(UIBaseComponent, "ShortcutKeyRoot/RightShortcutKey/RightShortcutKeyRedPoint")
end

local function ComponentDestroy(self)
  self.unlockStarInfoPanel = nil
  self.upgradeBallEffObj:GameObjectRecycleAll()
  self.propIconObj:GameObjectRecycleAll()
  if self.longPressTipDisappearTimer then
    self.longPressTipDisappearTimer:Stop()
    self.longPressTipDisappearTimer = nil
  end
  self.propIconSlotList = nil
  self.toBuildBtnTop = nil
  self.btnLeftShortcutKey = nil
  self.btnRightShortcutKey = nil
  self.compShortcutKeyRoot = nil
  self.compLeftShortcutKeyRedPoint = nil
  self.compRightShortcutKeyRedPoint = nil
end

local function DataDefine(self)
  self.closePanelFunc = nil
  self.desCells = {}
  self.curUpgradeProgress = 0
  self.isLongPress = nil
  self.isClick = nil
  self.allTweenList = {}
  self.propIconTimerList = {}
  self.ballEffDelayRecycleList = {}
  self.maxProgressInfo = nil
  self.curSingleClickCount = 0
  self.isAlreadyShowLongPress = false
  self.isLockLevelUpMsg = false
end

local function DataDestroy(self)
  self.curUpgradeProgress = nil
  self.closePanelFunc = nil
  self.isLongPress = nil
  self.isClick = nil
  for _, v in ipairs(self.allTweenList) do
    v:Kill()
  end
  self.allTweenList = nil
  for _, v in ipairs(self.propIconTimerList) do
    if v then
      v:Stop()
    end
  end
  self.propIconTimerList = nil
  if self.showProgressEffTimer then
    self.showProgressEffTimer:Stop()
    self.showProgressEffTimer = nil
  end
  if self.showStarUnlockPanelTimer then
    self.showStarUnlockPanelTimer:Stop()
    self.showStarUnlockPanelTimer = nil
  end
  if self.upgradeIconDisappearTimer then
    self.upgradeIconDisappearTimer:Stop()
    self.upgradeIconDisappearTimer = nil
  end
  if self.showPropIconTimer then
    self.showPropIconTimer:Stop()
    self.showPropIconTimer = nil
  end
  for _, v in ipairs(self.ballEffDelayRecycleList) do
    v:Stop()
  end
  self.maxProgressInfo = nil
  self.curSingleClickCount = nil
  self.isAlreadyShowLongPress = nil
  if self.desCells then
    for _, v in ipairs(self.desCells) do
      v.inst:Destroy()
    end
  end
  self.desCells = nil
  self.isLockLevelUpMsg = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.BuildDecoProgressLevelUp, self.OnBuildProgressLevelUp)
  self:AddUIListener(EventId.BuildLevelUp, self.OnBuildProgressLevelUp)
  self:AddUIListener(EventId.BuildDecoNumChange, self.OnDecoNumUpdate)
  self:AddUIListener(EventId.DecoratorProgressUpgradeMessageOnReceive, self.OnDecoratorProgressUpgradeMessageOnReceive)
  self:AddUIListener(EventId.OnFinishHandleInitMsg, self.OnFinishHandleInitMsg)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.BuildDecoProgressLevelUp, self.OnBuildProgressLevelUp)
  self:RemoveUIListener(EventId.BuildLevelUp, self.OnBuildProgressLevelUp)
  self:RemoveUIListener(EventId.BuildDecoNumChange, self.OnDecoNumUpdate)
  self:RemoveUIListener(EventId.DecoratorProgressUpgradeMessageOnReceive, self.OnDecoratorProgressUpgradeMessageOnReceive)
  self:RemoveUIListener(EventId.OnFinishHandleInitMsg, self.OnFinishHandleInitMsg)
end

function UIDecorationAdvanceUpgrade:ReInit(param, closePanelFunc, refreshFromUpgrade)
  if closePanelFunc then
    self.closePanelFunc = closePanelFunc
  end
  if param == nil then
    return
  end
  self.param = param
  self.buildIcon:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(self.param.itemId, 1), DefaultImage)
  self.curLevelText:SetText(self.param.level)
  self.nextLevelText:SetText(self.param.level + 1)
  self.template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.param.itemId)
  self.baseLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.param.itemId, 1)
  self.curLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.param.itemId, self.param.level)
  self.maxCount = self.template.unlockBuildInfo[1].canBuildNun
  self.buildingDataNormal = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(self.param.itemId, false)
  self.progressGroupId = self.curLevelTemplate.decoGroupUpgradeBaseId
  self.maxLv = self.param.max_level or self.template.max_level
  self.isMaxLv = self.param.level >= self.maxLv
  if self.isMaxLv then
    local prevLv = self.param.level - 1
    local prevBuildingData = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.param.itemId, prevLv)
    if prevBuildingData then
      self.progressGroupId = prevBuildingData.decoGroupUpgradeBaseId
    end
  else
    self.maxProgressInfo = DataCenter.DecorationUpgradeTemplateManager:GetMaxProgressInfo(self.progressGroupId, self.param.level)
  end
  self.curUpgradeProgress = param.prodStatus or 0
  local listBuilds = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(self.param.itemId)
  self.placedTitle:SetText(Localization:GetString(310148) .. ": " .. #listBuilds .. "/" .. self.maxCount)
  self.nameText:SetLocalText(self.template.name)
  self.descText:SetLocalText(self.template.des)
  self:RefreshDecorate(refreshFromUpgrade)
  self:RefreshMaxLvAbout()
  self.unlockStarInfoPanel.gameObject:SetActive(false)
  self.blockClickAreaObj:SetActive(false)
  self:RefreshBtnState()
  if self.moreInfoTipObj then
    self.moreInfoTipObj:SetActive(false)
  end
  if self.seasonCallbackInfo then
    self.seasonCallbackInfo:TrySetItemById(SeasonCallbackType.Decoration, self.param.itemId)
  end
  self.baseBuildingIdList = param.baseBuildingIdList or {}
  self.curIndex = param.curIndex or 0
  self:InitShortcutKey(param.isShowShortCutKey)
  self.isLockLevelUpMsg = false
end

function UIDecorationAdvanceUpgrade:RefreshBtnState()
  if self.isMaxLv then
    return
  end
  local hasInCity = DataCenter.BuildManager:IsDecorationExistInCity(self.param.itemId)
  local showToBuild = not hasInCity
  self.toBuildBtn:SetActive(false)
  self.LevelUpBtn:SetActive(false)
  if showToBuild then
    self.toBuildBtn:SetActive(true)
  else
    self.LevelUpBtn:SetActive(true)
  end
  self:RefreshBtnText()
end

function UIDecorationAdvanceUpgrade:RefreshBtnText()
  if not self.curUpgradeProgress or not self.maxProgressInfo then
    return
  end
  local curMaxUpgradeProgress = self:GetCurCanUpgradeMaxProgress()
  local btnTextStr
  if curMaxUpgradeProgress <= 0 then
    btnTextStr = "100547"
    self.upgradeBtnText:SetLocalText(btnTextStr)
  else
    local isCanLevelUp = self.curUpgradeProgress + curMaxUpgradeProgress >= self.maxProgressInfo.stage_need
    btnTextStr = isCanLevelUp and "decoration_building_desc10" or "decoration_building_desc9"
    self.upgradeBtnText:SetLocalText(btnTextStr, curMaxUpgradeProgress)
  end
end

function UIDecorationAdvanceUpgrade:InitInfoDes(curProgress, refreshFromUpgrade)
  local buildingId = self.param.itemId
  local level = self.param.level
  local curMaxUpgradeProgress = self:GetCurCanUpgradeMaxProgress()
  local nextProgress = curProgress + curMaxUpgradeProgress
  local isShowAddDes = 0 < curMaxUpgradeProgress
  local paramList = BuildingUtils.GetDecorationProgressUpValue(buildingId, level, curProgress, level, nextProgress)
  for i = 1, #paramList do
    paramList[i].index = i
    paramList[i].isShowAddDes = isShowAddDes
  end
  self:GenDescInfo(paramList, refreshFromUpgrade)
end

function UIDecorationAdvanceUpgrade:GenDescInfo(paramList, refreshFromUpgrade)
  for i = 1, #paramList do
    local param = paramList[i]
    local decsCell = self.desCells[i]
    if decsCell and decsCell.model then
      decsCell.model:SetActive(true)
      decsCell.model:ReInit(param, refreshFromUpgrade)
    else
      local cell = {}
      cell.param = param
      table.insert(self.desCells, cell)
      cell.inst = self:GameObjectInstantiateAsync(UIAssets.DesCell_New, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.des_content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform:SetAsLastSibling()
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local temp = self.des_content:AddComponent(UIDesCell_New, nameStr)
        temp:ReInit(cell.param, refreshFromUpgrade)
        temp:SetActive(true)
        cell.model = temp
      end)
    end
  end
  for i = #paramList + 1, #self.desCells do
    if self.desCells[i].model then
      self.desCells[i].model:SetActive(false)
    end
  end
end

function UIDecorationAdvanceUpgrade:InitInfoDesMax(level, progress)
  local buildingId = self.param.itemId
  local paramList = BuildingUtils.GetDecorationProgressUpValue(buildingId, level, progress, level, progress)
  for i = 1, #paramList do
    paramList[i].index = i
    paramList[i].isShowAddDes = false
  end
  self:GenDescInfo(paramList)
end

function UIDecorationAdvanceUpgrade:RefreshDecorate(refreshFromUpgrade)
  self.cantUseGlueText:SetActive(self.baseLevelTemplate.convert_decorator_num <= 0 and not self.isMaxLv)
  if self.param.uuid == nil then
    self:RefreshDecoPreView()
  elseif self.param.level >= self.template.max_level then
    self:RefreshDecoMaxView(refreshFromUpgrade)
  else
    self:RefreshNormalView(refreshFromUpgrade)
  end
end

function UIDecorationAdvanceUpgrade:RefreshMaxLvAbout()
  self.maxImgObj:SetActive(self.isMaxLv)
  self.bottomMaxTipObj:SetActive(self.isMaxLv)
  self.lvArrObj:SetActive(not self.isMaxLv)
  self.nextLevelText:SetActive(not self.isMaxLv)
  self.LevelUpBtn:SetActive(not self.isMaxLv)
  self.costAreaObj:SetActive(not self.isMaxLv)
end

function UIDecorationAdvanceUpgrade:RefreshDecoPreView()
  self.noHaveText:SetActive(true)
  self.maxTip:SetActive(false)
  self.decorateList:SetActive(false)
  self.compMaxLvRemainingShow:SetActive(false)
  self.LevelUpBtn:SetActive(false)
  self.GotoBtn:SetActive(false)
  self.toBuildBtnTop:SetActive(false)
  self.placedTitle:SetActive(false)
  local setGray = BuildingUtils.IsDecoratorCantBuyDirectly(self.param.itemId)
  originPos = self.cantUseGlueText:GetAnchoredPosition()
  self.cantUseGlueText:SetAnchoredPositionXY(originPos.x, -291)
end

function UIDecorationAdvanceUpgrade:RefreshDecoMaxView(refreshFromUpgrade)
  local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.uuid)
  local hasInCity = DataCenter.BuildManager:IsDecorationExistInCity(self.param.itemId)
  local showToBuild = not hasInCity
  local showToUpgrade = hasInCity and buildingData.state == BuildingStateType.FoldUp and (self.buildingDataNormal == nil or buildingData.level > self.buildingDataNormal.level)
  self.GotoBtn:SetActive(not showToBuild and not showToUpgrade and hasInCity and self.maxCount == 1)
  self.toBuildBtnTop:SetActive(showToBuild)
  self.noHaveText:SetActive(false)
  self.decorateList:SetActive(false)
  self.compMaxLvRemainingShow:SetActive(true)
  self.maxTip:SetActive(true)
  self.LevelUpBtn:SetActive(false)
  self.placedTitle:SetActive(true)
  local originPos = self.cantUseGlueText:GetAnchoredPosition()
  self.cantUseGlueText:SetAnchoredPositionXY(originPos.x, -291)
  local prevLv = self.param.level - 1
  local preLvMaxProgressInfo = DataCenter.DecorationUpgradeTemplateManager:GetMaxProgressInfo(self.progressGroupId, prevLv)
  local curLvMaxProgress = preLvMaxProgressInfo.stage_need
  if self.expProgress then
    local function showUnlockStarTipFun(screenPos, progressData)
      self:ShowUnlockStarTipPanel(screenPos, progressData)
    end
    
    local param = {}
    param.buildingLv = prevLv
    param.groupId = self.progressGroupId
    param.curProgress = curLvMaxProgress
    param.stageMaxProgress = curLvMaxProgress
    param.previewProgress = curLvMaxProgress
    param.showUnlockStarTipFun = showUnlockStarTipFun
    param.isMaxLv = self.isMaxLv
    param.refreshFromUpgrade = refreshFromUpgrade
    self.expProgress:SetData(param)
  end
  self:InitInfoDesMax(prevLv, curLvMaxProgress)
  self:ClearScroll_MaxDecoration()
  self.upgradeCostInfoList = {}
  local param = {}
  param.uuid = self.param.uuid
  param.levelTemplate = self.baseLevelTemplate
  param.id = self.baseLevelTemplate.id
  param.itemId = self.baseLevelTemplate.id
  param.count = 0
  table.insert(self.upgradeCostInfoList, param)
  local count = #self.upgradeCostInfoList
  self.scrollViewMaxLevelDecoration:SetTotalCount(count)
  if 0 < count then
    self.scrollViewMaxLevelDecoration:RefillCells()
  end
  self.textRemainingDesc:SetLocalText(100100)
  local decorationNum = BuildingUtils.GetDecorateCountByLevel(self.param.itemId, 1)
  self.textRemainingNum:SetText(decorationNum)
end

function UIDecorationAdvanceUpgrade:RefreshNormalView(refreshFromUpgrade)
  self.curProgressInfo = DataCenter.DecorationUpgradeTemplateManager:GetLvAndStageInfoByProgress(self.progressGroupId, self.param.level, self.curUpgradeProgress, true)
  self.noHaveText:SetActive(false)
  self.decorateList:SetActive(true)
  self.compMaxLvRemainingShow:SetActive(false)
  self.maxTip:SetActive(false)
  self.placedTitle:SetActive(true)
  self.LevelUpBtn:SetActive(true)
  local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.uuid)
  local hasInCity = DataCenter.BuildManager:IsDecorationExistInCity(self.param.itemId)
  local showToBuild = not hasInCity
  local showToUpgrade = hasInCity and buildingData.state == BuildingStateType.FoldUp and (self.buildingDataNormal == nil or buildingData.level > self.buildingDataNormal.level)
  self.GotoBtn:SetActive(not showToBuild and not showToUpgrade and hasInCity and self.maxCount == 1)
  self.toBuildBtnTop:SetActive(showToBuild)
  local originPos = self.cantUseGlueText:GetAnchoredPosition()
  self.cantUseGlueText:SetAnchoredPositionXY(originPos.x, -231)
  local upgradeBtnOriginPos = self.LevelUpBtn:GetAnchoredPosition()
  if self.cantUseGlueText.gameObject.activeSelf then
    self.LevelUpBtn:SetAnchoredPositionXY(upgradeBtnOriginPos.x, -312)
  else
    self.LevelUpBtn:SetAnchoredPositionXY(upgradeBtnOriginPos.x, -297)
  end
  self:RefreshCostArea()
  self:InitInfoDes(self.curUpgradeProgress, refreshFromUpgrade)
  if self.expProgress then
    local function showUnlockStarTipFun(screenPos, progressData)
      self:ShowUnlockStarTipPanel(screenPos, progressData)
    end
    
    local curCanUpgradeNum = self:GetCurCanUpgradeMaxProgress()
    local previewProgress = self.curUpgradeProgress + curCanUpgradeNum
    local param = {}
    param.buildingLv = self.param.level
    param.groupId = self.progressGroupId
    param.curProgress = self.curUpgradeProgress
    param.stageMaxProgress = self.curProgressInfo and self.curProgressInfo.stage_need or 0
    param.previewProgress = previewProgress
    param.showUnlockStarTipFun = showUnlockStarTipFun
    param.isMaxLv = false
    param.refreshFromUpgrade = refreshFromUpgrade
    self.expProgress:SetData(param)
  end
end

function UIDecorationAdvanceUpgrade:GetRemainProgressToNextStage()
  if self.isMaxLv then
    return 0
  end
  if not self.curProgressInfo or not self.curUpgradeProgress then
    return 0
  end
  local ret = self.curProgressInfo.stage_need - self.curUpgradeProgress
  return math.max(ret, 0)
end

function UIDecorationAdvanceUpgrade:GetCurCanUpgradeMaxProgress()
  if not self.curProgressInfo or not self.upgradeCostInfoList then
    return 0
  end
  local lastData = self.upgradeCostInfoList[#self.upgradeCostInfoList]
  if not lastData then
    return 0
  end
  local remainProgressToNextStage = self:GetRemainProgressToNextStage()
  local singleUpgradeCost = self.curProgressInfo.cost_item
  local curCanUpgradeNum = lastData.count // singleUpgradeCost
  curCanUpgradeNum = math.min(curCanUpgradeNum, remainProgressToNextStage)
  return curCanUpgradeNum
end

function UIDecorationAdvanceUpgrade:ShowUnlockStarTipPanel(position, progressData)
  if not self.unlockStarInfoPanel then
    return
  end
  self.unlockStarInfoPanel:SetData(position, self.curUpgradeProgress, progressData, self.isMaxLv)
  PostEventLog.Track(PostEventLog.Defines.DecoSplitUpgradeClickTips, {
    buildingid = tostring(self.param.itemId),
    level = tonumber(progressData.level),
    progress = tostring(progressData.progressIndex)
  })
end

function UIDecorationAdvanceUpgrade:RefreshCostArea()
  self:ClearScroll()
  self.upgradeCostInfoList = {}
  self.upLevelScarceInfos = BuildingUtils.GetDecorateUpLevelBuilds(self.param)
  if not self.upLevelScarceInfos or table.count(self.upLevelScarceInfos) <= 0 then
    return
  end
  local remainProgressToNextStage = self:GetRemainProgressToNextStage()
  local remainCostItemToNextStage = remainProgressToNextStage * self.curProgressInfo.cost_item
  if self.upLevelScarceInfos and table.count(self.upLevelScarceInfos) > 0 then
    local param = {}
    param.uuid = self.param.uuid
    param.levelTemplate = self.baseLevelTemplate
    param.id = self.baseLevelTemplate.id
    param.itemId = self.baseLevelTemplate.id
    param.count = 0
    param.nextScore = remainCostItemToNextStage
    param.singleUpgradeCost = self.curProgressInfo.cost_item
    for k, v in pairs(self.upLevelScarceInfos) do
      param.count = param.count + v.count
    end
    table.insert(self.upgradeCostInfoList, param)
  end
  local count = #self.upgradeCostInfoList
  self.decorateList:SetTotalCount(count)
  if 0 < count then
    self.decorateList:RefillCells()
  end
end

function UIDecorationAdvanceUpgrade:AddDesCell(param, refreshFromUpgrade)
  local cell = {}
  cell.param = param
  table.insert(self.desCells, cell)
  cell.inst = self:GameObjectInstantiateAsync(UIAssets.DesCell_New, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.des_content.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.transform:SetAsLastSibling()
    local nameStr = tostring(NameCount)
    go.name = nameStr
    NameCount = NameCount + 1
    local temp = self.des_content:AddComponent(UIDesCell_New, nameStr)
    temp:ReInit(cell.param, refreshFromUpgrade)
    cell.model = temp
  end)
end

function UIDecorationAdvanceUpgrade:GetLevelUpValue(template, level)
  local temp, temp1
  local paramList = {}
  if level < (self.param.max_level or template.max_level) then
    local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.param.itemId, level)
    local nextLevelTemp
    if level < (self.param.max_level or template.max_level) then
      nextLevelTemp = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.param.itemId, level + 1)
    end
    local param
    for id, value in pairs(nextLevelTemp.building_effect_last) do
      temp, temp1 = WorkerUtil.GetEffectText(id, value, true)
      param = {}
      param.effectId = id
      param.name = temp
      param.addValue = temp1
      if levelTemplate and levelTemplate.building_effect_last[id] then
        temp, temp1 = WorkerUtil.GetEffectText(id, levelTemplate.building_effect_last[id], true)
        param.curValue = temp1
      else
        param.curValue = 0
      end
      table.insert(paramList, param)
    end
  elseif level == (self.param.max_level or template.max_level) then
    local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.param.itemId, level)
    local param
    for id, value in pairs(levelTemplate.building_effect_last) do
      temp, temp1 = WorkerUtil.GetEffectText(id, value, true)
      param = {}
      param.name = temp
      param.curValue = temp1
      table.insert(paramList, param)
    end
  end
  return paramList
end

function UIDecorationAdvanceUpgrade:ClearScroll()
  self.decorateList:ClearCells()
  self.decorateList:RemoveComponents(UIDecorateItemCell)
end

function UIDecorationAdvanceUpgrade:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local item = self.decorateList:AddComponent(UIDecorateItemCell, itemObj)
  item:ReInit(self.upgradeCostInfoList[index], true)
end

function UIDecorationAdvanceUpgrade:OnDeleteCell(itemObj, index)
  self.decorateList:RemoveComponent(itemObj.name, UIDecorateItemCell)
end

function UIDecorationAdvanceUpgrade:OnCreateCell_MaxDecoration(itemObj, index)
  itemObj.name = tostring(index)
  local item = self.scrollViewMaxLevelDecoration:AddComponent(UIDecorateItemCell, itemObj)
  item:ReInit(self.upgradeCostInfoList[index], false)
end

function UIDecorationAdvanceUpgrade:OnDeleteCell_MaxDecoration(itemObj, index)
  self.scrollViewMaxLevelDecoration:RemoveComponent(itemObj.name, UIDecorateItemCell)
end

function UIDecorationAdvanceUpgrade:ClearScroll_MaxDecoration()
  self.scrollViewMaxLevelDecoration:ClearCells()
  self.scrollViewMaxLevelDecoration:RemoveComponents(UIDecorateItemCell)
end

function UIDecorationAdvanceUpgrade:ToBuild()
  local curScene = CS.SceneManager.CurrSceneID
  local cacheParam = self.param
  if curScene == SceneManagerSceneID.City then
    local point = BuildingUtils.GetPointByBuildCanPut(self.param.itemId, SceneUtils.WorldToTileIndex(CS.SceneManager.World.CurTarget))
    BuildingUtils.ShowPutBuild(self.param.itemId, PlaceBuildType.Replace, self.param.uuid, point, nil, UIWindowNames.UIBuildUpgrade)
    GoToUtil.CloseAllWindows()
  elseif curScene == SceneManagerSceneID.World then
    SceneUtils.ChangeToCity(function()
      local point = BuildingUtils.GetPointByBuildCanPut(cacheParam.itemId, SceneUtils.WorldToTileIndex(CS.SceneManager.World.CurTarget))
      BuildingUtils.ShowPutBuild(cacheParam.itemId, PlaceBuildType.Replace, cacheParam.uuid, point, nil, UIWindowNames.UIBuildUpgrade)
    end)
  end
end

function UIDecorationAdvanceUpgrade:OnClickGoto()
  if self.param ~= nil and self.param.uuid ~= nil then
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.uuid)
    if buildData ~= nil then
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(buildData.pointId, ForceChangeScene.City), CS.SceneManager.World.InitZoom, nil, function()
        if buildData then
          local world = CS.SceneManager.World
          if IsNull(world) then
            return
          end
          local cityObj = world:GetBuildingByPoint(buildData.pointId)
          if IsNull(cityObj) then
            return
          end
          cityObj:ChangeMove()
        end
      end)
    end
  end
end

function UIDecorationAdvanceUpgrade:OnLevelUpClick(isLongPress)
  if self.isLockLevelUpMsg ~= nil and self.isLockLevelUpMsg == true then
    return
  end
  if isLongPress and self.maxProgressInfo then
    local isLastProgressUpgrade = self.curUpgradeProgress == self.maxProgressInfo.stage_need - 1
    if isLastProgressUpgrade then
      self:BreakLongPress()
      return
    end
  end
  if isLongPress and self.curProgressInfo then
    local isLastProgressUpgrade = self.curUpgradeProgress == self.curProgressInfo.stage_need
    if isLastProgressUpgrade then
      self:BreakLongPress()
      return
    end
  end
  if not self.upgradeCostInfoList then
    return
  end
  local lastData = self.upgradeCostInfoList[#self.upgradeCostInfoList]
  local remainProgressToNextStage = self:GetRemainProgressToNextStage()
  local curCanUpgradeNum = self:GetCurCanUpgradeMaxProgress()
  if 0 < curCanUpgradeNum then
    SFSNetwork.SendMessage(MsgDefines.DecoratorProgressUpgradeMessage, self.param.uuid, curCanUpgradeNum)
    self.isLockLevelUpMsg = true
  else
    self:BreakLongPress()
    local remainCostItemToNextStage = remainProgressToNextStage * self.curProgressInfo.cost_item
    local needCount = remainCostItemToNextStage - lastData.count
    LWResourceLackUtil:GotoBuildDecorationResLack(self.param.uuid, needCount)
  end
  if not isLongPress then
    self.curSingleClickCount = self.curSingleClickCount + 1
    self:CheckShowLongPressTip()
  else
    self.curSingleClickCount = 0
  end
end

function UIDecorationAdvanceUpgrade:CheckShowLongPressTip()
end

function UIDecorationAdvanceUpgrade:OnBuildProgressLevelUp(buildData)
  if buildData.uuid ~= self.param.uuid then
    return
  end
  local data = DataCenter.BuildManager:GetBuildingDataByUuid(buildData.uuid)
  self:ReInit(data, nil, true)
  local oldLevel = buildData.oldLevel or -1
  local oldProgress = buildData.oldProdStatus or -1
  local newProgress = buildData.newProdStatus or -1
  local newLevel = buildData.newLevel or -1
  if self.isMaxLv then
    newLevel = self.param.level
  end
  if oldLevel < newLevel then
    self:ShowDecoLevelUpPanel(oldLevel, oldProgress, newLevel, newProgress)
  else
    local newProgressInfo = DataCenter.DecorationUpgradeTemplateManager:GetLvAndStageInfoByProgress(self.progressGroupId, self.param.level, newProgress, true)
    local oldProgressInfo = DataCenter.DecorationUpgradeTemplateManager:GetLvAndStageInfoByProgress(self.progressGroupId, self.param.level, oldProgress, true)
    local newProgressIndex = newProgressInfo and (newProgressInfo.progressIndex or -1)
    local oldProgressIndex = oldProgressInfo and (oldProgressInfo.progressIndex or -1)
    if newProgressIndex > oldProgressIndex then
      self:ShowUnlockStageStarPanel(oldProgress, newProgress)
    end
  end
  local genBallCount = 1
  if not self.isLongPress then
    genBallCount = 3
  end
  for i = 1, genBallCount do
    self:PlayExpBallFly()
  end
  if self.showProgressEffTimer == nil then
    Logger.LogInfo("[deco]start delay")
    self.showProgressEffTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.expProgress:ShowUpgradeEff()
      self.showProgressEffTimer = nil
    end, 1)
  end
  if not self.showPropIconTimer then
    self.showPropIconTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:ShowPropIconFlyEff(oldProgress, newProgress)
      self.showPropIconTimer = nil
    end, SHOW_PROP_ICON_INTERVAL)
  end
end

function UIDecorationAdvanceUpgrade:PlayExpBallFly()
  local ballEff = self.upgradeBallEffObj:GameObjectSpawn(self.transform)
  local startPos = self.LevelUpBtn.transform.position + Vector3.New(math.random(-50, 50), math.random(-20, 20), 0)
  local destPos = self.expProgress.transform.position + Vector3.New(1, 0, 0) * math.random(-50, 50)
  local randomSign = math.random(0, 1) == 0 and -1 or 1
  local controlPos = (startPos + destPos) * 0.5 + Vector3.New(1, 0, 0) * math.random(100, 350) * randomSign
  ballEff.transform.position = startPos
  local pathVec = self:Bezier2Path(startPos, controlPos, destPos)
  local randomTime = math.random(8, 10) * 0.1
  local pathTween = ballEff.transform:DOPath(pathVec, randomTime):SetEase(CS.DG.Tweening.Ease.InQuad)
  pathTween:OnComplete(function()
    pathTween = nil
    local cycleDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
      ballEff:GameObjectRecycle()
    end, 0.3)
    table.insert(self.ballEffDelayRecycleList, cycleDelayTimer)
  end)
  table.insert(self.allTweenList, pathTween)
end

function UIDecorationAdvanceUpgrade:Bezier2Path(startPos, controlPos, endPos)
  for i = 1, SEGMENT_COUNT do
    local t = i / SEGMENT_COUNT
    local pixel = self:CalculateCubicBezierPointFor2C(t, startPos, controlPos, endPos)
    paths[i - 1] = pixel
  end
  return paths
end

function UIDecorationAdvanceUpgrade:CalculateCubicBezierPointFor2C(t, p0, p1, p2)
  local u = 1 - t
  local tt = t * t
  local uu = u * u
  local p = uu * p0
  p = p + 2 * u * t * p1
  p = p + tt * p2
  return p
end

function UIDecorationAdvanceUpgrade:ShowUnlockStageStarPanel(oldProgress, newProgress)
  self:BreakLongPress()
  self.blockClickAreaObj:SetActive(true)
  self.showStarUnlockPanelTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.blockClickAreaObj:SetActive(false)
    local data = {}
    data.buildingId = self.param.itemId
    data.level = self.param.level
    data.fromProgress = oldProgress
    data.toProgress = newProgress
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildDecoUnlockStar, {anim = true}, data)
  end, 1.5)
end

function UIDecorationAdvanceUpgrade:ShowDecoLevelUpPanel(oldLevel, oldProgress, newLevel, newProgress)
  self.blockClickAreaObj:SetActive(true)
  self.showStarUnlockPanelTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.blockClickAreaObj:SetActive(false)
    local data = {}
    data.buildingId = self.param.itemId
    data.oldLevel = oldLevel
    data.oldProgress = oldProgress
    data.newLevel = newLevel
    data.newProgress = newProgress
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildDecoUpgradeSuccess, {anim = true}, data)
  end, 1.5)
end

function UIDecorationAdvanceUpgrade:OnDecoNumUpdate()
  self:RefreshDecorate()
  self:RefreshBtnState()
end

function UIDecorationAdvanceUpgrade:OpenNextLvPropertyPanel()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildDecoratePropPreview, {anim = true}, self.param)
end

function UIDecorationAdvanceUpgrade:OnClickInfo()
  local param = {}
  param.baseBuildingId = self.param.itemId
  param.alignObject = self.InfoBtn
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWDecorationBookProperty, {anim = false}, param)
end

function UIDecorationAdvanceUpgrade:OnPointerDown()
  self.isClick = true
  self.lastTime = Time.time
end

function UIDecorationAdvanceUpgrade:OnPointerUp()
  self:OnLevelUpClick()
end

function UIDecorationAdvanceUpgrade:BreakLongPress()
end

function UIDecorationAdvanceUpgrade:CheckPressInterval()
  if self.lastTime == nil then
    return
  end
  local checkIntervalTime = Time.time - self.lastTime
  if not self.isLongPress then
    if checkIntervalTime < triggerLongPressTime then
      return
    end
    self.lastTime = Time.time
    self.startPressTime = Time.time
    self.isLongPress = true
    self.isClick = false
  end
  local curPressTime = Time.time - self.startPressTime
  local DynamicCheckInterval = Mathf.Lerp(longPressInterval, longPressMinInterval, Mathf.Clamp01(curPressTime / longPressIntervalAccTime))
  if checkIntervalTime < DynamicCheckInterval then
    return
  end
  self.lastTime = Time.time
  self:OnLevelUpClick(true)
end

function UIDecorationAdvanceUpgrade:ShowPropIconFlyEff(oldProgress, newProgress)
  self.upgradeIconAniObj:SetActive(true)
  if self.upgradeIconDisappearTimer then
    self.upgradeIconDisappearTimer:Stop()
  end
  self.upgradeIconDisappearTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.upgradeIconAniObj:SetActive(false)
  end, 2)
  local buildingId = self.param.itemId
  local level = self.param.level
  local addPropInfo = BuildingUtils.GetDecorationProgressUpValue(buildingId, level, oldProgress, level, newProgress)
  local propIndex = math.random(1, 5)
  for _, v in ipairs(addPropInfo) do
    if not v.changeNumVal ~= 0 and v.changeNumVal ~= 0 then
      local propSlot = self.propIconSlotList[propIndex]
      propIndex = math.modf(propIndex + 1, table.count(self.propIconSlotList))
      propIndex = Mathf.Clamp(propIndex, 1, 5)
      propSlot = propSlot or self.upgradeIconAniObj.transform
      local iconObj = self.propIconObj:GameObjectSpawn(propSlot.transform)
      iconObj.transform:Set_localPosition(0, 0, 0)
      local index = NameCount
      iconObj.name = index
      local propIcon = propSlot:AddComponent(DecoUpgradePropIcon, iconObj.name)
      propIcon:ReInit(v)
      local iconDisappearTimer = TimerManager:GetInstance():DelayInvoke(function()
        propIcon = nil
        iconObj:GameObjectRecycle()
        if self.propIconTimerList and table.containsKey(self.propIconTimerList, index) then
          self.propIconTimerList[index] = nil
        end
      end, 1)
      self.propIconTimerList[index] = iconDisappearTimer
      NameCount = NameCount + 1
    end
  end
end

function UIDecorationAdvanceUpgrade:ClickToBuildBtn()
  local curScene = CS.SceneManager.CurrSceneID
  if curScene == SceneManagerSceneID.City then
    local point = BuildingUtils.GetPointByBuildCanPut(self.param.itemId, SceneUtils.WorldToTileIndex(CS.SceneManager.World.CurTarget))
    BuildingUtils.ShowPutBuild(self.param.itemId, PlaceBuildType.Replace, self.param.uuid, point, nil, UIWindowNames.UIBuildUpgrade)
    GoToUtil.CloseAllWindows()
  elseif curScene == SceneManagerSceneID.World then
    SceneUtils.ChangeToCity(function()
      local point = BuildingUtils.GetPointByBuildCanPut(self.param.itemId, SceneUtils.WorldToTileIndex(CS.SceneManager.World.CurTarget))
      BuildingUtils.ShowPutBuild(self.param.itemId, PlaceBuildType.Replace, self.param.uuid, point, nil, UIWindowNames.UIBuildUpgrade)
    end)
  end
end

function UIDecorationAdvanceUpgrade:GetCurUpgradeState()
  return 1
end

function UIDecorationAdvanceUpgrade:ClickMoreInfoBtn()
  if not self.moreInfoTipObj then
    return
  end
  self.moreInfoTipObj:SetActive(not self.moreInfoTipObj.activeSelf)
end

function UIDecorationAdvanceUpgrade:ClickMoreInfoCloseBtn()
  if not self.moreInfoTipObj then
    return
  end
  self.moreInfoTipObj:SetActive(false)
end

function UIDecorationAdvanceUpgrade:InitShortcutKey(isShowShortCutKey)
  self.compShortcutKeyRoot:SetActive(isShowShortCutKey)
  if not isShowShortCutKey then
    return
  end
  self:RefreshShortcutKeyState()
  self:RefreshShortcutKeyRedPoint()
end

function UIDecorationAdvanceUpgrade:RefreshShortcutKeyState()
  self.btnLeftShortcutKey:SetActive(self.curIndex ~= 1)
  self.btnRightShortcutKey:SetActive(self.curIndex ~= #self.baseBuildingIdList)
end

function UIDecorationAdvanceUpgrade:RefreshShortcutKeyRedPoint()
  local leftCurIndex = math.max(self.curIndex - 1, 1)
  local leftBaseBuildingId = self.baseBuildingIdList[leftCurIndex]
  local isShowLeftRedPoint = self:IsShowRedPoint(leftBaseBuildingId)
  self.compLeftShortcutKeyRedPoint:SetActive(isShowLeftRedPoint)
  local rightCurIndex = math.min(self.curIndex + 1, #self.baseBuildingIdList)
  local rightBaseBuildingId = self.baseBuildingIdList[rightCurIndex]
  local isShowRightRedPoint = self:IsShowRedPoint(rightBaseBuildingId)
  self.compRightShortcutKeyRedPoint:SetActive(isShowRightRedPoint)
end

function UIDecorationAdvanceUpgrade:IsShowRedPoint(baseBuildingId)
  local hasBuilding = DataCenter.BuildManager:HasBuilding(baseBuildingId, true)
  if not hasBuilding then
    return false
  end
  local buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(baseBuildingId, true)
  local buildDataExist = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(baseBuildingId, false)
  local isFoldUp = buildData.state == BuildingStateType.FoldUp and (buildDataExist == nil or buildData.level > buildDataExist.level)
  if isFoldUp then
    return true
  end
  local baseBuildData = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(baseBuildingId)
  local lvTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
  if not (lvTemplate and lvTemplate.decoGroupUpgradeBaseId) or lvTemplate.decoGroupUpgradeBaseId < 0 then
    return
  end
  local groupId = lvTemplate.decoGroupUpgradeBaseId
  local maxProgressInfo = DataCenter.DecorationUpgradeTemplateManager:GetMaxProgressInfo(groupId, buildData.level)
  if not maxProgressInfo then
    return
  end
  local curProgress = buildData.prodStatus or 0
  local curProgressInfo = DataCenter.DecorationUpgradeTemplateManager:GetLvAndStageInfoByProgress(groupId, buildData.level, curProgress)
  if not curProgressInfo then
    return
  end
  local isFoldUp = buildData.state == BuildingStateType.FoldUp
  local upgradeCost = toInt(curProgressInfo.cost_item) or 0
  local hasCount, needCount, needCountWithoutGlue
  hasCount, needCountWithoutGlue = DataCenter.BuildManager:IsCanUpgradeDecoration(buildData.itemId, buildData.level, false)
  if isFoldUp then
    return true
  elseif upgradeCost <= hasCount and buildData.level < baseBuildData.max_level then
    return true
  end
  return false
end

function UIDecorationAdvanceUpgrade:OnBtnLeftShortcutKeyClick()
  if table.IsNullOrEmpty(self.baseBuildingIdList) then
    return
  end
  self.curIndex = math.max(self.curIndex - 1, 1)
  self:RefreshShortcutKeyState()
  self:RefreshShortcutKeyRedPoint()
  EventManager:GetInstance():Broadcast(EventId.DecorationViewLeftAndRightShortcutKey, 1)
end

function UIDecorationAdvanceUpgrade:OnBtnRightShortcutKeyClick()
  if table.IsNullOrEmpty(self.baseBuildingIdList) then
    return
  end
  self.curIndex = math.min(self.curIndex + 1, #self.baseBuildingIdList)
  self:RefreshShortcutKeyState()
  self:RefreshShortcutKeyRedPoint()
  EventManager:GetInstance():Broadcast(EventId.DecorationViewLeftAndRightShortcutKey, 2)
end

function UIDecorationAdvanceUpgrade:OnDecoratorProgressUpgradeMessageOnReceive()
  self.isLockLevelUpMsg = false
end

function UIDecorationAdvanceUpgrade:OnFinishHandleInitMsg()
  self.isLockLevelUpMsg = false
end

UIDecorationAdvanceUpgrade.OnCreate = OnCreate
UIDecorationAdvanceUpgrade.OnDestroy = OnDestroy
UIDecorationAdvanceUpgrade.OnEnable = OnEnable
UIDecorationAdvanceUpgrade.OnDisable = OnDisable
UIDecorationAdvanceUpgrade.ComponentDefine = ComponentDefine
UIDecorationAdvanceUpgrade.ComponentDestroy = ComponentDestroy
UIDecorationAdvanceUpgrade.DataDefine = DataDefine
UIDecorationAdvanceUpgrade.DataDestroy = DataDestroy
UIDecorationAdvanceUpgrade.OnAddListener = OnAddListener
UIDecorationAdvanceUpgrade.OnRemoveListener = OnRemoveListener
return UIDecorationAdvanceUpgrade
