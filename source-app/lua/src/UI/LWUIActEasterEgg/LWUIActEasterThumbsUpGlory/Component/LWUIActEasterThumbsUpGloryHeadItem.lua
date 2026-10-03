local LWUIActEasterThumbsUpGloryHeadItem = BaseClass("LWUIActEasterThumbsUpGloryHeadItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local u_i_player_head_path = "UIPlayerHead"

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
  self.headItem = self:AddComponent(UICommonHead, u_i_player_head_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function LWUIActEasterThumbsUpGloryHeadItem:ReInit(data)
  if not data then
    return
  end
  self.headItem:SetData(data.uid, data.pic, data.picVer, nil, LuaEntry.Player:GetHeadBgImg())
  self.headItem:ParseHeadInfo(data)
end

LWUIActEasterThumbsUpGloryHeadItem.OnCreate = OnCreate
LWUIActEasterThumbsUpGloryHeadItem.OnDestroy = OnDestroy
LWUIActEasterThumbsUpGloryHeadItem.OnEnable = OnEnable
LWUIActEasterThumbsUpGloryHeadItem.OnDisable = OnDisable
LWUIActEasterThumbsUpGloryHeadItem.ComponentDefine = ComponentDefine
LWUIActEasterThumbsUpGloryHeadItem.ComponentDestroy = ComponentDestroy
LWUIActEasterThumbsUpGloryHeadItem.DataDefine = DataDefine
LWUIActEasterThumbsUpGloryHeadItem.DataDestroy = DataDestroy
LWUIActEasterThumbsUpGloryHeadItem.OnAddListener = OnAddListener
LWUIActEasterThumbsUpGloryHeadItem.OnRemoveListener = OnRemoveListener
return LWUIActEasterThumbsUpGloryHeadItem
