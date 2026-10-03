local LWGateDefenceHero = BaseClass("LWGateDefenceHero")
local FSMachine = require("Common.FSMachine")
local utils = require("DataCenter.LWGateDefenceManager.LWGateDefenceUtils")
local searchFsmStatus = require("DataCenter.LWGateDefenceManager.HeroStates.HeroStateSearch")
local fireFsmStatus = require("DataCenter.LWGateDefenceManager.HeroStates.HeroStateFire")
local reloadFsmStatus = require("DataCenter.LWGateDefenceManager.HeroStates.HeroStateReload")

function LWGateDefenceHero:__init(params)
  self.heroUuid = params[1]
  self.gameObject = params[2]
  self.gameObjectValid = true
  self.heroType = GateDefenceHeroType.LWHero
  self.transform = self.gameObject.transform
  self.transformValid = true
  self.position = Vector3(self.transform:Get_position())
  self.fireEffectContext = utils.GetHeroFireEffectContext(self)
  self.standAlready = false
  self.animator = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation))
  self.animator.cullingMode = CS.UnityEngine.AnimatorCullingMode.CullCompletely
  self.fsm = FSMachine.Create(self)
  self.fsm:Add("Search", searchFsmStatus.Create())
  self.fsm:Add("Fire", fireFsmStatus.Create())
  self.fsm:Add("Reload", reloadFsmStatus.Create())
  self.fsm:Switch("Search")
end

function LWGateDefenceHero:__delete()
  if self.fsm ~= nil then
    self.fsm:Dispose()
    self.fsm = nil
  end
  self.gameObject = nil
  self.gameObjectValid = nil
  self.transform = nil
  self.transformValid = nil
  self.position = nil
  self.fireCoverArea = nil
  self.animator = nil
  self.heroType = nil
  self.standAlready = nil
end

function LWGateDefenceHero:SetPosition(x, y, z)
  if IsNull(self.transform) then
    return
  end
  self.transform:Set_position(x, y, z)
  self.position = Vector3(x, y, z)
end

function LWGateDefenceHero:Update(dt)
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

return LWGateDefenceHero
