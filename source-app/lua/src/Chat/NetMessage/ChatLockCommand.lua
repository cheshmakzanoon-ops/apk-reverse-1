local ChatLockCommand = BaseClass("ChatLockCommand", SFSBaseMessage)

local function OnCreate(self, uid)
  self.sfsObj:PutUtfString("uid", uid)
end

local function HandleMessage(self, msg)
  DataCenter.ChatPrivateSearchDataManager:RemoveBlockedRoomData(msg)
  local Restrict = ChatManager2:GetInstance().Restrict
  local shieldInfo
  if not table.IsNullOrEmpty(msg.chatShield) then
    for _, obj in ipairs(msg.chatShield) do
      shieldInfo = Restrict:CreateChatShieldInfo()
      shieldInfo:onParseServerData(obj)
      Restrict:addShieldInfo(shieldInfo)
      ChatInterface.flyHint(ChatInterface.getString("290011", obj.name))
    end
  end
  if msg.code == "280013" then
    if shieldInfo then
      Logger.LogInfo(" This user has been blocked. uid : " .. tostring(shieldInfo.uid))
    else
      Logger.LogInfo(" This user has been blocked. not  shieldInfo")
    end
  end
end

ChatLockCommand.OnCreate = OnCreate
ChatLockCommand.HandleMessage = HandleMessage
return ChatLockCommand
