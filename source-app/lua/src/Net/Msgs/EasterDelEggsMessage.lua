local EasterDelEggsMessage = BaseClass("EasterDelEggsMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EasterDelEggsMessage:OnCreate(activityId, type, delArr)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("type", type)
  self.sfsObj:PutLuaArray("delArr", delArr)
end

function EasterDelEggsMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActEasterEggManager:OnRecDeleteMyEggs(t)
  end
end

return EasterDelEggsMessage
