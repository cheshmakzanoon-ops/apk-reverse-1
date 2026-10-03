local base = UIBaseContainer
local UIRevivalPlanTaskItemComponent = BaseClass("UIRevivalPlanTaskItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIRevivalPlanTaskItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIRevivalPlanTaskItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIRevivalPlanTaskItemComponent:ComponentDefine()
  self.imgIcon = self:AddComponent(UIImage, "icon")
  self.textDesc = self:AddComponent(UITextMeshProUGUIEx, "desc")
  self.btnGoto = self:AddComponent(UIButton, "btnGoto")
  self.btnGoto:SetOnClick(function()
    self:OnBtnGotoClick()
  end)
  self.textTxtGoto = self:AddComponent(UIText, "btnGoto/txtGoto")
  self.textScore = self:AddComponent(UIText, "scoreIcon/score")
  self.textTxtGoto:SetText(Localization:GetString("revival_plan_028"))
  self.textDesc:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
  self.scoreIcon = self:AddComponent(UIBaseContainer, "scoreIcon")
end

function UIRevivalPlanTaskItemComponent:ComponentDestroy()
  self.imgIcon = nil
  self.textDesc = nil
  self.btnGoto = nil
  self.textTxtGoto = nil
  self.textScore = nil
end

function UIRevivalPlanTaskItemComponent:DataDefine()
end

function UIRevivalPlanTaskItemComponent:DataDestroy()
end

function UIRevivalPlanTaskItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIRevivalPlanTaskItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIRevivalPlanTaskItemComponent:SetData(ruleId, hideBtn)
  local cfg = DataCenter.ActivityRevivalScoreShowTemplateManager:GetTemplate(ruleId)
  if cfg == nil then
    Logger.LogError("UIRevivalPlanTaskItemComponent.SetData get rule cfg invalid : " .. tostring(ruleId))
    return
  end
  local name = cfg.score_des
  local points = cfg.score_value
  local gotoType = cfg.score_gototype
  local gotoPara = cfg.score_gototype_value
  if not string.IsNullOrEmpty(gotoPara) then
    self.gotoPara = string.split(gotoPara, ";")
  else
    self.gotoPara = {}
  end
  self.gotoType = gotoType
  local specialName = false
  if string.IsNullOrEmpty(points) and gotoType == QuestGoType.BuildBtn then
    local buildId = tonumber(self.gotoPara[1]) or 0
    if buildId == BuildingTypes.LW_BUILD_MILITARY_CAMP then
      local level = 1
      local maxLevelSoldier = DataCenter.SoldierDataManager:GetCanTrainHighestLevelSoldier()
      if maxLevelSoldier then
        level = maxLevelSoldier.lv
      end
      local value = cfg:GetExtraValue(level)
      points = value
      specialName = true
      self.textDesc:SetText(Localization:GetString(name, level))
    end
  end
  self.textScore:SetText("+" .. string.GetFormattedSeparatorNum(points))
  if not specialName then
    self.textDesc:SetText(Localization:GetString(name))
  end
  local btnShow = self.gotoType > 0 and not hideBtn
  if btnShow then
    self.btnGoto:SetActive(true)
    if CommonUtil and CommonUtil.IsArabicAutoMirrorOpen() then
      self.scoreIcon:SetAnchorMaxXY(0, 1)
      self.scoreIcon:SetAnchorMinXY(0, 1)
      self.scoreIcon:SetPivotXY(0, 1)
    else
      self.scoreIcon:SetAnchorMaxXY(1, 1)
      self.scoreIcon:SetAnchorMinXY(1, 1)
      self.scoreIcon:SetPivotXY(1, 1)
    end
    self.scoreIcon:SetAnchoredPositionXY(-122, -24)
  else
    self.btnGoto:SetActive(false)
    if CommonUtil and CommonUtil.IsArabicAutoMirrorOpen() then
      self.scoreIcon:SetAnchorMaxXY(0, 0.5)
      self.scoreIcon:SetAnchorMinXY(0, 0.5)
      self.scoreIcon:SetPivotXY(0, 0.5)
    else
      self.scoreIcon:SetAnchorMaxXY(1, 0.5)
      self.scoreIcon:SetAnchorMinXY(1, 0.5)
      self.scoreIcon:SetPivotXY(1, 0.5)
    end
    self.scoreIcon:SetAnchoredPositionXY(-122, 0)
  end
  self.imgIcon:LoadSprite(cfg.score_pic)
end

function UIRevivalPlanTaskItemComponent:OnBtnGotoClick()
  if self.gotoType then
    GoToUtil.GoToByTypeAndParam(self.gotoType, self.gotoPara)
  end
end

function UIRevivalPlanTaskItemComponent:OnPointerClick(clickPos)
  if self.textDesc == nil then
    return
  end
  local linkId = self.textDesc:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
  param.title = nil
  param.content = Localization:GetString(linkId)
  param.screenPos = clickPos
  param.yPosFix = -40
  param.width = 400
  param.showArrow = false
  param.preferTop = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
end

return UIRevivalPlanTaskItemComponent
