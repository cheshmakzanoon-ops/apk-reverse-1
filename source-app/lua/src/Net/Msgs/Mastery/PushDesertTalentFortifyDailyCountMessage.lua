local PushDesertTalentFortifyDailyCountMessage = BaseClass("PushDesertTalentFortifyDailyCountMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
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

PushDesertTalentFortifyDailyCountMessage.OnCreate = OnCreate
PushDesertTalentFortifyDailyCountMessage.HandleMessage = HandleMessage
return PushDesertTalentFortifyDailyCountMessage
