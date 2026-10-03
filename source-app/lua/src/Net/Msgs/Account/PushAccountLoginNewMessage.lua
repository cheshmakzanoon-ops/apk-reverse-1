local AccountLoginNewMessage = BaseClass("AccountLoginNewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param, type)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAccountVerify)
  DataCenter.AccountManager:AccountLoginHandle(t)
end

AccountLoginNewMessage.OnCreate = OnCreate
AccountLoginNewMessage.HandleMessage = HandleMessage
return AccountLoginNewMessage
