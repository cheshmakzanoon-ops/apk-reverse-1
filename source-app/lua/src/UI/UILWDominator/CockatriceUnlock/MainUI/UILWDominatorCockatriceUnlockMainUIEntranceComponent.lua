local base = UIBaseContainer
local UILWDominatorCockatriceUnlockMainUIEntranceComponent = BaseClass("UILWDominatorCockatriceUnlockMainUIEntranceComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWDominatorCockatriceUnlockMainUIEntranceComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDominatorCockatriceUnlockMainUIEntranceComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorCockatriceUnlockMainUIEntranceComponent:ComponentDefine()
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.compRed = self:AddComponent(UIBaseContainer, "RedPointNum")
end

function UILWDominatorCockatriceUnlockMainUIEntranceComponent:ComponentDestroy()
  self.btn = nil
  self.compRed = nil
end

function UILWDominatorCockatriceUnlockMainUIEntranceComponent:DataDefine()
  self.isShow = nil
end

function UILWDominatorCockatriceUnlockMainUIEntranceComponent:DataDestroy()
  self.isShow = nil
end

function UILWDominatorCockatriceUnlockMainUIEntranceComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DetectEventComp, self.OnGetDetectEventCompMsg)
  self:AddUIListener(EventId.DetectInfoChange, self.OnDetectInfoChange)
  self:AddUIListener(EventId.MainTaskUpdate, self.OnTaskUpdate)
  self:AddUIListener(EventId.DominatorArchiveUnlockSuccess, self.OnArchiveUnlock)
  self:AddUIListener(EventId.DominatorCommonGuideProgressChanged, self.OnGuideIdChange)
end

function UILWDominatorCockatriceUnlockMainUIEntranceComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.DetectEventComp, self.OnGetDetectEventCompMsg)
  self:RemoveUIListener(EventId.DetectInfoChange, self.OnDetectInfoChange)
  self:RemoveUIListener(EventId.MainTaskUpdate, self.OnTaskUpdate)
  self:RemoveUIListener(EventId.DominatorArchiveUnlockSuccess, self.OnArchiveUnlock)
  self:RemoveUIListener(EventId.DominatorCommonGuideProgressChanged, self.OnGuideIdChange)
  base.OnRemoveListener(self)
end

function UILWDominatorCockatriceUnlockMainUIEntranceComponent:ReInit()
  self.isShow = DataCenter.DominatorCockatriceUnlockManager:IsShowMainUIEntrance()
  self:SetActive(self.isShow)
  if self.isShow then
    self.compRed:SetActive(self:GetIsShowRed())
  end
end

function UILWDominatorCockatriceUnlockMainUIEntranceComponent:GetIsShowRed()
  local curGuideId = DataCenter.DominatorCockatriceUnlockManager:GetCurGuideId()
  if curGuideId == DominatorCockatriceUnlockProgress.End then
    return false
  end
  if DataCenter.DominatorCockatriceUnlockManager:GetGroupShowRedCount(1) > 0 then
    return true
  end
  if 0 < DataCenter.DominatorCockatriceUnlockManager:GetGroupShowRedCount(2) then
    return true
  end
  if 0 < DataCenter.DominatorCockatriceUnlockManager:GetGroupShowRedCount(3) then
    return true
  end
  if 0 < DataCenter.DominatorCockatriceUnlockManager:GetGroupShowRedCount(4) then
    return true
  end
  local finalEventInfo = DataCenter.DominatorCockatriceUnlockManager:GetFinalDetectEventInfo()
  if finalEventInfo ~= nil and finalEventInfo.state == DetectEventState.DETECT_EVENT_STATE_FINISHED then
    return true
  end
  local info = DataCenter.DominatorManager:GetInfoById(DominatorId.Cockatrice)
  if info ~= nil and info:HasAnyArchiveCanUnlock() then
    return true
  end
  return false
end

function UILWDominatorCockatriceUnlockMainUIEntranceComponent:OnBtnClick()
  DataCenter.DominatorCockatriceUnlockManager:OnMainUIEntranceClick()
end

function UILWDominatorCockatriceUnlockMainUIEntranceComponent:OnGetDetectEventCompMsg(info)
  if not SceneUtils.GetIsInWorld() then
    return
  end
  local uuid = info
  local event = DataCenter.RadarCenterDataManager:GetDetectEventInfo(uuid)
  if event == nil or toInt(event.pointId) <= 0 then
    return
  end
  if event.template == nil then
    return
  end
  local isDominatorEvent = event.template.type == DetectEventType.DOMINATOR_COCKATRICE_GUIDE_1 or event.template.type == DetectEventType.DOMINATOR_COCKATRICE_GUIDE_2 or event.template.type == DetectEventType.DOMINATOR_COCKATRICE_GUIDE_3
  if not isDominatorEvent then
    return
  end
  local mainWorldPos = SceneUtils.TileIndexToWorld(event.pointId, ForceChangeScene.World)
  local world = CS.SceneManager.World
  local mainScreenPos = world:WorldToScreenPoint(mainWorldPos)
  local pos = CS.GameEntry.UICamera:ScreenToWorldPoint(mainScreenPos)
  local effectPath = "Assets/_Art/Effect/prefab/ui/VFX_leida_trail.prefab"
  local startPos = pos
  local endPos = self.transform.position
  UIUtil.DoFlySimpleFunc(effectPath, startPos, endPos, 1, nil, function()
  end)
end

function UILWDominatorCockatriceUnlockMainUIEntranceComponent:OnDetectInfoChange()
  if self.isShow then
    self.compRed:SetActive(self:GetIsShowRed())
  end
end

function UILWDominatorCockatriceUnlockMainUIEntranceComponent:OnTaskUpdate()
  if self.isShow then
    self.compRed:SetActive(self:GetIsShowRed())
  end
end

function UILWDominatorCockatriceUnlockMainUIEntranceComponent:OnArchiveUnlock()
  if self.isShow then
    self.compRed:SetActive(self:GetIsShowRed())
  end
end

function UILWDominatorCockatriceUnlockMainUIEntranceComponent:OnGuideIdChange()
  if self.isShow then
    self.isShow = DataCenter.DominatorCockatriceUnlockManager:IsShowMainUIEntrance()
    self:SetActive(self.isShow)
    if self.isShow then
      self.compRed:SetActive(self:GetIsShowRed())
    end
  end
end

return UILWDominatorCockatriceUnlockMainUIEntranceComponent
