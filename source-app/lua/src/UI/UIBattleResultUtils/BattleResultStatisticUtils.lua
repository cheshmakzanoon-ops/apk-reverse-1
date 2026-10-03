local BattleResultStatisticUtils = {}
local Localization = CS.GameEntry.Localization
local CommonResulHeroEntryListComponent = require("UI.UIBattleResultComponents.CommonResulHeroEntryListComponent")
local CommonResultWeaponEntryListComponent = require("UI.UIBattleResultComponents.CommonResultWeaponEntryListComponent")
local HERO_ENTRY_PREFAB_NAME = "CommonResultHeroEntryList"
local WEAPON_ENTRY_PREFAB_NAME = "CommonResultWeaponEntryList"
local STATISTIC_FILED_DAMAGE = "makeDmg"
local STATISTIC_FILED_DAMAGE_TAKEN = "takeDmg"

function BattleResultStatisticUtils.GetBarrageStatisticCfgs(fieldName)
  local statisticItemsCfg = {}
  local squad = DataCenter.ZombieBattleManager.squad
  local statisticalData = DataCenter.ZombieBattleManager.heroStatisticalData[fieldName]
  local heroDeathData = DataCenter.ZombieBattleManager.heroStatisticalData.death
  local maxValue = 0
  local heroDatas = {}
  local heroDeaths = {}
  for i = 1, 5 do
    local heroData = squad.heroes[i]
    if heroData then
      table.insert(heroDatas, heroData)
      local value = statisticalData[heroData.uuid] or 0
      if maxValue < value then
        maxValue = value
      end
      table.insert(heroDeaths, heroDeathData[heroData.uuid] or false)
    end
  end
  for i = 1, #heroDatas do
    local heroData = heroDatas[i]
    if heroData then
      table.insert(statisticItemsCfg, {
        cmp = CommonResulHeroEntryListComponent,
        prefabName = HERO_ENTRY_PREFAB_NAME,
        heroData = heroData,
        value = statisticalData[heroData.uuid] or 0,
        maxValue = maxValue,
        heroDeath = heroDeaths[i]
      })
    end
  end
  return statisticItemsCfg
end

function BattleResultStatisticUtils.GetFakePVPStatisticCfgs(fieldName)
  local statisticItemsCfg = {}
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  local maxValue = 0
  local heroDatas = {}
  local heroVal = {}
  local heroDeaths = {}
  
  local function HeroDataHandler(heroData)
    table.insert(heroDatas, heroData)
    local value = 0
    if fieldName == STATISTIC_FILED_DAMAGE then
      value = heroData.stat.damage
    else
      value = heroData.stat.injured
    end
    if value > maxValue then
      maxValue = value
    end
    table.insert(heroVal, value)
    table.insert(heroDeaths, 0 >= heroData.hp)
  end
  
  local startSlot = PVPBattleSlot.SelfHero1
  local endSlot = PVPBattleSlot.SelfHero5
  for i = startSlot, endSlot do
    local heroData = logic.battleData.heroData[i]
    if heroData then
      HeroDataHandler(heroData)
    end
  end
  local dominatorData = logic.battleData.heroData[PVPBattleSlot.SelfDominator]
  if dominatorData then
    HeroDataHandler(dominatorData)
  end
  for i = 1, #heroDatas do
    local heroData = heroDatas[i]
    if heroData then
      local inData = heroData.heroInfo
      inData.uuid = heroData.heroUuid
      table.insert(statisticItemsCfg, {
        cmp = CommonResulHeroEntryListComponent,
        prefabName = HERO_ENTRY_PREFAB_NAME,
        heroData = inData,
        value = heroVal[i] or 0,
        maxValue = maxValue,
        heroDeath = heroDeaths[i]
      })
    end
  end
  return statisticItemsCfg
end

function BattleResultStatisticUtils.GetParkourStatisticCfgs(fieldName)
  local statisticItemsCfg = {}
  local battleLogic = DataCenter.LWBattleManager:GetCurBattleLogic()
  local team = battleLogic.team.teamInitUnits
  local statisticalData = battleLogic.heroStatisticalData[fieldName]
  local heroDeathData = battleLogic.heroStatisticalData.death
  local maxValue = 0
  local heroDatas = {}
  local heroDeaths = {}
  for i = 1, 5 do
    local hero = team[i]
    if hero then
      local heroData = hero.hero
      table.insert(heroDatas, heroData)
      local value = statisticalData[heroData.uuid] or 0
      if maxValue < value then
        maxValue = value
      end
      table.insert(heroDeaths, heroDeathData[heroData.uuid] or false)
    end
  end
  local weaponStatisticalData = battleLogic.weaponStatisticalData[fieldName]
  if maxValue < weaponStatisticalData then
    maxValue = weaponStatisticalData
  end
  for i = 1, #heroDatas do
    local heroData = heroDatas[i]
    if heroData then
      local statisticalValue = statisticalData[heroData.uuid]
      if statisticalValue then
        table.insert(statisticItemsCfg, {
          cmp = CommonResulHeroEntryListComponent,
          prefabName = HERO_ENTRY_PREFAB_NAME,
          heroData = heroData,
          value = statisticalValue,
          maxValue = maxValue,
          heroDeath = heroDeaths[i]
        })
      end
    end
  end
  local weaponData = battleLogic.team.weaponData
  local weaponAppearanceId = battleLogic.team.weaponAppearanceId
  if fieldName == STATISTIC_FILED_DAMAGE and 0 < weaponStatisticalData and weaponData ~= nil then
    table.insert(statisticItemsCfg, {
      cmp = CommonResultWeaponEntryListComponent,
      prefabName = WEAPON_ENTRY_PREFAB_NAME,
      weaponData = weaponData,
      appearanceId = weaponAppearanceId,
      value = weaponStatisticalData,
      maxValue = maxValue
    })
  end
  return statisticItemsCfg
end

BattleResultStatisticUtils.STATISTIC_FILED_DAMAGE = STATISTIC_FILED_DAMAGE
BattleResultStatisticUtils.STATISTIC_FILED_DAMAGE_TAKEN = STATISTIC_FILED_DAMAGE_TAKEN
return BattleResultStatisticUtils
