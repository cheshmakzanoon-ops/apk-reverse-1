local LWDoomsdayManager = BaseClass("LWDoomsdayManager")
local Localization = CS.GameEntry.Localization
local Notifier = require("Common.Notifier")

function LWDoomsdayManager:__init()
end

function LWDoomsdayManager:__delete()
end

function LWDoomsdayManager:OnGetEventInfo(msgTbl)
  self.activityId = msgTbl.id
  self.activityEndTime = msgTbl.endTime
end

function LWDoomsdayManager:IsOpen()
  if self.activityId == nil then
    return false
  end
  if self.activityEndTime == nil then
    return false
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.activityEndTime - curTime < 0 then
    return false
  end
  return true
end

function LWDoomsdayManager:OnGetSuperBossActivityInfo()
  local type = GetTableData(TableName.Activity, self.activityId, "type")
  if tonumber(type) == 157 then
    local str = GetTableData(TableName.Activity, self.activityId, "para_1")
    if not string.IsNullOrEmpty(str) then
      local season, days, resource, ruleStr = string.match(str, "(%d+):(%d+),([^,]+),([^,]+)")
      local result = {
        season = tonumber(season),
        days = tonumber(days),
        resourcePath = resource,
        ruleStr = ruleStr
      }
      return result
    end
    return nil
  end
  return nil
end

function LWDoomsdayManager:OnGetMainInfo(msgTbl)
  local vo = {}
  vo.activityId = self.activityId
  vo.ruleStr = Localization:GetString(GetTableData(TableName.Activity, self.activityId, "desc"))
  vo.endTime = self.activityEndTime
  vo.bossTime = msgTbl.refresh_time
  vo.guardian = nil
  if msgTbl.fist and msgTbl.fist.uid then
    local guardianInfo = msgTbl.fist
    vo.guardian = {
      uid = guardianInfo.uid,
      pic = guardianInfo.pic,
      picVer = guardianInfo.picver,
      headSkinId = guardianInfo.headSkinId,
      headSkinET = guardianInfo.headSkinET,
      nameStr = UIUtil.FormatAllianceAndName(guardianInfo.abbr, guardianInfo.name),
      killPoint = guardianInfo.score
    }
  end
  vo.allianceBosses = {}
  if msgTbl.boss_info and msgTbl.boss_info.alliance_boss then
    for _, bossInfo in ipairs(msgTbl.boss_info.alliance_boss) do
      local bossVO = {
        monsterId = bossInfo.monster_id,
        targetPos = bossInfo.point_id,
        refreshTime = bossInfo.expire_time,
        isRally = bossInfo.isRally,
        uid = bossInfo.monster_uid
      }
      table.insert(vo.allianceBosses, bossVO)
    end
  end
  vo.theaterBosses = {}
  if msgTbl.boss_info and msgTbl.boss_info.server_boss then
    for _, bossInfo in ipairs(msgTbl.boss_info.server_boss) do
      local bossVO = {
        monsterId = bossInfo.monster_id,
        targetPos = bossInfo.point_id,
        refreshTime = bossInfo.expire_time,
        isRally = bossInfo.isRally,
        uid = bossInfo.monster_uid
      }
      table.insert(vo.theaterBosses, bossVO)
    end
  end
  Notifier.Dispatch("UIDoomsday.Refresh", vo)
  Notifier.Dispatch("UIDoomsday.RefreshReddot", self.redDotCount)
end

function LWDoomsdayManager:OnGetQuestInfo(msgTbl)
  local achieveVOs = {}
  self.redDotCount = 0
  local hasRecievedIds = {}
  if msgTbl.quest_info then
    if msgTbl.quest_info.has_rewards then
      local arr = string.split(msgTbl.quest_info.has_rewards, ",")
      for _, id in ipairs(arr) do
        if 0 < string.len(id) then
          hasRecievedIds[tonumber(id)] = true
        end
      end
    end
    if msgTbl.quest_info.doomsday_quests then
      local questList = msgTbl.quest_info.doomsday_quests
      table.sort(questList, function(a, b)
        return a.quest_id < b.quest_id
      end)
      for _, questInfo in ipairs(questList) do
        local hasRecieved = hasRecievedIds[questInfo.quest_id] or false
        local questType = GetTableData(TableName.doomsday_quest, questInfo.quest_id, "Type")
        local displayProcess = (tonumber(questType) == 2 or tonumber(questType) == 4) and " (" .. questInfo.count .. "/" .. GetTableData(TableName.doomsday_quest, questInfo.quest_id, "para") .. ")" or ""
        local achieveVO = {
          uuid = questInfo.uuid,
          achieveStr = Localization:GetString(GetTableData(TableName.doomsday_quest, questInfo.quest_id, "desc"), GetTableData(TableName.doomsday_quest, questInfo.quest_id, "para")) .. displayProcess,
          hasRecieved = hasRecieved,
          canRecieve = not hasRecieved and questInfo.state == 1,
          rewards = questInfo.rewards
        }
        table.insert(achieveVOs, achieveVO)
        if achieveVO.canRecieve then
          self.redDotCount = self.redDotCount + 1
        end
      end
    end
  end
  Notifier.Dispatch("UIDoomsday.RefreshAchieve", achieveVOs)
  Notifier.Dispatch("UIDoomsday.RefreshReddot", self.redDotCount)
end

function LWDoomsdayManager:OnGetRankInfo(msgTbl)
  local rankParams = {}
  rankParams.rankVOs = {}
  local selfRankVO
  if msgTbl.ranks then
    for _, rankInfo in ipairs(msgTbl.ranks) do
      local rankVO = {
        uid = rankInfo.uid,
        pic = rankInfo.pic,
        picVer = rankInfo.picver,
        headSkinId = rankInfo.headSkinId,
        headSkinET = rankInfo.headSkinET,
        rank = rankInfo.rank,
        medalRes = rankInfo.rank < 4 and string.format("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_%s.png", rankInfo.rank) or nil,
        killStr = Localization:GetString("doomsday_activity_tips1002", string.GetFormattedStr(rankInfo.score)),
        nameStr = UIUtil.FormatAllianceAndName(rankInfo.abbr, rankInfo.name),
        hasGender = rankInfo.gender == 1 or rankInfo.gender == 2,
        isFemale = rankInfo.gender == 2,
        isSelf = rankInfo.uid == LuaEntry.Player.uid
      }
      if rankVO.isSelf then
        selfRankVO = rankVO
      end
      table.insert(rankParams.rankVOs, rankVO)
    end
  end
  if selfRankVO then
    rankParams.selfRankVO = selfRankVO
  elseif msgTbl.self then
    local selfRankInfo = msgTbl.self
    local allianceAbbr = LuaEntry.Player:IsInAlliance() and LuaEntry.Player:GetAllianceAbbr() or ""
    local headSkinId, headSkinET = LuaEntry.Player:GetHeadBgET()
    rankParams.selfRankVO = {
      uid = LuaEntry.Player.uid,
      pic = LuaEntry.Player:GetPic(),
      picVer = LuaEntry.Player:GetPicVer(),
      headSkinId = headSkinId,
      headSkinET = headSkinET,
      rank = selfRankInfo.rank,
      medalRes = nil,
      killStr = Localization:GetString("doomsday_activity_tips1002", string.GetFormattedStr(selfRankInfo.score)),
      nameStr = UIUtil.FormatAllianceAndName(allianceAbbr, LuaEntry.Player:GetName()),
      hasGender = LuaEntry.Player:GetGender() == 1 or LuaEntry.Player:GetGender() == 2,
      isFemale = LuaEntry.Player:GetGender() == 2,
      isSelf = true
    }
  end
  Notifier.Dispatch("UIDoomsday.RefreshRank", rankParams)
end

function LWDoomsdayManager:OnGetRankRewards(msgTbl)
  local rewardVOs = {}
  if msgTbl.rank_show then
    for i, rewardInfo in ipairs(msgTbl.rank_show) do
      local rankArr = string.split(rewardInfo.rank, "-")
      local minRanking = rankArr[1]
      local maxRanking = rankArr[2] or minRanking
      local rewardVO = {
        ribbonRes = string.format("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_jiangli_%s.png", math.min(i, 4)),
        rankStr = minRanking == maxRanking and Localization:GetString(2000235, minRanking) or Localization:GetString(2000236, minRanking, maxRanking),
        rewards = rewardInfo.rewards
      }
      table.insert(rewardVOs, rewardVO)
    end
  end
  Notifier.Dispatch("UIDoomsday.RefreshReward", rewardVOs)
end

function LWDoomsdayManager:OnRecieveQuests(msgTbl)
  self:OnGetQuestInfo(msgTbl)
  DataCenter.RewardManager:AddRewardsAndRes({
    reward = msgTbl.rewards
  })
  DataCenter.RewardManager:ShowCommonReward({
    reward = msgTbl.rewards
  })
  if self.activityId ~= nil then
    SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(self.activityId))
  end
end

function LWDoomsdayManager:OnSingleQuestUpdate(msgTbl)
  if msgTbl.state == 1 then
    if self.redDotCount then
      self.redDotCount = self.redDotCount + 1
    else
      self.redDotCount = 1
    end
  end
  Notifier.Dispatch("UIDoomsday.UpdateSingleQuest", msgTbl.uuid, msgTbl.state)
  Notifier.Dispatch("UIDoomsday.RefreshReddot", self.redDotCount)
end

function LWDoomsdayManager:OnSingleBossDelete(msgTbl)
  Notifier.Dispatch("UIDoomsday.DelSingleBoss", msgTbl.uuid)
end

function LWDoomsdayManager:GetRedDotCount()
  return self.redDotCount or 0
end

function LWDoomsdayManager:PlayPlotBubble3D(marchInfo, transform, duration)
  if transform and duration then
    if marchInfo then
      local bubbleParams = {}
      local str = LuaEntry.DataConfig:TryGetStr("running_boss", "k3", "")
      local content = Localization:GetString(str)
      bubbleParams.fakePlotMeta = {duration = duration, contentString = content}
      bubbleParams.followTarget = transform
      local targetPos = transform.position
      local pic = marchInfo.pic
      if string.IsNullOrEmpty(pic) then
        local monsterId = marchInfo.monsterId
        if 0 < monsterId then
          local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
          if monster ~= nil then
            pic = monster.pic
          end
        end
      end
      pic = "Assets/Main/Sprites/HeroIconsSmall/" .. pic .. ".png"
      local playerInfo = {
        uid = marchInfo.ownerUid,
        pic = pic,
        picVer = marchInfo.picVer
      }
      bubbleParams.anchor = Vector3.New(targetPos.x, targetPos.y + 3.7, targetPos.z)
      bubbleParams.mode = "3D"
      bubbleParams.playerInfo = playerInfo
      bubbleParams.headType = 1
      EventManager:GetInstance():Broadcast(EventId.PlayPlotBubble, bubbleParams)
    else
      Logger.LogWarning("cannot get marchInfo")
    end
  end
end

return LWDoomsdayManager
