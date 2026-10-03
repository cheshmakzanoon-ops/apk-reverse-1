local base = UIBaseContainer
local RevivalPlanMainDayItem = BaseClass("RevivalPlanMainDayItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local titleBgPath_Normal = "Assets/Main/Sprites/UI/UILWRevivalPlan/FX_fuxingjihua_dangan_14.png"
local titleBgPath_Gray = "Assets/Main/Sprites/UI/UILWRevivalPlan/FX_fuxingjihua_dangan2_14.png"

function RevivalPlanMainDayItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function RevivalPlanMainDayItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function RevivalPlanMainDayItem:ComponentDefine()
  self.rawImgIcon = self:AddComponent(UIRawImage, "icon")
  self.btnIcon = self:AddComponent(UIButton, "icon")
  self.btnIcon:SetOnClick(function()
    self:OnBtnIconClick()
  end)
  self.textTitle = self:AddComponent(UIText, "icon/titleBg/title")
  self.compFinishFlag = self:AddComponent(UIBaseContainer, "icon/finishFlag")
  self.effectNode = self:AddComponent(UIBaseContainer, "icon/effect")
  self.effectNode:SetActive(false)
  self.anim = self:AddComponent(UISimpleAnimation, "icon")
  self.anim:Enable(false)
  self.titleBg = self:AddComponent(UIImage, "icon/titleBg")
  self.redPoint = self:AddComponent(UIBaseContainer, "icon/titleBg/RedPoint")
  self.redPointNum = self:AddComponent(UIText, "icon/titleBg/RedPoint/RedNum")
  self.redPoint:SetActive(false)
end

function RevivalPlanMainDayItem:ComponentDestroy()
  self.rawImgIcon = nil
  self.btnIcon = nil
  self.textTitle = nil
  self.compFinishFlag = nil
  self.redPoint = nil
  self.redPointNum = nil
end

function RevivalPlanMainDayItem:DataDefine()
end

function RevivalPlanMainDayItem:DataDestroy()
end

function RevivalPlanMainDayItem:OnAddListener()
  base.OnAddListener(self)
end

function RevivalPlanMainDayItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function RevivalPlanMainDayItem:SetStage(stageIndex, stageId, curStageIndex, activityId, showDayEffect)
  self.stageIndex = stageIndex
  self.stageId = stageId
  self.open = false
  self.curStageIndex = curStageIndex
  self.anim:Enable(true)
  local playEffect = false
  local cfg = DataCenter.ActivityRevivalConfigTemplateManager:GetTemplate(stageId)
  if stageIndex <= curStageIndex then
    self.textTitle:SetText(Localization:GetString("revival_plan_022", stageIndex))
    if cfg ~= nil then
      local totalCount = #cfg.score_list
      local info = DataCenter.RevivalPlanManager:GetStageInfo(activityId, stageIndex)
      local rewardCount = 0
      if info ~= nil then
        rewardCount = #info.indexList
      end
      self.compFinishFlag:SetActive(totalCount <= rewardCount)
      self.open = true
      self.rawImgIcon:LoadSprite(cfg.phase_open_pic)
      if stageIndex < curStageIndex then
        self.rawImgIcon:SetColorRGBA(0.7, 0.7, 0.7, 1)
        self.titleBg:LoadSprite(titleBgPath_Gray)
      else
        self.rawImgIcon:SetColorRGBA(1, 1, 1, 1)
        playEffect = showDayEffect
        self.titleBg:LoadSprite(titleBgPath_Normal)
      end
      self.rawImgIcon:SetNativeSize()
      self.effectNode:SetActive(stageIndex == curStageIndex)
    end
  else
    self.textTitle:SetText(Localization:GetString("revival_plan_022", stageIndex))
    if cfg then
      self.rawImgIcon:LoadSprite(cfg.phase_open_pic)
      self.rawImgIcon:SetNativeSize()
    end
    self.compFinishFlag:SetActive(false)
    self.effectNode:SetActive(false)
    self.titleBg:LoadSprite(titleBgPath_Normal)
  end
  if playEffect then
    if not self.anim:IsPlaying("Default") then
      self.anim:Rewind("Default")
      self.anim:Play("Default")
    end
  else
    self.anim:SampleAnimationAtTime("Default", 1)
  end
  local redCount = DataCenter.RevivalPlanManager:GetStageRedCount(activityId, stageIndex)
  if 0 < redCount then
    self.redPoint:SetActive(true)
    self.redPointNum:SetText(redCount)
  else
    self.redPoint:SetActive(false)
  end
end

function RevivalPlanMainDayItem:OnBtnIconClick()
  if self.open then
    EventManager:GetInstance():Broadcast(EventId.RevivalPlanShowCurPage, self.stageId)
  else
    EventManager:GetInstance():Broadcast(EventId.RevivalPlanShowPlanTaskFromDayItem, {
      stageId = self.stageId,
      hideBtn = self.stageIndex > self.curStageIndex
    })
  end
end

function RevivalPlanMainDayItem:ForceCloseEffectNode()
  if self.effectNode then
    self.effectNode:SetActive(false)
    self.titleBg:LoadSprite(titleBgPath_Normal)
    self.rawImgIcon:SetColorRGBA(1, 1, 1, 1)
    self.redPoint:SetActive(false)
  end
end

return RevivalPlanMainDayItem
