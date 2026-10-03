local base = UIBaseContainer
local UIDriverTipBubbleComponent = BaseClass("UIDriverTipBubbleComponent", UIBaseContainer)

function UIDriverTipBubbleComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIDriverTipBubbleComponent:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDriverTipBubbleComponent:ComponentDefine()
  self.driverTipsBtn = self:AddComponent(UIButton, "")
  self.driverTipsBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITrainDriverRemind)
  end)
  self.head = self:AddComponent(UICommonHead, "bubble/Head")
end

function UIDriverTipBubbleComponent:ComponentDestroy()
  self.driverTipsBtn = nil
  self.head = nil
end

function UIDriverTipBubbleComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIDriverTipBubbleComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIDriverTipBubbleComponent:Show()
  self.head:SetAsMyself()
  self:SetActive(true)
end

function UIDriverTipBubbleComponent:CheckActive()
  local isShow, isShowBubble, bubbleMsg, isShowDriverBubble = RailwayUtil.UIMainBLBtnTrainCheckEnable()
  if isShowDriverBubble then
    self:Show()
  else
    self:Hide()
  end
end

function UIDriverTipBubbleComponent:Hide()
  self:SetActive(false)
end

return UIDriverTipBubbleComponent
