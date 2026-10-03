local CommonEquipTemplateManager = BaseClass("CommonEquipTemplateManager")
local SquadEquipTemplate = require("DataCenter.CommonEquipDataManager.SquadEquipTemplate")
local LwSquadEquipLvTemplate = require("DataCenter/CommonEquipDataManager/LwSquadEquipLvTemplate")

local function __init(self)
  self.templateDic = {}
  self.researchTemplateGroupInitFlag = {}
end

local function __delete(self)
  self.templateDic = nil
  self.researchTemplateGroupMap = nil
  self.researchTemplateGroupInitFlag = nil
end

local function GetTemplate(self, id)
  if self.templateDic and self.templateDic[id] then
    return self.templateDic[id]
  end
  local lineData = LocalController:instance():tryGetLine(TableName.LW_Squad_Equip, id)
  if lineData == nil then
    return nil
  end
  local template = SquadEquipTemplate.New()
  template:UpdateData(lineData)
  self.templateDic[id] = template
  return template
end

function CommonEquipTemplateManager:GetTemplateListBySlot(slot)
  local list = {}
  LocalController:instance():visitTable(TableName.LW_Squad_Equip, function(id, lineData)
    if lineData.slot == slot then
      table.insert(list, self:GetTemplate(id))
    end
  end)
  return list
end

function CommonEquipTemplateManager:GetResearchTemplateGroup(groupId)
  if self.researchTemplateGroupMap then
    local group = self.researchTemplateGroupMap[groupId]
    if self.researchTemplateGroupInitFlag[groupId] == nil and group ~= nil then
      self.researchTemplateGroupInitFlag[groupId] = 1
      local tempList = {}
      for i, id in ipairs(group) do
        local template = LwSquadEquipLvTemplate.New()
        local lineData = LocalController:instance():getLine(TableName.LW_Squad_Equip_Lv, id)
        template:UpdateData(lineData)
        table.insert(tempList, template)
      end
      table.sort(tempList, function(a, b)
        return a.order < b.order
      end)
      self.researchTemplateGroupMap[groupId] = tempList
    end
    return self.researchTemplateGroupMap[groupId]
  end
  self.researchTemplateGroupMap = {}
  LocalController:instance():visitTable(TableName.LW_Squad_Equip_Lv, function(id, lineData)
    local group = self.researchTemplateGroupMap[lineData.group]
    group = group or {}
    table.insert(group, id)
    self.researchTemplateGroupMap[lineData.group] = group
  end)
  return self:GetResearchTemplateGroup(groupId)
end

CommonEquipTemplateManager.__init = __init
CommonEquipTemplateManager.__delete = __delete
CommonEquipTemplateManager.InitAllTemplate = InitAllTemplate
CommonEquipTemplateManager.GetTemplate = GetTemplate
return CommonEquipTemplateManager
