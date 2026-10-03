local WorldBuildHeadUI = BaseClass("WorldBuildHeadUI")
local hp_spr_path = "Transform/back/hp"
local hp_red_spr_path = "Transform/back/hpRed"
local head_bg_path = "Transform/back/headbg"
local hero_head_bg_path = "Transform/back/hero_head_bg"
local player_name_path = "Transform/NameBg/playerName"
local city_name_path = "Transform/NameBg/cityName"
local icon_path = "Transform/back/headIcon"
local hero_head_icon_path = "Transform/back/hero_head_icon"
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:SetHP(1, 1)
  self:ComponentDestroy()
end

local function ComponentDefine(self)
  self.hp_spr = self.transform:Find(hp_spr_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.hp_slider = self.transform:Find(hp_spr_path):GetComponent(typeof(CS.SceneSpriteSlider))
  self.hp_red_slider = self.transform:Find(hp_red_spr_path):GetComponent(typeof(CS.SceneSpriteSlider))
  self.icon = self.transform:Find(icon_path):GetComponent(typeof(CS.UIPlayerHead))
  self.head_bg = self.transform:Find(head_bg_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.hero_head_bg = self.transform:Find(hero_head_bg_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.head_icon = self.transform:Find(icon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.hero_head_icon = self.transform:Find(hero_head_icon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.player_name = self.transform:Find(player_name_path):GetComponent(typeof(CS.SuperTextMesh))
  self.city_name = self.transform:Find(city_name_path):GetComponent(typeof(CS.SuperTextMesh))
  self.cacheHpImg = ""
  self.startBloodPercent = 0
  self.endBloodPercent = 0
end

local function ComponentDestroy(self)
  self.hp_spr = nil
  self.hp_slider = nil
  self.hp_red_slider = nil
  self.icon = nil
  self.player_name = nil
  self.city_name = nil
  self.cacheHpImg = nil
  self.startBloodPercent = nil
  self.endBloodPercent = nil
  self.head_bg = nil
  self.head_icon = nil
  self.hero_head_bg = nil
end

local function InitInfo(self, buildPointData, initHealth, curHealth, uid, ownerData)
  local name = ""
  local buildId = buildPointData.itemId
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if buildTemplate ~= nil then
    name = Localization:GetString(buildTemplate.name)
  end
  self:UpdatePosition(buildPointData.mainIndex, buildTemplate.tileX, buildTemplate.tileY)
  self.city_name.text = name
  self.hero_head_icon.gameObject:SetActive(false)
  self.head_icon.gameObject:SetActive(true)
  self.hero_head_bg.gameObject:SetActive(false)
  self.head_bg.gameObject:SetActive(true)
  self:SetPlayerData(uid, ownerData)
  self:SetHP(curHealth, initHealth)
end

local function InitCollectInfo(self, buildPointData, initHealth, curHealth, marchUuid)
  self:UpdatePosition(buildPointData.mainIndex, 1, 1)
  self.hero_head_bg.gameObject:SetActive(true)
  self.head_bg.gameObject:SetActive(false)
  self.hero_head_icon.gameObject:SetActive(true)
  self.head_icon.gameObject:SetActive(false)
  self.player_name.text = ""
  self.city_name.text = ""
  local info = CS.SceneManager.World:GetMarch(marchUuid)
  if info ~= nil then
    if info.allianceAbbr ~= nil and info.allianceAbbr ~= "" then
      self.player_name.text = "[" .. info.allianceAbbr .. "] " .. info.ownerName
    else
      self.player_name.text = info.ownerName
    end
    local armyInfo = info:GetFirstArmyInfo()
    if armyInfo ~= nil and armyInfo.HeroInfos ~= nil and armyInfo.HeroInfos.Count > 0 then
      local heroData = armyInfo.HeroInfos[0]
      if heroData ~= nil then
        local rarity = tonumber(GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "rarity"))
        local isReachMax = heroData:GetIsAllSKillReachMax()
        if isReachMax ~= nil and isReachMax == true then
          if rarity ~= HeroUtils.RarityType.S then
            isReachMax = false
          end
        else
          isReachMax = false
        end
        self.hero_head_bg:LoadSprite(HeroUtils.GetCircleQualityIconPath(rarity, isReachMax))
        local icon = HeroUtils.GetHeroIconRoundPath(heroData.heroId)
        UIUtil.LoadSpriteRenderAuto(self.hero_head_icon, icon)
      end
    end
    local count = info:GetSoliderNum()
    self.city_name.text = string.GetFormattedSeperatorNum(count)
  end
  self:SetHP(curHealth, initHealth)
end

local function SetPlayerData(self, uid, ownerData)
  if ownerData ~= nil then
    local playerName = ownerData:GetUserName()
    self.player_name.text = playerName
    local userPic = ownerData.headPic or ""
    local userPicVer = ownerData.headPicVer or 0
    self.icon:SetData(uid, userPic, userPicVer)
  end
end

local function SetHP(self, hp, maxhp)
  self.hp_red_slider:Init(math.max(maxhp, 1), self.cacheBloodHp)
  local percent = hp / math.max(maxhp, 1)
  local spr = ""
  if percent < 0.3 then
    spr = "Assets/Main/Sprites/UI/UIWorldBattle/UIWorldBattle_pro_player_red.png"
  elseif 0.3 <= percent and percent < 0.7 then
    spr = "Assets/Main/Sprites/UI/UIWorldBattle/UIWorldBattle_pro_player_yellow.png"
  elseif 0.7 <= percent then
    spr = "Assets/Main/Sprites/UI/UIWorldBattle/UIWorldBattle_pro_player_green.png"
  end
  if self.cacheHpImg ~= spr then
    self.hp_spr:LoadSprite(spr)
    self.cacheHpImg = spr
  end
  self.cacheBloodHp = hp
  self.hp_slider:Init(math.max(maxhp, 1), hp)
end

local function UpdatePosition(self, index, tileX, tileY)
  local modelHeight = 0
  if CS.SceneManager.World ~= nil then
    modelHeight = CS.SceneManager.World:GetBuildingHeight(index)
  end
  self.transform.position = BuildingUtils.GetBuildModelDownVec(index, tileX, tileY) + Vector3.New(0, modelHeight, 0)
end

WorldBuildHeadUI.OnCreate = OnCreate
WorldBuildHeadUI.OnDestroy = OnDestroy
WorldBuildHeadUI.ComponentDefine = ComponentDefine
WorldBuildHeadUI.ComponentDestroy = ComponentDestroy
WorldBuildHeadUI.SetPlayerData = SetPlayerData
WorldBuildHeadUI.InitInfo = InitInfo
WorldBuildHeadUI.SetHP = SetHP
WorldBuildHeadUI.UpdatePosition = UpdatePosition
WorldBuildHeadUI.InitCollectInfo = InitCollectInfo
return WorldBuildHeadUI
