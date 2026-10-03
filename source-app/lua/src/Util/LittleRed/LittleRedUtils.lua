local LittleRed = require("Util.LittleRed.LittleRed")
local LittleRedUtils = {}
LittleRedUtils.roots = {}

function LittleRedUtils.Get(name, parent)
  if not name then
    return
  end
  local red
  if parent then
    red = parent:GetChild(name)
    if red then
      return red
    end
    red = LittleRed.New(name, parent)
    return red, true
  else
    red = LittleRedUtils.roots[name]
    if red then
      return red
    end
    red = LittleRed.New(name, nil)
    LittleRedUtils.roots[name] = red
    return red, true
  end
end

function LittleRedUtils.SetCount(rootName, childName, count, quiet)
  if not rootName then
    return false
  end
  local red = LittleRedUtils.roots[rootName]
  if not red then
    return false
  end
  return red:SetCount(childName, count, quiet)
end

function LittleRedUtils.GetCount(rootName, childName)
  if not rootName then
    return 0
  end
  local red = LittleRedUtils.roots[rootName]
  return red and red:GetCount(childName) or 0
end

function LittleRedUtils.AddListener(rootName, childName, handle, callback)
  if not rootName then
    return
  end
  local red = LittleRedUtils.roots[rootName]
  if not red then
    return
  end
  red:AddListener(childName, handle, callback)
end

function LittleRedUtils.ClearListener(rootName, handle)
  if not rootName then
    return
  end
  local red = LittleRedUtils.roots[rootName]
  if not red then
    return
  end
  red:RemoveListener(handle)
end

function LittleRedUtils.Description()
  local sb = StringBuilder.New()
  sb:AppendFormatLine("\231\186\162\231\130\185root\231\154\132\230\149\176\233\135\143\228\184\186:%s", table.count(LittleRedUtils.roots))
  sb:AppendLine("\230\159\165\231\156\139\230\137\128\230\156\137\231\186\162\231\130\185\231\138\182\230\128\129")
  for k, v in pairs(LittleRedUtils.roots) do
    sb:AppendLine(v:Description())
  end
  return sb:ToString()
end

function LittleRedUtils.Clear(rootName)
  if not rootName then
    return
  end
  LittleRedUtils.roots[rootName] = nil
end

function LittleRedUtils.ClearAll()
  LittleRedUtils.roots = {}
end

return ConstClass("LittleRedUtils", LittleRedUtils)
