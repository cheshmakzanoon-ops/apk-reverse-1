local CreateChatRoomCommand = BaseClass("CreateChatRoomCommand", SFSBaseMessage)

local function OnCreate(self, param)
  if param.type then
    self.sfsObj:PutLong("type", param.type)
  end
  if param.name then
    self.sfsObj:PutUtfString("name", param.name)
  end
  local memberList = param.memberList
  if type(memberList) == "string" then
    memberList = string.split(memberList, ";")
  end
  if type(memberList) == "table" then
    self.sfsObj:PutLuaArray("members", memberList)
  else
    print("member error!!!")
  end
end

local function HandleMessage(self, msg)
  if msg.errorCode then
    local errorCode = msg.errorCode
    if errorCode ~= nil and errorCode ~= "0" then
      UIUtil.ShowErrorCodeTips(msg)
    end
  end
end

CreateChatRoomCommand.OnCreate = OnCreate
CreateChatRoomCommand.HandleMessage = HandleMessage
return CreateChatRoomCommand
