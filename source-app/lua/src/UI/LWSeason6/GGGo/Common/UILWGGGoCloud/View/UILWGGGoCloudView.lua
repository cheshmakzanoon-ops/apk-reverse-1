local UILWGGGoCloudView = BaseClass("UILWGGGoCloudView", UIBaseView)
local base = UIBaseView
local FIRST_ANIM_LENGTH = 0.5
local SECOND_ANIM_LENGTH = 1.1

function UILWGGGoCloudView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
  DataCenter.LWSoundManager:PlaySound(5100019, false)
end

function UILWGGGoCloudView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UILWGGGoCloudView:ComponentDefine()
  self.theCanvas = self:AddComponent(UICanvas, "")
  self.anim = self:AddComponent(UISimpleAnimation, "anims")
end

function UILWGGGoCloudView:ComponentDestroy()
  self.theCanvas = nil
  self.anim = nil
end

function UILWGGGoCloudView:DataDefine()
  self.midAction, self.holdFunc, self.tickUpdate = self:GetUserData()
  self.firstAnimFinish = false
end

function UILWGGGoCloudView:DataDestroy()
  self.midAction = nil
  self.holdFunc = nil
  self.toServerId = nil
  self.firstAnimFinish = nil
end

function UILWGGGoCloudView:OnEnable()
  base.OnEnable(self)
  if self.theCanvas then
    self.theCanvas:SetOverrideSorting(true)
    self.theCanvas:SetSortingOrder(CanvasOrder.Cloud)
  end
end

function UILWGGGoCloudView:OnDisable()
  base.OnDisable(self)
end

function UILWGGGoCloudView:Init()
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

function UILWGGGoCloudView:TickLogic()
  if self.firstAnimFinish and self.anim and self.holdFunc and self.holdFunc() then
    self.anim:Play("Diffuse")
    TimerManager:GetInstance():DelayInvoke(function()
      if self.ctrl then
        self.ctrl:CloseSelf()
      end
    end, SECOND_ANIM_LENGTH)
    self.holdFunc = nil
  end
end

function UILWGGGoCloudView:Update1000MS()
  if self.tickUpdate then
    return
  end
  self:TickLogic()
end

function UILWGGGoCloudView:Update()
  if not self.tickUpdate then
    return
  end
  self:TickLogic()
end

return UILWGGGoCloudView
