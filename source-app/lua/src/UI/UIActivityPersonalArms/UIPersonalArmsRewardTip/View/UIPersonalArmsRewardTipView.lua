local UIPersonalArmsRewardTipView = BaseClass("UIPersonalArmsRewardTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIPersonalArmsRewardTipItem = require("UI.UIActivityPersonalArms.UIPersonalArmsRewardTip.Component.UIPersonalArmsRewardTipItem")
local Screen = CS.UnityEngine.Screen
local Direction = {LEFT = 1, RIGHT = 2}
local ParamData = {
  title = "",
  titleStr = "",
  titleFontSize = 32,
  titleAlignment = CS.TMPro.TextAlignmentOptions.Midline,
  dir = Direction.LEFT,
  position = Vector2.zero,
  deltaX = 0,
  deltaY = 0,
  totalVal = 0,
  rewardList = {},
  hideCount = false,
  hideResIconCount = false
}
local ParamDataClass = DataClass("ParamDataClass", ParamData)

local function OnCreate(self)
  base.OnCreate(self)
  self.param = nil
  self:ComponentDefine()
end

local function OnDestroy(self)
  self.param = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  self.param = self:GetUserData()
  local contentDeltaX = 177
  if CommonUtil.IsArabicAutoMirrorOpen() then
    contentDeltaX = -177
  end
  local contentDeltaY = 175
  local arrowX = self.param.position.x
  local arrowY = self.param.position.y
  self.imgArrow:SetPositionXYZ(arrowX, arrowY, 0)
  local anchoredPosition = self.imgArrow:GetAnchoredPosition()
  local contentPosX = 0
  local contentPosY = 0
  arrowX = anchoredPosition.x + self.param.deltaX
  arrowY = anchoredPosition.y + self.param.deltaY
  self.rewardMultiVal = self.param.rewardMultiVal or 1
  self.imgArrow:SetAnchoredPositionXY(arrowX, anchoredPosition.y)
  if self.param.dir == Direction.LEFT then
    if CommonUtil.IsArabicAutoMirrorOpen() then
      self.imgArrow.transform:Set_localScale(1, 1, 1)
    else
      self.imgArrow.transform:Set_localScale(-1, 1, 1)
    end
    contentPosX = arrowX + contentDeltaX
  else
    if CommonUtil.IsArabicAutoMirrorOpen() then
      self.imgArrow.transform:Set_localScale(-1, 1, 1)
    else
      self.imgArrow.transform:Set_localScale(1, 1, 1)
    end
    contentPosX = arrowX - contentDeltaX
  end
  self.touchTrough:ToggleThrough(not self.param.closePassClick)
  self:RefreshView()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  local titleContentDeltaY = 0
  if self.titleContent:GetActiveInHierarchy() then
    titleContentDeltaY = self.titleContent:GetSizeDelta().y
  end
  local longTitleContentDeltaY = 0
  if self.longTitleContent:GetActiveInHierarchy() then
    longTitleContentDeltaY = self.longTitleContent:GetSizeDelta().y
  end
  local rewardCount = table.count(self.param.rewardList)
  local rewardDeltaY = rewardCount * 82 + (rewardCount - 1) * 4 + 20
  local contentPadding = self.contentVerticalLayout:GetPadding()
  local halfContentSizeDeltaY = (titleContentDeltaY + longTitleContentDeltaY + rewardDeltaY + contentPadding.top + contentPadding.bottom) / 2
  local endValue = contentDeltaY < halfContentSizeDeltaY and contentDeltaY or halfContentSizeDeltaY
  contentPosY = arrowY + endValue
  self.content:SetAnchoredPositionXY(contentPosX, contentPosY)
end

local function RefreshView(self)
  if self.param.totalVal > 0 then
    self.longTitleContent:SetActive(false)
    self.titleContentCustom:SetActive(false)
    self.titleContent:SetActive(true)
    self.titleText:SetLocalText(2000384, string.GetFormattedSeparatorNum(self.param.totalVal))
    self.titleIcon.gameObject:SetActive(true)
  elseif not string.IsNullOrEmpty(self.param.customTitleIcon) and not string.IsNullOrEmpty(self.param.customTitleStr) then
    self.longTitleContent:SetActive(false)
    self.titleContent:SetActive(false)
    self.titleContentCustom:SetActive(true)
    self.imgCustomTitleIcon:LoadSprite(self.param.customTitleIcon)
    self.txtCustomTitle:SetText(self.param.customTitleStr)
  elseif not string.IsNullOrEmpty(self.param.title) or not string.IsNullOrEmpty(self.param.titleStr) then
    self.longTitleContent:SetActive(true)
    self.titleContent:SetActive(false)
    self.titleContentCustom:SetActive(false)
    self.longTitleText.unity_tmpro.fontSize = self.param.titleFontSize
    self.longTitleText:SetAlignment(self.param.titleAlignment)
    if not string.IsNullOrEmpty(self.param.title) then
      self.longTitleText:SetLocalText(self.param.title)
    else
      self.longTitleText:SetText(self.param.titleStr)
    end
  else
    self.longTitleContent:SetActive(false)
    self.titleContent:SetActive(false)
    self.titleContentCustom:SetActive(false)
  end
  self.rewardContent:RemoveComponents(UIPersonalArmsRewardTipItem)
  self.item.gameObject:GameObjectRecycleAll()
  local showCount = not self.param.hideCount
  local hideResIconCount = self.param.hideResIconCount
  local list = self.param.rewardList
  if list ~= nil then
    self.rewardLayoutElement:SetActive(true)
    for i = 1, table.length(list) do
      local item = self.item.gameObject:GameObjectSpawn(self.rewardContent.transform)
      item.name = tostring(i)
      local cell = self.rewardContent:AddComponent(UIPersonalArmsRewardTipItem, item.name, list[i])
      cell:SetData(list[i], showCount, self.rewardMultiVal, hideResIconCount)
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rewardContent.rectTransform)
    local height = self.rewardContent.rectTransform.rect.height
    self.rewardLayoutElement:SetPreferredHeight(height + 20)
  else
    self.rewardLayoutElement:SetActive(false)
  end
end

local function OnDisable(self)
end

local function ComponentDefine(self)
  local btnPanel = self:AddComponent(UIButton, "Panel")
  btnPanel:SetOnClick(function()
    self.ctrl.CloseSelf(self.ctrl)
  end)
  self.imgArrow = self:AddComponent(UIBaseContainer, "ImgArrow")
  self.content = self:AddComponent(UIBaseContainer, "content")
  self.contentVerticalLayout = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, "content")
  self.longTitleContent = self:AddComponent(UIBaseContainer, "content/LongTitleContent")
  self.longTitleText = self:AddComponent(UITextMeshProUGUIEx, "content/LongTitleContent/LongTitleText")
  self.titleContent = self:AddComponent(UIBaseContainer, "content/TitleContent")
  self.titleContentCustom = self:AddComponent(UIBaseContainer, "content/TitleContentCustom")
  self.titleText = self:AddComponent(UIText, "content/TitleContent/TitleText")
  self.titleIcon = self:AddComponent(UIImage, "content/TitleContent/Icon")
  self.rewardContent = self:AddComponent(UIBaseContainer, "content/TextContent/ItemScroll/Viewport/rewardContent")
  self.rewardLayoutElement = self:AddComponent(UILayoutElement, "content/TextContent")
  self.item = self:AddComponent(UIBaseContainer, "content/TextContent/ItemScroll/Item")
  self.item.gameObject:GameObjectCreatePool()
  self.touchTrough = btnPanel.rectTransform:GetComponent(typeof(CS.LFTouchThrough))
  self.imgCustomTitleIcon = self:AddComponent(UIImage, "content/TitleContentCustom/Icon2")
  self.txtCustomTitle = self:AddComponent(UITextMeshProUGUIEx, "content/TitleContentCustom/TitleText2")
end

local function ComponentDestroy(self)
  self.imgArrow = nil
  self.content = nil
  self.longTitleContent = nil
  self.longTitleText = nil
  self.titleContent = nil
  self.titleText = nil
  self.rewardContent:RemoveComponents(UIPersonalArmsRewardTipItem)
  self.rewardContent = nil
  self.rewardLayoutElement = nil
  self.item.gameObject:GameObjectRecycleAll()
  self.item = nil
  self.titleContentCustom = nil
end

UIPersonalArmsRewardTipView.ParamDataClass = ParamDataClass
UIPersonalArmsRewardTipView.Direction = Direction
UIPersonalArmsRewardTipView.OnCreate = OnCreate
UIPersonalArmsRewardTipView.OnDestroy = OnDestroy
UIPersonalArmsRewardTipView.OnEnable = OnEnable
UIPersonalArmsRewardTipView.OnDisable = OnDisable
UIPersonalArmsRewardTipView.ComponentDefine = ComponentDefine
UIPersonalArmsRewardTipView.ComponentDestroy = ComponentDestroy
UIPersonalArmsRewardTipView.RefreshView = RefreshView
return UIPersonalArmsRewardTipView
