local UIDispatchTaskMainTabGroup = BaseClass("UIDispatchTaskMainTabGroup", UIBaseContainer)
local TabItem = require("UI.UIDispatchTask.Main.Component.UIDispatchTaskMainTabItem")
local base = UIBaseContainer
local TabItemPath = "Assets/Main/Prefabs/UI/DispatchTask/UIDispatchTaskMainTab.prefab"
local title_path = "groupName/groupName"
local tabContainer_path = "activityContainer"

function UIDispatchTaskMainTabGroup:OnCreate()
  base.OnCreate(self)
  self.groupTitle = ""
  self.titleN = self:AddComponent(UIText, title_path)
  self.tabContainerN = self:AddComponent(UIBaseContainer, tabContainer_path)
end

function UIDispatchTaskMainTabGroup:OnDestroy()
  self:SetAllCellDestroy()
  self.titleN = nil
  self.tabContainerN = nil
  self.groupId = nil
  base.OnDestroy(self)
end

function UIDispatchTaskMainTabGroup:RefreshGroup(activityList)
  self.activityList = activityList
  self:RefreshTabs()
end

function UIDispatchTaskMainTabGroup:RefreshTabs()
  self:SetAllCellDestroy()
  self.modelTabs = {}
  self.tabItems = {}
  self.orderedTabItems = {}
  for i, v in ipairs(self.activityList) do
    local activityId = v.id
    self.modelTabs[activityId] = self:GameObjectInstantiateAsync(TabItemPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.tabContainerN.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = activityId
      local cell = self.tabContainerN:AddComponent(TabItem, go.name, activityId)
      cell:SetData()
      self.tabItems[activityId] = cell
      table.insert(self.orderedTabItems, activityId)
      if table.count(self.tabItems) == #self.activityList then
        self.view:OnGroupCellLoadFinish()
      end
    end)
  end
end

function UIDispatchTaskMainTabGroup:SetAllCellDestroy()
  self.tabContainerN:RemoveComponents(TabItem)
  if self.modelTabs ~= nil then
    for k, v in pairs(self.modelTabs) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function UIDispatchTaskMainTabGroup:SelectTab(actId)
  if self.tabItems[actId] then
    self.tabItems[actId]:OnClick()
  end
end

function UIDispatchTaskMainTabGroup:SetUnSelect(id)
  self.tabItems[tostring(id)]:SetUnSelect()
end

function UIDispatchTaskMainTabGroup:SetSelect(id)
  self.tabItems[tostring(id)]:SetSelect()
end

function UIDispatchTaskMainTabGroup:GetActivtyRedCount(id)
  local redNum = 0
  if DataCenter.ActivityListDataManager:IsActivityNew(id) then
    redNum = 1
  else
    local actData = DataCenter.ActivityListDataManager:GetActivityDataById(id)
    if actData then
      redNum = DataCenter.ActivityListDataManager:GetRewardNumByTypeAndId(actData.type, actData.id)
    end
  end
  return redNum
end

local TabWidth = 230
local spacing = 11

function UIDispatchTaskMainTabGroup:OnScrollChanged(originScrollPos, viewSize)
  if not table.IsNullOrEmpty(self.orderedTabItems) then
    local leftRedNum = 0
    local rightRedNum = 0
    local scrollPos = -originScrollPos
    local scrollSize = viewSize
    local scrollLeftPos = scrollPos
    local scrollRightPos = scrollPos + scrollSize
    for index, activityId in pairs(self.orderedTabItems) do
      local leftBoundPos = (index - 1) * TabWidth + (index - 1) * spacing
      local rightBoundPos = index * TabWidth + (index - 1) * spacing
      if scrollLeftPos > rightBoundPos then
        leftRedNum = leftRedNum + GetActivtyRedCount(self, activityId)
      elseif scrollRightPos < leftBoundPos then
        rightRedNum = rightRedNum + GetActivtyRedCount(self, activityId)
      end
    end
    return leftRedNum, rightRedNum
  end
  return 0, 0
end

return UIDispatchTaskMainTabGroup
