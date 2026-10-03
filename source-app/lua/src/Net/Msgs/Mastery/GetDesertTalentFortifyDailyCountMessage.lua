local GetDesertTalentFortifyDailyCountMessage = BaseClass("GetDesertTalentFortifyDailyCountMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, targetUid)
  self.sfsObj:PutUtfString("targetUid", targetUid)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.MasteryManager:HandleFortifyDailyCount(t)
end

GetDesertTalentFortifyDailyCountMessage.OnCreate = OnCreate
GetDesertTalentFortifyDailyCountMessage.HandleMessage = HandleMessage
return GetDesertTalentFortifyDailyCountMessage
