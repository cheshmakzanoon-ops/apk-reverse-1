local DecorationBookDetailItem = BaseClass("DecorationBookDetailItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local GreenBgPath = "Assets/Main/Sprites/UI/LWDecorationBook/Mjc_zhuagnshiwugongfang_tujian_card_text02.png"
local RedBgPath = "Assets/Main/Sprites/UI/LWDecorationBook/Mjc_zhuagnshiwugongfang_tujian_card_text01.png"
local btn_path = "BG"
local detail_btn_path = "detailBtn"
local icon_path = "Icon"
local have_content_path = "HaveContent"
local lv_path = "HaveContent/Lv"
local add_score_green_path = "HaveContent/AddScoreGreen"
local add_score_gray_path = "HaveContent/AddScoreGray"
local name_text_path = "maskName/NameText"
local count_bg_path = "HaveContent/CountBg"
local count_text_path = "HaveContent/CountBg/CountText"
local up_path = "HaveContent/up"
local redpoint_path = "HaveContent/redpoint"
local no_have_content_path = "NoHaveContent"
local no_have_name_text_path = "NoHaveContent/mask/NoHaveNameText"
local obtain_btn_path = "NoHaveContent/ObtainBtn"
local QUEST_ENTRY_WIDTH_LIMIT = 180
local QUEST_ENTRY_ROLLING_SPD = 60
local QUEST_ENTRY_ROLLING_DELAY = 2
local QUEST_ENTRY_ROLLING_HOLD = 3
local UnityRectTransform = typeof(CS.UnityEngine.RectTransform)

function DecorationBookDetailItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function DecorationBookDetailItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function DecorationBookDetailItem:ComponentDefine()
  self.detail_btn = self:AddComponent(UIButton, detail_btn_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.have_content = self:AddComponent(UIBaseContainer, have_content_path)
  self.lv = self:AddComponent(UIText, lv_path)
  self.add_score_green = self:AddComponent(UIText, add_score_green_path)
  self.add_score_gray = self:AddComponent(UIText, add_score_gray_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.count_bg = self:AddComponent(UIImage, count_bg_path)
  self.count_text = self:AddComponent(UIText, count_text_path)
  self.up = self:AddComponent(UIButton, up_path)
  self.redpoint = self:AddComponent(UIButton, redpoint_path)
  self.no_have_content = self:AddComponent(UIImage, no_have_content_path)
  self.no_have_name_text = self:AddComponent(UIText, no_have_name_text_path)
  self.name_rectTransform = self.transform:Find(no_have_name_text_path):GetComponent(UnityRectTransform)
  self.name_rectTransformHave = self.transform:Find(name_text_path):GetComponent(UnityRectTransform)
  self.obtain_btn = self:AddComponent(UIButton, obtain_btn_path)
  self.obtain_btn:SetOnClick(function()
    self:OnClickObtain()
  end)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.bgImg = self:AddComponent(UIImage, btn_path)
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.detail_btn:SetOnClick(function()
    self:OnClickDetailBtn()
  end)
end

function DecorationBookDetailItem:ComponentDestroy()
  self.detail_btn = nil
  self.icon = nil
  self.have_content = nil
  self.lv = nil
  self.name_rectTransform = nil
  self.add_score_green = nil
  self.add_score_gray = nil
  self.name_text = nil
  self.name_rectTransformHave = nil
  self.count_bg = nil
  self.up = nil
  self.redpoint = nil
  self.no_have_content = nil
  self.no_have_name_text = nil
  self.obtain_btn = nil
end

function DecorationBookDetailItem:DataDefine()
end

function DecorationBookDetailItem:DataDestroy()
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
  if self.tweenSeq2 then
    self.tweenSeq2:Kill()
    self.tweenSeq2 = nil
  end
end

function DecorationBookDetailItem:SetData(data)
  self.data = data
  self.baseBuildingId = self.data.baseBuildingId
  self.effectId = self.data.effectId
  self:ShowItem()
  self:AdjustMaskText()
end

function DecorationBookDetailItem:AdjustMaskText()
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
  if self.name_rectTransform then
    self.tweenSeq = UIUtil.SetTMPHorseRaceLamp(self.no_have_name_text, QUEST_ENTRY_WIDTH_LIMIT, QUEST_ENTRY_ROLLING_DELAY, QUEST_ENTRY_ROLLING_SPD, QUEST_ENTRY_ROLLING_HOLD, self.name_rectTransform)
  end
  if self.tweenSeq2 then
    self.tweenSeq2:Kill()
    self.tweenSeq2 = nil
  end
  if self.name_rectTransformHave then
    self.tweenSeq2 = UIUtil.SetTMPHorseRaceLamp(self.name_text, QUEST_ENTRY_WIDTH_LIMIT, QUEST_ENTRY_ROLLING_DELAY, QUEST_ENTRY_ROLLING_SPD, QUEST_ENTRY_ROLLING_HOLD, self.name_rectTransformHave)
  end
end

function DecorationBookDetailItem:ShowItem()
  self.icon:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(self.baseBuildingId, 0))
  self.baseBuildData = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.baseBuildingId)
  self.name_text:SetLocalText(self.baseBuildData.name)
  self.no_have_name_text:SetLocalText(self.baseBuildData.name)
  self.hasBuilding = DataCenter.BuildManager:HasBuilding(self.baseBuildingId, true)
  self.have_content:SetActive(self.hasBuilding)
  self.no_have_content:SetActive(not self.hasBuilding)
  self.obtain_btn:SetActive(false)
  self.no_have_name_text:SetActive(false)
  self.bgImg:LoadSprite(BuildingUtils.GetDecoratorBookBg(tonumber(self.baseBuildData.para3)))
  if self.hasBuilding then
    self.buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(self.baseBuildingId, true)
    local buildDataExist = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(self.baseBuildingId, false)
    if self.buildData.level < self.baseBuildData.max_level then
      self.lv:SetLocalText("season_mastery_163", self.buildData.level)
    else
      self.lv:SetLocalText("building_center_desc10")
    end
    local isFoldUp = self.buildData.state == BuildingStateType.FoldUp and (buildDataExist == nil or self.buildData.level > buildDataExist.level)
    self.count_text:SetText(isFoldUp and "0/1" or "1/1")
    self.count_bg:LoadSprite(isFoldUp and RedBgPath or GreenBgPath)
    self.add_score_green:SetActive(not isFoldUp)
    self.add_score_gray:SetActive(isFoldUp)
    local buildTemplateData = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.buildData.itemId, self.buildData.level)
    local effectMap = buildTemplateData.building_effect_last
    local desc, value
    if self.effectId == 75949 or self.effectId == 75950 then
      local effectValue = (effectMap[75949] or 0) + (effectMap[75950] or 0)
      desc, value = WorkerUtil.GetEffectText(self.effectId, effectValue, true)
    else
      desc, value = WorkerUtil.GetEffectText(self.effectId, effectMap[self.effectId] or 0, true)
    end
    self.add_score_green:SetText(value)
    self.add_score_gray:SetText(value)
    self.redpoint:SetActive(isFoldUp)
  elseif not BuildingUtils.IsDecoratorCantBuyDirectly(self.baseBuildingId) then
    self.obtain_btn:SetActive(true)
  else
    self.no_have_name_text:SetActive(true)
  end
end

function DecorationBookDetailItem:OnClickObtain()
  local availableRechargeId = BuildingUtils.GetDecoratorAvailableRechargeId(self.baseBuildingId)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerLevelPackage, {anim = true}, availableRechargeId, {availableRechargeId})
end

function DecorationBookDetailItem:OnClick()
  if self.hasBuilding then
    local oneData = {}
    oneData.buildUuid = self.buildData.uuid
    oneData.isShowShortCutKey = false
    oneData.hasBuilding = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWDecorationBookUpgrade, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, oneData)
  else
    local oneData = {}
    oneData.itemId = self.baseBuildingId
    oneData.level = 5
    oneData.max_level = 5
    oneData.type = Building_Upgrade_Type.DecorationBook
    oneData.isShowShortCutKey = false
    oneData.hasBuilding = false
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWDecorationBookUpgrade, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, oneData)
  end
end

function DecorationBookDetailItem:OnClickDetailBtn()
  local param = {}
  param.baseBuildingId = self.baseBuildingId
  param.alignObject = self.detail_btn
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWDecorationBookProperty, {anim = false}, param)
end

return DecorationBookDetailItem
