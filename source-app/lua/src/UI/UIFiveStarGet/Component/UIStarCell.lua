local UIStarCell = BaseClass("UIStarCell", UIBaseContainer)
local base = UIBaseContainer

function UIStarCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIStarCell:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIStarCell:ComponentDefine()
  self.starBtn = self:AddComponent(UIButton, "")
  self.starIcon = self:AddComponent(UIImage, "startIcon")
  self.starBtn:SetOnClick(function()
    self.view:OnStartClick(self.index)
  end)
end

function UIStarCell:ComponentDestroy()
  self.starBtn = nil
  self.starIcon = nil
end

function UIStarCell:InitData(index)
  self.index = index
end

function UIStarCell:IconSetActive(isOn)
  self.starIcon:SetActive(isOn)
end

return UIStarCell
