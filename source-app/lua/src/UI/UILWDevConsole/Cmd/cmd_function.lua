local cmd = {}

function cmd.Execute(arr)
  local tag = arr[2]
  if tag ~= nil then
    local id = tonumber(tag)
    local on = DataCenter.FunctionOnManager:IsServerSwitchOn(id)
    return "ServerSwitch " .. id .. " is " .. (on and "on" or "off")
  end
  local ret = DataCenter.FunctionOnManager:DumpServerSwitchOn()
  return ret
end

function cmd.Help()
  return "function dump"
end

return cmd
