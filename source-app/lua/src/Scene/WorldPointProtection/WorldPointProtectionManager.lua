local WorldPointProtectionManager = BaseClass("WorldPointProtectionManager")
local ZoneMobilizationSupplyPointProtection = require("Scene.WorldPointProtection.ZoneMobilizationSupplyPointProtection")

local function __init(self)
  self.allProtections = nil
  self.protectionTime = nil
  self.updateSecTimer = nil
  self:AddListeners()
end

local function __delete(self)
  self:RemoveListeners()
  self:Clear()
end

local function Clear(self)
  if self.updateSecTimer then
    self.updateSecTimer:Stop()
    self.updateSecTimer = nil
  end
  if self.allProtections then
    for _, value in pairs(self.allProtections) do
      if value then
        value:Delete()
        ObjectPool:GetInstance():Save(value)
      end
    end
    self.allProtections = nil
  end
  self.protectionTime = nil
end

local function StartUp(self)
end

local function AddListeners(self)
  EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.ExitWorld)
  EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self.EnterWorld)
end

local function RemoveListeners(self)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.ExitWorld)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.EnterWorld)
end

local function CreateProtection(self, uuid, transform)
  if self.allProtections == nil then
    self.allProtections = {}
  end
  if CS.SceneManager.World then
    local info = CS.SceneManager.World:GetPointInfoByUuid(uuid)
    if info then
      local protection = self.allProtections[uuid]
      if protection == nil then
        protection = ObjectPool:GetInstance():Load(ZoneMobilizationSupplyPointProtection)
        self.allProtections[uuid] = protection
      end
      protection:Refresh(info, transform, self.protectionTime)
    else
      self:RemoveProtection(uuid)
    end
  else
    self:RemoveProtection(uuid)
  end
end

local function RemoveProtection(self, uuid)
  if self.allProtections then
    local protection = self.allProtections[uuid]
    if protection then
      protection:Delete()
      self.allProtections[uuid] = nil
      ObjectPool:GetInstance():Save(protection)
    end
  end
end

local function EnterWorld()
  local self = DataCenter.WorldPointProtectionManager
  if self.updateSecTimer == nil then
    self.updateSecTimer = TimerManager:GetInstance():GetTimer(1, self.OnUpdateSec, self, false, false, false)
    self.updateSecTimer:Start()
  end
end

local function ExitWorld()
  DataCenter.WorldPointProtectionManager:Clear()
end

local function OnUpdateSec(self)
  if self.allProtections then
    for _, value in pairs(self.allProtections) do
      if value then
        value:OnUpdateSec()
      end
    end
  end
end

local function GetPointProtectionTime(self)
  self.protectionTime = LuaEntry.DataConfig:TryGetNum("zone_mobilization", "k28", 0)
  return self.protectionTime
end

WorldPointProtectionManager.__init = __init
WorldPointProtectionManager.__delete = __delete
WorldPointProtectionManager.Clear = Clear
WorldPointProtectionManager.StartUp = StartUp
WorldPointProtectionManager.AddListeners = AddListeners
WorldPointProtectionManager.RemoveListeners = RemoveListeners
WorldPointProtectionManager.CreateProtection = CreateProtection
WorldPointProtectionManager.RemoveProtection = RemoveProtection
WorldPointProtectionManager.EnterWorld = EnterWorld
WorldPointProtectionManager.ExitWorld = ExitWorld
WorldPointProtectionManager.OnUpdateSec = OnUpdateSec
WorldPointProtectionManager.getters.protectionTime = GetPointProtectionTime
return WorldPointProtectionManager
