local DispatchTreasureItem = BaseClass("DispatchTreasureItem", UIBaseContainer)
local base = UIBaseContainer
local OwnBtn_path = ""
local OwnImg_path = ""
local NumText_path = "NumText"
local IdImg_path = "IdImg"
local Effect_path = "Effect"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function ComponentDefine(self)
  self.OwnBtn = self:AddComponent(UIButton, OwnBtn_path)
  self.OwnImg = self:AddComponent(UIImage, OwnImg_path)
  self.NumText = self:AddComponent(UITextMeshProUGUIEx, NumText_path)
  self.IdImg = self:AddComponent(UIImage, IdImg_path)
  self.Effect = self:AddComponent(UIBaseContainer, Effect_path)
  self.OwnBtn:SetOnClick(function()
    LWResourceLackUtil:GotoGoodsItemLack(self.itemId, 1)
  end)
end

local function DataDefine(self)
  self.itemId = 0
  self.num = 0
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDestroy(self)
  self.OwnBtn = nil
  self.OwnImg = nil
  self.NumText = nil
end

local function DataDestroy(self)
  self.itemId = nil
  self.num = nil
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function SetData(self, itemId, num)
  self.itemId = itemId
  self.num = num
  self.NumText:SetText("x" .. num)
  self.Effect:SetActive(num == 0)
  self.OwnImg:SetAlpha(0 < num and 0 or 1)
  if DataCenter.DigTreasureManager:IsActivityOpen() then
    self.IdImg:SetColor(Color.New(1, 1, 1, 1))
    return
  end
  if 0 < num then
    self.IdImg:SetColor(Color.New(0.4627450980392157, 0.23529411764705882, 0.09803921568627451, 0.6))
  else
    self.IdImg:SetColor(Color.New(0.09411764705882353, 0.050980392156862744, 0.38823529411764707, 0.6))
  end
end

DispatchTreasureItem.OnCreate = OnCreate
DispatchTreasureItem.OnEnable = OnEnable
DispatchTreasureItem.OnAddListener = OnAddListener
DispatchTreasureItem.OnRemoveListener = OnRemoveListener
DispatchTreasureItem.OnDisable = OnDisable
DispatchTreasureItem.ComponentDefine = ComponentDefine
DispatchTreasureItem.ComponentDestroy = ComponentDestroy
DispatchTreasureItem.ComponentDestroy = ComponentDestroy
DispatchTreasureItem.DataDefine = DataDefine
DispatchTreasureItem.DataDestroy = DataDestroy
DispatchTreasureItem.OnDestroy = OnDestroy
DispatchTreasureItem.SetData = SetData
return DispatchTreasureItem
