local PushPlayerAllianceRankMessage = BaseClass("PushPlayerAllianceRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.rank ~= nil then
    local dataFrame = {}
    dataFrame.rank = t.rank
    dataFrame.playerId = LuaEntry.Player.uid
    DataCenter.AllianceMemberDataManager:SetAllianceRank(dataFrame)
    DataCenter.AllianceBaseDataManager:SetSelfRankInfo(t)
    if CS.SceneManager:IsInWorld() and not BattleFieldUtil.InBattleField() then
      DataCenter.WorldFavoDataManager:ClearAllAllianceMarksView()
      DataCenter.WorldFavoDataManager:CreateAllAllianceMark()
    end
    DataCenter.LWActivityAlarmClockManager:TrySendGetActivityAlarmClockDataMsg()
    if t.rank == LWAlMemberRankType.R5 then
      SFSNetwork.SendMessage(MsgDefines.AllianceRecommendR4CandidateCheck)
    end
  end
end

PushPlayerAllianceRankMessage.OnCreate = OnCreate
PushPlayerAllianceRankMessage.HandleMessage = HandleMessage
return PushPlayerAllianceRankMessage
