local FoodBuildBubbleTip = BaseClass("FoodBuildBubbleTip")
local FoodBuildBubbleCell = require("UI.FoodBuildBubbleTip.View.FoodBuildBubbleCell")
local ResourceManager = CS.GameEntry.Resource
local content_path = "Content"
local tip = ""
local PositionDeltaHeight = Vector3.New(0, 1.2, 0)

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
end

local function ComponentDefine(self)
  if not self.defend then
    if self.param.model == UIAssets.FoodStateIcon then
      self.content = self.transform:Find(content_path).gameObject
    end
    self.defend = true
  end
end

local function ComponentDestroy(self)
  self.gameObject = nil
  self.transform = nil
  self.cell = nil
end

local function DataDefine(self)
  self.param = nil
  self.curPosition = nil
  self.index = nil
  self.defend = nil
  self.list = {}
end

local function DataDestroy(self)
  self.param = nil
  self.curPosition = nil
  self.index = nil
  self.defend = nil
  self.list = nil
end

local function ReInit(self, param)
  self.param = param
  self:ComponentDefine()
  self:InitData()
end

local function InitData(self)
  if self.param.pos ~= nil then
    self:UpdatePosition(self.param.pos)
  end
  local list = self.param.itemList
  if list ~= nil then
    DataCenter.BuildBubbleManager:DeleteBuildBubbleChild(self.param.uuid)
    local poxX = 0
    for i = 1, table.length(list) do
      local request = ResourceManager:InstantiateAsync(UIAssets.FoodStateIconCell)
      request:completed("+", function()
        if request.isError then
          return
        end
        request.gameObject:SetActive(true)
        request.gameObject.transform:SetParent(self.content.transform)
        request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        request.gameObject.name = "FoodStateIconCell" .. tostring(i)
        request.gameObject.transform.position = Vector3.New(0, 0, 0)
        local param = {}
        param.pos = Vector3.New(poxX, 0.5, 0)
        param.modelHeight = self.param.modelHeight
        param.iconName = list[i].iconName
        param.iconScale = list[i].iconScale
        param.count = list[i].count
        param.callBack = list[i].callBack
        param.itemId = list[i].itemId
        param.uuid = list[i].uuid
        param.buildBubbleType = list[i].buildBubbleType
        local tempCell = FoodBuildBubbleCell.New()
        tempCell:OnCreate(request)
        self.list[i] = tempCell
        self.list[i]:ReInit(param)
        poxX = poxX + 1.5
      end)
    end
  end
end

local function UpdatePosition(self, index)
  if self.index ~= index then
    self.index = index
    local worldPos = BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + PositionDeltaHeight
    self:SetPosition(worldPos)
  end
end

local function SetPosition(self, value)
  self.transform.position = value
end

local function GetBubblePosition(self)
  if self.transform ~= nil then
    return self.transform.position
  end
  return ResetPosition
end

FoodBuildBubbleTip.OnCreate = OnCreate
FoodBuildBubbleTip.OnDestroy = OnDestroy
FoodBuildBubbleTip.ComponentDefine = ComponentDefine
FoodBuildBubbleTip.ComponentDestroy = ComponentDestroy
FoodBuildBubbleTip.DataDefine = DataDefine
FoodBuildBubbleTip.DataDestroy = DataDestroy
FoodBuildBubbleTip.ReInit = ReInit
FoodBuildBubbleTip.InitData = InitData
FoodBuildBubbleTip.UpdatePosition = UpdatePosition
FoodBuildBubbleTip.SetPosition = SetPosition
FoodBuildBubbleTip.GetBubblePosition = GetBubblePosition
return FoodBuildBubbleTip
