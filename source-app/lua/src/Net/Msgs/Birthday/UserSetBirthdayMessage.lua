local UserSetBirthdayMessage = BaseClass("UserSetBirthdayMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UserSetBirthdayMessage:OnCreate(birthday, age, displayType, zodType)
  base.OnCreate(self)
  if birthday then
    self.sfsObj:PutUtfString("birthday", birthday)
  end
  if age then
    self.sfsObj:PutInt("age", age)
  end
  if displayType then
    self.sfsObj:PutInt("displayType", displayType)
  end
  if zodType then
    self.sfsObj:PutInt("zodType", zodType)
  end
end

function UserSetBirthdayMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.BirthdayDataManager:UpdateData(t)
    EventManager:GetInstance():Broadcast(EventId.BirthdaySetDataSuccess)
  end
end

return UserSetBirthdayMessage
