local GMHappyWatcher = BaseClass("GMHappyWatcher")

function GMHappyWatcher:__init()
  self.happyKeys = 0
  self.happyGetters = {}
end

function GMHappyWatcher:__delete()
  self.happyKeys = 0
  self.happyGetters = {}
end

function GMHappyWatcher:AddHappy(getter)
  for k, v in pairs(self.happyGetters) do
    if v == getter then
      return
    end
  end
  local key = self.happyKeys
  self.happyKeys = self.happyKeys + 1
  self.happyGetters[key] = getter
  return key
end

function GMHappyWatcher:DelHappy(key)
  self.happyGetters[key] = nil
end

function GMHappyWatcher:GetHappyInfo()
  local sb
  for k, v in pairs(self.happyGetters) do
    if v then
      local info = v()
      if not string.IsNullOrEmpty(info) then
        sb = sb or StringBuilder.New()
        sb:AppendLineFormat(info)
      end
    end
  end
  if sb then
    return sb:ToString()
  end
  return nil
end

return GMHappyWatcher
