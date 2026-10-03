local base = UIBaseContainer
local UICapacityBoxSelectNewDecorationAttributeCellComponent = BaseClass("UICapacityBoxSelectNewDecorationAttributeCellComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UICapacityBoxSelectNewDecorationAttributeCellComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UICapacityBoxSelectNewDecorationAttributeCellComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICapacityBoxSelectNewDecorationAttributeCellComponent:ComponentDefine()
  self.compBgBlack = self:AddComponent(UIBaseContainer, "BgBlack")
  self.textTitle = self:AddComponent(UIText, "Title")
  self.textCur = self:AddComponent(UIText, "DetailLayout/CurText")
  self.compArrow = self:AddComponent(UIBaseContainer, "DetailLayout/Arrow")
  self.textNext = self:AddComponent(UIText, "DetailLayout/NextText")
  self.compLayout = self:AddComponent(UIBaseContainer, "DetailLayout")
end

function UICapacityBoxSelectNewDecorationAttributeCellComponent:ComponentDestroy()
  self.compBgBlack = nil
  self.textTitle = nil
  self.textCur = nil
  self.compArrow = nil
  self.textNext = nil
  self.compLayout = nil
end

function UICapacityBoxSelectNewDecorationAttributeCellComponent:DataDefine()
end

function UICapacityBoxSelectNewDecorationAttributeCellComponent:DataDestroy()
end

function UICapacityBoxSelectNewDecorationAttributeCellComponent:ReInit(info)
  self.textTitle:SetText(info.name)
  self.textCur:SetActive(info.curValue ~= nil)
  if info.curValue ~= nil then
    self.textCur:SetText(tostring(info.curValue))
  end
  self.textNext:SetActive(info.addValue ~= nil)
  if info.addValue ~= nil then
    self.textNext:SetText(tostring(info.addValue))
  end
  self.compArrow:SetActive(info.curValue ~= nil and info.addValue ~= nil)
  self.compBgBlack:SetActive(info.showBlack)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compLayout.transform)
end

function UICapacityBoxSelectNewDecorationAttributeCellComponent:OnAddListener()
  base.OnAddListener(self)
end

function UICapacityBoxSelectNewDecorationAttributeCellComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

return UICapacityBoxSelectNewDecorationAttributeCellComponent
