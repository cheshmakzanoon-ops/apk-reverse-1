local UIBattleResultFrontBreakVictoryView = BaseClass("UIBattleResultFrontBreakVictoryView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIBattleResultFrontBreakVictoryView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIBattleResultFrontBreakVictoryView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBattleResultFrontBreakVictoryView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgHead = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textTxtSoldierNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textTxtTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTxtStage = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTxtExceedNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.btnReturn = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnReturn:SetOnClick(function()
    self:OnBtnReturnClick()
  end)
  self.textTxtReturn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnShare = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnShare:SetOnClick(function()
    self:OnBtnShareClick()
  end)
  self.animatorUIBattleResultFrontBreakVictory = self.viewSkin:AddComponent(self, UIAnimator, 9)
  self.textTxtTitle:SetLocalText("311105")
end

function UIBattleResultFrontBreakVictoryView:ComponentDestroy()
  self.viewSkin = nil
  self.imgHead = nil
  self.textTxtSoldierNum = nil
  self.textTxtTitle = nil
  self.textTxtStage = nil
  self.textTxtExceedNum = nil
  self.btnReturn = nil
  self.textTxtReturn = nil
  self.btnShare = nil
  self.animatorUIBattleResultFrontBreakVictory = nil
end

function UIBattleResultFrontBreakVictoryView:DataDefine()
  local hasAni, animTime = self.animatorUIBattleResultFrontBreakVictory:GetAnimationReturnTime("CommonPopup_movein")
  if hasAni and 0 < animTime then
    self.interactableBtns = false
    self.aniTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.interactableBtns = true
    end, animTime)
  else
    self.interactableBtns = true
  end
end

function UIBattleResultFrontBreakVictoryView:DataDestroy()
  if self.EscTimer then
    self.EscTimer:Stop()
    self.EscTimer = nil
  end
  if self.aniTimer then
    self.aniTimer:Stop()
    self.aniTimer = nil
    self.interactableBtns = false
  end
  if self.scoreTween then
    self.scoreTween:Kill()
  end
  self.scoreTween = nil
end

function UIBattleResultFrontBreakVictoryView:RefreshView()
  local param = self:GetUserData()
  local stageId = param.stageId
  local tableName = LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature)
  local stageOrder = GetTableData(tableName, stageId, "order")
  self.textTxtStage:SetText(Localization:GetString(GetTableData(tableName, stageId, "name"), stageOrder))
  DataCenter.LWSoundManager:PlaySound(10027)
  if param.fromHelpResult then
    self.textTxtReturn:SetLocalText("100178")
  elseif param.enterType == PVEEnterType.StageFeatureScene then
    self.textTxtReturn:SetLocalText("plane_chapter_btn_01")
  else
    self.textTxtReturn:SetLocalText("800306")
  end
  if self.scoreTween then
    self.scoreTween:Kill()
  end
  self.tempScore = 0
  self.textTxtSoldierNum:SetText("X 0")
  self.scoreTween = CS.DG.Tweening.DOTween.To(function()
    return self.tempScore
  end, function(value)
    self.tempScore = value
    self.textTxtSoldierNum:SetText("X " .. math.floor(value))
  end, param.score, 1):SetEase(CS.DG.Tweening.Ease.OutQuad):SetDelay(0.5):OnComplete(function()
    self.textTxtSoldierNum:SetText("X " .. param.score)
  end)
  self.textTxtExceedNum:SetText(string.format("<size=32><color=#ffffff>%s</color></size> <size=36><color=#fec939>%s</color></size> <size=32><color=#ffffff>%s</color></size>", Localization:GetString("800827"), param.rank, Localization:GetString("800828")))
end

function UIBattleResultFrontBreakVictoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
end

function UIBattleResultFrontBreakVictoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  base.OnRemoveListener(self)
end

function UIBattleResultFrontBreakVictoryView:OnBtnReturnClick()
  if not self.interactableBtns then
    return
  end
  local param = self:GetUserData()
  if param.fromHelpResult then
    self.ctrl:CloseSelf()
    return
  end
  if param.enterType == PVEEnterType.StageFeatureScene then
    DataCenter.LWBattleManager:SetBattleExitFlag(true)
  end
  self.ctrl:CloseSelf()
  DataCenter.LWBattleManager:Exit(nil, "win")
end

function UIBattleResultFrontBreakVictoryView:OnBtnShareClick()
  if not self.interactableBtns then
    return
  end
  local stage_share_time = CommonUtil.PlayerPrefsGetLong(SettingKeys.STAGE_FEATURE_SHARE_TIME, 0)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaMinTime = LuaEntry.DataConfig:TryGetNum("Breakthrough_config", "k3", 0) * 1000
  if curTime <= stage_share_time + deltaMinTime then
    UIUtil.ShowTips(Localization:GetString("breakthough_tips_03"))
    return
  end
  local param = self:GetUserData()
  local shareParam = {}
  shareParam.post = PostType.STAGE_FEATURE_CHAPTER
  shareParam.param = {}
  local stageId = param.stageId or 0
  shareParam.param.stageId = stageId
  local stageOrder = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), stageId, "order") or 0
  shareParam.param.stageOrder = stageOrder
  shareParam.param.fromChapter = true
  shareParam.param.score = param.score or 0
  shareParam.param.rank = param.rank or 0
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, shareParam)
end

function UIBattleResultFrontBreakVictoryView:OnKeyCodeEscape()
  if not self.interactableBtns then
    return
  end
  if self.EscTimer ~= nil then
    return
  end
  self.EscTimer = TimerManager:GetInstance():DelayFrameInvoke(function()
    self:OnBtnReturnClick()
    self.EscTimer = nil
  end, 1)
end

return UIBattleResultFrontBreakVictoryView
