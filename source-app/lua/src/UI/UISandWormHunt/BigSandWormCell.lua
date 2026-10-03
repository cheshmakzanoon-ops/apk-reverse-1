local BigSandWormCell = BaseClass("BigSandWormCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local icon_path = "Icon"
local name_path = "name"
local location_path = "location"
local state_path = "state"
local finder_path = "finder"
local slider_path = "Slider"
local slider_txt_path = "Slider/SliderTxt"

function BigSandWormCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function BigSandWormCell:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function BigSandWormCell:ComponentDefine()
  self.icon = self:AddComponent(UIImage, icon_path)
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.location = self:AddComponent(UITextMeshProUGUIEx, location_path)
  self.state = self:AddComponent(UITextMeshProUGUIEx, state_path)
  self.finder = self:AddComponent(UITextMeshProUGUIEx, finder_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.slider_txt = self:AddComponent(UITextMeshProUGUIEx, slider_txt_path)
  self.btn_go = self:AddComponent(UIButton, location_path)
  self.btn_go:SetOnClick(function()
    self:OnClickGoBtn()
  end)
end

function BigSandWormCell:ComponentDestroy()
  self.icon = nil
  self.name = nil
  self.location = nil
  self.state = nil
  self.finder = nil
  self.slider = nil
  self.slider_txt = nil
end

function BigSandWormCell:DataDefine()
end

function BigSandWormCell:DataDestroy()
  self.serverId = nil
  self.pointId = nil
end

function BigSandWormCell:SetData(data)
  if not data then
    return
  end
  self.serverId = data.serverId
  self.pointId = data.pointId
  local meta = DataCenter.MonsterTemplateManager:GetMonsterTemplate(data.monsterId)
  self.icon:LoadSpriteAuto(meta:GetSmallIcon())
  self.name:SetLocalText(meta.name)
  local tilePos = SceneUtils.IndexToTilePos(data.pointId, ForceChangeScene.World)
  self.location:SetText(string.format("#%s X:%s Y:%s", data.serverId, tilePos.x, tilePos.y))
  self.state:SetLocalText(meta.name)
  local finderStr = Localization:GetString(2901038)
  self.finder:SetText(string.format("%s %s", finderStr, UIUtil.FormatAllianceAndName(data.avatar.abbr, data.avatar.name, data.avatar.uid)))
end

function BigSandWormCell:OnClickGoBtn()
  if not self.serverId then
    return
  end
  local serverId = self.serverId
  local pos = SceneUtils.TileIndexToWorld(self.pointId, ForceChangeScene.World)
  GoToUtil.GotoWorldPos(pos, nil, 0, nil, serverId)
  GoToUtil.CloseAllWindows()
end

return BigSandWormCell
