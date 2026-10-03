local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local RankItemCity = BaseClass("UILWSeasonRainforestKingDestroyRankItemCity", base)
local UILWSeasonRainforestKingDestroyRankItem = BaseClass("UILWSeasonRainforestKingDestroyRankItem", base)
local mask_path = "mask"
local flag_icon_path = "InnerPanel/BasePanel/FlagItem/FlagIcon"
local name_text_path = "InnerPanel/BasePanel/NameText"
local base_info_btn_path = "InnerPanel/BasePanel/BaseInfoBtn"
local value_city_path = "InnerPanel/BasePanel/bg1/ValueCity"
local value_force_path = "InnerPanel/BasePanel/bg2/ValueForce"
local city_path = "City"
local titleBg_path = "Title"
local lineBg1_path = "Title/line1"
local lineBg2_path = "Title/line2"
local expand_btn_path = "InnerPanel/ExpandBtn"

function UILWSeasonRainforestKingDestroyRankItem:OnCreate()
  base.OnCreate(self)
  self.titleBg = self:AddComponent(UIImage, titleBg_path)
  self.lineBg1 = self:AddComponent(UIImage, lineBg1_path)
  self.lineBg2 = self:AddComponent(UIImage, lineBg2_path)
  self.mask = self:AddComponent(UIRawImage, mask_path)
  self.bg = self:AddComponent(UIImage, "")
  self.flag_icon = self:AddComponent(UIImage, flag_icon_path)
  self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
  self.base_info_btn = self:AddComponent(UIButton, base_info_btn_path)
  self.value_city = self:AddComponent(UITextMeshProUGUIEx, value_city_path)
  self.value_force = self:AddComponent(UITextMeshProUGUIEx, value_force_path)
  self.theItemPool = self.transform:Find(city_path).gameObject
  self.theItemPool:GameObjectCreatePool()
  self.theItemPool:SetActive(false)
  self.base_info_btn:SetOnClick(function()
    if self.allianceId then
      UIUtil.TryShowAllianceInfo(self.serverId, self.allianceId)
    end
  end)
  self.expand_btn = self:AddComponent(UIButton, expand_btn_path)
  self.expand_btn:SetOnClick(function()
    self.expand = not self.expand
    if self.expand then
      self.titleBg:SetActive(true)
      self:ShowCityData()
      self.expand_btn:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_anniu_xiala_2.png")
    else
      self:RemoveComponents(RankItemCity)
      self.theItemPool:GameObjectRecycleAll()
      self.titleBg:SetActive(false)
      self.expand_btn:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_anniu_xiala_1.png")
    end
    if self.view and self.view.content then
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.view.content.transform)
    end
  end)
  self.expand = false
  self.titleBg:SetActive(false)
  self.expand_btn:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_anniu_xiala_1.png")
end

function UILWSeasonRainforestKingDestroyRankItem:OnDestroy()
  self:RemoveComponents(RankItemCity)
  self.theItemPool:GameObjectRecycleAll()
  self.expand_btn = nil
  self.flag_icon = nil
  self.name_text = nil
  self.base_info_btn = nil
  self.value_city = nil
  self.value_force = nil
  self.city = nil
  self.titleBg = nil
  self.lineBg1 = nil
  self.lineBg2 = nil
  base.OnDestroy(self)
end

function UILWSeasonRainforestKingDestroyRankItem:ReInit(data)
  local allianceId = data.allianceId
  local allianceData = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(allianceId)
  if allianceData == nil then
    SFSNetwork.SendMessage(MsgDefines.GetAllianceInfo, allianceId)
  end
  self.expand = false
  self.serverId = data.serverId
  self.campId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(data.serverId)
  self.allianceId = allianceId
  self.allianceData = allianceData
  self.data = data
  if self.campId == SeasonFactionType.Rebels then
    self.mask:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Textures/CommonS6/mjc_S6_wenli_zhenying_2.png")
    self.bg:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/CommonS6/cell/mjc_S6_ZFWZZ_liebiao_bg02.png")
    self.name_text:SetColorHex("#8EFFCE")
    self.value_city:SetColorHex("#8EFFCE")
    self.value_force:SetColorHex("#8EFFCE")
    self.titleBg:SetColorHex("#96E6A0")
    self.lineBg1:SetColorHex("#C3F5BE")
    self.lineBg2:SetColorHex("#C3F5BE")
  else
    self.mask:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Textures/CommonS6/mjc_S6_wenli_zhenying_1.png")
    self.bg:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/CommonS6/cell/mjc_S6_ZFWZZ_liebiao_bg03.png")
    self.name_text:SetColorHex("#73FAFF")
    self.value_city:SetColorHex("#73FAFF")
    self.value_force:SetColorHex("#73FAFF")
    self.titleBg:SetColorHex("#9BDCFF")
    self.lineBg1:SetColorHex("#C8F0FF")
    self.lineBg2:SetColorHex("#C8F0FF")
  end
  self.mask:SetColorHex("FFFFFF58")
  self.titleBg:SetActive(self.expand)
  self:ShowAllianceData()
  self:ShowCityData()
end

function UILWSeasonRainforestKingDestroyRankItem:UpdateAllianceData()
  local allianceId = self.allianceId
  if allianceId and self.allianceData == nil then
    local allianceData = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(allianceId)
    if allianceData ~= nil then
      self.allianceData = allianceData
    end
  end
  self:ShowAllianceData()
end

function UILWSeasonRainforestKingDestroyRankItem:ShowAllianceData()
  if self.allianceData == nil then
    return
  end
  self.flag_icon:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(self.allianceData.icon)))
  self.name_text:SetText(self.allianceData:GetFullName())
end

function UILWSeasonRainforestKingDestroyRankItem:ShowCityData()
  if self.data == nil then
    return
  end
  local cityList = self.data.cityList
  local destroy_force = toInt(self.data.destroy_force)
  self.value_city:SetLocalText("season_s6_activity_1200116_desc10", #cityList)
  self.value_force:SetLocalText("season_s6_activity_1200116_desc11", destroy_force)
  if cityList and self.expand then
    local goItem, theItem
    for index, v in ipairs(cityList) do
      local cityData = v.data
      local cityCfg = v.cfg
      if cityData and cityCfg then
        goItem = self.theItemPool:GameObjectSpawn(self.transform)
        goItem.name = "item_" .. UIUtil.GetLoopListItemIndex()
        goItem:SetActive(true)
        theItem = self:AddComponent(RankItemCity, goItem.name)
        theItem:ReInit(index, cityCfg, cityData, self.campId)
      end
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

function RankItemCity:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, "")
  self.v1 = self:AddComponent(UITextMeshProUGUIEx, "v1")
  self.v2 = self:AddComponent(UITextMeshProUGUIEx, "v2")
  self.v3 = self:AddComponent(UITextMeshProUGUIEx, "v3")
  self.jump_btn = self:AddComponent(UIButton, "v2/jumpBtn")
  self.jump_btn:SetOnClick(function()
    if self.cityCfg then
      self.cityCfg:JumpTo()
    end
  end)
end

function RankItemCity:OnDestroy()
  self.v1 = nil
  self.v2 = nil
  self.v3 = nil
  self.jump_btn = nil
  base.OnDestroy(self)
end

function RankItemCity:ReInit(index, cityCfg, cityData, campId)
  local pos = cityCfg.pos
  self.cityCfg = cityCfg
  self.v1:SetText(Localization:GetString("310161", cityCfg:GetName(), cityCfg.level))
  self.v2:SetText(string.format("<u>%s, %s</u>", pos.x, pos.y))
  self.v3:SetText(cityCfg:getIntValue("destroy_force", 0))
  if campId == 1 then
    if index % 2 == 0 then
      self.bg:SetColorHex("C9F6C5")
    else
      self.bg:SetColorHex("B5F0B5")
    end
  elseif index % 2 == 0 then
    self.bg:SetColorHex("CEF2FF")
  else
    self.bg:SetColorHex("BAEAFF")
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

return UILWSeasonRainforestKingDestroyRankItem
