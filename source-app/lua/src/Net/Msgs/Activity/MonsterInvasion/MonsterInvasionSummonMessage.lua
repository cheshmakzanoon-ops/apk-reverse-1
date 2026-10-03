local MonsterInvasionSummonMessage = BaseClass("MonsterInvasionSummonMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uid)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local monsterId = t.monsterId
    local level = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.Monster), monsterId, "level")
    local showStr = Localization:GetString("2901047", level)
    local duration = LuaEntry.DataConfig:TryGetNum("monster_invasion", "k11", 1)
    UIUtil.ShowTips(showStr, duration)
    local uuid = t.uuid
    if uuid and CS.SceneManager.World then
      local troop = CS.SceneManager.World:GetTroop(uuid)
      if troop then
        troop:InitBossBornStage(2)
      else
        DataCenter.ActivityMonsterInvasionDataManager:OnMarkBossTroopSpeak(t.uuid)
      end
    end
  end
end

MonsterInvasionSummonMessage.OnCreate = OnCreate
MonsterInvasionSummonMessage.HandleMessage = HandleMessage
return MonsterInvasionSummonMessage
