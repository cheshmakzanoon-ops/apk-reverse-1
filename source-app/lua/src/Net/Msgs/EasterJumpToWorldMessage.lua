local EasterJumpToWorldMessage = BaseClass("EasterJumpToWorldMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EasterJumpToWorldMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

function EasterJumpToWorldMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActEasterEggManager:OnRecWorldEggPoint(t)
  end
end

return EasterJumpToWorldMessage
