local base = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local ChatDeleteMessage = BaseClass("ChatDeleteMessage", base)

local function OnCreate(self, roomId, seqId)
  self.tableData = {roomId = roomId, seqId = seqId}
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t then
    local errCode = t.code
    if errCode and errCode ~= 1 then
      UIUtil.ShowTipsId(errCode)
      return
    elseif t.result then
      ChatInterface.getRoomMgr():DeleteRoomMessage(t.result.roomId, t.result.seqId)
      ChatInterface.getMoment():DeleteMomentMessage(t.result.roomId, t.result.seqId)
      if t.result.roomId ~= nil then
        EventManager:GetInstance():Broadcast(EventId.FriendsCircleSelfCommentUpdate, {
          roomId = t.result.roomId,
          self_comment = t.result.self_comment
        })
      end
    end
  end
end

ChatDeleteMessage.OnCreate = OnCreate
ChatDeleteMessage.HandleMessage = HandleMessage
return ChatDeleteMessage
