local UITWSkillChipBookContainer = BaseClass("UITWSkillChipBookContainer", UIBaseContainer)
local base = UIBaseContainer
local UITWSkillChipGroupItem = require("UI.UILWTWSkillChip.UILWTWSkillChipBook.Component.UITWSkillChipGroupItem")
local group_scroll_path = "GroupScroll"
local content_path = "GroupScroll/Viewport/Content"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function GetItemNameSequence(self)
  NameCount = NameCount + 1
  return tostring(NameCount)
end

local function ClearScroll(self)
  if self.group_scroll then
    self.group_scroll_content:RemoveComponents(UITWSkillChipGroupItem)
    self.group_scroll:ClearAllItems()
  end
end

local function OnDestroy(self)
  ClearScroll(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function GetScrollItem(self, listview, index)
  local chipList = self.chipList
  index = index + 1
  if index < 1 or index > #chipList then
    return nil
  end
  local item = listview:NewListViewItem("GroupItem")
  local script = self.group_scroll_content:GetComponent(item.gameObject.name, UITWSkillChipGroupItem)
  if script == nil then
    local nameStr = GetItemNameSequence(self)
    item.gameObject.name = nameStr
    script = self.group_scroll_content:AddComponent(UITWSkillChipGroupItem, nameStr)
  end
  script:SetData(chipList[index], index)
  script:SetOnChildExpandFinish(self.childExpandFinishCallback)
  return item
end

local function DataDefine(self)
  self.childExpandFinishCallback = BindCallback(self, self.OnChildExpandFinish)
end

local function DataDestroy(self)
  self.hasInit = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function ComponentDefine(self)
  self.group_scroll = self:AddComponent(UILoopListView2, group_scroll_path)
  self.group_scroll:InitListView(0, function(listview, index)
    return GetScrollItem(self, listview, index)
  end)
  self.group_scroll_content = self:AddComponent(UIBaseContainer, content_path)
end

local function ComponentDestroy(self)
end

local function OnChildExpandFinish(self, index)
  self.group_scroll:OnItemSizeChanged(index - 1)
end

local function Init(self)
  if not self.hasInit then
    self.hasInit = true
    self.chipList = DataCenter.TWSkillChipTemplateManager:GetTemplatesByType()
    self.group_scroll:SetListItemCount(#self.chipList, false, false)
  end
end

UITWSkillChipBookContainer.OnCreate = OnCreate
UITWSkillChipBookContainer.OnDestroy = OnDestroy
UITWSkillChipBookContainer.OnEnable = OnEnable
UITWSkillChipBookContainer.OnDisable = OnDisable
UITWSkillChipBookContainer.DataDefine = DataDefine
UITWSkillChipBookContainer.DataDestroy = DataDestroy
UITWSkillChipBookContainer.ComponentDefine = ComponentDefine
UITWSkillChipBookContainer.ComponentDestroy = ComponentDestroy
UITWSkillChipBookContainer.OnChildExpandFinish = OnChildExpandFinish
UITWSkillChipBookContainer.Init = Init
return UITWSkillChipBookContainer
