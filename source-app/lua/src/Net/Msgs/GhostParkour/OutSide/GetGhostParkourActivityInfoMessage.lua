local GetGhostParkourActivityInfoMessage = BaseClass("GetGhostParkourActivityInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetGhostParkourActivityInfoMessage:OnCreate(isOpenView)
  base.OnCreate(self)
  self.sfsObj:PutBool("isOpenView", isOpenView)
end

function GetGhostParkourActivityInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWGhostParkourDataManager:SaveGhostParkourMainInfo(t)
  end
end

return GetGhostParkourActivityInfoMessage
