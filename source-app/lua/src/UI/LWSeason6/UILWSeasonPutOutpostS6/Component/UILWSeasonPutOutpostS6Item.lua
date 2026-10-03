local UILWSeasonPutOutpostS6Item = BaseClass("UILWSeasonPutOutpostS6Item", UIToggle)
local base = UIToggle

function UILWSeasonPutOutpostS6Item:OnCreate()
  base.OnCreate(self)
  self.select = self:AddComponent(UIImage, "select")
  self.info = self:AddComponent(UIBaseContainer, "info")
  self.icon = self:AddComponent(UIImage, "info/icon")
  self.bg = self:AddComponent(UIImage, "info/bg")
  self.name = self:AddComponent(UITextMeshProUGUIEx, "info/name")
end

function UILWSeasonPutOutpostS6Item:OnDestroy()
  self.select = nil
  self.info = nil
  self.icon = nil
  self.bg = nil
  self.name = nil
  base.OnDestroy(self)
end

function UILWSeasonPutOutpostS6Item:ReInit(serverId, cityId, isKingCity)
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local cityData = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(cityId, serverId)
  if isKingCity then
    local campId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(serverId)
    self.name:SetText("#" .. serverId)
    if cityData and cityData:IsRuins() then
      self.name:SetColorHex("f53c3d")
    elseif mySourceServerId == serverId then
      self.name:SetColorHex("3BF58E")
    else
      self.name:SetColorHex("45C4F1")
    end
    if campId == 1 then
      self.icon:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/CommonS6/LodIcon/lyt_S6_wujisuofang_12.png")
      self.bg:LoadSprite("Assets/Main/SeasonRes/S6/Sprites/SelectCamp/ljq_s6_fuwuqibg01.png")
    else
      self.icon:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/CommonS6/LodIcon/lyt_S6_wujisuofang_8.png")
      self.bg:LoadSprite("Assets/Main/SeasonRes/S6/Sprites/SelectCamp/ljq_s6_fuwuqibg02.png")
    end
    return
  end
  local putByServerId = DataCenter.SeasonOutpostManager:GetPutInfoByCityId(cityId)
  if putByServerId then
    if cityData ~= nil then
      if toInt(cityData.destroyServerId) > 0 then
        self.name:SetLocalText("zonewar_landlord_limit_1017")
        self.name:SetColorHex("#F53C3D")
        self.icon:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/OutpostS6/mjc_S6_QSZ_icon_cuihui.png")
      else
        self.name:SetText("#" .. putByServerId)
        self.name:SetColorHex("#FFFFFF")
        self.icon:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/OutpostS6/mjc_S6_QSZ_icon_qianshaozhan1.png")
      end
    else
      self.name:SetText("#" .. putByServerId)
      self.name:SetColorHex("#FFFFFF")
      self.icon:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/OutpostS6/mjc_S6_QSZ_icon_qianshaozhan1.png")
    end
    if cityData and cityData:IsRuins() then
      self.name:SetColorHex("f53c3d")
    elseif mySourceServerId == putByServerId then
      self.name:SetColorHex("3BF58E")
    else
      self.name:SetColorHex("45C4F1")
    end
  else
    self.name:SetLocalText("s6_outpost_btn_4")
    self.name:SetColorHex("#FFFFFF")
    self.icon:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/OutpostS6/mjc_S6_QSZ_icon_weifangzhi.png")
  end
end

return UILWSeasonPutOutpostS6Item
