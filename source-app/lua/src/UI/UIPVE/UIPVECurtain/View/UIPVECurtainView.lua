local UIPVECurtain = BaseClass("UIPVECurtain", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local root_path = "Root"
local title_path = "Root/Bottom/TitleMask/Title"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.root_anim = self:AddComponent(UIAnimator, root_path)
  self.title_text = self:AddComponent(UIText, title_path)
end

local function ComponentDestroy(self)
  self.root_anim = nil
  self.title_text = nil
end

local function DataDefine(self)
  self.active = false
  self.callback = nil
end

local function DataDestroy(self)
  self.active = nil
  self.callback = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
  self:ReInit()
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  local param = self:GetUserData()
  self.title_text:SetText(param.title)
  self.callback = param.callback
  local _, duration = self.root_anim:PlayAnimationReturnTime("UIPVECurtainShow")
  TimerManager:GetInstance():DelayInvoke(function()
    if self.active then
      if self.callback then
        self.callback()
      end
      self.ctrl:CloseSelf()
    end
  end, duration)
end

UIPVECurtain.OnCreate = OnCreate
UIPVECurtain.OnDestroy = OnDestroy
UIPVECurtain.OnEnable = OnEnable
UIPVECurtain.OnDisable = OnDisable
UIPVECurtain.ComponentDefine = ComponentDefine
UIPVECurtain.ComponentDestroy = ComponentDestroy
UIPVECurtain.DataDefine = DataDefine
UIPVECurtain.DataDestroy = DataDestroy
UIPVECurtain.OnAddListener = OnAddListener
UIPVECurtain.OnRemoveListener = OnRemoveListener
UIPVECurtain.ReInit = ReInit
return UIPVECurtain
