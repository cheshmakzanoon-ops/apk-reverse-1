local UIKonbiniBoard = BaseClass("UIKonbiniBoard", UIBaseContainer)
local base = UIBaseContainer
local bg_path = "Bg"
local icon_path = "Bg/Icon"
local count_path = "Bg/Count"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.bg_go = self:AddComponent(UIBaseContainer, bg_path)
  self.icon_image = self:AddComponent(UIImage, icon_path)
  self.count_text = self:AddComponent(UIText, count_path)
end

local function ComponentDestroy(self)
  self.bg_go = nil
  self.icon_image = nil
  self.count_text = nil
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

local function SetData(self, data, icon)
  self.icon_image:LoadSprite(icon)
  self.count_text:SetText("+" .. string.GetFormattedSeperatorNum(data.count))
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bg_go.rectTransform)
end

UIKonbiniBoard.OnCreate = OnCreate
UIKonbiniBoard.OnDestroy = OnDestroy
UIKonbiniBoard.OnEnable = OnEnable
UIKonbiniBoard.OnDisable = OnDisable
UIKonbiniBoard.ComponentDefine = ComponentDefine
UIKonbiniBoard.ComponentDestroy = ComponentDestroy
UIKonbiniBoard.DataDefine = DataDefine
UIKonbiniBoard.DataDestroy = DataDestroy
UIKonbiniBoard.OnAddListener = OnAddListener
UIKonbiniBoard.OnRemoveListener = OnRemoveListener
UIKonbiniBoard.State = State
UIKonbiniBoard.SetData = SetData
return UIKonbiniBoard
