local UnlockParkourBuffMessage = BaseClass("UnlockParkourBuffMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UnlockParkourBuffMessage:OnCreate(id)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", id)
end

function UnlockParkourBuffMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSurfingDataManager:UnlockBuffSkill(t)
  end
end

return UnlockParkourBuffMessage
