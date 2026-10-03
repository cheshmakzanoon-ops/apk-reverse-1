local MoveAllianceBossS0Message = BaseClass("MoveAllianceBossS0Message", SFSBaseMessage)
local base = SFSBaseMessage

function MoveAllianceBossS0Message:OnCreate(startPoint, endPoint)
  base.OnCreate(self)
  self.sfsObj:PutInt("startPoint", startPoint)
  self.sfsObj:PutInt("endPoint", endPoint)
end

function MoveAllianceBossS0Message:HandleMessage(message)
  base.HandleMessage(self, message)
  local errorCode = message.errorCode
  if errorCode ~= nil then
    UIUtil.ShowTipsId(errorCode)
    return
  end
  DataCenter.S0AllianceBossDataManager:UpdateLastMoveTime(message.moveTime)
end

return MoveAllianceBossS0Message
