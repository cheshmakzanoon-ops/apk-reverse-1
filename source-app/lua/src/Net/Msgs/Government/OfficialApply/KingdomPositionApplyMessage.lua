local KingdomPositionApplyMessage = BaseClass("KingdomPositionApplyMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, positionId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("positionId", positionId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t == nil or t.errorCode == nil then
  else
    UIUtil.ShowTipsId(t.errorCode)
  end
end

KingdomPositionApplyMessage.OnCreate = OnCreate
KingdomPositionApplyMessage.HandleMessage = HandleMessage
return KingdomPositionApplyMessage
