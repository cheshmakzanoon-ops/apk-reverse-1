local base = UIBaseContainer
local InfoExpandBarComponent = BaseClass("InfoExpandBarComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local EXPAND_IMG_PATH = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_anniu_xiala_1.png"
local SHRINK_IMG_PATH = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_anniu_xiala_2.png"

function InfoExpandBarComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function InfoExpandBarComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function InfoExpandBarComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnExpand = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnExpand:SetOnClick(function()
    self:OnBtnExpandClick()
  end)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.imgExpandIcon = self.viewSkin:AddComponent(self, UIImage, 3)
  self.compBG4Expand = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
end

function InfoExpandBarComponent:ComponentDestroy()
  self.viewSkin = nil
  self.btnExpand = nil
  self.textTime = nil
  self.imgExpandIcon = nil
  self.compBG4Expand = nil
end

function InfoExpandBarComponent:DataDefine()
end

function InfoExpandBarComponent:DataDestroy()
end

function InfoExpandBarComponent:OnAddListener()
  base.OnAddListener(self)
end

function InfoExpandBarComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function InfoExpandBarComponent:OnBtnExpandClick()
  self.expandState = not self.expandState
  self:UpdateExpandState()
  local params = {}
  params.activityId = self.activityId
  params.dayIndex = self.dayIndex
  params.expandState = self.expandState
  EventManager:GetInstance():Broadcast(EventId.ActLimitedTimeFestHistoryExpandStateChange, params)
end

function InfoExpandBarComponent:SetData(itemData, isPreviewItem)
  if not itemData then
    return
  end
  self.isPreviewItem = isPreviewItem
  self.itemData = itemData
  self.type = itemData.type
  self.data = itemData.data
  self.activityId = self.data.activityId
  self.dayIndex = self.data.dayIndex
  self.expandState = self.data.expandState
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self:RefreshView()
end

function InfoExpandBarComponent:RefreshView()
  self:RefreshDayTime()
  self:UpdateExpandState()
end

function InfoExpandBarComponent:RefreshDayTime()
  local actStartTime = self.activityInfo.startTime
  local dayNum = self.dayIndex
  local dayNumTime = actStartTime + (dayNum - 1) * 24 * 3600 * 1000
  local format = UITimeManager:GetInstance():TimeStampToServerDate(dayNumTime)
  local timeStr = string.format("%d-%d-%d", format.year, format.month, format.day)
  self.textTime:SetText(timeStr)
end

function InfoExpandBarComponent:UpdateExpandState()
  local imgPath = self.expandState == true and EXPAND_IMG_PATH or SHRINK_IMG_PATH
  self.imgExpandIcon:LoadSpriteAsync(imgPath)
  local isShowExpandBG = self.expandState and not self.isPreviewItem
  self.compBG4Expand:SetActive(isShowExpandBG)
end

return InfoExpandBarComponent
