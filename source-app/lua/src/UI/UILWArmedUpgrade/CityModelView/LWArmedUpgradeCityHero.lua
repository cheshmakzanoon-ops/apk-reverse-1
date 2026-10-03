local LWArmedUpgradeCityHero = BaseClass("LWArmedUpgradeCityHero")
local FSMachine = require("Common.FSMachine")
local utils = require("DataCenter.LWGateDefenceManager.LWGateDefenceUtils")
local searchFsmStatus = require("DataCenter.LWGateDefenceManager.HeroStates.HeroStateSearch")
local fireFsmStatus = require("DataCenter.LWGateDefenceManager.HeroStates.HeroStateFire")
local reloadFsmStatus = require("DataCenter.LWGateDefenceManager.HeroStates.HeroStateReload")

function LWArmedUpgradeCityHero:__init(params)
  self.heroId = params[1]
  self.gameObject = params[2]
  self.heroInfo = DataCenter.HeroDataManager:GetHeroByHeroId(self.heroId)
  self.heroUuid = self.heroInfo and self.heroInfo.uuid or ""
  self.transform = self.gameObject.transform
  self.position = Vector3(self.transform:Get_position())
  self.fireEffectContext = self:GetHeroFireEffectContext()
  self.animator = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation))
  self.animator.cullingMode = CS.UnityEngine.AnimatorCullingMode.CullCompletely
  self.fsm = FSMachine.Create(self)
  self.fsm:Add("Search", searchFsmStatus.Create())
  self.fsm:Add("Fire", fireFsmStatus.Create())
  self.fsm:Add("Reload", reloadFsmStatus.Create())
  self.fsm:Switch("Search")
end

function LWArmedUpgradeCityHero:__delete()
  if self.fsm ~= nil then
    self.fsm:Dispose()
    self.fsm = nil
  end
  self.heroUuid = nil
  self.gameObject = nil
  self.transform = nil
  self.position = nil
  self.fireEffectContext = nil
  self.animator = nil
end

function LWArmedUpgradeCityHero:Update(dt)
  if IsNull(self.gameObject) then
    return
  end
  if self.fsm ~= nil then
    self.fsm:Update(dt)
  end
end

function LWArmedUpgradeCityHero:GetHeroFireEffectContext()
  local skillId = LocalController:instance():getValue("lw_hero", self.heroId, "skills")[1]
  if self.heroInfo then
    local skillData = self.heroInfo:GetHeroSkillBySlotIndex(1)
    if skillData then
      local newSkillData = DataCenter.LWArmedUpgradeManager:GetArmedUpgradeSkillInfoData(self.heroInfo, skillData)
      if newSkillData then
        skillId = newSkillData.skillId
      end
    end
  end
  local skillTemplate = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
  local skillEffId = 0
  if skillTemplate then
    skillEffId = skillTemplate.skill_effect
  end
  local appearanceId = LocalController:instance():getValue("lw_hero", self.heroId, "appearance")
  local fireVfxPath = LocalController:instance():getValue("lw_hero_skill_effect", skillEffId, "fire_effect")
  local newAppearanceId = DataCenter.LWArmedUpgradeManager:GetArmedUpgradeAppearanceId(self.heroId, appearanceId)
  local muzzlePath = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "fire_path")
  local muzzle_1Path = muzzlePath[1] or ""
  local bulletType = tonumber(LocalController:instance():getValue("lw_hero", self.heroId, "idle_attack"))
  local fireDelay = tonumber(LocalController:instance():getValue("lw_hero_skill_effect", skillEffId, "fire_delay")) * 0.001
  bulletType = bulletType or math.random() > 0.5 and 1 or 2
  return {
    bullet = bulletType,
    vfxPath = fireVfxPath,
    muzzle = self.transform:Find(muzzle_1Path),
    delay = fireDelay
  }
end

return LWArmedUpgradeCityHero
