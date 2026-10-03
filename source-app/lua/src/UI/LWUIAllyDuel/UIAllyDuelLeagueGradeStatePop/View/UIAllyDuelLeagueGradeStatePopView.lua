local UIAllyDuelLeagueGradeStatePopView = BaseClass("UIAllyDuelLeagueGradeStatePopView", UIBaseView)
local base = UIBaseView
local ActMgr = DataCenter.LeagueMatchManager

function UIAllyDuelLeagueGradeStatePopView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAllyDuelLeagueGradeStatePopView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllyDuelLeagueGradeStatePopView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.cupBg = self.viewSkin:AddComponent(self, UIRawImage, 3)
  self.cup = self.viewSkin:AddComponent(self, UIRawImage, 4)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textGrade = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textState = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textGradeGroup = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.compDown = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.compUp = self.viewSkin:AddComponent(self, UIBaseComponent, 10)
  self.animator = self.viewSkin:AddComponent(self, UIAnimator, 11)
end

function UIAllyDuelLeagueGradeStatePopView:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.btnBack = nil
  self.cupBg = nil
  self.cup = nil
  self.textTitle = nil
  self.textGrade = nil
  self.textState = nil
  self.textGradeGroup = nil
  self.compDown = nil
  self.compUp = nil
  self.animator = nil
end

function UIAllyDuelLeagueGradeStatePopView:DataDefine()
  local lastInfo = DataCenter.LeagueMatchManager:GetMyCurDuelInfo(true)
  if table.IsNullOrEmpty(lastInfo) then
    Logger.Log("<color=#FF0000>[UIAllyDuelLeagueGradeStatePopView] last duel info is null</color>")
    self.ctrl:CloseSelf()
    return
  end
  self.curSegment = ActMgr:GetSegment()
  self.lastSegment = ActMgr:GetSegment(true)
  local baseInfo = ActMgr:GetLeagueMatchBaseInfo()
  self.curSeason = baseInfo ~= nil and baseInfo.season or 1
  ActMgr:SignGradeChangePop()
  self.curStep = 0
  local ret, time = self.animator:PlayAnimationReturnTime("V_ui_UIAllyDuelLeagueGradePop_in")
  if ret then
    self:RefreshUI(true)
    self.isPlaying = true
    self.animTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.animTimer ~= nil then
        self.animTimer:Stop()
        self.animTimer = nil
      end
      self.curStep = 1
      self.isPlaying = false
      self.nextDelay = TimerManager:GetInstance():DelayInvoke(function()
        self:PlayNext()
      end, 2)
    end, time)
  else
    self:RefreshUI()
    self.curStep = 2
    self.isPlaying = false
  end
end

function UIAllyDuelLeagueGradeStatePopView:DataDestroy()
  if self.animTimer ~= nil then
    self.animTimer:Stop()
    self.animTimer = nil
  end
  if self.nextDelay ~= nil then
    self.nextDelay:Stop()
    self.nextDelay = nil
  end
  if self.refreshDelay ~= nil then
    self.refreshDelay:Stop()
    self.refreshDelay = nil
  end
end

function UIAllyDuelLeagueGradeStatePopView:OnAddListener()
  base.OnAddListener(self)
end

function UIAllyDuelLeagueGradeStatePopView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAllyDuelLeagueGradeStatePopView:OnBtnPanelClick()
  self:DoCloseSelf()
end

function UIAllyDuelLeagueGradeStatePopView:OnBtnBackClick()
  self:DoCloseSelf()
end

function UIAllyDuelLeagueGradeStatePopView:DoCloseSelf()
  if self.isPlaying then
    return
  end
  if self.curStep == 1 then
    self:PlayNext()
    return
  end
  self.ctrl:CloseSelf()
end

function UIAllyDuelLeagueGradeStatePopView:PlayNext()
  if self.nextDelay ~= nil then
    self.nextDelay:Stop()
    self.nextDelay = nil
  end
  local state = 0
  if self.curSegment > self.lastSegment then
    state = 1
  elseif self.curSegment < self.lastSegment then
    state = -1
  end
  local anim = "V_ui_UIAllyDuelLeagueGradePop_guarantee"
  if 0 < state then
    anim = "V_ui_UIAllyDuelLeagueGradePop_promotion"
  elseif state < 0 then
    anim = "V_ui_UIAllyDuelLeagueGradePop_downgarde"
  end
  local ret, time = self.animator:PlayAnimationReturnTime(anim)
  if ret then
    self.isPlaying = true
    self.curStep = 2
    self.refreshDelay = TimerManager:GetInstance():DelayFrameInvoke(function()
      if self.refreshDelay ~= nil then
        self.refreshDelay:Stop()
        self.refreshDelay = nil
      end
      self:RefreshUI()
    end, 5)
    self.animTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.animTimer ~= nil then
        self.animTimer:Stop()
        self.animTimer = nil
      end
      self.isPlaying = false
    end, time)
  else
    self.isPlaying = false
  end
end

function UIAllyDuelLeagueGradeStatePopView:RefreshUI(bLast)
  local season = bLast and self.curSeason - 1 or self.curSeason
  self.textTitle:SetLocalText("459001", season)
  ActMgr:SetCup(self.cup, self.cupBg, self.textGradeGroup, bLast)
  local _, _, curName = ActMgr:GetGroupName(bLast)
  self.textGrade:SetText(curName)
  local segment = bLast and self.lastSegment or self.curSegment
  local segmentColor
  if segment == SegmentType.Silver then
    segmentColor = "7CF1FA"
  elseif segment == SegmentType.Gold then
    segmentColor = "F9DD56"
  else
    segmentColor = "D2C8FF"
  end
  local color = UIUtil.HexToColor(segmentColor)
  self.textGrade:SetColor(color)
  self.textGradeGroup:SetColor(color)
  local state = 0
  if bLast then
    self.textState:SetActive(false)
    return
  end
  self.textState:SetActive(true)
  local stateKey = "alliance_duel_tips11007"
  local stateColor = "FFFFFF"
  if self.curSegment > self.lastSegment then
    stateKey = "alliance_duel_tips11005"
    stateColor = "F9DD56"
    state = 1
  elseif self.curSegment < self.lastSegment then
    stateKey = "alliance_duel_tips11006"
    stateColor = "EA6C5B"
    state = -1
  end
  color = UIUtil.HexToColor(stateColor)
  self.compDown:SetActive(state < 0)
  self.compUp:SetActive(0 < state)
  self.textState:SetColor(color)
  self.textState:SetLocalText(stateKey)
end

return UIAllyDuelLeagueGradeStatePopView
