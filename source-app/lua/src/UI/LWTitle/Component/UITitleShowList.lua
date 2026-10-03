local base = UIBaseContainer
local UITitleShowList = BaseClass("UITitleShowList", base)
local UITitleShowItem = require("UI.LWTitle.Component.UITitleShowItem")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
end

local function ComponentDestroy(self)
  self:Clear()
end

local function DataDefine(self)
  self.titleItems = {}
  self.items = {}
end

local function DataDestroy(self)
end

function UITitleShowList:Clear()
  if self.titleItems then
    self:RemoveComponents(UITitleShowItem)
    for k, v in pairs(self.titleItems) do
      if v then
        self:GameObjectDestroy(v)
      end
    end
    self.titleItems = nil
  end
end

function UITitleShowList:Refresh(titleDic, uid, scale)
  for position = 1, TitleShowCount do
    if not self.titleItems[position] then
      self.titleItems[position] = self:GameObjectInstantiateAsync(UIAssets.UITitleShowItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.transform)
        go.name = string.format("titleItem_%s", position)
        local cell = self:AddComponent(UITitleShowItem, go.name)
        cell:ReInit(titleDic and titleDic[position], uid, scale)
        self.items[position] = cell
      end)
    else
      local cell = self.items[position]
      if cell then
        cell:ReInit(titleDic and titleDic[position], uid, scale)
      end
    end
  end
end

UITitleShowList.OnCreate = OnCreate
UITitleShowList.OnDestroy = OnDestroy
UITitleShowList.OnEnable = OnEnable
UITitleShowList.OnDisable = OnDisable
UITitleShowList.ComponentDefine = ComponentDefine
UITitleShowList.ComponentDestroy = ComponentDestroy
UITitleShowList.DataDefine = DataDefine
UITitleShowList.DataDestroy = DataDestroy
return UITitleShowList
