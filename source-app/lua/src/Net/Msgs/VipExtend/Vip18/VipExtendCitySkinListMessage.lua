local VipExtendCitySkinListMessage = BaseClass("VipExtendCitySkinListMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutInt("page", param)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.VipExtendManager:OnRefreshCitySkinList(t)
  end
end

VipExtendCitySkinListMessage.OnCreate = OnCreate
VipExtendCitySkinListMessage.HandleMessage = HandleMessage
return VipExtendCitySkinListMessage
