local TriggerEventManager = BaseClass("TriggerEventManager")
local TriggerEnum = require("Scene.LWBattle.ParkourBattle.TriggerEvent.TriggerEnum")
local AddBuffTriggerEvent = require("Scene.LWBattle.ParkourBattle.TriggerEvent.Impl.AddBuffTriggerEvent")
local AddSkillTriggerEvent = require("Scene.LWBattle.ParkourBattle.TriggerEvent.Impl.AddSkillTriggerEvent")
local AddHeroTriggerEvent = require("Scene.LWBattle.ParkourBattle.TriggerEvent.Impl.AddHeroTriggerEvent")
local RemoveHeroTriggerEvent = require("Scene.LWBattle.ParkourBattle.TriggerEvent.Impl.RemoveHeroTriggerEvent")
local SaveHeroTriggerEvent = require("Scene.LWBattle.ParkourBattle.TriggerEvent.Impl.SaveHeroTriggerEvent")
local SaveWorkerTriggerEvent = require("Scene.LWBattle.ParkourBattle.TriggerEvent.Impl.SaveWorkerTriggerEvent")
local GetGoodsTriggerEvent = require("Scene.LWBattle.ParkourBattle.TriggerEvent.Impl.GetGoodsTriggerEvent")
local AddSingleHeroBuffTriggerEvent = require("Scene.LWBattle.ParkourBattle.TriggerEvent.Impl.AddSingleHeroBuffTriggerEvent")
local AddSingleHeroSkillTriggerEvent = require("Scene.LWBattle.ParkourBattle.TriggerEvent.Impl.AddSingleHeroSkillTriggerEvent")
local ReplaceSingleHeroNormalAttackTriggerEvent = require("Scene.LWBattle.ParkourBattle.TriggerEvent.Impl.ReplaceSingleHeroNormalAttackTriggerEvent")
local ThreeChoicesTriggerEvent = require("Scene.LWBattle.ParkourBattle.TriggerEvent.Impl.ThreeChoicesTriggerEvent")
local AddSingleHeroIdBuffTriggerEvent = require("Scene.LWBattle.ParkourBattle.TriggerEvent.Impl.AddSingleHeroIdBuffTriggerEvent")
local AddTrialHeroTriggerEvent = require("Scene.LWBattle.ParkourBattle.TriggerEvent.Impl.AddTrialHeroTriggerEvent")
local ReplaceHeroIdNormalAttackTriggerEvent = require("Scene.LWBattle.ParkourBattle.TriggerEvent.Impl.ReplaceHeroIdNormalAttackTriggerEvent")
local ReplaceHeroIdAppearanceTriggerEvent = require("Scene.LWBattle.ParkourBattle.TriggerEvent.Impl.ReplaceHeroIdAppearanceTriggerEvent")
local ReplaceHeroIdAppearanceSaveLvTriggerEvent = require("Scene.LWBattle.ParkourBattle.TriggerEvent.Impl.ReplaceHeroIdAppearanceSaveLvTriggerEvent")
local AddEnergyTriggerEvent = require("Scene.LWBattle.ParkourBattle.TriggerEvent.Impl.AddEnergyTriggerEvent")
local AddSingleHeroIdSkillTriggerEvent = require("Scene.LWBattle.ParkourBattle.TriggerEvent.Impl.AddSingleHeroIdSkillTriggerEvent")
local ReplaceHeroIdNormalBulletTriggerEvent = require("Scene.LWBattle.ParkourBattle.TriggerEvent.Impl.ReplaceHeroIdNormalBulletTriggerEvent")
local ReplaceHeroIdActiveBulletTriggerEvent = require("Scene.LWBattle.ParkourBattle.TriggerEvent.Impl.ReplaceHeroIdActiveBulletTriggerEvent")
local SummonMonsterBatchTriggerEvent = require("Scene.LWBattle.ParkourBattle.TriggerEvent.Impl.SummonMonsterBatchTriggerEvent")
local AddHeroIdGlobalBuffTriggerEvent = require("Scene.LWBattle.ParkourBattle.TriggerEvent.Impl.AddHeroIdGlobalBuffTriggerEvent")
local SummonFriendlyPetTriggerEvent = require("Scene.LWBattle.ParkourBattle.TriggerEvent.Impl.SummonFriendlyPetTriggerEvent")
local ReplaceHeroIdActiveAttackWithoutInterruptTriggerEvent = require("Scene.LWBattle.ParkourBattle.TriggerEvent.Impl.ReplaceHeroIdActiveAttackWithoutInterruptTriggerEvent")
local ReplaceHeroIdNormalAttackWithoutInterruptTriggerEvent = require("Scene.LWBattle.ParkourBattle.TriggerEvent.Impl.ReplaceHeroIdNormalAttackWithoutInterruptTriggerEvent")
local AddHeroIdEnergyTriggerEvent = require("Scene.LWBattle.ParkourBattle.TriggerEvent.Impl.AddHeroIdEnergyTriggerEvent")

function TriggerEventManager:__init(battleMgr)
  self.battleMgr = battleMgr
  self:Register(TriggerEnum.EventType.AddBuff, AddBuffTriggerEvent.New)
  self:Register(TriggerEnum.EventType.AddSkill, AddSkillTriggerEvent.New)
  self:Register(TriggerEnum.EventType.AddHero, AddHeroTriggerEvent.New)
  self:Register(TriggerEnum.EventType.RemoveHero, RemoveHeroTriggerEvent.New)
  self:Register(TriggerEnum.EventType.SaveHero, SaveHeroTriggerEvent.New)
  self:Register(TriggerEnum.EventType.SaveWorker, SaveWorkerTriggerEvent.New)
  self:Register(TriggerEnum.EventType.GetGoods, GetGoodsTriggerEvent.New)
  self:Register(TriggerEnum.EventType.AddSingleHeroBuff, AddSingleHeroBuffTriggerEvent.New)
  self:Register(TriggerEnum.EventType.AddSingleHeroSkill, AddSingleHeroSkillTriggerEvent.New)
  self:Register(TriggerEnum.EventType.ReplaceSingleHeroNormalAttack, ReplaceSingleHeroNormalAttackTriggerEvent.New)
  self:Register(TriggerEnum.EventType.ThreeChoices, ThreeChoicesTriggerEvent.New)
  self:Register(TriggerEnum.EventType.AddSingleHeroIdBuff, AddSingleHeroIdBuffTriggerEvent.New)
  self:Register(TriggerEnum.EventType.AddTrialHero, AddTrialHeroTriggerEvent.New)
  self:Register(TriggerEnum.EventType.ReplaceHeroIdNormalAttack, ReplaceHeroIdNormalAttackTriggerEvent.New)
  self:Register(TriggerEnum.EventType.ReplaceHeroIdAppearance, ReplaceHeroIdAppearanceTriggerEvent.New)
  self:Register(TriggerEnum.EventType.ReplaceHeroIdAppearanceSaveLv, ReplaceHeroIdAppearanceSaveLvTriggerEvent.New)
  self:Register(TriggerEnum.EventType.AddEnergy, AddEnergyTriggerEvent.New)
  self:Register(TriggerEnum.EventType.AddSingleHeroIdSkill, AddSingleHeroIdSkillTriggerEvent.New)
  self:Register(TriggerEnum.EventType.ReplaceHeroIdNormalBullet, ReplaceHeroIdNormalBulletTriggerEvent.New)
  self:Register(TriggerEnum.EventType.ReplaceHeroIdActiveBullet, ReplaceHeroIdActiveBulletTriggerEvent.New)
  self:Register(TriggerEnum.EventType.SummonMonsterBatch, SummonMonsterBatchTriggerEvent.New)
  self:Register(TriggerEnum.EventType.AddHeroIdGlobalBuff, AddHeroIdGlobalBuffTriggerEvent.New)
  self:Register(TriggerEnum.EventType.SummonFriendlyPet, SummonFriendlyPetTriggerEvent.New)
  self:Register(TriggerEnum.EventType.ReplaceHeroIdNormalAttackWithoutInterrupt, ReplaceHeroIdNormalAttackWithoutInterruptTriggerEvent.New)
  self:Register(TriggerEnum.EventType.ReplaceHeroIdActiveAttackWithoutInterrupt, ReplaceHeroIdActiveAttackWithoutInterruptTriggerEvent.New)
  self:Register(TriggerEnum.EventType.AddHeroIdEnergy, AddHeroIdEnergyTriggerEvent.New)
end

function TriggerEventManager:__delete()
  self.battleMgr = nil
  self.factory = nil
end

function TriggerEventManager:Register(type, func)
  if not self.factory then
    self.factory = {}
  end
  if self.factory[type] then
    Logger.LogError(type .. " already register")
    return
  end
  self.factory[type] = func
end

function TriggerEventManager:Trigger(type, param, extra, sourceId)
  if not self.factory[type] then
    Logger.LogError(type .. " not register")
    return nil
  end
  local e = self.factory[type]
  local obj = e()
  if not string.IsNullOrEmpty(param.gain_sound) then
    DataCenter.LWSoundManager:PlaySound(tonumber(param.gain_sound))
  end
  if param.gain_vibrate and #param.gain_vibrate == 3 and self.battleMgr.DoVibration then
    self.battleMgr:DoVibration(param.gain_vibrate[1], param.gain_vibrate[2], param.gain_vibrate[3])
  end
  if param.gainShakeParam and self.battleMgr.ShakeCameraWithParam then
    self.battleMgr:ShakeCameraWithParam(param.gainShakeParam)
  end
  if param.desc_gaintext and self.battleMgr.ShowGainText then
    self.battleMgr:ShowGainText(param.desc_gaintext, param.text_time)
  end
  obj:Execute(param, extra, sourceId)
  return obj
end

return TriggerEventManager
