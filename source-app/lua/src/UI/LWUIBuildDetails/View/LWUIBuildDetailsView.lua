local LWUIBuildDetailsView = BaseClass("LWUIBuildDetailsView", UIBaseView)
local MainBuildingContent = require("UI.LWUIBuildDetails.Component.MainBuildingContent")
local CommonBuildingContent = require("UI.LWUIBuildDetails.Component.CommonBuildingContent")
local base = UIBaseView
local build_icon_path = "panel/BG/buildInfo/buildIcon"
local title_text_path = "panel/BG/buildInfo/infoText/titleText"
local cur_level_text_path = "panel/BG/buildInfo/infoText/CurLevelText"
local close_btn_path = "panel/BG/buildInfo/CloseBtn"
local common_building_content_path = "panel/BG/CommonBuildingContent"
local main_building_content_path = "panel/BG/MainBuildingContent"

function LWUIBuildDetailsView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
  DataCenter.LWSoundManager:PlaySound(62261, false)
end

function LWUIBuildDetailsView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIBuildDetailsView:DataDefine()
  self.curBuildIndex = nil
  self.curBuildData = nil
  self.buildCurLevelTemplate = nil
end

function LWUIBuildDetailsView:DataDestroy()
  self.curBuildIndex = nil
  self.curBuildData = nil
  self.buildCurLevelTemplate = nil
end

function LWUIBuildDetailsView:ComponentDefine()
  self.buildIcon = self:AddComponent(UIImage, build_icon_path)
  self.titleText = self:AddComponent(UIText, title_text_path)
  self.curLevelText = self:AddComponent(UIText, cur_level_text_path)
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.planeBtn = self:AddComponent(UIButton, "PanelBtn")
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.planeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.common_building_content = self:AddComponent(CommonBuildingContent, common_building_content_path)
  self.main_building_content = self:AddComponent(MainBuildingContent, main_building_content_path)
end

function LWUIBuildDetailsView:ComponentDestroy()
  self.workerIconImg = nil
  self.titleText = nil
  self.curLevelText = nil
  self.closeBtn = nil
  self.planeBtn = nil
  self.common_building_content = nil
  self.main_building_content = nil
  if self.StartGuideTimer then
    self.StartGuideTimer:Stop()
    self.StartGuideTimer = nil
  end
  if self.closeArrowTimer then
    self.closeArrowTimer:Stop()
    self.closeArrowTimer = nil
  end
end

function LWUIBuildDetailsView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BuildingHeroDispatching, self.OnGetBuildingHeroDispatchingMsg)
  self:AddUIListener(EventId.UpdateBuildEffect, self.RefreshPropertys)
end

function LWUIBuildDetailsView:OnRemoveListener()
  self:RemoveUIListener(EventId.BuildingHeroDispatching, self.OnGetBuildingHeroDispatchingMsg)
  self:RemoveUIListener(EventId.UpdateBuildEffect, self.RefreshPropertys)
  base.OnRemoveListener(self)
end

function LWUIBuildDetailsView:GF_window_closed(uiname)
  if not self.closeAction then
    return
  end
  self:closeAction(uiname)
end

function LWUIBuildDetailsView:ReInit()
  self.curBuildIndex = tonumber(self:GetUserData())
  self.curBuildData = DataCenter.BuildManager:GetBuildingDataByPointId(self.curBuildIndex)
  self.buildCurLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.curBuildData.itemId, self.curBuildData.level)
  self.titleText:SetLocalText(self.buildCurLevelTemplate.name)
  self.buildIcon:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(self.curBuildData.itemId, self.curBuildData.level))
  self.curLevelText:SetLocalText(GameDialogDefine.LEVEL_NUMBER, self.curBuildData.level)
  self:Refresh()
end

function LWUIBuildDetailsView:TryStartGuide()
  if self.curBuildData.itemId ~= BuildingTypes.LW_BUILD_WORKER_HOUSE then
    return
  end
  if CommonUtil.PlayerPrefsGetInt("TryStartGuide_detail", 0) == 1 then
    return
  end
  CommonUtil.PlayerPrefsSetInt("TryStartGuide_detail", 1)
  if not self.common_building_content.worker_btn.gameObject.activeInHierarchy then
    return
  end
  self.closeAction = self.GF_window_closed_plot
  self.StartGuideTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.StartGuideTimer = nil
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = 2714, hideMainUI = false})
  end, 0.5)
end

function LWUIBuildDetailsView:GF_window_closed_plot(uiname)
  if uiname ~= UIWindowNames.UILWPlot then
    return
  end
  self.closeAction = self.GF_window_closed_arrow
  local param = {}
  param.position = self.common_building_content.worker_btn.transform.position
  param.textKey = "newbies_guide_worker_tips1"
  param.scale = Vector3.New(1, 1, 1)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIArrowFinger_New, {anim = true}, param)
end

function LWUIBuildDetailsView:GF_window_closed_arrow(uiname)
  if uiname ~= UIWindowNames.UIArrowFinger_New then
    return
  end
  self.closeAction = nil
  self.closeArrowTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.closeArrowTimer = nil
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = 2715, hideMainUI = false})
  end, 0.5)
end

function LWUIBuildDetailsView:RefreshPropertys(bUuid)
  if bUuid == self.curBuildData.uuid then
    self:Refresh()
  end
end

function LWUIBuildDetailsView:OnGetBuildingHeroDispatchingMsg()
  local isNeedPlayAni = false
  if self.curBuildData.itemId ~= BuildingTypes.FUN_BUILD_MAIN then
    isNeedPlayAni = true
  end
  if isNeedPlayAni then
    self.common_building_content:RecordCurVal()
  end
  self:Refresh()
  if isNeedPlayAni then
    self.common_building_content:TryPlayAni()
  end
end

function LWUIBuildDetailsView:Refresh()
  if self.curBuildData == nil or self.buildCurLevelTemplate == nil then
    return
  end
  if self.curBuildData.itemId == BuildingTypes.FUN_BUILD_MAIN then
    self.main_building_content:SetActive(true)
    self.common_building_content:SetActive(false)
    self.main_building_content:ReInit(self.curBuildIndex, self.curBuildData, self.buildCurLevelTemplate)
  else
    self.main_building_content:SetActive(false)
    self.common_building_content:SetActive(true)
    self.common_building_content:ReInit(self.curBuildIndex, self.curBuildData, self.buildCurLevelTemplate)
  end
end

return LWUIBuildDetailsView
