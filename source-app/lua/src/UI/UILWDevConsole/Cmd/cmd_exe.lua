local cmd = {}

function cmd.Execute(input)
  local command, code = input:match("^(%S+)%s+(.*)$")
  local fun2 = load(code)
  local ok, msg = xpcall(fun2, debug.traceback)
  if not ok then
    Logger.LogError(msg)
  end
  local fun = load("print('cmd_exe execute lua code!!!')")
  pcall(fun)
end

function cmd.Help()
  local content = ""
  content = content .. "pve exe\n"
  return content
end

return cmd
