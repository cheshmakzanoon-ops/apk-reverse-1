local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local ChatAtCommand = BaseClass("ChatAtCommand", WebSocketBaseMessage)

local function OnCreate(self)
  self.tableData = {}
  if ChatInterface.isInAlliance() then
    local alData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if alData then
      self.tableData.allianceRoom = ChatInterface.getAllianceRoomId()
      self.tableData.allianceTime = alData.joinTime
      if DataCenter.AllianceBaseDataManager:IsR4orR5() then
        self.tableData.r4r5Room = ChatManager2:GetInstance().Room:GetAllianceMangaerRoomId()
        self.tableData.r4r5Time = alData.rankTime
      end
    end
  end
end

local function HandleMessage(self, serverData)
  if serverData ~= nil and serverData.result and serverData.result.code then
    UIUtil.ShowTips(Localization:GetString(serverData.result.code))
    return
  end
  if serverData and serverData.result then
    local atInfo = serverData.result.atInfo or {}
    local atAllInfo = serverData.result.atAll or {}
    local atTimes = serverData.result.atTimes or {}
    for _, v in pairs(atAllInfo) do
      table.insert(atInfo, v)
    end
    local timesMap = {}
    for _, v in pairs(atTimes) do
      timesMap[v.roomId] = v
    end
    local roomMgr = ChatManager2:GetInstance().Room
    for _, v in pairs(atInfo) do
      local roomData = roomMgr:GetRoomData(v.roomId)
      if roomData then
        roomData:InitAtInfo(v)
      end
    end
    local rooms = roomMgr:GetRoomDatas()
    for _, v in pairs(rooms) do
      if timesMap[v.roomId] then
        v:UpdateAtTimes(timesMap[v.roomId])
      end
    end
    AtMaxTimes = serverData.result.maxTimes or AtMaxTimes
  end
end

ChatAtCommand.OnCreate = OnCreate
ChatAtCommand.HandleMessage = HandleMessage
return ChatAtCommand
