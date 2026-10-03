local DetectEventLastStandFeatureMessage = BaseClass("DetectEventLastStandFeatureMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DetectEventLastStandFeatureMessage:OnCreate(uuid, isWin, stageId)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutBool("isWin", isWin)
  self.sfsObj:PutInt("id", stageId)
end

function DetectEventLastStandFeatureMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return DetectEventLastStandFeatureMessage
