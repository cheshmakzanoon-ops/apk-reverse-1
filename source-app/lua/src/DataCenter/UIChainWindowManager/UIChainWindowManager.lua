local UIChainWindowManager = BaseClass("UIChainWindowManager")

local function __init(self)
  self.chainList = nil
  self.onChainFinished = nil
  self.chainCurrent = nil
  self.chainReplace = true
end

local function __delete(self)
  self.chainList = nil
  self.onChainFinished = nil
  self.chainCurrent = nil
  self.chainReplace = nil
  self:RemoveListeners()
end

local function AddListeners(self)
  if not self.addListeners then
    self.addListeners = true
    EventManager:GetInstance():AddListenerWithSelf(EventId.CloseUI, self.OnWindowClosed, self)
  end
end

local function RemoveListeners(self)
  if self.addListeners then
    self.addListeners = false
    EventManager:GetInstance():RemoveListener(EventId.CloseUI, self.OnWindowClosed)
  end
end

local function OpenWindowsChain(self, windowList, onChainFinished, options)
  if not windowList or #windowList == 0 then
    if onChainFinished then
      onChainFinished()
    end
    return
  end
  self:AddListeners()
  options = options or {}
  local replace = options.replace
  if self.chainList and replace then
    self.chainList = nil
    self.onChainFinished = nil
    self.chainCurrent = nil
  end
  if self.chainList and not replace then
    for i, v in ipairs(windowList) do
      table.insert(self.chainList, v)
    end
    return
  end
  self.chainList = windowList
  self.onChainFinished = onChainFinished
  self.chainReplace = replace
  self:OpenNext()
end

local function OpenNext(self)
  if not self.chainList or #self.chainList == 0 then
    self:InternalFinishChain()
    return
  end
  local entry = table.remove(self.chainList, 1)
  local isLastWindow = #self.chainList == 0
  self.chainCurrent = entry[1]
  UIManager:GetInstance():OpenWindow(SafeUnpack(entry))
end

local function InternalFinishChain(self)
  self:RemoveListeners()
  self.chainList = nil
  self.chainCurrent = nil
  if self.onChainFinished then
    self.onChainFinished()
    self.onChainFinished = nil
  end
end

local function InterruptChain(self)
  self:InternalFinishChain()
end

local function OnWindowClosed(self, ui_name)
  if not self.chainList then
    return
  end
  if self.chainCurrent == ui_name then
    self.chainCurrent = nil
    self:OpenNext()
  end
end

UIChainWindowManager.__init = __init
UIChainWindowManager.__delete = __delete
UIChainWindowManager.AddListeners = AddListeners
UIChainWindowManager.RemoveListeners = RemoveListeners
UIChainWindowManager.OpenWindowsChain = OpenWindowsChain
UIChainWindowManager.OpenNext = OpenNext
UIChainWindowManager.InterruptChain = InterruptChain
UIChainWindowManager.OnWindowClosed = OnWindowClosed
UIChainWindowManager.InternalFinishChain = InternalFinishChain
return UIChainWindowManager
