local base = UIBaseContainer
local UIActBountyHunterGuideComponent = BaseClass("UIActBountyHunterGuideComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local Const = require("UI/UIActivityCenterTable/Component/ActBountyHunter/BountyHunterConstant")
local GuideState = {Plot = 0, WaitClickBtn = 1}

function UIActBountyHunterGuideComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActBountyHunterGuideComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActBountyHunterGuideComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.simpleAnimationRect = self.viewSkin:AddComponent(self, UISimpleAnimation, 1)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.simpleAnimationRoot = self.viewSkin:AddComponent(self, UISimpleAnimation, 3)
  self.textActName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.simpleAnimationLoad = self.viewSkin:AddComponent(self, UISimpleAnimation, 5)
  self.textLoad = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.btnLWCommonNew = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnLWCommonNew:SetOnClick(function()
    self:OnBtnLWCommonNewClick()
  end)
  self.textBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.compCover = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.compEdge = self.viewSkin:AddComponent(self, UIBaseComponent, 10)
  self.textTitle:SetLocalText("activity_hunter_entrance_title")
  self.textLoad:SetLocalText("activity_hunter_entrance_desc1")
  self.textBtn:SetLocalText("activity_hunter_entrance_desc2")
  self.btnLWCommonNew:SetActive(false)
  self.compEdge:SetActive(true)
end

function UIActBountyHunterGuideComponent:ComponentDestroy()
  self.viewSkin = nil
  self.simpleAnimationRect = nil
  self.textTitle = nil
  self.simpleAnimationRoot = nil
  self.textActName = nil
  self.simpleAnimationLoad = nil
  self.textLoad = nil
  self.btnLWCommonNew = nil
  self.textBtn = nil
  self.compCover = nil
  self.compEdge = nil
end

function UIActBountyHunterGuideComponent:DataDefine()
  self.delayPlayPlotTimer = nil
  self.delayShowEnterTimer = nil
  self.delayCloseTimer = nil
  self.onEnterClick = nil
  self.activityId = nil
  self.isCanEnter = false
end

function UIActBountyHunterGuideComponent:OnDisable()
  base.OnDisable(self)
  self:StopAllTimer()
end

function UIActBountyHunterGuideComponent:DataDestroy()
  if self.delayPlayPlotTimer then
    self.delayPlayPlotTimer:Stop()
    self.delayPlayPlotTimer = nil
  end
  if self.delayShowEnterTimer then
    self.delayShowEnterTimer:Stop()
    self.delayShowEnterTimer = nil
  end
  if self.delayCloseTimer then
    self.delayCloseTimer:Stop()
    self.delayCloseTimer = nil
  end
  self.onEnterClick = nil
  self.activityId = nil
  self.isCanEnter = nil
end

function UIActBountyHunterGuideComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIActBountyHunterGuideComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActBountyHunterGuideComponent:ReInit(activityId, onEnterClick, isCanEnter, onGuideClose)
  self.guideState = GuideState.Plot
  self.activityId = activityId
  self.onEnterClick = onEnterClick
  self.isCanEnter = isCanEnter
  self.onGuideClose = onGuideClose
  self.simpleAnimationLoad:SetActive(false)
  self.btnLWCommonNew:SetActive(false)
  self:SetActive(true)
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.activityData = DataCenter.BountyHunterActDataManager:GetActData(self.activityId)
  if self.activityInfo ~= nil then
    self.textActName:SetLocalText(self.activityInfo.name)
  end
  local ret, inAnimTime = self.simpleAnimationRect:PlayAnimationReturnTime("In")
  self.simpleAnimationRect:PlayQueued("Idle")
  self.simpleAnimationRoot:Play("in")
  self.simpleAnimationRoot:PlayQueued("loop")
  if self.delayPlayPlotTimer then
    self.delayPlayPlotTimer:Stop()
    self.delayPlayPlotTimer = nil
  end
  if ret then
    self.delayPlayPlotTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.activityData == nil then
        self:OnPlotFinish()
        return
      end
      self.activityData:TriggerGuide(function()
        self:OnPlotFinish()
      end)
    end, inAnimTime)
  end
  self:StartCheckAutoSkipPlotTimer()
end

function UIActBountyHunterGuideComponent:OnPlotFinish()
  if self.simpleAnimationLoad == nil or self.btnLWCommonNew == nil then
    return
  end
  self.simpleAnimationLoad:SetActive(true)
  self.simpleAnimationLoad:Play("In")
  self.simpleAnimationLoad:PlayQueued("Idle")
  if self.delayShowEnterTimer then
    self.delayShowEnterTimer:Stop()
    self.delayShowEnterTimer = nil
  end
  self.delayShowEnterTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.simpleAnimationLoad:SetActive(false)
    self.btnLWCommonNew:SetActive(true)
    if self.autoShowSkipBtnTimer then
      self.autoShowSkipBtnTimer:Stop()
      self.autoShowSkipBtnTimer = nil
    end
  end, Const.FIRST_GUIDE_ENTER_DELAY)
  self.autoEnterSceneTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:AutoEnterScene()
  end, Const.AUTO_ENTER_SCENE)
  if self.autoClosePlotTimer then
    self.autoClosePlotTimer:Stop()
    self.autoClosePlotTimer = nil
  end
  self:StartCheckAutoEnterSceneTimer()
  self:StartAutoShowSkipBtnTimer()
end

function UIActBountyHunterGuideComponent:OnBtnLWCommonNewClick()
  if self.isCanEnter then
    local isCanEnter = self.isCanEnter()
    if isCanEnter then
      self.btnLWCommonNew:SetActive(false)
      self.compEdge:SetActive(false)
      if self.onEnterClick then
        self.onEnterClick()
      end
      self.simpleAnimationRoot:Play("out")
      local ret, time = self.simpleAnimationRect:PlayAnimationReturnTime("Out")
      if ret then
        self.delayCloseTimer = TimerManager:GetInstance():DelayInvoke(function()
          if self.onGuideClose then
            self.onGuideClose()
          end
        end, time)
      end
    end
  end
end

function UIActBountyHunterGuideComponent:StartAutoShowSkipBtnTimer()
  if self.autoShowSkipBtnTimer then
    self.autoShowSkipBtnTimer:Stop()
    self.autoShowSkipBtnTimer = nil
  end
  local showSkipBtnTime = self.activityData and self.activityData:GetSkipBtnShowTime() or Const.SHOW_SKIP_BTN_TIME
  self.autoShowSkipBtnTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.btnLWCommonNew then
      self.btnLWCommonNew:SetActive(true)
    end
    Logger.LogInfo("UIActBountyHunterGuideComponent Auto Show Btn")
  end, showSkipBtnTime)
end

function UIActBountyHunterGuideComponent:StartCheckAutoSkipPlotTimer()
  if self.autoClosePlotTimer then
    self.autoClosePlotTimer:Stop()
    self.autoClosePlotTimer = nil
  end
  local skipPlotTime = self.activityData and self.activityData:GetAutoSkipPlotTime() or Const.AUTO_BREAK_GUIDE_TIME
  self.autoClosePlotTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:BreakPlotGuide()
  end, skipPlotTime)
end

function UIActBountyHunterGuideComponent:StartCheckAutoEnterSceneTimer()
  if self.autoEnterSceneTimer then
    self.autoEnterSceneTimer:Stop()
    self.autoEnterSceneTimer = nil
  end
  local enterSceneTime = self.activityData and self.activityData:GetAutoEnterSceneTime() or Const.AUTO_ENTER_SCENE
  self.autoEnterSceneTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:AutoEnterScene()
  end, enterSceneTime)
end

function UIActBountyHunterGuideComponent:BreakPlotGuide()
  self:StopAllTimer()
  self.activityData:BreakGuide()
  self:StartCheckAutoEnterSceneTimer()
  self:StartAutoShowSkipBtnTimer()
  Logger.LogInfo("UIActBountyHunterGuideComponent:BreakPlotGuide")
end

function UIActBountyHunterGuideComponent:AutoEnterScene()
  if self.onEnterClick then
    self.onEnterClick()
  end
  if self.onGuideClose then
    self.onGuideClose()
  end
  Logger.LogInfo("UIActBountyHunterGuideComponent:AutoEnterScene")
end

function UIActBountyHunterGuideComponent:StopAllTimer()
  if self.delayPlayPlotTimer then
    self.delayPlayPlotTimer:Stop()
    self.delayPlayPlotTimer = nil
  end
  if self.delayShowEnterTimer then
    self.delayShowEnterTimer:Stop()
    self.delayShowEnterTimer = nil
  end
  if self.delayCloseTimer then
    self.delayCloseTimer:Stop()
    self.delayCloseTimer = nil
  end
  if self.autoClosePlotTimer then
    self.autoClosePlotTimer:Stop()
    self.autoClosePlotTimer = nil
  end
  if self.autoEnterSceneTimer then
    self.autoEnterSceneTimer:Stop()
    self.autoEnterSceneTimer = nil
  end
  if self.autoShowSkipBtnTimer then
    self.autoShowSkipBtnTimer:Stop()
    self.autoShowSkipBtnTimer = nil
  end
end

return UIActBountyHunterGuideComponent
