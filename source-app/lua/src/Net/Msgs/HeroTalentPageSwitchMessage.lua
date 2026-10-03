local HeroTalentPageSwitchMessage = BaseClass("HeroTalentPageSwitchMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutUtfString("uuid", param.uuid)
    self.sfsObj:PutInt("talentPageIndex", param.talentPageIndex)
    self.sfsObj:PutUtfString("itemUuid", param.itemUuid)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
end

HeroTalentPageSwitchMessage.OnCreate = OnCreate
HeroTalentPageSwitchMessage.HandleMessage = HandleMessage
return HeroTalentPageSwitchMessage
