local AllianceFeatureManager = BaseClass("AllianceFeatureManager")
local Localization = CS.GameEntry.Localization

function AllianceFeatureManager:__init()
end

function AllianceFeatureManager:__delete()
end

function AllianceFeatureManager:GetMemberFeatureShowAndOpenTime()
  local show = LuaEntry.DataConfig:CheckSwitch("alliance_invite_open")
  local openTime
  local officialPos = DataCenter.AllianceMemberDataManager:GetOfficialPosByUid(LuaEntry.Player.uid)
  if show and not DataCenter.AllianceBaseDataManager:IsSelfLeader() and officialPos ~= LWAlMemberOffcialType.Al_Goddess then
    show = false
  end
  if show and SeasonUtil.GetSeason() ~= 0 then
    show = false
  end
  if show then
    if self.openDayRange and self.openDayRange[2] then
      local openDay = UITimeManager:GetInstance():GetOpenServerDay()
      if openDay > self.openDayRange[2] then
        show = false
      elseif openDay < self.openDayRange[1] then
        local openServerTime = LuaEntry.Player.openServerTime
        local openServerTimeZeroTime = UITimeManager:GetInstance():GetTodayZeroServerTime(openServerTime // 1000) * 1000
        openTime = openServerTimeZeroTime + (self.openDayRange[1] - 1) * 86400 * 1000
      end
    else
      show = false
    end
  end
  return show, openTime
end

function AllianceFeatureManager:ReceivedInvite(inviteUid, inviteAllianceId, seqId, roomId)
  if DataCenter.AllianceBaseDataManager:IsSelfLeader() then
    UIUtil.ShowTipsId("alliance_invite_tips_leaderTips")
    return
  end
  if not LuaEntry.Player:IsInAlliance() then
    self:RecommendationReceivedInvite(false, inviteUid, inviteAllianceId, seqId, roomId)
    return
  end
  local farmer = DataCenter.SeasonFarmerManager:IsActive()
  if farmer then
    UIUtil.ShowSecondMessage("", Localization:GetString("season_builders_alliance_UI_20"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      UIUtil.ShowLeaveAllianceTips(function(isDismiss)
        self:RecommendationReceivedInvite(isDismiss, inviteUid, inviteAllianceId, seqId, roomId)
      end, nil, true)
    end, nil, nil, nil, nil, nil, nil, nil, nil, false)
    return
  end
  UIUtil.ShowLeaveAllianceTips(function(isDismiss)
    self:RecommendationReceivedInvite(isDismiss, inviteUid, inviteAllianceId, seqId, roomId)
  end, nil, true)
end

function AllianceFeatureManager:RecommendationReceivedInvite(isDismiss, inviteUid, inviteAllianceId, seqId, roomId)
  if isDismiss then
    UIUtil.ShowTipsId("alliance_invite_tips_leaderTips")
  else
    SFSNetwork.SendMessage(MsgDefines.AllianceManagerRecommendationReceivedInvite, inviteUid, inviteAllianceId, seqId, roomId, true)
  end
end

function AllianceFeatureManager.getters:maxInviteCountCfg()
  self.maxInviteCountCfg = LuaEntry.DataConfig:TryGetNum("alliance_invite_config", "k5", 0)
  return self.maxInviteCountCfg
end

function AllianceFeatureManager.getters:openDayRange()
  self.openDayRange = {}
  local cfg = LuaEntry.DataConfig:TryGetStr("alliance_invite_config", "k6")
  if not string.IsNullOrEmpty(cfg) then
    local split = string.split(cfg, ";")
    for i, v in ipairs(split) do
      self.openDayRange[i] = tonumber(v)
    end
  end
  return self.openDayRange
end

function AllianceFeatureManager.getters:autoCancelTime()
  self.autoCancelTime = LuaEntry.DataConfig:TryGetNum("alliance_invite_config", "k7")
  return self.autoCancelTime
end

function AllianceFeatureManager.getters:goldStarScoreList()
  local cfg = LuaEntry.DataConfig:TryGetStr("alliance_invite_config", "k13")
  self.goldStarScoreList = {}
  if not string.IsNullOrEmpty(cfg) then
    for i, v in ipairs(string.split(cfg, ";")) do
      self.goldStarScoreList[i] = tonumber(v)
    end
  end
  return self.goldStarScoreList
end

function AllianceFeatureManager.getters:boldScore()
  self.boldScore = LuaEntry.DataConfig:TryGetNum("alliance_invite_config", "k14")
  return self.boldScore
end

function AllianceFeatureManager.getters:engagePointMax()
  self.engagePointMax = LuaEntry.DataConfig:TryGetNum("alliance_invite_config", "k15")
  return self.engagePointMax
end

function AllianceFeatureManager.getters:joinAllianceListScoreShowNum()
  self.joinAllianceListScoreShowNum = LuaEntry.DataConfig:TryGetNum("join_alliancelist", "k2")
  return self.joinAllianceListScoreShowNum
end

function AllianceFeatureManager.getters:alInfoFireScore()
  self.alInfoFireScore = LuaEntry.DataConfig:TryGetNum("join_alliancelist", "k7")
  return self.alInfoFireScore
end

function AllianceFeatureManager:RefreshAllianceJumpNew(allianceJumpNew)
  self.allianceJumpNew = allianceJumpNew
  EventManager:GetInstance():Broadcast(EventId.AllianceRecommendRefreshJumpNew)
end

function AllianceFeatureManager:SendAllianceRecommendInfoForJump()
  SFSNetwork.SendMessage(MsgDefines.AllianceRecommendGainAllianceInfoForJump)
end

function AllianceFeatureManager:GetAlSwitchJobNodeShow()
  return self.allianceJumpNew and LuaEntry.Player:IsInAlliance()
end

return AllianceFeatureManager
