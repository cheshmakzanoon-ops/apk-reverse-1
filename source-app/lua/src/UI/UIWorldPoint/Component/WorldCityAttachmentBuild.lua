local WorldCityAttachmentBuild = BaseClass("WorldCityAttachmentBuild", UIAsyncContainer)
local base = UIAsyncContainer
local LWSeasonAllianceTipsItem = require("UI.LWSeason.LWSeasonAllianceRank.Component.LWSeasonAllianceTipsItem")
local Localization = CS.GameEntry.Localization
local btn_info_path = "info/EffectTxt/btn_info"
local city_effect_key_path = "info/CityEffectKey"
local city_effect_txt_path = "info/CityEffectTxt"
local effect_key_path = "info/EffectKey"
local effect_txt_path = "info/EffectTxt"
local owner_key_path = "info/OwnerKey"
local owner_txt_path = "info/OwnerTxt"
local building_info_path = "BuildingInfo"
local reward_pro_path = "BuildingInfo/Reward/RewardPro"
local reward_value_path = "BuildingInfo/Reward/RewardValue"
local reward_count_path = "BuildingInfo/Reward/RewardCount"
local status_path = "Status"
local status_text_path = "Status/StatusText"
local reward_icon_path = "BuildingInfo/Reward/RewardIcon"
local tip_root_path = "BuildingInfo/Reward/RewardIcon/TipRoot"
local btn_close_tip_path = "BuildingInfo/Reward/RewardIcon/TipRoot/BtnCloseTip"
local tip_box_title_root_path = "BuildingInfo/Reward/RewardIcon/TipRoot/TipBox/Title"
local tip_box_title_path = "BuildingInfo/Reward/RewardIcon/TipRoot/TipBox/Title/TipBoxTitle"
local tip_box_icon_path = "BuildingInfo/Reward/RewardIcon/TipRoot/TipBox/Title/TipBoxIcon"
local tip_box_content_path = "BuildingInfo/Reward/RewardIcon/TipRoot/TipBox/ScrollView/Viewport/TipBoxContent"
local tip_box_item_path = "BuildingInfo/Reward/RewardIcon/TipRoot/TipBox/ScrollView/Viewport/TipBoxContent/TipBoxItem"
local reward_path = "BuildingInfo/Reward"
local reward_only_path = "BuildingInfo/RewardOnly"
local reward_pro_simple_path = "BuildingInfo/RewardOnly/RewardProSimple"
local reward_value_simple_path = "BuildingInfo/RewardOnly/RewardValueSimple"

function WorldCityAttachmentBuild:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function WorldCityAttachmentBuild:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function WorldCityAttachmentBuild:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UPDATE_POINTS_DATA, self.OnPointDateUpdate)
end

function WorldCityAttachmentBuild:OnRemoveListener()
  self:RemoveUIListener(EventId.UPDATE_POINTS_DATA, self.OnPointDateUpdate)
  base.OnRemoveListener(self)
end

function WorldCityAttachmentBuild:ComponentDefine()
  self.reward_icon = self:AddComponent(UIButton, reward_icon_path)
  self.tip_root = self:AddComponent(UICanvasGroup, tip_root_path)
  self.btn_close_tip = self:AddComponent(UIButton, btn_close_tip_path)
  self.tip_root:SetActive(false)
  self.tip_box_title_root = self:AddComponent(UIBaseComponent, tip_box_title_root_path)
  self.tip_box_title = self:AddComponent(UIText, tip_box_title_path)
  self.tip_box_icon = self:AddComponent(UIImage, tip_box_icon_path)
  self.tip_box_content = self:AddComponent(UIBaseContainer, tip_box_content_path)
  self.tipBoxTemplate = self.transform:Find(tip_box_item_path).gameObject
  self.tipBoxTemplate:GameObjectCreatePool()
  self.btn_close_tip:SetOnClick(function()
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    sequence:Join(self.tip_root:FadeOut(0.2))
    sequence:Join(self.tip_root.transform:DOScale(Vector3.New(0.7, 0, 0.7), 0.2))
    sequence:AppendCallback(function()
      if self.tip_root then
        self.tip_root:SetActive(false)
      end
    end)
  end)
  self.reward_icon:SetOnClick(function()
    if self.tip_root:GetActive() and self.tip_root:GetAlpha() ~= 0 then
      return
    end
    self.tip_root:SetAlpha(0)
    self.tip_root:SetActive(true)
    self:InitRewardTips()
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    sequence:Join(self.tip_root:FadeIn(0.2))
    sequence:Join(self.tip_root.transform:DOScale(Vector3.New(0.7, 0.7, 0.7), 0.2))
  end)
  self.city_effect_key = self:AddComponent(UITextMeshProUGUIEx, city_effect_key_path)
  self.city_effect_txt = self:AddComponent(UITextMeshProUGUIEx, city_effect_txt_path)
  self.effect_key = self:AddComponent(UITextMeshProUGUIEx, effect_key_path)
  self.effect_txt = self:AddComponent(UITextMeshProUGUIEx, effect_txt_path)
  self.owner_key = self:AddComponent(UITextMeshProUGUIEx, owner_key_path)
  self.owner_txt = self:AddComponent(UITextMeshProUGUIEx, owner_txt_path)
  self.building_info = self:AddComponent(UIBaseContainer, building_info_path)
  self.reward_pro = self:AddComponent(UISlider, reward_pro_path)
  self.reward_value = self:AddComponent(UITextMeshProUGUIEx, reward_value_path)
  self.reward_count = self:AddComponent(UITextMeshProUGUIEx, reward_count_path)
  self.status = self:AddComponent(UIBaseContainer, status_path)
  self.status_text = self:AddComponent(UITextMeshProUGUIEx, status_text_path)
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.btn_info:SetOnClick(function()
    if self.data then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonCityAttachmentDetail, {anim = true}, self.data.buildId)
    end
  end)
  self.reward_root = self:AddComponent(UIBaseContainer, reward_path)
  self.reward_root_simple = self:AddComponent(UIBaseContainer, reward_only_path)
  self.reward_pro_simple = self:AddComponent(UISlider, reward_pro_simple_path)
  self.reward_value_simple = self:AddComponent(UITextMeshProUGUIEx, reward_value_simple_path)
  self.reward_root:SetActive(false)
  self.reward_root_simple:SetActive(true)
end

function WorldCityAttachmentBuild:ComponentDestroy()
  self.tip_box_content:RemoveComponents(LWSeasonAllianceTipsItem)
  self.tipBoxTemplate:GameObjectRecycleAll()
  self.reward_icon = nil
  self.btn_info = nil
  self.icon = nil
  self.des_txt = nil
  self.city_effect_key = nil
  self.city_effect_txt = nil
  self.effect_key = nil
  self.effect_txt = nil
  self.owner_key = nil
  self.owner_txt = nil
  self.building_info = nil
  self.reward_pro = nil
  self.reward_value = nil
  self.reward_count = nil
  self.status = nil
  self.status_text = nil
  self.reward_root = nil
  self.reward_root_simple = nil
  self.reward_pro_simple = nil
  self.reward_value_simple = nil
end

function WorldCityAttachmentBuild:InitRewardTips()
  self.tip_box_content:RemoveComponents(LWSeasonAllianceTipsItem)
  self.tipBoxTemplate:GameObjectRecycleAll()
  local goItem, theItem
  local extraRewards = DataCenter.SeasonDataManager:GetLootRewardList()
  if extraRewards ~= nil then
    for i, item in ipairs(extraRewards) do
      goItem = self.tipBoxTemplate:GameObjectSpawn(self.tip_box_content.transform)
      goItem.name = "item_" .. i
      goItem:SetActive(true)
      theItem = self.tip_box_content:AddComponent(LWSeasonAllianceTipsItem, goItem.name)
      theItem:ReInit(item)
    end
  end
  extraRewards = DataCenter.SeasonDataManager:GetSeasonConfig()
  local value = extraRewards.loot_reward_value
  local text = Localization:GetString("2000155")
  self.tip_box_title:SetText(text .. value)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.tip_box_title_root.rectTransform)
end

function WorldCityAttachmentBuild:OnInfoClick()
  if self.data == nil or IsNull(self.gameObject) then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonCityAttachmentDetail, {anim = true}, self.data.buildId)
end

function WorldCityAttachmentBuild:OnReturnClick()
  if self.data == nil or IsNull(self.gameObject) then
    return
  end
end

function WorldCityAttachmentBuild:RefreshData(pointData)
  self.data = pointData
  self:UpdateData()
end

function WorldCityAttachmentBuild:UpdateData()
  if IsNull(self.gameObject) then
    return
  end
  if self.serverDataCache then
    self:UpdateInfo(self.serverDataCache)
  end
  if self.data then
    local buildData = DataCenter.SeasonFarmerTemplateManager:GetBuildTemplateById(self.data.buildId)
    self.buildData = buildData
    if self.data.state == 0 and self.data.curExp ~= nil and buildData then
      local slot = 0
      local chest_num = 0
      local curExp = toInt(self.data.curExp)
      local needExp = toInt(buildData.cost)
      local cityInfo = DataCenter.SeasonFarmerTemplateManager:GetCityAttachmentTemplate(self.data.cityId)
      if cityInfo == nil then
        Logger.LogError(string.format("CityAttachment %s %s %s %s", self.data.serverId or 0, self.data.cityId or 0, self.data.buildId or 0, self.data.pointId or 0))
      else
        slot = cityInfo:GetSlotIdByBuildPos(self.data.pointId)
        chest_num = cityInfo:GetChestNumBySlot(slot)
      end
      self.status:SetActive(true)
      self.building_info:SetActive(true)
      self.status_text:SetText(string.percentage(curExp, needExp, 2))
      local pro_value = math.min(curExp / needExp, 1)
      local pro_txt = string.GetFormattedSeparatorNum(curExp) .. "/" .. string.GetFormattedSeparatorNum(needExp)
      if self.data.isFirst and 0 < toInt(chest_num) then
        self.reward_count:SetText("\195\151" .. chest_num)
        self.reward_pro:SetValue(pro_value)
        self.reward_value:SetText(pro_txt)
        self.reward_root:SetActive(true)
        self.reward_root_simple:SetActive(false)
      else
        self.reward_pro_simple:SetValue(pro_value)
        self.reward_value_simple:SetText(pro_txt)
        self.reward_root:SetActive(false)
        self.reward_root_simple:SetActive(true)
      end
    else
      self.status:SetActive(false)
      self.building_info:SetActive(false)
    end
    self.city_effect_key:SetLocalText("season_builders_alliance_UI_72")
    if buildData and buildData.durability then
      local str1, str2 = string.match(buildData.durability, "([^:,;|]+)[:,;|]([^:,;|]+)")
      if str1 ~= nil and str2 ~= nil then
        if str1 == "1" then
          self.city_effect_txt:SetText(string.GetFormattedSeparatorNum(toInt(str2)))
        elseif str1 == "2" then
          local addValue = (tonumber(str2) or 0) * 100
          self.city_effect_txt:SetText(addValue .. "%")
        end
      else
        self.city_effect_txt:SetText(string.GetFormattedSeparatorNum(toInt(buildData.durability)))
      end
    else
      self.city_effect_txt:SetText("???")
    end
    self.effect_key:SetLocalText("season_builders_alliance_UI_71")
    self.effect_txt:SetText(self.data.desc)
    self.owner_key:SetLocalText("season_builders_alliance_UI_70")
    self.owner_txt:SetText(UIUtil.FormatAllianceAndName(self.data.alAbbr, self.data.alName))
    if self.data.allianceUid == LuaEntry.Player.allianceId then
      self.owner_txt:SetColorRGBA(0.14, 0.61, 0.77, 1)
    else
      self.owner_txt:SetColorRGBA255(42, 40, 48, 255)
    end
  end
end

function WorldCityAttachmentBuild:UpdateInfo(serverData)
  self.serverData = serverData.playerData
  if IsNull(self.gameObject) then
    self.serverDataCache = data
    return
  end
  self.serverDataCache = nil
  if self.serverData ~= nil then
  end
end

function WorldCityAttachmentBuild:OnPointDateUpdate()
  ProfilerUtil.BeginSample("WorldCityAttachmentBuild:OnPointDateUpdate")
  if self.data == nil or self.buildData == nil or self.data.pointId == nil or IsNull(self.gameObject) then
    ProfilerUtil.EndSample()
    return
  end
  local info = CS.SceneManager.World:GetPointInfo(self.data.pointId)
  if info ~= nil then
    cast(info, typeof(CS.CityAttachmentBuildPointInfo))
    local mBuildData = info.mBuildData
    if mBuildData then
      if mBuildData.State == 1 then
        self.data.state = 1
        self.status:SetActive(false)
        self.building_info:SetActive(false)
      else
        local curExp = toInt(mBuildData.CurExp)
        local needExp = toInt(self.buildData.cost)
        self.reward_pro:SetValue(curExp / needExp)
        self.reward_value:SetText(string.GetFormattedSeparatorNum(curExp) .. "/" .. string.GetFormattedSeparatorNum(needExp))
        self.status_text:SetText(string.percentage(curExp, needExp, 2))
        self.status:SetActive(true)
        self.building_info:SetActive(true)
      end
    end
  end
  ProfilerUtil.EndSample()
end

return WorldCityAttachmentBuild
