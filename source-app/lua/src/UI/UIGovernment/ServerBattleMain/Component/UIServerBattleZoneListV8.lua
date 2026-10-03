local UIServerBattleZoneListV8 = BaseClass("UIServerBattleZoneListV8", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UIServerBattleZoneInfo = require("UI.UIGovernment.ServerBattleMain.Component.UIServerBattleZoneInfo")
local info_btn_path = "info/InfoBtn"
local title_path = "info/title"
local remain_time_path = "info/TimeBg/remainTime"
local line12_path = "Viewport/Content/vs/2/line12"
local line56_path = "Viewport/Content/vs/2/line56"
local line34_path = "Viewport/Content/vs/1/line34"
local line78_path = "Viewport/Content/vs/1/line78"
local bg15_path = "Viewport/Content/vs/bg15"
local server15_path = "Viewport/Content/vs/bg15/Server15"
local bg48_path = "Viewport/Content/vs/bg48"
local server48_path = "Viewport/Content/vs/bg48/Server48"
local bg12_path = "Viewport/Content/line/bg12"
local server12_path = "Viewport/Content/line/bg12/Server12"
local bg34_path = "Viewport/Content/line/bg34"
local server34_path = "Viewport/Content/line/bg34/Server34"
local bg56_path = "Viewport/Content/line/bg56"
local server56_path = "Viewport/Content/line/bg56/Server56"
local bg78_path = "Viewport/Content/line/bg78"
local server78_path = "Viewport/Content/line/bg78/Server78"
local line1_path = "Viewport/Content/line/line1"
local line2_path = "Viewport/Content/line/line2"
local line3_path = "Viewport/Content/line/line3"
local line4_path = "Viewport/Content/line/line4"
local line5_path = "Viewport/Content/line/line5"
local line6_path = "Viewport/Content/line/line6"
local line7_path = "Viewport/Content/line/line7"
local line8_path = "Viewport/Content/line/line8"
local p1_path = "Viewport/Content/top/p1"
local p2_path = "Viewport/Content/top/p2"
local p3_path = "Viewport/Content/top/p3"
local p4_path = "Viewport/Content/top/p4"
local p5_path = "Viewport/Content/bottom/p5"
local p6_path = "Viewport/Content/bottom/p6"
local p7_path = "Viewport/Content/bottom/p7"
local p8_path = "Viewport/Content/bottom/p8"
local status1_win_path = "Viewport/Content/vs/bg15/status1Win"
local status1_lost_path = "Viewport/Content/vs/bg15/status1Lost"
local status2_win_path = "Viewport/Content/vs/bg48/status2Win"
local status2_lost_path = "Viewport/Content/vs/bg48/status2Lost"

function UIServerBattleZoneListV8:OnCreate()
  base.OnCreate(self)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.remain_time = self:AddComponent(UITextMeshProUGUIEx, remain_time_path)
  self.bg15 = self:AddComponent(UIButton, bg15_path)
  self.server15 = self:AddComponent(UITextMeshProUGUIEx, server15_path)
  self.bg48 = self:AddComponent(UIButton, bg48_path)
  self.server48 = self:AddComponent(UITextMeshProUGUIEx, server48_path)
  self.bg12 = self:AddComponent(UIButton, bg12_path)
  self.server12 = self:AddComponent(UITextMeshProUGUIEx, server12_path)
  self.bg34 = self:AddComponent(UIButton, bg34_path)
  self.server34 = self:AddComponent(UITextMeshProUGUIEx, server34_path)
  self.bg56 = self:AddComponent(UIButton, bg56_path)
  self.server56 = self:AddComponent(UITextMeshProUGUIEx, server56_path)
  self.bg78 = self:AddComponent(UIButton, bg78_path)
  self.server78 = self:AddComponent(UITextMeshProUGUIEx, server78_path)
  self.serverWin1256 = nil
  self.serverWin3478 = nil
  self.bg15:SetOnClick(function()
    if self.serverWin1256 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOfficial, {anim = true}, self.serverWin1256)
    end
  end)
  self.bg48:SetOnClick(function()
    if self.serverWin3478 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOfficial, {anim = true}, self.serverWin3478)
    end
  end)
  self.serverWin12 = nil
  self.serverWin34 = nil
  self.serverWin56 = nil
  self.serverWin78 = nil
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
  self.bg56:SetOnClick(function()
    if self.serverWin56 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOfficial, {anim = true}, self.serverWin56)
    end
  end)
  self.bg78:SetOnClick(function()
    if self.serverWin78 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOfficial, {anim = true}, self.serverWin78)
    end
  end)
  self.line1 = self:AddComponent(UIImage, line1_path)
  self.line2 = self:AddComponent(UIImage, line2_path)
  self.line3 = self:AddComponent(UIImage, line3_path)
  self.line4 = self:AddComponent(UIImage, line4_path)
  self.line5 = self:AddComponent(UIImage, line5_path)
  self.line6 = self:AddComponent(UIImage, line6_path)
  self.line7 = self:AddComponent(UIImage, line7_path)
  self.line8 = self:AddComponent(UIImage, line8_path)
  self.line12 = self:AddComponent(UIImage, line12_path)
  self.line56 = self:AddComponent(UIImage, line56_path)
  self.line34 = self:AddComponent(UIImage, line34_path)
  self.line78 = self:AddComponent(UIImage, line78_path)
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
  self.status1_win = self:AddComponent(UIImage, status1_win_path)
  self.status1_lost = self:AddComponent(UIImage, status1_lost_path)
  self.status2_win = self:AddComponent(UIImage, status2_win_path)
  self.status2_lost = self:AddComponent(UIImage, status2_lost_path)
  self.info_btn:SetOnClick(function()
    if self.config ~= nil then
      self.config:ShowActivityDesc()
    end
  end)
  self.server15:SetText("?")
  self.server48:SetText("?")
  self.server12:SetText("?")
  self.server34:SetText("?")
  self.server56:SetText("?")
  self.server78:SetText("?")
end

function UIServerBattleZoneListV8:OnDestroy()
  base.OnDestroy(self)
end

function UIServerBattleZoneListV8:OnEnable()
  base.OnEnable(self)
  self:AddUIListener(EventId.CrossKingScheduleRefresh, self.UpdateData)
  self:AddUIListener(EventId.CrossKingRoundInfoALLRefresh, self.UpdateData)
  self:AddUIListener(EventId.CrossKingFightInfoRefresh, self.UpdateData)
end

function UIServerBattleZoneListV8:OnDisable()
  self:RemoveUIListener(EventId.CrossKingScheduleRefresh, self.UpdateData)
  self:RemoveUIListener(EventId.CrossKingRoundInfoALLRefresh, self.UpdateData)
  self:RemoveUIListener(EventId.CrossKingFightInfoRefresh, self.UpdateData)
  base.OnDisable(self)
end

function UIServerBattleZoneListV8:UpdateData()
  self:UpdateEndTime()
  local roundInfo = DataCenter.ZoneWarManager:GetCrossKingRoundInfoALL()
  local configSchedule = DataCenter.ZoneWarManager:GetCrossKingSchedule()
  if configSchedule == nil or roundInfo == nil then
    return
  end
  local player = LuaEntry.Player
  local mySeverId = player:GetSourceServerId()
  local group = configSchedule.initServerGroup.group
  local server1 = group.a[1]
  local server2 = group.a[2]
  local server3 = group.a[3]
  local server4 = group.a[4]
  local server5 = group.b[1]
  local server6 = group.b[2]
  local server7 = group.b[3]
  local server8 = group.b[4]
  local serverKing = roundInfo.serverKing or {}
  local server1Status = server1 == mySeverId and 2 or server2 == mySeverId and 1 or 0
  local server2Status = server2 == mySeverId and 2 or server1 == mySeverId and 1 or 0
  local server3Status = server3 == mySeverId and 2 or server4 == mySeverId and 1 or 0
  local server4Status = server4 == mySeverId and 2 or server3 == mySeverId and 1 or 0
  local server5Status = server5 == mySeverId and 2 or server6 == mySeverId and 1 or 0
  local server6Status = server6 == mySeverId and 2 or server5 == mySeverId and 1 or 0
  local server7Status = server7 == mySeverId and 2 or server8 == mySeverId and 1 or 0
  local server8Status = server8 == mySeverId and 2 or server7 == mySeverId and 1 or 0
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
  self.line1:SetActive(false)
  self.line2:SetActive(false)
  self.line3:SetActive(false)
  self.line4:SetActive(false)
  self.line5:SetActive(false)
  self.line6:SetActive(false)
  self.line7:SetActive(false)
  self.line8:SetActive(false)
  self.status1_win:SetActive(false)
  self.status1_lost:SetActive(false)
  self.status2_win:SetActive(false)
  self.status2_lost:SetActive(false)
  self.view:UpdateStatus(self.bg12, self.server12, "???", 0)
  self.view:UpdateStatus(self.bg34, self.server34, "???", 0)
  self.view:UpdateStatus(self.bg56, self.server56, "???", 0)
  self.view:UpdateStatus(self.bg78, self.server78, "???", 0)
  self.view:UpdateStatus(self.bg15, self.server15, "???", 0)
  self.view:UpdateStatus(self.bg48, self.server48, "???", 0)
  self.p1:ReInit(serverKing[tostring(server1)], self.serverBattleType, server1Status, server1, serverInfo[server1])
  self.p2:ReInit(serverKing[tostring(server2)], self.serverBattleType, server2Status, server2, serverInfo[server2])
  self.p3:ReInit(serverKing[tostring(server3)], self.serverBattleType, server3Status, server3, serverInfo[server3])
  self.p4:ReInit(serverKing[tostring(server4)], self.serverBattleType, server4Status, server4, serverInfo[server4])
  self.p5:ReInit(serverKing[tostring(server5)], self.serverBattleType, server5Status, server5, serverInfo[server5])
  self.p6:ReInit(serverKing[tostring(server6)], self.serverBattleType, server6Status, server6, serverInfo[server6])
  self.p7:ReInit(serverKing[tostring(server7)], self.serverBattleType, server7Status, server7, serverInfo[server7])
  self.p8:ReInit(serverKing[tostring(server8)], self.serverBattleType, server8Status, server8, serverInfo[server8])
  self.serverWin12 = nil
  self.serverWin34 = nil
  self.serverWin56 = nil
  self.serverWin78 = nil
  self.serverWin1256 = nil
  self.serverWin3478 = nil
  if roundInfo.serverInfo and roundInfo.allRoundInfo then
    local win12, win34, win56, win78, win1256, win3478
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
        elseif v.serverId == server5 then
          self.p5:ShowOccupy()
        elseif v.serverId == server6 then
          self.p6:ShowOccupy()
        elseif v.serverId == server7 then
          self.p7:ShowOccupy()
        elseif v.serverId == server8 then
          self.p8:ShowOccupy()
        end
      end
      if v.win == nil or v.win == 1 then
        if v.serverId == server1 and v.vsServerId == server2 or v.serverId == server2 and v.vsServerId == server1 then
          self.line1:SetActive(v.serverId == server1)
          self.line2:SetActive(v.serverId == server2)
          win12 = v.serverId
        elseif v.serverId == server3 and v.vsServerId == server4 or v.serverId == server4 and v.vsServerId == server3 then
          self.line3:SetActive(v.serverId == server3)
          self.line4:SetActive(v.serverId == server4)
          win34 = v.serverId
        elseif v.serverId == server5 and v.vsServerId == server6 or v.serverId == server6 and v.vsServerId == server5 then
          self.line5:SetActive(v.serverId == server5)
          self.line6:SetActive(v.serverId == server6)
          win56 = v.serverId
        elseif v.serverId == server7 and v.vsServerId == server8 or v.serverId == server8 and v.vsServerId == server7 then
          self.line7:SetActive(v.serverId == server7)
          self.line8:SetActive(v.serverId == server8)
          win78 = v.serverId
        end
      end
    end
    self:UpdateStatus(self.bg12, self.server12, win12, mySeverId == win56 and 1 or 0, mySeverId)
    self:UpdateStatus(self.bg34, self.server34, win34, mySeverId == win78 and 1 or 0, mySeverId)
    self:UpdateStatus(self.bg56, self.server56, win56, mySeverId == win12 and 1 or 0, mySeverId)
    self:UpdateStatus(self.bg78, self.server78, win78, mySeverId == win34 and 1 or 0, mySeverId)
    self.serverWin12 = win12
    self.serverWin34 = win34
    self.serverWin56 = win56
    self.serverWin78 = win78
    for _, v in ipairs(roundInfo.allRoundInfo) do
      if v.win == nil or v.win == 1 then
        if v.serverId == win12 and v.vsServerId == win56 or v.serverId == win56 and v.vsServerId == win12 then
          self.line12:SetActive(v.serverId == win12)
          self.line56:SetActive(v.serverId == win56)
          self:UpdateStatus(self.bg12, self.server12, win12, mySeverId == win56 and 1 or 0, mySeverId)
          self:UpdateStatus(self.bg56, self.server56, win56, mySeverId == win12 and 1 or 0, mySeverId)
          win1256 = v.serverId
        elseif v.serverId == win34 and v.vsServerId == win78 or v.serverId == win78 and v.vsServerId == win34 then
          self.line34:SetActive(v.serverId == win34)
          self.line78:SetActive(v.serverId == win78)
          self:UpdateStatus(self.bg34, self.server34, win34, mySeverId == win78 and 1 or 0, mySeverId)
          self:UpdateStatus(self.bg78, self.server78, win78, mySeverId == win34 and 1 or 0, mySeverId)
          win3478 = v.serverId
        end
      end
    end
    if win1256 and win3478 then
      for _, v in ipairs(roundInfo.allRoundInfo) do
        if (v.win == nil or v.win == 1) and (v.serverId == win1256 and v.vsServerId == win3478 or v.serverId == win3478 and v.vsServerId == win1256) then
          self.status1_win:SetActive(v.serverId == win1256)
          self.status1_lost:SetActive(v.serverId == win3478)
          self.status2_win:SetActive(v.serverId == win3478)
          self.status2_lost:SetActive(v.serverId == win1256)
          break
        end
      end
      self:UpdateStatus(self.bg15, self.server15, win1256, mySeverId == win3478 and 1 or 0, mySeverId)
      self:UpdateStatus(self.bg48, self.server48, win3478, mySeverId == win1256 and 1 or 0, mySeverId)
      self.serverWin1256 = win1256
      self.serverWin3478 = win3478
    else
      self.line12:SetActive(false)
      self.line34:SetActive(false)
      self.line56:SetActive(false)
      self.line78:SetActive(false)
    end
  end
end

function UIServerBattleZoneListV8:UpdateStatus(bgNode, txtNode, serverId, status, mySeverId)
  if serverId then
    if mySeverId == serverId then
      self.view:UpdateStatus(bgNode, txtNode, "#" .. serverId, 2)
    else
      self.view:UpdateStatus(bgNode, txtNode, "#" .. serverId, status)
    end
  end
end

function UIServerBattleZoneListV8:ReInit(configSchedule, config, serverBattleType)
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

function UIServerBattleZoneListV8:UpdateEndTime()
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

function UIServerBattleZoneListV8:Update1000MS()
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

return UIServerBattleZoneListV8
