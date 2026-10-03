local GmSoldierElevenMessage = BaseClass("GmSoldierElevenMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GmSoldierElevenMessage:OnCreate(funcName, progressId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("func", funcName)
  if progressId then
    self.sfsObj:PutInt("progressId", progressId)
  end
end

function GmSoldierElevenMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return GmSoldierElevenMessage
