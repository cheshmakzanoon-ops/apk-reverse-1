local UILWSeasonCityOccupyListS6Item = BaseClass("UILWSeasonCityOccupyListS6Item", UIBaseContainer)
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
local title_root_path = "Status/title"
local res_icon2_path = "popup/res_icon2"
local res_count_path = "popup/res_count"
local popup_path = "popup"

function UILWSeasonCityOccupyListS6Item:OnCreate()
  base.OnCreate(self)
  self.bg_white = self:AddComponent(UIImage, bg_white_path)
  self.building = self:AddComponent(UIButton, building_path)
  self.city = self:AddComponent(UIBaseContainer, city_path)
  self.king = self:AddComponent(UIBaseContainer, king_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.status = self:AddComponent(UIImage, status_path)
  self.res_icon = self:AddComponent(UIImage, res_icon_path)
  self.members = self:AddComponent(UIImage, members_path)
  self.member_icon = self:AddComponent(UIImage, member_icon_path)
  self.member_text = self:AddComponent(UITextMeshProUGUIEx, member_text_path)
  self.popup = self:AddComponent(UIButton, popup_path)
  self.res_icon2 = self:AddComponent(UIImage, res_icon2_path)
  self.res_count = self:AddComponent(UITextMeshProUGUIEx, res_count_path)
  self.popup:SetOnClick(function()
    if self.cityId then
      self.tryGetReward = true
      if self.city_type == WorldAllianceCityType.City then
        SFSNetwork.SendMessage(MsgDefines.CollectAllianceCityResource, self.serverId, self.cityId)
      else
        SFSNetwork.SendMessage(MsgDefines.CollectStrongholdResource, self.serverId, self.cityId)
      end
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

function UILWSeasonCityOccupyListS6Item:ShowTips()
  if self.effectId ~= nil then
    self.tooltip:SetAlpha(0)
    self.tooltip:SetActive(true)
    self.tooltip:FadeIn(0.3)
    self.tooltip.transform:DORotate(Vector3.zero, 0.2)
    self.tooltip_tick = 2
    self.popup:SetActive(false)
  end
end

function UILWSeasonCityOccupyListS6Item:OnClick()
  self:ShowTips()
end

function UILWSeasonCityOccupyListS6Item:HideTips()
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

function UILWSeasonCityOccupyListS6Item:OnDestroy()
  self.bg_white = nil
  self.building = nil
  self.txtLevel = nil
  self.txt_product = nil
  self.text = nil
  self.text_join_battle = nil
  base.OnDestroy(self)
end

function UILWSeasonCityOccupyListS6Item:ReInit(index, dataConfig, isCity)
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local cityId = toInt(dataConfig.id)
  self.index = index
  self.dataConfig = dataConfig
  self.cityPos = dataConfig.pos
  self.cityId = cityId
  self.serverId = dataConfig:GetCurServerId(mySourceServerId)
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
  self.city_type = dataConfig.type
  if dataConfig.type == WorldAllianceCityType.City or isCity then
    self.members:SetActive(false)
    self.popup:SetActive(false)
    self.icon:SetColorRGBA(1, 1, 1, 1)
    if dataConfig then
      local itemProductId = dataConfig.itemProductId
      local itemProductCount = dataConfig.itemProductCount
      if itemProductId == nil or itemProductCount == nil then
        self.status:SetActive(false)
      elseif itemProductId and itemProductCount then
        local meta = DataCenter.ItemTemplateManager:TryGetItemTemplate(itemProductId)
        if meta then
          local seasonIndex = SeasonUtil.GetSeason()
          local icon, name, desc, name_value = meta:GetDetailInfo(seasonIndex)
          local iconUrl = string.format(LoadPath.ItemPath, icon)
          self.res_icon:SetActive(true)
          self.res_icon:LoadSprite(iconUrl)
          self.res_icon2:LoadSprite(iconUrl)
        end
        self.status:SetActive(true)
      else
        self.status:SetActive(false)
        self.res_icon:LoadSprite("Assets/Main/Sprites/ItemIcons/LXY_s5_jinjiejing_icon.png")
        self.res_icon2:LoadSprite("Assets/Main/Sprites/ItemIcons/LXY_s5_jinjiejing_icon.png")
      end
    end
    self:CheckCityResProduct()
  elseif dataConfig.type == WorldAllianceCityType.Stronghold then
    self.members:SetActive(true)
    self.status:SetActive(false)
    self.popup:SetActive(false)
    self.member_icon:LoadSprite("Assets/Main/SeasonRes/S6/Sprites/CommonS6/zxl_cundan_tubiao.png")
    self.res_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.FLINT))
    self.res_icon2:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.FLINT))
    if dataConfig then
      local resProductDict = dataConfig.resProductDict
      if resProductDict then
        for strResId, nResCount in pairs(resProductDict) do
          local resId = toInt(strResId)
          if 0 < resId and resId ~= ResourceType.FLINT then
            self.res_icon2:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(resId))
          end
        end
      end
    end
    self:CheckStrongholdResProduct()
  else
    self.members:SetActive(false)
    self.popup:SetActive(false)
    self.status:SetActive(false)
  end
  local serverId = DataCenter.SeasonDataManager:GetNinePalacesServer(dataConfig.bigMapIndex)
  self.serverId = serverId
  self.text:SetText(string.format("<color=#0C9C4A><u>#%s X:%s Y:%s</u></color>", serverId, dataConfig.pos.x, dataConfig.pos.y))
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
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.title_root.rectTransform)
end

function UILWSeasonCityOccupyListS6Item:CheckCityResProduct()
  local dummyData = false
  local dataConfig = self.dataConfig
  if dataConfig == nil or dataConfig.type ~= WorldAllianceCityType.City then
    self.popup:SetActive(false)
    return
  end
  local itemProductId = dataConfig.itemProductId
  local itemProductCount = dataConfig.itemProductCount
  if itemProductId == nil or itemProductCount == nil then
    self.txt_product:SetText("+0/h")
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
  self.popup:SetActive(0 < leftNum)
  if 0 < leftNum then
    self.res_count:SetText(string.GetFormattedStr(leftNum * itemProductCount))
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
    self.txt_product:SetText("+" .. string.GetFormattedSeparatorNum(itemProductCount) .. "/h")
  end
end

function UILWSeasonCityOccupyListS6Item:CheckStrongholdResProduct()
  self:CheckStrongholdMember()
  local dummyData = false
  local dataConfig = self.dataConfig
  if dataConfig == nil or dataConfig.type ~= WorldAllianceCityType.Stronghold or dataConfig.season_snow_coal_value == nil then
    self.popup:SetActive(false)
    self.txt_product:SetText("+0/h")
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
  self.popup:SetActive(0 < leftNum)
  if 0 < leftNum then
    self.res_count:SetText(string.GetFormattedStr(leftNum * dataConfig.season_snow_coal_value))
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

function UILWSeasonCityOccupyListS6Item:CheckStrongholdMember()
  local list, value = DataCenter.SeasonDataManager.CrossOccupyStrongholdList
  if list then
    for _, v in ipairs(list) do
      if v.id == self.cityId then
        value = v
      end
    end
  end
  self.member_text:SetLocalText(135225, value and value.curDepositNum or 0, self.dataConfig.max_player or 0)
end

function UILWSeasonCityOccupyListS6Item:Update1000MS()
  if self.effectId ~= nil and self.tooltip_tick ~= nil and self.tooltip_tick > 0 then
    self.tooltip_tick = self.tooltip_tick - 1
    if self.tooltip_tick <= 0 then
      self:HideTips()
    end
  end
end

function UILWSeasonCityOccupyListS6Item:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CollectAllianceCityResourceSuccess, self.OnCollectResourceSuccess)
  self:AddUIListener(EventId.CollectStrongholdResourceSuccess, self.OnCollectResourceSuccess)
  self:AddUIListener(EventId.BatchCollectStrongholdResourceSuccess, self.OnBatchCollectResourceSuccess)
end

function UILWSeasonCityOccupyListS6Item:OnRemoveListener()
  self:RemoveUIListener(EventId.CollectAllianceCityResourceSuccess, self.OnCollectResourceSuccess)
  self:RemoveUIListener(EventId.CollectStrongholdResourceSuccess, self.OnCollectResourceSuccess)
  self:RemoveUIListener(EventId.BatchCollectStrongholdResourceSuccess, self.OnBatchCollectResourceSuccess)
  base.OnRemoveListener(self)
end

function UILWSeasonCityOccupyListS6Item:OnCollectResourceSuccess(t)
  if t and (t.cityId == self.cityId or t.strongholdId == self.cityId) and self.popup then
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

function UILWSeasonCityOccupyListS6Item:OnBatchCollectResourceSuccess(serverId)
  if serverId == self.serverId and self.popup then
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.Music_Effect_Task_Done_Btn)
    self.popup:SetActive(false)
  end
end

return UILWSeasonCityOccupyListS6Item
