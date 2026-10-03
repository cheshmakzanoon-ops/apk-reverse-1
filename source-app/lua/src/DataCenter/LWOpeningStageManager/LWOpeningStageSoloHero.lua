local LWOpeningStageSoloHero = BaseClass("LWOpeningStageSoloHero")
local FSMachine = require("Common.FSMachine")
local OnZakuZombieInited, OnZakuZombieDestroyed

function LWOpeningStageSoloHero:__init(config)
  self.config = config
  self.targets = {}
  self.handle = CS.GameEntry.Resource:InstantiateAsync(config.model)
  self.handle:completed("+", function(handle)
    if handle.isError then
      Logger.LogError("load res failed:" .. config.model)
    end
    self.gameObject = handle.gameObject
    self.transform = self.gameObject.transform
    self.transform.position = config.pos
    self.transform.rotation = config.rot
    self.transform.localScale = Vector3(config.size, config.size, config.size)
    self.animator = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation))
    self.turret = self.gameObject:GetComponentInChildren(typeof(CS.SoloHeroTurret))
    self.muzzle = self.gameObject:GetComponentInChildren(typeof(CS.SoloHeroMuzzle))
    self.fsm = FSMachine.Create(self)
    self.fsm:Add("Idle", require("DataCenter.LWOpeningStageManager.SoloHeroStates.SoloHeroStateIdle").Create())
    self.fsm:Add("Aim", require("DataCenter.LWOpeningStageManager.SoloHeroStates.SoloHeroStateAim").Create())
    self.fsm:Add("Fire", require("DataCenter.LWOpeningStageManager.SoloHeroStates.SoloHeroStateFire").Create())
    self.fsm:Add("Reload", require("DataCenter.LWOpeningStageManager.SoloHeroStates.SoloHeroStateReload").Create())
    self.fsm:Switch("Idle")
  end)
  
  function OnZakuZombieInited(zaku)
    table.insert(self.targets, zaku)
  end
  
  function OnZakuZombieDestroyed(zaku)
    for i = 1, #self.targets do
      if self.targets[i] == zaku then
        table.remove(self.targets, i)
        break
      end
    end
  end
  
  EventManager:GetInstance():AddListener(EventId.OpeningStageZakuZombieInited, OnZakuZombieInited)
  EventManager:GetInstance():AddListener(EventId.OpeningStageZakuZombieDestroyed, OnZakuZombieDestroyed)
end

function LWOpeningStageSoloHero:__delete()
  EventManager:GetInstance():RemoveListener(EventId.OpeningStageZakuZombieInited, OnZakuZombieInited)
  EventManager:GetInstance():RemoveListener(EventId.OpeningStageZakuZombieDestroyed, OnZakuZombieDestroyed)
  OnZakuZombieInited = nil
  OnZakuZombieDestroyed = nil
  if self.fsm ~= nil then
    self.fsm:Dispose()
    self.fsm = nil
  end
  self.config = nil
  self.targets = nil
  if not IsNull(self.handle) then
    self.handle:Destroy()
    self.handle = nil
    self.gameObject = nil
    self.transform = nil
    self.animator = nil
  end
end

function LWOpeningStageSoloHero:Update(dt)
  if self.fsm ~= nil then
    self.fsm:Update(dt)
  end
end

function LWOpeningStageSoloHero:DestroySelf()
end

return LWOpeningStageSoloHero
