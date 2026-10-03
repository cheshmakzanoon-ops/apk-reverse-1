local WorkerTemplate = BaseClass("WorkerTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = 0
  self.first_name = ""
  self.last_name = ""
  self.quality = 0
  self.appearance = 0
  self.power = 0
  self.isShow = 0
  self.star = 0
  self.worker_dialog_idle = nil
  self.effectData = {}
  self.workingBuildList = {}
  self.workingBuildMap = {}
end

local function __delete(self)
  self.id = nil
  self.first_name = nil
  self.last_name = nil
  self.quality = nil
  self.appearance = nil
  self.power = nil
  self.isShow = nil
  self.star = nil
  self.worker_dialog_idle = nil
  self.effectData = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.first_name = row:getValue("first_name")
  self.last_name = row:getValue("last_name")
  self.appearance = tonumber(row:getValue("appearance")) or 0
  self.power = tonumber(row:getValue("power")) or 0
  self.isShow = tonumber(row:getValue("isShow")) or 0
  self.star = tonumber(row:getValue("star")) or 0
  self.quality = tonumber(row:getValue("quality")) or 0
  self.worker_dialog_idle = row:getValue("worker_dialog_idle")
  local effect = row:getValue("effect") or {}
  self.effectData = effect
  self.effects = effect
  self.workingBuildList = row:getValue("working_building") or {}
  for i, itemId in pairs(self.workingBuildList) do
    self.workingBuildMap[itemId] = true
  end
end

local function GetName(self)
  return Localization:GetString(self.first_name) .. " " .. Localization:GetString(self.last_name)
end

WorkerTemplate.__init = __init
WorkerTemplate.__delete = __delete
WorkerTemplate.InitData = InitData
WorkerTemplate.GetName = GetName
return WorkerTemplate
