local UILWMailHeroPageRelationContainer = BaseClass("UILWMailHeroPageRelationContainer", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UILWMailHeroLineUpInfoItemRender = require("UI.UILWMail.UILWMailMain.Component.UILWMailHeroLineUpInfoItemRender")
local UILWMailHeroCampEffectInfoItemRender = require("UI.UILWMail.UILWMailMain.Component.UILWMailHeroCampEffectInfoItemRender")
local hero_page_hero_lineup_info1_path = "HeroLineUpInfo/HeroPageHeroLineupInfo1"
local hero_page_hero_lineup_info2_path = "HeroLineUpInfo/HeroPageHeroLineupInfo2"
local hero_camp_effect_info_path = "HeroCampEffectInfo"
local hero_page_hero_camp_effect_info1_path = "HeroCampEffectInfo/HorizontalLayout/HeroPageHeroCampEffectInfo1"
local hero_page_hero_camp_effect_info2_path = "HeroCampEffectInfo/HorizontalLayout/HeroPageHeroCampEffectInfo2"
local tips_text_path = "TipsText"
local over_title_text_path = "HeroLineUpInfo/OverTitle/OverTitleText"

function UILWMailHeroPageRelationContainer:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWMailHeroPageRelationContainer:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailHeroPageRelationContainer:ComponentDefine()
  self.tips_text = self:AddComponent(UIText, tips_text_path)
  self.hero_page_hero_lineup_info1 = self:AddComponent(UILWMailHeroLineUpInfoItemRender, hero_page_hero_lineup_info1_path)
  self.hero_page_hero_lineup_info2 = self:AddComponent(UILWMailHeroLineUpInfoItemRender, hero_page_hero_lineup_info2_path)
  self.hero_page_hero_camp_effect_info1 = self:AddComponent(UILWMailHeroCampEffectInfoItemRender, hero_page_hero_camp_effect_info1_path)
  self.hero_page_hero_camp_effect_info2 = self:AddComponent(UILWMailHeroCampEffectInfoItemRender, hero_page_hero_camp_effect_info2_path)
  self.hero_camp_effect_info = self:AddComponent(UIBaseContainer, hero_camp_effect_info_path)
  self.titleTextObj = self:AddComponent(UIBaseContainer, over_title_text_path)
end

function UILWMailHeroPageRelationContainer:ComponentDestroy()
  self.tips_text = nil
  self.hero_page_hero_lineup_info1 = nil
  self.hero_page_hero_lineup_info2 = nil
  self.hero_page_hero_camp_effect_info1 = nil
  self.hero_page_hero_camp_effect_info2 = nil
  self.hero_camp_effect_info = nil
  self.titleTextObj = nil
end

function UILWMailHeroPageRelationContainer:ReInit(data)
  self.mailBattleReport = data
  if self.mailBattleReport then
    local containSelf = false
    local leftIsSelf = false
    for _, player in pairs(self.mailBattleReport.player) do
      if player.uid == LuaEntry.Player.uid then
        leftIsSelf = self.mailBattleReport.player[1].uid == LuaEntry.Player.uid
        containSelf = true
        break
      end
    end
    if not containSelf and (string.IsNullOrEmpty(self.mailBattleReport.player[1].uid) or string.IsNullOrEmpty(self.mailBattleReport.player[2].uid)) then
      leftIsSelf = not string.IsNullOrEmpty(self.mailBattleReport.player[1].uid)
    end
    local player1CampDic = {}
    local player2CampDic = {}
    for _, heroData in pairs(self.mailBattleReport.hero) do
      local heroConfig = DataCenter.HeroTemplateManager:GetTemplate(heroData.heroId)
      if heroData.index <= PVPBattleSlot.SelfHero5 then
        if heroConfig ~= nil then
          if player1CampDic[heroConfig.type] then
            player1CampDic[heroConfig.type].count = player1CampDic[heroConfig.type].count + 1
          else
            player1CampDic[heroConfig.type] = {}
            player1CampDic[heroConfig.type].type = heroConfig.type
            player1CampDic[heroConfig.type].count = 1
          end
        end
      elseif heroData.index <= PVPBattleSlot.EnemyHero5 and heroConfig ~= nil then
        if player2CampDic[heroConfig.type] then
          player2CampDic[heroConfig.type].count = player2CampDic[heroConfig.type].count + 1
        else
          player2CampDic[heroConfig.type] = {}
          player2CampDic[heroConfig.type].type = heroConfig.type
          player2CampDic[heroConfig.type].count = 1
        end
      end
    end
    local isPlayer1ExistExtraData = BattleReportUtil.IsContainsExtraPowerData(self.mailBattleReport.player[1])
    local isPlayer2ExistExtraData = BattleReportUtil.IsContainsExtraPowerData(self.mailBattleReport.player[2])
    local isShowOldTitle = not isPlayer1ExistExtraData and not isPlayer2ExistExtraData
    if self.titleTextObj then
      self.titleTextObj:SetActive(not isShowOldTitle)
    end
    local player1HeroCampList = self:SortCamp(player1CampDic)
    self.hero_page_hero_lineup_info1:ReInit(player1HeroCampList, leftIsSelf, self.mailBattleReport.player[1], isShowOldTitle)
    local player2HeroCampList = self:SortCamp(player2CampDic)
    local isPVE = self.mailBattleReport.player[1].armyType ~= MailTargetType.Player or self.mailBattleReport.player[2].armyType ~= MailTargetType.Player
    if isPVE or self.mailBattleReport.battleType == MailBattleReportType.ActBoss or self.mailBattleReport.battleType == MailBattleReportType.ALLIANCE_BOSS or self.mailBattleReport.battleType == MailBattleReportType.ALLIANCE_MONSTER_CHALLENGE_KIROV or self.mailBattleReport.battleType == MailBattleReportType.CITY_BATTLE_S1_REST_ATTACK_MONSTER or self.mailBattleReport.battleType == MailBattleReportType.ALLIANCE_BOSS_S0 then
      isShowOldTitle = true
    end
    self.hero_page_hero_lineup_info2:ReInit(player2HeroCampList, not leftIsSelf, self.mailBattleReport.player[2], isShowOldTitle)
    local player1CampEffectType = self:GetCampEffectType(player1CampDic)
    local player2CampEffectType = self:GetCampEffectType(player2CampDic)
    local isFormationBuffOpen = UIUtil.IsFormationBuffInfoOpen()
    if player1CampEffectType == 0 and player2CampEffectType == 0 or not isFormationBuffOpen then
      self.hero_camp_effect_info:SetActive(false)
    else
      self.hero_camp_effect_info:SetActive(true)
      local player1Effect = self.mailBattleReport:GetEffectFromPlayer(1) or {}
      local player2Effect = self.mailBattleReport:GetEffectFromPlayer(2) or {}
      local player1LineupHpAddRate = player1Effect[HeroEffectDefine.LineupHpAddRate] or 0
      local player2LineupHpAddRate = player2Effect[HeroEffectDefine.LineupHpAddRate] or 0
      player1LineupHpAddRate = math.floor(player1LineupHpAddRate * 1000) / 1000
      player2LineupHpAddRate = math.floor(player2LineupHpAddRate * 1000) / 1000
      self.hero_page_hero_camp_effect_info1:ReInit(player1CampEffectType, isPlayer1ExistExtraData, player1LineupHpAddRate)
      self.hero_page_hero_camp_effect_info2:ReInit(player2CampEffectType, isPlayer2ExistExtraData, player2LineupHpAddRate)
    end
    local compareCampValue = self:CompareCamp(player1HeroCampList, player2HeroCampList)
    if compareCampValue < 10 then
      if leftIsSelf then
        self.tips_text:SetLocalText("report_help_18")
      else
        self.tips_text:SetLocalText("report_help_22")
      end
    elseif 10 <= compareCampValue and compareCampValue < 40 then
      if leftIsSelf then
        self.tips_text:SetLocalText("report_help_19")
      else
        self.tips_text:SetLocalText("report_help_21")
      end
    elseif 40 <= compareCampValue and compareCampValue <= 60 then
      self.tips_text:SetLocalText("report_help_20")
    elseif 60 < compareCampValue and compareCampValue <= 90 then
      if leftIsSelf then
        self.tips_text:SetLocalText("report_help_21")
      else
        self.tips_text:SetLocalText("report_help_19")
      end
    elseif 90 < compareCampValue then
      if leftIsSelf then
        self.tips_text:SetLocalText("report_help_22")
      else
        self.tips_text:SetLocalText("report_help_18")
      end
    end
  end
end

function UILWMailHeroPageRelationContainer:SortCamp(campDic)
  local lineupsInfo = {}
  for i, v in pairs(campDic) do
    table.insert(lineupsInfo, v)
  end
  table.sort(lineupsInfo, function(a, b)
    if a.count > b.count then
      return true
    elseif a.count == b.count and a.type < b.type then
      return true
    end
  end)
  local finallyList = {}
  for i = 1, #lineupsInfo do
    for j = 1, lineupsInfo[i].count do
      table.insert(finallyList, lineupsInfo[i].type)
    end
  end
  return finallyList
end

function UILWMailHeroPageRelationContainer:GetCampEffectType(campDic)
  local max = 0
  local too = 0
  for i, campData in pairs(campDic) do
    if max < campData.count then
      max = campData.count
    end
  end
  if max == 3 then
    for i, campData in pairs(campDic) do
      if too < campData.count and max > campData.count then
        too = campData.count
      end
    end
  end
  local type = 0
  if 3 <= max then
    if 5 <= max then
      type = 4
    elseif 4 <= max then
      type = 3
    elseif 3 <= max and 2 <= too then
      type = 2
    else
      type = 1
    end
  end
  return type
end

function UILWMailHeroPageRelationContainer:CompareCamp(player1HeroCampList, player2HeroCampList)
  local function getCounter(camp1, camp2)
    local temp = camp2 - camp1
    
    if temp == 2 then
      return -1
    elseif temp == -2 then
      return 1
    else
      return temp
    end
  end
  
  local sum = 0
  for i = 1, math.max(#player1HeroCampList, #player2HeroCampList) do
    local player1HeroCamp = player1HeroCampList[i]
    local player2HeroCamp = player2HeroCampList[i]
    if player1HeroCamp == nil and player2HeroCamp == nil then
      sum = sum + 0
    elseif player1HeroCamp == nil then
      sum = sum - 1
    elseif player2HeroCamp == nil then
      sum = sum + 1
    else
      sum = sum + getCounter(player1HeroCamp, player2HeroCamp)
    end
  end
  return sum * 10 + 50
end

return UILWMailHeroPageRelationContainer
