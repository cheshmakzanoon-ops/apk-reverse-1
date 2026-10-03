local Notifier = {}
local listeners = {}
local lookupTbl = {}
local __AUTO_INC_ID = 1

function Notifier.AddListener(p_noti, p_callback, p_this, p_idBook)
  local callbacks = listeners[p_noti]
  if callbacks == nil then
    callbacks = {}
  end
  table.insert(callbacks, {
    id = __AUTO_INC_ID,
    noti = p_noti,
    func = p_callback,
    owner = p_this
  })
  listeners[p_noti] = callbacks
  lookupTbl[__AUTO_INC_ID] = callbacks[#callbacks]
  if p_idBook ~= nil then
    table.insert(p_idBook, __AUTO_INC_ID)
  end
  __AUTO_INC_ID = __AUTO_INC_ID + 1
  return __AUTO_INC_ID - 1
end

function Notifier.RemoveListener(p_noti, p_callback, p_this)
  local callbacks = listeners[p_noti]
  if callbacks == nil then
    return
  end
  for idx, callback in ipairs(callbacks) do
    if callback.func == p_callback and callback.owner == p_this then
      lookupTbl[callback.id] = nil
      table.remove(callbacks, idx)
      break
    end
  end
  listeners[p_noti] = callbacks
end

function Notifier.RemoveListenerByID(p_ID)
  if lookupTbl[p_ID] == nil then
    return
  end
  Notifier.RemoveListener(lookupTbl[p_ID].noti, lookupTbl[p_ID].func, lookupTbl[p_ID].owner)
end

function Notifier.RemoveListenerByBook(p_idBook)
  for _, id in ipairs(p_idBook) do
    Notifier.RemoveListenerByID(id)
  end
end

function Notifier.Dispatch(notiName, ...)
  local callbacks = listeners[notiName]
  if callbacks == nil then
    return
  end
  local param = {
    ...
  }
  for _, callback in ipairs(callbacks) do
    if callback.owner == nil then
      callback.func(param[1], param[2], param[3], param[4], param[5])
    else
      callback.func(callback.owner, param[1], param[2], param[3], param[4], param[5])
    end
  end
end

return Notifier
