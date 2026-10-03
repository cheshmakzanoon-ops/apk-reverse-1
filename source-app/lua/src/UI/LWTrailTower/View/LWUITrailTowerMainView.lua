local LWUITrailTowerMainView = BaseClass("LWUITrailTowerMainView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWUITrailTowerTabItemRender = require("UI.LWTrailTower.Component.LWUITrailTowerTabItemRender")
local LWUITrailTowerSubView = require("UI.LWTrailTower.View.LWUITrailTowerSubView")
local LWCountBattleMapView = require("UI.LWCountBattle.MapUI.View.LWCountBattleMapView")
local LWUIStageFeatureChapterView = require("UI.LWUIStageFeatureChapter.View.LWUIStageFeatureChapterView")
local LWUIEasyStageFeatureChapterView = require("UI.LWUIEasyStageFeatureChapter.View.LWUIEasyStageFeatureChapterView")
local closeBtn_path = "Root/CloseBtn"
local titleText_path = "Root/TopContainer/TextTitle"
local tabContent_path = "Root/TopContainer/ScrollView/Viewport/TabContent"
local tabItemRender_path = "Root/TopContainer/TabItemRender"
local subPanelContainer_path = "Root/SubPanelContainer"
local infoBtn_path = "Root/InfoBtn"
local finger_path = "Root/FingerRoot"

function LWUITrailTowerMainView:UpdateTitle()
  local targetEntrance = DataCenter.LWTrailTowerManager:GetEntranceByTabType(self.targetTabType)
  if targetEntrance and targetEntrance.checkFunc() then
    self.titleText:SetLocalText(targetEntrance.titleKey)
  else
    self.titleText:SetLocalText("trialtower_039")
  end
end

function LWUITrailTowerMainView:OnCreate()
  base.OnCreate(self)
  self.targetTabType, self.showGuide, self.preLoadAssets = self:GetUserData()
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function LWUITrailTowerMainView:OnDestroy()
  self:DestroyAllSubViews()
  self:DestroyAllTabs()
  self:ComponentDestroy()
  self:DataDestroy()
  self:ClearAllDelayTimers()
  base.OnDestroy(self)
  DataCenter.StageFeatureSceneManager:TryExit()
end

function LWUITrailTowerMainView:DataDefine()
  self.tabItemDic = {}
  self.subViewPanelDic = {}
  self.subViewCompDic = {}
  self.getTrailTowerInfoRefreshView = false
  self.infoKey = ""
end

function LWUITrailTowerMainView:DataDestroy()
  self.tabItemDic = nil
  self.subViewPanelDic = nil
  self.subViewCompDic = nil
  self.getTrailTowerInfoRefreshView = nil
  self.infoKey = nil
end

function LWUITrailTowerMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetTrailTowerInfo, self.OnGetTrailTowerInfo)
end

function LWUITrailTowerMainView:OnRemoveListener()
  self:RemoveUIListener(EventId.GetTrailTowerInfo, self.OnGetTrailTowerInfo)
  base.OnRemoveListener(self)
end

function LWUITrailTowerMainView:OnGetTrailTowerInfo()
  self.getTrailTowerInfoRefreshView = true
  self:RefreshTabShow()
  self.getTrailTowerInfoRefreshView = false
end

function LWUITrailTowerMainView:ComponentDefine()
  self.CloseBtn = self:AddComponent(UIButton, closeBtn_path)
  self.CloseBtn:SetOnClick(function()
    if DataCenter.StageFeatureSceneManager:IsInScene() then
      DataCenter.StageFeatureSceneManager:Exit()
    else
      self.ctrl:CloseSelf()
    end
  end)
  self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
  self.infoBtn:SetOnClick(function()
    local curPageId = self.ctrl:GetPage()
    if curPageId == TrailTowerTabType.IntegratedStageFeatureChapter then
      self:ShowIntegratedStageHowToPlay()
      return
    end
    if string.IsNullOrEmpty(self.infoKey) then
      local serverId = LuaEntry.Player:GetSelfServerId()
      local str = LuaEntry.DataConfig:TryGetStr("lw_trialtower_faq", "k1")
      if not string.IsNullOrEmpty(str) then
        local strArr = string.split(str, "|")
        if table.count(strArr) > 0 then
          for i, v in ipairs(strArr) do
            local contentArr = string.split(v, ";")
            if table.count(contentArr) == 2 then
              local serverIdArr = string.split(contentArr[1], "-")
              if table.count(serverIdArr) == 2 then
                local serverIdStart = tonumber(serverIdArr[1])
                local serverIdEnd = tonumber(serverIdArr[2])
                if serverIdStart and serverIdEnd and serverId >= serverIdStart and serverId <= serverIdEnd then
                  self.infoKey = contentArr[2]
                  break
                end
              end
            end
          end
        end
      end
    end
    local param = {}
    param.title = "457004"
    local showKey = string.IsNullOrEmpty(self.infoKey) and "trialtower_012" or self.infoKey
    param.activityRulesStr = Localization:GetString(showKey)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.titleText:SetLocalText("trialtower_039")
  self.subPanelContainer = self:AddComponent(UIBaseContainer, subPanelContainer_path)
  self.tabContent = self:AddComponent(UIBaseContainer, tabContent_path)
  self.tabItemRender_obj = self.transform:Find(tabItemRender_path).gameObject
  self.tabItemRender_obj:GameObjectCreatePool()
  self.fingerRoot = self:AddComponent(UIBaseContainer, finger_path)
  self.fingerRoot.gameObject:SetActive(false)
end

function LWUITrailTowerMainView:ComponentDestroy()
  self.CloseBtn = nil
  self.titleText = nil
  self.infoBtn = nil
  self.subPanelContainer = nil
  self.tabContent = nil
  self.tabItemRender_obj = nil
  self.fingerRoot = nil
end

function LWUITrailTowerMainView:ReInit()
  if DataCenter.LWTrailTowerManager:GetTrailTowerSwitchIsOpen() and not DataCenter.T11IdleGameManager:IsT11IdleGameFunctionOn() then
    SFSNetwork.SendMessage(MsgDefines.TrailTowerInfo)
  end
  self:RefreshTabShow()
end

function LWUITrailTowerMainView:RefreshTabShow()
  self:DestroyAllTabs()
  local itemObj, tabItemRender
  local isOpenTrailTower = false
  self:UpdateTitle()
  isOpenTrailTower = DataCenter.LWTrailTowerManager:CheckTabOpenByTargetType(TrailTowerTabType.TrailTower, self.targetTabType)
  if isOpenTrailTower then
    itemObj = self.tabItemRender_obj:GameObjectSpawn(self.tabContent.transform)
    itemObj.name = "trailTower"
    itemObj:SetActive(true)
    tabItemRender = self.tabContent:AddComponent(LWUITrailTowerTabItemRender, itemObj.name)
    tabItemRender:SetData(TrailTowerTabType.TrailTower, Localization:GetString("trialtower_011"), false)
    self.tabItemDic[TrailTowerTabType.TrailTower] = tabItemRender
  end
  local IntegratedStageFeatureOpen = DataCenter.LWTrailTowerManager:CheckTabOpenByTargetType(TrailTowerTabType.IntegratedStageFeatureChapter, self.targetTabType)
  if IntegratedStageFeatureOpen then
    itemObj = self.tabItemRender_obj:GameObjectSpawn(self.tabContent.transform)
    itemObj.name = "IntegratedStageFeature"
    itemObj:SetActive(true)
    tabItemRender = self.tabContent:AddComponent(LWUITrailTowerTabItemRender, itemObj.name)
    tabItemRender:SetData(TrailTowerTabType.IntegratedStageFeatureChapter, Localization:GetString("special_stage_name"), false)
    self.tabItemDic[TrailTowerTabType.IntegratedStageFeatureChapter] = tabItemRender
  end
  local easyStageFeatureChapterOpen = DataCenter.LWTrailTowerManager:CheckTabOpenByTargetType(TrailTowerTabType.EasyStageFeatureChapter, self.targetTabType)
  if easyStageFeatureChapterOpen then
    itemObj = self.tabItemRender_obj:GameObjectSpawn(self.tabContent.transform)
    itemObj.name = "easyStageFeatureChapterOpen"
    itemObj:SetActive(true)
    tabItemRender = self.tabContent:AddComponent(LWUITrailTowerTabItemRender, itemObj.name)
    tabItemRender:SetData(TrailTowerTabType.EasyStageFeatureChapter, Localization:GetString("activity_breakthrough_tips_66"), false)
    self.tabItemDic[TrailTowerTabType.EasyStageFeatureChapter] = tabItemRender
  end
  local stageFeatureChapterOpen = DataCenter.LWTrailTowerManager:CheckTabOpenByTargetType(TrailTowerTabType.StageFeatureChapter, self.targetTabType)
  if stageFeatureChapterOpen then
    itemObj = self.tabItemRender_obj:GameObjectSpawn(self.tabContent.transform)
    itemObj.name = "stageFeatureChapter"
    itemObj:SetActive(true)
    tabItemRender = self.tabContent:AddComponent(LWUITrailTowerTabItemRender, itemObj.name)
    tabItemRender:SetData(TrailTowerTabType.StageFeatureChapter, Localization:GetString("special_stage_name"), false)
    self.tabItemDic[TrailTowerTabType.StageFeatureChapter] = tabItemRender
  end
  local countBattleMapOpen = DataCenter.LWTrailTowerManager:CheckTabOpenByTargetType(TrailTowerTabType.Common, self.targetTabType)
  if countBattleMapOpen then
    itemObj = self.tabItemRender_obj:GameObjectSpawn(self.tabContent.transform)
    itemObj.name = "battleCount"
    itemObj:SetActive(true)
    tabItemRender = self.tabContent:AddComponent(LWUITrailTowerTabItemRender, itemObj.name)
    tabItemRender:SetData(TrailTowerTabType.Common, Localization:GetString("trialtower_034"), false)
    self.tabItemDic[TrailTowerTabType.Common] = tabItemRender
  end
  local showGuide = self.showGuide
  self.showGuide = false
  if self.targetTabType == TrailTowerTabType.None or self.targetTabType == TrailTowerTabType.TrailTower then
    if isOpenTrailTower then
      self:OnTabItemClick(TrailTowerTabType.TrailTower, showGuide)
    else
      self:TabDefault(isOpenTrailTower, stageFeatureChapterOpen, countBattleMapOpen, easyStageFeatureChapterOpen, IntegratedStageFeatureOpen)
    end
  elseif self.targetTabType == TrailTowerTabType.StageFeatureChapter then
    if stageFeatureChapterOpen then
      self:OnTabItemClick(TrailTowerTabType.StageFeatureChapter, showGuide)
    else
      self:TabDefault(isOpenTrailTower, stageFeatureChapterOpen, countBattleMapOpen, easyStageFeatureChapterOpen, IntegratedStageFeatureOpen)
    end
  elseif self.targetTabType == TrailTowerTabType.EasyStageFeatureChapter then
    if easyStageFeatureChapterOpen then
      self:OnTabItemClick(TrailTowerTabType.EasyStageFeatureChapter, showGuide)
    else
      self:TabDefault(isOpenTrailTower, stageFeatureChapterOpen, countBattleMapOpen, easyStageFeatureChapterOpen, IntegratedStageFeatureOpen)
    end
  elseif self.targetTabType == TrailTowerTabType.IntegratedStageFeatureChapter then
    if IntegratedStageFeatureOpen then
      self:OnTabItemClick(TrailTowerTabType.IntegratedStageFeatureChapter, showGuide)
    else
      self:TabDefault(isOpenTrailTower, stageFeatureChapterOpen, countBattleMapOpen, easyStageFeatureChapterOpen, IntegratedStageFeatureOpen)
    end
  elseif self.targetTabType == TrailTowerTabType.Common then
    if countBattleMapOpen then
      self:OnTabItemClick(TrailTowerTabType.Common, showGuide)
    else
      self:TabDefault(isOpenTrailTower, stageFeatureChapterOpen, countBattleMapOpen, easyStageFeatureChapterOpen, IntegratedStageFeatureOpen)
    end
  else
    self:TabDefault(isOpenTrailTower, stageFeatureChapterOpen, countBattleMapOpen, easyStageFeatureChapterOpen, IntegratedStageFeatureOpen)
  end
end

function LWUITrailTowerMainView:TabDefault(isOpenTrailTower, stageFeatureChapterOpen, countBattleMapOpen, easyStageFeatureChapterOpen, IntegratedStageFeatureOpen)
  local tab
  if isOpenTrailTower then
    tab = TrailTowerTabType.TrailTower
  elseif stageFeatureChapterOpen then
    tab = TrailTowerTabType.StageFeatureChapter
  elseif easyStageFeatureChapterOpen then
    tab = TrailTowerTabType.EasyStageFeatureChapter
  elseif IntegratedStageFeatureOpen then
    tab = TrailTowerTabType.IntegratedStageFeatureChapter
  elseif countBattleMapOpen then
    tab = TrailTowerTabType.Common
  end
  if tab ~= nil then
    self:OnTabItemClick(tab)
  end
end

local EASY_STAGE_FEATURE_DONE_GUIDE = 1069
local EASY_STAGE_FEATURE_FIRST_CHAPTER_DONE_GUIDE = 1070

function LWUITrailTowerMainView:OnTabItemClick(newTrailTowerType, showGuide)
  local curPageId = self.ctrl:GetPage()
  if curPageId == newTrailTowerType and self.subViewPanelDic[newTrailTowerType] ~= nil and not self.getTrailTowerInfoRefreshView then
    return
  end
  if self.subViewCompDic[curPageId] then
    self.subViewCompDic[curPageId]:SetActive(false)
    self.tabItemDic[curPageId]:SetSelectState(false)
  end
  self.infoBtn:SetActive(newTrailTowerType == TrailTowerTabType.TrailTower or newTrailTowerType == TrailTowerTabType.IntegratedStageFeatureChapter)
  self.ctrl:SetPage(newTrailTowerType)
  self.tabItemDic[newTrailTowerType]:SetSelectState(true)
  local handlerData = TrailTowerContentHandler[newTrailTowerType]
  local property = self:GetAssetLoadProperty(handlerData.assetPath)
  if handlerData ~= nil and handlerData.assetPath and handlerData.cls and not self.subViewPanelDic[newTrailTowerType] then
    self.subViewPanelDic[newTrailTowerType] = self:GameObjectInstantiateAsync(handlerData.assetPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.name = newTrailTowerType
      go.transform:SetParent(self.subPanelContainer.transform)
      go.transform:Set_localScale(1, 1, 1)
      go:SetActive(true)
      local subViewComp = self.subPanelContainer:AddComponent(require(handlerData.cls), go.name)
      subViewComp:SetOffsetMinXY(0, 0)
      subViewComp:SetOffsetMaxXY(0, 0)
      self.subViewCompDic[newTrailTowerType] = subViewComp
      if newTrailTowerType == TrailTowerTabType.Common or newTrailTowerType == TrailTowerTabType.StageFeatureChapter or newTrailTowerType == TrailTowerTabType.EasyStageFeatureChapter then
        subViewComp:ReInit({autoShowTip = false, showGuide = showGuide})
      else
        subViewComp:ReInit()
      end
      local nowPageId = self.ctrl:GetPage()
      for i, v in pairs(self.subViewCompDic) do
        v:SetActive(i == nowPageId)
      end
      if handlerData.logType then
        DataCenter.LWBattleManager:SetBattleExitEndTime(handlerData.logType)
      end
    end, property)
  elseif self.subViewCompDic[newTrailTowerType] then
    self.subViewCompDic[newTrailTowerType]:SetActive(true)
    local subViewComp = self.subViewCompDic[newTrailTowerType]
    if newTrailTowerType == TrailTowerTabType.Common then
      subViewComp:ReInit({autoShowTip = false, showGuide = showGuide})
    else
      subViewComp:ReInit()
    end
    if handlerData and handlerData.logType then
      DataCenter.LWBattleManager:SetBattleExitEndTime(handlerData.logType)
    end
  end
  if newTrailTowerType == TrailTowerTabType.StageFeatureChapter then
    local easyStageOpenAndAllDone = DataCenter.LWEasyStageFeatureChapterManager:IsOpen() and DataCenter.LWEasyStageFeatureChapterManager:IsAllDone()
    local infos = DataCenter.AllianceCongratulationDataManager:GetPopInfo()
    if easyStageOpenAndAllDone then
      if infos == nil then
        DataCenter.LWGuideFlowManager:TryTriggerFlexibly(EASY_STAGE_FEATURE_DONE_GUIDE)
      else
        DataCenter.AllianceCongratulationDataManager:SetGuideInfo(EASY_STAGE_FEATURE_DONE_GUIDE)
      end
    end
  elseif newTrailTowerType == TrailTowerTabType.EasyStageFeatureChapter then
    local firstChapterOver = DataCenter.LWEasyStageFeatureChapterManager:IsOpen() and DataCenter.LWEasyStageFeatureChapterManager.currStageId == 50008
    if firstChapterOver then
      DataCenter.LWGuideFlowManager:TryTriggerFlexibly(EASY_STAGE_FEATURE_FIRST_CHAPTER_DONE_GUIDE)
    end
  end
end

function LWUITrailTowerMainView:DestroyAllTabs()
  self.tabContent:RemoveComponents(LWUITrailTowerTabItemRender)
  self.tabItemRender_obj:GameObjectRecycleAll()
  self.tabItemDic = {}
end

function LWUITrailTowerMainView:DestroyAllSubViews()
  if self.subPanelContainer then
    self.subPanelContainer:RemoveAllComponentes()
  end
  if self.subViewPanelDic ~= nil then
    for k, v in pairs(self.subViewPanelDic) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.subViewPanelDic = {}
  self.subViewCompDic = {}
end

function LWUITrailTowerMainView:CreateDelayTimer(callback, delay, timerName)
  if self.delayTimers == nil then
    self.delayTimers = {}
  end
  timerName = timerName or "timer_" .. tostring(#self.delayTimers + 1)
  local timer = TimerManager:GetInstance():DelayInvoke(function()
    if self.delayTimers[timerName] then
      self.delayTimers[timerName] = nil
    end
    callback()
  end, delay)
  self.delayTimers[timerName] = timer
  return timer
end

function LWUITrailTowerMainView:ClearAllDelayTimers()
  if self.delayTimers then
    for name, timer in pairs(self.delayTimers) do
      if timer then
        timer:Stop()
      end
    end
    self.delayTimers = {}
  end
end

function LWUITrailTowerMainView:GetAssetLoadProperty(assetName)
  if self.preLoadAssets and self.preLoadAssets[assetName] then
    return AssetLoadPriority.UltraHigh
  end
  return nil
end

function LWUITrailTowerMainView:ShowIntegratedStageHowToPlay()
  local subView = self.subViewCompDic[TrailTowerTabType.IntegratedStageFeatureChapter]
  if not subView then
    return
  end
  local difficulty = subView:GetCurDifficulty()
  if difficulty == StageFeatureIntegratedDifficulty.Hard then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, {
      howToPlayList = {100062}
    })
  elseif difficulty == StageFeatureIntegratedDifficulty.Nightmare then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, {
      howToPlayList = {100063}
    })
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, {
      howToPlayList = {100061}
    })
  end
end

return LWUITrailTowerMainView
