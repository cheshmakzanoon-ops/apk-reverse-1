local UIServerBattleLastKingServerInfo1 = BaseClass("UIServerBattleLastKingServerInfo1", UIBaseContainer)
local base = UIBaseContainer
local UIServerBattleZoneInfo = require("UI.UIGovernment.ServerBattleMain.Component.UIServerBattleZoneInfo")

function UIServerBattleLastKingServerInfo1:OnCreate()
  base.OnCreate(self)
  self.p1 = self:AddComponent(UIServerBattleZoneInfo, "S1")
  self.p2 = self:AddComponent(UIServerBattleZoneInfo, "S2")
end

function UIServerBattleLastKingServerInfo1:OnDestroy()
  base.OnDestroy(self)
end

function UIServerBattleLastKingServerInfo1:ReInit(configSchedule, fightInfo, config, serverBattleType)
  self.config = config
  self.serverBattleType = serverBattleType
  local roundInfo = DataCenter.ZoneWarManager:GetCrossKingRoundInfoALL()
  local mySeverId, leftInfo, rightInfo = DataCenter.ZoneWarManager:ParseVsRound(fightInfo.curVsRound, true)
  local serverInfo1 = fightInfo.serverInfo[tostring(leftInfo.serverId)] or {cfgId = 511001}
  local serverInfo2 = fightInfo.serverInfo[tostring(rightInfo.serverId)] or {cfgId = 511001}
  if roundInfo then
    local serverKing = roundInfo.serverKing or {}
    local rightStatus = DataCenter.ZoneWarManager:IsAlly(mySeverId, rightInfo.serverId) and 2 or 1
    local leftStatus = rightStatus == 1 and 2 or 1
    self.p1:ReInit(serverKing[tostring(leftInfo.serverId)], serverBattleType, leftStatus, leftInfo.serverId, serverInfo1, leftInfo)
    self.p2:ReInit(serverKing[tostring(rightInfo.serverId)], serverBattleType, rightStatus, rightInfo.serverId, serverInfo2, rightInfo)
  else
    SFSNetwork.SendMessage(MsgDefines.CrossKingRoundInfoALL)
  end
end

return UIServerBattleLastKingServerInfo1
