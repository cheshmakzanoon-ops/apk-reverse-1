local ActivitySelectcampSelectMessage = BaseClass("ActivitySelectcampSelectMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ActivitySelectcampSelectMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("value", param.value)
end

function ActivitySelectcampSelectMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonSelectCampManager:OnSelectCallback(t)
  end
end

return ActivitySelectcampSelectMessage
