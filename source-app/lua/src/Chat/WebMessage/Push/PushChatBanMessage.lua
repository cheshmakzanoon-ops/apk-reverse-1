local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushChatBanMessage = BaseClass("PushChatBanMessage", WebSocketBaseMessage)

local function OnCreate(self)
end

local function HandleMessage(self, serverData)
  if serverData.data ~= nil and serverData.data ~= "" and serverData.params then
    local params = serverData.params
    local uid = params.uid
    local chatBantime = 0
    if chatBantime == 9223372036854775807 or chatBantime == -1 then
      chatBantime = -1
    else
      chatBantime = math.floor(chatBantime / 1000)
    end
    local banName = params.banGmName
    ChatManager2:GetInstance().Restrict:chatBanOrUnBan(uid, banName, chatBantime, 1)
    ChatManager2:GetInstance().User:updateBanTime(uid, chatBantime)
  end
end

PushChatBanMessage.OnCreate = OnCreate
PushChatBanMessage.HandleMessage = HandleMessage
return PushChatBanMessage
