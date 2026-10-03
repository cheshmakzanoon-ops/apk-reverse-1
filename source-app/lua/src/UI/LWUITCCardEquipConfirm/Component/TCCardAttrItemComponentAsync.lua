local TCCardAttrItemComponentAsync = BaseClass("TCCardAttrItemComponentAsync", UIAsyncDataContainer)
local base = UIAsyncDataContainer
local UILWScienceDetailDesc = require("UI.UILWScience.UILWScienceDetail.Component.UILWScienceDetailDesc")
TCCardAttrItemComponentAsync.DataSchema = {"name", "value"}
TCCardAttrItemComponentAsync.PrefabPath = "Assets/Main/Prefabs/UI/UILWTC/Component/CardDetailItem/TCCardAttrItem.prefab"
local attri_name_text_path = "AttriNameText"
local value_path = "Value"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.effNameText = self:AddComponent(UILWScienceDetailDesc, attri_name_text_path)
  self.effValText = self:AddComponent(UIText, value_path)
end

local function ComponentDestroy(self)
  self.effNameText = nil
  self.effValText = nil
end

function TCCardAttrItemComponentAsync:UpdateData()
  self.effNameText:SetText(self.viewData.name or "")
  self.effValText:SetText(self.viewData.value or "")
end

TCCardAttrItemComponentAsync.OnCreate = OnCreate
TCCardAttrItemComponentAsync.OnDestroy = OnDestroy
TCCardAttrItemComponentAsync.ComponentDestroy = ComponentDestroy
TCCardAttrItemComponentAsync.ComponentDefine = ComponentDefine
return TCCardAttrItemComponentAsync
