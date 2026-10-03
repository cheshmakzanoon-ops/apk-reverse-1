local base = UIBaseView
local UIFlowerTrainCommonGroupShowView = BaseClass("UIFlowerTrainCommonGroupShowView", base)
local GameObject = CS.UnityEngine.GameObject
local TaskActivity = require("UI.UIActivityCenterTable.Component.Task.TaskActivity")
local LWBuyDiamondResDownloadComponent = require("UI/LWGift/BuyDiamond/Component/LWBuyDiamondResDownloadComponent")
local UIFlowerTrainRedPoint = require("UI.FlowerTrain.UIFlowerTrainCommonGroupShow.Component.UIFlowerTrainRedPoint")
local panel = "Panel"
local panelContainer_path = "safeArea/panelContainer"
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
local AssetsConfig = {
  {
    assetPath = "Assets/Main/Prefabs/UI/FlowerTrain/UIFlowerTrainShowList.prefab",
    cls = "UI.FlowerTrain.UIFlowerTrainCommonGroupShow.Component.UIFlowerTrainShowList"
  },
  {
    assetPath = "Assets/Main/Prefabs/UI/FlowerTrain/UIFlowerTrainRankList.prefab",
    cls = "UI.FlowerTrain.UIFlowerTrainCommonGroupShow.Component.UIFlowerTrainRankListView"
  }
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local groupId, jumpActId = self:GetUserData()
  jumpActId = tonumber(jumpActId)
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
  self.toggleContainerN = self:AddComponent(UIBaseContainer, toggleContent_path)
  self.toggleScrollN = self:AddComponent(UIScrollRect, toggleScroll_path)
  self.bg = self:AddComponent(UIRawImage, bg_path)
  self.bg1 = self:AddComponent(UIImage, bg1_path)
  self.topBarBg = self:AddComponent(UIImage, top_bar_path)
  self.topBarDec = self:AddComponent(UIBaseContainer, dec_path)
end

local function ClearGroupContent(self)
end

local function ComponentDestroy(self)
  self:ClearGroupContent()
  self.togglesTbN = nil
  self.closeBtnN = nil
  self.panelBtn = nil
  self.infoBtnN = nil
  self.panelContainerN = nil
  self.rankBtnTxtN = nil
  self.rewardBtnTxtN = nil
  self.toggleContainerN = nil
end

local function DataDefine(self)
  self.toggleDataList = {
    {
      name = "common_treasure_tab_01"
    },
    {
      name = "2025halloween_treasure_page_name2"
    }
  }
  self.panelList = {}
  self.reqList = {}
  self.curTabIndex = nil
  self.tabTextMatsDic = {}
  self.tabTextDefaultMat = nil
end

local function DataDestroy(self)
  self.toggleDataList = {}
  self.panelList = nil
  self.reqList = nil
  self.curTabIndex = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ResourceUpdated, self.OnRefreshCallback)
  self:AddUIListener(EventId.RefreshResourceItem, self.OnRefreshCallback)
  self:AddUIListener(EventId.UpdateGold, self.OnRefreshCallback)
  self:AddUIListener(EventId.OnPassDay, self.DelayRefreshAll)
  self:AddUIListener(EventId.EnableOneUITopItem, self.OnOneUITopItemEnabled)
  self:AddUIListener(EventId.ActivityCommonGroupView_FestivalPackagingModify, self.FestivalPackagingModify)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.ResourceUpdated, self.OnRefreshCallback)
  self:RemoveUIListener(EventId.RefreshResourceItem, self.OnRefreshCallback)
  self:RemoveUIListener(EventId.UpdateGold, self.OnRefreshCallback)
  self:RemoveUIListener(EventId.OnPassDay, self.DelayRefreshAll)
  self:RemoveUIListener(EventId.EnableOneUITopItem, self.OnOneUITopItemEnabled)
  self:RemoveUIListener(EventId.ActivityCommonGroupView_FestivalPackagingModify, self.FestivalPackagingModify)
  base.OnRemoveListener(self)
end

local function GetGroupActivityList(self)
  self.groupActList = {}
end

local function InitUI(self, groupId, jumpActId)
  self.groupId = groupId
  self.jumpActId = jumpActId
  self:GetGroupActivityList()
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(jumpActId)
  table.sort(self.groupActList, function(a, b)
    return a.extraOrder > b.extraOrder
  end)
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.groupId)
  if actInfo then
    self.title:SetLocalText(actInfo.name)
  elseif self.groupId and CommonActivityGroupTitle[self.groupId] then
    self.title:SetLocalText(CommonActivityGroupTitle[self.groupId])
  else
    self:CheckFestivalTitle(self.jumpActId)
  end
  self.bg:SetActive(true)
  self.bg1:SetActive(false)
  self:RefreshToggles()
  self:SetDefaultTopBarBg()
  self:SetDefaultBottomBg()
  self:SetDefaultFullScreenBg()
  self:FestivalPackagingModifyByActivityId(tonumber(self.jumpActId))
  self:FestivalPackagingModify({
    activityId = self.jumpActId,
    isShowItemTopBar = false
  })
end

local function RefreshToggles(self)
  self.togglesTbN = {}
  self.togglesModelList = {}
  for i = 1, #self.toggleDataList do
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
        self:ChangeShowType(i)
      end)
      local newTog = {}
      newTog.toggleN = toggle
      newTog.chooseN = toggle:AddComponent(UIBaseContainer, "select")
      newTog.imgChooseBg = toggle:AddComponent(UIImage, "select")
      newTog.notChooseBg = toggle:AddComponent(UIImage, "TypeButton")
      newTog.commonRedPoint = toggle:AddComponent(UIFlowerTrainRedPoint, "CommonRedPoint")
      newTog.commonRedPoint:SetType(CommonRedPointPriority.Level1)
      newTog.nameN = toggle:AddComponent(UITextMeshProUGUIEx, "activityName")
      newTog.showNewN = toggle:AddComponent(UIBaseContainer, "NewDot")
      newTog.showNewN:SetActive(false)
      newTog.ShowNewTxtN = toggle:AddComponent(UIText, "NewDot/Bg/Text")
      newTog.icon = toggle:AddComponent(UIImage, "select/Icon")
      newTog.finTip = toggle:AddComponent(UIBaseContainer, "finTip")
      newTog.actData = self.activityData
      table.insert(self.togglesTbN, newTog)
      if #self.togglesTbN == #self.toggleDataList then
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.toggleContainerN.transform)
        local jumpIndex = 1
        local normalizedPosition = 0
        if #self.toggleDataList > 1 then
          normalizedPosition = (jumpIndex - 1) / (#self.toggleDataList - 1)
        end
        self.toggleScrollN:SetHorizontalNormalizedPosition(normalizedPosition)
        self:ChangeShowType(jumpIndex)
        self:RefreshTabs()
      end
    end)
  end
end

local function RefreshAll(self)
  self:OnRefreshCallback()
end

local function RefreshTabs(self)
  for i, v in ipairs(self.togglesTbN) do
    v.nameN:SetLocalText(self.toggleDataList[i].name)
    self:ModifyTabPacking(v)
  end
end

function UIFlowerTrainCommonGroupShowView:SetDefaultTabPacking(toggleData)
  toggleData.imgChooseBg:LoadSprite(tabSelectBgDefaultPath)
  toggleData.notChooseBg:LoadSprite(tabUnSelectBgDefaultPath)
  toggleData.nameN:ChangeNewMaterial(SelectTextMatPath)
end

function UIFlowerTrainCommonGroupShowView:ModifyTabPacking(toggleData)
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
end

local function DelayRefreshAll(self)
  self.refreshTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.refreshTimer = nil
    self:RefreshAll()
  end, 3)
end

local function ChangeShowType(self, tabIndex)
  if self.curTabIndex == tabIndex then
    return
  end
  for i = 1, #self.togglesTbN do
    self:SetToggleTbNState(i, tabIndex)
  end
  self:FestivalPackagingModifyByActivityId(tonumber(self.jumpActId))
  local curHandler
  if self.curTabIndex then
    if self.curTabIndex > #self.toggleDataList then
      self.curTabIndex = tabIndex
    end
    curHandler = AssetsConfig[self.curTabIndex]
  end
  local nextHandler = AssetsConfig[tabIndex]
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
        cell:SetOffsetMinXY(0, 0)
        cell:SetOffsetMaxXY(0, 0)
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

function UIFlowerTrainCommonGroupShowView:SetToggleTbNState(i, tabIndex)
  self.togglesTbN[i].chooseN:SetActive(i == tabIndex)
  self.togglesTbN[i].icon:SetActive(false)
  self.togglesTbN[i].nameN:SetActive(true)
  self.togglesTbN[i].commonRedPoint:SetActive(false)
  self.togglesTbN[i].finTip:SetActive(false)
end

local function RefreshOnShowPanel(self)
  if self.curTabIndex == nil then
    return
  end
  local curHandler = AssetsConfig[self.curTabIndex]
  local tempPanel = curHandler.assetPath
  self.panelList[tempPanel]:RefreshView()
end

local function OnClickCloseBtn(self)
  self.ctrl:CloseSelf()
end

local function OnOneUITopItemEnabled(self)
  if CommonUtil.IsArabic() then
    local oldSizeDeltaX = self.title.rectTransform.sizeDelta.x
    local oldSizeDeltaY = self.title.rectTransform.sizeDelta.y
    self.title.rectTransform.sizeDelta = Vector2.New(oldSizeDeltaX - 200, oldSizeDeltaY)
  end
end

function UIFlowerTrainCommonGroupShowView:FestivalPackagingModify(packingParams)
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

function UIFlowerTrainCommonGroupShowView:FestivalPackagingModifyByActivityId(activityId)
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

function UIFlowerTrainCommonGroupShowView:ModifyTopBannerBg(lineData, isShowItemTopBar)
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

function UIFlowerTrainCommonGroupShowView:SetDefaultTopBarBg()
  self.topBarDec:SetActive(true)
  self.topBarBg:SetSizeDeltaY(topBarBgDefaultHeight)
  self.topBarBg:LoadSprite(topBarBgDefaultPath)
end

function UIFlowerTrainCommonGroupShowView:ModifyBottomBg(lineData)
  if string.IsNullOrEmpty(lineData.button_pic) then
    self:SetDefaultBottomBg()
    return
  end
  self.imgBottomBg:SetActive(true)
  self.imgBottomBg:LoadSprite(DataCenter.ActivityListDataManager:GetActivityModLoadPath(activityThemPath, lineData.button_pic))
end

function UIFlowerTrainCommonGroupShowView:SetDefaultBottomBg()
  self.imgBottomBg:SetActive(false)
end

function UIFlowerTrainCommonGroupShowView:ModifyFullScreenBg(lineData)
  if string.IsNullOrEmpty(lineData.bg) then
    self:SetDefaultFullScreenBg()
    return
  end
  self.bg:SetActive(false)
  self.bg1:SetActive(true)
  self.bg1:LoadSprite(DataCenter.ActivityListDataManager:GetActivityModLoadPath(activityThemPath, lineData.bg))
end

function UIFlowerTrainCommonGroupShowView:SetDefaultFullScreenBg()
  self.bg1:LoadSprite(bg1DefaultPath)
end

function UIFlowerTrainCommonGroupShowView:CheckFestivalTitle(activityId)
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

function UIFlowerTrainCommonGroupShowView:GetShowTargetIndex(line)
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

function UIFlowerTrainCommonGroupShowView:GetActStartTime(actId)
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

UIFlowerTrainCommonGroupShowView.OnCreate = OnCreate
UIFlowerTrainCommonGroupShowView.OnDestroy = OnDestroy
UIFlowerTrainCommonGroupShowView.ComponentDefine = ComponentDefine
UIFlowerTrainCommonGroupShowView.ComponentDestroy = ComponentDestroy
UIFlowerTrainCommonGroupShowView.DataDefine = DataDefine
UIFlowerTrainCommonGroupShowView.DataDestroy = DataDestroy
UIFlowerTrainCommonGroupShowView.OnAddListener = OnAddListener
UIFlowerTrainCommonGroupShowView.OnRemoveListener = OnRemoveListener
UIFlowerTrainCommonGroupShowView.InitUI = InitUI
UIFlowerTrainCommonGroupShowView.RefreshToggles = RefreshToggles
UIFlowerTrainCommonGroupShowView.RefreshTabs = RefreshTabs
UIFlowerTrainCommonGroupShowView.RefreshAll = RefreshAll
UIFlowerTrainCommonGroupShowView.ChangeShowType = ChangeShowType
UIFlowerTrainCommonGroupShowView.RefreshOnShowPanel = RefreshOnShowPanel
UIFlowerTrainCommonGroupShowView.OnClickCloseBtn = OnClickCloseBtn
UIFlowerTrainCommonGroupShowView.OnRefreshCallback = OnRefreshCallback
UIFlowerTrainCommonGroupShowView.DelayRefreshAll = DelayRefreshAll
UIFlowerTrainCommonGroupShowView.GetGroupActivityList = GetGroupActivityList
UIFlowerTrainCommonGroupShowView.ClearGroupContent = ClearGroupContent
UIFlowerTrainCommonGroupShowView.OnOneUITopItemEnabled = OnOneUITopItemEnabled
return UIFlowerTrainCommonGroupShowView
