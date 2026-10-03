local AllianceWartimeSetMessage = BaseClass("AllianceWartimeSetMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceWartimeSetMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("index", param.index)
end

function AllianceWartimeSetMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.UILWSeasonAllianceWarTimeManager:OnSetTimeCallback(t)
  end
end

return AllianceWartimeSetMessage
