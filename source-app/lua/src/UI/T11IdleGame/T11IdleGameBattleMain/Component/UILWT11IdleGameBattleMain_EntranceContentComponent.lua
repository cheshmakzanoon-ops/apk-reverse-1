local base = UIBaseContainer
local UILWT11IdleGameBattleMain_EntranceContentComponent = BaseClass("UILWT11IdleGameBattleMain_EntranceContentComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UILWT11IdleGameBattleMain_EntranceMapItemComponent = require("UI/T11IdleGame/T11IdleGameBattleMain/Component/UILWT11IdleGameBattleMain_EntranceMapItemComponent")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")

function UILWT11IdleGameBattleMain_EntranceContentComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWT11IdleGameBattleMain_EntranceContentComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWT11IdleGameBattleMain_EntranceContentComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textBattleSceneTitle01 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textBattleSceneTitle02 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnStart = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnStart:SetOnClick(function()
    self:OnBtnStartClick()
  end)
  self.textStartBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compUILWT11IdleGameBattleMainEntranceMapItem10 = self.viewSkin:AddComponent(self, UILWT11IdleGameBattleMain_EntranceMapItemComponent, 5)
  self.compUILWT11IdleGameBattleMainEntranceMapItem09 = self.viewSkin:AddComponent(self, UILWT11IdleGameBattleMain_EntranceMapItemComponent, 6)
  self.compUILWT11IdleGameBattleMainEntranceMapItem08 = self.viewSkin:AddComponent(self, UILWT11IdleGameBattleMain_EntranceMapItemComponent, 7)
  self.compUILWT11IdleGameBattleMainEntranceMapItem07 = self.viewSkin:AddComponent(self, UILWT11IdleGameBattleMain_EntranceMapItemComponent, 8)
  self.compUILWT11IdleGameBattleMainEntranceMapItem06 = self.viewSkin:AddComponent(self, UILWT11IdleGameBattleMain_EntranceMapItemComponent, 9)
  self.compUILWT11IdleGameBattleMainEntranceMapItem05 = self.viewSkin:AddComponent(self, UILWT11IdleGameBattleMain_EntranceMapItemComponent, 10)
  self.compUILWT11IdleGameBattleMainEntranceMapItem04 = self.viewSkin:AddComponent(self, UILWT11IdleGameBattleMain_EntranceMapItemComponent, 11)
  self.compUILWT11IdleGameBattleMainEntranceMapItem03 = self.viewSkin:AddComponent(self, UILWT11IdleGameBattleMain_EntranceMapItemComponent, 12)
  self.compUILWT11IdleGameBattleMainEntranceMapItem02 = self.viewSkin:AddComponent(self, UILWT11IdleGameBattleMain_EntranceMapItemComponent, 13)
  self.compUILWT11IdleGameBattleMainEntranceMapItem01 = self.viewSkin:AddComponent(self, UILWT11IdleGameBattleMain_EntranceMapItemComponent, 14)
  self.imgSoldierIcon = self.viewSkin:AddComponent(self, UIImage, 15)
  self.btnSoldierIconInfo = self.viewSkin:AddComponent(self, UIButton, 16)
  self.btnSoldierIconInfo:SetOnClick(function()
    self:OnBtnSoldierIconInfoClick()
  end)
  self.textSoldierIconName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.textSoldierIconLevel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.textPowerTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.textPowerSlider = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 20)
  self.textSoldierTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 21)
  self.textSoldierSlider = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 22)
  self.textInfo = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 23)
  self.btnTask = self.viewSkin:AddComponent(self, UIButton, 24)
  self.btnTask:SetOnClick(function()
    self:OnBtnTaskClick()
  end)
  self.textBattleDuration = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 25)
  self.animatorUILWT11IdleGameBattleMainEntranceContent = self.viewSkin:AddComponent(self, UIAnimator, 26)
  self.btnRank = self.viewSkin:AddComponent(self, UIButton, 27)
  self.btnRank:SetOnClick(function()
    self:OnBtnRankClick()
  end)
  self.btnRewardPreview = self.viewSkin:AddComponent(self, UIButton, 28)
  self.btnRewardPreview:SetOnClick(function()
    self:OnBtnRewardPreviewClick()
  end)
  self.compTaskRedPoint = self.viewSkin:AddComponent(self, UIBaseContainer, 29)
  self.compStartRed = self.viewSkin:AddComponent(self, UIBaseComponent, 30)
  self.compCenter = self.viewSkin:AddComponent(self, UIBaseComponent, 31)
  self.compBg = self.viewSkin:AddComponent(self, UIBaseComponent, 32)
  self.compLeftTime = self.viewSkin:AddComponent(self, UIBaseComponent, 33)
  self.textLeftTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 34)
  self.btnLeftTimeInfo = self.viewSkin:AddComponent(self, UIButton, 35)
  self.btnLeftTimeInfo:SetOnClick(function()
    self:OnBtnLeftTimeInfoClick()
  end)
  self.btnPowerInfo = self.viewSkin:AddComponent(self, UIButton, 36)
  self.btnPowerInfo:SetOnClick(function()
    self:OnBtnPowerInfoClick()
  end)
  self.compEffUiT11IdleMark01 = self.viewSkin:AddComponent(self, UIBaseComponent, 37)
  self.compEffUiT11IdleMark02 = self.viewSkin:AddComponent(self, UIBaseComponent, 38)
  self.compEffUiT11IdleMark03 = self.viewSkin:AddComponent(self, UIBaseComponent, 39)
  self.compEffUiT11IdleMark04 = self.viewSkin:AddComponent(self, UIBaseComponent, 40)
  self.compEffUiT11IdleMark05 = self.viewSkin:AddComponent(self, UIBaseComponent, 41)
  self.compEffUiT11IdleMark06 = self.viewSkin:AddComponent(self, UIBaseComponent, 42)
  self.compEffUiT11IdleMark07 = self.viewSkin:AddComponent(self, UIBaseComponent, 43)
  self.compEffUiT11IdleMark08 = self.viewSkin:AddComponent(self, UIBaseComponent, 44)
  self.compEffUiT11IdleMark09 = self.viewSkin:AddComponent(self, UIBaseComponent, 45)
  self.compEffUiT11IdleMark10 = self.viewSkin:AddComponent(self, UIBaseComponent, 46)
  self.mapItems = {
    self.compUILWT11IdleGameBattleMainEntranceMapItem01,
    self.compUILWT11IdleGameBattleMainEntranceMapItem02,
    self.compUILWT11IdleGameBattleMainEntranceMapItem03,
    self.compUILWT11IdleGameBattleMainEntranceMapItem04,
    self.compUILWT11IdleGameBattleMainEntranceMapItem05,
    self.compUILWT11IdleGameBattleMainEntranceMapItem06,
    self.compUILWT11IdleGameBattleMainEntranceMapItem07,
    self.compUILWT11IdleGameBattleMainEntranceMapItem08,
    self.compUILWT11IdleGameBattleMainEntranceMapItem09,
    self.compUILWT11IdleGameBattleMainEntranceMapItem10
  }
  self.compEffUiT11IdleMarkList = {
    self.compEffUiT11IdleMark01,
    self.compEffUiT11IdleMark02,
    self.compEffUiT11IdleMark03,
    self.compEffUiT11IdleMark04,
    self.compEffUiT11IdleMark05,
    self.compEffUiT11IdleMark06,
    self.compEffUiT11IdleMark07,
    self.compEffUiT11IdleMark08,
    self.compEffUiT11IdleMark09,
    self.compEffUiT11IdleMark10
  }
  self.textBattleSceneTitle01:SetLocalText("t11_idle_game_desc_2")
  self.textSoldierIconName:SetLocalText("t11_idle_game_desc_5")
  self.textPowerTitle:SetLocalText("t11_idle_game_desc_6")
  self.textSoldierTitle:SetLocalText("t11_idle_game_desc_7")
  self.textInfo:SetLocalText("t11_idle_game_desc_8")
  self.textStartBtn:SetLocalText("t11_idle_game_button_9")
end

function UILWT11IdleGameBattleMain_EntranceContentComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textBattleSceneTitle01 = nil
  self.textBattleSceneTitle02 = nil
  self.btnStart = nil
  self.textStartBtn = nil
  self.compUILWT11IdleGameBattleMainEntranceMapItem10 = nil
  self.compUILWT11IdleGameBattleMainEntranceMapItem09 = nil
  self.compUILWT11IdleGameBattleMainEntranceMapItem08 = nil
  self.compUILWT11IdleGameBattleMainEntranceMapItem07 = nil
  self.compUILWT11IdleGameBattleMainEntranceMapItem06 = nil
  self.compUILWT11IdleGameBattleMainEntranceMapItem05 = nil
  self.compUILWT11IdleGameBattleMainEntranceMapItem04 = nil
  self.compUILWT11IdleGameBattleMainEntranceMapItem03 = nil
  self.compUILWT11IdleGameBattleMainEntranceMapItem02 = nil
  self.compUILWT11IdleGameBattleMainEntranceMapItem01 = nil
  self.imgSoldierIcon = nil
  self.btnSoldierIconInfo = nil
  self.textSoldierIconName = nil
  self.textSoldierIconLevel = nil
  self.textPowerTitle = nil
  self.textPowerSlider = nil
  self.textSoldierTitle = nil
  self.textSoldierSlider = nil
  self.textInfo = nil
  self.btnTask = nil
  self.textBattleDuration = nil
  self.animatorUILWT11IdleGameBattleMainEntranceContent = nil
  self.btnRank = nil
  self.btnRewardPreview = nil
  self.compTaskRedPoint = nil
  self.compStartRed = nil
  self.compCenter = nil
  self.compBg = nil
  self.compLeftTime = nil
  self.textLeftTime = nil
  self.btnLeftTimeInfo = nil
  self.btnPowerInfo = nil
  self.compEffUiT11IdleMark01 = nil
  self.compEffUiT11IdleMark02 = nil
  self.compEffUiT11IdleMark03 = nil
  self.compEffUiT11IdleMark04 = nil
  self.compEffUiT11IdleMark05 = nil
  self.compEffUiT11IdleMark06 = nil
  self.compEffUiT11IdleMark07 = nil
  self.compEffUiT11IdleMark08 = nil
  self.compEffUiT11IdleMark09 = nil
  self.compEffUiT11IdleMark10 = nil
  self.compEffUiT11IdleMarkList = nil
  self.mapItems = nil
end

function UILWT11IdleGameBattleMain_EntranceContentComponent:DataDefine()
  self.infoData = nil
  self.sendStartMsgLock = false
end

function UILWT11IdleGameBattleMain_EntranceContentComponent:DataDestroy()
  self.infoData = nil
  self.sendStartMsgLock = nil
  if self.delayRefreshMarkTimer then
    self.delayRefreshMarkTimer:Stop()
    self.delayRefreshMarkTimer = nil
  end
end

function UILWT11IdleGameBattleMain_EntranceContentComponent:ReInit(param)
  self.infoData = DataCenter.T11IdleGameDataManager:GetIdleInfoData()
  if self.infoData == nil then
    return
  end
  self.sendStartMsgLock = false
  self:RefreshAll(param)
  if param and param.isFromOpen then
    self.animatorUILWT11IdleGameBattleMainEntranceContent:Play("V_ui_UILWT11IdleGameBattleMain_EntranceContent_in")
  else
    self.animatorUILWT11IdleGameBattleMainEntranceContent:Play("V_ui_UILWT11IdleGameBattleMain_EntranceContent_idle")
  end
  local isShowRedPoint = DataCenter.T11IdleGameDataManager:IsShowEventRedPointByMainMsg()
  self.compTaskRedPoint:SetActive(isShowRedPoint)
end

function UILWT11IdleGameBattleMain_EntranceContentComponent:RefreshAll(param)
  self:RefreshMapItems(param)
  self:RefreshInfoContent()
  self:RefreshLevelTitle()
  self:RefreshUIPosYByScreenHeight()
  self:RefreshLeftTime()
end

function UILWT11IdleGameBattleMain_EntranceContentComponent:RefreshLevelTitle()
  if self.infoData == nil then
    return
  end
  local curLevel = self.infoData:GetLevelTemplate()
  if curLevel then
    self.textBattleSceneTitle02:SetText(curLevel:GetName())
  end
end

function UILWT11IdleGameBattleMain_EntranceContentComponent:RefreshInfoContent()
  if self.infoData == nil then
    return
  end
  local soldierId = self.infoData.soldierId
  local soldierMeta = DataCenter.SoldierDataManager:GetTemplate(soldierId)
  if not soldierMeta then
    return
  end
  self.textSoldierIconLevel:SetText(soldierMeta.lv)
  local soldierIcon = DataCenter.T11IdleGameTemplateManager:GetIdleBattleSoldierIconPath(soldierId)
  if not string.IsNullOrEmpty(soldierIcon) then
    self.imgSoldierIcon:LoadSprite(soldierIcon)
  end
  self.textPowerSlider:SetText(self.infoData:GetPowerStr())
  self.textSoldierSlider:SetText(self.infoData.soldierNum)
end

function UILWT11IdleGameBattleMain_EntranceContentComponent:RefreshMapItems(param)
  if not self.mapItems or not self.infoData then
    return
  end
  for i, v in ipairs(self.mapItems) do
    v:ReInit(i, param)
  end
  local levelTemplate = self.infoData:GetLevelTemplate()
  if levelTemplate then
    local timeMSTotal = levelTemplate:GetTotalTimeMS()
    self.textBattleDuration:SetText(Localization:GetString("t11_idle_game_desc_4", UITimeManager:GetInstance():MilliSecondToFmtString(timeMSTotal)))
  end
  for i, v in ipairs(self.compEffUiT11IdleMarkList) do
    local template = DataCenter.T11IdleGameTemplateManager:GetLevelTemplateByLevel(i)
    if template ~= nil then
      if param ~= nil and param.newLevelId == template.id then
        local mark = v
        mark:SetActive(false)
        self.delayRefreshMarkTimer = TimerManager:GetInstance():DelayInvoke(function()
          mark:SetActive(true)
        end, 2)
      else
        local state = template:GetState()
        v:SetActive(state == Const.LevelState.Current)
      end
    end
  end
end

function UILWT11IdleGameBattleMain_EntranceContentComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.T11IdleGameOnStartIdleGameMessageFailed, self.OnStartIdleGameMessageFailed)
  self:AddUIListener(EventId.T11IdleGameTaskEventListRefresh, self.OnRefreshEventRedPointByEventList)
  self:AddUIListener(EventId.T11IdleGameTaskEventRedPointRefreshByUpdateMsg, self.OnRefreshEventRedPointByUpdateMsg)
end

function UILWT11IdleGameBattleMain_EntranceContentComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.T11IdleGameOnStartIdleGameMessageFailed, self.OnStartIdleGameMessageFailed)
  self:RemoveUIListener(EventId.T11IdleGameTaskEventListRefresh, self.OnRefreshEventRedPointByEventList)
  self:RemoveUIListener(EventId.T11IdleGameTaskEventRedPointRefreshByUpdateMsg, self.OnRefreshEventRedPointByUpdateMsg)
  base.OnRemoveListener(self)
end

function UILWT11IdleGameBattleMain_EntranceContentComponent:OnBtnStartClick()
  local mainData = DataCenter.T11IdleGameDataManager:GetMainData()
  if mainData == nil then
    return
  end
  local leftTime = mainData:GetStartGameLeftTime()
  if leftTime <= 0 then
    return
  end
  if not self.sendStartMsgLock then
    self.sendStartMsgLock = true
    DataCenter.T11IdleGameDataManager:SendStartIdleGameMessage()
    DataCenter.LWSoundManager:PlaySound(91009, false)
  end
end

function UILWT11IdleGameBattleMain_EntranceContentComponent:OnBtnSoldierIconInfoClick()
  local param = {}
  param.alignObject = self.btnSoldierIconInfo.transform
  param.yPosFix = 10
  param.contentText = Localization:GetString("t11_idle_game_desc_57")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWT11IdleGameBattleSoldierInfoTip, {anim = true}, param)
end

function UILWT11IdleGameBattleMain_EntranceContentComponent:OnBtnTaskClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIIdleGameTaskEventList)
  DataCenter.T11IdleGameDataManager:CheckOpenTaskEventNewTipsView()
  DataCenter.T11IdleGameDataManager:ClearNewEventTipsData()
end

function UILWT11IdleGameBattleMain_EntranceContentComponent:PlayChangeAnim()
  return self.animatorUILWT11IdleGameBattleMainEntranceContent:PlayAnimationReturnTime("V_ui_UILWT11IdleGameBattleMain_EntranceContent_show")
end

function UILWT11IdleGameBattleMain_EntranceContentComponent:PlayChangeBackAnim()
  return self.animatorUILWT11IdleGameBattleMainEntranceContent:PlayAnimationReturnTime("V_ui_UILWT11IdleGameBattleMain_EntranceContent_hide")
end

function UILWT11IdleGameBattleMain_EntranceContentComponent:OnBtnRankClick()
  DataCenter.T11IdleGameManager:OpenRankView()
end

function UILWT11IdleGameBattleMain_EntranceContentComponent:OnBtnRewardPreviewClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWT11IdleGameBattleRewardPreview, {anim = true})
end

function UILWT11IdleGameBattleMain_EntranceContentComponent:OnStartIdleGameMessageFailed()
  self.sendStartMsgLock = false
end

function UILWT11IdleGameBattleMain_EntranceContentComponent:OnRefreshEventRedPointByEventList()
  local isShowRedPoint = DataCenter.T11IdleGameDataManager:IsShowEventRedPointByTaskList()
  self.compTaskRedPoint:SetActive(isShowRedPoint)
end

function UILWT11IdleGameBattleMain_EntranceContentComponent:OnRefreshEventRedPointByUpdateMsg()
  local isShowRedPoint = DataCenter.T11IdleGameDataManager:IsShowEventRedPointByUpdateMsg()
  self.compTaskRedPoint:SetActive(isShowRedPoint)
end

function UILWT11IdleGameBattleMain_EntranceContentComponent:RefreshStartBtnRed()
end

function UILWT11IdleGameBattleMain_EntranceContentComponent:RefreshUIPosYByScreenHeight()
  local uiContainerRect = UIManager:GetInstance():GetUIContainerRect()
  local parentHeight = uiContainerRect.sizeDelta.y
  if Config.IsPC() then
    parentHeight = DefaultScreenHeight
  end
  local curOffsetMin = self.compBg:GetOffsetMin()
  self.compBg:SetOffsetMinXY(curOffsetMin.x, -0.3888888888888889 * (parentHeight - DefaultScreenHeight))
end

function UILWT11IdleGameBattleMain_EntranceContentComponent:RefreshLeftTime()
  local mainData = DataCenter.T11IdleGameDataManager:GetMainData()
  if mainData == nil then
    return
  end
  local leftTime = mainData:GetStartGameLeftTime()
  self.textLeftTime:SetLocalText("t11_idle_game_desc_87", leftTime)
end

function UILWT11IdleGameBattleMain_EntranceContentComponent:OnBtnLeftTimeInfoClick()
  local param = {}
  param.alignObject = self.btnLeftTimeInfo.transform
  param.yPosFix = 70
  param.xPosFix = -10
  param.showArrow = false
  param.target = self.btnLeftTimeInfo
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWT11IdleGameBattleLeftTimeTips, {anim = true}, param)
end

function UILWT11IdleGameBattleMain_EntranceContentComponent:OnBtnPowerInfoClick()
  local param = {}
  param.activityRulesStr = Localization:GetString("t11_idle_game_desc_92")
  param.title = "t11_idle_game_title_91"
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

return UILWT11IdleGameBattleMain_EntranceContentComponent
