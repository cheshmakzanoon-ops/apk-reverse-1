local UISkyBattleLoseView = BaseClass("UISkyBattleLoseView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGrowthItem = require("UI.UIZombieBattleLose.Component.UIZombieBattleResultGrowthListItem")

function UISkyBattleLoseView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:RefreshView()
  self:Show()
end

function UISkyBattleLoseView:OnDestroy()
  base.OnDestroy(self)
end

function UISkyBattleLoseView:ComponentDefine()
  self.canvasGroup = self.transform:Find("Root").gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.tryAgainBtn = self:AddComponent(UIButton, "Root/btnLayout/TryAgainBtn")
  self.tryAgainBtn:SetOnClick(function()
    self:OnTryAgainBtnClick()
  end)
  self.tryAgainBtnText = self:AddComponent(UIText, "Root/btnLayout/TryAgainBtn/TryAgainBtnText")
  self.tryAgainBtnText:SetText(Localization:GetString("134021"))
  self.backBtn = self:AddComponent(UIButton, "Root/btnLayout/BackBtn")
  self.backBtn:SetOnClick(function()
    self:OnBackBtnClick()
  end)
  self.backBtnText = self:AddComponent(UIText, "Root/btnLayout/BackBtn/BackBtnText")
  self.backBtnText:SetText(Localization:GetString("activity_breakthrough_tips_29"))
  self.defeatText = self:AddComponent(UIText, "Root/Top/BattleDefeatPanel_ani/DefeatGo/DefeatText")
  self.defeatText:SetText(Localization:GetString("311106"))
  self.levelText = self:AddComponent(UIText, "Root/Top/LevelText")
  self.space = self:AddComponent(UIBaseContainer, "Root/space")
  self.growGuideScroll = self:AddComponent(UIBaseContainer, "Root/GrowGuideScroll")
  self.videoLink = self:AddComponent(UIBaseContainer, "Root/VideoLink")
  self.videoBtn = self:AddComponent(UIButton, "Root/VideoLink/VideoBtn")
  self.videoBtn:SetOnClick(function()
    self:OnVideoBtnClick()
  end)
  self.videoBtnText = self:AddComponent(UIText, "Root/VideoLink/VideoBtn/VideoBtnText")
  self.videoBtnText:SetText(Localization:GetString("breakthough_tips_06"))
  self.shareBtn = self:AddComponent(UIButton, "ShareBtn")
  self.shareBtn:SetOnClick(function()
    self:OnShareBtnClick()
  end)
  self.btnGroupContainer = self:AddComponent(UIBaseContainer, "Root/btnLayout")
  self.btnGroupLayoutElement = self:AddComponent(UILayoutElement, "Root/btnLayout")
  self.btnGroupLayoutElement:SetIgnoreLayout(false)
  self.growGuidePlaneChange = self:AddComponent(UIGrowthItem, "Root/GrowGuideScroll/Viewport/Content/ChangePlaneContent")
  self.growGuidePlaneEquip = self:AddComponent(UIGrowthItem, "Root/GrowGuideScroll/Viewport/Content/EquipPlaneContent")
  self.resultDetailContent = self:AddComponent(UIBaseContainer, "Root/ResultDetailContent")
  self.resultDetailContent:SetActive(true)
  self.resultKillLabel = self:AddComponent(UITextMeshProUGUIEx, "Root/ResultDetailContent/KillContent/KillLabel")
  self.resultKillLabel:SetLocalText("800303")
  self.resultKillNum = self:AddComponent(UITextMeshProUGUIEx, "Root/ResultDetailContent/KillContent/KillNumTxt")
  self.resultTimeLabel = self:AddComponent(UITextMeshProUGUIEx, "Root/ResultDetailContent/TimeContent/TimeLabel")
  self.resultTimeLabel:SetLocalText("800304")
  self.resultTimeNum = self:AddComponent(UITextMeshProUGUIEx, "Root/ResultDetailContent/TimeContent/TimeNumTxt")
end

function UISkyBattleLoseView:ComponentDestroy()
  self.backBtn = nil
end

function UISkyBattleLoseView:OnRefreshFirstPay()
  self:RefreshView()
end

function UISkyBattleLoseView:RefreshView()
  local param = self:GetUserData()
  local stageId = param.stageId
  local levelTitle = ""
  local levelTitlePrefixKey = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_SkyBattle), stageId, "name")
  local order = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_SkyBattle), stageId, "order")
  levelTitle = Localization:GetString(levelTitlePrefixKey, order)
  self.levelText:SetText(levelTitle)
  self.resultKillNum:SetText(string.format("%d", param.kill or 0))
  self.resultTimeNum:SetText(UITimeManager:GetInstance():SecondToFmtStringWithoutDay(param.time or 0))
  local growthMode = param.growthMode
  if growthMode then
    self.growGuideScroll:SetActive(true)
    self:RefreshGrowGuide()
  else
    self.growGuideScroll:SetActive(false)
  end
  self.shareBtn:SetActive(false)
  self.videoLink:SetActive(false)
  self.backBtn:SetActive(true)
  self.tryAgainBtn:SetActive(true)
  self.btnGroupContainer:SetActive(true)
end

function UISkyBattleLoseView:Show()
end

function UISkyBattleLoseView:RefreshGrowGuide()
  self.growGuidePlaneChange:RefreshView(Localization:GetString("NoKey-Plane"), "450004", self, self.OnPlaneBtnClick)
  self.growGuidePlaneEquip:RefreshView(Localization:GetString("NoKey-Equip"), "450004", self, self.OnPlaneEquipBtnClick)
end

function UISkyBattleLoseView:OnPlaneBtnClick()
  self.ctrl:CloseSelf()
  
  local function afterSwitchScene()
    local data = {
      growMode = true,
      tab = 2,
      guideType = SkyBattleChapterGrowthGuideType.Skin
    }
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWStageSkyBattleChapter) then
      EventManager:GetInstance():Broadcast(EventId.SkyBattleChapterViewRefresh, data)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWStageSkyBattleChapter, {anim = true}, data)
    end
  end
  
  DataCenter.LWBattleManager:Exit(afterSwitchScene, "lose")
end

function UISkyBattleLoseView:OnPlaneEquipBtnClick()
  self.ctrl:CloseSelf()
  
  local function afterSwitchScene()
    local data = {
      growMode = true,
      tab = 2,
      guideType = SkyBattleChapterGrowthGuideType.Slot1
    }
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWStageSkyBattleChapter) then
      EventManager:GetInstance():Broadcast(EventId.SkyBattleChapterViewRefresh, data)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWStageSkyBattleChapter, {anim = true}, data)
    end
  end
  
  DataCenter.LWBattleManager:Exit(afterSwitchScene, "lose")
end

function UISkyBattleLoseView:OnBackBtnClick()
  if self.ctrl then
    self.ctrl:CloseSelf()
  end
  DataCenter.LWBattleManager:GetCurBattleLogic():NoticeLose()
  DataCenter.LWBattleManager:Exit(nil, "lose")
end

function UISkyBattleLoseView:OnVideoBtnClick()
  if self.loseToShowVideoURL then
    Logger.LogInfo("OnVideoBtnClick" .. self.loseToShowVideoURL)
    CS.SDKManager.OpenURL(self.loseToShowVideoURL)
  end
end

function UISkyBattleLoseView:OnTryAgainBtnClick()
  self.ctrl:CloseSelf()
  DataCenter.LWBattleManager:GetCurBattleLogic():NoticeLose()
  DataCenter.LWBattleManager:Restart()
end

function UISkyBattleLoseView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
end

function UISkyBattleLoseView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  base.OnRemoveListener(self)
end

function UISkyBattleLoseView:OnKeyCodeEscape()
  TimerManager:GetInstance():DelayFrameInvoke(function()
    self:OnBackBtnClick()
  end, 1)
end

function UISkyBattleLoseView:OnShareBtnClick()
end

return UISkyBattleLoseView
