local WorkerAttrOverviewSubItem = BaseClass("WorkerAttrOverviewSubItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function WorkerAttrOverviewSubItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function WorkerAttrOverviewSubItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function WorkerAttrOverviewSubItem:ComponentDefine()
  self.root = self:AddComponent(UIBaseContainer, "")
  self.bg = self:AddComponent(UIBaseContainer, "BG")
  self.name = self:AddComponent(UIText, "Content/name")
  self.value = self:AddComponent(UIText, "Content/value")
end

function WorkerAttrOverviewSubItem:ComponentDestroy()
  self.root = nil
  self.name = nil
  self.value = nil
  self.detailBtn = nil
end

function WorkerAttrOverviewSubItem:DataDefine()
end

function WorkerAttrOverviewSubItem:DataDestroy()
end

function WorkerAttrOverviewSubItem:OnBtnClick()
end

function WorkerAttrOverviewSubItem:Refresh(strData, index)
  self.strData = strData
  self.index = index
  self.name:SetText(self.strData.name)
  self.value:SetText(self.strData.value)
  self.bg:SetActive(index % 2 == 0)
end

return WorkerAttrOverviewSubItem
