local UILWSeasonOutpostMapItemS6 = BaseClass("UILWSeasonOutpostMapItemS6", UIToggle)
local base = UIToggle
local Localization = CS.GameEntry.Localization

function UILWSeasonOutpostMapItemS6:OnCreate()
  base.OnCreate(self)
  self.info = self:AddComponent(UIBaseContainer, "info")
  self.icon = self:AddComponent(UIImage, "info/icon")
  self.bg = self:AddComponent(UIImage, "info/bg")
  self.name = self:AddComponent(UITextMeshProUGUIEx, "info/name")
  self.status = self:AddComponent(UIImage, "status")
  self.select = self:AddComponent(UIImage, "select")
  self:SetIsOn(false)
  self.select:SetActive(false)
  self.status:SetActive(false)
end

function UILWSeasonOutpostMapItemS6:OnDestroy()
  self.info = nil
  self.icon = nil
  self.bg = nil
  self.name = nil
  self.status = nil
  self.select = nil
  base.OnDestroy(self)
end

function UILWSeasonOutpostMapItemS6:ReInit(serverId, cityId, isKingCity)
  local factionMgr = DataCenter.SeasonFactionWarDataManager
  local cityData = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(cityId, serverId)
  if isKingCity then
    local campId = factionMgr:GetCampIdByServerId(serverId)
    self.name:SetText("#" .. serverId)
    self.name:SetColorHex("#FFFFFF")
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
    local canAttack = false
    local canDefence = false
    if cityData ~= nil then
      local mySourceServerId = LuaEntry.Player:GetSourceServerId()
      local campId = factionMgr:GetCampIdByServerId(putByServerId)
      local myCampId = factionMgr.myCampId
      if toInt(cityData.destroyServerId) > 0 then
        self.name:SetLocalText("zonewar_landlord_limit_1017")
        self.name:SetColorHex("#F53C3D")
        self.icon:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/OutpostS6/mjc_S6_QSZ_icon_cuihui.png")
      else
        self.name:SetText(UIUtil.FormatServerAllianceName(cityData.occupyServerId, cityData.abbr))
        if cityData.occupyServerId == mySourceServerId then
          self.icon:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/OutpostS6/mjc_S6_QSZ_icon_qianshaozhan3.png")
          self.name:SetColorHex("#5FEF87")
          canDefence = true
        elseif campId == myCampId then
          self.icon:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/OutpostS6/mjc_S6_QSZ_icon_qianshaozhan2.png")
          self.name:SetColorHex("#70E6F1")
        else
          self.icon:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/OutpostS6/mjc_S6_QSZ_icon_qianshaozhan4.png")
          self.name:SetColorHex("#F53C3D")
          canAttack = SeasonUtil.CheckConnectSwitch(cityId, serverId, true)
        end
        if DataCenter.SeasonAllyFriendManager:IsMyAllianceFriend(cityData.allianceId) then
          canDefence = true
        end
      end
    else
      self.name:SetText("#" .. putByServerId)
      self.name:SetColorHex("#FFFFFF")
      self.icon:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/OutpostS6/mjc_S6_QSZ_icon_qianshaozhan1.png")
    end
    if canDefence and cityData then
      local hasEnemy = false
      local theOwnerCampId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(cityData.occupyServerId)
      local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, serverId)
      if cityTemplate then
        local nearBy = cityTemplate.nearBy
        if nearBy then
          local mgr = DataCenter.WorldAllianceCityDataManager
          for i, theCityId in ipairs(nearBy) do
            local cityInfo = mgr:GetAllianceCityDataByCityId(toInt(theCityId))
            if cityInfo ~= nil and cityInfo.occupyServerId ~= 0 then
              local _ownerCampId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(cityInfo.occupyServerId)
              if _ownerCampId ~= theOwnerCampId then
                hasEnemy = true
                break
              end
            end
          end
        end
      end
      canDefence = hasEnemy
    end
    self.status:SetActive(canAttack or canDefence)
    if canAttack then
      self.status:LoadSpriteAuto("Assets/Main/Sprites/UI/UILWMail/FX_youjianzhanbao_gongji.png")
    elseif canDefence then
      self.status:LoadSpriteAuto("Assets/Main/Sprites/UI/UILWMail/FX_youjianzhanbao_hudun.png")
    end
  else
    self.status:SetActive(false)
    self.name:SetLocalText("s6_outpost_btn_4")
    self.name:SetColorHex("#FFFFFF")
    self.icon:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/OutpostS6/mjc_S6_QSZ_icon_weifangzhi.png")
  end
end

return UILWSeasonOutpostMapItemS6
