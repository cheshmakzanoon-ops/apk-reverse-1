local UILUISheepCloudView = BaseClass("UILUISheepCloudView", UIBaseView)
local base = UIBaseView
local FIRST_ANIM_LENGTH = 0.7
local SECOND_ANIM_LENGTH = 1.3

function UILUISheepCloudView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function UILUISheepCloudView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UILUISheepCloudView:ComponentDefine()
  self.theCanvas = self:AddComponent(UICanvas, "")
  self.anim = self:AddComponent(UISimpleAnimation, "anims")
end

function UILUISheepCloudView:ComponentDestroy()
  self.theCanvas = nil
  self.anim = nil
end

function UILUISheepCloudView:DataDefine()
  self.midAction, self.holdFunc = self:GetUserData()
  self.firstAnimFinish = false
end

function UILUISheepCloudView:DataDestroy()
  self.midAction = nil
  self.holdFunc = nil
  self.toServerId = nil
  self.firstAnimFinish = nil
end

function UILUISheepCloudView:OnEnable()
  base.OnEnable(self)
  if self.theCanvas then
    self.theCanvas:SetOverrideSorting(true)
    self.theCanvas:SetSortingOrder(CanvasOrder.Cloud)
  end
end

function UILUISheepCloudView:OnDisable()
  base.OnDisable(self)
end

function UILUISheepCloudView:Init()
  self.anim:Play("Default")
  if self.holdFunc then
    TimerManager:GetInstance():DelayInvoke(function()
      if self.midAction then
        self.midAction()
        self.midAction = nil
      end
      self.firstAnimFinish = true
      self:Update1000MS()
    end, FIRST_ANIM_LENGTH)
  else
    TimerManager:GetInstance():DelayInvoke(function()
      if self.midAction then
        self.midAction()
        self.midAction = nil
      end
      if self.anim then
        self.anim:Play("Diffuse")
      end
    end, FIRST_ANIM_LENGTH)
    TimerManager:GetInstance():DelayInvoke(function()
      if self.ctrl then
        self.ctrl:CloseSelf()
      end
    end, FIRST_ANIM_LENGTH + SECOND_ANIM_LENGTH)
  end
end

function UILUISheepCloudView:Update1000MS()
  if self.firstAnimFinish and self.anim and self.holdFunc and self.holdFunc() then
    self.anim:Play("Diffuse")
    TimerManager:GetInstance():DelayInvoke(function()
      self.ctrl:CloseSelf()
    end, SECOND_ANIM_LENGTH)
    self.holdFunc = nil
  end
end

return UILUISheepCloudView
