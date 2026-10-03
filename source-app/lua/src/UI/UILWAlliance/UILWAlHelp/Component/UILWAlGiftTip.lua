local UILWAlGiftTip = BaseClass("UILWAlGiftTip", UIAsyncContainer)
local base = UIAsyncContainer
local click_btn_path = "Btn"

function UILWAlGiftTip:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlGiftTip:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlGiftTip:ComponentDefine()
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    self:OnClick()
  end)
end

function UILWAlGiftTip:ComponentDestroy()
  self.clickBtn = nil
end

function UILWAlGiftTip:DataDefine()
end

function UILWAlGiftTip:DataDestroy()
end

function UILWAlGiftTip:OnEnable()
  base.OnEnable(self)
end

function UILWAlGiftTip:OnDisable()
  base.OnDisable(self)
end

function UILWAlGiftTip:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlGiftTip:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAlGiftTip:OnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceGift, {anim = true, hideTop = true})
end

return UILWAlGiftTip
