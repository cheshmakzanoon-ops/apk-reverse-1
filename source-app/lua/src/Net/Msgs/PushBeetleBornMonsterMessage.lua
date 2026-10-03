local PushBeetleBornMonsterMessage = BaseClass("PushBeetleBornMonsterMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local mosnterId = t.monsterId
    local uuid = t.uuid
    if uuid and CS.SceneManager.World then
      local troop = CS.SceneManager.World:GetTroop(uuid)
      if troop and troop:PlayBornAni() then
      else
        DataCenter.RunningBossDataManager:OnMarkMonsterTroopCreate(t.uuid)
      end
    end
  end
end

PushBeetleBornMonsterMessage.OnCreate = OnCreate
PushBeetleBornMonsterMessage.HandleMessage = HandleMessage
return PushBeetleBornMonsterMessage
