local DecorationBookIllustratedDetailItem = BaseClass("DecorationBookIllustratedDetailItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UnityRectTransform = typeof(CS.UnityEngine.RectTransform)
local GreenBgPath = "Assets/Main/Sprites/UI/LWDecorationBook/Mjc_zhuagnshiwugongfang_tujian_card_text02.png"
local RedBgPath = "Assets/Main/Sprites/UI/LWDecorationBook/Mjc_zhuagnshiwugongfang_tujian_card_text01.png"
local FullFillImgPath = "Assets/Main/Sprites/UI/LWDecorationBook/Mjc_zhuagnshiwugongfang_jindutiao_03.png"
local NotFullFillImgPath = "Assets/Main/Sprites/UI/LWDecorationBook/Mjc_zhuagnshiwugongfang_jindutiao_00.png"
local btn_path = "BG"
local detail_btn_path = "detailBtn"
local icon_path = "Icon"
local have_content_path = "HaveContent"
local lv_path = "HaveContent/Lv"
local name_text_path = "HaveContent/NameMask/NameText"
local name_mask_path = "HaveContent/NameMask"
local count_text_path = "HaveContent/CountBg/CountText"
local count_bg_path = "HaveContent/CountBg"
local up_path = "HaveContent/up"
local redpoint_path = "HaveContent/redpoint"
local no_have_content_path = "NoHaveContent"
local no_have_name_text_path = "NoHaveContent/NoHaveNameMask/NoHaveNameText"
local slider_path = "HaveContent/Slider"
local fill_path = "HaveContent/Slider/Fill Area/Fill"
local QUEST_ENTRY_WIDTH_LIMIT = 174
local QUEST_ENTRY_ROLLING_SPD = 60
local QUEST_ENTRY_ROLLING_DELAY = 2
local QUEST_ENTRY_ROLLING_HOLD = 3

function DecorationBookIllustratedDetailItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function DecorationBookIllustratedDetailItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function DecorationBookIllustratedDetailItem:ComponentDefine()
  self.detail_btn = self:AddComponent(UIButton, detail_btn_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.have_content = self:AddComponent(UIBaseContainer, have_content_path)
  self.lv = self:AddComponent(UIText, lv_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.name_mask = self:AddComponent(UIBaseContainer, name_mask_path)
  self.name_rectTransform = self.name_text.gameObject:GetComponent(UnityRectTransform)
  self.count_text = self:AddComponent(UIText, count_text_path)
  self.count_bg = self:AddComponent(UIImage, count_bg_path)
  self.up = self:AddComponent(UIButton, up_path)
  self.redpoint = self:AddComponent(UIButton, redpoint_path)
  self.no_have_content = self:AddComponent(UIImage, no_have_content_path)
  self.no_have_name_text = self:AddComponent(UIText, no_have_name_text_path)
  self.no_have_name_rectTransform = self.no_have_name_text.gameObject:GetComponent(UnityRectTransform)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.fill = self:AddComponent(UIImage, fill_path)
  self.bgImg = self:AddComponent(UIImage, btn_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.detail_btn:SetOnClick(function()
    self:OnClickDetailBtn()
  end)
  self.recommendTag = self:AddComponent(UIBaseComponent, "HaveContent/RecommendTag")
end

function DecorationBookIllustratedDetailItem:OnClick()
  if self.hasBuilding then
    local uuid = self.buildData.uuid
    if self.buildDataExist and self.buildData.level == self.buildDataExist.level then
      uuid = self.buildDataExist.uuid
    end
    local oneData = {}
    oneData.buildUuid = uuid
    oneData.isShowShortCutKey = true
    oneData.hasBuilding = true
    oneData.baseBuildingIdList = self.baseBuildingIdList
    oneData.curIndex = self.index
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
    oneData.isShowShortCutKey = true
    oneData.hasBuilding = false
    oneData.baseBuildingIdList = self.baseBuildingIdList
    oneData.curIndex = self.index
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWDecorationBookUpgrade, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, oneData)
  end
end

function DecorationBookIllustratedDetailItem:OnClickDetailBtn()
  local param = {}
  param.baseBuildingId = self.baseBuildingId
  param.alignObject = self.detail_btn
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWDecorationBookProperty, {anim = false}, param)
end

function DecorationBookIllustratedDetailItem:ComponentDestroy()
  self.detail_btn = nil
  self.icon = nil
  self.have_content = nil
  self.lv = nil
  self.name_text = nil
  self.name_mask = nil
  self.name_rectTransform = nil
  self.count_bg = nil
  self.up = nil
  self.redpoint = nil
  self.no_have_content = nil
  self.no_have_name_text = nil
  self.no_have_name_rectTransform = nil
  self.recommendTag = nil
end

function DecorationBookIllustratedDetailItem:DataDefine()
end

function DecorationBookIllustratedDetailItem:DataDestroy()
  if self.tweenSeq then
    self.tweenSeq:Kill()
  end
end

function DecorationBookIllustratedDetailItem:SetData(data)
  self.data = data
  self.baseBuildingIdList = self.data.baseBuildingIdList
  self.index = self.data.index
  self.baseBuildingId = self.baseBuildingIdList[self.index]
  self.isShowUpArrowWhenFoldUp = data.isShowUpArrowWhenFoldUp
  self:ShowItem()
end

function DecorationBookIllustratedDetailItem:SetScrollingtext()
  if self.hasBuilding then
    self.open_name_text = self.name_text
  else
    self.open_name_text = self.no_have_name_text
  end
  local rawWidth = self.name_text:GetWidth()
  local width = math.min(QUEST_ENTRY_WIDTH_LIMIT, rawWidth)
  if self.tweenSeq then
    self.tweenSeq:Kill()
  end
  if rawWidth > width then
    local startPox = 0
    local endPox = width - rawWidth
    if CommonUtil.IsArabic() and CommonUtil.ArabicAutoMirrorFactor() == 1 then
      startPox = endPox
      endPox = 0
    end
    self.name_rectTransform:Set_anchoredPosition(startPox, 0)
    self.no_have_name_rectTransform:Set_anchoredPosition(startPox, 0)
    self.tweenSeq = DOTween.Sequence()
    self.tweenSeq:AppendInterval(QUEST_ENTRY_ROLLING_DELAY)
    self.tweenSeq:Append(self.open_name_text.transform:DOAnchorPosX(CommonUtil.ArabicAutoMirrorFactor() * endPox, (rawWidth - width) / QUEST_ENTRY_ROLLING_SPD):SetEase(CS.DG.Tweening.Ease.Linear))
    self.tweenSeq:AppendInterval(QUEST_ENTRY_ROLLING_HOLD)
    self.tweenSeq:SetLoops(-1, CS.DG.Tweening.LoopType.Restart)
  else
    local position_x = CommonUtil.ArabicAutoMirrorFactor() * (QUEST_ENTRY_WIDTH_LIMIT - rawWidth) / 2
    self.name_rectTransform:Set_anchoredPosition(position_x, 0)
    self.no_have_name_rectTransform:Set_anchoredPosition(position_x, 0)
  end
end

function DecorationBookIllustratedDetailItem:ShowItem()
  self.icon:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(self.baseBuildingId, 0))
  self.baseBuildData = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.baseBuildingId)
  self.name_text:SetLocalText(self.baseBuildData.name)
  self.no_have_name_text:SetLocalText(self.baseBuildData.name)
  self.hasBuilding = DataCenter.BuildManager:HasBuilding(self.baseBuildingId, true)
  self:SetScrollingtext()
  self.have_content:SetActive(self.hasBuilding)
  self.no_have_content:SetActive(not self.hasBuilding)
  local sprite = BuildingUtils.GetDecoratorBookBg(tonumber(self.baseBuildData.para3))
  if sprite ~= nil then
    self.bgImg:LoadSprite(sprite)
  end
  if self.hasBuilding then
    self.buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(self.baseBuildingId, true)
    self.buildDataExist = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(self.baseBuildingId, false)
    if self.buildData.level < self.baseBuildData.max_level then
      self.lv:SetLocalText("season_mastery_163", self.buildData.level)
    else
      self.lv:SetLocalText("building_center_desc10")
    end
    local isFoldUp = self.buildData.state == BuildingStateType.FoldUp and (self.buildDataExist == nil or self.buildData.level > self.buildDataExist.level)
    self.count_text:SetText(isFoldUp and "0/1" or "1/1")
    self.count_bg:LoadSprite(isFoldUp and RedBgPath or GreenBgPath)
    self.slider:SetActive(not isFoldUp)
    self:RefreshDecoProgress()
  else
  end
  local isShowRecommendTag = false
  if DataCenter.DecorationRecommendManager:IsFunctionOn() and DataCenter.DecorationRecommendManager:GetIsOn() then
    local recommendBaseId = DataCenter.DecorationRecommendManager:GetRecommendBuildBaseId()
    isShowRecommendTag = recommendBaseId ~= nil and self.baseBuildingId == recommendBaseId
  end
  self.recommendTag:SetActive(isShowRecommendTag)
end

function DecorationBookIllustratedDetailItem:RefreshDecoProgress()
  local isExistAdvanceUpgrade = BuildingUtils.IsExistAdvanceUpgrade(self.buildData.itemId, self.buildData.level)
  if isExistAdvanceUpgrade then
    self:RefreshDecoProgress4AdvanceUpgrade()
  else
    self:RefreshDecoProgress4NormalUpgrade()
  end
end

function DecorationBookIllustratedDetailItem:RefreshDecoProgress4AdvanceUpgrade()
  self.up:SetActive(false)
  self.redpoint:SetActive(false)
  local lvTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.buildData.itemId, self.buildData.level)
  if not (lvTemplate and lvTemplate.decoGroupUpgradeBaseId) or lvTemplate.decoGroupUpgradeBaseId < 0 then
    return
  end
  local groupId = lvTemplate.decoGroupUpgradeBaseId
  local maxProgressInfo = DataCenter.DecorationUpgradeTemplateManager:GetMaxProgressInfo(groupId, self.buildData.level)
  if not maxProgressInfo then
    return
  end
  local curProgress = self.buildData.prodStatus or 0
  self.slider:SetValue(curProgress / maxProgressInfo.stage_need)
  self.fill:LoadSprite(curProgress >= maxProgressInfo.stage_need and FullFillImgPath or NotFullFillImgPath)
  local curProgressInfo = DataCenter.DecorationUpgradeTemplateManager:GetLvAndStageInfoByProgress(groupId, self.buildData.level, curProgress)
  if not curProgressInfo then
    return
  end
  local isFoldUp = self.buildData.state == BuildingStateType.FoldUp and (self.buildDataExist == nil or self.buildData.level > self.buildDataExist.level)
  local upgradeCost = toInt(curProgressInfo.cost_item) or 0
  local hasCount, needCount, needCountWithoutGlue
  hasCount, needCountWithoutGlue = DataCenter.BuildManager:IsCanUpgradeDecoration(self.buildData.itemId, self.buildData.level, false)
  if upgradeCost <= hasCount and self.buildData.level < self.baseBuildData.max_level or isFoldUp and self.isShowUpArrowWhenFoldUp then
    self.up:SetActive(true)
  end
end

function DecorationBookIllustratedDetailItem:RefreshDecoProgress4NormalUpgrade()
  local hasCount, needCount, needCountWithoutGlue
  hasCount, needCountWithoutGlue = DataCenter.BuildManager:IsCanUpgradeDecoration(self.buildData.itemId, self.buildData.level, false)
  local isFoldUp = self.buildData.state == BuildingStateType.FoldUp and (self.buildDataExist == nil or self.buildData.level > self.buildDataExist.level)
  self.up:SetActive(false)
  self.redpoint:SetActive(false)
  if hasCount >= needCountWithoutGlue and self.buildData.level < self.baseBuildData.max_level or isFoldUp and self.isShowUpArrowWhenFoldUp then
    self.up:SetActive(true)
  end
  self.slider:SetValue(hasCount / needCountWithoutGlue)
  self.fill:LoadSprite(hasCount >= needCountWithoutGlue and FullFillImgPath or NotFullFillImgPath)
end

return DecorationBookIllustratedDetailItem
