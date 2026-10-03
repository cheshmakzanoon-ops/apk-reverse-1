local FunctionOnManager = BaseClass("FunctionOnManager")
local FunctionOnData = require("DataCenter.FunctionOnManager.FunctionOnData")

local function __init(self)
  self:AddListener()
  self.data = {}
end

local function __delete(self)
  self.data = nil
  self:RemoveListener()
end

local function AddListener(self)
end

local function RemoveListener(self)
end

local function InitData(self, message)
  self.data = {}
  for _, value in pairs(FunctionOnType) do
    self.data[value] = {}
    local cfg1 = ""
    if value == FunctionOnType.FestivalEntrance then
      cfg1 = LuaEntry.DataConfig:TryGetStr("funcion_on_config", "k1")
    elseif value == FunctionOnType.Activity then
      cfg1 = LuaEntry.DataConfig:TryGetStr("funcion_on_config", "k2")
    end
    if not string.IsNullOrEmpty(cfg1) then
      local tab1 = string.split(cfg1, "|")
      for _, cfg2 in ipairs(tab1) do
        local functionOnData = FunctionOnData.New()
        functionOnData:InitData(value, cfg2)
        table.insert(self.data[value], functionOnData)
      end
    end
  end
  self:HandlePushImmediateToggleType(message)
end

local function GetOpenDataByLevel(self, level)
  level = tostring(level)
  local data
  for _, functionOnDataList in ipairs(self.data) do
    for _, functionOnData in ipairs(functionOnDataList) do
      local iconData = functionOnData:GetIconData()
      if functionOnData.level == level and iconData then
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

local function GetNeedWaitById(self, type, id)
  id = tostring(id)
  local isFind = false
  local isNeed = false
  local dataList = self.data[type]
  if dataList then
    for key, value in ipairs(dataList) do
      for key2, value2 in ipairs(value.iconDataList) do
        if value2.id == id then
          isNeed = value.needWait
          isFind = true
          break
        end
        if isFind then
          break
        end
      end
    end
  end
  return isNeed
end

local function RefreshNeedWait(self, level)
  for _, functionOnDataList in ipairs(self.data) do
    for _, functionOnData in ipairs(functionOnDataList) do
      local iconData = functionOnData:GetIconData()
      if functionOnData.level == tostring(level) and iconData then
        local oldNeedWait = functionOnData.needWait
        functionOnData:RefreshNeedWait()
        local newNeedWait = functionOnData.needWait
        if oldNeedWait and not newNeedWait and functionOnData.type == FunctionOnType.Activity then
          DataCenter.ActivityListDataManager:SetLastVisitedActivityId(iconData.id)
        end
        break
      end
    end
  end
end

local function HandlePushImmediateToggleType(self, t)
  self.immediate_toggle = t.immediate_toggle
  self:SyncImmediateSwitch()
end

local function IsServerSwitchOn(self, serverSwitch)
  return self.immediate_toggle ~= nil and self.immediate_toggle & 1 << serverSwitch > 0
end

local function DumpServerSwitchOn(self)
  if self.immediate_toggle == nil then
    return "all off"
  end
  local ret = ""
  for k, v in pairs(ServerSwitch) do
    if self:IsServerSwitchOn(v) then
      ret = ret .. k .. "(" .. v .. "):" .. "true\n"
    else
      ret = ret .. k .. "(" .. v .. "):" .. "false\n"
    end
  end
  return ret
end

function FunctionOnManager:SyncImmediateSwitch()
  if CS.GameEntry.Data and CS.GameEntry.Data.Player then
    CS.GameEntry.Data.Player:SyncImmediateSwitch(self.immediate_toggle)
  end
  if Vector3 then
    Vector3.RefreshUsePool()
  end
  if SceneUtils then
    SceneUtils.RefreshUsePool()
  end
end

FunctionOnManager.__init = __init
FunctionOnManager.__delete = __delete
FunctionOnManager.AddListener = AddListener
FunctionOnManager.RemoveListener = RemoveListener
FunctionOnManager.InitData = InitData
FunctionOnManager.GetOpenDataByLevel = GetOpenDataByLevel
FunctionOnManager.RefreshNeedWait = RefreshNeedWait
FunctionOnManager.GetNeedWaitById = GetNeedWaitById
FunctionOnManager.IsServerSwitchOn = IsServerSwitchOn
FunctionOnManager.DumpServerSwitchOn = DumpServerSwitchOn
FunctionOnManager.HandlePushImmediateToggleType = HandlePushImmediateToggleType
return FunctionOnManager
