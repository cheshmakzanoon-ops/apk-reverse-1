local RadarAlarmDataManager = BaseClass("RadarAlarmDataManager")
local Setting = CS.GameEntry.Setting
local ASSISTANCE = MarchStatus.ASSISTANCE
local ASSEMBLY_MARCH = NewMarchType.ASSEMBLY_MARCH

local function __init(self)
  self.RadarAlarm = {}
  self.CancelList = {}
  self:AddListener()
end

local function __delete(self)
  self.RadarAlarm = nil
  self.CancelList = nil
  self:RemoveListener()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.MarchItemTargetMeUpdate, self.ResetCancelList)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.MarchItemTargetMeUpdate, self.ResetCancelList)
end

local function GetAllMarches(self)
  local world = CS.SceneManager.World
  if world == nil then
    return {}
  end
  local targetOwnerList = DataCenter.WorldMarchDataManager:GetMarchesTargetForMineLite()
  local list = {}
  if targetOwnerList ~= nil then
    for i, v in pairs(targetOwnerList) do
      if v:GetMarchStatus() ~= ASSISTANCE and v.ownerUid ~= LuaEntry.Player.uid and v.ownerUid ~= "" and v:GetMarchType() ~= ASSEMBLY_MARCH and not v:IsMonster() then
        table.insert(list, v)
      end
    end
  end
  return list
end

local function IsCancel(self, marchUuid)
  return self.CancelList[marchUuid] ~= nil
end

local function InitCancelList(self)
  local cancelStr = Setting:GetString(SettingKeys.CANCEL_MARCH_ALERT_UUIDS, "")
  local vec = string.split(cancelStr, ",")
  table.walk(vec, function(_, v)
    if v ~= nil and v ~= "" then
      self:AddToCancelList(toInt(v), false)
    end
  end)
end

local function SaveCancelList(self)
  local str = ""
  table.walk(self.CancelList, function(k, v)
    if str == "" then
      str = str .. k
    else
      str = str .. "," .. k
    end
  end)
  Setting:SetString(SettingKeys.CANCEL_MARCH_ALERT_UUIDS, str)
end

local function ResetCancelList()
  local targetOwnerList = DataCenter.WorldMarchDataManager:GetMarchesTargetForMineLite()
  local temp = {}
  if targetOwnerList ~= nil then
    table.walk(targetOwnerList, function(k, v)
      if DataCenter.RadarAlarmDataManager:IsCancel(v.uuid) then
        table.insert(temp, v.uuid)
      end
    end)
  end
  DataCenter.RadarAlarmDataManager:ResetCancelListData()
  table.walk(temp, function(k, v)
    DataCenter.RadarAlarmDataManager:AddToCancelList(v, false)
  end)
  local list = DataCenter.RadarAlarmDataManager:GetAllMarches()
  if list then
    EventManager:GetInstance():Broadcast(EventId.NoticeMainViewUpdateMarch)
  end
end

local function AddToCancelList(self, marchUuid, saveFlag)
  self.CancelList[marchUuid] = 1
  if saveFlag then
    self:SaveCancelList()
  end
end

local function InitData(self)
end

local function RemoveToCancelList(self, marchUuid, saveFlag)
  self.CancelList[marchUuid] = nil
end

local function ResetCancelListData(self)
  self.CancelList = {}
end

RadarAlarmDataManager.__init = __init
RadarAlarmDataManager.__delete = __delete
RadarAlarmDataManager.InitData = InitData
RadarAlarmDataManager.GetAllMarches = GetAllMarches
RadarAlarmDataManager.InitCancelList = InitCancelList
RadarAlarmDataManager.SaveCancelList = SaveCancelList
RadarAlarmDataManager.ResetCancelList = ResetCancelList
RadarAlarmDataManager.AddToCancelList = AddToCancelList
RadarAlarmDataManager.IsCancel = IsCancel
RadarAlarmDataManager.AddListener = AddListener
RadarAlarmDataManager.RemoveListener = RemoveListener
RadarAlarmDataManager.ResetCancelListData = ResetCancelListData
RadarAlarmDataManager.RemoveToCancelList = RemoveToCancelList
return RadarAlarmDataManager
