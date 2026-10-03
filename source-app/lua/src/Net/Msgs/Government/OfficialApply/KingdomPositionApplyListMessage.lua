local KingdomPositionApplyListMessage = BaseClass("KingdomPositionApplyListMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, positionId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("positionId", positionId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.OfficialApplyManager:InitApplyList(t)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

KingdomPositionApplyListMessage.OnCreate = OnCreate
KingdomPositionApplyListMessage.HandleMessage = HandleMessage
return KingdomPositionApplyListMessage
