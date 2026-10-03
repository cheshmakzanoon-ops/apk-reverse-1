RedPointGroup = require("RedPoint.Core.RedPointGroup")
RedPointNode = require("RedPoint.Core.RedPointNode")
local definePath = {
  "RedPoint.Define.RedDef_Season"
}
local redDef, redRequire = {}, {}
for _, path in ipairs(definePath) do
  local value = require(path)
  local r, d = value and value.RedRequire, value and value.RedDef
  if r then
    for k, v in pairs(r) do
      redRequire[k] = v
    end
  end
  if d then
    for k, v in pairs(d) do
      if redDef[k] ~= nil then
        Logger.LogError(string.format("RedDef\229\174\154\228\185\137\229\134\178\231\170\129\239\188\140key=%s,path=%s", k, path))
      else
        redDef[k] = v
      end
    end
  end
end
RedDef = ConstClass("RedDef", redDef)
RedRequire = ConstClass("RedRequire", redRequire)
return RedDef
