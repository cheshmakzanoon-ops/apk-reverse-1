local ProfilerUtil = {}
local LuaClientProfiler = CS.LuaClientProfiler
local LuaBeginSampleById = LuaClientProfiler.LuaBeginSampleById
local LuaBeginSampleByIdName = LuaClientProfiler.LuaBeginSampleByIdName
local LuaEndSample = LuaClientProfiler.LuaEndSample
local LuaBeginRuntimeSampleById = LuaClientProfiler.LuaBeginRuntimeSampleById
local LuaBeginRuntimeSampleByIdName = LuaClientProfiler.LuaBeginRuntimeSampleByIdName
local LuaEndRuntimeSample = LuaClientProfiler.LuaEndRuntimeSample

function ProfilerUtil.BeginSample(name)
end

function ProfilerUtil.EndSample()
end

function ProfilerUtil.BeginRuntimeSample(name)
end

function ProfilerUtil.EndRuntimeSample()
end

local _cache = {}
local _id_generator = 0
if CS.CommonUtils.IsDebug() then
  function ProfilerUtil.BeginSample(name)
    local id = _cache[name]
    
    if id then
      LuaBeginSampleById(id)
    else
      _id_generator = _id_generator + 1
      id = _id_generator
      _cache[name] = id
      LuaBeginSampleByIdName(id, name)
    end
  end
  
  function ProfilerUtil.EndSample()
    LuaEndSample()
  end
end

function ProfilerUtil.InitRuntimeSample()
  if LuaClientProfiler.LuaRuntimeSampleEnabled then
    function ProfilerUtil.BeginRuntimeSample(name)
      local id = _cache[name]
      
      if id then
        LuaBeginRuntimeSampleById(id)
      else
        _id_generator = _id_generator + 1
        id = _id_generator
        _cache[name] = id
        LuaBeginRuntimeSampleByIdName(id, name)
      end
    end
    
    function ProfilerUtil.EndRuntimeSample()
      LuaEndRuntimeSample()
    end
  end
end

return ProfilerUtil
