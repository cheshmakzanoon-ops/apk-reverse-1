local WorldDetectDigGame = BaseClass("WorldDetectDigGame", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization

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
  self.textDesc = self:AddComponent(UITextMeshProUGUIEx, "content/TextDesc")
end

local function ComponentDestroy(self)
  self.textDesc = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function RefreshData(self, param)
  if not param then
    return
  end
  self.textDesc:SetText(param.tip)
end

WorldDetectDigGame.OnCreate = OnCreate
WorldDetectDigGame.OnDestroy = OnDestroy
WorldDetectDigGame.OnEnable = OnEnable
WorldDetectDigGame.OnDisable = OnDisable
WorldDetectDigGame.ComponentDefine = ComponentDefine
WorldDetectDigGame.ComponentDestroy = ComponentDestroy
WorldDetectDigGame.DataDefine = DataDefine
WorldDetectDigGame.DataDestroy = DataDestroy
WorldDetectDigGame.RefreshData = RefreshData
return WorldDetectDigGame
