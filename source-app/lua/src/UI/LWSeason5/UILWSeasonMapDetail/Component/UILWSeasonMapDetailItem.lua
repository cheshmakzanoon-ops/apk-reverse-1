local UILWSeasonMapDetailItem = BaseClass("UILWSeasonMapDetailItem", UIToggle)
local base = UIToggle
local Localization = CS.GameEntry.Localization

function UILWSeasonMapDetailItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, "select")
  self.pos = self:AddComponent(UIImage, "pos")
  self.name = self:AddComponent(UITextMeshProUGUIEx, "name")
  self.server = self:AddComponent(UITextMeshProUGUIEx, "server")
  self:SetOnValueChanged(function(tf)
    if self.view and not self.view.doWorking then
      self.view:OnInfoChanged(self)
    end
  end)
end

function UILWSeasonMapDetailItem:OnDestroy()
  self.pos = nil
  self.name = nil
  self.server = nil
  base.OnDestroy(self)
end

function UILWSeasonMapDetailItem:ReInit(index, info)
  local sourceServerId = LuaEntry.Player:GetSourceServerId()
  local skin = info:GetSkinTemplate()
  local mapName = Localization:GetString(skin.aliases)
  self.mapIndex = index
  self.serverId = info.serverId
  self.skinMeta = skin
  self.name:SetText(mapName)
  self.server:SetText("#" .. self.serverId)
  if sourceServerId == self.serverId then
    self.pos:SetActive(true)
    self.name:SetColorHex("#61EF88")
    self.server:SetColorHex("#61EF88")
  else
    self.pos:SetActive(false)
    if index == 5 then
      self.name:SetColorHex("#FDC939")
      self.server:SetColorHex("#FDC939")
    else
      self.name:SetColorHex("#FFFFFF")
      self.server:SetColorHex("#FFFFFF")
    end
  end
end

function UILWSeasonMapDetailItem:ShowSelf(showGreen)
  if showGreen then
    self.bg:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/MiniMap/lrb_S5ditu_map_xuanzhong03.png")
  else
    self.bg:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/MiniMap/lrb_S5ditu_map_xuanzhong01.png")
  end
  self.showGreen = showGreen
end

return UILWSeasonMapDetailItem
