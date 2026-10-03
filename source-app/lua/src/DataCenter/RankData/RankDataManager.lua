local RankDataManager = BaseClass("RankDataManager")

function RankDataManager:__init()
  self.allianceSelfKill = 0
  self.allianceSelfKillGlobal = 0
  self.theRankData = {
    k0 = {},
    k1 = {}
  }
  self.thePreviewRankData = {
    k0 = {},
    k1 = {}
  }
  self.trailTowerRankStageData = {
    k0 = {},
    k1 = {}
  }
  self.selfRanking = -1
end

function RankDataManager:__delete()
  self.allianceSelfKill = nil
  self.allianceSelfKillGlobal = nil
  self.theRankData = nil
  self.thePreviewRankData = nil
  self.trailTowerRankStageData = nil
  self.selfRanking = nil
end

function RankDataManager:HasPreviewRankData(global, serverId)
  return self.thePreviewRankData["k" .. global][serverId] ~= nil
end

function RankDataManager:GetPreviewRankData(global, rankType, serverId)
  if self.thePreviewRankData["k" .. global][serverId] ~= nil and self.thePreviewRankData["k" .. global][serverId][rankType] ~= nil then
    return self.thePreviewRankData["k" .. global][serverId][rankType] or {}
  end
  SFSNetwork.SendMessage(MsgDefines.GetRankPreviewMessage, global, serverId)
  return {}
end

function RankDataManager:GetRankData(global, rankType, serverId)
  if self.theRankData["k" .. global][serverId] ~= nil and self.theRankData["k" .. global][serverId][rankType] ~= nil then
    return self.theRankData["k" .. global][serverId][rankType] or {}
  end
  SFSNetwork.SendMessage(MsgDefines.GetRankListMessage, global, rankType, serverId)
  return {}
end

function RankDataManager:GetPlayerRankListByType(global, rankType, serverId)
  if self.theRankData["k" .. global][serverId] ~= nil and self.theRankData["k" .. global][serverId][rankType] ~= nil then
    return self.theRankData["k" .. global][serverId][rankType] or {}
  end
  SFSNetwork.SendMessage(MsgDefines.GetRankListMessage, global, rankType, serverId)
  return {}
end

function RankDataManager:GetAllianceRankListByType(global, rankType, serverId, force)
  if not force and self.theRankData["k" .. global][serverId] ~= nil and self.theRankData["k" .. global][serverId][rankType] ~= nil then
    return self.theRankData["k" .. global][serverId][rankType] or {}, true
  end
  SFSNetwork.SendMessage(MsgDefines.GetRankListMessage, global, rankType, serverId)
  return {}, false
end

function RankDataManager:UpdatePreviewRankData(global, data, serverId)
  self.thePreviewRankData["k" .. global][serverId] = data
  EventManager:GetInstance():Broadcast(EventId.UpdateRankPreview)
end

function RankDataManager:fetchPreviewRankData(global, serverId)
  SFSNetwork.SendMessage(MsgDefines.GetRankPreviewMessage, global, serverId)
end

function RankDataManager:fetchRankData(global, rankType, serverId)
  SFSNetwork.SendMessage(MsgDefines.GetRankListMessage, global, rankType, serverId)
end

function RankDataManager:GetTrailTowerRankStageData(global, rankType, serverId)
  if self.trailTowerRankStageData["k" .. global][serverId] ~= nil then
    return self.trailTowerRankStageData["k" .. global][serverId][rankType] or ""
  end
  return ""
end

function RankDataManager:ParsePlayerRankData(global, rankType, message)
  if message ~= nil then
    local rankList = {}
    local serverId = message.serverId
    if message.serverRanking ~= nil then
      local arr = message.serverRanking
      for k, v in pairs(arr) do
        local oneData = PlayerRankData.New()
        oneData:ParseData(v, rankType)
        oneData:SetRank(k)
        table.insert(rankList, oneData)
      end
    end
    if self.theRankData["k" .. global][serverId] == nil then
      self.theRankData["k" .. global][serverId] = {}
    end
    self.theRankData["k" .. global][serverId][rankType] = rankList
    self.selfRanking = -1
    if rankType == RankingTypeServer.TRIAL_TOWER_AIRPLANE or rankType == RankingTypeServer.TRIAL_TOWER_TANK or rankType == RankingTypeServer.TRIAL_TOWER_MISSILE then
      if message.group and message.order then
        local group = message.group
        local order = message.order
        if self.trailTowerRankStageData["k" .. global][serverId] == nil then
          self.trailTowerRankStageData["k" .. global][serverId] = {}
        end
        self.trailTowerRankStageData["k" .. global][serverId][rankType] = group .. "-" .. order
      end
    elseif rankType == RankingTypeServer.KILL then
      self.selfRanking = message.selfRanking or -1
    end
  end
end

function RankDataManager:ParseAllianceRankData(global, rankType, message)
  if message ~= nil then
    local rankList = {}
    local serverId = message.serverId
    local arr
    if message.allianceRanking ~= nil then
      arr = message.allianceRanking
      if global == 1 then
        self.allianceSelfKillGlobal = message.selfAllianceKillNum or 0
        if self.allianceSelfKillGlobal < 0 then
          self.allianceSelfKillGlobal = 0
        end
      else
        self.allianceSelfKill = message.selfAllianceKillNum or 0
        if 0 > self.allianceSelfKill then
          self.allianceSelfKill = 0
        end
      end
    elseif message.serverRanking ~= nil then
      arr = message.serverRanking
    end
    if arr ~= nil then
      for k, v in pairs(arr) do
        local oneData = AllianceRankData.New()
        oneData:ParseData(v, rankType)
        oneData:SetRank(k)
        table.insert(rankList, oneData)
      end
    end
    if self.theRankData["k" .. global][serverId] == nil then
      self.theRankData["k" .. global][serverId] = {}
    end
    self.theRankData["k" .. global][serverId][rankType] = rankList
  end
end

return RankDataManager
