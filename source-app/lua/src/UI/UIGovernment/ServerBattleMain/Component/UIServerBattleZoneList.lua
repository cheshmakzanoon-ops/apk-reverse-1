local UIServerBattleZoneList = BaseClass("UIServerBattleZoneList", UIBaseContainer)
local base = UIBaseContainer
local UIServerBattleZoneInfo = require("UI.UIGovernment.ServerBattleMain.Component.UIServerBattleZoneInfo")
local info_btn_path = "info/InfoBtn"
local title_path = "info/title"
local remain_time_path = "info/TimeBg/remainTime"
local line1_path = "Viewport/Content/line/line1"
local line2_path = "Viewport/Content/line/line2"
local line3_path = "Viewport/Content/line/line3"
local line4_path = "Viewport/Content/line/line4"
local p4_path = "Viewport/Content/p4"
local p3_path = "Viewport/Content/p3"
local p1_path = "Viewport/Content/p1"
local p2_path = "Viewport/Content/p2"
local server1_path = "Viewport/Content/vs/bg1/Server1"
local server2_path = "Viewport/Content/vs/bg2/Server2"
local bg1_path = "Viewport/Content/vs/bg1"
local bg2_path = "Viewport/Content/vs/bg2"
local status1_win_path = "Viewport/Content/vs/bg1/status1Win"
local status1_lost_path = "Viewport/Content/vs/bg1/status1Lost"
local status2_win_path = "Viewport/Content/vs/bg2/status2Win"
local status2_lost_path = "Viewport/Content/vs/bg2/status2Lost"

function UIServerBattleZoneList:OnCreate()
  base.OnCreate(self)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.remain_time = self:AddComponent(UITextMeshProUGUIEx, remain_time_path)
  self.line1 = self:AddComponent(UIImage, line1_path)
  self.line2 = self:AddComponent(UIImage, line2_path)
  self.line3 = self:AddComponent(UIImage, line3_path)
  self.line4 = self:AddComponent(UIImage, line4_path)
  self.p4 = self:AddComponent(UIServerBattleZoneInfo, p4_path)
  self.p3 = self:AddComponent(UIServerBattleZoneInfo, p3_path)
  self.p1 = self:AddComponent(UIServerBattleZoneInfo, p1_path)
  self.p2 = self:AddComponent(UIServerBattleZoneInfo, p2_path)
  self.server12 = self:AddComponent(UITextMeshProUGUIEx, server1_path)
  self.server34 = self:AddComponent(UITextMeshProUGUIEx, server2_path)
  self.bg12 = self:AddComponent(UIButton, bg1_path)
  self.bg34 = self:AddComponent(UIButton, bg2_path)
  self.status1_win = self:AddComponent(UIImage, status1_win_path)
  self.status1_lost = self:AddComponent(UIImage, status1_lost_path)
  self.status2_win = self:AddComponent(UIImage, status2_win_path)
  self.status2_lost = self:AddComponent(UIImage, status2_lost_path)
  self.p4.enableOccupy = true
  self.p3.enableOccupy = true
  self.p1.enableOccupy = true
  self.p2.enableOccupy = true
  self.info_btn:SetOnClick(function()
    if self.config ~= nil then
      self.config:ShowActivityDesc()
    end
  end)
  self.bg12:SetOnClick(function()
    if self.serverWin12 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOfficial, {anim = true}, self.serverWin12)
    end
  end)
  self.bg34:SetOnClick(function()
    if self.serverWin34 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOfficial, {anim = true}, self.serverWin34)
    end
  end)
  self.server12:SetText("?")
  self.server34:SetText("?")
end

function UIServerBattleZoneList:OnDestroy()
  base.OnDestroy(self)
end

function UIServerBattleZoneList:OnEnable()
  base.OnEnable(self)
  self:AddUIListener(EventId.CrossKingScheduleRefresh, self.UpdateData)
  self:AddUIListener(EventId.CrossKingRoundInfoALLRefresh, self.UpdateData)
  self:AddUIListener(EventId.CrossKingFightInfoRefresh, self.UpdateData)
end

function UIServerBattleZoneList:OnDisable()
  self:RemoveUIListener(EventId.CrossKingScheduleRefresh, self.UpdateData)
  self:RemoveUIListener(EventId.CrossKingRoundInfoALLRefresh, self.UpdateData)
  self:RemoveUIListener(EventId.CrossKingFightInfoRefresh, self.UpdateData)
  base.OnDisable(self)
end

function UIServerBattleZoneList:UpdateData()
  self:UpdateEndTime()
  local roundInfo = DataCenter.ZoneWarManager:GetCrossKingRoundInfoALL()
  local configSchedule = DataCenter.ZoneWarManager:GetCrossKingSchedule()
  if configSchedule == nil or roundInfo == nil or roundInfo.serverInfo == nil then
    return
  end
  local player = LuaEntry.Player
  local mySeverId = player:GetSourceServerId()
  local group = configSchedule.initServerGroup.group
  local server1 = group.a[1]
  local server2 = group.a[2]
  local server3 = group.b[1]
  local server4 = group.b[2]
  local serverKing = roundInfo.serverKing or {}
  local server1Status = 0
  local server2Status = 0
  local server3Status = 0
  local server4Status = 0
  if server1 == mySeverId then
    server1Status = 2
    server2Status = 1
  elseif server2 == mySeverId then
    server1Status = 1
    server2Status = 2
  elseif server3 == mySeverId then
    server3Status = 2
    server4Status = 1
  elseif server4 == mySeverId then
    server3Status = 1
    server4Status = 2
  end
  local serverInfo = {}
  serverInfo[server1] = roundInfo.serverInfo[tostring(server1)] or {cfgId = 511001}
  serverInfo[server2] = roundInfo.serverInfo[tostring(server2)] or {cfgId = 511001}
  serverInfo[server3] = roundInfo.serverInfo[tostring(server3)] or {cfgId = 511001}
  serverInfo[server4] = roundInfo.serverInfo[tostring(server4)] or {cfgId = 511001}
  self.line1:SetActive(false)
  self.line2:SetActive(false)
  self.line3:SetActive(false)
  self.line4:SetActive(false)
  self.status1_win:SetActive(false)
  self.status1_lost:SetActive(false)
  self.status2_win:SetActive(false)
  self.status2_lost:SetActive(false)
  self.view:UpdateStatus(self.bg12, self.server12, "???", 0)
  self.view:UpdateStatus(self.bg34, self.server34, "???", 0)
  self.p1:ReInit(serverKing[tostring(server1)], self.serverBattleType, server1Status, server1, serverInfo[server1])
  self.p2:ReInit(serverKing[tostring(server2)], self.serverBattleType, server2Status, server2, serverInfo[server2])
  self.p3:ReInit(serverKing[tostring(server3)], self.serverBattleType, server3Status, server3, serverInfo[server3])
  self.p4:ReInit(serverKing[tostring(server4)], self.serverBattleType, server4Status, server4, serverInfo[server4])
  if roundInfo.serverInfo and roundInfo.allRoundInfo then
    local win12, win34
    for _, v in ipairs(roundInfo.allRoundInfo) do
      if v.win == -1 and v.round == roundInfo.curRound then
        if v.serverId == server1 then
          self.p1:ShowOccupy()
        elseif v.serverId == server2 then
          self.p2:ShowOccupy()
        elseif v.serverId == server3 then
          self.p3:ShowOccupy()
        elseif v.serverId == server4 then
          self.p4:ShowOccupy()
        end
      end
      if v.win == nil or v.win == 1 then
        if v.serverId == server1 and v.vsServerId == server2 or v.serverId == server2 and v.vsServerId == server1 then
          self.p1:ReInit(serverKing[tostring(server1)], self.serverBattleType, server1Status, server1, serverInfo[server1])
          self.p2:ReInit(serverKing[tostring(server2)], self.serverBattleType, server2Status, server2, serverInfo[server2])
          self.line1:SetActive(v.serverId == server1)
          self.line2:SetActive(v.serverId == server2)
          win12 = v.serverId
        elseif v.serverId == server3 and v.vsServerId == server4 or v.serverId == server4 and v.vsServerId == server3 then
          self.p3:ReInit(serverKing[tostring(server3)], self.serverBattleType, server3Status, server3, serverInfo[server3])
          self.p4:ReInit(serverKing[tostring(server4)], self.serverBattleType, server4Status, server4, serverInfo[server4])
          self.line3:SetActive(v.serverId == server3)
          self.line4:SetActive(v.serverId == server4)
          win34 = v.serverId
        end
      end
    end
    if win12 and win34 then
      if mySeverId == win12 then
        self.view:UpdateStatus(self.bg12, self.server12, "#" .. win12, 2)
        self.view:UpdateStatus(self.bg34, self.server34, "#" .. win34, 1)
      elseif mySeverId == win34 then
        self.view:UpdateStatus(self.bg12, self.server12, "#" .. win12, 1)
        self.view:UpdateStatus(self.bg34, self.server34, "#" .. win34, 2)
      else
        self.view:UpdateStatus(self.bg12, self.server12, "#" .. win12, 0)
        self.view:UpdateStatus(self.bg34, self.server34, "#" .. win34, 0)
      end
      self.serverWin12 = win12
      self.serverWin34 = win34
      for _, v in ipairs(roundInfo.allRoundInfo) do
        if (v.win == nil or v.win == 1) and (v.serverId == win12 and v.vsServerId == win34 or v.serverId == win34 and v.vsServerId == win12) then
          self.status1_win:SetActive(v.serverId == win12)
          self.status1_lost:SetActive(v.serverId == win34)
          self.status2_win:SetActive(v.serverId == win34)
          self.status2_lost:SetActive(v.serverId == win12)
          break
        end
      end
    else
      self.serverWin12 = nil
      self.serverWin34 = nil
    end
  end
  self.configSchedule = configSchedule
end

function UIServerBattleZoneList:ReInit(configSchedule, config, serverBattleType)
  local weekIndex = DataCenter.ZoneWarManager:GetWeekNum()
  self.config = config
  self.configSchedule = configSchedule
  self.weekIndex = weekIndex
  self.endTime = configSchedule.endTime
  self.title:SetLocalText(config:GetWeekText())
  self.serverBattleType = serverBattleType
  self:UpdateData()
  self:Update1000MS()
end

function UIServerBattleZoneList:UpdateEndTime()
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

function UIServerBattleZoneList:Update1000MS()
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

return UIServerBattleZoneList
