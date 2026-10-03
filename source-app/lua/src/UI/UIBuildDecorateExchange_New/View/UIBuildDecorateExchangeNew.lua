local UIBuildDecorateExchangeNew = BaseClass("UIBuildDecorateExchangeNew", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "panel"
local close_btn_path = "MiddleBg/CloseBtn"
local title_text_path = "MiddleBg/Common_img_title/titleText"
local tips1_path = "MiddleBg/Content/BaseInfo/Tips1"
local item_count_path = "MiddleBg/Content/BaseInfo/IconContent/ItemIcon/ItemCount"
local decorator_count_path = "MiddleBg/Content/BaseInfo/IconContent/DecoratorIcon/DecoratorCount"
local decorator_icon_path = "MiddleBg/Content/BaseInfo/IconContent/DecoratorIcon"
local next_stage_btn_path = "MiddleBg/Content/BatchSelectArea/NextStageBtn"
local next_level_btn_path = "MiddleBg/Content/BatchSelectArea/NextLevelBtn"
local dec_btn_path = "MiddleBg/Content/InfoInput/DecBtn"
local add_btn_path = "MiddleBg/Content/InfoInput/AddBtn"
local top_btn_path = "MiddleBg/Content/InfoInput/TopBtn"
local exchange_btn_path = "MiddleBg/ExchangeBtn"
local slider_path = "MiddleBg/Content/InfoInput/Slider"
local tips2_path = "MiddleBg/Content/Tips2"
local over_max_tips_path = "MiddleBg/Content/OverMax/OverMaxTips"
local next_stage_text_path = "MiddleBg/Content/ExchangeTextInfo/NextStageText"
local next_level_text_path = "MiddleBg/Content/ExchangeTextInfo/NextLevelText"
local batch_select_area_path = "MiddleBg/Content/BatchSelectArea"
local have_item_text_path = "MiddleBg/Content/InfoInput/HaveItemText"
local input_area_path = "MiddleBg/Content/InfoInput/TextBg/InputArea"
local over_max_bubble_path = "MiddleBg/Content/InfoInput/Slider/HandleSlideArea/Handle/OverMaxBubble"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.data = self:GetUserData()
  self.param = self.data.buildingData
  self.haveNum = self.data.haveNum or 0
  self:Refresh()
  if self.param and self.param.itemId then
    PostEventLog.Track(PostEventLog.Defines.OpenDecoConvertPanel, {
      buildingid = self.param.itemId
    })
  end
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.panelCloseBtn = self:AddComponent(UIButton, panel_path)
  self.panelCloseBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.titleText = self:AddComponent(UIText, title_text_path)
  self.tip1Text = self:AddComponent(UIText, tips1_path)
  self.exchangeItemNumText = self:AddComponent(UIText, item_count_path)
  self.targetDecoItemNumText = self:AddComponent(UIText, decorator_count_path)
  self.targetDecoItemImg = self:AddComponent(UIImage, decorator_icon_path)
  self.selectNextStageBtn = self:AddComponent(UIButton, next_stage_btn_path)
  self.selectNextStageBtn:SetOnClick(function()
    self:OnClickUpgradeOneStage()
  end)
  self.selectNextLevelBtn = self:AddComponent(UIButton, next_level_btn_path)
  self.selectNextLevelBtn:SetOnClick(function()
    self:OnClickUpgradeOneLevel()
  end)
  self.decBtn = self:AddComponent(UIButton, dec_btn_path)
  self.decBtn:SetOnClick(function()
    self:OnClickDecBtn()
  end)
  self.addBtn = self:AddComponent(UIButton, add_btn_path)
  self.addBtn:SetOnClick(function()
    self:OnClickAddBtn()
  end)
  self.topBtn = self:AddComponent(UIButton, top_btn_path)
  self.topBtn:SetOnClick(function()
    self:OnClickSelectMaxBtn()
  end)
  self.exchangeBtn = self:AddComponent(UIButton, exchange_btn_path)
  self.exchangeBtn:SetOnClick(function()
    self:OnClickExchangeBtn()
  end)
  self.countSlider = self:AddComponent(UISlider, slider_path)
  self.countSlider:SetOnValueChanged(function(value)
    self:OnSliderValChange(value)
  end)
  self.tips2Text = self:AddComponent(UIText, tips2_path)
  self.nextStageCostText = self:AddComponent(UIText, next_stage_text_path)
  self.nextLevelCostText = self:AddComponent(UIText, next_level_text_path)
  self.batchSelectAreObj = self:AddComponent(UIBaseContainer, batch_select_area_path)
  self.haveItemNumText = self:AddComponent(UIText, have_item_text_path)
  self.selectNumInputText = self:AddComponent(UIInput, input_area_path)
  self.selectNumInputText:SetOnEndEdit(function(value)
    self:OnInputEnd(value)
  end)
  self.overMaxTips = self:AddComponent(UIText, over_max_tips_path)
  self.overMaxBubble = self:AddComponent(UIBaseComponent, over_max_bubble_path)
end

local function ComponentDestroy(self)
  self.overMaxTips = nil
  self.overMaxBubble = nil
end

local function DataDefine(self)
  self.curSelectNum = 0
  self.haveGlueCount = 0
  self.curMaxExchangeCount = 0
  self.needDecoNumToNextLevel = 0
  self.needExchangeNumToNextStage = 0
  self.needExchangeNumToNextLevel = 0
  self.needDecoNumToMaxLevel = 0
end

local function DataDestroy(self)
  self.curSelectNum = nil
  self.haveGlueCount = nil
  self.curMaxExchangeCount = nil
  self.needExchangeNumToNextStage = nil
  self.needExchangeNumToNextLevel = nil
  self.needDecoNumToMaxLevel = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.BuildDecoNumChange, self.CloseWindow)
  self:AddUIListener(EventId.UpdateGiftPackData, self.Refresh)
  self:AddUIListener(EventId.RefreshItems, self.Refresh)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.BuildDecoNumChange, self.CloseWindow)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.Refresh)
  self:RemoveUIListener(EventId.RefreshItems, self.Refresh)
end

function UIBuildDecorateExchangeNew:Refresh()
  self.curLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.param.itemId, self.param.level)
  local oneLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.data.buildingData.itemId, 1)
  self.singleExchangeNeedNum = oneLevelTemplate.convert_decorator_num
  self.tips2Text:SetLocalText("building_center_desc27", oneLevelTemplate.convert_decorator_num)
  self.targetDecoItemImg:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(self.data.buildingData.itemId, 1), DefaultImage)
  self.haveGlueCount = DataCenter.ItemData:GetItemCount(GLUE_GOOD_ID)
  self.curMaxExchangeCount = self.haveGlueCount // self.singleExchangeNeedNum
  self.curMinExchangeCount = self.curMaxExchangeCount > 0 and 1 or 0
  if self.ctrl:IsOverMaxFunctionOn() then
    self.needDecoNumToMaxLevel = self.ctrl:GetNeedDecorationItemCountToMaxLevel(self.data.buildingData.itemId)
  end
  if 0 < self.needDecoNumToMaxLevel then
    self.overMaxTips:SetLocalText("decoration_limit_up_desc_01", self.needDecoNumToMaxLevel)
  end
  self.countSlider.unity_uislider.minValue = self.curMinExchangeCount
  self.countSlider.unity_uislider.maxValue = self.curMaxExchangeCount
  self.curSelectDecoExchangeNum = self.data.need or 0
  self:SetSelectNum(self.curSelectDecoExchangeNum)
  self.progressGroupId = self.curLevelTemplate.decoGroupUpgradeBaseId
  self.isExistAdvanceUpgrade = 0 < self.progressGroupId
  if self.isExistAdvanceUpgrade then
    self:RefreshViewAboutAdvanceUpgrade()
  else
    self:RefreshViewAboutNormalUpgrade()
  end
  self.haveItemNumText:SetLocalText(130128, self.haveGlueCount)
end

function UIBuildDecorateExchangeNew:RefreshViewAboutAdvanceUpgrade()
  if not self.isExistAdvanceUpgrade then
    return
  end
  self.curUpgradeProgress = self.param.prodStatus or 0
  self.curProgressInfo = DataCenter.DecorationUpgradeTemplateManager:GetLvAndStageInfoByProgress(self.progressGroupId, self.param.level, self.curUpgradeProgress)
  if not self.curProgressInfo then
    self.ctrl:CloseSelf()
    return
  end
  local curGroupId = self.curProgressInfo.group
  local level = self.curProgressInfo.level
  local needProgressToNextStage = BuildingUtils.GetRemainProgressToNextStage(curGroupId, level, self.curUpgradeProgress)
  self.needDecoNumToNextStage = math.max(needProgressToNextStage * self.curProgressInfo.cost_item - self.haveNum, 0)
  self.needExchangeNumToNextStage = self.needDecoNumToNextStage * self.singleExchangeNeedNum
  local curLevel = self.curProgressInfo.level
  local needProgressToNextLevel = BuildingUtils.GetRemainProgressToNextLevel(curGroupId, curLevel, self.curUpgradeProgress)
  self.needDecoNumToNextLevel = math.max(needProgressToNextLevel * self.curProgressInfo.cost_item - self.haveNum, 0)
  self.needExchangeNumToNextLevel = self.needDecoNumToNextLevel * self.singleExchangeNeedNum
  self.nextStageCostText:SetActive(true)
  self.nextLevelCostText:SetActive(true)
  self.nextStageCostText:SetLocalText("decoration_building_desc1", string.format("<color=#2a2830>%s</color>", self.needExchangeNumToNextStage))
  self.nextLevelCostText:SetLocalText("decoration_building_desc2", string.format("<color=#2a2830>%s</color>", self.needExchangeNumToNextLevel))
  self:CheckAutoSelectNextStageOrLevelBtnState()
end

function UIBuildDecorateExchangeNew:RefreshViewAboutNormalUpgrade()
  self.selectNextStageBtn:SetActive(false)
  local upLevelScarceInfos = BuildingUtils.GetDecorateUpLevelBuilds(self.param)
  local haveDecoNum = 0
  local nextLvNeedDecoNum = 0
  if upLevelScarceInfos and 0 < table.count(upLevelScarceInfos) then
    local lastData = upLevelScarceInfos[#upLevelScarceInfos]
    haveDecoNum = lastData.count
    nextLvNeedDecoNum = lastData.needScore
  end
  self.needDecoNumToNextLevel = nextLvNeedDecoNum
  local needExchangeNumToNextLevel = nextLvNeedDecoNum * self.singleExchangeNeedNum
  if needExchangeNumToNextLevel <= self.haveGlueCount then
    self:SetSelectNum(nextLvNeedDecoNum)
    self.selectNextLevelBtn:SetActive(true)
  else
    self.selectNextLevelBtn:SetActive(false)
  end
  self.nextStageCostText:SetActive(false)
  self.nextLevelCostText:SetActive(true)
  self.nextLevelCostText:SetLocalText("decoration_building_desc2", string.format("<color=#2a2830>%s</color>", needExchangeNumToNextLevel))
end

function UIBuildDecorateExchangeNew:CheckAutoSelectNextStageOrLevelBtnState()
  local enoughUpgradeNextStage = self.haveGlueCount >= self.needExchangeNumToNextStage
  local enoughUpgradeNextLevel = self.haveGlueCount >= self.needExchangeNumToNextLevel
  if not enoughUpgradeNextStage and not enoughUpgradeNextLevel then
    self.batchSelectAreObj:SetActive(false)
    return
  end
  self.batchSelectAreObj:SetActive(true)
  local isLastUpgradeStage = self.needExchangeNumToNextStage == self.needExchangeNumToNextLevel
  self.selectNextStageBtn:SetActive(enoughUpgradeNextStage and not isLastUpgradeStage)
  self.selectNextLevelBtn:SetActive(enoughUpgradeNextLevel)
end

function UIBuildDecorateExchangeNew:OnSliderValChange(value)
  self:SetSelectNum(value)
end

function UIBuildDecorateExchangeNew:SetSelectNum(targetNum)
  local isOverMaxNeedDecoNum = self.needDecoNumToMaxLevel > 0 and targetNum >= self.needDecoNumToMaxLevel
  self.overMaxBubble:SetActive(isOverMaxNeedDecoNum)
  self.overMaxTips:SetActive(isOverMaxNeedDecoNum)
  if isOverMaxNeedDecoNum then
    self.curSelectDecoExchangeNum = toInt(Mathf.Clamp(self.needDecoNumToMaxLevel, self.curMinExchangeCount, self.curMaxExchangeCount))
  else
    self.curSelectDecoExchangeNum = toInt(Mathf.Clamp(targetNum, self.curMinExchangeCount, self.curMaxExchangeCount))
  end
  self.countSlider:SetValueWithoutNotify(self.curSelectDecoExchangeNum)
  self.curTotalCostExchangeNum = self.curSelectDecoExchangeNum * self.singleExchangeNeedNum
  self.selectNumInputText:SetText(self.curTotalCostExchangeNum)
  self:RefreshItemInfo()
end

function UIBuildDecorateExchangeNew:OnClickAddBtn()
  local targetNum = self.curSelectDecoExchangeNum + 1
  self.countSlider:SetValue(targetNum)
end

function UIBuildDecorateExchangeNew:OnClickDecBtn()
  local targetNum = self.curSelectDecoExchangeNum - 1
  self.countSlider:SetValue(targetNum)
end

function UIBuildDecorateExchangeNew:OnClickSelectMaxBtn()
  self.countSlider:SetValue(self.curMaxExchangeCount)
end

function UIBuildDecorateExchangeNew:RefreshItemInfo()
  local isEnough = self.curTotalCostExchangeNum >= self.singleExchangeNeedNum
  local color = isEnough and "#5FEF87" or "#F97077"
  self.exchangeItemNumText:SetText(string.format("<color=%s>%d</color>/%d", color, self.curTotalCostExchangeNum, self.singleExchangeNeedNum))
  self.targetDecoItemNumText:SetText(self.curSelectDecoExchangeNum)
end

function UIBuildDecorateExchangeNew:OnClickUpgradeOneStage()
  if not self.needDecoNumToNextStage or self.needDecoNumToNextStage <= 0 then
    return
  end
  self.countSlider:SetValue(self.needDecoNumToNextStage)
end

function UIBuildDecorateExchangeNew:OnClickUpgradeOneLevel()
  if not self.needDecoNumToNextLevel or self.needDecoNumToNextLevel <= 0 then
    return
  end
  self.countSlider:SetValue(self.needDecoNumToNextLevel)
end

function UIBuildDecorateExchangeNew:OnClickExchangeBtn()
  if self.curSelectDecoExchangeNum <= 0 then
    local prevWindowNeed = self.data.need or 1
    local needGlueCount = self.singleExchangeNeedNum * prevWindowNeed
    LWResourceLackUtil:GotoGoodsItemLack(GLUE_GOOD_ID, needGlueCount)
    UIUtil.ShowTipsId(120021)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.DecoratorConvertMessage, self.param.itemId, self.curSelectDecoExchangeNum)
end

function UIBuildDecorateExchangeNew:CloseWindow()
  self.ctrl.CloseSelf()
end

function UIBuildDecorateExchangeNew:OnInputEnd(value)
  local selectNum = toInt(value)
  if selectNum == nil then
    return
  end
  local convertDecoCount = selectNum // self.singleExchangeNeedNum
  self.countSlider:SetValue(convertDecoCount)
end

UIBuildDecorateExchangeNew.OnCreate = OnCreate
UIBuildDecorateExchangeNew.OnDestroy = OnDestroy
UIBuildDecorateExchangeNew.OnEnable = OnEnable
UIBuildDecorateExchangeNew.OnDisable = OnDisable
UIBuildDecorateExchangeNew.ComponentDefine = ComponentDefine
UIBuildDecorateExchangeNew.ComponentDestroy = ComponentDestroy
UIBuildDecorateExchangeNew.DataDefine = DataDefine
UIBuildDecorateExchangeNew.DataDestroy = DataDestroy
UIBuildDecorateExchangeNew.OnAddListener = OnAddListener
UIBuildDecorateExchangeNew.OnRemoveListener = OnRemoveListener
return UIBuildDecorateExchangeNew
