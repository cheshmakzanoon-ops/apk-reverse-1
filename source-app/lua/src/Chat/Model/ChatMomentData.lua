local base = require("Chat.Model.ChatRoomData")
local ChatMomentData = BaseClass("ChatMomentData", base)

function ChatMomentData:getNewMsgNum()
  return 0
end

function ChatMomentData:readMsg()
end

function ChatMomentData:AddSuggestMomentData(data)
  if data then
    table.insert(self.msgs, data)
  end
end

return ChatMomentData
