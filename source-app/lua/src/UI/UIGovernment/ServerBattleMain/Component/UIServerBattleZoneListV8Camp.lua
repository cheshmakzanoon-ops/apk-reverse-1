local UIServerBattleZoneListV8Camp = BaseClass("UIServerBattleZoneListV8Camp", UIBaseContainer)
local base = UIBaseContainer
local UIServerBattleZoneInfo = require("UI.UIGovernment.ServerBattleMain.Component.UIServerBattleZoneInfo")
local title_path = "info/title"
local info_btn_path = "info/InfoBtn"
local remain_time_path = "info/TimeBg/remainTime"
local desc_btn_path = "info/DescBtn"
local p1_path = "Viewport/Content/right/p1"
local p2_path = "Viewport/Content/right/p2"
local p3_path = "Viewport/Content/right/p3"
local p4_path = "Viewport/Content/right/p4"
local p5_path = "Viewport/Content/left/p5"
local p6_path = "Viewport/Content/left/p6"
local p7_path = "Viewport/Content/left/p7"
local p8_path = "Viewport/Content/left/p8"

function UIServerBattleZoneListV8Camp:OnCreate()
  base.OnCreate(self)
  self.desc_btn = self:AddComponent(UIButton, desc_btn_path)
  self.desc_btn:SetOnClick(function()
    if self.config ~= nil then
      self.config:ShowActivityNews(self.desc_btn.transform.position, true, true)
    end
  end)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.remain_time = self:AddComponent(UIText, remain_time_path)
  self.title = self:AddComponent(UIText, title_path)
  self.p1 = self:AddComponent(UIServerBattleZoneInfo, p1_path)
  self.p2 = self:AddComponent(UIServerBattleZoneInfo, p2_path)
  self.p3 = self:AddComponent(UIServerBattleZoneInfo, p3_path)
  self.p4 = self:AddComponent(UIServerBattleZoneInfo, p4_path)
  self.p5 = self:AddComponent(UIServerBattleZoneInfo, p5_path)
  self.p6 = self:AddComponent(UIServerBattleZoneInfo, p6_path)
  self.p7 = self:AddComponent(UIServerBattleZoneInfo, p7_path)
  self.p8 = self:AddComponent(UIServerBattleZoneInfo, p8_path)
  self.p1.enableOccupy = true
  self.p2.enableOccupy = true
  self.p3.enableOccupy = true
  self.p4.enableOccupy = true
  self.p5.enableOccupy = true
  self.p6.enableOccupy = true
  self.p7.enableOccupy = true
  self.p8.enableOccupy = true
  self.info_btn:SetOnClick(function()
    if self.config ~= nil then
      self.config:ShowActivityDesc()
    end
  end)
  self.desc_btn:SetActive(false)
end

function UIServerBattleZoneListV8Camp:OnDestroy()
  self.desc_btn = nil
  base.OnDestroy(self)
end

function UIServerBattleZoneListV8Camp:OnEnable()
  base.OnEnable(self)
  self:AddUIListener(EventId.CrossKingScheduleRefresh, self.UpdateData)
  self:AddUIListener(EventId.CrossKingRoundInfoALLRefresh, self.UpdateData)
  self:AddUIListener(EventId.CrossKingFightInfoRefresh, self.UpdateData)
end

function UIServerBattleZoneListV8Camp:OnDisable()
  self:RemoveUIListener(EventId.CrossKingScheduleRefresh, self.UpdateData)
  self:RemoveUIListener(EventId.CrossKingRoundInfoALLRefresh, self.UpdateData)
  self:RemoveUIListener(EventId.CrossKingFightInfoRefresh, self.UpdateData)
  base.OnDisable(self)
end

function UIServerBattleZoneListV8Camp:UpdateData()
  self:UpdateEndTime()
  local roundInfo = DataCenter.ZoneWarManager:GetCrossKingRoundInfoALL()
  local configSchedule = DataCenter.ZoneWarManager:GetCrossKingSchedule()
  if configSchedule == nil or roundInfo == nil then
    return
  end
  if configSchedule.configNow then
    self.title:SetLocalText(configSchedule.configNow:GetWeekText())
  end
  local mySeverId = LuaEntry.Player:GetSourceServerId()
  local selfCamp = DataCenter.ZoneWarManager:GetServerCampIndex(mySeverId)
  local group = configSchedule.initServerGroup.group
  local server1 = group.a[1] or 0
  local server2 = group.a[2] or 0
  local server3 = group.a[3] or 0
  local server4 = group.a[4] or 0
  local server5 = group.b[1] or 0
  local server6 = group.b[2] or 0
  local server7 = group.b[3] or 0
  local server8 = group.b[4] or 0
  local serverKing = roundInfo.serverKing or {}
  local serverInfo = {}
  serverInfo[server1] = roundInfo.serverInfo[tostring(server1)] or {cfgId = 511001}
  serverInfo[server2] = roundInfo.serverInfo[tostring(server2)] or {cfgId = 511001}
  serverInfo[server3] = roundInfo.serverInfo[tostring(server3)] or {cfgId = 511001}
  serverInfo[server4] = roundInfo.serverInfo[tostring(server4)] or {cfgId = 511001}
  serverInfo[server5] = roundInfo.serverInfo[tostring(server5)] or {cfgId = 511001}
  serverInfo[server6] = roundInfo.serverInfo[tostring(server6)] or {cfgId = 511001}
  serverInfo[server7] = roundInfo.serverInfo[tostring(server7)] or {cfgId = 511001}
  serverInfo[server8] = roundInfo.serverInfo[tostring(server8)] or {cfgId = 511001}
  self.configSchedule = configSchedule
  local rightStatus = selfCamp == SeasonFactionType.Rebels and 1 or 2
  local leftStatus = rightStatus == 1 and 2 or 1
  self.p1:ReInit(serverKing[tostring(server1)], self.serverBattleType, leftStatus, server1, serverInfo[server1])
  self.p2:ReInit(serverKing[tostring(server2)], self.serverBattleType, leftStatus, server2, serverInfo[server2])
  self.p3:ReInit(serverKing[tostring(server3)], self.serverBattleType, leftStatus, server3, serverInfo[server3])
  self.p4:ReInit(serverKing[tostring(server4)], self.serverBattleType, leftStatus, server4, serverInfo[server4])
  self.p5:ReInit(serverKing[tostring(server5)], self.serverBattleType, rightStatus, server5, serverInfo[server5])
  self.p6:ReInit(serverKing[tostring(server6)], self.serverBattleType, rightStatus, server6, serverInfo[server6])
  self.p7:ReInit(serverKing[tostring(server7)], self.serverBattleType, rightStatus, server7, serverInfo[server7])
  self.p8:ReInit(serverKing[tostring(server8)], self.serverBattleType, rightStatus, server8, serverInfo[server8])
  if roundInfo.serverInfo and roundInfo.allRoundInfo then
    for _, v in ipairs(roundInfo.allRoundInfo) do
      if v.win == -1 and v.round == roundInfo.curRound then
        if v.serverId == server1 or v.serverId == server2 or v.serverId == server3 or v.serverId == server4 then
          self.p1:ShowOccupy()
          self.p2:ShowOccupy()
          self.p3:ShowOccupy()
          self.p4:ShowOccupy()
        elseif v.serverId == server5 or v.serverId == server6 or v.serverId == server7 or v.serverId == server8 then
          self.p5:ShowOccupy()
          self.p6:ShowOccupy()
          self.p7:ShowOccupy()
          self.p8:ShowOccupy()
        end
      end
    end
  end
end

function UIServerBattleZoneListV8Camp:ReInit(configSchedule, config, serverBattleType)
  self.config = config
  self.configSchedule = configSchedule
  self.endTime = configSchedule.endTime
  self.serverBattleType = serverBattleType
  self:UpdateData()
  self:Update1000MS()
  if self.config ~= nil and self.config:HasActivityNews() then
    local count = UIUtil.GetMonthActiveCount("ServerZoneBattleV8CampNews", true)
    if count == 0 then
      self.config:ShowActivityNews(self.desc_btn.transform.position, false, true)
    end
  end
  self.desc_btn:SetActive(self.config:HasActivityNews())
end

function UIServerBattleZoneListV8Camp:UpdateEndTime()
  local configSchedule = self.configSchedule
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < configSchedule.crossStartTime then
    self.endTime = configSchedule.breakThroneProtectTime
  elseif curTime < configSchedule.roundSettleTime then
    self.endTime = configSchedule.roundSettleTime
    local fightInfo = DataCenter.ZoneWarManager:GetCrossKingFightInfo()
    if fightInfo and fightInfo.curVsRound[1].win == 0 and curTime < configSchedule.breakThroneProtectTime then
      self.endTime = configSchedule.breakThroneProtectTime
    end
  elseif curTime < configSchedule.startTime then
    self.endTime = configSchedule.startTime
  else
    self.endTime = configSchedule.endTime
  end
  if curTime > self.endTime then
    self.endTime = configSchedule.endTime
  end
  return self.endTime
end

function UIServerBattleZoneListV8Camp:Update1000MS()
  if self.endTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.endTime - curTime
    if 0 < remainTime then
      self.remain_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.endTime = nil
      self.remain_time:SetText("00:00:00")
    end
  end
end

return UIServerBattleZoneListV8Camp
