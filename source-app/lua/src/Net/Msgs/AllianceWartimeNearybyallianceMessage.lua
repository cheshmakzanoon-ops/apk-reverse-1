local AllianceWartimeNearybyallianceMessage = BaseClass("AllianceWartimeNearybyallianceMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceWartimeNearybyallianceMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("allianceid", param.allianceid)
end

function AllianceWartimeNearybyallianceMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonDataManager:OnGetNearAllianceWarTimeCallback(t)
  end
end

return AllianceWartimeNearybyallianceMessage
