local MonsterIDistanceItem = BaseClass("MonsterIDistanceItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local bg_path = "Bg"
local dis_text_path = "Bg/DisText"

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

local function ComponentDefine(self)
  self.bg = self:AddComponent(UIBaseContainer, bg_path)
  self.dis_text = self:AddComponent(UITextMeshProUGUIEx, dis_text_path)
end

local function ComponentDestroy(self)
  self.bg = nil
  self.dis_text = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function ReInit(self, point)
  if point and 0 < point then
    local distance = math.ceil(SceneUtils.TileDistance(SceneUtils.IndexToTilePos(point, ForceChangeScene.World), SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)))
    self.dis_text:SetText(distance .. Localization:GetString(GameDialogDefine.KILOMETRE))
  end
end

MonsterIDistanceItem.OnCreate = OnCreate
MonsterIDistanceItem.OnDestroy = OnDestroy
MonsterIDistanceItem.ComponentDefine = ComponentDefine
MonsterIDistanceItem.ComponentDestroy = ComponentDestroy
MonsterIDistanceItem.DataDefine = DataDefine
MonsterIDistanceItem.DataDestroy = DataDestroy
MonsterIDistanceItem.ReInit = ReInit
return MonsterIDistanceItem
