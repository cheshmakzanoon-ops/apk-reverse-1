local UIGuideCommunicationTalkView = BaseClass("UIGuideCommunicationTalkView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "GuideTalkBtn"
local talk_des_path = "BottomGo/DesBg/TalkDes"
local head_icon_path = "BottomGo/HeadGo/HeadBg/HeadIcon"
local btn_arrow_path = "BottomGo/ArrowGo/UIGuide_talk_arrow_yellow"
local anim_path = "BottomGo"
local AnimState = {
  Show = "V_ui_xinhaoganrao_show_anim",
  Idle = "V_ui_xinhaoganrao_idle_anim",
  Close = "V_ui_xinhaoganrao_close_anim",
  Switch = "V_ui_xinhaoganrao_switch_anim",
  Click = ""
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.talk_des = self:AddComponent(UIText, talk_des_path)
  self.btn_arrow = self:AddComponent(UIBaseContainer, btn_arrow_path)
  self.head_icon = self:AddComponent(UIImage, head_icon_path)
  self.anim = self:AddComponent(UIAnimator, anim_path)
  self.panel:SetOnClick(function()
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.panel = nil
  self.talk_des = nil
  self.btn_arrow = nil
  self.head_icon = nil
  self.anim = nil
end

local function DataDefine(self)
  self.template = nil
  
  function self.timer_action()
    self:TimerAction()
  end
  
  self.delayCloseTimer = nil
  
  function self.can_close_timer_action()
    self:CanCloseTimerAction()
  end
  
  function self.auto_to_do_next_timer_action()
    self:AutoDoNextTimerAction()
  end
  
  self.canCloseTimer = nil
  self.canClose = true
  self.animState = AnimState.Show
  self.autoDoNextTimer = nil
  self.param = {}
end

local function DataDestroy(self)
  self:DeleteAutoDoNextTimer()
  self:DeleteTimer()
  self:DeleteCanCloseTimer()
  self.template = nil
  self.timer_action = nil
  self.delayCloseTimer = nil
  self.can_close_timer_action = nil
  self.auto_to_do_next_timer_action = nil
  self.canCloseTimer = nil
  self.canClose = nil
  self.animState = nil
  self.autoDoNextTimer = nil
  self.param = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self:Refresh()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
  self:AddUIListener(EventId.RefreshGuideAnim, self.RefreshGuideAnimSignal)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
  self:RemoveUIListener(EventId.RefreshGuideAnim, self.RefreshGuideAnimSignal)
end

local function Refresh(self)
  self.gameObject:SetActive(true)
  self.template = DataCenter.GuideManager:GetCurTemplate()
  if self.template ~= nil and self.template.type == GuideType.ShowCommunicationTalk then
    self:SetParam()
    local time = self.template:GetAutoDoNextTime()
    if time ~= nil and 0 < time then
      self:AddAutoDoNextTimer(time / 1000)
    end
    self.talk_des:SetText(self.param.dialog)
    self.head_icon:LoadSprite(string.format(LoadPath.Guide, self.param.modelName))
    if self.modelName == nil then
      self:DoAnim(AnimState.Show)
    elseif self.modelName ~= self.param.modelName then
      self:DoAnim(AnimState.Switch)
    end
    self.modelName = self.param.modelName
    if self.template.para3 == nil or self.template.para3 == "" then
      self.btn_arrow:SetActive(true)
      self.canClose = true
    else
      self.btn_arrow:SetActive(false)
      self.canClose = false
      self:AddCanCloseTimer(tonumber(self.template.para3) / 1000)
    end
  end
end

local function RefreshGuideSignal(self)
  self:DeleteTimer()
  self:DeleteAutoDoNextTimer()
  self.template = DataCenter.GuideManager:GetCurTemplate()
  if self.template ~= nil and self.template.type == GuideType.ShowCommunicationTalk then
    self:SetParam()
    if self.modelName ~= self.param.modelName then
      self.gameObject:SetActive(false)
    end
  else
    self:DoAnim(AnimState.Close)
  end
end

local function OnBtnClick(self)
  if self.canClose then
    self.canClose = false
    self:DeleteAutoDoNextTimer()
    local nextType = DataCenter.GuideManager:GetNextGuideTemplateParam("type")
    if nextType == GuideType.ShowCommunicationTalk then
      self:DoAnim(AnimState.Click)
    else
      self:DoAnim(AnimState.Close)
    end
  end
end

local function AddDelayTimer(self, time)
  self:DeleteTimer()
  self.delayCloseTimer = TimerManager:GetInstance():GetTimer(time, self.timer_action, self, true, false, false)
  self.delayCloseTimer:Start()
end

local function TimerAction(self)
  self:DeleteTimer()
  if self.animState == AnimState.Close then
    if self.template ~= nil and self.template.type == GuideType.ShowCommunicationTalk then
      DataCenter.GuideManager:HasClick(panel_path)
    end
    self.ctrl:CloseSelf()
  elseif self.animState == AnimState.Click then
    DataCenter.GuideManager:HasClick(panel_path)
  elseif self.animState == AnimState.Show then
    self:DoAnim(AnimState.Idle)
  elseif self.animState == AnimState.Switch then
    self:DoAnim(AnimState.Idle)
  end
end

local function DeleteTimer(self)
  if self.delayCloseTimer then
    self.delayCloseTimer:Stop()
    self.delayCloseTimer = nil
  end
end

local function RefreshGuideAnimSignal(self)
  self:Refresh()
end

local function AddCanCloseTimer(self, time)
  self:DeleteCanCloseTimer()
  self.canCloseTimer = TimerManager:GetInstance():GetTimer(time, self.can_close_timer_action, self, true, false, false)
  self.canCloseTimer:Start()
end

local function CanCloseTimerAction(self)
  self:DeleteCanCloseTimer()
  self.canClose = true
  self.btn_arrow:SetActive(true)
end

local function DeleteCanCloseTimer(self)
  if self.canCloseTimer then
    self.canCloseTimer:Stop()
    self.canCloseTimer = nil
  end
end

local function AddAutoDoNextTimer(self, time)
  self:DeleteAutoDoNextTimer()
  self.autoDoNextTimer = TimerManager:GetInstance():GetTimer(time, self.auto_to_do_next_timer_action, self, true, false, false)
  self.autoDoNextTimer:Start()
end

local function AutoDoNextTimerAction(self)
  self.canClose = true
  DataCenter.GuideManager:SetNoGotoTime(true)
  self:DeleteAutoDoNextTimer()
  self:OnBtnClick()
end

local function DeleteAutoDoNextTimer(self)
  if self.autoDoNextTimer then
    self.autoDoNextTimer:Stop()
    self.autoDoNextTimer = nil
  end
end

local function DoAnim(self, stateName)
  self.animState = stateName
  if stateName == AnimState.Click then
    self:TimerAction()
  else
    local ret, time = self.anim:PlayAnimationReturnTime(stateName)
    if ret and 0 < time then
      self:AddDelayTimer(time)
    else
      self:TimerAction()
    end
  end
end

local function SetParam(self)
  self.param = {}
  if self.template ~= nil and self.template.para2 ~= nil then
    local spl = string.split(self.template.para2, ",")
    if 1 < #spl then
      self.param.dialog = Localization:GetString(spl[1])
      self.param.modelName = spl[2]
    end
  end
end

UIGuideCommunicationTalkView.OnCreate = OnCreate
UIGuideCommunicationTalkView.OnDestroy = OnDestroy
UIGuideCommunicationTalkView.OnEnable = OnEnable
UIGuideCommunicationTalkView.OnDisable = OnDisable
UIGuideCommunicationTalkView.OnAddListener = OnAddListener
UIGuideCommunicationTalkView.OnRemoveListener = OnRemoveListener
UIGuideCommunicationTalkView.ComponentDefine = ComponentDefine
UIGuideCommunicationTalkView.ComponentDestroy = ComponentDestroy
UIGuideCommunicationTalkView.DataDefine = DataDefine
UIGuideCommunicationTalkView.DataDestroy = DataDestroy
UIGuideCommunicationTalkView.ReInit = ReInit
UIGuideCommunicationTalkView.Refresh = Refresh
UIGuideCommunicationTalkView.RefreshGuideSignal = RefreshGuideSignal
UIGuideCommunicationTalkView.OnBtnClick = OnBtnClick
UIGuideCommunicationTalkView.AddDelayTimer = AddDelayTimer
UIGuideCommunicationTalkView.TimerAction = TimerAction
UIGuideCommunicationTalkView.DeleteTimer = DeleteTimer
UIGuideCommunicationTalkView.RefreshGuideAnimSignal = RefreshGuideAnimSignal
UIGuideCommunicationTalkView.AddCanCloseTimer = AddCanCloseTimer
UIGuideCommunicationTalkView.CanCloseTimerAction = CanCloseTimerAction
UIGuideCommunicationTalkView.DeleteCanCloseTimer = DeleteCanCloseTimer
UIGuideCommunicationTalkView.AddAutoDoNextTimer = AddAutoDoNextTimer
UIGuideCommunicationTalkView.AutoDoNextTimerAction = AutoDoNextTimerAction
UIGuideCommunicationTalkView.DeleteAutoDoNextTimer = DeleteAutoDoNextTimer
UIGuideCommunicationTalkView.DoAnim = DoAnim
UIGuideCommunicationTalkView.SetParam = SetParam
return UIGuideCommunicationTalkView
