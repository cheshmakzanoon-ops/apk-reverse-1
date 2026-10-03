local base = UIBaseView
local LWUIZoneMobilizationDonatedSubView = BaseClass("LWUIZoneMobilizationDonatedSubView", base)
local LWUIZoneMobilizationDonatedInfoItemRender = require("UI.LWUIZoneMobilization.LWUIDonatedSubView.LWUIZoneMobilizationDonatedInfoItemRender")
local LWUIZoneMobilizationDonatedFlyItemRender = require("UI.LWUIZoneMobilization.LWUIDonatedSubView.LWUIZoneMobilizationDonatedFlyItemRender")
local LWUIZoneMobilizationDonatedRewardPreviewContent = require("UI.LWUIZoneMobilization.LWUIDonatedRewardPreview.LWUIZoneMobilizationDonatedRewardPreviewContent")
local UIZoneMobilizationNameItem = require("UI.LWUIZoneMobilization.LWUIZoneMobilizationMain.Component.UIZoneMobilizationNameItem")
local Localization = CS.GameEntry.Localization
local coinBtn_path = "CoinBtn"
local coinBtnText_path = "CoinBtn/CoinBtnText"
local suppliesBtn_path = "SuppliesBtn"
local suppliesBtnText_path = "SuppliesBtn/SuppliesBtnText"
local coinBtnRedPoint_path = "CoinBtn/CoinBtnRedPoint"
local placeTipsText_path = "PlaceTipsText"
local stageInfoContent_path = "StageInfoContent"
local stageText_path = "StageInfoContent/StageText"
local rewardBtn_path = "StageInfoContent/RewardBtn"
local rewardBtnRedPoint_path = "StageInfoContent/RewardBtn/RewardBtnRedPoint"
local nextStageTimeText_path = "StageInfoContent/NextStageTimeText"
local donatedProgressSlider_path = "StageInfoContent/DonatedProgressSlider"
local donatedProgressValueText_path = "StageInfoContent/DonatedProgressSlider/DonatedProgressValueText"
local personalDonatedObj_path = "PersonalDonatedObj"
local allianceDonatedObj_path = "AllianceDonatedObj"
local gotoBtn_path = "GoToBtn"
local gotoBtnText_path = "GoToBtn/GoToBtnText"
local cutDownTipsIcon_path = "GoToBtn/CutDownTipsIcon"
local donatedStageRewardPreviewObj_path = "LWUIZoneMobilizationDonatedRewardPreviewContent"
local rankBtn_path = "RankBtn"
local rankBtnText_path = "RankBtn/RankBtnText"
local donatedProgressEffect_path = "StageInfoContent/DonatedProgressSlider/Eff_ui_Zone_saoguang_long"
local suppliesPointsBubbleContent_path = "SuppliesBtn/SuppliesPointsBubbleContent"
local settle_tips_text_path = "SettleTipsText"
local name_group_path = "NameGroup"
local sprint_stage_path = "StageInfoContent/SprintStage"
local sprint_stage_text_path = "StageInfoContent/SprintStage/SprintStageText"
local supplies_red_point_path = "SuppliesBtn/SuppliesRedPoint"
local PERSONAL_SUPPLIES_PATH = "zxl_xiusai_wuziqipao_02_big"
local PERSONAL_RESOURCE_PATH = "zxl_xiusai_wuziqipao_big"
local ALLIANCE_SUPPLIES_PATH = "wxy_xiusai_wuziqipao_02_big"
local ALLIANCE_RESOURCE_PATH = "wxy_xiusai_wuziqipao_big"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:StopDonatedProgressSeq()
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
  self.coinBtn = self:AddComponent(UIButton, coinBtn_path)
  self.coinBtnText = self:AddComponent(UIText, coinBtnText_path)
  self.suppliesBtn = self:AddComponent(UIButton, suppliesBtn_path)
  self.suppliesBtnText = self:AddComponent(UIText, suppliesBtnText_path)
  self.coinBtnRedPoint = self:AddComponent(UIBaseContainer, coinBtnRedPoint_path)
  self.placeTipsText = self:AddComponent(UIText, placeTipsText_path)
  self.stageInfoContent = self:AddComponent(UIBaseContainer, stageInfoContent_path)
  self.stageText = self:AddComponent(UIText, stageText_path)
  self.rewardBtn = self:AddComponent(UIButton, rewardBtn_path)
  self.rewardBtnRedPoint = self:AddComponent(UIBaseContainer, rewardBtnRedPoint_path)
  self.nextStageTimeText = self:AddComponent(UIText, nextStageTimeText_path)
  self.donatedProgressSlider = self:AddComponent(UISlider, donatedProgressSlider_path)
  self.donatedProgressValueText = self:AddComponent(UIText, donatedProgressValueText_path)
  self.personalDonatedObj = self:AddComponent(UIBaseContainer, personalDonatedObj_path)
  self.allianceDonatedObj = self:AddComponent(UIBaseContainer, allianceDonatedObj_path)
  self.gotoBtn = self:AddComponent(UIButton, gotoBtn_path)
  self.gotoBtnText = self:AddComponent(UIText, gotoBtnText_path)
  self.cutDownTipsIcon = self:AddComponent(UIBaseContainer, cutDownTipsIcon_path)
  self.donatedStageRewardPreviewObj = self:AddComponent(UIBaseContainer, donatedStageRewardPreviewObj_path)
  self.rankBtn = self:AddComponent(UIButton, rankBtn_path)
  self.rankBtnText = self:AddComponent(UIText, rankBtnText_path)
  self.donatedProgressEffect = self:AddComponent(UIBaseContainer, donatedProgressEffect_path)
  self.suppliesPointsBubbleContent = self:AddComponent(LWUIZoneMobilizationDonatedFlyItemRender, suppliesPointsBubbleContent_path)
  self.personalDonatedItemRender = self:AddComponent(LWUIZoneMobilizationDonatedInfoItemRender, personalDonatedObj_path)
  self.personalDonatedItemRender:InitData(ZoneMobilizationDonatedBoxType.Personal)
  self.allianceDonatedItemRender = self:AddComponent(LWUIZoneMobilizationDonatedInfoItemRender, allianceDonatedObj_path)
  self.allianceDonatedItemRender:InitData(ZoneMobilizationDonatedBoxType.Alliance)
  self.donatedStageRewardPreviewContent = self:AddComponent(LWUIZoneMobilizationDonatedRewardPreviewContent, donatedStageRewardPreviewObj_path)
  self.settle_tips_text = self:AddComponent(UITextMeshProUGUIEx, settle_tips_text_path)
  self.coinBtn:SetOnClick(function()
    self:CoinBtnClick()
  end)
  self.suppliesBtn:SetOnClick(function()
    self:SuppliesBtnClick()
  end)
  self.coinBtnText:SetLocalText("zone_mobilization_alliance_task_btn")
  self.suppliesBtnText:SetLocalText("zone_mobilization_alliance_find_btn")
  self.placeTipsText:SetLocalText("zone_mobilization_tips_unbuilt")
  self.rewardBtn:SetOnClick(function()
    self:RewardBtnClick()
  end)
  self.gotoBtn:SetOnClick(function()
    self:GotoBtnClick()
  end)
  self.gotoBtnText:SetLocalText("zone_mobilization_stage_go_btn")
  self.rankBtn:SetOnClick(function()
    self:RankBtnClick()
  end)
  self.rankBtnText:SetLocalText("zone_mobilization_defend_rank_btn")
  self.donatedProgressEffect:SetActive(false)
  self.name_group = self:AddComponent(UIZoneMobilizationNameItem, name_group_path)
  self.sprint_stage = self:AddComponent(UIBaseContainer, sprint_stage_path)
  self.sprint_stage_text = self:AddComponent(UITextMeshProUGUIEx, sprint_stage_text_path)
  self.supplies_red_point = self:AddComponent(UIImage, supplies_red_point_path)
end

local function ComponentDestroy(self)
  self.coinBtn = nil
  self.coinBtnText = nil
  self.suppliesBtn = nil
  self.suppliesBtnText = nil
  self.coinBtnRedPoint = nil
  self.placeTipsText = nil
  self.stageInfoContent = nil
  self.stageText = nil
  self.rewardBtn = nil
  self.rewardBtnRedPoint = nil
  self.nextStageTimeText = nil
  self.donatedProgressSlider = nil
  self.donatedProgressValueText = nil
  self.personalDonatedObj = nil
  self.allianceDonatedObj = nil
  self.gotoBtn = nil
  self.gotoBtnText = nil
  self.cutDownTipsIcon = nil
  self.donatedStageRewardPreviewObj = nil
  self.rankBtn = nil
  self.rankBtnText = nil
  self.donatedProgressEffect = nil
  self.suppliesPointsBubbleContent = nil
  self.personalDonatedItemRender = nil
  self.allianceDonatedItemRender = nil
  self.donatedStageRewardPreviewContent = nil
  self.settle_tips_text = nil
  self.name_group = nil
  self.sprint_stage = nil
  self.sprint_stage_text = nil
  self.supplies_red_point = nil
end

local function DataDefine(self)
  self.curStageType = nil
  self.zoneMobilizationDonatedInfo = nil
  self.alreadySendMsg = false
  self.isSetGotoBtnGray = false
  self.playDonatedProgressStartValue = nil
end

local function DataDestroy(self)
  self.curStageType = nil
  self.zoneMobilizationDonatedInfo = nil
  self.alreadySendMsg = nil
  self.isSetGotoBtnGray = nil
  self.playDonatedProgressStartValue = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetZoneMobilizationInfoData, self.RefreshView)
  self:AddUIListener(EventId.UpdateZoneMobilizationDailyTaskRedPointData, self.RefreshCoinBtnRedPoint)
  self:AddUIListener(EventId.UpdateDonatedProgressRewardData, self.RefreshRewardBtnRedPoint)
  self:AddUIListener(EventId.ZoneMobilizationResourcePointsCountChanged, self.TryFlyResourcePointsIcon)
  self:AddUIListener(EventId.ZoneMobilizationSuppliesPointsCountChanged, self.TryFlySuppliesPointsIcon)
  self:AddUIListener(EventId.ZoneMobilizationDonatedProgressChanged, self.OnDonatedProgressChanged)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.GetZoneMobilizationInfoData, self.RefreshView)
  self:RemoveUIListener(EventId.UpdateZoneMobilizationDailyTaskRedPointData, self.RefreshCoinBtnRedPoint)
  self:RemoveUIListener(EventId.UpdateDonatedProgressRewardData, self.RefreshRewardBtnRedPoint)
  self:RemoveUIListener(EventId.ZoneMobilizationResourcePointsCountChanged, self.TryFlyResourcePointsIcon)
  self:RemoveUIListener(EventId.ZoneMobilizationSuppliesPointsCountChanged, self.TryFlySuppliesPointsIcon)
  self:RemoveUIListener(EventId.ZoneMobilizationDonatedProgressChanged, self.OnDonatedProgressChanged)
  base.OnRemoveListener(self)
end

local function Update1000MS(self)
  if self.zoneMobilizationDonatedInfo and self.curStageType and (self.curStageType == ZoneMobilizationStageType.Donated or self.curStageType == ZoneMobilizationStageType.Sprint) then
    self:CutDownStageTime()
    self:RefreshDonatedStageEndCutDownTipsView()
    local donatedStageIsEnd = self.zoneMobilizationDonatedInfo:DonatedStageIsEnd()
    if donatedStageIsEnd and not self.isSetGotoBtnGray then
      self.isSetGotoBtnGray = true
      CS.UIGray.SetGray(self.gotoBtn.transform, true, true)
      self.stageText:SetActive(false)
      self.sprint_stage:SetActive(false)
      self.nextStageTimeText:SetActive(false)
    end
  end
end

local function ReInitData(self)
  self.alreadySendMsg = false
  DataCenter.LWZoneMobilizationManager:RequestZoneMobilizationDonatedInfoData(ZoneMobilizationTabType.Donated)
  self:RefreshView()
  self.donatedStageRewardPreviewContent:SetActive(false)
end

local function RefreshView(self)
  self.curStageType = DataCenter.LWZoneMobilizationManager:GetCurStageType()
  self.zoneMobilizationDonatedInfo = DataCenter.LWZoneMobilizationManager:GetZoneMobilizationDonatedInfoData()
  if self.zoneMobilizationDonatedInfo then
    local isPlaced = DataCenter.LWZoneMobilizationManager:IsPlaced()
    self.placeTipsText:SetActive(not isPlaced)
    self.stageInfoContent:SetActive(isPlaced)
    if isPlaced then
      self:RefreshShowStageInfoView()
    end
    self:RefreshShowPersonalAndAllianceDonatedInfoView()
    self:RefreshCoinBtnRedPoint()
    self:RefreshRewardBtnRedPoint()
    self:RefreshDonatedStageEndCutDownTipsView()
    local donatedIsEnd = self.zoneMobilizationDonatedInfo:DonatedStageIsEnd()
    if self.curStageType == ZoneMobilizationStageType.Donated and not donatedIsEnd then
      local stage_show = GetTableData(TableName.ZoneMobilizationStage, DataCenter.LWZoneMobilizationManager.stage, "stage_show")
      self.stageText:SetLocalText("zone_mobilization_stage_name", stage_show)
      self.stageText:SetActive(true)
      self.sprint_stage:SetActive(false)
    elseif self.curStageType == ZoneMobilizationStageType.Sprint then
      self.sprint_stage_text:SetLocalText("zone_mobilization_stage_sprint_name")
      self.stageText:SetActive(false)
      self.sprint_stage:SetActive(true)
    else
      self.stageText:SetActive(false)
      self.sprint_stage:SetActive(false)
    end
    self.nextStageTimeText:SetActive(not donatedIsEnd)
    self.isSetGotoBtnGray = donatedIsEnd
    CS.UIGray.SetGray(self.gotoBtn.transform, self.isSetGotoBtnGray, true)
    self:TryPlayPlot()
  end
  if self.curStageType == ZoneMobilizationStageType.Battle then
    self.settle_tips_text:SetLocalText("zone_mobilization_stage_battle_title")
  elseif self.curStageType == ZoneMobilizationStageType.SettlementShow then
    self.settle_tips_text:SetLocalText("zone_mobilization_stage_end_title")
  else
    self.settle_tips_text:SetLocalText("")
  end
  self.name_group:ReInit(self.curStageType == ZoneMobilizationStageType.Sprint or self.curStageType == ZoneMobilizationStageType.Battle_Place, DataCenter.LWZoneMobilizationManager.bossId, nil, nil, true)
  if DataCenter.LWZoneMobilizationManager.jump then
    DataCenter.LWZoneMobilizationManager.jump = nil
    self:ShowArrowHand()
  end
  self:RefreshSuppliesRedPoint()
end

local function RefreshShowStageInfoView(self)
  self:CutDownStageTime()
  local curValue = self.zoneMobilizationDonatedInfo.donateProgress
  local maxValue = self.zoneMobilizationDonatedInfo.maxProgress
  if self.playDonatedProgressStartValue then
    self:DoDonatedProgressSeq(curValue, maxValue)
  else
    self:RefreshShowDonatedProgressView(curValue, maxValue)
  end
end

local function OnDonatedProgressChanged(self, param)
  self.playDonatedProgressStartValue = param
end

local function DoDonatedProgressSeq(self, curValue, maxValue)
  self:StopDonatedProgressSeq()
  self.donatedProgressEffect:SetActive(true)
  self.donatedProgressSeq = DOTween.Sequence()
  self.donatedProgressSeq:Append(DOTween.To(function(x)
    local str = string.GetFormattedSeparatorNum(math.floor(x)) .. "/" .. string.GetFormattedSeparatorNum(maxValue)
    self.donatedProgressValueText:SetText(str)
  end, self.playDonatedProgressStartValue, curValue, 1))
  self.donatedProgressSeq:Insert(0, self.donatedProgressSlider:DOValue(Mathf.Clamp01(curValue / maxValue), 1))
  self.donatedProgressSeq:AppendCallback(function()
    self.playDonatedProgressStartValue = nil
    self:RefreshShowDonatedProgressView(curValue, maxValue)
  end)
end

local function StopDonatedProgressSeq(self)
  if self.donatedProgressSeq then
    self.donatedProgressSeq:Kill()
    self.donatedProgressSeq = nil
  end
end

local function RefreshShowDonatedProgressView(self, curValue, maxValue)
  local str = string.GetFormattedSeparatorNum(curValue) .. "/" .. string.GetFormattedSeparatorNum(maxValue)
  self.donatedProgressValueText:SetText(str)
  local progress = Mathf.Clamp01(curValue / maxValue)
  self.donatedProgressSlider:SetValue(progress)
  if self.donatedProgressEffect.activeSelf then
    self.donatedProgressEffect:SetActive(false)
  end
end

local function CutDownStageTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local nextStageTime = DataCenter.LWZoneMobilizationManager.nextStageTime
  local surplusTime = nextStageTime - curTime
  if surplusTime <= 0 then
    surplusTime = 0
    if not self.alreadySendMsg then
      self.alreadySendMsg = true
      DataCenter.LWZoneMobilizationManager:RequestZoneMobilizationDonatedInfoData(ZoneMobilizationTabType.Donated)
    end
  end
  local isPlaced = DataCenter.LWZoneMobilizationManager:IsPlaced()
  if isPlaced and self.nextStageTimeText.activeSelf then
    local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(surplusTime)
    self.nextStageTimeText:SetLocalText("zone_mobilization_stage_count_down", timeStr)
    self.nextStageTimeText:SetText(Localization:GetString("zone_mobilization_stage_count_down") .. timeStr)
  end
end

local function RefreshShowPersonalAndAllianceDonatedInfoView(self)
  local personalNeedIntegralNum = self.zoneMobilizationDonatedInfo:GetPersonalBoxNeedIntegralNum()
  local allianceNeedIntegralNum = self.zoneMobilizationDonatedInfo:GetAllianceBoxNeedIntegralNum()
  self.personalDonatedItemRender:RefreshData(self.zoneMobilizationDonatedInfo.personalDonateInfo, personalNeedIntegralNum)
  self.allianceDonatedItemRender:RefreshData(self.zoneMobilizationDonatedInfo.allianceDonateInfo, allianceNeedIntegralNum)
end

local function RefreshDonatedStageEndCutDownTipsView(self)
  local isShow = false
  if self.zoneMobilizationDonatedInfo and not self.zoneMobilizationDonatedInfo:DonatedStageIsEnd() then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local surplusTime = self.zoneMobilizationDonatedInfo.donateStageEndTime - curTime
    if surplusTime <= OneDayTime * 1000 then
      isShow = true
    end
  end
  if self.cutDownTipsIcon.activeSelf ~= isShow then
    self.cutDownTipsIcon:SetActive(isShow)
  end
end

local function RefreshCoinBtnRedPoint(self)
  local hasRedPoint = DataCenter.LWZoneMobilizationManager:GetZoneMobilizationDailyTaskRedPointData()
  self.coinBtnRedPoint:SetActive(hasRedPoint)
end

local function RefreshRewardBtnRedPoint(self)
  local receiveAllDonatedStageReward = self.zoneMobilizationDonatedInfo:IsReceiveAllDonatedStageReward()
  if receiveAllDonatedStageReward then
    self.rewardBtnRedPoint:SetActive(false)
  else
    local canReceiveDonatedStageReward = self.zoneMobilizationDonatedInfo:IsCanReceiveDonatedStageReward()
    self.rewardBtnRedPoint:SetActive(canReceiveDonatedStageReward)
  end
end

local function TryFlyResourcePointsIcon(self, param)
  if param == nil then
    return
  end
  local stageType = DataCenter.LWZoneMobilizationManager:GetCurStageType()
  if stageType == ZoneMobilizationStageType.Donated or stageType == ZoneMobilizationStageType.Sprint then
    local addNum = param.addNum
    local type = param.type
    local pos, path, node
    if type == ZoneMobilizationSuppliesType.Personal then
      pos = self.personalDonatedItemRender:GetFlyResourcePointsStartPos()
      path = PERSONAL_RESOURCE_PATH
      node = self.personalDonatedItemRender
    else
      pos = self.allianceDonatedItemRender:GetFlyResourcePointsStartPos()
      path = ALLIANCE_RESOURCE_PATH
      node = self.allianceDonatedItemRender
    end
    self.suppliesPointsBubbleContent:TryFlyPointsIcon(pos, self.suppliesPointsBubbleContent.gameObject.transform.position, string.format(LoadPath.LWUIZoneMobilizationSpritePath, path), addNum)
    if node then
      node:DoSupplyPointDisplay()
    end
  end
end

local function TryFlySuppliesPointsIcon(self, param)
  if param == nil then
    return
  end
  local stageType = DataCenter.LWZoneMobilizationManager:GetCurStageType()
  if stageType == ZoneMobilizationStageType.Donated or stageType == ZoneMobilizationStageType.Sprint then
    local addNum = param.addNum
    local type = param.type
    local pos, path, node
    if type == ZoneMobilizationSuppliesType.Personal then
      pos = self.personalDonatedItemRender:GetFlyResourcePointsStartPos()
      path = PERSONAL_SUPPLIES_PATH
      node = self.personalDonatedItemRender
    else
      pos = self.allianceDonatedItemRender:GetFlyResourcePointsStartPos()
      path = ALLIANCE_SUPPLIES_PATH
      node = self.allianceDonatedItemRender
    end
    self.suppliesPointsBubbleContent:TryFlyPointsIcon(pos, self.suppliesPointsBubbleContent.gameObject.transform.position, string.format(LoadPath.LWUIZoneMobilizationSpritePath, path), addNum)
    if node then
      node:DoSupplyPointDisplay()
    end
  end
end

local function TryPlayPlot(self)
  if self.curStageType ~= ZoneMobilizationStageType.None and self.zoneMobilizationDonatedInfo and self.zoneMobilizationDonatedInfo.isAutoFill then
    local localCacheIsValid = DataCenter.LWZoneMobilizationManager:CheckLocalCacheDataIsValid()
    if not localCacheIsValid then
      local stageId = DataCenter.LWZoneMobilizationManager.stage
      local stageTemplate = DataCenter.LWZoneMobilizationStageTemplateManager:GetTemplate(stageId)
      if stageTemplate then
        DataCenter.LWZoneMobilizationManager:RecordLocalCacheStagePlotData()
        EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
          plotGroupId = stageTemplate.lw_plot,
          hideMainUI = false
        })
      end
    end
  end
end

local function CoinBtnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIZoneMobilizationTask, {anim = true})
end

local function SuppliesBtnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIZoneMobilizationSuppliesList, {anim = true})
end

local function RewardBtnClick(self)
  if self.zoneMobilizationDonatedInfo then
    local receiveAllDonatedStageReward = self.zoneMobilizationDonatedInfo:IsReceiveAllDonatedStageReward()
    if receiveAllDonatedStageReward then
      self.donatedStageRewardPreviewContent:SetActive(true)
      self.donatedStageRewardPreviewContent:ShowView()
    else
      local success = DataCenter.LWZoneMobilizationManager:TryReceiveDonatedProgressReward()
      if not success then
        self.donatedStageRewardPreviewContent:SetActive(true)
        self.donatedStageRewardPreviewContent:ShowView()
      end
    end
  end
end

local function GotoBtnClick(self)
  if self.zoneMobilizationDonatedInfo then
    if DataCenter.LWZoneMobilizationManager:GetPosRedPoint() then
      DataCenter.LWZoneMobilizationManager:SetPosRedPoint()
    end
    if self.zoneMobilizationDonatedInfo:DonatedStageIsEnd() then
      UIUtil.ShowTipsId("zone_mobilization_donated_stage_end")
      return
    end
    if DataCenter.LWZoneMobilizationManager:TryGetReward() then
      return
    end
    DataCenter.LWZoneMobilizationManager:DonateTabGotoPointHandler()
  end
end

local function RankBtnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIZoneMobilizationAllianceRank, {anim = true}, ZoneMobilizationRankType.Donated)
end

local function ShowArrowHand(self)
  local param = {}
  param.positionType = PositionType.Screen
  local targetRoot = self.coinBtn
  param.position = targetRoot.transform.position + Vector3.New(50, -50, 0)
  param.isAutoClose = 2
  DataCenter.ArrowManager:ShowFingerArrow(param)
end

local function RefreshSuppliesRedPoint(self)
  self.supplies_red_point:SetActive(DataCenter.LWZoneMobilizationManager:GetSuppliesRedPoint())
end

LWUIZoneMobilizationDonatedSubView.OnCreate = OnCreate
LWUIZoneMobilizationDonatedSubView.OnDestroy = OnDestroy
LWUIZoneMobilizationDonatedSubView.OnEnable = OnEnable
LWUIZoneMobilizationDonatedSubView.OnDisable = OnDisable
LWUIZoneMobilizationDonatedSubView.ComponentDefine = ComponentDefine
LWUIZoneMobilizationDonatedSubView.ComponentDestroy = ComponentDestroy
LWUIZoneMobilizationDonatedSubView.DataDefine = DataDefine
LWUIZoneMobilizationDonatedSubView.DataDestroy = DataDestroy
LWUIZoneMobilizationDonatedSubView.OnAddListener = OnAddListener
LWUIZoneMobilizationDonatedSubView.OnRemoveListener = OnRemoveListener
LWUIZoneMobilizationDonatedSubView.Update1000MS = Update1000MS
LWUIZoneMobilizationDonatedSubView.ReInitData = ReInitData
LWUIZoneMobilizationDonatedSubView.RefreshView = RefreshView
LWUIZoneMobilizationDonatedSubView.RefreshShowStageInfoView = RefreshShowStageInfoView
LWUIZoneMobilizationDonatedSubView.CutDownStageTime = CutDownStageTime
LWUIZoneMobilizationDonatedSubView.RefreshShowPersonalAndAllianceDonatedInfoView = RefreshShowPersonalAndAllianceDonatedInfoView
LWUIZoneMobilizationDonatedSubView.RefreshDonatedStageEndCutDownTipsView = RefreshDonatedStageEndCutDownTipsView
LWUIZoneMobilizationDonatedSubView.RefreshCoinBtnRedPoint = RefreshCoinBtnRedPoint
LWUIZoneMobilizationDonatedSubView.RefreshRewardBtnRedPoint = RefreshRewardBtnRedPoint
LWUIZoneMobilizationDonatedSubView.CoinBtnClick = CoinBtnClick
LWUIZoneMobilizationDonatedSubView.SuppliesBtnClick = SuppliesBtnClick
LWUIZoneMobilizationDonatedSubView.RewardBtnClick = RewardBtnClick
LWUIZoneMobilizationDonatedSubView.GotoBtnClick = GotoBtnClick
LWUIZoneMobilizationDonatedSubView.RankBtnClick = RankBtnClick
LWUIZoneMobilizationDonatedSubView.TryFlyResourcePointsIcon = TryFlyResourcePointsIcon
LWUIZoneMobilizationDonatedSubView.TryFlySuppliesPointsIcon = TryFlySuppliesPointsIcon
LWUIZoneMobilizationDonatedSubView.TryPlayPlot = TryPlayPlot
LWUIZoneMobilizationDonatedSubView.OnDonatedProgressChanged = OnDonatedProgressChanged
LWUIZoneMobilizationDonatedSubView.DoDonatedProgressSeq = DoDonatedProgressSeq
LWUIZoneMobilizationDonatedSubView.StopDonatedProgressSeq = StopDonatedProgressSeq
LWUIZoneMobilizationDonatedSubView.RefreshShowDonatedProgressView = RefreshShowDonatedProgressView
LWUIZoneMobilizationDonatedSubView.ShowArrowHand = ShowArrowHand
LWUIZoneMobilizationDonatedSubView.RefreshSuppliesRedPoint = RefreshSuppliesRedPoint
return LWUIZoneMobilizationDonatedSubView
