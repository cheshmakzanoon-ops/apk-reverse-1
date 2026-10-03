local PushSkinSkillCdMessage = BaseClass("PushSkinSkillCdMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    local para2 = t.errorPara2
    if para2 == nil then
      UIUtil.ShowTipsId(errCode)
    elseif type(para2) == "table" and 0 < #para2 then
      UIUtil.ShowTips(Localization:GetString(errCode, table.unpack(para2)))
    end
    return
  end
  if t.skillId and t.cdEndTime then
    DataCenter.CitySkinSkillManager:SetSkillCdData(t.skillId, t.cdEndTime, t.intervalUseTime)
    EventManager:GetInstance():Broadcast(EventId.CitySkinSkillUse)
  end
end

PushSkinSkillCdMessage.OnCreate = OnCreate
PushSkinSkillCdMessage.HandleMessage = HandleMessage
return PushSkinSkillCdMessage
