local VIPTemplateManager = BaseClass("VIPTemplateManager", Singleton)
local VipTemplate = require("DataCenter.VIPData.VipTemplate")

local function __init(self)
  self.vipDatas = {}
  self.maxLevel = 0
end

local function __delete(self)
  self.vipDatas = nil
  self.maxLevel = nil
end

local function InitAllTemplate(self)
  local level = 0
  LocalController:instance():visitTable(TableName.Vip, function(id, lineData)
    local item = VipTemplate.New()
    item:InitData(lineData)
    if self.vipDatas[item.id] == nil then
      level = item.level
      self.vipDatas[item.id] = item
    end
  end)
  self.maxLevel = #self.vipDatas
end

local function GetAllTemplate(self)
  if self.vipDatas ~= nil then
    return self.vipDatas
  end
end

local function GetTemplate(self, level)
  if self.vipDatas[level] == nil then
    local oneTemplate = LocalController:instance():getLine(TableName.Vip, level)
    if oneTemplate ~= nil then
      local item = VipTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.vipDatas[item.id] = item
      end
    end
  end
  return self.vipDatas[level]
end

local function GetFormatAffectValue(self, data)
  if tonumber(data.num_type) == 1 then
    return "+" .. data.value .. "%"
  elseif tonumber(data.num_type) == 2 then
    if data.value == 0 then
      return "+" .. 0 .. "%"
    else
      return "+" .. data.value / 10 .. "%"
    end
  elseif tonumber(data.num_type) == 0 then
    return "+" .. data.value
  elseif tonumber(data.num_type) == 3 then
    return ""
  end
end

VIPTemplateManager.__init = __init
VIPTemplateManager.__delete = __delete
VIPTemplateManager.InitAllTemplate = InitAllTemplate
VIPTemplateManager.GetAllTemplate = GetAllTemplate
VIPTemplateManager.GetTemplate = GetTemplate
VIPTemplateManager.GetFormatAffectValue = GetFormatAffectValue
return VIPTemplateManager
