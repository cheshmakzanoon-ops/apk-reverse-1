local UIDebugChooseServerCtrl = BaseClass("UIDebugChooseServerCtrl", UIBaseCtrl)
local m_param = {}

local function CloseSelf(self)
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIDebugChooseServer)
  window.View:ClearItems()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDebugChooseServer)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function SetParam(self, param)
  m_param.OnComplete = param
end

local function GoContinue(self, ip, port, zone, uuid, connection_tyoe)
  if m_param.OnComplete ~= nil then
    m_param.OnComplete(tostring(ip), tonumber(port), tostring(zone), tostring(uuid), tonumber(connection_tyoe))
    m_param.OnComplete = nil
  end
  self:CloseSelf()
end

local function StartNewGame(self)
end

UIDebugChooseServerCtrl.CloseSelf = CloseSelf
UIDebugChooseServerCtrl.Close = Close
UIDebugChooseServerCtrl.SetParam = SetParam
UIDebugChooseServerCtrl.GoContinue = GoContinue
UIDebugChooseServerCtrl.StartNewGame = StartNewGame
return UIDebugChooseServerCtrl
