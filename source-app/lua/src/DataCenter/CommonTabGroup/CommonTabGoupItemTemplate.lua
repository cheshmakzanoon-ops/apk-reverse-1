local CommonTabGoupItemTemplate = BaseClass("CommonTabGoupItemTemplate")

local function __init(self)
  self.title = ""
  self.iconPath = ""
  self.eventId = ""
  self.minWidth = nil
  self.minHeight = nil
  self.unSelectIconPath = ""
  self:AddListener()
end

local function __delete(self)
  self.title = nil
  self.iconPath = nil
  self.eventId = nil
  self.minWidth = nil
  self.minHeight = nil
  self.unSelectIconPath = nil
  self:RemoveListener()
end

local function AddListener(self)
end

local function RemoveListener(self)
end

local function SetHandle(self, onClickHandler, refreshRedHandler)
  self.onClickHandler = onClickHandler
  self.refreshRedHandler = refreshRedHandler
end

CommonTabGoupItemTemplate.__init = __init
CommonTabGoupItemTemplate.__delete = __delete
CommonTabGoupItemTemplate.AddListener = AddListener
CommonTabGoupItemTemplate.RemoveListener = RemoveListener
CommonTabGoupItemTemplate.SetHandle = SetHandle
return CommonTabGoupItemTemplate
