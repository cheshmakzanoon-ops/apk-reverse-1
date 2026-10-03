local MoveAllianceBossMessage = BaseClass("MoveAllianceBossMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, startPoint, endPoint)
  base.OnCreate(self)
  self.sfsObj:PutInt("startPoint", startPoint)
  self.sfsObj:PutInt("endPoint", endPoint)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t == nil or t.errorCode == nil then
  else
    UIUtil.ShowTipsId(t.errorCode)
  end
end

MoveAllianceBossMessage.OnCreate = OnCreate
MoveAllianceBossMessage.HandleMessage = HandleMessage
return MoveAllianceBossMessage
