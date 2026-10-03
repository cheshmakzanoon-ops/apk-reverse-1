local FunctionOnIconData = BaseClass("FunctionOnIconData")

local function __init(self)
  self.id = ""
  self.name = ""
  self.icon = ""
  self:AddListener()
end

local function __delete(self)
  self.id = nil
  self.name = nil
  self.icon = nil
  self:RemoveListener()
end

local function AddListener(self)
end

local function RemoveListener(self)
end

local function InitData(self, id, name, icon)
  self.id = id
  self.name = name
  self.icon = icon
end

FunctionOnIconData.__init = __init
FunctionOnIconData.__delete = __delete
FunctionOnIconData.AddListener = AddListener
FunctionOnIconData.RemoveListener = RemoveListener
FunctionOnIconData.InitData = InitData
return FunctionOnIconData
