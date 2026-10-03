local CSBIManager = CS.RiverBISDK.BIManager
local BIManager = {}
local rapidjson = require("rapidjson")

function BIManager.SendToBI(eventName, tbl)
  if CSBIManager.SendToBIFromLua ~= nil then
    local value = tbl and rapidjson.encode(tbl) or ""
    CSBIManager.SendToBIFromLua(eventName, value)
  end
end

return BIManager
