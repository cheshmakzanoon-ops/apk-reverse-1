local GroupChatSetTemplateManager = BaseClass("GroupChatSetTemplateManager")
local GroupChatSetTemplate = require("DataCenter.GroupChatSetTemplateManager.GroupChatSetTemplate")

local function __init(self)
  self.templateDic = nil
  self.groupToGroupType = nil
end

local function __delete(self)
  self.templateDic = nil
  self.groupToGroupType = nil
end

local function InitTempData(self)
  self.templateDic = {}
  self.groupToGroupType = {}
  local tempList = {}
  LocalController:instance():visitTable(TableName.ChatRoom, function(id, lineData)
    if ChatGroupType[lineData.groupType] then
      local template = GroupChatSetTemplate.New()
      template:InitData(lineData)
      self.templateDic[template.groupType] = template
      table.insert(tempList, template)
    end
  end)
  if 0 < #tempList then
    table.sort(tempList, function(a, b)
      local _a = a.sort or 0
      local _b = b.sort or 0
      return _a < _b
    end)
  end
  for k, v in ipairs(tempList) do
    if self.groupToGroupType[v.group] == nil then
      self.groupToGroupType[v.group] = {}
    end
    table.insert(self.groupToGroupType[v.group], v.groupType)
  end
end

local function TryInitTempData(self)
  if ChatGroupType == nil then
    return
  end
  if self.templateDic == nil or not self.groupToGroupType then
    self:InitTempData()
  end
end

local function GetTempByGroupType(self, groupType)
  self:TryInitTempData()
  return self.templateDic[groupType]
end

function GroupChatSetTemplateManager:GetAllChatGroup()
  self:TryInitTempData()
  return self.groupToGroupType
end

function GroupChatSetTemplateManager:GetGroupAllRoom(group)
  if not group then
    return
  end
  self:TryInitTempData()
  return self.groupToGroupType[group]
end

function GroupChatSetTemplateManager:GetCanShowHelpBubble(group)
  if not group then
    return
  end
  self:TryInitTempData()
  if self.templateDic[group] and self.templateDic[group].help_bubble >= 1 then
    return true
  end
  return false
end

function GroupChatSetTemplateManager:GetShareSort(group)
  self:TryInitTempData()
  if self.templateDic[group] then
    return self.templateDic[group].sort
  end
  return 1000
end

function GroupChatSetTemplateManager:GetIsCanShow(group)
  return self:GetShareSort(group) < 1000
end

GroupChatSetTemplateManager.__init = __init
GroupChatSetTemplateManager.__delete = __delete
GroupChatSetTemplateManager.InitTempData = InitTempData
GroupChatSetTemplateManager.TryInitTempData = TryInitTempData
GroupChatSetTemplateManager.GetTempByGroupType = GetTempByGroupType
return GroupChatSetTemplateManager
