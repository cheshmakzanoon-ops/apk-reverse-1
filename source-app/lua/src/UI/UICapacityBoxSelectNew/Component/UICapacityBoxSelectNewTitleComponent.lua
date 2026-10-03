local base = UIBaseContainer
local UICapacityBoxSelectNewTitleComponent = BaseClass("UICapacityBoxSelectNewTitleComponent", UIBaseContainer)

function UICapacityBoxSelectNewTitleComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UICapacityBoxSelectNewTitleComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICapacityBoxSelectNewTitleComponent:ComponentDefine()
  self.btnArrow = self:AddComponent(UIButton, "ArrowButton")
  self.btnArrow:SetOnClick(function()
    self:OnBtnArrowClick()
  end)
  self.btnArrow.transform:Set_localEulerAngles(ResetEulerAngles.x, ResetEulerAngles.y, -90)
end

function UICapacityBoxSelectNewTitleComponent:ComponentDestroy()
  self.btnArrow = nil
end

function UICapacityBoxSelectNewTitleComponent:DataDefine()
  self.arrowClickCallback = nil
  self.isArrowDown = true
end

function UICapacityBoxSelectNewTitleComponent:DataDestroy()
  self.arrowClickCallback = nil
  self.isArrowDown = nil
end

function UICapacityBoxSelectNewTitleComponent:SetArrowClickCallback(callback)
  self.arrowClickCallback = callback
end

function UICapacityBoxSelectNewTitleComponent:OnBtnArrowClick()
  if self.arrowClickCallback ~= nil then
    self.arrowClickCallback()
  end
  local targetZ = self.isArrowDown and 0 or -90
  self.isArrowDown = not self.isArrowDown
  self.btnArrow.transform:DOKill()
  self.btnArrow.transform:DOLocalRotate(Vector3.New(0, 0, targetZ), 0.2)
end

return UICapacityBoxSelectNewTitleComponent
