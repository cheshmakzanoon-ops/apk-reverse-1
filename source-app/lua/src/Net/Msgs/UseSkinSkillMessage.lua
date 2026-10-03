local UseSkinSkillMessage = BaseClass("UseSkinSkillMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, skinId, skillId, serverId, worldId)
  base.OnCreate(self)
  self.sfsObj:PutInt("skinId", skinId)
  self.sfsObj:PutInt("skillId", skillId)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutInt("worldId", worldId)
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

local function GetTestData(self, skillId)
  local t = {
    _id = 167,
    _time = 64,
    cdEndTime = UITimeManager:GetInstance():GetServerTime() + 5000,
    intervalUseTime = UITimeManager:GetInstance():GetServerTime() + 3000,
    skillId = skillId or 10001
  }
  return t
end

UseSkinSkillMessage.GetTestData = GetTestData
UseSkinSkillMessage.OnCreate = OnCreate
UseSkinSkillMessage.HandleMessage = HandleMessage
return UseSkinSkillMessage
