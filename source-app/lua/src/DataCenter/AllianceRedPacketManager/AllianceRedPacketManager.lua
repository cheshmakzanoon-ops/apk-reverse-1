local AllianceRedPacketManager = BaseClass("AllianceRedPacketManager")
local RedPacketInfo = require("DataCenter.AllianceRedPacketManager.RedPacketInfo")
local Localization = CS.GameEntry.Localization

function AllianceRedPacketManager:__init()
  self.redPacketList = {}
  self.msgTable = {}
end

function AllianceRedPacketManager:__delete()
  self.redPacketList = nil
  self.msgTable = nil
end

function AllianceRedPacketManager:InitRedPacket(message)
  if message.prepareRedPackets ~= nil then
    local data = message.prepareRedPackets
    for i = 1, #data do
      local info = RedPacketInfo.New()
      info:ParseData(data[i])
      self.redPacketList[info.uuid] = info
    end
  end
end

function AllianceRedPacketManager:RequestRedPacket()
  SFSNetwork.SendMessage(MsgDefines.GetAllianceRedPacket)
end

function AllianceRedPacketManager:UpdateRedPacketByUUid(message)
  if next(message) then
    local data = self:GetRedPacketByUUid(message.uuid)
    if data then
      data:UpdateData(message)
    else
      local info = RedPacketInfo.New()
      info:UpdateData(message)
      if not message.status then
        info:UpdateStatus(RedPacketState.VALID)
      end
      self.redPacketList[info.uuid] = info
    end
  end
end

function AllianceRedPacketManager:UpdateRecordHandle(message)
  for i = 1, #message do
    local data = self:GetRedPacketByUUid(message[i].uid)
    if data then
      data:UpdateStatus(message[i].status)
    end
  end
end

function AllianceRedPacketManager:GetRedPacketByUUid(uuid)
  if self.redPacketList[uuid] then
    return self.redPacketList[uuid]
  end
  return nil
end

function AllianceRedPacketManager:GetRedPacket()
  return self.redPacketList
end

function AllianceRedPacketManager:UpdateRecordByUUid(message)
  if next(message) then
    local data = self:GetRedPacketByUUid(message.redPack.uuid)
    if data then
      data:UpdateData(message.redPack)
      data:UpdateRecord(message.record)
      data:UpdateStatus(message.status)
    else
      local info = RedPacketInfo.New()
      info:UpdateData(message.redPack)
      info:UpdateRecord(message.record)
      info:UpdateStatus(message.status)
      self.redPacketList[info.uuid] = info
    end
    if message.getGold then
      local dialog
      if message.redPack.resType == ResourceType.Gold then
        LuaEntry.Player.gold = message.gold
        EventManager:GetInstance():Broadcast(EventId.UpdateGold)
        dialog = GameDialogDefine.DIAMOND
      elseif message.redPack.resType == ResourceType.Food then
        LuaEntry.Resource.money = message.resource.money
        EventManager:GetInstance():Broadcast(EventId.ResourceUpdated)
        local template = DataCenter.ResourceTemplateManager:GetResourceTemplate(RewardToResType[RewardType.FOOD])
        dialog = template.name
      end
      local k4 = LuaEntry.DataConfig:TryGetNum("red_packet_time", "k4")
      if message.getGold >= message.redPack.total * k4 * 0.01 then
        local _chatRoomManager = ChatInterface.getRoomMgr()
        for _, chatItem in pairs(_chatRoomManager:GetShareRoom()) do
          if chatItem:isAllianceRoom() then
            local _roomId = chatItem.roomId
            ChatInterface.ChatShareMsg(_roomId, "390888", 3, {
              message.redPack.name,
              message.getGold,
              ""
            }, {
              "",
              "",
              dialog
            })
            break
          end
        end
      end
      if next(self.msgTable) then
        ChatManager2:GetInstance():SetGiveLikeMsgTime(self.msgTable.msgSeq)
        ChatManager2:GetInstance():SetGiveLikeAnim(self.msgTable.msgSeq, 1)
        EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SEND_ROOM_MSG_UP_COMMAND, self.msgTable)
        self.msgTable = {}
      end
      EventManager:GetInstance():Broadcast(EventId.GetRedPacketUpdate)
    end
  end
end

function AllianceRedPacketManager:UpdateStatusByUUid(uuid, state)
  local data = self:GetRedPacketByUUid(uuid)
  data:UpdateStatus(state)
end

function AllianceRedPacketManager:GetValidRedPacketNum()
  local num = 0
  local data = self:GetRedPacket()
  if next(data) then
    for i, v in pairs(data) do
      if v.status == RedPacketState.VALID then
        num = num + 1
      end
    end
  end
  return num
end

function AllianceRedPacketManager:SetRedRoomInfo(param)
  self.msgTable = param
end

function AllianceRedPacketManager:ClearRedPacket()
  self.redPacketList = {}
end

return AllianceRedPacketManager
