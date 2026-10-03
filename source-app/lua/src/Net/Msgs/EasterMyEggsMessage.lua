local EasterMyEggsMessage = BaseClass("EasterMyEggsMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EasterMyEggsMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

function EasterMyEggsMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActEasterEggManager:OnRecMyPostEggsData(t)
  end
end

return EasterMyEggsMessage
