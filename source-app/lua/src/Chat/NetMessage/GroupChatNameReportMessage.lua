local GroupChatNameReportMessage = BaseClass("GroupChatNameReportMessage", SFSBaseMessage)

local function OnCreate(self, roomId, reasons, name, content)
  self.sfsObj:PutUtfString("roomId", roomId)
  local str = ""
  for key, v in pairs(reasons) do
    if string.IsNullOrEmpty(str) then
      str = tostring(key)
    else
      str = str .. "," .. tostring(key)
    end
  end
  self.sfsObj:PutUtfString("reason", str)
  self.sfsObj:PutUtfString("name", name)
  self.sfsObj:PutUtfString("content", content)
end

local function HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  end
end

GroupChatNameReportMessage.OnCreate = OnCreate
GroupChatNameReportMessage.HandleMessage = HandleMessage
return GroupChatNameReportMessage
