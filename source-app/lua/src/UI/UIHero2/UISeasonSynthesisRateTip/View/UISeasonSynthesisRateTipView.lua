local UISeasonSynthesisRateTipView = BaseClass("UISeasonSynthesisRateTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIHeroRecruitTipRateDetailInfo = require("UI.UIHero2.UIHeroRecruitTipNew.Component.UIHeroRecruitTipRateDetailInfo")
local tab_btn_path = "Btn"
local tab_select_path = "Select"
local tab_unselect_path = "UnSelect"
local tab_name_path = "Group/titleText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:OnOpen()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnPanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closeBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/Common_bg_orange/CloseBtn")
  self.closeBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.textTitle = self:AddComponent(UIText, "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText")
  self.recruitRateDetailInfo = self:AddComponent(UIHeroRecruitTipRateDetailInfo, "Root/Common_bg/recruitRateDetailInfo")
  self.textTitle:SetLocalText("season_activity1000014_desc015")
  self.toogle1_ui_container = self:AddComponent(UIBaseContainer, "Root/Tab/Toggle1")
  self.toogle1_tabtext_off = self.toogle1_ui_container:AddComponent(UINewText, "tab_text")
  self.toogle1_tabtext_on = self.toogle1_ui_container:AddComponent(UINewText, "Choose/tab_2_text")
  self.toogle1 = self:AddComponent(UIToggle, "Root/Tab/Toggle1")
  self.toogle1:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabClick(1)
    end
  end)
  self.toogle2_ui_container = self:AddComponent(UIBaseContainer, "Root/Tab/Toggle2")
  self.toogle2_tabtext_off = self.toogle2_ui_container:AddComponent(UINewText, "tab_text")
  self.toogle2_tabtext_on = self.toogle2_ui_container:AddComponent(UINewText, "Choose/tab_2_text")
  self.toogle2 = self:AddComponent(UIToggle, "Root/Tab/Toggle2")
  self.toogle2:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabClick(2)
    end
  end)
  self.toogle1_tabtext_off:SetText(Localization:GetString("season_activity1000016_desc027"))
  self.toogle1_tabtext_on:SetText(Localization:GetString("season_activity1000016_desc027"))
  self.toogle2_tabtext_off:SetText(Localization:GetString("season_activity1000016_desc028"))
  self.toogle2_tabtext_on:SetText(Localization:GetString("season_activity1000016_desc028"))
end

local function ComponentDestroy(self)
  self.btnPanel = nil
  self.closeBtn = nil
  self.textTitle = nil
  self.recruitRateDetailInfo = nil
  self.toogle1_ui_container = nil
  self.toogle1_tabtext_off = nil
  self.toogle1_tabtext_on = nil
  self.toogle1 = nil
  self.toogle2_ui_container = nil
  self.toogle2_tabtext_off = nil
  self.toogle2_tabtext_on = nil
  self.toogle2 = nil
end

local function OnOpen(self)
  self.selected = 1
  self.viewSelected = 0
  self.lotteryId = self:GetUserData()
  self.extraData = DataCenter.ActivityListDataManager:GetExtraData(SEASON_ACTIVITY_SYNTHESIS_REWARD_RATE)
  self.toogle1:SetIsOn(true)
  self:RefreshInfoContent()
end

local function RefreshInfoContent(self)
  if self.selected == self.viewSelected then
    return
  end
  self.viewSelected = self.selected
  local data = {}
  data.rareArray = {}
  data.totalWeight = 0
  if self.selected == 1 then
    data.overrideName = ""
    data.totalWeight = 1
    local must_reward_rare = 0
    local must_reward_season = 0
    local must_reward_data
    for i = 1, #self.extraData do
      local id = self.extraData[i].id
      local weight = 1
      local rare = GetTableData(TableName.GeneSynthesis, id, "merge_level", 1)
      local season = GetTableData(TableName.GeneSynthesis, id, "condition", "0")
      if data.rareArray[rare] == nil then
        data.rareArray[rare] = {}
      end
      local rewards = self.extraData[i].must_reward
      local iType
      for j = 1, #rewards do
        local reward = rewards[j]
        if reward.type == RewardType.HERO then
          iType = HeroRecruitRateDetailInfoType.Hero
        elseif reward.type == RewardType.GOODS then
          iType = HeroRecruitRateDetailInfoType.Goods
        elseif reward.type == RewardType.RESOURCE_ITEM then
          iType = HeroRecruitRateDetailInfoType.ResItem
        elseif reward.type == RewardType.WORKER then
          iType = HeroRecruitRateDetailInfoType.Worker
        elseif reward.type == RewardType.CommonEquip then
          iType = HeroRecruitRateDetailInfoType.SquadEquip
        elseif reward.type == RewardType.EQUIP then
          iType = HeroRecruitRateDetailInfoType.Equip
        elseif reward.type == RewardType.TWSkillChip then
          iType = HeroRecruitRateDetailInfoType.SkillChip
        end
        if iType ~= nil and must_reward_season < tonumber(season) then
          must_reward_rare = rare
          must_reward_data = {
            type = iType,
            id = reward.value.id,
            num = reward.value.num,
            weight = weight
          }
        end
      end
    end
    if must_reward_data ~= nil then
      table.insert(data.rareArray[must_reward_rare], must_reward_data)
    end
  else
    for i = 1, #self.extraData do
      local id = self.extraData[i].id
      local rare = GetTableData(TableName.GeneSynthesis, id, "merge_level", 1)
      local weight = GetTableData(TableName.GeneSynthesis, id, "weight", 0)
      data.totalWeight = data.totalWeight + weight
      if data.rareArray[rare] == nil then
        data.rareArray[rare] = {}
      end
      local rewards = self.extraData[i].reward
      for j = 1, #rewards do
        local reward = rewards[j]
        local iType
        if reward.type == RewardType.HERO then
          iType = HeroRecruitRateDetailInfoType.Hero
        elseif reward.type == RewardType.GOODS then
          iType = HeroRecruitRateDetailInfoType.Goods
        elseif reward.type == RewardType.RESOURCE_ITEM then
          iType = HeroRecruitRateDetailInfoType.ResItem
        elseif reward.type == RewardType.WORKER then
          iType = HeroRecruitRateDetailInfoType.Worker
        elseif reward.type == RewardType.CommonEquip then
          iType = HeroRecruitRateDetailInfoType.SquadEquip
        elseif reward.type == RewardType.EQUIP then
          iType = HeroRecruitRateDetailInfoType.Equip
        elseif reward.type == RewardType.TWSkillChip then
          iType = HeroRecruitRateDetailInfoType.SkillChip
        end
        if iType ~= nil then
          table.insert(data.rareArray[rare], {
            type = iType,
            id = reward.value.id,
            num = reward.value.num,
            weight = weight
          })
        end
      end
    end
  end
  self.recruitRateDetailInfo:SetDataForSynthesisRate(data)
end

local function OnTabClick(self, index)
  self.selected = index
  self:RefreshInfoContent()
end

UISeasonSynthesisRateTipView.OnCreate = OnCreate
UISeasonSynthesisRateTipView.OnDestroy = OnDestroy
UISeasonSynthesisRateTipView.ComponentDefine = ComponentDefine
UISeasonSynthesisRateTipView.ComponentDestroy = ComponentDestroy
UISeasonSynthesisRateTipView.OnOpen = OnOpen
UISeasonSynthesisRateTipView.RefreshInfoContent = RefreshInfoContent
UISeasonSynthesisRateTipView.OnTabClick = OnTabClick
return UISeasonSynthesisRateTipView
