local LwSaveDetectPlaneStageMessage = BaseClass("LwSaveDetectPlaneStageMessage", SFSBaseMessage)
local base = SFSBaseMessage

function LwSaveDetectPlaneStageMessage:OnCreate(id, isWin, uuid)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", id)
  self.sfsObj:PutBool("isWin", isWin)
  self.sfsObj:PutLong("uuid", uuid)
end

function LwSaveDetectPlaneStageMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return LwSaveDetectPlaneStageMessage
