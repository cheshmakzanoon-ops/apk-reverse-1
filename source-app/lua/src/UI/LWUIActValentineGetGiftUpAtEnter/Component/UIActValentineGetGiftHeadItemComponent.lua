local UIActValentineGetGiftHeadItemComponent = BaseClass("UIActValentineGetGiftHeadItemComponent", UIBaseContainer)
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

function UIActValentineGetGiftHeadItemComponent:ReInit(data)
  if not data then
    return
  end
  self.headItem:ParseHeadInfo(data)
end

UIActValentineGetGiftHeadItemComponent.OnCreate = OnCreate
UIActValentineGetGiftHeadItemComponent.OnDestroy = OnDestroy
UIActValentineGetGiftHeadItemComponent.OnEnable = OnEnable
UIActValentineGetGiftHeadItemComponent.OnDisable = OnDisable
UIActValentineGetGiftHeadItemComponent.ComponentDefine = ComponentDefine
UIActValentineGetGiftHeadItemComponent.ComponentDestroy = ComponentDestroy
UIActValentineGetGiftHeadItemComponent.DataDefine = DataDefine
UIActValentineGetGiftHeadItemComponent.DataDestroy = DataDestroy
UIActValentineGetGiftHeadItemComponent.OnAddListener = OnAddListener
UIActValentineGetGiftHeadItemComponent.OnRemoveListener = OnRemoveListener
return UIActValentineGetGiftHeadItemComponent
