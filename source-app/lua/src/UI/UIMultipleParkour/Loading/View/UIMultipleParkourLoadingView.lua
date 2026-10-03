local UIMultipleParkourLoadingView = BaseClass("UIMultipleParkourLoadingView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local DEFAULT_PIC = "UIPveLoading_img01"
local yellow_path = "Yellow"
local left_text_path = "Yellow/Left/LeftText"
local right_text_path = "Yellow/Right/RightText"
local pic_path = "Yellow/Image"
local march_title_path = "Yellow/MarchContent/MarchTitle"
local march_value_path = "Yellow/MarchContent/MarchValue"
local black_path = "Black"
local circle_path = "Circle"
local wait_path = "Wait"
local LONG_WAIT_TIME = 3

local function OnCreate(self)
  base.OnCreate(self)
  local param = self:GetUserData()
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.yellow_anim = self:AddComponent(UIAnimator, yellow_path)
  self.left_text = self:AddComponent(UITextMeshProUGUIEx, left_text_path)
  self.right_text = self:AddComponent(UITextMeshProUGUIEx, right_text_path)
  self.pic_image = self:AddComponent(UIImage, pic_path)
  self.march_title = self:AddComponent(UITextMeshProUGUIEx, march_title_path)
  self.march_value = self:AddComponent(UITextMeshProUGUIEx, march_value_path)
  self.march_title:SetText(Localization:GetString("dev_multiple_stage_05"))
  self.black_anim = self:AddComponent(UIAnimator, black_path)
  self.circle_anim = self:AddComponent(UIAnimator, circle_path)
  self.wait_anim = self:AddComponent(UIAnimator, wait_path)
  self:ReInit()
  self:Enter()
end

local function ComponentDestroy(self)
  self.yellow_anim = nil
  self.left_text = nil
  self.right_text = nil
  self.pic_image = nil
  self.black_anim = nil
  self.circle_anim = nil
  self.wait_anim = nil
  self.march_title = nil
  self.march_value = nil
end

local function DataDefine(self)
  self.animType = nil
  self.waitTimer = nil
  DataCenter.ArrowManager:RemoveArrow()
  DataCenter.ArrowManager:RemoveFingerArrow()
  
  function self.TimerAction()
    self:OnUpdate()
  end
end

local function DataDestroy(self)
  if self.waitTimer then
    self.waitTimer:Stop()
    self.waitTimer = nil
  end
  self.animType = nil
  self:RemoveTimer()
  self.TimerAction = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  local param = self:GetUserData()
  self.animType = param and param.animType
  if self.animType == nil then
    self.animType = PveLoadingAnimType.Yellow
  end
  if self.animType == PveLoadingAnimType.Yellow then
    self.yellow_anim:SetActive(true)
    self.black_anim:SetActive(false)
    self.circle_anim:SetActive(false)
    self.wait_anim:SetActive(false)
    local _, t = UIUtil.PlayAnimationReturnTime(self.yellow_anim.unity_animator, "V_ui_zhuanchang_idle_anim")
    TimerManager:GetInstance():DelayInvoke(function()
      if self.onEntered then
        self.onEntered()
      end
    end, 0.1)
  elseif self.animType == PveLoadingAnimType.Black then
    self.yellow_anim:SetActive(false)
    self.black_anim:SetActive(true)
    self.circle_anim:SetActive(false)
    self.wait_anim:SetActive(false)
    local _, t = UIUtil.PlayAnimationReturnTime(self.black_anim.unity_animator, "V_ui_pve_heipinmu")
    TimerManager:GetInstance():DelayInvoke(function()
      if self.onEntered then
        self.onEntered()
      end
    end, t)
  elseif self.animType == PveLoadingAnimType.Circle then
    self.yellow_anim:SetActive(false)
    self.black_anim:SetActive(false)
    self.circle_anim:SetActive(true)
    self.wait_anim:SetActive(false)
    local _, t = UIUtil.PlayAnimationReturnTime(self.circle_anim.unity_animator, "UIMoving")
    TimerManager:GetInstance():DelayInvoke(function()
      if self.onEntered then
        self.onEntered()
      end
    end, t)
  end
  local tip
  if param and not string.IsNullOrEmpty(param.leftText) then
    self.left_text:SetText(param.leftText)
  elseif tip and not string.IsNullOrEmpty(tip.leftText) then
    self.left_text:SetLocalText(tip.leftText)
  else
    self.left_text:SetLocalText(410000)
  end
  if param and not string.IsNullOrEmpty(param.rightText) then
    self.right_text:SetText(param.rightText)
  elseif tip and not string.IsNullOrEmpty(tip.rightText) then
    self.right_text:SetLocalText(tip.rightText)
  else
    self.right_text:SetLocalText(410100)
  end
  if param and not string.IsNullOrEmpty(param.pic) then
    self.pic_image:LoadSprite(string.format(LoadPath.UIPveLoading, param.pic))
  elseif tip and not string.IsNullOrEmpty(tip.pic) then
    self.pic_image:LoadSprite(string.format(LoadPath.UIPveLoading, tip.pic))
  else
    self.pic_image:LoadSprite(string.format(LoadPath.UIPveLoading, DEFAULT_PIC))
  end
  self.marchCount = param.marchCount
  self.marchTime = param.marchTime
  self.marchCounter = 1
  self.marchTimer = 0
  self.march_value:SetText("1" .. "/" .. self.marchCount)
  self:AddTimer()
end

local function Enter(self)
  local duration = 1
  if self.animType == PveLoadingAnimType.Yellow then
    duration = 0.1
  elseif self.animType == PveLoadingAnimType.Black then
    duration = 1
  elseif self.animType == PveLoadingAnimType.Circle then
    duration = 1
  end
  self.finished = false
  self.quited = false
  TimerManager:GetInstance():DelayInvoke(function()
    self.finished = true
    self:TryClose()
  end, duration)
  if self.animType == PveLoadingAnimType.Black then
    self.waitTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.wait_anim:SetActive(true)
      self.wait_anim:Play("UIMoving", 0, 0)
    end, duration + LONG_WAIT_TIME)
  end
end

local function Quit(self)
  self.quited = true
  self:TryClose()
end

local function TryClose(self)
  if self.finished and self.quited then
    if self.waitTimer then
      self.wait_anim:SetActive(false)
      self.waitTimer:Stop()
      self.waitTimer = nil
    end
    self:Close()
  end
end

local function Close(self)
  if self.onClosed then
    self.onClosed()
    self.onClosed = nil
  end
  self.yellow_anim:SetActive(false)
  self.black_anim:SetActive(false)
  self.circle_anim:SetActive(false)
  self.wait_anim:SetActive(false)
  self.ctrl:CloseSelf()
end

local function SetOnEntered(self, onEntered)
  self.onEntered = onEntered
end

local function SetOnClosed(self, onClosed)
  self.onClosed = onClosed
end

function UIMultipleParkourLoadingView:AddTimer()
  self:RemoveTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
  end
  self.timer:Start()
end

function UIMultipleParkourLoadingView:RemoveTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIMultipleParkourLoadingView:OnUpdate()
  self.marchTimer = self.marchTimer + 1
  local pro = math.min(1, self.marchTimer / self.marchTime)
  self.marchCounter = math.min(self.marchCount, math.floor(self.marchCount * pro))
  self.march_value:SetText(self.marchCounter .. "/" .. self.marchCount)
end

UIMultipleParkourLoadingView.OnCreate = OnCreate
UIMultipleParkourLoadingView.OnDestroy = OnDestroy
UIMultipleParkourLoadingView.ComponentDefine = ComponentDefine
UIMultipleParkourLoadingView.ComponentDestroy = ComponentDestroy
UIMultipleParkourLoadingView.DataDefine = DataDefine
UIMultipleParkourLoadingView.DataDestroy = DataDestroy
UIMultipleParkourLoadingView.OnEnable = OnEnable
UIMultipleParkourLoadingView.OnDisable = OnDisable
UIMultipleParkourLoadingView.OnAddListener = OnAddListener
UIMultipleParkourLoadingView.OnRemoveListener = OnRemoveListener
UIMultipleParkourLoadingView.ReInit = ReInit
UIMultipleParkourLoadingView.Enter = Enter
UIMultipleParkourLoadingView.Quit = Quit
UIMultipleParkourLoadingView.TryClose = TryClose
UIMultipleParkourLoadingView.Close = Close
UIMultipleParkourLoadingView.SetOnEntered = SetOnEntered
UIMultipleParkourLoadingView.SetOnClosed = SetOnClosed
return UIMultipleParkourLoadingView
