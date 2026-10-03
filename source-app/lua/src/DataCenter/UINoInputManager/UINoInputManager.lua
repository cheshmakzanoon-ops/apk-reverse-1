local UINoInputManager = BaseClass("UINoInputManager")

local function __init(self)
  self:AddListener()
  self.uINoInputType = UINoInputType.Close
end

local function __delete(self)
  self:RemoveListener()
  self.uINoInputType = nil
end

local function Startup()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.UINoInput, self.UINoInputSignal)
  EventManager:GetInstance():AddListener(EventId.SetMovingUI, self.UIMovingSignal)
  EventManager:GetInstance():AddListener(EventId.SetCrossMovingUI, self.UICrossMovingSignal)
  EventManager:GetInstance():AddListener(EventId.ScreenLoadingUI, self.UILoadingSignal)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.UINoInput, self.UINoInputSignal)
  EventManager:GetInstance():RemoveListener(EventId.SetMovingUI, self.UIMovingSignal)
  EventManager:GetInstance():RemoveListener(EventId.SetCrossMovingUI, self.UICrossMovingSignal)
  EventManager:GetInstance():RemoveListener(EventId.ScreenLoadingUI, self.UILoadingSignal)
end

local function UINoInputSignal(uINoInputType)
  DataCenter.UINoInputManager.uINoInputType = uINoInputType
  if uINoInputType == UINoInputType.ShowNoScene then
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISceneNoInput) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UISceneNoInput, {anim = true, playEffect = false})
    else
      DataCenter.UINoInputManager:CloseWindow(UIWindowNames.UINoInput)
    end
  elseif uINoInputType == UINoInputType.ShowNoUI then
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UINoInput) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UINoInput, {anim = true, playEffect = false})
    end
  elseif uINoInputType == UINoInputType.Close then
    DataCenter.UINoInputManager:CloseWindow(UIWindowNames.UINoInput)
    DataCenter.UINoInputManager:CloseWindow(UIWindowNames.UISceneNoInput)
  end
end

local function UIMovingSignal(uiMovingType)
  if uiMovingType == UIMovingType.Open then
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIMoving) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIMoving, {anim = true, playEffect = false})
    end
  elseif uiMovingType == UIMovingType.Close then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMoving, {
      anim = false,
      playEffect = false,
      UIMainAnim = UIMainAnimType.ChangeAllShow
    })
  end
end

local function UICrossMovingSignal(serverId)
  if toInt(serverId) > 0 and not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIMoving) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIMoving, {anim = true, playEffect = false}, serverId)
  end
end

local function UILoadingSignal(openText)
  if openText then
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIScreenLoading) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIScreenLoading, {anim = true, playEffect = false}, openText)
    end
  else
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIScreenLoading, {
      anim = false,
      playEffect = false,
      UIMainAnim = UIMainAnimType.ChangeAllShow
    })
  end
end

local function CloseWindow(self, windowName)
  if self.uINoInputType == UINoInputType.ShowNoScene and windowName == UIWindowNames.UISceneNoInput then
    return
  end
  UIManager:GetInstance():DestroyWindow(windowName)
end

UINoInputManager.__init = __init
UINoInputManager.__delete = __delete
UINoInputManager.Startup = Startup
UINoInputManager.AddListener = AddListener
UINoInputManager.RemoveListener = RemoveListener
UINoInputManager.UINoInputSignal = UINoInputSignal
UINoInputManager.CloseWindow = CloseWindow
UINoInputManager.UIMovingSignal = UIMovingSignal
UINoInputManager.UICrossMovingSignal = UICrossMovingSignal
UINoInputManager.UILoadingSignal = UILoadingSignal
return UINoInputManager
