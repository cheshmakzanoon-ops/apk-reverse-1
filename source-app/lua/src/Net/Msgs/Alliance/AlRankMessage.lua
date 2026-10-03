local AlRankMessage = BaseClass("AlRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, allianceId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("allianceId", allianceId)
  DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.AllianceMember, true)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.AllianceMember, nil)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.allianceId ~= nil then
    local allianceId = t.allianceId
    local selfAllianceId = LuaEntry.Player.allianceId
    if allianceId == selfAllianceId then
      DataCenter.AllianceMemberDataManager:UpdateAllianceOfficial(t)
      DataCenter.AllianceMemberDataManager:UpdateAllianceMemberList(t)
      DataCenter.AllianceMemberDataManager:UpdateR4MemberList(t)
    else
      DataCenter.AllianceTempListManager:UpdateAllianceOfficial(t)
      DataCenter.AllianceTempListManager:UpdateAllianceMemberList(t)
    end
    if t.groupDescription ~= nil then
      DataCenter.AllianceMemberDataManager:UpdateAllianceRankName(t.groupDescription)
    else
      DataCenter.AllianceMemberDataManager:UpdateAllianceRankName({})
    end
    if t.viewOpen ~= nil then
      DataCenter.AllianceMemberDataManager:UpdateAllianceRankVisible(t.viewOpen)
    else
      DataCenter.AllianceMemberDataManager:UpdateAllianceRankVisible(0)
    end
    if BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
      DataCenter.ActEpidemicZoneManager:UpdateAllianceMemberList(allianceId, t.list)
    end
    EventManager:GetInstance():Broadcast(EventId.AllianceMember)
    if t.allianceOfficialArr and allianceId == selfAllianceId then
      DataCenter.AllianceMemberDataManager:UpdateAlliancePosition(t)
    end
  else
    EventManager:GetInstance():Broadcast(EventId.SearchAllianceError)
  end
  EventManager:GetInstance():Broadcast(EventId.GuideWaitMessage)
end

AlRankMessage.OnCreate = OnCreate
AlRankMessage.HandleMessage = HandleMessage
return AlRankMessage
