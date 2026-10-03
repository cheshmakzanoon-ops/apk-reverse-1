local ArmyAddMessage = BaseClass("ArmyAddMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutUtfString("id", param.id)
    self.sfsObj:PutBool("gold", param.gold)
    self.sfsObj:PutInt("num", param.num)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.ArmyManager:ArmyAddMessageHandle(t)
end

ArmyAddMessage.OnCreate = OnCreate
ArmyAddMessage.HandleMessage = HandleMessage
return ArmyAddMessage
