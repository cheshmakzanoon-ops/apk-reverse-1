local SoldierUpMessage = BaseClass("SoldierUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutUtfString("curArmyId", param.curArmyId)
    self.sfsObj:PutBool("isGold", param.isGold)
    self.sfsObj:PutInt("num", param.num)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.ArmyManager:SoldierUpMessageHandle(t)
end

SoldierUpMessage.OnCreate = OnCreate
SoldierUpMessage.HandleMessage = HandleMessage
return SoldierUpMessage
