local ActivitySelectcampInfoMessage = BaseClass("ActivitySelectcampInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ActivitySelectcampInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function ActivitySelectcampInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonSelectCampManager:OnGetInfoCallback(t)
  end
end

return ActivitySelectcampInfoMessage
