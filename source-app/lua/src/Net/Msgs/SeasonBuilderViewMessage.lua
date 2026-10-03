local SeasonBuilderViewMessage = BaseClass("SeasonBuilderViewMessage", SFSBaseMessage)
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
  DataCenter.SeasonFarmerManager:OnBuilderStateChange(t)
end

local function GetTestData(self)
  local data = {}
  data.hasAllianceBuilder = DataCenter.SeasonFarmerManager:IsActive()
  if data.hasAllianceBuilder then
    return data
  end
  local builderExpInfo = {}
  data.builderExpInfo = builderExpInfo
  builderExpInfo.allianceId = LuaEntry.Player.allianceId
  builderExpInfo.level = math.random(1, 10)
  builderExpInfo.totalExp = 10000000000
  builderExpInfo.curExp = math.random(999999, 9999999999)
  return data
end

SeasonBuilderViewMessage.OnCreate = OnCreate
SeasonBuilderViewMessage.HandleMessage = HandleMessage
SeasonBuilderViewMessage.GetTestData = GetTestData
return SeasonBuilderViewMessage
