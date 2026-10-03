local base = UIBaseContainer
local GoldTreePrayPlayerItem = BaseClass("GoldTreePrayPlayerItem", base)
local head_path = "headRoot/UIPlayerHead"
local name_path = "name"

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
  self.head = self:AddComponent(UIBaseContainer, head_path)
  self.name = self:AddComponent(UIText, name_path)
  self.playerIcon = self:AddComponent(UICommonHead, head_path)
  self.playerIcon:SetEnableClickShowInfo(true, true)
end

local function ComponentDestroy(self)
  self.head = nil
  self.name = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function GoldTreePrayPlayerItem:SetData(data, index)
  self.name:SetText(string.format("[%s]%s", data.abbr, data.name))
  self.playerIcon:SetHeadAndFrame(data.uid, data.pic, data.picver, nil, data.headSkinId, data.headSkinET)
end

GoldTreePrayPlayerItem.OnCreate = OnCreate
GoldTreePrayPlayerItem.OnDestroy = OnDestroy
GoldTreePrayPlayerItem.OnEnable = OnEnable
GoldTreePrayPlayerItem.OnDisable = OnDisable
GoldTreePrayPlayerItem.ComponentDefine = ComponentDefine
GoldTreePrayPlayerItem.ComponentDestroy = ComponentDestroy
GoldTreePrayPlayerItem.DataDefine = DataDefine
GoldTreePrayPlayerItem.DataDestroy = DataDestroy
return GoldTreePrayPlayerItem
