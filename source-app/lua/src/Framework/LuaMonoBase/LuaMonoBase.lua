local LuaMonoBase = BaseClass("LuaMonoBase")
local util = require("xlua.util")

local function DoCoroutine()
  local t = util.cs_generator(function()
    local i = 0
    while true do
      coroutine.yield(CS.UnityEngine.WaitForSeconds(1))
      CS.UnityEngine.Debug.LogError("Next step_int")
      i = i + 1
      if 10 < i then
        return
      end
    end
  end)
  return t
end

function LuaMonoBase:Awake()
  local ttt
  self.Mono:StartCoroutine(DoCoroutine())
end

function LuaMonoBase:OnDestroy()
  local t
end

function LuaMonoBase:OnUpdate()
end

function LuaMonoBase:OnEnable()
  local t
end

function LuaMonoBase:OnDisable()
  local t
end

function LuaMonoBase:OnCollisionEnter(other)
end

function LuaMonoBase:OnCollisionExit(other)
end

function LuaMonoBase:OnGUI()
  local t
end

return LuaMonoBase.New()
