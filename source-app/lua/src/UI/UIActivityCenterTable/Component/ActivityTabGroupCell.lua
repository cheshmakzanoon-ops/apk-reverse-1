local ActivityTabGroupCell = BaseClass("ActivityTabGroupCell", UIBaseContainer)
local ActivityListItem = require("UI.UIActivityCenterTable.Component.ActivityListItem")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local title_path = "groupName/groupName"
local tabContainer_path = "activityContainer"

local function OnCreate(self, id)
  base.OnCreate(self)
  self.groupTitle = ""
  self.titleN = self:AddComponent(UIText, title_path)
  self.tabContainerN = self:AddComponent(UIBaseContainer, tabContainer_path)
end

local function OnDestroy(self)
  self:SetAllCellDestroy()
  self.titleN = nil
  self.tabContainerN = nil
  self.groupId = nil
  base.OnDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function RefreshGroup(self, group)
  self.groupId = group.tabGroup
  self.activityList = group.activityList
  self.titleN:SetLocalText(self.groupId)
  self:RefreshTabs()
end

local function RefreshTabs(self)
  self:SetAllCellDestroy()
  self.modelTabs = {}
  self.tabItems = {}
  self.orderedTabItems = {}
  local property = self.view:GetAssetLoadProperty(UIAssets.UIActivityListItem)
  for i, v in ipairs(self.activityList) do
    local activityId = v.id
    self.modelTabs[activityId] = self:GameObjectInstantiateAsync(UIAssets.UIActivityListItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.tabContainerN.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = activityId
      local cell = self.tabContainerN:AddComponent(ActivityListItem, go.name, activityId)
      cell:SetData()
      self.tabItems[activityId] = cell
      table.insert(self.orderedTabItems, activityId)
      if table.count(self.tabItems) == #self.activityList then
        self.view:OnGroupCellLoadFinish()
      end
    end, property)
  end
end

local function SetAllCellDestroy(self)
  self.tabContainerN:RemoveComponents(ActivityListItem)
  if self.modelTabs ~= nil then
    for k, v in pairs(self.modelTabs) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

local function SelectTab(self, actId)
  if self.tabItems[actId] then
    self.tabItems[actId]:OnClick()
  end
end

local function SetUnSelect(self, id)
  self.tabItems[id]:SetUnSelect()
end

local function SetSelect(self, id)
  self.tabItems[id]:SetSelect()
end

local function GetActivtyRedCount(self, id)
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

local function OnScrollChanged(self, originScrollPos, viewSize)
  if not table.IsNullOrEmpty(self.orderedTabItems) then
    local leftRedNum = 0
    local rightRedNum = 0
    local scrollPos = -originScrollPos * CommonUtil.ArabicAutoMirrorFactor()
    local scrollSize = viewSize
    local scrollLeftPos = CommonUtil.IsArabicAutoMirrorOpen() and scrollPos - scrollSize or scrollPos
    local scrollRightPos = CommonUtil.IsArabicAutoMirrorOpen() and scrollPos or scrollPos + scrollSize
    for index, activityId in pairs(self.orderedTabItems) do
      local leftBoundPos = CommonUtil.IsArabicAutoMirrorOpen() and -(index * TabWidth + (index - 1) * spacing) or (index - 1) * TabWidth + (index - 1) * spacing
      local rightBoundPos = CommonUtil.IsArabicAutoMirrorOpen() and -((index - 1) * TabWidth + (index - 1) * spacing) or index * TabWidth + (index - 1) * spacing
      if scrollLeftPos > rightBoundPos then
        if CommonUtil.IsArabicAutoMirrorOpen() then
          rightRedNum = rightRedNum + GetActivtyRedCount(self, activityId)
        else
          leftRedNum = leftRedNum + GetActivtyRedCount(self, activityId)
        end
      elseif scrollRightPos < leftBoundPos then
        if CommonUtil.IsArabicAutoMirrorOpen() then
          leftRedNum = leftRedNum + GetActivtyRedCount(self, activityId)
        else
          rightRedNum = rightRedNum + GetActivtyRedCount(self, activityId)
        end
      end
    end
    return leftRedNum, rightRedNum
  end
  return 0, 0
end

ActivityTabGroupCell.OnCreate = OnCreate
ActivityTabGroupCell.OnDestroy = OnDestroy
ActivityTabGroupCell.OnAddListener = OnAddListener
ActivityTabGroupCell.OnRemoveListener = OnRemoveListener
ActivityTabGroupCell.RefreshGroup = RefreshGroup
ActivityTabGroupCell.RefreshTabs = RefreshTabs
ActivityTabGroupCell.SelectTab = SelectTab
ActivityTabGroupCell.SetAllCellDestroy = SetAllCellDestroy
ActivityTabGroupCell.SetUnSelect = SetUnSelect
ActivityTabGroupCell.SetSelect = SetSelect
ActivityTabGroupCell.OnScrollChanged = OnScrollChanged
return ActivityTabGroupCell
