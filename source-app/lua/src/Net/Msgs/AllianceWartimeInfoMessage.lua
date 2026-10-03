local AllianceWartimeInfoMessage = BaseClass("AllianceWartimeInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceWartimeInfoMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("allianceid", param.allianceid)
end

function AllianceWartimeInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    DataCenter.UILWSeasonAllianceWarTimeManager:ClearWaitingGetInfo()
  else
    DataCenter.UILWSeasonAllianceWarTimeManager:OnGetInfoCallback(t)
    DataCenter.SeasonCampDestroyManager:OnGetWarTimeInfoCallback(t)
  end
end

return AllianceWartimeInfoMessage
