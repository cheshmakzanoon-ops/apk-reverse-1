local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UIActHeroPromotion = BaseClass("UIActHeroPromotion", base)
local UIHeroSkillItem = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillItem")
local UIHeroSkillStar = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillStar")
local UIHeroSkillEffectLine = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillEffectLine")
local UIHeroSkillDesc = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillDesc")
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local skill1_path = "content/HeroSkillPage/HeroSkillInfo/SkillList/Skill1"
local skill2_path = "content/HeroSkillPage/HeroSkillInfo/SkillList/Skill2"
local skill3_path = "content/HeroSkillPage/HeroSkillInfo/SkillList/Skill3"
local skill4_path = "content/HeroSkillPage/HeroSkillInfo/SkillList/Skill4"
local hero_spine_container_path = "content/HeroSkillPage/PreviewSkillPage/HeroSpineViewport/HeroSpineContainer"
local skill_list_path = "content/HeroSkillPage/HeroSkillInfo/SkillList"
local skill_name_text_path = "content/HeroSkillPage/SkillDetailPage/ImgBg/SkillBasicInfo/SkillNameAndLevel/SkillNameText"
local skill_level_text_path = "content/HeroSkillPage/SkillDetailPage/ImgBg/SkillBasicInfo/SkillNameAndLevel/LevelAndLevelLimit/SkillLevelText"
local skill_level_limit_text_path = "content/HeroSkillPage/SkillDetailPage/ImgBg/SkillBasicInfo/SkillNameAndLevel/LevelAndLevelLimit/SkillLevelLimitText"
local skill_stars_path = "content/HeroSkillPage/SkillDetailPage/ImgBg/SkillBasicInfo/SkillStars"
local skill_star_path = "content/HeroSkillPage/SkillDetailPage/ImgBg/SkillBasicInfo/SkillStars/SkillStar"
local skill_desc_text_path = "content/HeroSkillPage/SkillDetailPage/ImgBg/DescLayout/SkillDescText"
local next_effect_group_path = "content/HeroSkillPage/SkillDetailPage/ImgBg/DescLayout/Viewport/Content/NextEffectGroup"
local next_effect_value_line_path = "content/HeroSkillPage/SkillDetailPage/ImgBg/DescLayout/Viewport/Content/NextEffectGroup/NextEffectValueLine"
local playe_preview_button_path = "content/HeroSkillPage/SkillDetailPage/ImgBg/SkillBasicInfo/PlayePreviewButton"
local img_color_path = "bg/imgColor"
local btn_editor_test_path = "BtnEditorTest"
local hero_nick_name_text_path = "content/HeroSkillPage/HeroNickNameText"
local hero_name_text_path = "content/HeroSkillPage/HeroNameText"
local do_btn_path = "DoBtn"
local hero_quality_icon_path = "content/HeroQualityIcon"
local text_cost_path = "DoBtn/ImgCostItem1/TextCost"
local intro_btn_path = "IntroBtn"
local img_cost_item1_path = "DoBtn/ImgCostItem1"
local do_btn_des_path = "DoBtn/DoBtnDes"
local info_path = "Des/Info"
local content_path = "content"
local red_dot_path = "DoBtn/RedDot"
local btn_left_path = "content/HeroSkillPage/SkillDetailPage/ImgBg/btn_left"
local btn_right_path = "content/HeroSkillPage/SkillDetailPage/ImgBg/btn_right"
local eff_ui_firstpay_ur_hold_path = "content/HeroQualityIcon/Eff_ui_firstpay_ur_hold"
local eff_ui_commonnew_glow_loop_hold_path = "bg_ur/Eff_ui_commonnew_glow_loop_hold"

function UIActHeroPromotion:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.maxIndex = 1
  self.curIndex = 1
  self.curHeroActId = nil
end

function UIActHeroPromotion:OnDestroy()
  self.maxIndex = nil
  self.curIndex = nil
  self.curHeroActId = nil
  self.playingSuccess = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActHeroPromotion:OnEnable()
  base.OnEnable(self)
end

function UIActHeroPromotion:OnDisable()
  base.OnDisable(self)
end

function UIActHeroPromotion:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonHeroPromote, self.PromoteSuccess)
end

function UIActHeroPromotion:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonHeroPromote, self.PromoteSuccess)
  base.OnRemoveListener(self)
end

function UIActHeroPromotion:PromoteSuccess(heroId)
  self:PlaySuccessAnim()
end

local function OnClickSkillItem(self, skillData)
  if not skillData then
    return
  end
  local slotIndex = skillData:GetSlotIndex()
  self:SelectSkill(slotIndex)
end

function UIActHeroPromotion:ComponentDefine()
  self.skill1 = self:AddComponent(UIHeroSkillItem, skill1_path)
  self.skill2 = self:AddComponent(UIHeroSkillItem, skill2_path)
  self.skill3 = self:AddComponent(UIHeroSkillItem, skill3_path)
  self.skill4 = self:AddComponent(UIHeroSkillItem, skill4_path)
  self.skills = {
    self.skill1,
    self.skill2,
    self.skill3,
    self.skill4
  }
  self.selectSkillCallBack = BindCallback(self, OnClickSkillItem)
  self.skill_list = self:AddComponent(UIBaseContainer, skill_list_path)
  self.hero_spine_container = self:AddComponent(UIBaseContainer, hero_spine_container_path)
  self.skill_name_text = self:AddComponent(UIText, skill_name_text_path)
  self.skill_level_text = self:AddComponent(UIText, skill_level_text_path)
  self.skill_level_limit_text = self:AddComponent(UIText, skill_level_limit_text_path)
  self.skill_stars = self:AddComponent(UIBaseContainer, skill_stars_path)
  self.img_cost_item1 = self:AddComponent(UIImage, img_cost_item1_path)
  self.skillStarTemplate = self.transform:Find(skill_star_path).gameObject
  self.skillStarTemplate:GameObjectCreatePool()
  self.skill_desc_text = self:AddComponent(UIHeroSkillDesc, skill_desc_text_path)
  self.nextEffectLineTemplate = self.transform:Find(next_effect_value_line_path).gameObject
  self.nextEffectLineTemplate:GameObjectCreatePool()
  self.nextEffectGroup = self:AddComponent(UIBaseContainer, next_effect_group_path)
  self.playe_preview_button = self:AddComponent(UIButton, playe_preview_button_path)
  self.playe_preview_button:SetOnClick(function()
    self:ShowPreviewSkillWindow()
  end)
  self.do_btn = self:AddComponent(UIButton, do_btn_path)
  self.do_btn:SetOnClick(function()
    self:OnDoBtnClick()
  end)
  self.text_cost = self:AddComponent(UIText, text_cost_path)
  self.hero_nick_name_text = self:AddComponent(UIText, hero_nick_name_text_path)
  self.hero_name_text = self:AddComponent(UIText, hero_name_text_path)
  self.intro_btn = self:AddComponent(UIButton, intro_btn_path)
  self.intro_btn:SetOnClick(function()
    self:ClickTip()
  end)
  self.hero_quality_icon = self:AddComponent(UIImage, hero_quality_icon_path)
  self.img_color = self:AddComponent(UIImage, img_color_path)
  self.do_btn_des = self:AddComponent(UIText, do_btn_des_path)
  self.info = self:AddComponent(UIText, info_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.red_dot = self:AddComponent(UIImage, red_dot_path)
  self.btn_left = self:AddComponent(UIButton, btn_left_path)
  self.btn_right = self:AddComponent(UIButton, btn_right_path)
  self.btn_left:SetOnClick(BindCallback(self, self.OnClickLeft))
  self.btn_right:SetOnClick(BindCallback(self, self.OnClickRight))
  self.btn_editor_test = self:AddComponent(UIButton, btn_editor_test_path)
  self.btn_editor_test:SetOnClick(BindCallback(self, self.OnClickedEditorTest))
  self.animSuccess = self:AddComponent(UIAnimator, "")
  self:ClearAnim()
  self.effURHold = self:AddComponent(UIBaseContainer, eff_ui_firstpay_ur_hold_path)
  self.effURHold2 = self:AddComponent(UIBaseContainer, eff_ui_commonnew_glow_loop_hold_path)
  self.btn_editor_test:SetActive(GMUtils.IsGM())
  if self.view.param then
    self.defaultActIndex = DataCenter.SeasonDataManager:TryFindHeroPromoteDataIndexByTMDHeroId(self.view.param)
  else
    self.defaultActIndex = nil
  end
end

function UIActHeroPromotion:ClearAnim()
  if self.animSuccess then
    local _, time = self.animSuccess:GetAnimationReturnTime("upgrade")
    if time then
      self.animSuccess:SampleAnimationAtTime("upgrade", time)
    end
  end
  if self.delayAnimTimer then
    self.delayAnimTimer:Stop()
    self.delayAnimTimer = nil
  end
  self.playingSuccess = nil
end

function UIActHeroPromotion:PlaySuccessAnim()
  if not self.animSuccess then
    return
  end
  if self.playingSuccess then
    return
  end
  self.playingSuccess = true
  self.effURHold:SetActive(false)
  self.effURHold2:SetActive(false)
  self:ClearAnim()
  self.animSuccess:Enable(true)
  local _, time = self.animSuccess:PlayAnimationReturnTime("upgrade")
  if time then
    self.delayAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:ClearAnim()
      self.playingSuccess = false
      self:SetData(tostring(self.curHeroActId))
    end, time)
  end
end

function UIActHeroPromotion:ComponentDestroy()
  self.skill1 = nil
  self.skill2 = nil
  self.skill3 = nil
  self.skill4 = nil
  self.skills = nil
  self.skill_list = nil
  self.selectSkillCallBack = nil
  self.hero_spine_container = nil
  self.img_cost_item1 = nil
  self.skill_name_text = nil
  self.skill_level_text = nil
  self.skill_level_limit_text = nil
  self.skill_stars = nil
  self.skill_desc_text = nil
  self.nextEffectLineTemplate.gameObject:GameObjectRecycleAll()
  self.nextEffectLineTemplate = nil
  self.skillStarTemplate.gameObject:GameObjectRecycleAll()
  self.skillStarTemplate = nil
  self.playe_preview_button = nil
  self.do_btn = nil
  self.text_btn1 = nil
  self.hero_nick_name_text = nil
  self.hero_name_text = nil
  self.intro_btn = nil
  self.hero_quality_icon = nil
  self.do_btn_des = nil
  self.info = nil
  self.content = nil
  self.red_dot = nil
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
  self.btn_left = nil
  self.btn_right = nil
  self:ClearAnim()
  self.animSuccess = nil
  self.currentHeroId = nil
  self.defaultActIndex = nil
end

function UIActHeroPromotion:SetData(activityId)
  local init = self.activityId == nil
  self.activityId = self.activityId or tonumber(activityId)
  if not self.activityId then
    return
  end
  self.curHeroActId = activityId
  self.activityHeroData = SeasonRedPointUtils.GetConfigData(self.curHeroActId)
  if init and self.activityHeroData then
    self.maxIndex = self.activityHeroData.index
    self.curIndex = self.maxIndex
  end
  if self.defaultActIndex then
    local pData = DataCenter.SeasonDataManager:GetHeroCanPromoteDataByIndex(self.defaultActIndex)
    if pData then
      self.curIndex = self.defaultActIndex
      self.defaultActIndex = nil
      self:SetData(tostring(pData.activityId))
      return
    else
      self.defaultActIndex = nil
    end
  end
  self.canPromote = false
  self.promoteHeroUuid = 0
  self.oldHeroId = 0
  local upgradeMax = false
  if self.activityHeroData then
    local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(self.activityHeroData.oldId)
    local newHeroData = DataCenter.HeroDataManager:GetHeroByHeroId(self.activityHeroData.newId)
    local tipEx = ""
    if newHeroData then
      self.do_btn_des:SetLocalText("season_hero_promotion_003")
      upgradeMax = true
    elseif heroData then
      local curRankId = heroData:GetRank()
      local maxRankId = heroData:GetMaxRank()
      self.oldHeroId = toInt(self.activityHeroData.oldId)
      if curRankId >= maxRankId then
        self.canPromote = true
        self.promoteHeroUuid = heroData.uuid
        tipEx = "(1/1)"
      else
        tipEx = "(0/1)"
      end
      self.do_btn_des:SetLocalText("season_hero_promotion_002")
    else
      tipEx = "(0/1)"
      self.do_btn_des:SetLocalText("season_hero_promotion_002")
    end
    local showHeroData
    local itemTemplateData = DataCenter.ItemTemplateManager:GetItemTemplate(self.activityHeroData.newId)
    if itemTemplateData ~= nil then
      local heroTemplateData = HeroInfo.New()
      heroTemplateData:UpdateFromTemplate(tonumber(itemTemplateData.para2), IntMaxValue, IntMaxValue, IntMaxValue)
      showHeroData = heroTemplateData
    else
      local heroTemp = DataCenter.HeroTemplateManager:GetTemplate(self.activityHeroData.newId)
      if heroTemp then
        local heroTemplateData = HeroInfo.New()
        heroTemplateData:UpdateFromTemplate(tonumber(self.activityHeroData.newId), IntMaxValue, IntMaxValue, IntMaxValue)
        showHeroData = heroTemplateData
      end
    end
    local conditionPassed = self:GetCondition()
    if showHeroData then
      self.content:SetActive(true)
      self.do_btn:SetActive(true)
      self:SetHeroData(showHeroData)
      local contentTxt = Localization:GetString("season_hero_promotion_004", self.heroData:GetName()) .. " " .. tipEx
      self.info:SetText(contentTxt)
      CS.UIGray.SetGray(self.do_btn.transform, upgradeMax or not conditionPassed, not upgradeMax)
      local item = DataCenter.ItemData:GetItemById(self.activityHeroData.costItemId)
      local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.activityHeroData.costItemId)
      if item then
        self.text_cost:SetText(tostring(item.count) .. "/" .. tostring(self.activityHeroData.costCount))
      else
        self.text_cost:SetText(tostring(0) .. "/" .. tostring(self.activityHeroData.costCount))
      end
      self.img_cost_item1:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
    else
      self.do_btn:SetActive(false)
      self.content:SetActive(false)
      Logger.LogError("data error, activityId: " .. self.activityId)
    end
    local mul = self.maxIndex > 1
    self.btn_left:SetActive(mul)
    self.btn_right:SetActive(mul)
    if mul then
      self.btn_right:SetActive(self.curIndex < self.maxIndex)
      self.btn_left:SetActive(self.curIndex > 1)
    end
  else
    self.do_btn:SetActive(false)
    self.content:SetActive(false)
    Logger.LogError("data error, activityId: " .. self.activityId)
  end
  if CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    local flag = SeasonRedPointUtils.SeasonHeroPromotionRedPoint(self.curHeroActId, true)
    self.red_dot:SetActive(flag)
    if flag then
      EventManager:GetInstance():Broadcast(EventId.LWSeasonMainEntranceRedPoint)
    end
  else
    self:BindRedPointUI(self.red_dot, nil, {
      RedDef.Season,
      tostring(self.activityId)
    })
  end
  self.effURHold:SetActive(upgradeMax)
  self.effURHold2:SetActive(upgradeMax)
end

local function _GetColorBg(quality)
  if quality == 5 then
    return "Assets/Main/Sprites/UI/UIActHeroPromotion/FX_yingxiongjinjie_jianbiancheng.png"
  else
    return "Assets/Main/Sprites/UI/UIActHeroPromotion/FX_yingxiongjinjie_jianbianzi.png"
  end
end

function UIActHeroPromotion:SetHeroData(heroData)
  if heroData == nil then
    return
  end
  if heroData.heroId == self.currentHeroId then
    return
  end
  self.heroData = heroData
  self.currentHeroId = heroData.heroId
  self.hero_name_text:SetText(self.heroData:GetName())
  self.hero_nick_name_text:SetText(self.heroData:GetNickName())
  if self.heroData.quality then
    local quality = self.heroData.quality
    quality = math.min(quality, 5)
    quality = math.max(quality, 1)
    local _icon = HeroUtils.GetHeroQualityTagImg(self.heroData.quality)
    self.hero_quality_icon:LoadSprite(_icon)
    self.hero_quality_icon:SetNativeSize()
    self.img_color:LoadSprite(_GetColorBg(self.heroData.quality))
  end
  self:RefreshHeroSkillListInfo()
  self.selectedSkillIndex = nil
  self:SelectSkill(1)
  self:LoadHeroSpine()
end

function UIActHeroPromotion:SelectSkill(skillIndex)
  if not self.heroData then
    return
  end
  if self.selectedSkillIndex == skillIndex then
    return
  end
  self.selectedSkillIndex = skillIndex
  self.skillData = self.heroData:GetHeroSkillBySlotIndex(skillIndex)
  if self.skillData and not self.skillData:IsUnlock() then
    if not self.templateSkillInfo then
      self.templateSkillInfo = SkillInfo.New()
    end
    local newSkillId = DataCenter.HeroSkillTemplateManager:GetMaxStarSkillBySkillId(self.skillData:GetId())
    self.templateSkillInfo:CreateFromTemplate(newSkillId, false, IntMaxValue)
    self.templateSkillInfo.slotIndex = self.skillData:GetSlotIndex()
    self.skillData = self.templateSkillInfo
  end
  for i = 1, 4 do
    self.skills[i]:SetSelected(i == skillIndex)
  end
  self:RefreshSelectedSkillDetail(self)
end

function UIActHeroPromotion:RefreshHeroSkillListInfo()
  for i = 1, 4 do
    local skillData = self.heroData:GetHeroSkillBySlotIndex(i)
    local skillShowRedPoint = false
    local unlockLevel = 0
    self.skills[i]:SetData(skillData, {
      showSkillName = false,
      showSkillLevel = true,
      showLock = true,
      showRedPoint = skillShowRedPoint,
      unlockLevel = unlockLevel,
      showStar = true
    }, self.selectSkillCallBack)
    self.skills[i]:SetSelected(i == self.selectedSkillIndex)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.skill_list.transform)
end

function UIActHeroPromotion:LoadHeroSpine()
  if not self.heroData then
    return
  end
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
  local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(self.heroData.modelId)
  local spinePath = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_path")
  local request = ResourceManager:InstantiateAsync(spinePath)
  self.heroSpineLoadRequest = request
  request:completed("+", function()
    if request.isError or request.gameObject == nil then
      self.heroSpineLoadRequest = nil
      return
    end
    self:ResetSpineTransform(request.gameObject)
  end)
end

function UIActHeroPromotion:ResetSpineTransform(obj)
  if not obj then
    return
  end
  local parent = self.hero_spine_container
  if not parent then
    return
  end
  obj:SetActive(true)
  local rectTransform = obj:GetComponent(typeof(CS.UnityEngine.RectTransform))
  if rectTransform ~= nil then
    local spineScale = Vector3.one
    local spinePos = Vector3.zero
    local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(self.heroData.modelId)
    spineScale = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_skill_scale")
    spinePos = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_skill_pos")
    rectTransform:SetParent(parent.transform)
    rectTransform:Set_localScale(spineScale, spineScale, 1)
    rectTransform:Set_anchoredPosition(spinePos[1], spinePos[2], 0)
  end
end

function UIActHeroPromotion:RefreshSelectedSkillDetail()
  if not self.skillData then
    return
  end
  local nameStr = self.skillData:GetName()
  if self.skillData:IsUnlock() then
    self.skill_name_text:SetText(nameStr)
    self.skill_level_text:SetText(string.format("Lv.%d", self.skillData:GetLevel()))
    self.skill_level_limit_text:SetText(string.format("/%d", self.skillData:GetMaxLevel()))
  else
    local resultStr = string.format("%s (%s)", nameStr, Localization:GetString(120050))
    self.skill_name_text:SetText(resultStr)
    self.skill_level_text:SetText("")
    self.skill_level_limit_text:SetText("")
  end
  self.skill_stars:RemoveComponents(UIHeroSkillStar)
  self.skillStarTemplate.gameObject:GameObjectRecycleAll()
  local maxStar = self.skillData:GetMaxStar()
  local curStar = self.skillData:GetStar()
  for i = 1, maxStar do
    local item = self.skillStarTemplate:GameObjectSpawn(self.skill_stars.transform)
    item.name = "star" .. i
    local cell = self.skill_stars:AddComponent(UIHeroSkillStar, item.name)
    cell:SetFilled(i <= curStar)
  end
  self.skill_desc_text:SetText(self.skillData:GetDesc(true))
  self.nextEffectGroup:RemoveComponents(UIHeroSkillEffectLine)
  self.nextEffectLineTemplate.gameObject:GameObjectRecycleAll()
  local effectsDesc = self.skillData:GetEffectsDesc()
  if 0 < #effectsDesc then
    for i = 1, #effectsDesc do
      self.nextEffectGroup:SetActive(true)
      local item = self.nextEffectLineTemplate:GameObjectSpawn(self.nextEffectGroup.transform)
      item.name = "item" .. i
      local cell = self.nextEffectGroup:AddComponent(UIHeroSkillEffectLine, item.name)
      cell:SetData(effectsDesc[i].isUnlock, effectsDesc[i].outDesc)
    end
  else
    self.nextEffectGroup:SetActive(false)
  end
  if self.skillData then
    local skillType = self.skillData:GetType()
    self.playe_preview_button:SetActive(skillType == SkillType.Bullet)
  end
end

function UIActHeroPromotion:ShowPreviewSkillWindow()
  if not self.heroData or not self.selectedSkillIndex then
    return
  end
  local heroId = self.heroData.heroId
  local selectedSkillInfo = self.heroData:GetHeroSkillBySlotIndex(self.selectedSkillIndex)
  local skillId = selectedSkillInfo:GetId()
  local skillLv = selectedSkillInfo:GetLevel()
  local skillMaxLv = selectedSkillInfo:GetMaxLevel()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPreviewSkillWindow, {anim = true}, heroId, skillId, skillLv, skillMaxLv)
end

function UIActHeroPromotion:OnDoBtnClick()
  if self:GetCondition(true) then
    UIUtil.ShowMessage(Localization:GetString("season_hero_promote_rule"), 2, nil, nil, function()
      if self.oldHeroId > 0 then
        DataCenter.BuildHeroManager:RemoveHeroFromDropList(self.oldHeroId)
      end
      SFSNetwork.SendMessage(MsgDefines.LWSeasonHeroTransition, self.promoteHeroUuid, self.activityId)
    end, nil, nil, nil, nil, nil, nil, nil, nil, nil, CS.UnityEngine.TextAnchor.UpperLeft)
  end
end

function UIActHeroPromotion:GetCondition(lackTip)
  if self.canPromote and self.activityHeroData then
    local item = DataCenter.ItemData:GetItemById(self.activityHeroData.costItemId)
    if item then
      if self.activityHeroData.costCount <= item.count then
        return true
      else
        if lackTip then
          LWResourceLackUtil:GotoGoodsItemLack(self.activityHeroData.costItemId, self.activityHeroData.costCount)
        end
        return false
      end
    else
      if lackTip then
        LWResourceLackUtil:GotoGoodsItemLack(self.activityHeroData.costItemId, self.activityHeroData.costCount)
      end
      return false
    end
  else
    local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(self.activityHeroData.oldId)
    if heroData then
      local curRankId = heroData:GetRank()
      local maxRankId = heroData:GetMaxRank()
      if curRankId < maxRankId then
        if lackTip then
          UIUtil.ShowTipsId("season_tips170")
        end
        return false
      end
    else
      if lackTip then
        UIUtil.ShowTipsId("season_tips170")
      end
      return false
    end
  end
  return false
end

function UIActHeroPromotion:ClickTip()
  local story = GetTableData(TableName.Activity, self.activityId, "desc")
  if not string.IsNullOrEmpty(story) then
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function UIActHeroPromotion:OnClickLeft()
  self:ClearAnim()
  self.curIndex = math.max(1, self.curIndex - 1)
  local curPromoteData = DataCenter.SeasonDataManager:GetHeroCanPromoteDataByIndex(self.curIndex)
  self:SetData(tostring(curPromoteData.activityId))
end

function UIActHeroPromotion:OnClickRight()
  self:ClearAnim()
  self.curIndex = math.min(self.maxIndex, self.curIndex + 1)
  local curPromoteData = DataCenter.SeasonDataManager:GetHeroCanPromoteDataByIndex(self.curIndex)
  self:SetData(tostring(curPromoteData.activityId))
end

function UIActHeroPromotion:OnClickedEditorTest()
  if not GMUtils.IsGM() then
    return
  end
  self:PromoteSuccess()
end

return UIActHeroPromotion
