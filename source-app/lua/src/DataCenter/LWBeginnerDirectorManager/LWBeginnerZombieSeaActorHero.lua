local LWBeginnerZombieSeaActorHero = BaseClass("LWBeginnerZombieSeaActorHero")
local FSMachine = require("Common.FSMachine")
local utils = require("DataCenter.LWGateDefenceManager.LWGateDefenceUtils")
local moveFsmStatus = require("DataCenter.LWGateDefenceManager.HeroStates.HeroStateMove")
local searchFsmStatus = require("DataCenter.LWGateDefenceManager.HeroStates.HeroStateSearch")
local fireFsmStatus = require("DataCenter.LWGateDefenceManager.HeroStates.HeroStateFire")
local reloadFsmStatus = require("DataCenter.LWGateDefenceManager.HeroStates.HeroStateReload")
local __Inst_Pool = {}

function LWBeginnerZombieSeaActorHero.Create(params)
  local inst
  if 0 < #__Inst_Pool then
    inst = table.remove(__Inst_Pool)
  else
    inst = LWBeginnerZombieSeaActorHero.New()
  end
  inst:Initialize(params)
  return inst
end

function LWBeginnerZombieSeaActorHero.Return(inst)
  if inst == nil then
    return
  end
  inst:Clear()
  table.insert(__Inst_Pool, inst)
end

function LWBeginnerZombieSeaActorHero.ReleaseAll()
  for i = 1, #__Inst_Pool do
    __Inst_Pool[i]:Delete()
  end
  __Inst_Pool = {}
end

function LWBeginnerZombieSeaActorHero:__init()
  self.heroType = GateDefenceHeroType.ChapterActor
  self.fsm = FSMachine.Create(self)
  self.fsm:Add("Move", moveFsmStatus.Create())
  self.fsm:Add("Search", searchFsmStatus.Create())
  self.fsm:Add("Fire", fireFsmStatus.Create())
  self.fsm:Add("Reload", reloadFsmStatus.Create())
end

function LWBeginnerZombieSeaActorHero:Initialize(params)
  self.heroUuid = params[1]
  self.modelPath = params[2]
  self.grid = utils.Grid(params[3][1], params[3][2])
  self.dstGrid = utils.Grid(params[4][1], params[4][2])
  self.bulletType = params[5]
  self.fireVfxPath = params[6]
  self.muzzlePath = params[7]
  self.fireDelay = params[8]
  self.gameObjectValid = false
  self.transformValid = false
  self.standAlready = false
  self.resHandle = CS.GameEntry.Resource:InstantiateAsync(self.modelPath, ObjectPoolTag.Normal, LoadPriority.Low)
  self.resHandle:completed("+", function(handle)
    if IsNull(handle.gameObject) then
      Logger.LogError("load res failed:" .. self.modelPath)
      DataCenter.LWGateDefenceManager:DestroyHero(self.id)
      return
    end
    self.gameObjectValid = true
    self.gameObject = handle.gameObject
    self.transform = self.gameObject.transform
    self.transformValid = true
    self.position = utils.Grid_2_World(self.grid.row, self.grid.col)
    self.transform.position = self.position
    self.transform.forward = Vector3(0, 0, 1)
    self.animator = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation))
    self.fireEffectContext = {
      bullet = self.bulletType,
      vfxPath = self.fireVfxPath,
      muzzle = self.transform:Find(self.muzzlePath),
      delay = self.fireDelay
    }
    self.fsm:Switch("Move")
  end)
end

function LWBeginnerZombieSeaActorHero:SetPosition(x, y, z)
  if IsNull(self.transform) then
    return
  end
  self.transform:Set_position(x, y, z)
  self.position = Vector3(x, y, z)
end

function LWBeginnerZombieSeaActorHero:Clear()
  self.heroUuid = nil
  self.modelPath = nil
  self.grid = nil
  self.dstGrid = nil
  self.bulletType = nil
  self.fireVfxPath = nil
  self.muzzlePath = nil
  self.fireDelay = nil
  self.fireCoverArea = nil
  self.fireEffectContext = nil
  self.standAlready = nil
  if not IsNull(self.resHandle) then
    self.resHandle:Destroy()
    self.resHandle = nil
  end
  self.gameObject = nil
  self.gameObjectValid = nil
  self.transform = nil
  self.transformValid = nil
  self.animator = nil
  if self.fsm ~= nil then
    self.fsm:Reset()
  end
  self.faceZ = nil
  self.faceX = nil
end

function LWBeginnerZombieSeaActorHero:__delete()
  self:Clear()
  if self.fsm ~= nil then
    self.fsm:Dispose()
    self.fsm = nil
  end
  self.heroType = nil
end

function LWBeginnerZombieSeaActorHero:Update(dt)
  if not self.gameObjectValid then
    return
  end
  if IsNull(self.gameObject) then
    DataCenter.LWGateDefenceManager:DestroyHero(self.heroUuid)
    return
  end
  if self.fsm ~= nil then
    self.fsm:Update(dt)
  end
end

return LWBeginnerZombieSeaActorHero
