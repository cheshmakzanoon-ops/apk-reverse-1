local LWSheepMoveMessage = BaseClass("LWSheepMoveMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, type, pointId)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
  self.sfsObj:PutUtfString("pointId", pointId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    DataCenter.LWSheepDataManager:Error()
  else
    DataCenter.LWSheepDataManager:UpdateMoveSheep(t)
  end
end

LWSheepMoveMessage.OnCreate = OnCreate
LWSheepMoveMessage.HandleMessage = HandleMessage
return LWSheepMoveMessage
