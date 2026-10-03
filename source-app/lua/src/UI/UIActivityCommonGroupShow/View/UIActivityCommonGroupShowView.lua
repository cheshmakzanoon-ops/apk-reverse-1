local base = UIBaseView
local UIActivityCommonGroupShowView = BaseClass("UIActivityCommonGroupShowView", base)
local GameObject = CS.UnityEngine.GameObject
local TaskActivity = require("UI.UIActivityCenterTable.Component.Task.TaskActivity")
local LWBuyDiamondResDownloadComponent = require("UI/LWGift/BuyDiamond/Component/LWBuyDiamondResDownloadComponent")
local UIActivityRedPoint = require("UI.UIActivityCommonGroupShow.Component.UIActivityRedPoint")
local panel = "Panel"
local panelContainer_path = "safeArea/panelContainer"
local download_res_content_container_path = "safeArea/downloadResContentContainer"
local toggleContent_path = "safeArea/tabsSv/Viewport/Content"
local toggleScroll_path = "safeArea/tabsSv"
local bg_path = "bg"
local bg1_path = "bg1"
local top_bar_path = "safeArea/TopBar"
local dec_path = "safeArea/TopBar/Dec"
local bg1DefaultPath = "Assets/Main/TextureEx/UICommonWindowBg/cfm_tongyon_quanping_di_1.png"
local topBarBgDefaultPath = "Assets/Main/TextureEx/UICommonWindowBg/cfm_tongyon_quanping_di_2.png"
local topBarBgDefaultHeight = 91.5
local topBarBgNewHeight = 150
local tabDownloadIconPath = "Assets/Main/Sprites/UI/LWUIActivityDownload/wxy_tongyongjiazai_yeqian_lanbing.png"
local tabSelectBgDefaultPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/zxl_tongyong_yeqian_xuanzhong.png"
local tabUnSelectBgDefaultPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_yeqian_yiji_2.png"
local activityThemPath = "Assets/Main/Sprites/UI/ActivityThemeSkin/%s"
local tabTextDefaultColor = Color.white
local tabTextOutlineDefaultColor = Color.New(0.7490196078431373, 0.7490196078431373, 0.7490196078431373, 1.0)
local tabTextShadowDefaultColor = Color.black
local SelectTextMatPath = "Assets/Main/TMPFont/Main/BodyFontMat/Body-Outline_080808_32.mat"
local downloadPrefabPath = "Assets/Main/Prefabs/UI/LWGift/LWBuyDiamondDownloadResMain.prefab"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local groupId, jumpActId = self:GetUserData()
  jumpActId = tonumber(jumpActId)
  if jumpActId then
    local lineData = LocalController:instance():tryGetLine(TableName.Activity, jumpActId)
    if lineData ~= nil and not string.IsNullOrEmpty(lineData.festival_interface_config) then
      Logger.LogWarning("FestivalActivity Open \239\188\129\239\188\129\239\188\129\239\188\129\239\188\129")
    end
  end
  self:InitUI(groupId, jumpActId)
end

local function OnDestroy(self)
  if self.refreshTimer then
    self.refreshTimer:Stop()
    self.refreshTimer = nil
  end
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.title = self:AddComponent(UIText, "safeArea/TopBar/TextTitle")
  self.titleOriginalSizeDeltaX = self.title.rectTransform.sizeDelta.x
  self.closeBtnN = self:AddComponent(UIButton, "safeArea/BottomBar/BtnBack")
  self.closeBtnN:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.panelBtn = self:AddComponent(UIButton, panel)
  self.panelBtn:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.imgBottomBg = self:AddComponent(UIImage, "safeArea/BottomBar/BottomBg")
  self.panelContainerN = self:AddComponent(UIBaseContainer, panelContainer_path)
  self.downloadResContentContainer = self:AddComponent(UIBaseContainer, download_res_content_container_path)
  self.toggleContainerN = self:AddComponent(UIBaseContainer, toggleContent_path)
  self.toggleScrollN = self:AddComponent(UIScrollRect, toggleScroll_path)
  self.bg = self:AddComponent(UIRawImage, bg_path)
  self.bg1 = self:AddComponent(UIImage, bg1_path)
  self.topBarBg = self:AddComponent(UIImage, top_bar_path)
  self.topBarDec = self:AddComponent(UIBaseContainer, dec_path)
end

local function ClearGroupContent(self)
  for k, v in pairs(self.togglesTbN) do
    if v ~= nil then
      if v.selectEffect then
        v.selectEffect:Remove()
      end
      if v.nameN and v.nameN.unity_tmpro and self.tabTextDefaultMat then
        v.nameN.unity_tmpro.fontSharedMaterial = self.tabTextDefaultMat
      end
    end
  end
  self.tabTextDefaultMat = nil
  self.togglesTbN = {}
  for k, v in pairs(self.tabTextMatsDic) do
    GameObject.Destroy(v)
  end
  self.tabTextMatsDic = {}
  self.toggleContainerN:RemoveAllComponentes()
  if self.togglesModelList ~= nil then
    for k, v in pairs(self.togglesModelList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.togglesModelList = {}
  CS.DynamicFPSConfig.FreeHighFPSLockerForChildrenScrollComponents(self.panelContainerN.gameObject)
  self.panelContainerN:RemoveAllComponentes()
  self.downloadResContentContainer:RemoveAllComponentes()
  if self.reqList ~= nil then
    for k, v in pairs(self.reqList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.reqList = {}
  self.panelList = {}
end

local function ComponentDestroy(self)
  self:ClearGroupContent()
  self.togglesTbN = nil
  self.closeBtnN = nil
  self.panelBtn = nil
  self.infoBtnN = nil
  self.panelContainerN = nil
  self.downloadResContentContainer = nil
  self.rankBtnTxtN = nil
  self.rewardBtnTxtN = nil
  self.toggleContainerN = nil
  if self.downloadResRequest then
    self:GameObjectDestroy(self.downloadResRequest)
  end
end

local function DataDefine(self)
  self.panelList = {}
  self.reqList = {}
  self.curTabIndex = nil
  self.tabTextMatsDic = {}
  self.tabTextDefaultMat = nil
  self.ctrl:SetDownloadingPageId(nil)
end

local function DataDestroy(self)
  self.panelList = nil
  self.reqList = nil
  self.curTabIndex = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.OnRefreshCallback)
  self:AddUIListener(EventId.ResourceUpdated, self.OnRefreshCallback)
  self:AddUIListener(EventId.RefreshResourceItem, self.OnRefreshCallback)
  self:AddUIListener(EventId.UpdateGold, self.OnRefreshCallback)
  self:AddUIListener(EventId.ActGiftBoxScoreRewardReceive, self.OnRefreshCallback)
  self:AddUIListener(EventId.OnPassDay, self.DelayRefreshAll)
  self:AddUIListener(EventId.ActGiftBoxTimeEnd, self.OnActGiftBoxTimeEnd)
  self:AddUIListener(EventId.CommonGroupActivityGotoPage, self.ExternalGotoActivity)
  self:AddUIListener(EventId.EnableOneUITopItem, self.OnOneUITopItemEnabled)
  self:AddUIListener(EventId.ActivityCommonGroupView_FestivalPackagingModify, self.FestivalPackagingModify)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.OnRefreshCallback)
  self:RemoveUIListener(EventId.ResourceUpdated, self.OnRefreshCallback)
  self:RemoveUIListener(EventId.RefreshResourceItem, self.OnRefreshCallback)
  self:RemoveUIListener(EventId.UpdateGold, self.OnRefreshCallback)
  self:RemoveUIListener(EventId.ActGiftBoxScoreRewardReceive, self.OnRefreshCallback)
  self:RemoveUIListener(EventId.OnPassDay, self.DelayRefreshAll)
  self:RemoveUIListener(EventId.ActGiftBoxTimeEnd, self.OnActGiftBoxTimeEnd)
  self:RemoveUIListener(EventId.CommonGroupActivityGotoPage, self.ExternalGotoActivity)
  self:RemoveUIListener(EventId.EnableOneUITopItem, self.OnOneUITopItemEnabled)
  self:RemoveUIListener(EventId.ActivityCommonGroupView_FestivalPackagingModify, self.FestivalPackagingModify)
  base.OnRemoveListener(self)
end

local function GetGroupActivityList(self)
  self.groupActList = {}
  DataCenter.ActivityListDataManager:SortActivityArr()
  local actList = DataCenter.ActivityListDataManager:GetNowActivityList(false)
  if actList ~= nil then
    for _, v in pairs(actList) do
      local group = v.festivalEntrance
      if group == self.groupId then
        if self.groupId == CommonActivityGroupEnum.S0AttackCityNew and v.type == EnumActivity.S0AttackCityClue.Type then
          local state = DataCenter.AttackCityS0DataManager:GetCityClueOpen()
          if state then
            table.insert(self.groupActList, v)
          end
        else
          table.insert(self.groupActList, v)
        end
      end
    end
  end
  for k, v in ipairs(self.groupActList) do
    v:RefreshExtraOrderData()
  end
  table.sort(self.groupActList, function(a, b)
    return a.extraOrder > b.extraOrder
  end)
end

local function GetFirstHasRedDotActId(self)
  for k, v in ipairs(self.groupActList) do
    local redNum = DataCenter.ActivityListDataManager:GetRewardNumByTypeAndId(v.type, v.id)
    if redNum == nil then
      redNum = 0
    end
    if 0 < redNum then
      return tonumber(v.id)
    end
  end
end

local function InitUI(self, groupId, jumpActId)
  self.groupId = groupId
  self.jumpActId = jumpActId
  self:GetGroupActivityList()
  local fakeDataList = self.ctrl:CheckNonActivityView(false)
  table.walk(fakeDataList, function(k, v)
    table.insert(self.groupActList, v)
  end)
  table.sort(self.groupActList, function(a, b)
    return a.extraOrder > b.extraOrder
  end)
  if not self.jumpActId then
    self.jumpActId = self:GetFirstHasRedDotActId()
    if not self.jumpActId then
      self.jumpActId = DataCenter.ActivityCommonGroupViewManager:GetLastVisitedActivityId(self.groupId)
    end
  end
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.groupId)
  if actInfo then
    self.title:SetLocalText(actInfo.name)
  elseif self.groupId and CommonActivityGroupTitle[self.groupId] then
    self.title:SetLocalText(CommonActivityGroupTitle[self.groupId])
  else
    self:CheckFestivalTitle(self.jumpActId)
  end
  if groupId and (groupId == CommonActivityGroupEnum.DoomVanguard or groupId == CommonActivityGroupEnum.Alliance) then
    self.bg:SetActive(false)
    self.bg1:SetActive(true)
  else
    self.bg:SetActive(true)
    self.bg1:SetActive(false)
  end
  self:RefreshToggles()
  DataCenter.ActivityCommonGroupViewManager:ClearAllGotoActIdList()
  DataCenter.ActivityCommonGroupViewManager:SetFirstGotoActIdList(tonumber(self.jumpActId))
  self:SetDefaultTopBarBg()
  self:SetDefaultTopBarBg()
  self:SetDefaultBottomBg()
  self:SetDefaultFullScreenBg()
end

local function RefreshToggles(self)
  self.togglesTbN = {}
  self.togglesModelList = {}
  for i = 1, #self.groupActList do
    self.togglesModelList[i] = self:GameObjectInstantiateAsync(UIAssets.UIActivityCommonGroupTab, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.toggleContainerN.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(i)
      go.name = nameStr
      local tempPath = nameStr
      local toggle = self.toggleContainerN:AddComponent(UIButton, tempPath)
      toggle:SetOnClick(function()
        DataCenter.ActivityCommonGroupViewManager:SetFirstGotoActIdList(tonumber(self.groupActList[i].id))
        self:ChangeShowType(i)
      end)
      local newTog = {}
      newTog.toggleN = toggle
      newTog.chooseN = toggle:AddComponent(UIBaseContainer, "select")
      newTog.imgChooseBg = toggle:AddComponent(UIImage, "select")
      newTog.notChooseBg = toggle:AddComponent(UIImage, "TypeButton")
      newTog.commonRedPoint = toggle:AddComponent(UIActivityRedPoint, "CommonRedPoint")
      newTog.commonRedPoint:SetType(CommonRedPointPriority.Level1)
      newTog.nameN = toggle:AddComponent(UITextMeshProUGUIEx, "activityName")
      newTog.showNewN = toggle:AddComponent(UIBaseContainer, "NewDot")
      newTog.showNewN:SetActive(false)
      newTog.ShowNewTxtN = toggle:AddComponent(UIText, "NewDot/Bg/Text")
      newTog.icon = toggle:AddComponent(UIImage, "select/Icon")
      newTog.finTip = toggle:AddComponent(UIBaseContainer, "finTip")
      newTog.actData = self.groupActList[i]
      table.insert(self.togglesTbN, newTog)
      if #self.togglesTbN == #self.groupActList then
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.toggleContainerN.transform)
        local jumpIndex = 1
        if self.jumpActId then
          for k, v in pairs(self.groupActList) do
            if tonumber(v.id) == self.jumpActId then
              jumpIndex = k
              break
            end
          end
        end
        self.jumpActId = tonumber(self.groupActList[jumpIndex].id)
        local normalizedPosition = 0
        if #self.groupActList > 1 then
          normalizedPosition = (jumpIndex - 1) / (#self.groupActList - 1)
        end
        self.toggleScrollN:SetHorizontalNormalizedPosition(normalizedPosition)
        self:ChangeShowType(jumpIndex)
        self:RefreshTabs()
        self:RefreshRed()
      end
    end)
  end
end

local function RefreshAll(self)
  local curActId = tonumber(self.groupActList[self.curTabIndex].id)
  if 0 < curActId then
    self.jumpActId = curActId
  end
  self:OnRefreshCallback()
end

local function RefreshTabs(self)
  local curDownloadingPageId = self.ctrl:GetDownloadingPageId()
  local showDownloadPage = self:CheckShowDownloadPage(curDownloadingPageId)
  for _, v in ipairs(self.togglesTbN) do
    v.nameN:SetLocalText(v.actData.name)
    if showDownloadPage then
      v.icon:LoadSprite(tabDownloadIconPath)
    elseif not string.IsNullOrEmpty(v.actData.list_icon) then
      v.icon:LoadSprite(DataCenter.ActivityListDataManager:GetActivityModLoadPath(LoadPath.ActivityIconPath, v.actData.list_icon))
    end
    if showDownloadPage or v.actData:GetFestivalInterfaceCfgId() == nil or v.actData:GetFestivalInterfaceCfgId() == 0 then
      self:SetDefaultTabPacking(v)
    else
      self:ModifyTabPacking(v)
    end
  end
end

function UIActivityCommonGroupShowView:SetDefaultTabPacking(toggleData)
  toggleData.imgChooseBg:LoadSprite(tabSelectBgDefaultPath)
  toggleData.notChooseBg:LoadSprite(tabUnSelectBgDefaultPath)
  toggleData.nameN:ChangeNewMaterial(SelectTextMatPath)
end

function UIActivityCommonGroupShowView:ModifyTabPacking(toggleData)
  local lineData = LocalController:instance():getLine(TableName.Festival_Interface_Config, toggleData.actData:GetFestivalInterfaceCfgId())
  if lineData == nil then
    Logger.LogError("Festival_Interface_Config GetTemplate lineData is nil id:" .. toggleData.actData:GetFestivalInterfaceCfgId())
    return
  end
  if string.IsNullOrEmpty(lineData.page) then
    self:SetDefaultTabPacking(toggleData)
  else
    local pageList = string.split(lineData.page, "|")
    toggleData.imgChooseBg:LoadSprite(DataCenter.ActivityListDataManager:GetActivityModLoadPath(activityThemPath, pageList[1]))
    toggleData.notChooseBg:LoadSprite(DataCenter.ActivityListDataManager:GetActivityModLoadPath(activityThemPath, pageList[2]))
  end
  local textCfgColor = lineData.pagetext_color and lineData.pagetext_color or ""
  local textCfgOutlineColor = lineData.pagetext_stroke_color and lineData.pagetext_stroke_color or ""
  local textCfgShadowColor = lineData.pagetext_shadow_color and lineData.pagetext_shadow_color or ""
  local textMatKey = textCfgColor .. textCfgOutlineColor .. textCfgShadowColor
  self.tabTextDefaultMat = toggleData.nameN.unity_tmpro.fontSharedMaterial
  if textMatKey ~= "" then
    if IsNull(self.tabTextMatsDic[textMatKey]) then
      local newFontMaterial = CS.UnityEngine.Material(self.tabTextDefaultMat)
      newFontMaterial.name = textMatKey
      if IsNotNull(newFontMaterial) then
        local textColor = tabTextDefaultColor
        if textCfgColor ~= "" then
          local tmpColor255 = string.string2array_i_oneSep(textCfgColor, ";")
          textColor = Color.New(tmpColor255[1] / 255, tmpColor255[2] / 255, tmpColor255[3] / 255, tmpColor255[4] / 255)
        end
        newFontMaterial:SetColor("_FaceColor", textColor)
        local textOutlineColor = tabTextOutlineDefaultColor
        if textCfgOutlineColor ~= "" then
          local tmpColor255 = string.string2array_i_oneSep(textCfgOutlineColor, ";")
          textOutlineColor = Color.New(tmpColor255[1] / 255, tmpColor255[2] / 255, tmpColor255[3] / 255, tmpColor255[4] / 255)
        end
        newFontMaterial:SetColor("_OutlineColor", textOutlineColor)
        local textShadowColor = tabTextShadowDefaultColor
        if textCfgShadowColor ~= "" then
          local tmpColor255 = string.string2array_i_oneSep(textCfgShadowColor, ";")
          textShadowColor = Color.New(tmpColor255[1] / 255, tmpColor255[2] / 255, tmpColor255[3] / 255, tmpColor255[4] / 255)
        end
        newFontMaterial:SetColor("_ShadowColor", textShadowColor)
        self.tabTextMatsDic[textMatKey] = newFontMaterial
      end
    end
    toggleData.nameN.unity_tmpro.fontSharedMaterial = self.tabTextMatsDic[textMatKey]
  end
end

local function OnRefreshCallback(self)
  local oldActList = self.groupActList
  self:GetGroupActivityList()
  if #self.groupActList == 0 then
    self.ctrl:CloseSelf()
    return
  end
  local fakeDataList = self.ctrl:CheckNonActivityView(false)
  table.walk(fakeDataList, function(k, v)
    table.insert(self.groupActList, v)
  end)
  table.sort(self.groupActList, function(a, b)
    return a.extraOrder > b.extraOrder
  end)
  local isHaveDiff = false
  if #oldActList ~= #self.groupActList then
    isHaveDiff = true
  else
    for k, v in ipairs(self.groupActList) do
      local oldData = oldActList[k]
      if v.id ~= oldData.id then
        isHaveDiff = true
        break
      end
    end
  end
  if isHaveDiff then
    self.curTabIndex = nil
    self:ClearGroupContent()
    self:RefreshToggles()
  end
  self:RefreshRed()
end

local function DelayRefreshAll(self)
  self.refreshTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.refreshTimer = nil
    self:RefreshAll()
  end, 3)
end

local function OnActGiftBoxTimeEnd(self)
  self.ctrl:CloseSelf()
end

local function RefreshRed(self)
  local curDownloadingPageId = self.ctrl:GetDownloadingPageId()
  local showDownloadPage = self:CheckShowDownloadPage(curDownloadingPageId)
  if showDownloadPage then
    for i, v in ipairs(self.togglesTbN) do
      v.commonRedPoint:SetActive(false)
    end
    return
  end
  for i, v in ipairs(self.togglesTbN) do
    local redCount, rewardCount, tipCount = DataCenter.ActivityListDataManager:GetRewardNumByTypeAndId(v.actData.type, v.actData.id)
    if redCount and 0 < redCount then
      if self.groupId == CommonActivityGroupEnum.DoomVanguard then
        if 0 < rewardCount then
          v.commonRedPoint:SetNum(rewardCount)
        else
          v.commonRedPoint:SetDefaultVisible(0 < redCount)
        end
      elseif v.actData.type == EnumActivity.ActMonopoly.Type or v.actData.type == EnumActivity.ActSlotMachine.Type or v.actData.type == EnumActivity.Banquet.Type or v.actData.type == EnumActivity.ActValentineReceiveGift.Type or v.actData.type == EnumActivity.ActValentineSendGift.Type or v.actData.type == EnumActivity.ActEasterEgg.Type or v.actData.type == EnumActivity.CrazyRock.Type then
        v.commonRedPoint:SetDefaultVisible(0 < redCount)
      else
        v.commonRedPoint:SetNum(0, redCount)
      end
    else
      v.commonRedPoint:SetActive(false)
    end
  end
end

local function ChangeShowType(self, tabIndex)
  local showDownloadPage = self:CheckShowDownloadPage(tabIndex)
  self:ShowDownloadComponentState(tabIndex, showDownloadPage)
  if showDownloadPage then
    self:SetDefaultTopBarBg()
    self:SetDefaultBottomBg()
    self:SetDefaultFullScreenBg()
    for i = 1, #self.togglesTbN do
      self:SetToggleTbNState(i, tabIndex)
    end
    return
  end
  if self.curTabIndex == tabIndex then
    return
  end
  local targetActData = self.groupActList[tabIndex]
  local isTargetActHaveClick = DataCenter.ActivityCommonGroupViewManager:GetClickActIdRecord(tonumber(targetActData.id))
  DataCenter.ActivityCommonGroupViewManager:SetActPanelShowRecord(self.groupId, tonumber(targetActData.id))
  if targetActData.type == EnumActivity.CitySkinExchange.Type and not isTargetActHaveClick then
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
  for i = 1, #self.togglesTbN do
    self:SetToggleTbNState(i, tabIndex)
    self:SetTabSelectEffect(i, tabIndex)
  end
  self:FestivalPackagingModifyByActivityId(tonumber(targetActData.id))
  local nextHandler
  if SubTypeActivities[self.groupActList[tabIndex].type] ~= nil then
    nextHandler = SubTypeActivities[self.groupActList[tabIndex].type][self.groupActList[tabIndex].subViewType]
  elseif self.groupActList[tabIndex].type == EnumActivity.FakeActivity.Type then
    nextHandler = NonActivityContentHandler[self.groupActList[tabIndex].noneActType]
  else
    nextHandler = ActivityContentHandler[self.groupActList[tabIndex].type]
  end
  if nextHandler == nil then
    return
  end
  local curHandler
  if self.curTabIndex then
    if self.curTabIndex > #self.groupActList then
      self.curTabIndex = tabIndex
    end
    if SubTypeActivities[self.groupActList[self.curTabIndex].type] then
      curHandler = SubTypeActivities[self.groupActList[self.curTabIndex].type][self.groupActList[self.curTabIndex].subViewType]
    elseif self.groupActList[self.curTabIndex].type == EnumActivity.FakeActivity.Type then
      curHandler = NonActivityContentHandler[self.groupActList[self.curTabIndex].noneActType]
    else
      curHandler = ActivityContentHandler[self.groupActList[self.curTabIndex].type]
    end
  end
  local prefabName = nextHandler.assetPath
  if self.curTabIndex and curHandler and prefabName == curHandler.assetPath then
    self.curTabIndex = tabIndex
    self:RefreshOnShowPanel()
  else
    if CommonUtil.IsArabic() then
      self.title.rectTransform.sizeDelta = Vector2.New(self.titleOriginalSizeDeltaX, self.title.rectTransform.sizeDelta.y)
    end
    if not self.panelList[prefabName] then
      if self.reqList[prefabName] then
        return
      end
      local assetFullPath = prefabName
      self.reqList[prefabName] = self:GameObjectInstantiateAsync(assetFullPath, function(request)
        if request.isError then
          return
        end
        if self.curTabIndex and curHandler and curHandler.assetPath then
          self.panelList[curHandler.assetPath]:SetActive(false)
        end
        self.curTabIndex = tabIndex
        local go = request.gameObject
        go.transform:SetParent(self.panelContainerN.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local v3 = go.transform.position
        v3.x = 0
        v3.y = 0
        go.transform.position = v3
        local script = require(nextHandler.cls)
        local cell = self.panelContainerN:AddComponent(script, go)
        self.panelList[prefabName] = cell
        self.panelList[prefabName]:SetActive(true)
        self:RefreshOnShowPanel()
        CS.DynamicFPSConfig.AcquireHighFPSLockerForChildrenScrollComponents(go)
      end)
    else
      if self.curTabIndex then
        self.panelList[curHandler.assetPath]:SetActive(false)
      end
      self.curTabIndex = tabIndex
      self.panelList[prefabName]:SetActive(true)
      self:RefreshOnShowPanel()
    end
  end
end

function UIActivityCommonGroupShowView:SetToggleTbNState(i, tabIndex)
  self.togglesTbN[i].chooseN:SetActive(i == tabIndex)
  self.togglesTbN[i].icon:SetActive(i == tabIndex)
  self.togglesTbN[i].nameN:SetActive(i ~= tabIndex)
  local curActData = self.groupActList[i]
  self.togglesTbN[i].finTip:SetActive(curActData:CheckIfIsToEnd())
end

function UIActivityCommonGroupShowView:SetTabSelectEffect(i, tabIndex)
  local festivalPackagingCfgId = self.togglesTbN[i].actData:GetFestivalInterfaceCfgId()
  if festivalPackagingCfgId ~= nil and festivalPackagingCfgId ~= 0 then
    local lineData = LocalController:instance():getLine(TableName.Festival_Interface_Config, festivalPackagingCfgId)
    if lineData == nil then
      Logger.LogError("Festival_Interface_Config GetTemplate lineData is nil id:" .. festivalPackagingCfgId)
      return
    end
    if not string.IsNullOrEmpty(lineData.page_select_effect) and i == tabIndex then
      if self.togglesTbN[i].selectEffect == nil then
        local param = {
          lifeType = UIVfxLifeType.Stay,
          isBreak = true
        }
        self.togglesTbN[i].selectEffect = self.togglesTbN[i].toggleN:AddComponent(UIVfx, "select/VFXNode", lineData.page_select_effect, param)
      end
      self.togglesTbN[i].selectEffect:Replay()
    end
  end
end

local function RefreshOnShowPanel(self)
  local curHandler
  if SubTypeActivities[self.groupActList[self.curTabIndex].type] then
    curHandler = SubTypeActivities[self.groupActList[self.curTabIndex].type][self.groupActList[self.curTabIndex].subViewType]
  elseif self.groupActList[self.curTabIndex].type == EnumActivity.FakeActivity.Type then
    curHandler = NonActivityContentHandler[self.groupActList[self.curTabIndex].noneActType]
  else
    curHandler = ActivityContentHandler[self.groupActList[self.curTabIndex].type]
  end
  local tempPanel = curHandler.assetPath
  local showType = self.groupActList[self.curTabIndex].type
  local actId = self.groupActList[self.curTabIndex].id
  self.panelList[tempPanel]:SetData(actId, actId)
  DataCenter.ActivityTipsManager:RecordSeenUI(actId, showType)
end

local function OnClickCloseBtn(self)
  local jumpRecordList = DataCenter.ActivityCommonGroupViewManager:GetGotoActIdList()
  if jumpRecordList and 2 <= #jumpRecordList then
    local listLen = #jumpRecordList
    local lastActId = jumpRecordList[listLen]
    local targetActId = jumpRecordList[listLen - 1]
    local targetIndex
    local curActId = tonumber(self.groupActList[self.curTabIndex].id)
    if curActId == lastActId then
      for k, v in pairs(self.groupActList) do
        if tonumber(v.id) == tonumber(targetActId) then
          targetIndex = k
          jumpRecordList[listLen] = nil
          break
        end
      end
    end
    if targetIndex then
      self:ChangeShowType(targetIndex)
    else
      self.ctrl:CloseSelf()
    end
  else
    self.ctrl:CloseSelf()
  end
end

local function ExternalGotoActivity(self, gotoData)
  if not gotoData then
    return
  end
  local groupId = gotoData.groupId
  local actId = gotoData.actId
  if not groupId or not actId then
    return
  end
  local curActData = self.groupActList[self.curTabIndex]
  if self.groupId == groupId and curActData.id == actId then
    return
  end
  if self.groupId ~= groupId then
    self.groupId = groupId
    self:ClearGroupContent()
    self:InitUI(groupId, actId)
  else
    local tabIndex
    for k, v in pairs(self.groupActList) do
      if tonumber(v.id) == tonumber(actId) then
        tabIndex = k
        break
      end
    end
    if tabIndex then
      local normalizedPosition = (tabIndex - 1) / (#self.groupActList - 1)
      self:ChangeShowType(tabIndex)
      self.toggleScrollN:SetHorizontalNormalizedPosition(normalizedPosition)
    end
    DataCenter.ActivityCommonGroupViewManager:AddGotoActIdList(tonumber(actId))
  end
end

local function OnOneUITopItemEnabled(self)
  if CommonUtil.IsArabic() then
    local oldSizeDeltaX = self.title.rectTransform.sizeDelta.x
    local oldSizeDeltaY = self.title.rectTransform.sizeDelta.y
    self.title.rectTransform.sizeDelta = Vector2.New(oldSizeDeltaX - 200, oldSizeDeltaY)
  end
end

function UIActivityCommonGroupShowView:FestivalPackagingModify(packingParams)
  if packingParams == nil then
    Logger.LogError("\229\189\147\229\137\141\229\173\144\233\161\181\231\173\190\229\136\183\230\150\176\230\180\187\229\138\168\228\184\187\231\149\140\233\157\162\229\140\133\232\163\133\230\151\182\230\178\161\230\156\137\228\188\160\229\143\130\239\188\129\232\175\183\230\163\128\230\159\165\228\187\163\231\160\129")
    return
  end
  local lineData = LocalController:instance():getLine(TableName.Activity, packingParams.activityId)
  if lineData == nil then
    Logger.LogError("Activity GetTemplate lineData is nil id:" .. packingParams.activityId)
    return nil
  end
  if string.IsNullOrEmpty(lineData.festival_interface_config) then
    self:SetDefaultTopBarBg()
    return
  end
  local festivalPackagingCfgId = tonumber(lineData.festival_interface_config)
  lineData = LocalController:instance():getLine(TableName.Festival_Interface_Config, festivalPackagingCfgId)
  if lineData == nil then
    Logger.LogError("Festival_Interface_Config GetTemplate lineData is nil id:" .. festivalPackagingCfgId)
    return
  end
  self:ModifyTopBannerBg(lineData, packingParams.isShowItemTopBar)
end

function UIActivityCommonGroupShowView:FestivalPackagingModifyByActivityId(activityId)
  if activityId == nil then
    Logger.LogError("\229\189\147\229\137\141\229\173\144\233\161\181\231\173\190\229\136\183\230\150\176\230\180\187\229\138\168\228\184\187\231\149\140\233\157\162\229\140\133\232\163\133\230\151\182activityId\228\184\186\231\169\186\239\188\129\232\175\183\230\163\128\230\159\165\228\187\163\231\160\129")
    return
  end
  local lineData = LocalController:instance():getLine(TableName.Activity, activityId)
  if lineData == nil then
    Logger.LogError("Activity GetTemplate lineData is nil id:" .. activityId)
    return nil
  end
  if string.IsNullOrEmpty(lineData.festival_interface_config) then
    self:SetDefaultBottomBg()
    self:SetDefaultFullScreenBg()
    return
  end
  local festivalPackagingCfgId = tonumber(lineData.festival_interface_config)
  lineData = LocalController:instance():getLine(TableName.Festival_Interface_Config, festivalPackagingCfgId)
  if lineData == nil then
    Logger.LogError("Festival_Interface_Config GetTemplate lineData is nil id:" .. festivalPackagingCfgId)
    return
  end
  self:ModifyBottomBg(lineData)
  self:ModifyFullScreenBg(lineData)
end

function UIActivityCommonGroupShowView:ModifyTopBannerBg(lineData, isShowItemTopBar)
  if string.IsNullOrEmpty(lineData.banner) then
    self:SetDefaultTopBarBg()
    return
  end
  self.topBarDec:SetActive(false)
  self.topBarBg:SetSizeDeltaY(topBarBgNewHeight)
  local bannerList = string.split(lineData.banner, "|")
  local imgPath = isShowItemTopBar and bannerList[1] or bannerList[2]
  self.topBarBg:LoadSprite(DataCenter.ActivityListDataManager:GetActivityModLoadPath(activityThemPath, imgPath))
end

function UIActivityCommonGroupShowView:SetDefaultTopBarBg()
  self.topBarDec:SetActive(true)
  self.topBarBg:SetSizeDeltaY(topBarBgDefaultHeight)
  self.topBarBg:LoadSprite(topBarBgDefaultPath)
end

function UIActivityCommonGroupShowView:ModifyBottomBg(lineData)
  if string.IsNullOrEmpty(lineData.button_pic) then
    self:SetDefaultBottomBg()
    return
  end
  self.imgBottomBg:SetActive(true)
  self.imgBottomBg:LoadSprite(DataCenter.ActivityListDataManager:GetActivityModLoadPath(activityThemPath, lineData.button_pic))
end

function UIActivityCommonGroupShowView:SetDefaultBottomBg()
  self.imgBottomBg:SetActive(false)
end

function UIActivityCommonGroupShowView:ModifyFullScreenBg(lineData)
  if string.IsNullOrEmpty(lineData.bg) then
    self:SetDefaultFullScreenBg()
    return
  end
  self.bg:SetActive(false)
  self.bg1:SetActive(true)
  self.bg1:LoadSprite(DataCenter.ActivityListDataManager:GetActivityModLoadPath(activityThemPath, lineData.bg))
end

function UIActivityCommonGroupShowView:SetDefaultFullScreenBg()
  self.bg1:LoadSprite(bg1DefaultPath)
end

function UIActivityCommonGroupShowView:CheckShowDownloadPage(tabIndex)
  if tabIndex == nil or tabIndex < 1 or self.groupActList == nil or #self.groupActList == 0 then
    return false
  end
  local targetActData = self.groupActList[tabIndex]
  if targetActData == nil then
    return false
  end
  self.ctrl:SetDownloadingPageId(tabIndex)
  local activityId = tonumber(targetActData.id)
  local isNeedCheckDownloadRes = DataCenter.ActivityListDataManager:IsNeedCheckDownloadRes(activityId)
  local isDownloadResComplete = DataCenter.ActivityListDataManager:IsDownloadResComplete(activityId)
  return isNeedCheckDownloadRes and not isDownloadResComplete
end

function UIActivityCommonGroupShowView:ShowDownloadComponentState(tabIndex, showDownloadPage)
  local targetActData = self.groupActList[tabIndex]
  local activityId = tonumber(targetActData.id)
  self.panelContainerN:SetActive(not showDownloadPage)
  self.downloadResContentContainer:SetActive(showDownloadPage)
  if showDownloadPage and self.downloadResRequest == nil then
    self.downloadResRequest = self:GameObjectInstantiateAsync(downloadPrefabPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.downloadResContentContainer.transform)
      go.transform:Set_localScale(1, 1, 1)
      self.downloadResComp = self.downloadResContentContainer:AddComponent(LWBuyDiamondResDownloadComponent, go.name)
      self.downloadResComp:SetOffsetMinXY(0, 0)
      self.downloadResComp:SetOffsetMaxXY(0, 0)
      self.downloadResComp:SetDataByActivityId(activityId, function()
        if self.ctrl then
          local curDownloadingPageId = self.ctrl:GetDownloadingPageId()
          self:ChangeShowType(curDownloadingPageId)
          self:RefreshTabs()
          self:RefreshRed()
        end
      end)
    end)
  end
end

function UIActivityCommonGroupShowView:CheckFestivalTitle(activityId)
  self.title:SetText("")
  local actData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if not actData then
    return
  end
  if string.IsNullOrEmpty(actData.festival_icon) or actData.festivalEntranceeffect <= 0 then
    return
  end
  local itemNameTxt = ""
  if actData.festivalEntranceeffect and actData.festivalEntranceeffect > 0 then
    local line = LocalController:instance():getLine(TableName.ACTIVITY_ENTRANCE_CONFIG, actData.festivalEntranceeffect)
    if not line then
      return
    end
    if not line.name then
      return
    end
    local nameList = string.split(line.name, "|")
    local targetIndex = self:GetShowTargetIndex(line)
    if nameList and nameList[targetIndex] then
      itemNameTxt = nameList[targetIndex]
    end
  else
    itemNameTxt = actData.festivalEntranceName
  end
  if string.IsNullOrEmpty(itemNameTxt) then
    return
  end
  self.title:SetLocalText(itemNameTxt)
end

function UIActivityCommonGroupShowView:GetShowTargetIndex(line)
  local targetIndex = 1
  if not string.IsNullOrEmpty(line.extra_condition) then
    local dataList = string.string2array_num(line.extra_condition, ";", "|")
    if dataList and #dataList == 2 and #dataList[1] == 1 and #dataList[2] > 0 then
      local actId = dataList[1][1]
      local dayNumList = dataList[2]
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local actStartTime = self:GetActStartTime(actId)
      local curDayNum = math.floor((curTime - actStartTime) / (OneDayTime * 1000)) + 1
      local findIndex = -1
      for i, v in ipairs(dayNumList) do
        if v > curDayNum then
          findIndex = i
          break
        end
      end
      if findIndex <= 0 then
        findIndex = #dayNumList + 1
      end
      targetIndex = findIndex
    end
  end
  return targetIndex
end

function UIActivityCommonGroupShowView:GetActStartTime(actId)
  local time = 0
  local tabData = LocalController:instance():getLine(TableName.Activity, toInt(actId))
  local AbsoluteTimeType = "101"
  if tabData and tabData.timeType == AbsoluteTimeType then
    local startTimeStr = tabData.para1
    local absoluteTime = UIUtil.GetAbsoluteTimeByStr(startTimeStr)
    if absoluteTime then
      time = absoluteTime * 1000
      time = time - 10000
    end
  end
  return time
end

UIActivityCommonGroupShowView.OnCreate = OnCreate
UIActivityCommonGroupShowView.OnDestroy = OnDestroy
UIActivityCommonGroupShowView.ComponentDefine = ComponentDefine
UIActivityCommonGroupShowView.ComponentDestroy = ComponentDestroy
UIActivityCommonGroupShowView.DataDefine = DataDefine
UIActivityCommonGroupShowView.DataDestroy = DataDestroy
UIActivityCommonGroupShowView.OnAddListener = OnAddListener
UIActivityCommonGroupShowView.OnRemoveListener = OnRemoveListener
UIActivityCommonGroupShowView.InitUI = InitUI
UIActivityCommonGroupShowView.RefreshToggles = RefreshToggles
UIActivityCommonGroupShowView.RefreshTabs = RefreshTabs
UIActivityCommonGroupShowView.RefreshAll = RefreshAll
UIActivityCommonGroupShowView.ChangeShowType = ChangeShowType
UIActivityCommonGroupShowView.RefreshOnShowPanel = RefreshOnShowPanel
UIActivityCommonGroupShowView.RefreshRed = RefreshRed
UIActivityCommonGroupShowView.OnClickCloseBtn = OnClickCloseBtn
UIActivityCommonGroupShowView.OnRefreshCallback = OnRefreshCallback
UIActivityCommonGroupShowView.DelayRefreshAll = DelayRefreshAll
UIActivityCommonGroupShowView.OnActGiftBoxTimeEnd = OnActGiftBoxTimeEnd
UIActivityCommonGroupShowView.GetGroupActivityList = GetGroupActivityList
UIActivityCommonGroupShowView.GetFirstHasRedDotActId = GetFirstHasRedDotActId
UIActivityCommonGroupShowView.ExternalGotoActivity = ExternalGotoActivity
UIActivityCommonGroupShowView.ClearGroupContent = ClearGroupContent
UIActivityCommonGroupShowView.OnOneUITopItemEnabled = OnOneUITopItemEnabled
return UIActivityCommonGroupShowView
