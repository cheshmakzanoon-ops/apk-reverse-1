local LWUITrailTowerStageItemRender = BaseClass("LWUITrailTowerStageItemRender", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local bossStageImage_path = "BossStageIcon"
local eliteStageImage_path = "EliteStageIcon"
local commonStageImage_path = "CommonStageIcon"
local bossStageFinishImage_path = "BossStageFinishImage"
local notBossStageFinishImage_path = "NotBossStageFinishImage"
local btn_path = "Btn"
local selectMark_path = "SelectMark"
local selectStageNameText_path = "SelectMark/SelectStageNameText"
local curDoingMarkParticle_path = "CurDoingMark"
local victory_effect_parent_path = "VictoryEffectParent"

function LWUITrailTowerStageItemRender:OnCreate()
  base.OnCreate(self)
  self.singleTime = LuaEntry.DataConfig:TryGetNum("trialtower_yijian_speed", "k1") / 1000
  self:ComponentDefine()
end

function LWUITrailTowerStageItemRender:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUITrailTowerStageItemRender:OnAddListener()
  self:AddUIListener(EventId.ChangeTrailTowerStageSelect, self.RefreshSelectState)
  base.OnAddListener(self)
end

function LWUITrailTowerStageItemRender:OnRemoveListener()
  self:RemoveUIListener(EventId.ChangeTrailTowerStageSelect, self.RefreshSelectState)
  base.OnRemoveListener(self)
end

function LWUITrailTowerStageItemRender:ComponentDefine()
  self.bossStageImage = self:AddComponent(UIImage, bossStageImage_path)
  self.eliteStageImage = self:AddComponent(UIImage, eliteStageImage_path)
  self.commonStageImage = self:AddComponent(UIImage, commonStageImage_path)
  self.bossStageFinishImage = self:AddComponent(UIImage, bossStageFinishImage_path)
  self.notBossStageFinishImage = self:AddComponent(UIImage, notBossStageFinishImage_path)
  self.curDoingMarkParticle = self.transform:Find(curDoingMarkParticle_path).gameObject
  self.selectMark = self:AddComponent(UIImage, selectMark_path)
  self.selectStageNameText = self:AddComponent(UIText, selectStageNameText_path)
  self.victory_effect_parent = self:AddComponent(UIBaseContainer, victory_effect_parent_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:BtnClick()
  end)
  self.pointItemList = {}
  self.highLightPointItemList = {}
  for i = 1, 12 do
    local path = "NormalPoint" .. i
    local pointItem = self:AddComponent(UIBaseContainer, path)
    pointItem:SetActive(false)
    table.insert(self.pointItemList, pointItem)
    local highLightPath = string.format("%s/HighlightPoint%d", path, i)
    local highLightPointItem = self:AddComponent(UIBaseContainer, highLightPath)
    table.insert(self.highLightPointItemList, highLightPointItem)
  end
end

function LWUITrailTowerStageItemRender:ComponentDestroy()
  self:ClearTween()
  self:ClearEffect()
  self.bossStageImage = nil
  self.eliteStageImage = nil
  self.commonStageImage = nil
  self.bossStageFinishImage = nil
  self.notBossStageFinishImage = nil
  self.btn = nil
  self.curDoingMarkParticle = nil
  self.selectMark = nil
  self.selectStageNameText = nil
  self.victory_effect_parent = nil
end

function LWUITrailTowerStageItemRender:SetData(trailTowerLevelTemplate, curSelectStage, pointPosList, isBattleSweep, isPassAllStage, battleSweepStartStageOrder)
  self.trailTowerLevelTemplate = trailTowerLevelTemplate
  self.curSelectStageId = curSelectStage
  self.pointPosList = pointPosList
  self.isBattleSweep = isBattleSweep
  self.isPassAllStage = isPassAllStage
  self.curStageOrder = LocalController:instance():getValue(TableName.LW_Trail_Tower_Level, self.curSelectStageId, "level_order")
  self.commonStageImage:SetActive(trailTowerLevelTemplate.levelType == tonumber(TrailTowerStageType.Common))
  self.eliteStageImage:SetActive(trailTowerLevelTemplate.levelType == tonumber(TrailTowerStageType.Elite))
  self.bossStageImage:SetActive(trailTowerLevelTemplate.levelType == tonumber(TrailTowerStageType.Boss))
  if self.trailTowerLevelTemplate.levelType == tonumber(TrailTowerStageType.Boss) then
    self.victory_effect_parent:SetLocalPositionXYZ(0, 90, 0)
  elseif self.trailTowerLevelTemplate.levelType == tonumber(TrailTowerStageType.Elite) then
    self.victory_effect_parent:SetLocalPositionXYZ(0, 53, 0)
  else
    self.victory_effect_parent:SetLocalPositionXYZ(0, 43, 0)
  end
  self:SetPointPos()
  self:RefreshView(battleSweepStartStageOrder)
end

function LWUITrailTowerStageItemRender:RefreshView(battleSweepStartStageOrder)
  local passMark = self.isPassAllStage or self.trailTowerLevelTemplate.levelOrder < self.curStageOrder
  if not self.isBattleSweep and passMark or self.isBattleSweep and passMark and battleSweepStartStageOrder >= self.trailTowerLevelTemplate.levelOrder then
    if self.isBattleSweep and self.trailTowerLevelTemplate.levelOrder == battleSweepStartStageOrder then
      self:ShowBattleSweepVictoryEffect()
      self:RefreshStageStatus(false)
      self:PlayStageFinishAni()
    else
      self:RefreshStageStatus(true)
      self:UpdatePointStatus(true)
    end
  else
    self:RefreshStageStatus(false)
    self:UpdatePointStatus(false)
  end
  local selected = false
  if self.isBattleSweep then
    selected = self.trailTowerLevelTemplate.levelOrder == battleSweepStartStageOrder
  else
    selected = self.trailTowerLevelTemplate.id == self.curSelectStageId
  end
  self.selectMark:SetActive(selected)
  self.curDoingMarkParticle:SetActive(selected)
  if selected then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_goal_achieved)
    self.selectStageNameText:SetText(self.trailTowerLevelTemplate.levelGroup .. "-" .. self.trailTowerLevelTemplate.levelOrder)
    if self.trailTowerLevelTemplate.levelType == tonumber(TrailTowerStageType.Boss) then
      self.curDoingMarkParticle.transform:Set_localScale(1, 1, 1)
      self.curDoingMarkParticle.transform:Set_localPosition(0, 15, 0)
    else
      self.curDoingMarkParticle.transform:Set_localScale(0.7, 0.7, 0.7)
      self.curDoingMarkParticle.transform:Set_localPosition(0, -8, 0)
    end
  end
end

function LWUITrailTowerStageItemRender:RefreshStageStatus(isFinish)
  local targetStageImage = self:GetTargetStageImage(self.trailTowerLevelTemplate.levelType)
  if isFinish then
    local bossStage = self.trailTowerLevelTemplate.levelType == tonumber(TrailTowerStageType.Boss)
    self.bossStageFinishImage:SetActive(bossStage)
    self.notBossStageFinishImage:SetActive(not bossStage)
    CS.UIGray.SetGray(targetStageImage.transform, true, false)
  else
    self.bossStageFinishImage:SetActive(false)
    self.notBossStageFinishImage:SetActive(false)
    CS.UIGray.SetGray(targetStageImage.transform, false, true)
  end
end

function LWUITrailTowerStageItemRender:GetTargetStageImage(levelType)
  if levelType == tonumber(TrailTowerStageType.Common) then
    return self.commonStageImage
  elseif levelType == tonumber(TrailTowerStageType.Elite) then
    return self.eliteStageImage
  else
    return self.bossStageImage
  end
end

function LWUITrailTowerStageItemRender:RefreshSelectState(curSelectStageId)
  local selected = self.trailTowerLevelTemplate.id == curSelectStageId
  self.selectMark:SetActive(selected)
  if selected then
    self.selectStageNameText:SetText(self.trailTowerLevelTemplate.levelGroup .. "-" .. self.trailTowerLevelTemplate.levelOrder)
  end
end

function LWUITrailTowerStageItemRender:BtnClick()
  if self.isBattleSweep and not self.view.battleSweepAniFinish then
    UIUtil.ShowTipsId("trialtower_yijian_07")
    return
  end
  EventManager:GetInstance():Broadcast(EventId.ChangeTrailTowerStageSelect, self.trailTowerLevelTemplate.id)
  self.view:OnStageItemClick(self.trailTowerLevelTemplate)
end

function LWUITrailTowerStageItemRender:SetPointPos()
  local count = table.count(self.pointItemList)
  local pointCount = table.count(self.pointPosList)
  for i = 1, count do
    if i <= pointCount then
      local pos = self.pointPosList[i]
      self.pointItemList[i]:SetActive(true)
      self.pointItemList[i]:SetAnchoredPosition(pos, true)
      if self.highLightPointItemList[i] then
        self.highLightPointItemList[i]:SetActive(false)
      end
    else
      self.pointItemList[i]:SetActive(false)
    end
  end
end

function LWUITrailTowerStageItemRender:UpdatePointStatus(isFinish)
  local pointCount = table.count(self.pointPosList)
  for i = 1, pointCount do
    if self.highLightPointItemList[i] then
      self.highLightPointItemList[i]:SetActive(isFinish)
    end
  end
end

function LWUITrailTowerStageItemRender:PlayStageFinishAni()
  self:ClearTween()
  self.sequence = CS.DG.Tweening.DOTween.Sequence()
  local pointCount = table.count(self.pointPosList)
  for i = 1, pointCount do
    self.sequence:AppendInterval(self.singleTime)
    self.sequence:AppendCallback(function()
      if self.highLightPointItemList and self.highLightPointItemList[i] then
        self.highLightPointItemList[i]:SetActive(true)
      end
    end)
  end
  self.sequence:AppendInterval(self.singleTime)
  self.sequence:AppendCallback(function()
    if self.trailTowerLevelTemplate then
      self:RefreshStageStatus(true)
      self.selectMark:SetActive(false)
      self.curDoingMarkParticle:SetActive(false)
      self.view:RefreshNextStagePlayAniInfo()
    end
  end)
end

function LWUITrailTowerStageItemRender:ClearTween()
  if self.sequence then
    self.sequence:Kill()
    self.sequence = nil
  end
end

function LWUITrailTowerStageItemRender:ShowBattleSweepVictoryEffect()
  if self.reqsEffect == nil then
    self.reqsEffect = self:GameObjectInstantiateAsync(UIAssets.TrailTowerStageVictoryEffect, function(request)
      if request.isError then
        return
      end
      self.effectGo = request.gameObject
      self.effectGo:SetActive(true)
      self.effectGo.transform:SetParent(self.victory_effect_parent.transform)
      self.effectGo.transform:Set_localPosition(0, 0, 0)
      self.effectGo.transform:Set_localScale(0.6, 0.6, 0.6)
    end)
  elseif self.effectGo then
    self.effectGo:SetActive(false)
    self.effectGo:SetActive(true)
  end
end

function LWUITrailTowerStageItemRender:ClearEffect()
  if self.reqsEffect then
    self:GameObjectDestroy(self.reqsEffect)
  end
  self.reqsEffect = nil
  self.effectGo = nil
end

return LWUITrailTowerStageItemRender
