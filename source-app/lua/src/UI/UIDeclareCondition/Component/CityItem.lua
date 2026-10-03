local CityItem = BaseClass("CityItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local icon_path = "icon"
local level_path = "level"
local name_path = "name"
local btn_path = "btn"
local btn_txt_path = "btn/btnTxt"

function CityItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function CityItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function CityItem:ComponentDefine()
  self.icon = self:AddComponent(UIImage, icon_path)
  self.level = self:AddComponent(UITextMeshProUGUIEx, level_path)
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    if self.template.pos ~= nil and self.template.pos.x ~= nil and self.template.pos.y ~= nil then
      local v3 = SceneUtils.TileToWorld(self.template.pos, ForceChangeScene.World)
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, nil, nil, LuaEntry.Player:GetCurServerId())
    end
  end)
  self.btn_txt = self:AddComponent(UITextMeshProUGUIEx, btn_txt_path)
end

function CityItem:ComponentDestroy()
  self.template = nil
  self.type = nil
end

function CityItem:Refresh(data, type)
  local template = data
  self.type = type
  self.template = template
  self.icon:LoadSprite(template:GetIconPath(false))
  self.level:SetLocalText("season_mastery_163", template.level)
  self.name:SetText(Localization:GetString(template.name) .. "\n" .. Localization:GetString("300015", template.pos.x, template.pos.y))
  if self.type == DeclareCondition.AdjacentCity then
    self.btn_txt:SetLocalText(2800105)
  elseif self.type == DeclareCondition.LevelOne then
    self.btn_txt:SetLocalText(2800105)
  elseif self.type == DeclareCondition.OccupyLimit then
    self.btn_txt:SetLocalText(110075)
  elseif self.type == DeclareCondition.AdjacentStronghold then
    self.btn_txt:SetLocalText(110003)
  end
end

return CityItem
