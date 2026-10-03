local DisplaySettings = require("DataCenter.WorldBattle.WorldBattleDisplaySettings")
local WorldTroopLightEffect = require("Scene.WorldTroopEffect.WorldTroopLightEffect")
local TroopHeadUI = BaseClass("TroopHeadUI")
local UIEventTrigger = CS.UIEventTrigger
local back_obj_path = ""
local transform_Panel_path = "Transform"
local back_bg_path = "Transform/back"
local head_state_path = "Transform/back/circle"
local head_bg_path = "Transform/back/headbg"
local head_icon_path = "Transform/back/headicon"
local hp_spr_path = "Transform/back/hp"
local hp_red_slider_path = "Transform/back/hp/hpRed"
local anger_spr_path = "Transform/back/anger"
local attack_name_obj_path = "Transform/back/attackNameBg"
local attack_name_path = "Transform/back/attackNameBg/attack_name"
local name_bg_path = "Transform/NameBg"
local solider_num_path = "Transform/NameBg/num"
local player_name_path = "Transform/NameBg/name"
local player_end_path = "Transform/NameBg/end"
local virus_node_path = "Transform/NameBg/VirusNode"
local city_troop_name_bg_path = "Transform/CityNameBg"
local city_troop_name_path = "Transform/CityNameBg/citytroopName"
local select_obj_path = "selectObj"
local troop_select_path = "selectObj/TroopSelect"
local troop_pin_path = "Transform/Pin"
local anger_effect_path = "Transform/back/anger/VFX_xuetiaoman"
local Localization = CS.GameEntry.Localization
local NormalPos = Vector3.New(0, 0, 0)
local AttackPos = Vector3.New(0.69, 0, 0)
local effect1_path = "Assets/Main/Prefabs/March/WorldTroopGlow.prefab"
local ResourceManager = CS.GameEntry.Resource

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self.LightRoot = nil
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:RemoveVirus()
  self:SetHP(1, 1)
  self:ComponentDestroy()
end

local function Hit(self)
end

local function ComponentDefine(self)
  self.effectList = {}
  self.back_obj = self.transform:Find(back_obj_path).gameObject
  self.select_obj = self.transform:Find(select_obj_path).gameObject
  self.back_bg = self.transform:Find(back_bg_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.name_bg = self.transform:Find(name_bg_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.head_state = self.transform:Find(head_state_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.head_bg = self.transform:Find(head_bg_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.head_icon = self.transform:Find(head_icon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.hp_slider = self.transform:Find(hp_spr_path):GetComponent(typeof(CS.SceneSpriteSlider))
  self.hp_red_slider = self.transform:Find(hp_red_slider_path):GetComponent(typeof(CS.SceneSpriteSlider))
  self.hp_spr = self.transform:Find(hp_spr_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.anger_slider = self.transform:Find(anger_spr_path):GetComponent(typeof(CS.SceneSpriteSlider))
  self.anger_spr = self.transform:Find(anger_spr_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.solider_num = self.transform:Find(solider_num_path):GetComponent(typeof(CS.TextMeshProEx))
  self.player_name = self.transform:Find(player_name_path):GetComponent(typeof(CS.TextMeshProEx))
  self.march_end = self.transform:Find(player_end_path):GetComponent(typeof(CS.TextMeshProEx))
  self.march_end_btn = self.transform:Find(player_end_path):GetComponent(typeof(UIEventTrigger))
  
  function self.march_end_btn.onPointerClick()
    self:OnEndBtnClick()
  end
  
  self.city_troop_name = self.transform:Find(city_troop_name_path):GetComponent(typeof(CS.TextMeshProEx))
  self.city_troop_name_bg = self.transform:Find(city_troop_name_bg_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.attack_name_obj = self.transform:Find(attack_name_obj_path).gameObject
  self.attack_name = self.transform:Find(attack_name_path):GetComponent(typeof(CS.TextMeshProEx))
  self.troop_select = self.transform:Find(troop_select_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.troop_pin = self.transform:Find(troop_pin_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.transform_Panel = self.transform:Find(transform_Panel_path).gameObject
  self.anger_effect = self.transform:Find(anger_effect_path).gameObject
  self.collider = self.transform:Find(back_bg_path):GetComponent(typeof(UIEventTrigger))
  
  function self.collider.onPointerClick()
    self:OnClick()
  end
  
  self.anger_effect:SetActive(false)
  self.grayMaterial = self.back_bg.material
  self.normalMaterial = self.head_state.material
  self.animator = self.transform:GetComponent(typeof(CS.SimpleAnimation))
  self.cacheSoldierNum = -1
  self.cacheHpImg = ""
  self.cacheBloodHp = -1
  self.curTxtColor = WorldWhiteColor32
end

local function ComponentDestroy(self)
  self.grayMaterial = nil
  self.normalMaterial = nil
  self.back_obj = nil
  self.back_bg = nil
  self.select_obj = nil
  self.name_bg = nil
  self.head_state = nil
  self.head_icon = nil
  self.hp_spr = nil
  self.anger_spr = nil
  self.solider_num = nil
  self.player_name = nil
  self.march_end = nil
  self.anger_slider = nil
  self.hp_slider = nil
  self.attack_name_obj = nil
  self.attack_name = nil
  self.troop_select = nil
  self.troop_pin = nil
  self.transform_Panel = nil
  self.marchInfo = nil
  if self.LightRoot ~= nil then
    self.LightRoot:Delete()
    self.LightRoot = nil
  end
  for k, v in pairs(self.effectList) do
    v:Destroy()
  end
  self.effectList = nil
end

local function SetTransformPositon(self, pos)
  self.transform_Panel.transform.localPosition = pos
end

local function ShowAnger(self)
  self.anger_spr.gameObject:SetActive(true)
end

local function ShowUseSkill(self)
  self.animator:Play("V_worldTroopHeadUI_fangda")
  self.animator:PlayQueued("V_worldTroopHeadUI_suoxiao")
  self.doSkill = true
  self:CreateUseSkillEffect(effect1_path, self.transform_Panel.transform)
end

local function CreateUseSkillEffect(self, path, p)
  if self.effectList[path] ~= nil and self.effectList[path].gameObject ~= nil then
    self.effectList[path].gameObject:SetActive(false)
    self.effectList[path].gameObject:SetActive(true)
  else
    local request = ResourceManager:InstantiateAsync(path)
    self.effectList[path] = request
    request:completed("+", function()
      if request.isError then
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:SetParent(p)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      request.gameObject.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      TimerManager:GetInstance():DelayInvoke(function()
        if request ~= nil and request.gameObject ~= nil then
          request.gameObject:SetActive(false)
        end
      end, 1.2)
    end)
  end
end

local function ShowExploreInfo(self, pointIndex, soliderNum, hp, hpMax)
  local data = CS.SceneManager.World:GetExplorePointInfoByIndex(pointIndex)
  if data ~= nil then
    local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
    if template ~= nil then
      local name = template:GetRealName()
      self:SetName(name)
    end
    self.head_bg.material = self.normalMaterial
    self.head_icon.material = self.normalMaterial
    self.anger_spr.gameObject:SetActive(true)
    local maxAnger = LuaEntry.DataConfig:TryGetNum("battle_config", "k12")
    self:SetAnger(0, maxAnger)
    self.select_obj.gameObject:SetActive(false)
    self.name_bg.gameObject:SetActive(false)
    self.back_bg.gameObject:SetActive(false)
    self.attack_name_obj:SetActive(true)
    self.player_name.color32 = WorldWhiteColor32
    self.attack_name.color32 = WorldWhiteColor32
    self.solider_num.color32 = WorldWhiteColor32
    self.troop_select.color = WorldWhiteColor
    self:SetSoldierNum(soliderNum)
    self:SetHP(hp, hpMax)
    local icon = UIUtil.GetFullPath(LoadPath.HeroIconsSmallPath, template.headIcon)
    UIUtil.LoadSpriteRenderAuto(self.head_icon, icon)
  end
end

local function ShowInBattleMarch(self, marchInfo, isBattle)
  if isBattle then
    self.anger_spr.gameObject:SetActive(true)
    self.select_obj.gameObject:SetActive(false)
    self.name_bg.gameObject:SetActive(false)
    self.back_bg.gameObject:SetActive(false)
    self.attack_name_obj:SetActive(true)
  else
    self.anger_spr.gameObject:SetActive(false)
    self.select_obj.gameObject:SetActive(true)
    self.name_bg.gameObject:SetActive(true)
    self.back_bg.gameObject:SetActive(true)
    self.attack_name_obj:SetActive(false)
  end
end

local function ShowMarchInfo(self, marchInfo, isInBattle, isCreate, parent)
  if parent ~= nil then
    self.transform:SetParent(parent, false)
  end
  self.marchInfo = marchInfo
  self.marchUuid = marchInfo.uuid
  self.serverId = marchInfo.serverId
  self.targetServer = marchInfo.targetServer
  self.worldId = marchInfo.worldId
  self.worldType = marchInfo.worldType
  local newMarchType = marchInfo:GetMarchType()
  if isCreate == true then
    if newMarchType == NewMarchType.NORMAL or newMarchType == NewMarchType.CROSS_NORMAL or newMarchType == NewMarchType.FAKE_ATTACK or newMarchType == NewMarchType.ALL_OUT or newMarchType == NewMarchType.ASSEMBLY_MARCH or newMarchType == NewMarchType.SCOUT or newMarchType == NewMarchType.CROSS_SCOUT or newMarchType == NewMarchType.TREAT_VIRUS or newMarchType == NewMarchType.LOTTO_RECEIVE or newMarchType == NewMarchType.EXPLORE or newMarchType == NewMarchType.RESOURCE_HELP or newMarchType == NewMarchType.GOLLOES_EXPLORE or newMarchType == NewMarchType.GOLLOES_TRADE or newMarchType == NewMarchType.DIRECT_MOVE_MARCH or newMarchType == NewMarchType.ZONE_MOBILIZATION_DONATE or newMarchType == NewMarchType.MONSTER_CHALLENGE_DONATE then
      self:SetName(marchInfo.ownerName, marchInfo.allianceAbbr, marchInfo.targetPos)
    elseif marchInfo:IsMonsterOrOrdinaryBoss() then
      local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(tostring(marchInfo.monsterId))
      local name = Localization:GetString(monster.name)
      self:SetName(name, nil, marchInfo.targetPos)
    end
    if marchInfo:GetIsBroken() and marchInfo:IsMasstroops() == false then
      self.head_bg.material = self.grayMaterial
      self.head_icon.material = self.grayMaterial
    else
      self.head_bg.material = self.normalMaterial
      self.head_icon.material = self.normalMaterial
    end
    self:SetHeadCircle(marchInfo)
    if newMarchType == NewMarchType.SCOUT or newMarchType == NewMarchType.CROSS_SCOUT or newMarchType == NewMarchType.TREAT_VIRUS or newMarchType == NewMarchType.LOTTO_RECEIVE or newMarchType == NewMarchType.RESOURCE_HELP or newMarchType == NewMarchType.GOLLOES_EXPLORE or newMarchType == NewMarchType.GOLLOES_TRADE or newMarchType == NewMarchType.ZONE_MOBILIZATION_DONATE or newMarchType == NewMarchType.MONSTER_CHALLENGE_DONATE then
      self:SetHP(1, 1)
    elseif isCreate == true then
      local hp = marchInfo:GetHP()
      local maxHp = marchInfo:GetMaxHP()
      self:SetHP(hp, maxHp)
    end
    if newMarchType == NewMarchType.SCOUT or newMarchType == NewMarchType.CROSS_SCOUT or newMarchType == NewMarchType.TREAT_VIRUS or newMarchType == NewMarchType.LOTTO_RECEIVE or newMarchType == NewMarchType.ZONE_MOBILIZATION_DONATE or newMarchType == NewMarchType.MONSTER_CHALLENGE_DONATE then
      self.head_bg:LoadSprite("Assets/Main/Sprites/UI/UIHeroCommon/cfm_yingxiong_touxiangkuang_fang_2.png")
      self.head_icon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_gongcheng_zhencha.png")
    elseif newMarchType == NewMarchType.RESOURCE_HELP then
      self.head_bg:LoadSprite("Assets/Main/Sprites/UI/UIHeroCommon/cfm_yingxiong_touxiangkuang_fang_4.png")
      self.head_icon:LoadSprite("Assets/Main/Sprites/HeroIconsSmall/round_hero_icon_1003.png")
    elseif newMarchType == NewMarchType.GOLLOES_EXPLORE then
      self.head_bg:LoadSprite("Assets/Main/Sprites/UI/UIHeroCommon/cfm_yingxiong_touxiangkuang_fang_4.png")
      self.head_icon:LoadSprite("Assets/Main/Sprites/HeroIconsSmall/hero_icon_golloes_explorer.png")
    elseif newMarchType == NewMarchType.GOLLOES_TRADE then
      self.head_bg:LoadSprite("Assets/Main/Sprites/UI/UIHeroCommon/cfm_yingxiong_touxiangkuang_fang_4.png")
      self.head_icon:LoadSprite("Assets/Main/Sprites/HeroIconsSmall/hero_icon_golloes_trader.png")
    elseif marchInfo:IsMonsterOrOrdinaryBoss() then
      local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(tostring(marchInfo.monsterId))
      if monster ~= nil then
        local icon = UIUtil.GetFullPath(LoadPath.HeroIconsSmallPath, monster.pic)
        UIUtil.LoadSpriteRenderAuto(self.head_icon, icon)
      end
    else
      local armyInfo = marchInfo:GetFirstArmyInfo()
      if armyInfo ~= nil and armyInfo.HeroInfos ~= nil and armyInfo.HeroInfos.Count > 0 then
        local heroData = armyInfo.HeroInfos[0]
        local max_quality = 0
        table.walk(armyInfo.HeroInfos, function(k, v)
          if v.heroQuality > max_quality then
            max_quality = v.heroQuality
            heroData = v
          end
        end)
        if heroData ~= nil then
          do
            local rarity = DataCenter.HeroTemplateManager:GetTemplate(heroData.heroId).quality
            local isReachMax = heroData:GetIsAllSKillReachMax()
            if isReachMax ~= nil and isReachMax == true then
              if rarity ~= HeroUtils.RarityType.S then
                isReachMax = false
              end
            else
              isReachMax = false
            end
            self.head_bg:LoadSprite(HeroUtils.GetTroopQualityIconPath(rarity, isReachMax))
            local icon = ""
            local modelId = heroData.modelId
            if heroData.weaponLevel and 0 < heroData.weaponLevel then
              local weaponInfo = DataCenter.HeroUniqueWeaponTemplateManager:GetTemplateByHeroId(heroData.heroId, heroData.weaponLevel)
              if weaponInfo and weaponInfo.modelId and 0 < weaponInfo.modelId then
                local appearance = weaponInfo.modelId
                icon = HeroUtils.GetHeroIconPath(appearance, HeroIconType.small_icon, heroData.skinId)
              end
            end
            if string.IsNullOrEmpty(icon) then
              icon = HeroUtils.GetHeroIconRoundPath(heroData.heroId, heroData.skinId)
            end
            UIUtil.LoadSpriteRenderAuto(self.head_icon, icon)
          end
        end
      end
    end
  end
  if newMarchType == NewMarchType.SCOUT or newMarchType == NewMarchType.CROSS_SCOUT or newMarchType == NewMarchType.TREAT_VIRUS or newMarchType == NewMarchType.LOTTO_RECEIVE or newMarchType == NewMarchType.RESOURCE_HELP or newMarchType == NewMarchType.ZONE_MOBILIZATION_DONATE or newMarchType == NewMarchType.MONSTER_CHALLENGE_DONATE then
    self.solider_num.text = ""
  elseif newMarchType == NewMarchType.GOLLOES_EXPLORE then
    local strCost = LuaEntry.DataConfig:TryGetStr("golloes_dispatch_para", "k2")
    local golloesCostTb = string.split(strCost, ";")
  elseif newMarchType == NewMarchType.GOLLOES_TRADE then
    local strCost = LuaEntry.DataConfig:TryGetStr("golloes_dispatch_para", "k2")
    local golloesCostTb = string.split(strCost, ";")
  else
    self:SetSoldierNum(marchInfo:GetSoliderNum())
  end
  if isInBattle then
    if marchInfo:IsMasstroops() == false then
      self.anger_spr.gameObject:SetActive(true)
      local maxAnger = LuaEntry.DataConfig:TryGetNum("battle_config", "k12")
      if isCreate == true then
        self:SetAnger(0, maxAnger)
      end
      self.name_bg.gameObject:SetActive(false)
      self.back_bg.gameObject:SetActive(false)
      self.attack_name_obj:SetActive(true)
    else
      self.anger_spr.gameObject:SetActive(false)
      self.name_bg.gameObject:SetActive(true)
      self.back_bg.gameObject:SetActive(true)
      self.attack_name_obj:SetActive(false)
    end
    self:SetSelectRotation(marchInfo.uuid)
    self.select_obj.gameObject:SetActive(false)
  else
    self.anger_spr.gameObject:SetActive(false)
    self.select_obj.gameObject:SetActive(true)
    self.name_bg.gameObject:SetActive(true)
    self.back_bg.gameObject:SetActive(true)
    self.attack_name_obj:SetActive(false)
    self:SetSelectRotation(marchInfo.uuid)
    if marchInfo:GetIsBroken() and marchInfo:IsMasstroops() == false then
      self.head_bg.material = self.grayMaterial
      self.head_icon.material = self.grayMaterial
    else
      self.head_bg.material = self.normalMaterial
      self.head_icon.material = self.normalMaterial
    end
  end
  self:UpdateDisplayMode()
  self:RefreshVirus(marchInfo)
end

function TroopHeadUI:RefreshVirus(marchInfo)
  local virusLayer = marchInfo.baseVirusLayer or 0
  if virusLayer <= 0 then
    self:RemoveVirus()
    return
  end
  if self.virusReq == nil then
    local request = ResourceManager:InstantiateAsync(UIAssets.MarchVirus)
    request:completed("+", function()
      if IsNull(request.gameObject) then
        return
      end
      local trans = request.gameObject.transform
      trans:SetParent(self.transform:Find(virus_node_path))
      trans:Set_localScale(0.48, 0.48, 0.48)
      trans:Set_localPosition(0, 0, 0)
      trans:Set_localRotation(0, 0, 0)
      local tmp = trans:Find("Layers"):GetComponent(typeof(CS.TextMeshProEx))
      tmp.text = tostring(virusLayer)
    end)
    self.virusReq = request
    local size = self.name_bg.size
    size.x = 3.15
    self.name_bg.size = size
  end
end

function TroopHeadUI:RemoveVirus()
  if self.virusReq then
    self.virusReq:Destroy()
    self.virusReq = nil
    local size = self.name_bg.size
    size.x = 2.55
    self.name_bg.size = size
  end
end

local function SetSelectRotation(self, marchUuid)
  local troop = CS.SceneManager.World:GetTroop(marchUuid)
  if troop ~= nil then
    local rotation = troop:GetRotation()
    local qua = rotation.eulerAngles
    self.troop_select.gameObject.transform.localRotation = Quaternion.Euler(0, 0, -qua.y)
  end
end

local function SetName(self, name, allianceAbbr, tileIndex)
  self.city_troop_name_bg.gameObject:SetActive(false)
  self.name_bg.gameObject:SetActive(true)
  self.back_bg.gameObject:SetActive(true)
  if allianceAbbr ~= nil and allianceAbbr ~= "" then
    self.player_name.text = "[" .. allianceAbbr .. "] " .. name
    self.attack_name.text = "[" .. allianceAbbr .. "] " .. name
  else
    self.player_name.text = name
    self.attack_name.text = name
  end
  local size = self.name_bg.size
  size.x = 2.55
  self.name_bg.size = size
  self.tileIndex = tileIndex
  if tileIndex ~= nil and tileIndex ~= 0 then
    local pos = SceneUtils.IndexToTilePos(tileIndex)
    local strX = string.format("<u>%s", pos.x)
    local strY = string.format("%s</u>", pos.y)
    if self.targetServer ~= nil and self.targetServer ~= 0 and SeasonUtil.InSeasonBigMapMode(self.targetServer) then
      local str = string.format("#%s(%s,%s)", self.targetServer, strX, strY)
      self.march_end.text = Localization:GetString("season_mastery_s3_UI_22", str)
    else
      self.march_end.text = Localization:GetString(GameDialogDefine.DESTINATION, strX, strY)
    end
  else
    self.march_end.text = ""
  end
end

local function SetHeadCircle(self, marchInfo)
  local camp = DataCenter.WorldTroopLineManager:GetCamp(marchInfo)
  local nameColor = DataCenter.WorldTroopLineManager:GetColor(camp, WorldTroopColorType.name)
  local lineColor = DataCenter.WorldTroopLineManager:GetColor(camp, WorldTroopColorType.line)
  self.player_name.color32 = nameColor
  self.attack_name.color32 = nameColor
  self.solider_num.color32 = nameColor
  self.troop_select.color = lineColor
end

local function SetHP(self, hp, maxhp)
  self.hp_red_slider:Init(math.max(maxhp, 1), self.cacheBloodHp)
  local percent = hp / math.max(maxhp, 1)
  self.hp_spr.gameObject:SetActive(true)
  self.cacheBloodHp = hp
  self.hp_slider:Init(math.max(maxhp, 1), hp)
end

local function SetAnger(self, anger, maxAnger)
  if maxAnger ~= nil and 0 < maxAnger and maxAnger <= anger then
    self.anger_effect:SetActive(false)
    self.anger_effect:SetActive(true)
  end
  self.anger_slider:Init(math.max(maxAnger, 1), anger)
end

local function SetSoldierNum(self, num)
  if self.cacheSoldierNum ~= num then
    self.solider_num.text = ""
    self.cacheSoldierNum = num
  end
end

local function ShowCityTroopInfo(self)
  self.city_troop_name_bg.gameObject:SetActive(true)
  self.name_bg.gameObject:SetActive(false)
  self.back_bg.gameObject:SetActive(false)
  self.city_troop_name.text = Localization:GetString("141013")
  self.solider_num.text = ""
  self.head_bg.material = self.normalMaterial
  self.head_icon.material = self.normalMaterial
  self.head_bg:LoadSprite("Assets/Main/Sprites/UI/UIHeroCommon/cfm_yingxiong_touxiangkuang_fang_2.png")
  self.anger_spr.gameObject:SetActive(false)
  self.hp_spr.gameObject:SetActive(false)
  self.select_obj.gameObject:SetActive(false)
  self.attack_name_obj:SetActive(false)
  self.head_icon:LoadSprite(LoadPath.HeroIconsSmallPath .. "round_hero_icon_dacongming")
end

local function SetSelectCircle(self, value)
  self.select_obj.gameObject:SetActive(value)
  self.name_bg.gameObject:SetActive(value)
  self.back_bg.gameObject:SetActive(value)
end

local function ShowBattleRedName(self)
  if self.curTxtColor ~= WorldRedColor32 then
    self.curTxtColor = WorldRedColor32
    self.player_name.color32 = WorldRedColor32
    self.attack_name.color32 = WorldRedColor32
    self.solider_num.color32 = WorldRedColor32
    self.troop_select.color = WorldRedColor
  end
end

local function SetForWasteland(self, gameObject)
  local icon = LoadPath.HeroIconsSmallPath .. "hero_icon_1006"
  self.head_icon:LoadSprite(icon)
  local heroName = Localization:GetString("151006")
  self:SetName(heroName)
  self.name_bg.gameObject:SetActive(false)
  self.back_bg.gameObject:SetActive(false)
  self:SetHP(1, 1)
end

local function OnClick(self)
  if self.marchUuid ~= nil and self.marchUuid ~= 0 then
    UIUtil.OnClickWorldTroop(self.marchUuid)
  end
end

local function OnEndBtnClick(self)
  if self.tileIndex then
    local worldPos = SceneUtils.TileIndexToWorld(self.tileIndex, ForceChangeScene.World, self.targetServer)
    GoToUtil.GotoWorldPos(worldPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
    end, self.targetServer, self.worldId, self.worldType)
  end
end

function TroopHeadUI:UpdateDisplayMode()
  if self.marchInfo == nil then
    return
  end
  if IsNull(self.troop_pin) then
    return
  end
  local showPin = DisplaySettings.ShowTroopPin()
  local marchInfo = self.marchInfo
  local newMarchType = marchInfo:GetMarchType()
  if newMarchType == NewMarchType.NORMAL or newMarchType == NewMarchType.CROSS_NORMAL or newMarchType == NewMarchType.FAKE_ATTACK then
    if showPin then
      SeasonUtil.UpdateTroopIconByMarchInfo(marchInfo, self.troop_pin)
    end
    self.troop_pin.gameObject:SetActive(showPin)
  else
    self.troop_pin.gameObject:SetActive(false)
  end
  local ownerLightUuid = toInt(marchInfo.ownerLightUuid)
  if showPin or ownerLightUuid <= 0 then
    if self.LightRoot ~= nil then
      self.LightRoot:SetActive(false)
    end
  else
    local canShowEffect = WorldSimpleModeUtils.CanShowTroopLight()
    if canShowEffect then
      if self.LightRoot == nil then
        local troop = CS.SceneManager.World:GetTroop(self.marchUuid)
        if troop ~= nil then
          self.LightRoot = WorldTroopLightEffect.New("TroopLight", self.transform, "Assets/_Art_LastWar/Effect/Prefab/S4/Eff_ljw_s4_budui_light.prefab")
          local quaternion = troop:GetRotation()
          self.LightRoot:SetRotation(quaternion.x, quaternion.y, quaternion.z, quaternion.w)
        end
      else
        self.LightRoot:UpdateDisplayLevel()
      end
    elseif self.LightRoot ~= nil then
      self.LightRoot:UpdateDisplayLevel()
    end
  end
end

TroopHeadUI.SetForWasteland = SetForWasteland
TroopHeadUI.OnCreate = OnCreate
TroopHeadUI.OnDestroy = OnDestroy
TroopHeadUI.ComponentDefine = ComponentDefine
TroopHeadUI.ComponentDestroy = ComponentDestroy
TroopHeadUI.ShowMarchInfo = ShowMarchInfo
TroopHeadUI.SetName = SetName
TroopHeadUI.SetHeadCircle = SetHeadCircle
TroopHeadUI.SetHP = SetHP
TroopHeadUI.SetAnger = SetAnger
TroopHeadUI.SetSoldierNum = SetSoldierNum
TroopHeadUI.SetSelectRotation = SetSelectRotation
TroopHeadUI.ShowExploreInfo = ShowExploreInfo
TroopHeadUI.ShowInBattleMarch = ShowInBattleMarch
TroopHeadUI.SetTransformPositon = SetTransformPositon
TroopHeadUI.ShowAnger = ShowAnger
TroopHeadUI.ShowUseSkill = ShowUseSkill
TroopHeadUI.CreateUseSkillEffect = CreateUseSkillEffect
TroopHeadUI.Hit = Hit
TroopHeadUI.ShowCityTroopInfo = ShowCityTroopInfo
TroopHeadUI.SetSelectCircle = SetSelectCircle
TroopHeadUI.ShowBattleRedName = ShowBattleRedName
TroopHeadUI.OnClick = OnClick
TroopHeadUI.OnEndBtnClick = OnEndBtnClick
return TroopHeadUI
