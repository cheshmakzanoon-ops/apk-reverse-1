local SavePayModelMessage = BaseClass("SavePayModelMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, platform, payType)
  base.OnCreate(self)
  self.sfsObj:PutInt("platform", platform)
  self.sfsObj:PutInt("payType", payType)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    DataCenter.PaymentMethodManager:RestoreServerPreferences()
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.PaymentMethodManager:ApplyPayModelUpdate(t)
end

SavePayModelMessage.OnCreate = OnCreate
SavePayModelMessage.HandleMessage = HandleMessage
return SavePayModelMessage
