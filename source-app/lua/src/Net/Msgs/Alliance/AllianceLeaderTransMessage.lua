local AllianceLeaderTransMessage = BaseClass("AllianceLeaderTransMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, playerId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("playerId", playerId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if t.errorPara2 then
      UIUtil.ShowTips(Localization:GetString(errCode, table.unpack(t.errorPara2)))
    else
      UIUtil.ShowTips(Localization:GetString(errCode))
    end
  else
    DataCenter.ActMigrationManager:OnAlLeaderChanged()
    local newLeaderUid
    if t.alliance ~= nil then
      newLeaderUid = t.alliance.learderUid
      DataCenter.AllianceBaseDataManager:UpdateAllianceBaseData(t)
    end
    if t.oldLeaderId ~= nil then
      DataCenter.AllianceMemberDataManager:AllianceLeaderChange(t.oldLeaderId, newLeaderUid, t.oldLeaderRank)
      if t.oldLeaderId == LuaEntry.Player.uid then
        DataCenter.AllianceMemberDataManager:SetNeedShowR4Recommend(false)
        EventManager:GetInstance():Broadcast(EventId.Al_R4RecommendTips)
      end
    end
    EventManager:GetInstance():Broadcast(EventId.AllianceMember)
    UIUtil.ShowTipsId(390952)
  end
end

AllianceLeaderTransMessage.OnCreate = OnCreate
AllianceLeaderTransMessage.HandleMessage = HandleMessage
return AllianceLeaderTransMessage
