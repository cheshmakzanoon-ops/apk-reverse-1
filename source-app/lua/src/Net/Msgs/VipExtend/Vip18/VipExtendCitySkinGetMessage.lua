local VipExtendCitySkinGetMessage = BaseClass("VipExtendCitySkinGetMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.VipExtendManager:OnGetCitySkinReward(t)
  end
end

VipExtendCitySkinGetMessage.OnCreate = OnCreate
VipExtendCitySkinGetMessage.HandleMessage = HandleMessage
return VipExtendCitySkinGetMessage
