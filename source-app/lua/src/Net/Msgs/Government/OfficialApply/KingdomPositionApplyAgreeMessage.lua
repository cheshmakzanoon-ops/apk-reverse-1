local KingdomPositionApplyAgreeMessage = BaseClass("KingdomPositionApplyAgreeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutUtfString("positionId", param.positionId)
    self.sfsObj:PutUtfString("uid", param.uid)
    self.sfsObj:PutUtfString("t", param.t)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t == nil or t.errorCode == nil then
  else
    UIUtil.ShowTipsId(t.errorCode)
  end
end

KingdomPositionApplyAgreeMessage.OnCreate = OnCreate
KingdomPositionApplyAgreeMessage.HandleMessage = HandleMessage
return KingdomPositionApplyAgreeMessage
