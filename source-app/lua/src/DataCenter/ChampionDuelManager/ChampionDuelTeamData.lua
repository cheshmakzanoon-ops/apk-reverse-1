local base = ArenaArmyFormationInfo
local ChampionDuelTeamData = BaseClass("ChampionDuelTeamData", base)

function ChampionDuelTeamData:__init()
  self.power = 0
  self.heroes = {}
  base.__init(self)
end

function ChampionDuelTeamData:__delete()
  self.power = 0
  self.heroes = {}
  base.__delete(self)
end

function ChampionDuelTeamData:ParseData(message)
  base.ParseData(self, message)
  if message == nil then
    return
  end
  if message.power ~= nil then
    self.power = message.power
  end
  local heroesArr = message.heroes
  if heroesArr ~= nil then
    self.heroes = {}
    for _, v in pairs(heroesArr) do
      local level = v.heroLevel
      local tmpData = {}
      tmpData.heroLevel = level
      tmpData.heroId = v.heroId
      tmpData.index = toInt(v.index)
      tmpData.heroUuid = v.heroUuid
      tmpData.power = v.power
      tmpData.rankLv = v.rankLv
      tmpData.skinId = v.heroSkinId
      tmpData.awakenLv = v.awakenLv
      if tmpData.index <= 5 then
        local one = HeroInfo.New()
        one:UpdateInfo(v)
        one.level = level
        local heroInfo = DataCenter.HeroDataManager:GetHeroByHeroId(tmpData.heroId)
        if heroInfo then
          one.uniqueWeaponLv = heroInfo.uniqueWeaponLv
          one.modelId = heroInfo.modelId
        end
        tmpData.heroInfo = one
      end
      table.insert(self.heroes, tmpData)
    end
  end
end

return ChampionDuelTeamData
