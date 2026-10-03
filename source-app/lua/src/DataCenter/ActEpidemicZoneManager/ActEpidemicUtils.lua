local Localization = CS.GameEntry.Localization
local ActEpidemicUtils = {}
ActEpidemicUtils.GroupNone = 0
ActEpidemicUtils.Group1 = 1
ActEpidemicUtils.Group2 = 2

function ActEpidemicUtils.DebugGetStageName(stage)
  if stage == EpidemicZoneStage.SignIn then
    return "\230\138\165\229\144\141"
  elseif stage == EpidemicZoneStage.Matching then
    return "\229\140\185\233\133\141"
  elseif stage == EpidemicZoneStage.MatchEnd then
    return "\229\140\185\233\133\141\229\174\140\230\136\144"
  elseif stage == EpidemicZoneStage.Prepare then
    return "\230\136\152\230\150\151\229\135\134\229\164\135"
  elseif stage == EpidemicZoneStage.Battle then
    return "\230\136\152\230\150\151\228\184\173"
  elseif stage == EpidemicZoneStage.Show then
    return "\229\177\149\231\164\186"
  elseif stage == EpidemicZoneStage.End then
    return "\231\187\147\230\157\159"
  else
    return "???"
  end
end

function ActEpidemicUtils.Log(fmt, ...)
  if not CommonUtil.IsDebug() then
    return
  end
  local _ = string.format(fmt, ...)
  _ = string.format("<color=#00FFFF>[ActEpidemic][Log]%s</color>", _)
  Logger.Log(_)
end

function ActEpidemicUtils.LogError(fmt, ...)
  local _ = string.format(fmt, ...)
  _ = string.format("<color=#FF0000>[ActEpidemic][Error]%s</color>", _)
  Logger.LogError(_)
end

ActEpidemicUtils.Error = ActEpidemicUtils.LogError

function ActEpidemicUtils.Tips(fmt, ...)
  if not CommonUtil.IsDebug() then
    return
  end
  local _ = string.format(fmt, ...)
  _ = "[ActEpidemic][Debug]" .. _
  UIUtil.ShowTips(_)
end

function ActEpidemicUtils.GetActInfo()
  return DataCenter.ActEpidemicZoneManager:GetActInfo()
end

function ActEpidemicUtils.GetTeamAState()
  local groupA = DataCenter.ActEpidemicZoneManager:GetGroup(ActEpidemicUtils.Group1)
  if not groupA then
    return EpidemicZoneSignState.StateSignNone
  end
  return groupA.state
end

function ActEpidemicUtils.GetTeamBState()
  local groupB = DataCenter.ActEpidemicZoneManager:GetGroup(ActEpidemicUtils.Group2)
  if not groupB then
    return EpidemicZoneSignState.StateSignNone
  end
  return groupB.state
end

function ActEpidemicUtils.GetGroup(idx)
  local info = DataCenter.ActEpidemicZoneManager:GetActInfo()
  if not info then
    return
  end
  return info:GetGroup(idx)
end

function ActEpidemicUtils.GetArbiterByGroupId(groupIdx)
  local groupInfo = ActEpidemicUtils.GetGroup(groupIdx)
  if not groupInfo then
    return
  end
  return groupInfo.selfRoleInfo and groupInfo.selfRoleInfo.arbiter
end

function ActEpidemicUtils.GetRolesByGroup(group)
  local actInfo = DataCenter.ActEpidemicZoneManager:GetActInfo()
  if not actInfo then
    return {}
  end
  if group == ActEpidemicUtils.Group1 then
    return actInfo.groupA.roles
  elseif group == ActEpidemicUtils.Group2 then
    return actInfo.groupB.roles
  end
  return {}
end

function ActEpidemicUtils.GetRoleByGroup(group)
  local actInfo = DataCenter.ActEpidemicZoneManager:GetActInfo()
  if not actInfo then
    return 0
  end
  return actInfo:GetRoleByGroup(group)
end

function ActEpidemicUtils.IsInSignInStage(groupIdx)
  local stage = DataCenter.ActEpidemicZoneManager:FixStage(groupIdx)
  return stage == EpidemicZoneStage.SignIn
end

function ActEpidemicUtils.CanChangeBattlePlayer()
  return DataCenter.AllianceBaseDataManager:IsR4orR5()
end

function ActEpidemicUtils.GetRole(side)
  if side == EpidemicBattleSide.FarmerR or side == EpidemicBattleSide.FarmerL then
    return EpidemicZoneRole.Farmer
  elseif side == EpidemicBattleSide.Lord then
    return EpidemicZoneRole.Lord
  end
  return EpidemicZoneRole.Default
end

function ActEpidemicUtils.CanAssignArbiter()
  return DataCenter.AllianceBaseDataManager:IsR4orR5()
end

function ActEpidemicUtils.GetPlayerByUid(uid)
  local playerList = DataCenter.ActEpidemicZoneManager:GetPlayerList()
  if not playerList then
    return
  end
  return playerList:GetPlayer(uid)
end

function ActEpidemicUtils.EnableEAV2()
  return false
end

function ActEpidemicUtils.LoadTeamSprite(image, group)
  local teamStr = group == ActEpidemicUtils.Group1 and "A" or "B"
  image:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldEpidemicPath, "lrb_shamofengbao_" .. teamStr))
end

function ActEpidemicUtils.GetRoleNameByRoleId(role)
  local key = role == EpidemicZoneRole.Lord and "YiBianJinQu_camp_name_1" or "YiBianJinQu_camp_name_2"
  return Localization:GetString(key)
end

function ActEpidemicUtils.GetRoleNameBySideId(side)
  return ActEpidemicUtils.GetRoleNameByRoleId(ActEpidemicUtils.GetRole(side))
end

function ActEpidemicUtils.GetSummaryByGroupAndRank(group, rank)
  local playerList = DataCenter.ActEpidemicZoneManager:GetPlayerList()
  if not playerList then
    return 0, 0
  end
  return playerList:GetSummaryByGroupAndRank(group, rank)
end

function ActEpidemicUtils.GetSummaryByGroup(group)
  local playerList = DataCenter.ActEpidemicZoneManager:GetPlayerList()
  if not playerList then
    return 0, 0
  end
  return playerList:GetSummaryByGroup(group)
end

function ActEpidemicUtils.GetMvpShowInfo(groupIndex)
  local info = ActEpidemicUtils.GetActInfo()
  if not info then
    return nil
  end
  return info:GetMvpShowInfo(groupIndex)
end

local _myColor = Color.New(0.4470589, 0.9019608, 0.9411765, 1)

function ActEpidemicUtils.GetMyColor()
  return _myColor
end

local _otherColor = Color.New(1, 1, 1, 1)

function ActEpidemicUtils.GetOtherColor()
  return _otherColor
end

function ActEpidemicUtils.GetAllPlayers()
  local playerList = DataCenter.ActEpidemicZoneManager:GetPlayerList()
  return playerList and playerList.players or {}
end

function ActEpidemicUtils.GetPlayersByGroup(group)
  local playerList = DataCenter.ActEpidemicZoneManager:GetPlayerList()
  return playerList and playerList:GetPlayersByGroup(group)
end

function ActEpidemicUtils.GetPlayerListByGroupAndRank(group, rank)
  local playerList = DataCenter.ActEpidemicZoneManager:GetPlayerList()
  if not playerList then
    return 0, 0
  end
  return playerList:GetPlayerListByGroupAndRank(group, rank)
end

function ActEpidemicUtils.GetMyGroupIndex()
  local info = ActEpidemicUtils.GetActInfo()
  if not info then
    return nil
  end
  return info:GetMyGroupIdx()
end

function ActEpidemicUtils.GetMyGroup()
  local info = ActEpidemicUtils.GetActInfo()
  if not info then
    return nil
  end
  return info:GetMyGroup()
end

function ActEpidemicUtils.GetMyInfo()
  local playerList = DataCenter.ActEpidemicZoneManager:GetPlayerList()
  if not playerList then
    return nil
  end
  return playerList:GetPlayer(LuaEntry.Player.uid)
end

function ActEpidemicUtils.GetMyRole()
  local myGroup = ActEpidemicUtils.GetMyGroup()
  if not myGroup or myGroup.state ~= EpidemicZoneSignState.StateMatchSuc then
    return EpidemicZoneRole.Default
  end
  local groupIdx = ActEpidemicUtils.GetMyGroupIndex()
  local stage = DataCenter.ActEpidemicZoneManager:FixStage(groupIdx)
  if stage ~= EpidemicZoneStage.MatchEnd and stage ~= EpidemicZoneStage.Prepare and stage ~= EpidemicZoneStage.Battle then
    return EpidemicZoneRole.Default
  end
  return myGroup.selfRole
end

function ActEpidemicUtils.GetMyPlayerState()
  local info = ActEpidemicUtils.GetActInfo()
  if not info then
    return EpidemicZonePlayerState.None
  end
  local myGroup = ActEpidemicUtils.GetMyGroup()
  if not myGroup or myGroup.state ~= EpidemicZoneSignState.StateMatchSuc then
    return EpidemicZonePlayerState.None
  end
  local groupIdx = ActEpidemicUtils.GetMyGroupIndex()
  local stage = DataCenter.ActEpidemicZoneManager:FixStage(groupIdx)
  if stage ~= EpidemicZoneStage.MatchEnd and stage ~= EpidemicZoneStage.Prepare and stage ~= EpidemicZoneStage.Battle then
    return EpidemicZonePlayerState.None
  end
  return info.selfAssigned or EpidemicZonePlayerState.None
end

function ActEpidemicUtils.GetLordSkillPassive()
  return DataCenter.ActEpidemicZoneManager:GetLordSkillPassive()
end

function ActEpidemicUtils.GetLordSkillRandom(group)
  local _g = ActEpidemicUtils.GetGroup(group)
  if not _g then
    return -1
  end
  return _g.lordRandomSkillId or -1
end

function ActEpidemicUtils.GetLordSkillArbiter()
  return DataCenter.ActEpidemicZoneManager:GetLordSkillArbiter()
end

function ActEpidemicUtils.GetRoleByGroupAndSide(group, side)
  local _g = ActEpidemicUtils.GetGroup(group)
  if not _g then
    return
  end
  return _g.rolesBySide and _g.rolesBySide[side]
end

function ActEpidemicUtils.InBattleGuide()
  local _curRunning = DataCenter.LWGuideFlowManager:TryGetCurrentRunning() or 0
  return tonumber(_curRunning) == GuideID.EpidemicBattleGuide
end

function ActEpidemicUtils.ContinueBattleGuide()
  EventManager:GetInstance():Broadcast(EventId.GF_epidemic_battle_guide_next)
end

function ActEpidemicUtils.GetWinnerRewardIdByTeamTypeAndRoleType(teamType, roleType)
  return DataCenter.ActEpidemicZoneManager:GetTeamWinnerRewards(teamType, roleType)
end

function ActEpidemicUtils.GetRoleInfoByGroupAndSide(group, side)
  local actInfo = ActEpidemicUtils.GetActInfo()
  return actInfo and actInfo:GetRoleInfoByGroupAndSide(group, side)
end

function ActEpidemicUtils.GetMyBattleScoreType()
  local iAm = EpidemicBattleScoreType.None
  local myInfo = ActEpidemicUtils.GetMyInfo()
  if not myInfo or myInfo.state == EpidemicZonePlayerState.None then
    return iAm
  end
  local group = ActEpidemicUtils.GetGroup(myInfo.group)
  if not group or group.state ~= EpidemicZoneSignState.StateMatchSuc then
    return iAm
  end
  local selfRole = group.selfRole
  if selfRole == EpidemicZoneRole.Lord then
    local roleInfo = group.selfRoleInfo
    if not roleInfo then
      return iAm
    end
    if roleInfo.arbiter ~= nil and roleInfo.arbiter.uid == LuaEntry.Player:GetUid() then
      return EpidemicBattleScoreType.Arbiter
    end
    return EpidemicBattleScoreType.Lord
  elseif selfRole == EpidemicZoneRole.Farmer then
    return EpidemicBattleScoreType.Farmer
  else
    return iAm
  end
end

function ActEpidemicUtils.TryGetFarmerRoom()
  local actInfo = ActEpidemicUtils.GetActInfo()
  if not actInfo then
    return nil
  end
  local myGroupIdx = ActEpidemicUtils.GetMyGroupIndex()
  local stage = DataCenter.ActEpidemicZoneManager:FixStage(myGroupIdx)
  if stage ~= EpidemicZoneStage.Battle and stage ~= EpidemicZoneStage.Prepare and stage ~= EpidemicZoneStage.MatchEnd then
    return nil
  end
  local myPlayerState = ActEpidemicUtils.GetMyPlayerState()
  local myRole = ActEpidemicUtils.GetMyRole()
  if myPlayerState == EpidemicZonePlayerState.None then
    return nil
  end
  local myGroup = ActEpidemicUtils.GetMyGroup()
  local battleServerId = myGroup.battleServerId
  local battleWorldId = myGroup.battleWorldId
  if myRole == EpidemicZoneRole.Farmer then
    local actData = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.ActEpidemic.ActId)
    if not actData then
      return nil
    end
    local actStartTime = actData.startTime
    local groupInfo = ActEpidemicUtils.GetGroup(myGroupIdx)
    local startTime = groupInfo and groupInfo.startTime or 0
    return string.format("%s%s_%s_%s_%s_%s", ChatInterface.GetRoomIdPrefix(), ChatGroupType.GROUP_EPIDEMIC_FARMER, battleServerId, battleWorldId, startTime, actStartTime)
  end
  return nil
end

function ActEpidemicUtils.TryGetCommonBattleRoom()
  local allianceId = LuaEntry.Player:GetAllianceUid()
  local groupIdx = ActEpidemicUtils.GetMyGroupIndex()
  if not groupIdx then
    return nil
  end
  local groupId = allianceId .. "_" .. groupIdx
  return string.format("%s%s%s_%s", ChatInterface.GetRoomIdPrefix(), ChatInterface.getDragonGroupType(true), groupId, BattleFieldType.EpidemicZone)
end

function ActEpidemicUtils.GotoChatRoom()
  local roomId = ActEpidemicUtils.TryGetFarmerRoom()
  if roomId then
    GoToUtil.OpenChatView(true, {anim = false, immediately = true}, {roomId = roomId, scrollToActive = true})
  end
end

ActEpidemicUtils.DEV_TEST_SKILL_UID = "_epidemicSkillTest"

function ActEpidemicUtils.TestCleanSkillObj(ignoreMusic)
  if not CommonUtil.IsDebug() then
    return
  end
  if ActEpidemicUtils._devTestSkillUpdateTimer ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(ActEpidemicUtils._devTestSkillUpdateTimer)
    ActEpidemicUtils._devTestSkillUpdateTimer = nil
  end
  if ActEpidemicUtils._devTestRequest ~= nil then
    ActEpidemicUtils._devTestRequest:Destroy()
    ActEpidemicUtils._devTestRequest = nil
  end
  ActEpidemicUtils._devTestSkillId = nil
  ActEpidemicUtils._devTestSkillPoint = nil
  DataCenter.BattleFieldAnimManager:UpdateObjSkill(ActEpidemicUtils.DEV_TEST_SKILL_UID)
  if not ignoreMusic then
    CommonUtil.ClearGameBgMusicData()
    CommonUtil.PlayGameBgMusic()
  end
end

function ActEpidemicUtils.GetTestSkillId()
  if not CommonUtil.IsDebug() then
    return
  end
  return ActEpidemicUtils._devTestSkillId
end

function ActEpidemicUtils.TestAddSkillObj(idx)
  if not CommonUtil.IsDebug() then
    return
  end
  ActEpidemicUtils.TestCleanSkillObj(true)
  local skillId
  if idx == 1 then
    skillId = EpidemicSkillId.Quake
  elseif idx == 2 then
    skillId = EpidemicSkillId.Hospital
  elseif idx == 3 then
    skillId = EpidemicSkillId.Turret
  elseif idx == 4 then
    skillId = EpidemicSkillId.Judgment
  end
  ActEpidemicUtils._devTestSkillId = skillId
  ActEpidemicUtils.Log(string.format("\230\149\153\231\187\131..\230\136\145\230\131\179..\230\181\139\232\175\149\228\184\128\228\184\139\230\138\128\232\131\189idx=%s,id=%s...", idx, skillId))
  local theWorld = CS.SceneManager.World
  if theWorld == nil or not SceneUtils.GetIsInWorld() then
    ActEpidemicUtils.Log("\230\178\161\230\156\137\229\156\168\229\164\167\228\184\150\231\149\140\229\149\138\239\188\129")
    UIUtil.ShowTips("\230\178\161\230\156\137\229\156\168\229\164\167\228\184\150\231\149\140\229\149\138\239\188\129")
    return
  end
  local prefabPath = DataCenter.ActEpidemicZoneManager:GetSkillModelPath(skillId)
  if string.IsNullOrEmpty(prefabPath) then
    ActEpidemicUtils.Log("\230\168\161\229\158\139\230\178\161\230\156\137\230\137\190\229\136\176\229\149\138\239\188\129")
    UIUtil.ShowTips("\230\168\161\229\158\139\230\178\161\230\156\137\230\137\190\229\136\176\229\149\138\239\188\129")
    return
  end
  if not BattleFieldUtil.InBattleField() then
    function ActEpidemicUtils._devTestSkillUpdateTimer()
      DataCenter.BattleFieldAnimManager:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(ActEpidemicUtils._devTestSkillUpdateTimer)
  end
  local _epidemicRequest = CS.GameEntry.Resource:InstantiateAsync(prefabPath)
  ActEpidemicUtils._devTestRequest = _epidemicRequest
  _epidemicRequest:completed("+", function()
    if _epidemicRequest.isError then
      DevUtils.EpidemicCleanSkillObj()
      return
    end
    local go = _epidemicRequest.gameObject
    go.name = "BF_Skill_TEST_" .. skillId
    local tf = go.transform
    tf:SetParent(theWorld.DynamicObjNode)
    local pointId = SceneUtils.WorldToTileIndex(theWorld.CurTarget, ForceChangeScene.World)
    tf.position = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, LuaEntry.Player:GetCurServerId())
    ActEpidemicUtils._devTestSkillPoint = pointId
    local bfObj = go:GetComponent(typeof(CS.BattleFieldObj))
    if bfObj == nil then
      bfObj = go:GetComponent(typeof(CS.BattleFieldObjNew))
    end
    if bfObj ~= nil then
      bfObj:SetState(2)
    end
    DataCenter.LWSoundManager:PlaySound(93007, true, true)
    local bfAnimMgr = DataCenter.BattleFieldAnimManager
    local param = bfAnimMgr:GetSkillParam()
    param.uid = ActEpidemicUtils.DEV_TEST_SKILL_UID
    param.anim = BattleFieldObjActType.BORN
    param.skillId = skillId
    param.pointIndex = pointId
    param.go = go
    bfAnimMgr:SetSkillObjAnim(param)
    ActEpidemicUtils.TestPlaySkillAtk(true)
  end)
end

function ActEpidemicUtils.TestPlaySkillAtk(bBorn)
  if not CommonUtil.IsDebug() then
    return
  end
  if ActEpidemicUtils._devTestSkillId == nil then
    ActEpidemicUtils.Log("\230\178\161\230\156\137\230\138\128\232\131\189id\229\149\138\239\188\129")
    UIUtil.ShowTips("\230\178\161\230\156\137\230\138\128\232\131\189id\229\149\138\239\188\129\229\133\136\230\183\187\229\138\160\228\184\128\228\184\170\230\138\128\232\131\189\229\143\152\232\186\171\239\188\129\239\188\129\239\188\129")
    return
  end
  local actMgr = DataCenter.ActEpidemicZoneManager
  if ActEpidemicUtils._devTestSkillId == EpidemicSkillId.Judgment and not bBorn then
    local pointId = LuaEntry.Player:GetMainWorldPos()
    actMgr:HandleBattleArbiterBreakCity({
      attUid = ActEpidemicUtils.DEV_TEST_SKILL_UID,
      attPointId = ActEpidemicUtils._devTestSkillPoint,
      defPointId = pointId
    })
    return
  elseif ActEpidemicUtils._devTestSkillId == EpidemicSkillId.Turret and bBorn then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local t = {
    uid = ActEpidemicUtils.DEV_TEST_SKILL_UID,
    point = ActEpidemicUtils._devTestSkillPoint,
    skillId = ActEpidemicUtils._devTestSkillId
  }
  if ActEpidemicUtils._devTestSkillId == EpidemicSkillId.Turret then
    local template = actMgr:GetTemplateSkillById(EpidemicSkillId.Turret)
    local remainTime = 1
    if template ~= nil and template.effPartTime then
      remainTime = template.effPartTime
    end
    t.fire = {
      fireTime = curTime + remainTime * 1000,
      targetPoint = LuaEntry.Player:GetMainWorldPos()
    }
    actMgr:HandleBattleSkillEffect(t)
    TimerManager:GetInstance():DelayInvoke(function()
      t.fire = nil
      t.fireArrive = {
        targetPoint = LuaEntry.Player:GetMainWorldPos(),
        damageSolider = 100,
        beforeHole = 2000,
        currHole = 1000
      }
      actMgr:HandleBattleSkillEffect(t)
    end, remainTime)
  else
    local bCure = ActEpidemicUtils._devTestSkillId == EpidemicSkillId.Hospital
    t.rangeEff = {
      bornType = bBorn and 1 or 0,
      damageInfo = {
        {
          uid = LuaEntry.Player:GetUid(),
          pointId = LuaEntry.Player:GetMainWorldPos(),
          cureSolider = bCure and 100 or nil,
          damageSolider = not bCure and 100 or nil,
          beforeHole = 2000,
          currHole = bCure and 3000 or 1000
        }
      }
    }
    actMgr:HandleBattleSkillEffect(t)
  end
  if bBorn then
    DataCenter.ActEpidemicZoneManager:HandleBattleSkillMVBorn({
      uid = t.uid,
      pointId = t.point
    })
  end
end

function ActEpidemicUtils.TestPlaySkillPreview()
  if not CommonUtil.IsDebug() then
    return
  end
  if ActEpidemicUtils._devTestSkillId == nil then
    ActEpidemicUtils.Log("\230\178\161\230\156\137\230\138\128\232\131\189id\229\149\138\239\188\129")
    UIUtil.ShowTips("\230\178\161\230\156\137\230\138\128\232\131\189id\229\149\138\239\188\129\229\133\136\230\183\187\229\138\160\228\184\128\228\184\170\230\138\128\232\131\189\229\143\152\232\186\171\239\188\129\239\188\129\239\188\129")
    return
  end
  DataCenter.ActEpidemicZoneManager:PreviewSkill(ActEpidemicUtils._devTestSkillId)
end

return ConstClass("ActEpidemicUtils", ActEpidemicUtils)
