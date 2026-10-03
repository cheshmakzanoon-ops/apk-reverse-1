local GetMultiUserInfoCommand = BaseClass("GetMultiUserInfoCommand", SFSBaseMessage)

local function OnCreate(self, uidArr)
  self.sfsObj:PutUtfString("allservers", "1")
  self.sfsObj:PutLuaArray("uids", uidArr)
end

local function HandleMessage(self, msg)
  if msg and msg.uids then
    ChatManager2:GetInstance().User:__onReceiveUserInfos(msg.uids)
  end
end

GetMultiUserInfoCommand.OnCreate = OnCreate
GetMultiUserInfoCommand.HandleMessage = HandleMessage
return GetMultiUserInfoCommand
