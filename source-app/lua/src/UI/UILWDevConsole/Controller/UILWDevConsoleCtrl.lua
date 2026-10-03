local UILWDevConsoleCtrl = BaseClass("UILWDevConsoleCtrl", UIBaseCtrl)

function UILWDevConsoleCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.UILWDevConsole)
end

function UILWDevConsoleCtrl:ExecuteCommand(input)
  local arr = string.split(input, " ")
  if arr == nil or #arr == 0 then
    return
  end
  local result
  local rst, cmd = pcall(require, "UI.UILWDevConsole.Cmd.cmd_" .. arr[1])
  if not rst or cmd == nil then
    result = "No such command: " .. arr[1]
  elseif arr[1] == "exe" then
    result = cmd.Execute(input)
  else
    result = cmd.Execute(arr)
  end
  if result == nil then
    self:CloseSelf()
  else
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UILWDevConsole)
    window.View:Print2Output(result)
  end
end

return UILWDevConsoleCtrl
