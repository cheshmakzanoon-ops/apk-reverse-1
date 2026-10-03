local SeasonBuilderCheckConditionMessage = BaseClass("SeasonBuilderCheckConditionMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t == nil then
    return
  end
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  if t.serverId ~= LuaEntry.Player:GetSourceServerId() then
    UIUtil.ShowTipsId(458585)
  end
  EventManager:GetInstance():Broadcast(EventId.SeasonBuilderCheckCondition, t)
end

local function GetTestData(self)
  local data = {}
  data.hasAllianceBuilder = DataCenter.SeasonFarmerManager:IsActive()
  if data.hasAllianceBuilder then
    return data
  end
  local conditionArr = {
    {
      index = 0,
      type = 1,
      result = true,
      currentNum = 0,
      configNum = 1
    },
    {
      index = 1,
      type = 2,
      result = true,
      currentNum = 6,
      configNum = 5
    },
    {
      index = 2,
      type = 3,
      result = true,
      currentNum = 0,
      configNum = 10
    },
    {
      index = 3,
      type = 4,
      result = true,
      currentNum = 1,
      configNum = 1
    },
    {
      index = 4,
      type = 4,
      result = true,
      currentNum = 1,
      configNum = 1
    }
  }
  data.conditionArr = conditionArr
  data.serverId = LuaEntry.Player.serverId
  data.totalNum = math.random(0, 20)
  return data
end

SeasonBuilderCheckConditionMessage.OnCreate = OnCreate
SeasonBuilderCheckConditionMessage.HandleMessage = HandleMessage
SeasonBuilderCheckConditionMessage.GetTestData = GetTestData
return SeasonBuilderCheckConditionMessage
