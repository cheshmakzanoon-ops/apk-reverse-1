local RankItemShow = {
  type = RankingTypeServer.DEFAULT,
  isAlliance = false,
  uid = "",
  firstName = "",
  secondName = "",
  rank = -1,
  power = "",
  allianceName = "",
  icon = ""
}
local UIRankDetailListCtrl = BaseClass("UIRankDetailListCtrl", UIBaseCtrl)
local OneData = DataClass("OneData", RankItemShow)

function UIRankDetailListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIRankDetailList)
end

function UIRankDetailListCtrl:GetSelfData(global, theType)
  local oneData = OneData.New()
  local Player = LuaEntry.Player
  local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if theType == RankingTypeServer.POWER_ALLIANCE or theType == RankingTypeServer.KILL_ALLIANCE then
    oneData.isAlliance = true
    oneData.type = theType
    oneData.serverId = LuaEntry.Player.serverId
    if Player:IsInAlliance() and allianceData ~= nil then
      oneData.rank = -1
      oneData.icon = allianceData.icon
      oneData.uid = Player.allianceId
      oneData.firstName = "[" .. allianceData.abbr .. "] " .. allianceData.allianceName
      if theType == RankingTypeServer.POWER_ALLIANCE then
        oneData.power = string.GetFormattedSeperatorNum(allianceData.fightPower)
      elseif theType == RankingTypeServer.KILL_ALLIANCE then
        if global == 1 then
          oneData.power = string.GetFormattedSeperatorNum(DataCenter.RankDataManager.allianceSelfKillGlobal)
        else
          oneData.power = string.GetFormattedSeperatorNum(DataCenter.RankDataManager.allianceSelfKill)
        end
      else
        oneData.power = "0"
      end
    else
      oneData.uid = nil
      oneData.firstName = "-"
      oneData.icon = nil
      oneData.power = "0"
      oneData.rank = "50+"
    end
  else
    oneData.isAlliance = false
    oneData.type = theType
    oneData.serverId = LuaEntry.Player.serverId
    local info = DataCenter.PlayerInfoDataManager.selfPlayerData
    if info ~= nil then
      oneData.rank = -1
      if theType == RankingTypeServer.POWER then
        oneData.power = string.GetFormattedSeperatorNum(info.power or 0)
      elseif theType == RankingTypeServer.KILL then
        oneData.power = string.GetFormattedSeperatorNum(info.armyKill or 0)
      elseif theType == RankingTypeServer.HERO_TOTAL_POWER then
        oneData.power = string.GetFormattedSeperatorNum(info.heroPower or 0)
      elseif theType == RankingTypeServer.PVE_STAGE then
        local isMonopolyEnd = DataCenter.MonopolyManager:GetIsEnd()
        local isJeepAdventureOpen = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_OPEN_TOWER_JEEP_ADVENTURE)
        local targetStageId = DataCenter.StageManager.stageId
        if not isMonopolyEnd then
          targetStageId = DataCenter.StageManager.stageId
        elseif 0 < isJeepAdventureOpen then
          local curStageId = DataCenter.LWTowerUpStageManager:GetCurStageId()
          local stageMeta = DataCenter.TowerUpTemplateManager:GetTowerUpUnlockTemplate(curStageId)
          if stageMeta ~= nil then
            targetStageId = stageMeta.idle_reward_stageid
          end
        end
        local pveMaxStage = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), targetStageId, "order", 0) or 0
        if pveMaxStage ~= nil and pveMaxStage ~= 0 then
          oneData.power = string.GetFormattedSeperatorNum(pveMaxStage)
        else
          oneData.power = string.GetFormattedSeperatorNum(info.pveMaxStage or 0)
        end
      elseif theType == RankingTypeServer.DOMINATOR_UP_PVE then
        local targetStageId = 0
        local curStageId = DataCenter.LWDominatorUpStageManager:GetCurStageId()
        local stageMeta = DataCenter.DominatorUpTemplateManager:GetDominatorUpUnlockTemplate(curStageId)
        if stageMeta ~= nil then
          targetStageId = stageMeta.idle_reward_stageid
        end
        local pveMaxStage = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), targetStageId, "order", 0) or 0
        oneData.power = string.GetFormattedSeperatorNum(pveMaxStage or 0)
      elseif theType == RankingTypeServer.ONE_HERO_POWER then
        local heroData = DataCenter.HeroDataManager:GetBestHeroByPower()
        if heroData ~= nil then
          oneData.heroId = heroData.heroId
          oneData.power = string.GetFormattedSeperatorNum(heroData.power or 0)
        else
          oneData.heroId = info.heroId
          oneData.power = string.GetFormattedSeperatorNum(info.power or 0)
        end
      elseif theType == RankingTypeServer.BUILDING then
        oneData.power = string.GetFormattedSeperatorNum(DataCenter.BuildManager.MainLv)
      elseif theType == RankingTypeServer.TRIAL_TOWER_AIRPLANE or theType == RankingTypeServer.TRIAL_TOWER_TANK or theType == RankingTypeServer.TRIAL_TOWER_MISSILE then
        oneData.power = DataCenter.RankDataManager:GetTrailTowerRankStageData(global, theType, LuaEntry.Player.serverId)
      elseif theType == RankingTypeServer.T11_IDLE_GAME then
        local mainData = DataCenter.T11IdleGameDataManager:GetMainData()
        if mainData then
          local levelTemplate = mainData:GetCurLevelTemplate()
          local bossTemplate = mainData:GetLastWinedBossTemplate()
          if bossTemplate then
            oneData.power = levelTemplate:GetName() .. "-" .. bossTemplate.boss_order
          else
            oneData.power = levelTemplate:GetName() .. "-" .. "0"
          end
        end
      end
    else
      oneData.rank = "100+"
      oneData.power = "0"
    end
    if allianceData == nil or allianceData.abbr == nil or allianceData.abbr == "" then
      oneData.firstName = Player:GetName()
    elseif LuaEntry.Player:IsInAlliance() then
      oneData.firstName = "[" .. allianceData.abbr .. "] " .. Player:GetName()
    else
      oneData.firstName = Player:GetName()
    end
    oneData.uid = Player:GetUid()
    oneData.pic = Player:GetPic()
    oneData.picVer = Player.picVer
    oneData.headFrame = Player:GetHeadBgImg()
  end
  return oneData
end

function UIRankDetailListCtrl:GetOneDataShow(isAlliance, type, item)
  local oneData = OneData.New()
  oneData.isAlliance = isAlliance
  oneData.type = type
  if item ~= nil then
    oneData.uid = item.uid
    oneData.rank = item.rank
    oneData.serverId = item.srcServer
    if isAlliance then
      oneData.allianceName = item.allianceName
      oneData.firstName = "[" .. item.allianceAbbr .. "] " .. item.allianceName
      oneData.icon = item.icon
      if type == RankingTypeServer.POWER_ALLIANCE then
        oneData.power = string.GetFormattedSeperatorNum(item.power or 0)
      elseif type == RankingTypeServer.KILL_ALLIANCE then
        oneData.power = string.GetFormattedSeperatorNum(item.kill or 0)
      end
    else
      local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(item.uid, item.name)
      if item.abbr == nil or item.abbr == "" then
        oneData.firstName = showName
      elseif item.uid == LuaEntry.Player.uid then
        if LuaEntry.Player:IsInAlliance() then
          oneData.firstName = "[" .. item.abbr .. "] " .. showName
        else
          oneData.firstName = showName
        end
      else
        oneData.firstName = "[" .. item.abbr .. "] " .. showName
      end
      if type == RankingTypeServer.POWER then
        oneData.power = string.GetFormattedSeperatorNum(item.power or 0)
      elseif type == RankingTypeServer.KILL then
        oneData.power = string.GetFormattedSeperatorNum(item.kill or 0)
      elseif type == RankingTypeServer.HERO_TOTAL_POWER then
        oneData.power = string.GetFormattedSeperatorNum(item.heroPower or 0)
      elseif type == RankingTypeServer.PVE_STAGE then
        oneData.power = string.GetFormattedSeperatorNum(item.pveMaxStage or 0)
      elseif type == RankingTypeServer.ONE_HERO_POWER then
        oneData.power = string.GetFormattedSeperatorNum(item.power or 0)
        oneData.heroId = item.heroId
      elseif type == RankingTypeServer.BUILDING then
        oneData.power = string.GetFormattedSeperatorNum(item.baseLevel or 0)
      elseif type == RankingTypeServer.TRIAL_TOWER_MISSILE or type == RankingTypeServer.TRIAL_TOWER_TANK or type == RankingTypeServer.TRIAL_TOWER_AIRPLANE then
        oneData.power = item.stageGroup .. "-" .. item.stageOrder
      elseif type == RankingTypeServer.DOMINATOR_UP_PVE then
        oneData.power = string.GetFormattedSeperatorNum(item.dominatorId or 0)
      elseif type == RankingTypeServer.T11_IDLE_GAME then
        oneData.power = ""
        if item.idleGameLevel then
          local levelTemplate = DataCenter.T11IdleGameTemplateManager:GetLevelTemplateById(item.idleGameLevel)
          if levelTemplate then
            local str = levelTemplate:GetName()
            if item.idleGameBoss and 0 < item.idleGameBoss then
              local bossTemplate = DataCenter.T11IdleGameTemplateManager:GetBossTemplateById(item.idleGameBoss)
              if bossTemplate then
                str = str .. "-" .. bossTemplate.boss_order
              end
            end
            oneData.power = str
          end
        end
      end
      oneData.pic = item.pic
      oneData.picVer = item.picVer
      oneData.headFrame = item:GetHeadBgImg()
    end
  else
    oneData.uid = ""
    oneData.firstName = "-"
    oneData.rank = "-"
    oneData.power = 0
  end
  return oneData
end

function UIRankDetailListCtrl:GetRankList(global, type, serverId)
  local showList, index = {}, 1
  if type == RankingTypeServer.POWER_ALLIANCE or type == RankingTypeServer.KILL_ALLIANCE then
    local list = DataCenter.RankDataManager:GetAllianceRankListByType(global, type, serverId)
    table.walk(list, function(k, v)
      local oneData = self:GetOneDataShow(true, type, v)
      if oneData ~= nil then
        showList[index] = oneData
        index = index + 1
      end
    end)
  else
    local list = DataCenter.RankDataManager:GetPlayerRankListByType(global, type, serverId)
    table.walk(list, function(k, v)
      local oneData = self:GetOneDataShow(false, type, v)
      if oneData ~= nil then
        showList[index] = oneData
        index = index + 1
      end
    end)
  end
  return showList
end

function UIRankDetailListCtrl:OnPlayerDetailClick(serverId, playerUid)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, {serverId = serverId, uid = playerUid})
end

function UIRankDetailListCtrl:OnAllianceDetailClick(serverId, uid, name)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true, hideTop = false}, name, uid, serverId)
end

return UIRankDetailListCtrl
