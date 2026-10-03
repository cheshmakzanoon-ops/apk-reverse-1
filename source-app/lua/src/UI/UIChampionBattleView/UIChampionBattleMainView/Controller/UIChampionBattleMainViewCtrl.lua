local UIChampionBattleMainViewCtrl = BaseClass("UIChampionBattleMainViewCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChampionBattleMain)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function ShowPlayerInfo(self, userUid)
  if string.IsNullOrEmpty(userUid) then
    return ""
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, userUid)
end

local function GetNameStr(self, abbr, name)
  local result = ""
  if not string.IsNullOrEmpty(abbr) then
    result = "[" .. abbr .. "]"
  end
  result = result .. name
  return result
end

local function SetHeadImg(self, userHead, guluFrame, userUid, pic, picvec, isGuluFrame)
  userHead:SetData(userUid, pic, picvec)
  guluFrame:SetActive(isGuluFrame == 1)
  if isGuluFrame == 1 then
    guluFrame:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_playerbg_golloes"))
  end
end

local function GetHeroInfo(self, index)
  local data = DataCenter.ActChampionBattleManager:GetFormationData(index)
  if data == nil or data.heroes == nil or table.count(data.heroes) == 0 then
    return nil
  end
  local heroUid = data.heroes[1].heroUuid
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUid)
  if heroData ~= nil then
    local heroConfig = heroData:GetConfig()
    if heroConfig ~= nil then
      local quality = heroData.quality
      local camp = heroConfig.camp
      local rarity = heroConfig.rarity
      local heroHead = DataCenter.ActChampionBattleManager:GetFormationHeroPic(index)
      local qualityIcon = HeroUtils.GetRarityIconPath(rarity)
      local campIcon = HeroUtils.GetCampIconPath(camp)
      local rankIcon = ""
      local rankId = heroData:GetRank()
      if 1 < rankId then
        rankIcon = HeroUtils.GetMilitaryRankIcon(rankId)
      end
      return heroHead, heroData.level, quality, rankIcon, campIcon, qualityIcon, rarity, heroData.heroId
    end
  end
  return nil
end

UIChampionBattleMainViewCtrl.CloseSelf = CloseSelf
UIChampionBattleMainViewCtrl.Close = Close
UIChampionBattleMainViewCtrl.SetHeadImg = SetHeadImg
UIChampionBattleMainViewCtrl.GetHeroInfo = GetHeroInfo
UIChampionBattleMainViewCtrl.ShowPlayerInfo = ShowPlayerInfo
UIChampionBattleMainViewCtrl.GetNameStr = GetNameStr
return UIChampionBattleMainViewCtrl
