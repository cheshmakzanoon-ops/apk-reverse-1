local LWUIMigration_TabBase = require("UI.LWUIMigration.Component.LWUIMigration_TabBase")
local LWUIMigrationView_Main = BaseClass("LWUIMigrationView_Main", LWUIMigration_TabBase)
local base = LWUIMigration_TabBase
local Localization = CS.GameEntry.Localization
local MyRand = math.random
local StateDi = require("UI.LWUIMigration.Component.LWUIMigrationView_StateDi")
local ZoneList_Cls = "UI.LWUIMigration.Component.LWUIMigrationView_ZoneList"
local ZoneList_Prefab = "Assets/Main/Prefabs/UI/LWUIMigration/LWUIMigration_ZoneList.prefab"
local btn_info_path = "State/BtnInfo"
local state_di_path = "State/StateDi"
local text_title_path = "Info/TitleText"
local text_day_path = "Info/DayText"
local text_time_path = "Info/TimeText"
local scroll_view_path = "ScrollView"
local content_path = "ScrollView/Viewport/Content"
local desc_path = "Desc"
local wordBg_path = "ScrollView/Viewport/Content/WordBg"
local word_arr_path = "ScrollView/Viewport/Content/WordBg/WArrow"
local text_word_path = "ScrollView/Viewport/Content/WordBg/WordText"
local ratingBg_path = "ScrollView/Viewport/Content/RatingBg"
local rating_arr_path = "ScrollView/Viewport/Content/RatingBg/RArrow"
local super_low_ratingBg_path = "ScrollView/Viewport/Content/RatingBg/SuperLow"
local text_super_low_rating_path = "ScrollView/Viewport/Content/RatingBg/SuperLow/SLText"
local low_ratingBg_path = "ScrollView/Viewport/Content/RatingBg/Low"
local text_low_rating_path = "ScrollView/Viewport/Content/RatingBg/Low/LText"
local normal_ratingBg_path = "ScrollView/Viewport/Content/RatingBg/Normal"
local text_normal_rating_path = "ScrollView/Viewport/Content/RatingBg/Normal/NText"
local strong_ratingBg_path = "ScrollView/Viewport/Content/RatingBg/Strong"
local text_strong_rating_path = "ScrollView/Viewport/Content/RatingBg/Strong/SText"
local ZONE_PREFAB = "Assets/Main/Prefabs/UI/LWUIMigration/LWUIMigration_ZoneList.prefab"
local DescItem_Prefab = "Assets/Main/Prefabs/UI/LWUIMigration/LWUIMigration_DescItem.prefab"
local DescItem_Cls = "UI.LWUIMigration.Component.LWUIMigrationView_DescItem"
local Bottom_Prefab = "Assets/Main/Prefabs/UI/LWUIMigration/LWUIMigration_Bottom.prefab"
local Bottom_Cls = "UI.LWUIMigration.Component.LWUIMigrationView_Bottom"
local LINE_CNT = 4

function LWUIMigrationView_Main:OnCreate()
  base.OnCreate(self)
  self.lList = 0
  self.endTime = 0
  self.bMirror = CommonUtil.IsArabicAutoMirrorOpen()
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.btn_info:SetOnClick(BindCallback(self, self.OnBtnInfoClick))
  self.stateDis = {}
  for i = 1, 4 do
    self.stateDis[i] = self:AddComponent(StateDi, state_di_path .. i)
  end
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_day = self:AddComponent(UIText, text_day_path)
  self.text_time = self:AddComponent(UIText, text_time_path)
  self.maxZCnt = 0
  self.zoneModels = {}
  self.zones = {}
  self.zoneItems = {}
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.scroll_view = self:AddComponent(UILoopListView2, scroll_view_path)
  self.scroll_view:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.scroll_view_trigger = self:AddComponent(UIScrollRectEventTrigger, scroll_view_path)
  self.scroll_view_trigger:OnBeginDrag(function()
    self:DeleteTimer()
  end)
  self.scroll_view_trigger:OnEndDrag(function()
    self:StartRandom()
  end)
  local configs = DataCenter.ActMigrationManager:GetGuideConfig(1)
  self.compDesc = self:AddComponent(UIBaseContainer, desc_path)
  for i = 1, 3 do
    if configs[i] then
      local comp = self:LoadComponentAsync(DescItem_Cls, DescItem_Prefab, self.compDesc)
      comp:SetName("DescItem" .. i)
      comp:SetData(configs[i])
      comp:SetActive(true)
    end
  end
  self.bottom = self:LoadComponentAsync(Bottom_Cls, Bottom_Prefab, self, function()
    if self.bottom ~= nil then
      self.bottom:SetAnchoredPositionXY(0, -15)
    end
  end)
  self.bottom:SetName("Bottom")
  self.bottom:SetSiblingIndex(1)
  self.wordBg = self:AddComponent(UIBaseComponent, wordBg_path)
  self.wordArr = self:AddComponent(UIBaseComponent, word_arr_path)
  self.text_word = self:AddComponent(UIText, text_word_path)
  self.ratingBg = self:AddComponent(UIBaseComponent, ratingBg_path)
  self.rating_arr = self:AddComponent(UIImage, rating_arr_path)
  self.super_low_ratingBg = self:AddComponent(UIImage, super_low_ratingBg_path)
  self.text_super_low_rating = self:AddComponent(UIText, text_super_low_rating_path)
  self.low_ratingBg = self:AddComponent(UIImage, low_ratingBg_path)
  self.text_low_rating = self:AddComponent(UIText, text_low_rating_path)
  self.normal_ratingBg = self:AddComponent(UIImage, normal_ratingBg_path)
  self.text_normal_rating = self:AddComponent(UIText, text_normal_rating_path)
  self.strong_ratingBg = self:AddComponent(UIImage, strong_ratingBg_path)
  self.text_strong_rating = self:AddComponent(UIText, text_strong_rating_path)
  if self.bMirror then
    self.wordBg:SetAnchorMinXY(0, 0)
    self.wordBg:SetAnchorMaxXY(0, 0)
    self.wordBg:SetPivotXY(1, 0)
    self.ratingBg:SetAnchorMinXY(0, 0)
    self.ratingBg:SetAnchorMaxXY(0, 0)
    self.ratingBg:SetPivotXY(1, 0)
  end
end

function LWUIMigrationView_Main:OnDestroy()
  self.bottom = nil
  self:SetAllZonesDestroy()
  self.text_time = nil
  self.stateDis = {}
  base.OnDestroy(self)
end

function LWUIMigrationView_Main:OnBtnInfoClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMigrationGuide)
end

function LWUIMigrationView_Main:SetData()
  base.SetData(self)
  local curStage, info = DataCenter.ActMigrationManager:GetCurStageInfo()
  if info ~= nil then
    self.curState = info.state
    self.curStage = curStage
    for i, v in ipairs(self.stateDis) do
      v:SetData(i, self.curStage)
    end
    self:UpdateInfoShow(info)
  end
  self:RefreshList()
  if self.bottom then
    self.bottom:RefreshView()
  end
end

function LWUIMigrationView_Main:UpdateInfoShow(info)
  local sTime = info ~= nil and info.sTime or 0
  local eTime = info ~= nil and info.eTime or 0
  if 0 < sTime and 0 < eTime then
    local str = DataCenter.ActMigrationManager:GetStageText(info.state)
    local maxDay = math.modf((eTime - sTime) / (OneDayTime * 1000))
    if info.state == ActMigrationState.Migrate then
      self.endTime = eTime - DataCenter.ActMigrationManager:GetMigrateForceTime()
    else
      self.endTime = eTime
    end
    local curDay = 1
    local curTime = UITimeManager:GetInstance():GetServerTime()
    while curTime > sTime + curDay * OneDayTime * 1000 do
      curDay = curDay + 1
    end
    self.text_title:SetText(str .. " " .. curDay .. "/" .. maxDay)
    self.text_title:SetActive(true)
    local dateStart = UITimeManager:GetInstance():TimeStampToServerDate(sTime)
    local dateEnd = UITimeManager:GetInstance():TimeStampToServerDate(eTime)
    self.text_day:SetText(string.format("%d.%02d--%d.%02d", dateStart.month, dateStart.day, dateEnd.month, dateEnd.day))
    self.text_day:SetActive(true)
    self.text_time:SetActive(true)
  else
    self.endTime = 0
    self.text_title:SetActive(false)
    self.text_day:SetActive(false)
    self.text_time:SetActive(false)
  end
  self:Update1000MS()
end

function LWUIMigrationView_Main:SetAllZonesDestroy()
  self.content:RemoveComponents(UIBaseContainer)
  self.scroll_view:ClearAllItems()
  self.maxZCnt = 0
  self.zoneModels = {}
  self.zones = {}
  self.zoneItems = {}
end

function LWUIMigrationView_Main:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > self.maxZCnt then
    return nil
  end
  local item = loopScroll:NewListViewItem(index == 1 and "ItemF" or "Item")
  local script = self.zoneModels[item]
  if script == nil then
    local objectName = UIUtil.GetLoopListItemIndex("Item")
    item.gameObject.name = objectName
    local parent = self.content:AddComponent(UIBaseContainer, objectName)
    script = self:LoadComponentAsync(ZoneList_Cls, ZoneList_Prefab, parent, function()
      script:SetAnchoredPositionXY(0, index == 1 and -40 or 0)
      local zones = script:GetZones()
      for i, zone in ipairs(zones) do
        local realI = (index - 1) * LINE_CNT + i
        self.zoneItems[realI] = zone
      end
    end)
    self.zones[index] = script
    self.zoneModels[item] = script
  elseif script:AsyncLoadDone() then
    local zones = script:GetZones()
    for i, zone in ipairs(zones) do
      local realI = (index - 1) * LINE_CNT + i
      self.zoneItems[realI] = zone
    end
  end
  script:SetData(index)
  return item
end

function LWUIMigrationView_Main:RefreshList()
  local actInfo = DataCenter.ActMigrationManager:GetActInfo()
  local serverIds = actInfo ~= nil and actInfo.serverIdList or {}
  local ls = #serverIds
  local l = math.ceil(ls / LINE_CNT)
  self.maxZCnt = l
  self.scroll_view:SetActive(0 < l)
  if l == 0 then
    return
  end
  self.scroll_view:SetListItemCount(l, false, false)
  self.scroll_view:RefreshAllShownItem()
  self:StartRandom()
end

function LWUIMigrationView_Main:Update1000MS()
  if self:IsMvHide() then
    return
  end
  if self.endTime > 0 and self.text_time ~= nil then
    local uiMgr = UITimeManager:GetInstance()
    local curSec = uiMgr:GetServerSeconds()
    local remainTime = self.endTime / 1000 - curSec
    if 0 < remainTime then
      self.text_time:SetText(uiMgr:SecondToFmtString(remainTime))
    else
      if self.curState == ActMigrationState.Migrate then
        self.text_time:SetLocalText("migration_activity_tips_20045")
      else
        self.text_time:SetText(uiMgr:SecondToFmtString(0))
      end
      self.endTime = 0
    end
  end
end

function LWUIMigrationView_Main:DeleteTimer()
  if self.timer then
    self.timer:Stop()
  end
  self.timer = nil
  if self.lastRandIdx then
    local zone = self.zoneItems[self.lastRandIdx]
    if zone then
      zone:HidePlayer()
    end
  end
  self.wordBg:SetActive(false)
  self.ratingBg:SetActive(false)
end

function LWUIMigrationView_Main:GetRandomIdx()
  local idx = self.lastRandIdx
  local actInfo = DataCenter.ActMigrationManager:GetActInfo()
  local serverIds = actInfo ~= nil and actInfo.serverIdList or {}
  local l = #serverIds
  if l == 1 then
    return 1
  end
  local rtf = self.scroll_view.rectTransform
  if rtf == nil then
    return 1
  end
  local maxH = rtf.rect.height
  local sameTimes = 0
  while true do
    idx = MyRand(1, l)
    local zone = self.zoneItems[idx]
    if zone == nil then
      idx = self.lastRandIdx
    else
      local zPos = zone:GetPosition()
      local zSize = zone:GetSizeDelta()
      local localPoint = CS.PointUtils.ScreenPointToLocalPointInRectangle(rtf, zPos)
      if localPoint.y < -zSize.y * 0.5 or maxH < localPoint.y + zSize.y then
        idx = self.lastRandIdx
      end
    end
    if idx ~= self.lastRandIdx then
      break
    end
    sameTimes = sameTimes + 1
    if not (3 <= sameTimes) then
    else
      break
    end
  end
  self.lastRandIdx = idx
  return idx
end

function LWUIMigrationView_Main:StartRandom(bNow)
  self:DeleteTimer()
  if self.zoneItems and #self.zoneItems == 0 then
    return
  end
  local sce = bNow and 0.5 or MyRand(20, 40) / 10
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    local idx = self:GetRandomIdx()
    local mgr = DataCenter.ActMigrationManager
    local actInfo = mgr:GetActInfo()
    local serverIds = actInfo ~= nil and actInfo.serverIdList or {}
    local sInfo = mgr:GetServerInfo(serverIds[idx])
    local zone = self.zoneItems[idx]
    if sInfo and zone then
      zone:ShowPlayer()
      local bTip = true
      local _, info = mgr:GetCurStageInfo()
      if info and info.state == ActMigrationState.Migrate and (sInfo.playerIn > 0 or 0 < sInfo.highPlayerIn) then
        bTip = MyRand(0, 100) < 50
      end
      if bTip then
        self:ShowTips(idx, sInfo, zone)
      else
        self:ShowRating(idx, sInfo, zone)
      end
    end
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      self:StartRandom()
    end, 4)
  end, sce)
end

function LWUIMigrationView_Main:ShowTips(idx, sInfo, zone)
  local msg = sInfo.notice
  if string.IsNullOrEmpty(msg) then
    msg = Localization:GetString("migration_activity_tips_20037")
  end
  self.text_word:SetText(msg)
  self:FixPos(self.wordBg, self.wordArr, idx, zone, true)
end

function LWUIMigrationView_Main:ShowRating(idx, sInfo, zone)
  local zInfo = DataCenter.ActMigrationManager:GetZoneStandard(sInfo.serverState)
  local myInfo = DataCenter.ActMigrationManager:GetMyInfo()
  local maxSLow = zInfo ~= nil and zInfo.superLowNum or 0
  self.text_super_low_rating:SetText(sInfo.superLowPlayerIn .. "/" .. maxSLow)
  local maxLow = zInfo ~= nil and zInfo.lowNum or 0
  self.text_low_rating:SetText(sInfo.lowPlayerIn .. "/" .. maxLow)
  local maxNormal = zInfo ~= nil and zInfo.normalNum or 0
  self.text_normal_rating:SetText(sInfo.playerIn .. "/" .. maxNormal)
  local maxStrong = zInfo ~= nil and zInfo.strongNum or 0
  self.text_strong_rating:SetText(sInfo.highPlayerIn .. "/" .. maxStrong)
  local gR, gG, gB = 222, 250, 227
  local gR2, gG2, gB2 = 240, 237, 235
  local identity = myInfo ~= nil and myInfo.identity or 0
  local bSLow = identity == ActMigrationIdentity.SuperLow
  self.super_low_ratingBg:SetColorRGBA255(bSLow and gR or gR2, bSLow and gG or gG2, bSLow and gB or gB2, 255)
  local bLow = identity == ActMigrationIdentity.Low
  self.low_ratingBg:SetColorRGBA255(bLow and gR or gR2, bLow and gG or gG2, bLow and gB or gB2, 255)
  local bNormal = identity == ActMigrationIdentity.Normal
  self.normal_ratingBg:SetColorRGBA255(bNormal and gR or gR2, bNormal and gG or gG2, bNormal and gB or gB2, 255)
  local bHigh = identity == ActMigrationIdentity.High
  self.strong_ratingBg:SetColorRGBA255(bHigh and gR or gR2, bHigh and gG or gG2, bHigh and gB or gB2, 255)
  self:FixPos(self.ratingBg, self.rating_arr, idx, zone, false)
end

function LWUIMigrationView_Main:FixPos(bg, arr, idx, zone, fixX)
  bg:SetActive(true)
  bg.transform:SetAsLastSibling()
  local bgRTF = bg.rectTransform
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(bgRTF)
  local part = 30
  local zPos = zone:GetPosition()
  local localPoint = CS.PointUtils.ScreenPointToLocalPointInRectangle(self.content.rectTransform, zPos)
  local sW = self.content.rectTransform.rect.width
  local bW = bgRTF.rect.width * 0.5
  local bH = bgRTF.rect.height
  if fixX then
    if localPoint.x + bW > sW - part then
      localPoint.x = sW - part - bW
    elseif part > localPoint.x - bW then
      localPoint.x = bW + part
    end
  end
  local zH = zone.rectTransform.rect.height
  if idx <= LINE_CNT then
    localPoint.y = localPoint.y + zH - bH - 10
  else
    localPoint.y = localPoint.y + zH + 60
  end
  bg:SetLocalPositionXYZ(localPoint.x, localPoint.y, 0)
  local aX, aY, zZ = arr:GetLocalPositionXYZ()
  if fixX then
    local tmpP = CS.PointUtils.ScreenPointToLocalPointInRectangle(bgRTF, zPos)
    aX = tmpP.x
    if self.bMirror then
      aX = 0 - tmpP.x
    end
  end
  aY = idx <= LINE_CNT and bH - 6 or 8
  arr:SetLocalPositionXYZ(aX, aY, zZ)
  arr.transform.localRotation = Vector3.New(0, 0, idx <= LINE_CNT and 0 or 180)
end

return LWUIMigrationView_Main
