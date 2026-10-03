local SeasonConvertToFarmerMessage = BaseClass("SeasonConvertToFarmerMessage", SFSBaseMessage)
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
    local para2 = t.errorPara2
    if para2 == nil then
      UIUtil.ShowTipsId(t.errorCode)
    elseif type(para2) == "table" and 0 < #para2 then
      UIUtil.ShowTips(CS.GameEntry.Localization:GetString(t.errorCode, table.unpack(para2)))
    end
    return
  end
end

local function GetTestData(self)
  if not LuaEntry.Player.allianceId then
    return
  end
  local data = {}
  data.allianceId = LuaEntry.Player.allianceId
  data.hasAllianceBuilder = true
  SFSNetwork.HandleMessage("push.alliance.builder.change", data)
  return data
end

SeasonConvertToFarmerMessage.OnCreate = OnCreate
SeasonConvertToFarmerMessage.HandleMessage = HandleMessage
SeasonConvertToFarmerMessage.GetTestData = GetTestData
return SeasonConvertToFarmerMessage
