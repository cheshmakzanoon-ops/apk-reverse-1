local FunctionOnData = BaseClass("FunctionOnData")
local FunctionOnIconData = require("DataCenter.FunctionOnManager.FunctionOnIconData")

local function __init(self)
  self.type = FunctionOnType.FestivalEntrance
  self.level = 0
  self.needWait = false
  self.iconDataList = {}
  self:AddListener()
end

local function __delete(self)
  self:RemoveListener()
end

local function AddListener(self)
end

local function RemoveListener(self)
end

local function InitData(self, type, cfg)
  if string.IsNullOrEmpty(cfg) then
    return
  end
  local cfgTab = string.split(cfg, ";")
  self.type = type
  self.level = cfgTab[1]
  self.needWait = DataCenter.BuildManager.MainLv < tonumber(self.level)
  local idList = {}
  if cfgTab[2] then
    idList = string.split(cfgTab[2], ",")
  end
  if self.type == FunctionOnType.FestivalEntrance then
    for index, value in ipairs(idList) do
      local iconData = FunctionOnIconData.New()
      local id = value
      local name = cfgTab[3]
      local icon = ""
      if not string.IsNullOrEmpty(cfgTab[4]) then
        icon = cfgTab[4]
      end
      iconData:InitData(id, name, icon)
      table.insert(self.iconDataList, iconData)
    end
  elseif self.type == FunctionOnType.Activity then
    for index, value in ipairs(idList) do
      local iconData = FunctionOnIconData.New()
      local id = value
      local actCfg = LocalController:instance():getLine(TableName.Activity, id)
      if actCfg then
        local name = actCfg.name
        local icon = ""
        if not string.IsNullOrEmpty(actCfg.icon) then
          icon = string.format(LoadPath.ActivityIconPath, actCfg.icon)
        end
        iconData:InitData(id, name, icon)
      end
      table.insert(self.iconDataList, iconData)
    end
  end
end

local function GetIconData(self)
  local data
  local actList = DataCenter.ActivityListDataManager:GetNowActivityList(false)
  for _, actInfo in pairs(actList) do
    local check
    if self.type == FunctionOnType.FestivalEntrance then
      check = actInfo.festivalEntrance
    elseif self.type == FunctionOnType.Activity then
      check = actInfo.id
    end
    for _, iconData in ipairs(self.iconDataList) do
      if check and iconData.id == tostring(check) then
        data = iconData
        break
      end
    end
    if data then
      break
    end
  end
  return data
end

local function RefreshNeedWait(self)
  self.needWait = DataCenter.BuildManager.MainLv < tonumber(self.level)
end

FunctionOnData.__init = __init
FunctionOnData.__delete = __delete
FunctionOnData.AddListener = AddListener
FunctionOnData.RemoveListener = RemoveListener
FunctionOnData.InitData = InitData
FunctionOnData.GetIconData = GetIconData
FunctionOnData.RefreshNeedWait = RefreshNeedWait
return FunctionOnData
