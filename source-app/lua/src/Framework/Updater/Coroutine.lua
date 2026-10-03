local action_map = {}
local action_pool = {}
local yield_map = {}
local yield_pool = {}
local co_pool = {}

local function __RecycleCoroutine(co)
  if not coroutine.status(co) == "suspended" then
    error("Try to recycle coroutine not suspended : " .. coroutine.status(co))
  end
  table.insert(co_pool, co)
end

local function __Coroutine(func, ...)
  local args = SafePack(...)
  while func do
    local ret = SafePack(func(SafeUnpack(args)))
    __RecycleCoroutine(coroutine.running())
    args = SafePack(coroutine.yield(SafeUnpack(ret)))
    func = args[1]
    table.remove(args, 1)
  end
end

local function __GetCoroutine()
  local co
  if table.length(co_pool) > 0 then
    co = table.remove(co_pool)
  else
    co = coroutine.create(__Coroutine)
  end
  return co
end

local function __RecycleAction(action)
  action.co = false
  action.timer = false
  action.func = false
  action.args = false
  action.result = false
  table.insert(action_pool, action)
end

local function __GetAction(co, timer, func, args, result)
  local action
  if table.length(action_pool) > 0 then
    action = table.remove(action_pool)
  else
    action = {
      false,
      false,
      false,
      false,
      false
    }
  end
  action.co = co and co or false
  action.timer = timer and timer or false
  action.func = func and func or false
  action.args = args and args or false
  action.result = result and result or false
  return action
end

local function __PResume(co, func, ...)
  local resume_ret
  if func ~= nil then
    resume_ret = SafePack(coroutine.resume(co, func, ...))
  else
    resume_ret = SafePack(coroutine.resume(co, ...))
  end
  local flag, msg = resume_ret[1], resume_ret[2]
  if not flag then
    Logger.LogError(msg .. "\n" .. debug.traceback(co))
  elseif 1 < resume_ret.n then
    table.remove(resume_ret, 1)
  else
    resume_ret = nil
  end
  return flag, resume_ret
end

local function start(func, ...)
  local co = __GetCoroutine()
  __PResume(co, func, ...)
  return co
end

local function yieldstart(func, callback, ...)
  local co = coroutine.running() or error("coroutine.yieldstart must be run in coroutine")
  local map
  if table.length(yield_pool) > 0 then
    map = table.remove(yield_pool)
    map.parent = co
    map.callback = callback
    map.waiting = false
    map.over = false
  else
    map = {
      parent = co,
      callback = callback,
      waiting = false,
      over = false
    }
  end
  local child = __GetCoroutine()
  yield_map[child] = map
  local flag, resume_ret = __PResume(child, func, ...)
  if not flag then
    table.insert(yield_pool, map)
    yield_map[child] = nil
    return nil
  elseif map.over then
    table.insert(yield_pool, map)
    yield_map[child] = nil
    if resume_ret == nil then
      return nil
    else
      return SafeUnpack(resume_ret)
    end
  else
    map.waiting = true
    local yield_ret = SafePack(coroutine.yield())
    table.insert(yield_pool, map)
    yield_map[child] = nil
    return SafeUnpack(yield_ret)
  end
end

local function yieldreturn(...)
  local co = coroutine.running() or error("coroutine.yieldreturn must be run in coroutine")
  local map = yield_map[co]
  local parent = map.parent
  if not map or not parent then
    return
  end
  local callback = map.callback
  assert(callback ~= nil, "If you don't need callback, use normal function call instead!!!")
  callback(co, ...)
  return coroutine.waitforframes(1)
end

local function yieldcallback(co, ...)
  assert(co ~= nil and type(co) == "thread")
  local map = yield_map[co]
  if not map or not map.parent then
    return
  end
  local callback = map.callback
  assert(callback ~= nil, "If you don't need callback, use normal function call instead!!!")
  callback(co, ...)
end

local function yieldbreak(...)
  local co = coroutine.running() or error("coroutine.yieldbreak must be run in coroutine")
  local map = yield_map[co]
  if not map then
    return ...
  end
  map.over = true
  assert(map.parent ~= nil, "What's the fuck!!!")
  if not map.waiting then
    return ...
  else
    __PResume(map.parent, nil, ...)
  end
end

local function __Action(action, abort, ...)
  assert(action.timer)
  if not action.func then
    abort = true
  end
  if not abort and action.func then
    if action.args and action.args.n > 0 then
      abort = action.func(SafeUnpack(action.args)) == action.result
    else
      abort = action.func() == action.result
    end
  end
  if abort then
    action.timer:Stop()
    action_map[action.co] = nil
    __PResume(action.co, ...)
    __RecycleAction(action)
  end
end

local function waitforframes(frames)
  assert(type(frames) == "number" and 1 <= frames and math.floor(frames) == frames)
  local co = coroutine.running() or error("coroutine.waitforframes must be run in coroutine")
  local timer = TimerManager:GetInstance():GetCoTimer()
  local action = __GetAction(co, timer)
  timer:Init(frames, __Action, action, true, true)
  timer:Start()
  action_map[co] = action
  return coroutine.yield()
end

local function waitforseconds(seconds)
  assert(type(seconds) == "number" and 0 <= seconds)
  local co = coroutine.running() or error("coroutine.waitforsenconds must be run in coroutine")
  local timer = TimerManager:GetInstance():GetCoTimer()
  local action = __GetAction(co, timer)
  timer:Init(seconds, __Action, action, true)
  timer:Start()
  action_map[co] = action
  return coroutine.yield()
end

local function __AsyncOpCheck(co, async_operation, callback)
  if callback ~= nil then
    callback(co, async_operation.progress)
  end
  return async_operation.isDone
end

local function waitforasyncop(async_operation, callback)
  assert(async_operation)
  local co = coroutine.running() or error("coroutine.waitforasyncop must be run in coroutine")
  local timer = TimerManager:GetInstance():GetCoTimer()
  local action = __GetAction(co, timer, __AsyncOpCheck, SafePack(co, async_operation, callback), true)
  timer:Init(1, __Action, action, false, true)
  timer:Start()
  action_map[co] = action
  return coroutine.yield()
end

local function waituntil(func, ...)
  assert(func)
  local co = coroutine.running() or error("coroutine.waituntil must be run in coroutine")
  local timer = TimerManager:GetInstance():GetCoTimer()
  local action = __GetAction(co, timer, func, SafePack(...), true)
  timer:Init(1, __Action, action, false, true)
  timer:Start()
  action_map[co] = action
  return coroutine.yield()
end

local function waitwhile(func, ...)
  assert(func)
  local co = coroutine.running() or error("coroutine.waitwhile must be run in coroutine")
  local timer = TimerManager:GetInstance():GetCoTimer()
  local action = __GetAction(co, timer, func, SafePack(...), false)
  timer:Init(1, __Action, action, false, true)
  timer:Start()
  action_map[co] = action
  return coroutine.yield()
end

local function waitforendofframe()
  local co = coroutine.running() or error("coroutine.waitforendofframe must be run in coroutine")
  local timer = TimerManager:GetInstance():GetCoLateTimer()
  local action = __GetAction(co, timer)
  timer:Init(0, __Action, action, true, true)
  timer:Start()
  action_map[co] = action
  return coroutine.yield()
end

local function stopwaiting(co, ...)
  local action = action_map[co]
  if action then
    __Action(action, true, ...)
  end
end

coroutine.start = start
coroutine.yieldstart = yieldstart
coroutine.yieldreturn = yieldreturn
coroutine.yieldcallback = yieldcallback
coroutine.yieldbreak = yieldbreak
coroutine.waitforframes = waitforframes
coroutine.waitforseconds = waitforseconds
coroutine.waitforasyncop = waitforasyncop
coroutine.waituntil = waituntil
coroutine.waitwhile = waitwhile
coroutine.waitforendofframe = waitforendofframe
coroutine.stopwaiting = stopwaiting
if Config.Debug then
  return {
    action_map = action_map,
    action_pool = action_pool,
    yield_map = yield_map,
    yield_pool = yield_pool,
    co_pool = co_pool
  }
end
