local GetRankListMessage = BaseClass("GetRankListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetRankListMessage:OnCreate(global, theType, serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", theType)
  self.sfsObj:PutInt("global", global)
  self.sfsObj:PutInt("serverId", serverId)
end

function GetRankListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local theType = t.type
    if theType == RankingTypeServer.KILL_ALLIANCE or theType == RankingTypeServer.POWER_ALLIANCE then
      DataCenter.RankDataManager:ParseAllianceRankData(t.global, theType, t)
      EventManager:GetInstance():Broadcast(EventId.AllianceRank)
    elseif theType == RankingTypeServer.KILL or theType == RankingTypeServer.HERO_TOTAL_POWER or theType == RankingTypeServer.PVE_STAGE or theType == RankingTypeServer.ONE_HERO_POWER or theType == RankingTypeServer.POWER or theType == RankingTypeServer.BUILDING or theType == RankingTypeServer.TRIAL_TOWER_AIRPLANE or theType == RankingTypeServer.TRIAL_TOWER_MISSILE or theType == RankingTypeServer.TRIAL_TOWER_TANK or theType == RankingTypeServer.DOMINATOR_UP_PVE or theType == RankingTypeServer.T11_IDLE_GAME then
      DataCenter.RankDataManager:ParsePlayerRankData(t.global, theType, t)
      EventManager:GetInstance():Broadcast(EventId.PlayerRank)
    else
      EventManager:GetInstance():Broadcast(EventId.RefreshRankingData)
    end
  end
end

return GetRankListMessage
