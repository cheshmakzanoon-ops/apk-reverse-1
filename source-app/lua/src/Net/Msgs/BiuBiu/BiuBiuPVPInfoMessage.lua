local BiuBiuPVPInfoMessage = BaseClass("BiuBiuPVPInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, opt)
  base.OnCreate(self)
  self.sfsObj:PutInt("opt", opt)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local room = DataCenter.LWBiuBiuDataManager:GetRoom()
    room:UpdateMsg(t, true)
  end
end

BiuBiuPVPInfoMessage.OnCreate = OnCreate
BiuBiuPVPInfoMessage.HandleMessage = HandleMessage
return BiuBiuPVPInfoMessage
