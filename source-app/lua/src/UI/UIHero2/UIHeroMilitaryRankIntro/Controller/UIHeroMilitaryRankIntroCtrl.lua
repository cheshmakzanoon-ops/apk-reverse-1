local UIHeroMilitaryRankCtrl = BaseClass("UIHeroMilitaryRankCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroMilitaryRankIntro)
end

local function GetShowData(self, heroUid)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUid)
  if heroData ~= nil then
    local heroConfig = heroData:GetConfig()
    local result = {}
    result.heroUid = heroUid
    result.quality = heroData.quality
    result.rarity = heroData.rarity
    result.heroId = heroData.heroId
    result.currentMilitaryRankId = heroData:GetRank()
    local level = GetTableData(TableName.HeroMilitaryRankLv, result.currentMilitaryRankId, "level")
    if level == "" then
    end
    result.currentMilitaryRankLv = level
    result.maxMilitaryRankId = heroData:IsReachMaxRank()
    local rankList = {}
    local rank = 1
    while rank <= result.maxMilitaryRankId do
      local level = GetTableData(TableName.HeroMilitaryRankLv, rank, "level")
      if level == "" then
        break
      end
      if 0 < level then
        local tmp = {}
        tmp.rankId = rank
        tmp.rarity = result.rarity
        tmp.curRank = result.currentMilitaryRankId
        tmp.maxRank = result.maxMilitaryRankId
        table.insert(rankList, tmp)
      end
      rank = rank + 1
    end
    result.rankList = rankList
    local skillArray = heroConfig.skill
    if type(skillArray) ~= "table" then
      skillArray = string.split(skillArray, "|")
    end
    result.skillList = skillArray
    return result
  end
  return nil
end

UIHeroMilitaryRankCtrl.CloseSelf = CloseSelf
UIHeroMilitaryRankCtrl.GetShowData = GetShowData
return UIHeroMilitaryRankCtrl
