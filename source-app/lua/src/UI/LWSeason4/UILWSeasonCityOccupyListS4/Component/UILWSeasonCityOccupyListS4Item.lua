local UILWSeasonCityOccupyListS4Item = BaseClass("UILWSeasonCityOccupyListS4Item", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local bg_white_path = "bgWhite"
local building_path = "building"
local level_path = "txtLevel"
local txt_product_path = "Status/title/txtStatus"
local text_path = "Pos/Text"
local text_join_battle_path = "Pos/TextJoinBattle"
local pos_path = "Pos"
local status_path = "Status"
local res_icon_path = "Status/title/res_icon"
local city_path = "building/city"
local king_path = "building/king"
local icon_path = "building/icon"
local tooltip_path = "tooltip"
local tooltip_value_path = "tooltip/tooltip_value"
local tooltip_key_path = "tooltip/tooltip_key"
local close_btn_path = "tooltip/closeBtn"
local title_root_path = "Status/title"
local res_icon2_path = "popup/res_icon2"
local res_count_path = "popup/res_count"
local popup_path = "popup"

function UILWSeasonCityOccupyListS4Item:OnCreate()
  base.OnCreate(self)
  self.bg_white = self:AddComponent(UIImage, bg_white_path)
  self.building = self:AddComponent(UIButton, building_path)
  self.city = self:AddComponent(UIBaseContainer, city_path)
  self.king = self:AddComponent(UIBaseContainer, king_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.status = self:AddComponent(UIImage, status_path)
  self.res_icon = self:AddComponent(UIImage, res_icon_path)
  self.popup = self:AddComponent(UIButton, popup_path)
  self.res_icon2 = self:AddComponent(UIImage, res_icon2_path)
  self.res_count = self:AddComponent(UITextMeshProUGUIEx, res_count_path)
  self.popup:SetOnClick(function()
    if self.cityId then
      self.tryGetReward = true
      SFSNetwork.SendMessage(MsgDefines.CollectStrongholdResource, LuaEntry.Player:GetSourceServerId(), self.cityId)
    end
  end)
  self.title_root = self:AddComponent(UIBaseContainer, title_root_path)
  self.txtLevel = self:AddComponent(UITextMeshProUGUIEx, level_path)
  self.txt_product = self:AddComponent(UITextMeshProUGUIEx, txt_product_path)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.text_join_battle = self:AddComponent(UITextMeshProUGUIEx, text_join_battle_path)
  self.pos_btn = self:AddComponent(UIButton, pos_path)
  self.pos_btn:SetOnClick(function()
    if self.cityPos ~= nil and self.cityPos.x ~= nil and self.cityPos.y ~= nil then
      local v3 = SceneUtils.TileToWorld(self.cityPos, ForceChangeScene.World)
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, nil, nil, LuaEntry.Player:GetSourceServerId())
    end
  end)
  self.building:SetOnClick(function()
    self:OnClick()
  end)
  self.tooltip = self:AddComponent(UICanvasGroup, tooltip_path)
  self.tooltip_value = self:AddComponent(UIText, tooltip_value_path)
  self.tooltip_key = self:AddComponent(UIText, tooltip_key_path)
  self.tooltip_close_btn = self:AddComponent(UIButton, close_btn_path)
  self.tooltip:SetActive(false)
  self.tooltip:SetAlpha(0)
  self.tooltip.transform:Rotate(0, 90, 0)
  self.tooltip_close_btn:SetOnClick(function()
    self:HideTips()
  end)
  self.popup:SetActive(false)
  self.tryGetReward = nil
end

function UILWSeasonCityOccupyListS4Item:ShowTips()
  if self.effectId ~= nil then
    self.tooltip:SetAlpha(0)
    self.tooltip:SetActive(true)
    self.tooltip:FadeIn(0.3)
    self.tooltip.transform:DORotate(Vector3.zero, 0.2)
    self.tooltip_tick = 2
    self.popup:SetActive(false)
  end
end

function UILWSeasonCityOccupyListS4Item:OnClick()
  self:ShowTips()
end

function UILWSeasonCityOccupyListS4Item:HideTips()
  if self.effectId ~= nil then
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    sequence:Append(self.tooltip:FadeOut(0.3))
    sequence:Join(self.tooltip.transform:DORotate(Vector3.New(0, 90, 0), 0.2))
    sequence:OnComplete(function()
      self.tooltip:SetActive(false)
    end)
    self.tooltip_tick = 0
  end
  self:CheckResProduct()
end

function UILWSeasonCityOccupyListS4Item:OnDestroy()
  self.bg_white = nil
  self.building = nil
  self.txtLevel = nil
  self.txt_product = nil
  self.text = nil
  self.text_join_battle = nil
  base.OnDestroy(self)
end

function UILWSeasonCityOccupyListS4Item:ReInit(index, dataConfig, isCity, ghostKingStatusList)
  local cityId = toInt(dataConfig.id)
  local seasonType = SeasonUtil.GetSeasonType()
  self.index = index
  self.dataConfig = dataConfig
  self.cityPos = dataConfig.pos
  self.cityId = cityId
  self.isGhostKingBattle = false
  self.isGhostKingAlive = false
  if ghostKingStatusList then
    local ghostKing = ghostKingStatusList[cityId]
    if ghostKing then
      self.isGhostKingBattle = ghostKing.isGhostKingBattle
      self.isGhostKingAlive = ghostKing.isGhostKingAlive
    end
  end
  self.txtLevel:SetLocalText("300665", dataConfig.level)
  self.city:SetActive(false)
  self.king:SetActive(false)
  self.icon:SetActive(true)
  self.icon:LoadSprite(dataConfig:GetIconPath(false))
  self.res_icon:SetActive(true)
  self.bg_white:SetActive(true)
  self.text_join_battle:SetActive(false)
  self.text:SetColorHex("#ffffff")
  self.txt_product:SetColorHex("#ffffff")
  if dataConfig.type == WorldAllianceCityType.City or isCity then
    self.status:SetActive(true)
    self.popup:SetActive(false)
    self.icon:SetColorRGBA(1, 1, 1, 1)
    self.bg_white:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/AttackCity/zyf_s2_chegnshi_bg_1.png")
    self.status:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/AttackCity/zyf_s2_chegnshi_bg_2.png")
    self.res_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.AllianceStone))
    self.txt_product:SetText("+" .. string.GetFormattedSeparatorNum(dataConfig.season_snow_stone_value) .. "/h")
    CS.UIGray.SetGray(self.bg_white.transform, false, false)
    CS.UIGray.SetGray(self.status.transform, false, false)
    if dataConfig then
      local resId = toInt(dataConfig.season_snow_stone_id)
      if 0 < resId and resId ~= ResourceType.AllianceStone then
        self.res_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(resId))
      end
    end
    if self.isGhostKingAlive then
      self:CheckGhostKingStatus()
    end
  elseif dataConfig.type == WorldAllianceCityType.Stronghold then
    self.status:SetActive(true)
    self.popup:SetActive(false)
    self.bg_white:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/AttackCity/mjc_s2_chegnshi_bg_1.png")
    self.status:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/AttackCity/mjc_s2_chegnshi_bg_2.png")
    self.res_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.FLINT))
    self.res_icon2:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.FLINT))
    if dataConfig then
      local resProductDict = dataConfig.resProductDict
      if resProductDict then
        for strResId, nResCount in pairs(resProductDict) do
          local resId = toInt(strResId)
          if 0 < resId and resId ~= ResourceType.FLINT then
            self.res_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(resId))
            self.res_icon2:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(resId))
          end
        end
      end
    end
    self:CheckResProduct()
  else
    self.popup:SetActive(false)
    self.status:SetActive(false)
  end
  self.text:SetText("<u>X:" .. dataConfig.pos.x .. " Y:" .. dataConfig.pos.y .. "</u>")
  self.effectId = nil
  self.effectValue = nil
  if dataConfig.buff ~= nil and dataConfig.buff ~= "" then
    local effectId, effectValue = string.match(dataConfig.buff, "(%d+);(%d+[.]?%d+)")
    if effectId ~= nil and effectValue ~= nil then
      local buffAddNum, effectName = UIUtil.GetEffectStr(nil, effectValue, effectId)
      if buffAddNum ~= nil then
        if self.isGhostKingAlive then
          local msg1 = Localization:GetString(effectName)
          local msg2 = Localization:GetString("season_s4_monster_tips26")
          self.tooltip_key:SetText(string.format([[
%s
<size=26>%s</size>]], msg1, msg2))
          self.tooltip_value:SetText(string.format("<color=#fd7156>%s</color>", buffAddNum))
        else
          self.tooltip_key:SetLocalText(effectName)
          self.tooltip_value:SetText(buffAddNum)
        end
        self.effectId = effectId
        self.effectValue = effectValue
      end
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.pos_btn.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.title_root.rectTransform)
end

function UILWSeasonCityOccupyListS4Item:CheckGhostKingStatus()
  if self.isGhostKingAlive then
    if not DataCenter.BloodyNightDataManager:IsBloodyNight() then
      return
    end
    local monsterId = 4044000 + toInt(self.dataConfig.level)
    local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
    if monster ~= nil then
      self.text_join_battle:SetActive(true)
      self.icon:SetActive(true)
      self.icon:LoadSpriteAuto(monster:GetIcon())
      self.res_icon:SetActive(false)
      if self.isGhostKingBattle then
        self.txt_product:SetLocalText("season_s4_monster_tips19")
      else
        self.txt_product:SetLocalText("season_s4_monster_tips18")
      end
      self.txt_product:SetColorHex("#fd7156")
      self.text:SetColorHex("#fd7156")
      self.text_join_battle:SetColorHex("#fd7156")
    end
  end
end

function UILWSeasonCityOccupyListS4Item:CheckResProduct()
  local dummyData = false
  local dataConfig = self.dataConfig
  if dataConfig == nil or dataConfig.type ~= WorldAllianceCityType.Stronghold then
    self.popup:SetActive(false)
    return
  end
  local hasCoal = 0
  local RewardInfo = DataCenter.SeasonDataManager.CrossOccupyStrongholdRewardInfo
  if RewardInfo and 0 < #RewardInfo then
    for _, v in ipairs(RewardInfo) do
      if v.id == self.cityId then
        hasCoal = toInt(v.leftNum)
        dummyData = v.dummyData
        break
      end
    end
  end
  self.popup:SetActive(0 < hasCoal)
  if 0 < hasCoal then
    self.res_count:SetText(string.GetFormattedStr(hasCoal * dataConfig.season_snow_coal_value))
  end
  if dummyData then
    self.txt_product:SetText("+0/h")
    self.icon:SetColorRGBA(1, 1, 1, 0.3)
    CS.UIGray.SetGray(self.bg_white.transform, true, false)
    CS.UIGray.SetGray(self.status.transform, true, false)
  else
    self.icon:SetColorRGBA(1, 1, 1, 1)
    CS.UIGray.SetGray(self.bg_white.transform, false, false)
    CS.UIGray.SetGray(self.status.transform, false, false)
    self.txt_product:SetText("+" .. string.GetFormattedSeparatorNum(dataConfig.season_snow_coal_value) .. "/h")
  end
end

function UILWSeasonCityOccupyListS4Item:Update1000MS()
  if self.effectId ~= nil and self.tooltip_tick ~= nil and self.tooltip_tick > 0 then
    self.tooltip_tick = self.tooltip_tick - 1
    if self.tooltip_tick <= 0 then
      self:HideTips()
    end
  end
end

function UILWSeasonCityOccupyListS4Item:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CollectStrongholdResourceSuccess, self.OnCollectResourceSuccess)
  self:AddUIListener(EventId.BatchCollectStrongholdResourceSuccess, self.OnBatchCollectResourceSuccess)
end

function UILWSeasonCityOccupyListS4Item:OnRemoveListener()
  self:RemoveUIListener(EventId.CollectStrongholdResourceSuccess, self.OnCollectResourceSuccess)
  self:RemoveUIListener(EventId.BatchCollectStrongholdResourceSuccess, self.OnBatchCollectResourceSuccess)
  base.OnRemoveListener(self)
end

function UILWSeasonCityOccupyListS4Item:OnCollectResourceSuccess(t)
  if t and t.serverId == LuaEntry.Player:GetSourceServerId() and t.strongholdId == self.cityId and self.popup then
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.Music_Effect_Task_Done_Btn)
    self.popup:SetActive(false)
  elseif t and t.errorCode == "season_s2_tips_004" and self.tryGetReward then
    self.popup:SetActive(false)
    local RewardInfo = DataCenter.SeasonDataManager.CrossOccupyStrongholdRewardInfo
    if RewardInfo then
      for _, v in ipairs(RewardInfo) do
        if v.id == self.cityId then
          v.leftNum = 0
        end
      end
    end
  end
  self.tryGetReward = nil
end

function UILWSeasonCityOccupyListS4Item:OnBatchCollectResourceSuccess(serverId)
  if serverId == LuaEntry.Player:GetSourceServerId() and self.popup then
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.Music_Effect_Task_Done_Btn)
    self.popup:SetActive(false)
  end
end

return UILWSeasonCityOccupyListS4Item
