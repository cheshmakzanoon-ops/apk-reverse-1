local UILWSeasonCityOccupyListS6PondItem = BaseClass("UILWSeasonCityOccupyListS6PondItem", UIBaseContainer)
local base = UIBaseContainer
local bg_white_path = "bgWhite"
local building_path = "building"
local level_path = "txtLevel"
local text_path = "Pos/Text"
local pos_path = "Pos"
local members_path = "Members"
local member_icon_path = "Members/title/memberIcon"
local member_text_path = "Members/title/memberTxt"
local city_path = "building/city"
local king_path = "building/king"
local icon_path = "building/icon"
local tooltip_path = "tooltip"
local tooltip_value_path = "tooltip/tooltip_value"
local tooltip_key_path = "tooltip/tooltip_key"
local close_btn_path = "tooltip/closeBtn"
local res_icon2_path = "popup/res_icon2"
local res_count_path = "popup/res_count"
local popup_path = "popup"

function UILWSeasonCityOccupyListS6PondItem:OnCreate()
  base.OnCreate(self)
  self.bg_white = self:AddComponent(UIImage, bg_white_path)
  self.building = self:AddComponent(UIButton, building_path)
  self.city = self:AddComponent(UIBaseContainer, city_path)
  self.king = self:AddComponent(UIBaseContainer, king_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.member_text = self:AddComponent(UITextMeshProUGUIEx, member_text_path)
  self.popup = self:AddComponent(UIButton, popup_path)
  self.res_icon2 = self:AddComponent(UIImage, res_icon2_path)
  self.res_count = self:AddComponent(UITextMeshProUGUIEx, res_count_path)
  self.popup:SetOnClick(function()
    if self.cityId then
      self.tryGetReward = true
      SFSNetwork.SendMessage(MsgDefines.SeasonFishGatherFishPondEnergy)
    end
  end)
  self.txtLevel = self:AddComponent(UITextMeshProUGUIEx, level_path)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.pos_btn = self:AddComponent(UIButton, pos_path)
  self.pos_btn:SetOnClick(function()
    if self.cityPos ~= nil and self.cityPos.x ~= nil and self.cityPos.y ~= nil then
      local v3 = SceneUtils.TileToWorld(self.cityPos, ForceChangeScene.World)
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, nil, nil, self.serverId)
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

function UILWSeasonCityOccupyListS6PondItem:ShowTips()
  if self.effectId ~= nil then
    self.tooltip:SetAlpha(0)
    self.tooltip:SetActive(true)
    self.tooltip:FadeIn(0.3)
    self.tooltip.transform:DORotate(Vector3.zero, 0.2)
    self.tooltip_tick = 2
  end
end

function UILWSeasonCityOccupyListS6PondItem:OnClick()
  self:ShowTips()
end

function UILWSeasonCityOccupyListS6PondItem:HideTips()
  if self.effectId ~= nil then
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    sequence:Append(self.tooltip:FadeOut(0.3))
    sequence:Join(self.tooltip.transform:DORotate(Vector3.New(0, 90, 0), 0.2))
    sequence:OnComplete(function()
      self.tooltip:SetActive(false)
    end)
    self.tooltip_tick = 0
  end
  self:CheckStrongholdResProduct()
  self:CheckCityResProduct()
end

function UILWSeasonCityOccupyListS6PondItem:OnDestroy()
  self.bg_white = nil
  self.building = nil
  self.txtLevel = nil
  self.text = nil
  base.OnDestroy(self)
end

function UILWSeasonCityOccupyListS6PondItem:ReInit(index, dataConfig, isCity)
  local cityId = toInt(dataConfig.id)
  self.index = index
  self.dataConfig = dataConfig
  self.cityPos = dataConfig.pos
  self.cityId = cityId
  self.serverId = dataConfig:GetSourceServerId()
  self.txtLevel:SetLocalText("300665", dataConfig.level)
  self.city:SetActive(false)
  self.king:SetActive(false)
  self.icon:SetActive(true)
  self.icon:LoadSprite(dataConfig:GetIconPath(false))
  self.city_type = dataConfig.type
  if dataConfig.type == WorldAllianceCityType.Stronghold then
    self.popup:SetActive(false)
    self.res_icon2:LoadSpriteAsync(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Petroleum))
    self:CheckStrongholdResProduct()
  end
  local serverId = DataCenter.SeasonDataManager:GetNinePalacesServer(dataConfig.bigMapIndex)
  self.serverId = serverId
  self.text:SetText(string.format("#%s X:%s Y:%s", serverId, dataConfig.pos.x, dataConfig.pos.y))
  self.effectId = nil
  self.effectValue = nil
  if dataConfig.buff ~= nil and dataConfig.buff ~= "" then
    local effectId, effectValue = string.split_ss(dataConfig.buff, ";")
    if effectId ~= nil and effectValue ~= nil then
      local buffAddNum, effectName = UIUtil.GetEffectStr(nil, effectValue, effectId)
      if buffAddNum ~= nil then
        self.tooltip_key:SetLocalText(effectName)
        self.tooltip_value:SetText(buffAddNum)
        self.effectId = effectId
        self.effectValue = effectValue
      end
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.text.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.pos_btn.rectTransform)
end

function UILWSeasonCityOccupyListS6PondItem:CheckCityResProduct()
  local dummyData = false
  local dataConfig = self.dataConfig
  if dataConfig == nil or dataConfig.type ~= WorldAllianceCityType.City then
    self.popup:SetActive(false)
    return
  end
  local itemProductId = dataConfig.itemProductId
  local itemProductCount = dataConfig.itemProductCount
  if itemProductId == nil or itemProductCount == nil then
    return
  end
  local leftNum = 0
  local RewardInfo = DataCenter.SeasonDataManager.CrossOccupyCityRewardInfo
  if RewardInfo and 0 < #RewardInfo then
    for _, v in ipairs(RewardInfo) do
      if v.id == self.cityId then
        leftNum = toInt(v.leftNum)
        dummyData = v.dummyData
        break
      end
    end
  end
  self.popup:SetActive(false)
  if 0 < leftNum then
    self.res_count:SetText(string.GetFormattedStr(leftNum * itemProductCount))
  end
  if dummyData then
    self.icon:SetColorRGBA(1, 1, 1, 0.3)
    CS.UIGray.SetGray(self.bg_white.transform, true, false)
  else
    self.icon:SetColorRGBA(1, 1, 1, 1)
    CS.UIGray.SetGray(self.bg_white.transform, false, false)
  end
end

function UILWSeasonCityOccupyListS6PondItem:CheckStrongholdResProduct()
  self:CheckStrongholdMember()
  local dummyData = false
  local dataConfig = self.dataConfig
  if dataConfig == nil or dataConfig.type ~= WorldAllianceCityType.Stronghold or dataConfig.season_snow_coal_value == nil then
    self.popup:SetActive(false)
    return
  end
  local leftNum = 0
  local RewardInfo = DataCenter.SeasonDataManager.CrossOccupyStrongholdRewardInfo
  if RewardInfo and 0 < #RewardInfo then
    for _, v in ipairs(RewardInfo) do
      if v.id == self.cityId then
        leftNum = toInt(v.leftNum)
        dummyData = v.dummyData
        break
      end
    end
  end
  self.popup:SetActive(false)
  if 0 < leftNum then
    self.res_count:SetText(string.GetFormattedStr(leftNum * dataConfig.season_snow_coal_value))
  end
  if dummyData then
    self.icon:SetColorRGBA(1, 1, 1, 0.3)
    CS.UIGray.SetGray(self.bg_white.transform, true, false)
  else
    self.icon:SetColorRGBA(1, 1, 1, 1)
    CS.UIGray.SetGray(self.bg_white.transform, false, false)
  end
end

function UILWSeasonCityOccupyListS6PondItem:CheckStrongholdMember()
  local list, value = DataCenter.SeasonDataManager.CrossOccupyStrongholdList
  if list then
    for _, v in ipairs(list) do
      if v.id == self.cityId then
        value = v
      end
    end
  end
  self.member_text:SetText((value and value.fishPlayerNum or 0) .. "/" .. (self.dataConfig.max_fisher or 150))
end

function UILWSeasonCityOccupyListS6PondItem:Update1000MS()
  if self.effectId ~= nil and self.tooltip_tick ~= nil and self.tooltip_tick > 0 then
    self.tooltip_tick = self.tooltip_tick - 1
    if self.tooltip_tick <= 0 then
      self:HideTips()
    end
  end
end

function UILWSeasonCityOccupyListS6PondItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnSeasonFishGatherFishPondEnergy, self.OnSeasonFishGatherFishPondEnergy)
end

function UILWSeasonCityOccupyListS6PondItem:OnRemoveListener()
  self:RemoveUIListener(EventId.OnSeasonFishGatherFishPondEnergy, self.OnSeasonFishGatherFishPondEnergy)
  base.OnRemoveListener(self)
end

function UILWSeasonCityOccupyListS6PondItem:OnSeasonFishGatherFishPondEnergy()
  if self.popup then
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.Music_Effect_Task_Done_Btn)
    self.popup:SetActive(false)
  end
end

return UILWSeasonCityOccupyListS6PondItem
