local UILWMainTaskTitleSubItem = BaseClass("UILWMainTaskTitleSubItem", UIBaseContainer)
local base = UIBaseContainer
local main_title_path = "mainTitle"
local other_title_path = "otherTitle"

function UILWMainTaskTitleSubItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWMainTaskTitleSubItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMainTaskTitleSubItem:ComponentDefine()
  self.main_title = self:AddComponent(UIBaseContainer, main_title_path)
  self.other_title = self:AddComponent(UIBaseContainer, other_title_path)
end

function UILWMainTaskTitleSubItem:ComponentDestroy()
  self.main_title = nil
  self.other_title = nil
end

function UILWMainTaskTitleSubItem:ReInit(data)
  self.main_title:SetActive(data.titleType == 1)
  self.other_title:SetActive(data.titleType == 2)
end

return UILWMainTaskTitleSubItem
