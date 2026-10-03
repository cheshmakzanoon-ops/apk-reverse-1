local FetchSeasonFactionWarVsInfoMessage = BaseClass("FetchSeasonFactionWarVsInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchSeasonFactionWarVsInfoMessage:OnCreate()
  base.OnCreate(self)
end

function FetchSeasonFactionWarVsInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.furnaceInfo or t.s3BuildInfo or t.scoreInfo or t.vsInfo or t.inviteList then
    local mgr = DataCenter.SeasonFactionWarDataManager
    local s3BuildInfo = t.s3BuildInfo
    local mainBuildId = SeasonUtil.GetSeasonMilitaryCenterId()
    mgr.warInfo = t
    if t.targetAllianceId then
      mgr.defenderAllianceId = t.targetAllianceId
    end
    if t.furnaceInfo then
      mgr.defenderFurnaceInfo = t.furnaceInfo
    end
    if s3BuildInfo then
      if s3BuildInfo.buildList then
        for k, v in pairs(s3BuildInfo.buildList) do
          if v and v.buildId == mainBuildId then
            s3BuildInfo.uuid = v.uuid
            s3BuildInfo.buildId = v.buildId
            s3BuildInfo.pointId = v.pointId
            s3BuildInfo.buildServerId = v.buildServerId
            break
          end
        end
      end
      mgr.s3BuildInfo = s3BuildInfo
    end
    EventManager:GetInstance():Broadcast(EventId.LWSeasonFactionWarDetailUpdate)
    if t.vsInfo and t.vsInfo.defence and t.vsInfo.attack and t.startTime ~= nil and t.result == 0 and table.count(mgr.theDefenderList) == 0 and table.count(mgr.theAttackerList) == 0 then
      local currStep = mgr:GetCurrStep()
      if currStep and (currStep == SeasonFactionDeclareWarStep.battle_before or currStep == SeasonFactionDeclareWarStep.battle) then
        for k, v in ipairs(t.vsInfo.defence) do
          mgr.theDefenderList[v.allianceId] = v.allianceId
        end
        for k, v in ipairs(t.vsInfo.attack) do
          mgr.theAttackerList[v.allianceId] = v.allianceId
        end
      end
    end
  end
end

return FetchSeasonFactionWarVsInfoMessage
