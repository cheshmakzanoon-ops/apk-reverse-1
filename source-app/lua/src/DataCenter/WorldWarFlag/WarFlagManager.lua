local WarFlagManager = BaseClass("WarFlagManager")
local WarFlag = require("DataCenter.WorldWarFlag.WarFlag")
local DisplaySettings = require("DataCenter.WorldBattle.WorldBattleDisplaySettings")

function WarFlagManager:__init()
  self.allFlags = {}
  EventManager:GetInstance():AddListener(EventId.AfterWorldCameraLodChanged, self.OnLodChange)
  EventManager:GetInstance():AddListener(EventId.WorldMarchUpdateDisplayMode, self.OnDisplayModeChanged)
  EventManager:GetInstance():AddListener(EventId.WorldCameraViewChanged, self.OnWorldCameraViewChanged)
end

function WarFlagManager:__delete()
  self:StopTimer()
  self.dirtyFlags = nil
  EventManager:GetInstance():RemoveListener(EventId.AfterWorldCameraLodChanged, self.OnLodChange)
  EventManager:GetInstance():RemoveListener(EventId.WorldMarchUpdateDisplayMode, self.OnDisplayModeChanged)
  EventManager:GetInstance():RemoveListener(EventId.WorldCameraViewChanged, self.OnWorldCameraViewChanged)
  for _, v in pairs(self.allFlags) do
    v:Destroy()
  end
  self.allFlags = {}
end

function WarFlagManager:AddOrUpdateOneFlag(flagData)
  if CS.SceneManager:IsInWorld() then
    local flag = self.allFlags[flagData.uuid]
    if not flag then
      flag = WarFlag.New()
      self.allFlags[flagData.uuid] = flag
    end
    flag:UpdateData(flagData)
    self:StartTimer()
  end
end

function WarFlagManager:RemoveOneFlag(uuid)
  if self.allFlags[uuid] then
    self.allFlags[uuid]:Destroy()
    self.allFlags[uuid] = nil
  end
end

function WarFlagManager:RemoveAllWarFlags()
  for _, v in pairs(self.allFlags) do
    v:Destroy()
  end
  self.allFlags = {}
end

function WarFlagManager.OnLodChange(lod)
  local self = DataCenter.WarFlagManager
  self.currentLod = lod
  self:StartTimer()
end

function WarFlagManager.OnDisplayModeChanged()
  local self = DataCenter.WarFlagManager
  local dLevel = DisplaySettings.GetCurrentDisplayLevel()
  self.currentDisplayLevel = dLevel
  self:StartTimer()
end

function WarFlagManager.OnWorldCameraViewChanged(rect)
  local self = DataCenter.WarFlagManager
  if rect then
    self.cameraMinX = rect[1]
    self.cameraMinY = rect[2]
    self.cameraMaxX = rect[3]
    self.cameraMaxY = rect[4]
    self:StartTimer()
  end
end

function WarFlagManager:Description()
  local sb = StringBuilder.New()
  sb:AppendLine("\230\136\152\230\151\151\231\174\161\231\144\134\229\153\168(WarFlagManager):")
  sb:AppendFormatLine("CurrentLod:%s", self.currentLod)
  sb:AppendFormatLine("CurrentDisplayLevel:%s", self.currentDisplayLevel)
  sb:AppendFormatLine("CurrentView: min:%s,%s, max:%s,%s", self.cameraMinX, self.cameraMinY, self.cameraMaxX, self.cameraMaxY)
  sb:AppendFormatLine("\229\189\147\229\137\141\231\174\161\231\144\134\231\154\132\230\136\152\230\151\151\230\149\176\233\135\143\239\188\154%s", self.allFlags and table.count(self.allFlags) or "0")
  for k, v in pairs(self.allFlags) do
    sb:AppendLine(v:Description())
  end
  sb:AppendFormatLine("\230\152\175\229\144\166\229\188\128\229\144\175\228\186\134\229\174\154\230\151\182\229\153\168:%s", self.timer and "\230\152\175" or "\229\144\166")
  return sb:ToString()
end

function WarFlagManager:TimerUpate()
  for k, v in pairs(self.allFlags) do
    if v then
      v:RefreshVisibleState(self.currentLod, self.currentDisplayLevel, self.cameraMinX, self.cameraMinY, self.cameraMaxX, self.cameraMaxY)
    end
  end
  self:StopTimer()
end

function WarFlagManager:StartTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(0.1, WarFlagManager.TimerUpate, self, false, false, false)
    self.timer:Start()
  end
end

function WarFlagManager:StopTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

return WarFlagManager
