local base = UIBaseContainer
local UIBFDsbDuelActScheduleTimeItem = BaseClass("UIBFDsbDuelActScheduleTimeItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIBFDsbDuelActScheduleTimeItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActScheduleTimeItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActScheduleTimeItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compBgL = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.compLine = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.compLight = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.compLightBig = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.btnMid = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnMid:SetOnClick(function()
    self:OnBtnMidClick()
  end)
end

function UIBFDsbDuelActScheduleTimeItem:ComponentDestroy()
  self.viewSkin = nil
  self.compBgL = nil
  self.compLine = nil
  self.compLight = nil
  self.compLightBig = nil
  self.btnMid = nil
end

function UIBFDsbDuelActScheduleTimeItem:DataDefine()
  self.index = 0
  self.curIndex = 0
  self.totalCount = 0
end

function UIBFDsbDuelActScheduleTimeItem:DataDestroy()
  self.index = nil
  self.curIndex = nil
  self.totalCount = nil
end

function UIBFDsbDuelActScheduleTimeItem:OnAddListener()
  base.OnAddListener(self)
end

function UIBFDsbDuelActScheduleTimeItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActScheduleTimeItem:ReInit(index, curIndex, totalCount)
  self.index = index
  self.curIndex = curIndex
  self.totalCount = totalCount
  self.compBgL:SetActive(1 < index)
  self.compLine:SetActive(index <= curIndex)
  if 1 < index and index < totalCount then
    if index < curIndex then
      self.compLine.transform:Set_sizeDelta(0, 18)
    elseif curIndex == index then
      self.compLine.transform:Set_sizeDelta(-19, 18)
    end
  end
  self.compLight:SetActive(index < curIndex)
  self.compLightBig:SetActive(curIndex == index)
end

function UIBFDsbDuelActScheduleTimeItem:OnBtnMidClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelActRules)
end

return UIBFDsbDuelActScheduleTimeItem
