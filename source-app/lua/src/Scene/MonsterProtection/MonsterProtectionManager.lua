local MonsterProtectionManager = BaseClass("MonsterProtectionManager")
local MonsterProtection = require("Scene.MonsterProtection.MonsterProtection")

local function __init(self)
  self.allMonsterProtection = nil
end

local function __delete(self)
  if self.updateSecTimer then
    self.updateSecTimer:Stop()
    self.updateSecTimer = nil
  end
  if self.allMonsterProtection then
    for key, value in pairs(self.allMonsterProtection) do
      value:Delete()
      ObjectPool:GetInstance():Save(value)
    end
    self.allMonsterProtection = nil
  end
end

local function CreateMonsterProtection(self, uuid, msg)
  if self.allMonsterProtection == nil then
    self.allMonsterProtection = {}
  end
  uuid = tonumber(uuid)
  if CS.SceneManager.World then
    local march = CS.SceneManager.World:GetMarch(uuid)
    local troop = CS.SceneManager.World:GetTroop(uuid)
    if march and march.position and troop then
      local monsterProtection = self.allMonsterProtection[uuid]
      if monsterProtection == nil then
        monsterProtection = ObjectPool:GetInstance():Load(MonsterProtection)
        self.allMonsterProtection[uuid] = monsterProtection
      end
      monsterProtection:Refresh(march, msg)
    else
      self:RemoveMonsterProtection(uuid)
    end
  else
    self:RemoveMonsterProtection(uuid)
  end
end

local function RemoveMonsterProtection(self, uuid)
  uuid = tonumber(uuid)
  if self.allMonsterProtection then
    local monsterProtection = self.allMonsterProtection[uuid]
    if monsterProtection then
      monsterProtection:Delete()
      self.allMonsterProtection[uuid] = nil
      ObjectPool:GetInstance():Save(monsterProtection)
    end
  end
end

local function EnterWorld(self)
  if self.updateSecTimer == nil then
    self.updateSecTimer = TimerManager:GetInstance():GetTimer(1, self.OnUpdateSec, self, false, false, false)
    self.updateSecTimer:Start()
  end
end

local function ExitWorld(self)
  self:Delete()
end

local function OnUpdateSec(self)
  if self.allMonsterProtection then
    for key, value in pairs(self.allMonsterProtection) do
      value:OnUpdateSec()
    end
  end
end

local function GetMonsterProtectionEndTime(self, uuid)
  uuid = tonumber(uuid)
  local protectionEndTime = 0
  if self.allMonsterProtection then
    local monsterProtection = self.allMonsterProtection[uuid]
    if monsterProtection then
      protectionEndTime = monsterProtection.showEndTime
    end
  end
  return protectionEndTime
end

local function OnGetDetail(self, msg)
  self:CreateMonsterProtection(msg.uuid, msg)
  EventManager:GetInstance():Broadcast(EventId.MonsterProtectionRefresh, msg)
end

MonsterProtectionManager.__init = __init
MonsterProtectionManager.__delete = __delete
MonsterProtectionManager.CreateMonsterProtection = CreateMonsterProtection
MonsterProtectionManager.RemoveMonsterProtection = RemoveMonsterProtection
MonsterProtectionManager.EnterWorld = EnterWorld
MonsterProtectionManager.ExitWorld = ExitWorld
MonsterProtectionManager.OnUpdateSec = OnUpdateSec
MonsterProtectionManager.GetMonsterProtectionEndTime = GetMonsterProtectionEndTime
MonsterProtectionManager.OnGetDetail = OnGetDetail
return MonsterProtectionManager
