local LWSeasonHeroLVInterchangeMessage = BaseClass("LWSeasonHeroLVInterchangeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, srcUuid, destUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("src_hero_uuid", srcUuid)
  self.sfsObj:PutLong("dst_hero_uuid", destUuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  EventManager:GetInstance():Broadcast(EventId.LWSeasonHeroLevelChange)
end

LWSeasonHeroLVInterchangeMessage.OnCreate = OnCreate
LWSeasonHeroLVInterchangeMessage.HandleMessage = HandleMessage
return LWSeasonHeroLVInterchangeMessage
