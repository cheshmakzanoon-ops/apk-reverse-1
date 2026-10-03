local rapidjson = require("rapidjson")
local MailShowHelper = {}
local Localization = CS.GameEntry.Localization
local base64 = require("Framework.Common.base64")
local MailBattleParseHelper = require("DataCenter.MailData.MailBattleParseHelper")
local MailParseHelper = require("DataCenter.MailData.MailParseHelper")

function MailShowHelper.IsSeasonBattleMail(mailType, battleType)
  if mailType == MailType.LW_SEASON_DESERT_BATTLE_MAIL or mailType == MailType.LW_SEASON_PLAYER_BATTLE_MAIL or mailType == MailType.LW_SEASON_AL_CENTER_BATTLE_MAIL then
    return true
  end
  if battleType == MailBattleReportType.SEASON_DESERT_BATTLE or battleType == MailBattleReportType.SEASON_PLAYER_BUILDING_BATTLE or battleType == MailBattleReportType.SEASON_AL_BUILDING_BATTLE or battleType == MailBattleReportType.MUSE_MUMMY or battleType == MailBattleReportType.MUMMY_PATROL or battleType == MailBattleReportType.MUMMY_MONSTER_ATTACK_AL_BUILDING or battleType == MailBattleReportType.DARKNESS_MONSTER_ATTACK_CITY or battleType == MailBattleReportType.DARKNESS_MONSTER_ATTACK_AL_BUILDING or battleType == MailBattleReportType.ALLIANCE_BUILDING_FURNACE or battleType == MailBattleReportType.CITY_OUTPOST or battleType == MailBattleReportType.ROB_STRONGHOLD_BANK then
    return true
  end
  return false
end

function MailShowHelper.GetMailIcon(mailInfo)
  if mailInfo == nil then
    return ""
  end
  local mailType = mailInfo.type
  if IsMailNewFightType(mailType) then
    if mailInfo:GetMailExt():IsExistMonsterBattle() then
      return "icon_battle_pve"
    end
    return "icon_battle_win"
  elseif IsMailScoutType(mailType) or IsMailBeScoutType(mailType) or mailType == MailType.LW_SEASON_SCOUT_MAIL then
    return "icon_scout"
  elseif mailType == MailType.MARCH_DESTROY_MAIL then
    return "icon_battle_win"
  end
  return ""
end

function MailShowHelper.GetMainTitle(mailInfo)
  if mailInfo == nil then
    return ""
  end
  local mailType = mailInfo.type
  if mailType == MailType.NEW_COLLECT_MAIL then
    return Localization:GetString("310121")
  elseif mailType == MailType.MONSTER_COLLECT_REWARD then
    return Localization:GetString("310173")
  elseif mailType == MailType.MARCH_DESTROY_MAIL then
    return MailShowHelper.GetMailMainTitle_DestroyBuild(mailInfo)
  elseif IsMailNewFightType(mailType) or mailType == MailType.TRUCK_BATTLE_REPORT or mailType == MailType.TRAIN_3V3 or mailType == MailType.ZONE_TRAIN_BATTLE_RESULT or mailType == MailType.TRAIN_KOF or mailType == MailType.NEW_ARENA_KOF_BATTLE then
    return MailShowHelper.GetMailMainTitle_NewFight(mailInfo)
  elseif mailType == MailType.MAIL_EXPLORE then
    return MailShowHelper.GetMailMainTitle_Explore(mailInfo)
  elseif mailType == MailType.MAIL_ALLIANCE_ALL then
    return MailShowHelper.GetMailMailTitle_AllianceAll(mailInfo)
  elseif mailType == MailType.ELITE_FIGHT_MAIL then
    return MailShowHelper.GetMailMailTitle_EliteFightMail(mailInfo)
  elseif mailType == MailType.ALLIANCE_CITY_RANK then
    return MailShowHelper.GetMailMainTitle_DestroyRankList(mailInfo)
  elseif mailType == MailType.COLLECT_OVER_FLOW_MAIL then
    return Localization:GetString("312083")
  elseif mailType == MailType.FIGHT_MONSTER or mailType == MailType.RUNNING_BOSS_ATTACK_CITY or mailType == MailType.RUNNING_MUMMY_ATTACK_CITY or mailType == MailType.LW_ZOMBIE_RUSH_BOSS_ATTACK_CITY or mailType == MailType.ALLIANCE_BOSS_SAND_ATTACK_CITY or mailType == MailType.BLOOD_QUEEN_MONSTER_ATTACK_CITY then
    return MailShowHelper.GetMailMainTitle_Monster(mailInfo)
  elseif mailType == MailType.HOSPITAL_FULL then
    return Localization:GetString(GameDialogDefine.HOSPITAL_IS_FULL)
  elseif mailType == MailType.LW_REBIRTH_HOSPITAL_DEAD then
    return Localization:GetString("mail_title_emergency_center")
  elseif mailType == MailType.TranslationRating or mailType == MailType.Automatic_TranslationRating then
    return MailShowHelper.GetMailMainTitle_TranslationRating(mailInfo)
  elseif MailShowHelper.IsSeasonBattleMail(mailType) then
    return MailShowHelper.GetMailMainTitle_NewFight(mailInfo)
  elseif mailType == MailType.LW_Notice_Vote then
    return Localization:GetString("poll_result_mail_title")
  elseif mailType == MailType.LANDMINE then
    local ext = mailInfo:GetMailExt()
    local ret = Localization:GetString("season_mastery_s2_UI_2")
    if ext then
      local color = ext:IsPassive() and "#C80700" or "#007F00"
      return string.format("<color=%s>%s</color>", color, ret)
    end
    return string.format("<color=%s>%s</color>", "#007F00", ret)
  elseif mailType == MailType.DISGUISE_ATTACK then
    local ext = mailInfo:GetMailExt()
    local ret = Localization:GetString("season_mastery_s3_mail_1")
    if ext then
      local color = ext:IsPassive() and "#C80700" or "#007F00"
      return string.format("<color=%s>%s</color>", color, ret)
    end
    return string.format("<color=%s>%s</color>", "#007F00", ret)
  elseif mailType == MailType.LW_SEASON_BREAK_ICE_MAIL then
    return Localization:GetString("season_s2_ice_crush_mail_tittle01")
  elseif mailType == MailType.ARENA_BATTLE_REPORT then
    return MailShowHelper.GetMailMainTitle_ArenaBattleReport(mailInfo)
  elseif mailType == MailType.LW_METEORITE_COLLECT then
    return Localization:GetString("310121")
  elseif mailType == MailType.ROB_BANK_MAIL then
    return Localization:GetString("s5_bank_mail_tittle")
  elseif mailType == MailType.LANDLORD_WEEK_RESULT then
    return Localization:GetString("zonewar_landlord_mail_tittle_1007")
  else
    return mailInfo:GetMailTitle()
  end
end

function MailShowHelper.GetMailMainTitle_DestroyRankList(mailInfo)
  local mailExt = mailInfo:GetMailExt()
  if mailExt ~= nil then
    return mailExt:GetTitle()
  end
  return ""
end

function MailShowHelper.GetMailMainTitle_DestroyBuild(mailInfo)
  local mailExt = mailInfo:GetMailExt()
  if mailExt ~= nil then
    return mailExt:GetTitle()
  end
  return ""
end

function MailShowHelper.GetMailMailTitle_EliteFightMail(mailInfo)
  return Localization:GetString("302022")
end

function MailShowHelper.GetMailMainTitle_Monster(mailInfo)
  local mailExt = mailInfo:GetMailExt()
  if mailExt and (mailExt.battleType == MailBattleReportType.ActBoss or mailExt.battleType == MailBattleReportType.ALLIANCE_BOSS or mailExt.battleType == MailBattleReportType.ACT_BERSERK_BOSS or mailExt.battleType == MailBattleReportType.ALLIANCE_MONSTER_CHALLENGE_KIROV or mailExt.battleType == MailBattleReportType.CITY_BATTLE_S1_REST_ATTACK_MONSTER or mailExt.battleType == MailBattleReportType.ALLIANCE_BOSS_S0) then
    return Localization:GetString(456012)
  end
  local resultState = mailExt:GetBattleResultStatus()
  local color = resultState == FightResult.SELF_WIN and "#007F00" or "#C80700"
  local dialogId = resultState == FightResult.SELF_WIN and GameDialogDefine.WIN or GameDialogDefine.FAIL
  local ret = Localization:GetString(dialogId)
  ret = string.format("<color=%s>%s</color>", color, ret)
  return ret
end

function MailShowHelper.GetMailMainTitle_NewFight(mailInfo)
  local dialogId, color = MailShowHelper.GetMailMainTitle_NewFight_ForShare(mailInfo)
  local ret = Localization:GetString(dialogId)
  ret = string.format("<color=%s>%s</color>", color, ret)
  return ret
end

function MailShowHelper.GetMailMainTitle_NewFight_ForShare(mailInfo)
  local ext = mailInfo:GetMailExt()
  local resultState = ext:GetBattleResultStatus()
  local dialogId = ""
  local color = "#C80700"
  if resultState == FightResult.SELF_WIN then
    if ext:IsMyAttackCity() then
      dialogId = "311107"
    elseif ext:IsMyProtectCity() then
      if ext:IsAssistanceProtectedCity() then
        dialogId = "world_tip10021"
      else
        dialogId = "311109"
      end
    else
      dialogId = "312095"
    end
    color = "#007F00"
  elseif resultState == FightResult.OTHER_WIN then
    if mailInfo:GetMailExt():IsMyAttackCity() then
      dialogId = "311108"
    elseif mailInfo:GetMailExt():IsMyProtectCity() then
      if ext:IsAssistanceProtectedCity() then
        dialogId = "world_tip10022"
      else
        dialogId = "311110"
      end
    else
      dialogId = "312096"
    end
  else
    dialogId = "311132"
  end
  return dialogId, color
end

function MailShowHelper.GetMailMainTitle_ArenaBattleReport(mailInfo)
  local resultState = mailInfo:GetMailExt():GetBattleResultStatus()
  local dialogId = ""
  local color = "#C80700"
  if resultState == FightResult.SELF_WIN then
    dialogId = "new_arena_tips_86"
    color = "#007F00"
  elseif resultState == FightResult.OTHER_WIN then
    dialogId = "new_arena_tips_87"
  end
  local ret = Localization:GetString(dialogId)
  ret = string.format("<color=%s>%s</color>", color, ret)
  return ret
end

function MailShowHelper.GetMailMainTitle_Explore(mailInfo)
  local isWin = mailInfo:GetMailExt():GetExploreWin()
  local name = mailInfo:GetMailExt():GetName()
  if isWin then
    return Localization:GetString("140057", name)
  else
    return Localization:GetString("140058", name)
  end
end

function MailShowHelper.GetMailMailTitle_AllianceAll(mailInfo)
  return mailInfo.fromName
end

function MailShowHelper.GetMailMainTitle_TranslationRating(mailInfo)
  local mailExt = mailInfo:GetMailExt()
  if mailExt ~= nil then
    return mailExt:GetTitle()
  end
  return ""
end

function MailShowHelper.GetMailMainTitle_Season(mailInfo)
  local mailExt = mailInfo:GetMailExt()
  if mailExt and (mailExt.battleType == MailBattleReportType.SEASON_DESERT_BATTLE or mailExt.battleType == MailBattleReportType.SEASON_PLAYER_BUILDING_BATTLE) then
    local resultState = mailExt:GetBattleResultStatus()
    local color = resultState == FightResult.SELF_WIN and "#007F00" or "#C80700"
    local dialogId = resultState == FightResult.SELF_WIN and "312095" or "312096"
    return string.format("<color=%s>%s</color>", color, Localization:GetString(dialogId))
  end
  return Localization:GetString("311132")
end

function MailShowHelper.GetMailSubTitle(mailInfo)
  if mailInfo == nil then
    return ""
  end
  local mailType = mailInfo.type
  if IsMailNewFightType(mailType) or mailType == MailType.ARENA_BATTLE_REPORT then
    return MailShowHelper.GetMailSubTitle_NewFight(mailInfo)
  elseif IsMailBeScoutType(mailType) or IsMailScoutType(mailType) or mailType == MailType.LW_SEASON_SCOUT_MAIL then
    return MailShowHelper.GetMailSubTitle_Scout(mailInfo)
  elseif mailType == MailType.TRUCK_BATTLE_REPORT or mailType == MailType.TRAIN_3V3 or mailType == MailType.TRAIN_KOF or mailType == MailType.NEW_ARENA_KOF_BATTLE or mailType == MailType.ZONE_TRAIN_BATTLE_RESULT then
    return MailShowHelper.GetMailSubTitle_RobTrain(mailInfo)
  elseif mailType == MailType.FIGHT_MONSTER or mailType == MailType.RUNNING_BOSS_ATTACK_CITY or mailType == MailType.RUNNING_MUMMY_ATTACK_CITY or mailType == MailType.ALLIANCE_BOSS_SAND_ATTACK_CITY or mailType == MailType.LW_ZOMBIE_RUSH_BOSS_ATTACK_CITY or mailType == MailType.BLOOD_QUEEN_MONSTER_ATTACK_CITY then
    return MailShowHelper.GetMailSubTitle_Monster(mailInfo)
  elseif mailType == MailType.NEW_COLLECT_MAIL or mailType == MailType.MONSTER_COLLECT_REWARD or mailType == MailType.COLLECT_OVER_FLOW_MAIL or mailType == MailType.LW_METEORITE_COLLECT then
    return ""
  elseif mailType == MailType.MAIL_PICK_GARBAGE then
    return MailShowHelper.GetMailSubTitle_PickGarbage(mailInfo)
  elseif mailType == MailType.MAIL_EXPLORE then
    return MailShowHelper.GetMailSubTitle_Explore(mailInfo)
  elseif mailType == MailType.ALLIANCE_CITY_OCCUPIED_REWARD then
    return MailShowHelper.GetMailSubTitle_Neutral(mailInfo)
  elseif mailType == MailType.MARCH_DESTROY_MAIL then
    return MailShowHelper.GetMailSubTitle_DestroyBuild(mailInfo)
  elseif mailType == MailType.MAIL_ALLIANCE_ALL then
    return MailShowHelper.GetMailSubTitle_AllianceAll(mailInfo)
  elseif mailType == MailType.ELITE_FIGHT_MAIL then
    return MailShowHelper.GetMailSubTitle_EliteFightMail(mailInfo)
  elseif mailType == MailType.MAIL_ALLIANCE_INVITE then
    return MailShowHelper.GetMailSubTitle_AllianceInvite(mailInfo)
  elseif mailType == MailType.HOSPITAL_FULL then
    return Localization:GetString(801510, mailInfo:GetMailParam(2))
  elseif mailType == MailType.LW_Notice_Vote then
    local json = rapidjson.decode(mailInfo.contents)
    local extra = json and json.b.extra
    local title = ""
    if type(extra) == "table" then
      title = extra.voteInfo.title
    elseif type(extra) == "string" then
      local extraData = rapidjson.decode(extra)
      title = extraData.voteInfo.title
    end
    return title
  elseif MailShowHelper.IsSeasonBattleMail(mailType) then
    return MailShowHelper.GetMailSubTitle_NewFight(mailInfo)
  elseif mailType == MailType.LW_REBIRTH_HOSPITAL_DEAD then
    return Localization:GetString("emergency_center_desc_1008", mailInfo:GetMailParam(2))
  elseif mailType == MailType.LANDMINE then
    local data = mailInfo:GetMailExt()
    if data then
      local meta = DataCenter.WorldTriggerTemplateManager:GetMeta(data.cfgId)
      local isPassive = data:IsPassive()
      local name = isPassive and data.hunter.name or data.prey.name
      local langKey = isPassive and "season_mastery_s2_UI_7" or "season_mastery_s2_UI_6"
      return Localization:GetString(langKey, name, meta:GetName())
    end
    return ""
  elseif mailType == MailType.DISGUISE_ATTACK then
    local data = mailInfo:GetMailExt()
    if data then
      local isPassive = data:IsPassive()
      local langKey = isPassive and "season_mastery_s3_mail_5" or "season_mastery_s3_mail_4"
      return Localization:GetString(langKey)
    end
    return ""
  elseif mailType == MailType.LW_SEASON_BREAK_ICE_MAIL then
    return MailShowHelper.GetBreakIceTargetNameAndIcon(mailInfo)
  elseif mailType == MailType.ATTACK_RUIN_BUILDING then
    local data = mailInfo:GetMailSFSObj()
    return Localization:GetString("Teleport_Territory_mailDes_2", data and data.dmg or 0)
  elseif mailType == MailType.SEASON_BANK then
    local data = mailInfo:GetMailSFSObj()
    if not data or not data.depositAmount then
      return Localization:GetString("mail_tips002", MailShowHelper.GetMainTitle(mailInfo))
    end
    local subTitle = DataCenter.SeasonBankTemplateManager.subTitle[data.logTypeCode or 1]
    return subTitle and Localization:GetString(subTitle, data.depositAmount, data.depositDays, data.settleAmount) or mailInfo:GetMailSubTitle()
  elseif mailType == MailType.ROB_BANK_MAIL then
    local data = mailInfo:GetMailSFSObj()
    return Localization:GetString("s5_bank_mail_desc", data and data.extra and data.extra.robAmount or 0)
  else
    return mailInfo:GetMailSubTitle()
  end
end

function MailShowHelper.GetMailSummary(mailInfo, withoutlink)
  if mailInfo == nil then
    return ""
  end
  local mailType = mailInfo.type
  if mailType == MailType.NEW_FIGHT then
    return MailShowHelper.GetMailSummary_NewFight(mailInfo, withoutlink)
  elseif mailType == MailType.MARCH_DESTROY_MAIL then
    return MailShowHelper.GetMailSummary_DestroyBuild(mailInfo, withoutlink)
  else
    return MailShowHelper.GetMailSubTitle(mailInfo)
  end
end

function MailShowHelper.GetMailSubTitle_EliteFightMail(mailInfo)
  local mailExt = mailInfo:GetMailExt()
  local phaseStr = ""
  if mailExt == nil then
    return phaseStr
  end
  if mailExt.phase == ChampionBattlePosterType.Strongest_Eight then
    phaseStr = "302071"
  elseif mailExt.phase == ChampionBattlePosterType.Strongest_Four then
    phaseStr = "302072"
  elseif mailExt.phase == ChampionBattlePosterType.Strongest_Two then
    phaseStr = "302073"
  else
    return Localization:GetString("302047")
  end
  return Localization:GetString(phaseStr, mailExt.round, "")
end

function MailShowHelper.GetMailSubTitle_AllianceInvite(mailInfo)
end

function MailShowHelper.GetMailSubTitle_Season(mailInfo)
  local mailExt = mailInfo:GetMailExt()
  if mailExt and mailExt.pb_BattleReport and (mailExt.battleType == MailBattleReportType.SEASON_DESERT_BATTLE or mailExt.battleType == MailBattleReportType.SEASON_PLAYER_BUILDING_BATTLE) then
    local pointInfo = mailExt.pb_BattleReport.battlePointInfo
    if pointInfo then
      local name = Localization:GetString("100610")
      local player = mailExt.player
      if player and 1 < #player then
        local thePlayer = player[2]
        local meta = thePlayer.meta
        if meta and thePlayer.armyType == MailTargetType.SeasonDesert then
          name = thePlayer.name
        elseif meta and thePlayer.armyType == MailTargetType.SeasonBuilding then
          name = thePlayer.name
        elseif meta and thePlayer.armyType == MailTargetType.SeasonCenter then
          name = thePlayer.name
        end
      end
      local inSrcServer = LuaEntry.Player:IsInSourceServer()
      local mySrcServer = LuaEntry.Player:GetSourceServerId()
      local v2 = SceneUtils.IndexToTilePos(pointInfo.pointId, ForceChangeScene.World)
      if pointInfo.battleServerId ~= nil and (pointInfo.battleServerId ~= mySrcServer or not inSrcServer) then
        return string.format("%s (#%s X:%s,Y:%s) ", name, pointInfo.battleServerId, v2.x, v2.y)
      else
        return string.format("%s (X:%s,Y:%s)", name, v2.x, v2.y)
      end
    end
  end
  return mailInfo:GetMailSubTitle()
end

function MailShowHelper.GetMailSubTitle_DestroyBuild(mailInfo)
  local mailExt = mailInfo:GetMailExt()
  if mailExt ~= nil then
    return mailExt:GetName()
  end
  return ""
end

function MailShowHelper.GetMailSummary_DestroyBuild(mailInfo, withoutlink)
  local mailExt = mailInfo:GetMailExt()
  if mailExt ~= nil then
    return mailExt:GetSummary(withoutlink)
  end
  return ""
end

function MailShowHelper.GetMailSubTitle_AllianceAll(mailInfo)
  return Localization:GetString("141064") .. mailInfo:GetMailTitle()
end

function MailShowHelper.GetMailSubTitle_NewFight_ForShare(mailInfo)
  local param = {}
  local targetName = mailInfo:GetMailExt():GetTargetName_ForShare()
  local isWin = mailInfo:GetMailExt():GetBattleWin()
  if isWin then
    if mailInfo:GetMailExt():IsMyAttackCity() then
      local roundItem = mailInfo:GetMailExt():GetFightReportByRoundIndex(1)
      if roundItem ~= nil then
        local username = roundItem:GetForceTargetName()
        local targetName1 = mailInfo:GetMailExt():GetBuildingName_ForShare(false)
        param.dialogId = "311099"
        param.param1 = username
        param.param2 = targetName1
        return param
      end
    elseif mailInfo:GetMailExt():IsMyProtectCity() then
      local targetName1 = mailInfo:GetMailExt():GetBuildingName_ForShare(true)
      param.dialogId = "311101"
      param.param1 = targetName
      param.param2 = targetName1
      return param
    else
      param.dialogId = "311097"
    end
  elseif mailInfo:GetMailExt():IsMyAttackCity() then
    local roundItem = mailInfo:GetMailExt():GetFightReportByRoundIndex(1)
    if roundItem ~= nil then
      local username = roundItem:GetForceTargetName()
      local targetName1 = mailInfo:GetMailExt():GetBuildingName_ForShare(false)
      param.dialogId = "311100"
      param.param1 = username
      param.param2 = targetName1
      return param
    end
  elseif mailInfo:GetMailExt():IsMyProtectCity() then
    local targetName1 = mailInfo:GetMailExt():GetBuildingName_ForShare(true)
    param.dialogId = "311102"
    param.param1 = targetName
    param.param2 = targetName1
    return param
  else
    param.dialogId = "311098"
  end
  param.param1 = targetName
  return param
end

function MailShowHelper.GetMailSummary_NewFight(mailInfo, withoutlink)
  local battleFightPt = mailInfo:GetMailExt():GetBattleFightPointId()
  local battleServerId = mailInfo:GetMailExt():GetBattleServerId()
  local strLink = ""
  if 0 < battleFightPt then
    local battleFightV2Pt = SceneUtils.IndexToTilePos(battleFightPt, ForceChangeScene.World)
    local strBattlePt = " (" .. tostring(battleFightV2Pt.x) .. ", " .. tostring(battleFightV2Pt.y) .. ")"
    local link = {
      action = "Jump",
      pointId = battleFightPt,
      server = battleServerId
    }
    local json = rapidjson.encode(link)
    json = base64.encode(json)
    strLink = "<link=" .. json .. "><u>" .. strBattlePt .. "</u></link>"
    if withoutlink then
      strLink = ""
    end
  end
  local targetName = mailInfo:GetMailExt():GetTargetName()
  local dialogId = ""
  local isWin = mailInfo:GetMailExt():GetBattleWin()
  if isWin then
    if mailInfo:GetMailExt():IsMyAttackCity() then
      local roundItem = mailInfo:GetMailExt():GetFightReportByRoundIndex(1)
      if roundItem ~= nil then
        local username = roundItem:GetForceTargetName()
        local targetName1 = mailInfo:GetMailExt():GetBuildingName(false)
        return Localization:GetString("311099", username, targetName1) .. strLink
      end
    elseif mailInfo:GetMailExt():IsMyProtectCity() then
      local sBuildingName = mailInfo:GetMailExt():GetBuildingName(true)
      return Localization:GetString("311101", targetName, sBuildingName) .. strLink
    else
      dialogId = "311097"
    end
  elseif mailInfo:GetMailExt():IsMyAttackCity() then
    local roundItem = mailInfo:GetMailExt():GetFightReportByRoundIndex(1)
    if roundItem ~= nil then
      local username = roundItem:GetForceTargetName()
      local targetName1 = mailInfo:GetMailExt():GetBuildingName(false)
      return Localization:GetString("311100", username, targetName1) .. strLink
    end
  elseif mailInfo:GetMailExt():IsMyProtectCity() then
    local sBuildingName = mailInfo:GetMailExt():GetBuildingName(true)
    return Localization:GetString("311102", targetName, sBuildingName) .. strLink
  else
    dialogId = "311098"
  end
  return Localization:GetString(dialogId, targetName) .. strLink
end

function MailShowHelper.GetMailSubTitle_Monster(mailInfo)
  return mailInfo:GetMailExt():GetTargetName()
end

function MailShowHelper.GetMailSubTitle_NewFight(mailInfo)
  local targetName = mailInfo:GetMailExt():GetTargetName()
  local dialogId = ""
  local mailData = mailInfo:GetMailExt()
  local totalKill = mailData:GetEnemyTotalDeath()
  if mailData:GetBattleWin() then
    if mailData:GetBattleAttack() then
      dialogId = totalKill and 801508 or GameDialogDefine.MAIL_ATTACK_VICTORY
    else
      dialogId = totalKill and 801505 or GameDialogDefine.MAIL_DEFENCE_VICTORY
    end
  elseif mailData:GetBattleAttack() then
    dialogId = totalKill and 801509 or GameDialogDefine.MAIL_ATTACK_FAIL
  else
    dialogId = totalKill and 801506 or GameDialogDefine.MAIL_DEFENCE_FAIL
  end
  return Localization:GetString(dialogId, targetName, totalKill, nil)
end

function MailShowHelper.GetMailSubTitle_Scout(mailData)
  local subTitle = mailData:GetMailSubTitle()
  local player
  if IsMailScoutType(mailData.type) or mailData.type == MailType.LW_SEASON_SCOUT_MAIL then
    local data = mailData:GetMailExt():GetExtData()
    player = data.targetUser
  elseif IsMailBeScoutType(mailData.type) then
    local data = rapidjson.decode(mailData.contents).b
    player = data.userInfo
  end
  if player then
    if MailBattleParseHelper.IsWerewolf(player) then
      local wolf = Localization:GetString(GameDialogDefine.WEREWOLF)
      local name = player.name
      subTitle = string.gsub(subTitle, "%[.*%] ", "")
      subTitle = string.plain_gsub(subTitle, name, wolf, 1)
    else
      local remarkName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(player.uid, player.name)
      subTitle = string.plain_gsub(subTitle, player.name, remarkName, 1)
    end
  end
  return subTitle
end

function MailShowHelper.GetMailSubTitle_RobTrain(mailInfo)
  local targetName = mailInfo:GetMailExt():GetTargetName()
  local dialogId = ""
  local mailData = mailInfo:GetMailExt()
  if mailData:GetBattleWin() then
    if mailData:GetBattleAttack() then
      dialogId = GameDialogDefine.MAIL_ATTACK_VICTORY
    else
      dialogId = GameDialogDefine.MAIL_DEFENCE_VICTORY
    end
  elseif mailData:GetBattleAttack() then
    dialogId = GameDialogDefine.MAIL_ATTACK_FAIL
  else
    dialogId = GameDialogDefine.MAIL_DEFENCE_FAIL
  end
  return Localization:GetString(dialogId, targetName)
end

function MailShowHelper.GetMailSubTitle_RebirthHospitalFull(mailInfo)
  return Localization:GetString("emergency_center_mail_desc")
end

function MailShowHelper.GetMailSubTitle_PickGarbage(mailInfo)
  local mailExt = mailInfo:GetMailExt()
  if mailExt ~= nil then
    return mailExt:GetName()
  end
  return ""
end

function MailShowHelper.GetMailSubTitle_Neutral(mailInfo)
  local tabHeader = mailInfo.tabHeader or {}
  local h = tabHeader.h or {}
  local subTitle = h.subTitle or {}
  local dialog = subTitle.dialog or {}
  local dialogId = dialog.id
  local params = dialog.params or {}
  local strPos = ""
  if table.count(params) > 0 then
    local point = params[1].point or {}
    local server = point.server or 0
    local x = point.x or 0
    local y = point.y or 0
    strPos = Localization:GetString("128005", server, x, y)
  end
  local contents = mailInfo.contents or ""
  contents = rapidjson.decode(contents) or {}
  local b = contents.b or {}
  local content = b.content or {}
  local dialog = content.dialog or {}
  local params = dialog.params or {}
  local name = ""
  if table.count(params) > 0 then
    local oneParam = params[1] or {}
    local worldAllianceCity = oneParam.worldAllianceCity or {}
    local cityId = worldAllianceCity.id or 0
    name = worldAllianceCity.cityName or ""
    if 0 < cityId and (name == nil or name == "") then
      name = GetTableData(TableName.WorldCity, cityId, "name")
      if string.IsNullOrEmpty(name) then
        Logger.LogError("mail WorldCity dont have cityId:" .. cityId)
      else
        name = Localization:GetString(name)
      end
    end
  end
  if dialogId ~= nil then
    return Localization:GetString(dialogId, strPos, name)
  else
    return ""
  end
end

function MailShowHelper.GetMailSubTitle_Explore(mailInfo)
  return ""
end

function MailShowHelper.GetRelativeCreateTime(mail)
  return UITimeManager:GetInstance():GetMailShowTime(mail.createTime)
end

function MailShowHelper.GetAbstractCreateTime(mail)
  return UITimeManager:GetInstance():TimeStampToTimeForLocal(mail.createTime)
end

function MailShowHelper.GetAbstractExpireTime(mail)
  return UITimeManager:GetInstance():TimeStampToTimeForLocal(mail.expireTime)
end

function MailShowHelper.TryShareMail(mailInfo)
  local maildata = mailInfo
  if maildata == nil then
    return
  end
  if IsMailScoutType(maildata.type) or maildata.type == MailType.LW_SEASON_SCOUT_MAIL then
    local share_param = {}
    local msg = ""
    local subTitle = maildata:GetMailHeader()
    if subTitle ~= nil and subTitle.h ~= nil and subTitle.h.subTitle ~= nil then
      msg = subTitle.h.subTitle
    end
    share_param.msg = msg
    share_param.name = ""
    share_param.postType = PostType.Text_ScoutReport
    share_param.uid = maildata.uid
    share_param.mailType = maildata.type
    share_param.toUser = maildata.toUser
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
    return
  end
  local para = MailShowHelper.GetMailSubTitle_NewFight_ForShare(maildata)
  local result = maildata:GetMailExt():GetBattleWin() and "1" or "0"
  local toUser = maildata.toUser
  local mailType = maildata.type
  para.mailId = maildata.uid .. "#" .. mailType .. "#" .. toUser .. "#" .. result
  para.title = MailShowHelper.GetMailMainTitle_NewFight_ForShare(maildata)
  local subTitle = MailShowHelper.GetMailSummary(maildata, true)
  local share_param = {}
  share_param.msg = subTitle
  share_param.name = ""
  share_param.para = para
  share_param.postType = PostType.Text_Formation_Fight_Share
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
end

function MailShowHelper.GetBreakIceTargetNameAndIcon(mailInfo)
  local data = mailInfo:GetMailExt()
  local name = data:GetOtherFullName()
  return name, "Assets/Main/Sprites/UI/UILWMail/zyf_jijieyoujian_zhencha.png"
end

local function NormalizeUtf8String(str, keepOriginal, keepMapping)
  local originalChars = {}
  local normalizedChars = {}
  local mapping = {}
  local i = 1
  while i <= #str do
    local byte = str:byte(i)
    local len
    if 240 <= byte then
      len = 4
    elseif 224 <= byte then
      len = 3
    elseif 192 <= byte then
      len = 2
    else
      len = 1
    end
    local ch = str:sub(i, i + len - 1)
    local normalized = ch:lower()
    if normalized:match("[%w\228\184\128-\233\190\165]") then
      table.insert(normalizedChars, normalized)
      if keepMapping then
        table.insert(mapping, #originalChars + 1)
      end
    end
    if keepOriginal then
      table.insert(originalChars, ch)
    end
    i = i + len
  end
  return originalChars, normalizedChars, mapping
end

function MailShowHelper.GetTextWithHighlight(text, highlightTxt)
  if not text or highlightTxt == nil or highlightTxt == "" then
    return text
  end
  local success, result = pcall(function()
    local originalChars = {}
    local normalizedChars = {}
    local mapping = {}
    originalChars, normalizedChars, mapping = NormalizeUtf8String(text:gsub("<[^>]+>", ""), true, true)
    local _, highlightNorm = NormalizeUtf8String(highlightTxt, false, false)
    if #highlightNorm == 0 then
      return text
    end
    local matchStart
    for i = 1, #normalizedChars - #highlightNorm + 1 do
      local matched = true
      for j = 1, #highlightNorm do
        if normalizedChars[i + j - 1] ~= highlightNorm[j] then
          matched = false
          break
        end
      end
      if matched then
        matchStart = i
        break
      end
    end
    if not matchStart then
      return text
    end
    local startIdx = mapping[matchStart]
    local endIdx = mapping[matchStart + #highlightNorm - 1]
    local result = {}
    for i = 1, #originalChars do
      if i == startIdx then
        table.insert(result, "<color=#099b4a>")
      end
      table.insert(result, originalChars[i])
      if i == endIdx then
        table.insert(result, "</color>")
      end
    end
    return table.concat(result)
  end)
  return success and result or text
end

return MailShowHelper
