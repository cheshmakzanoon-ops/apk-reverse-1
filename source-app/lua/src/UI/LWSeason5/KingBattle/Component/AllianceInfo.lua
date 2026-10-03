local base = UIBaseContainer
local AllianceInfo = BaseClass("AllianceInfo", base)
local btn_path = ""
local pos_path = "txtPos"
local name_path = "txtAllianceName"
local icon_path = "allianceIcon"

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
  self.btn = self:AddComponent(UIButton, btn_path)
  self.pos = self:AddComponent(UIText, pos_path)
  self.name = self:AddComponent(UIText, name_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.btn:SetOnClick(function()
    self:Goto()
  end)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.pos = nil
  self.name = nil
  self.icon = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function AllianceInfo:ReInit(data, index)
  self.data = data
  if data == nil or data.hide then
    self:SetActive(false)
    return
  end
  if data and not string.IsNullOrEmpty(data.allianceAbbr) then
    self.icon:LoadSpriteAsync(string.format(AL_FLAG_SPRITE_PATH, data.allianceIcon or 1))
    self.name:SetText(string.format("#%s[%s]", data.serverId, data.allianceAbbr or ""))
  else
    self.name:SetLocalText("season_s5_activity_1200067_alliance_limit4")
    self.icon:LoadSpriteAsync("Assets/Main/SeasonRes/S5/Sprites/KingBattleS5/FX_S5_QSZ_wenhao.png")
  end
  if data and self.data.cityId and self.data.cityId > 0 then
    local midServerId = DataCenter.SeasonDataManager:GetNinePalacesServer(5, ServerEnum.Source)
    local tilePos = SceneUtils.IndexToTilePos(self.data.pointId, ForceChangeScene.World)
    local pos = SceneUtils.TileIndexToWorld(self.data.pointId, ForceChangeScene.World, midServerId)
    self.pos:SetText(string.format("X:%d Y:%d", tilePos.x or 0, tilePos.y or 0))
  end
  self:SetActive(true)
end

function AllianceInfo:Goto()
  if not (self.data and self.data.cityId) or self.data.cityId <= 0 then
    return
  end
  local midServerId = DataCenter.SeasonDataManager:GetNinePalacesServer(5, ServerEnum.Source)
  local pos = SceneUtils.TileIndexToWorld(self.data.pointId, ForceChangeScene.World, midServerId)
  local position = CS.UnityEngine.Vector3(pos.x, 0, pos.z)
  GoToUtil.GotoWorldPos(position, 150, nil, function()
  end, midServerId)
  GoToUtil.CloseAllWindows()
end

AllianceInfo.OnCreate = OnCreate
AllianceInfo.OnDestroy = OnDestroy
AllianceInfo.OnEnable = OnEnable
AllianceInfo.OnDisable = OnDisable
AllianceInfo.ComponentDefine = ComponentDefine
AllianceInfo.ComponentDestroy = ComponentDestroy
AllianceInfo.DataDefine = DataDefine
AllianceInfo.DataDestroy = DataDestroy
return AllianceInfo
