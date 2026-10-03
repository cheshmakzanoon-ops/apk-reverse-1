console = {
  log = function(format, ...)
    print(format, ...)
  end
}
local CONF = {
  [CS.UnityEngine.KeyCode.F8:GetHashCode()] = "Assets/Main/LuaScripts/Common/Debug/wbw.lua",
  [CS.UnityEngine.KeyCode.F9:GetHashCode()] = "Assets/Main/LuaScripts/Common/Debug/reloadModule.lua"
}

function onKeyBoard(keyCode)
  if CS.CommonUtils.IsDebug() then
    local path = CONF[keyCode]
    if path then
      dofile(path)
    end
  end
end
