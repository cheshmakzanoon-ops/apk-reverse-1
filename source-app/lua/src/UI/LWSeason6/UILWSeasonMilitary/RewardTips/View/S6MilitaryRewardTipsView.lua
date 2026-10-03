local S6MilitaryRewardTipsView = BaseClass("S6MilitaryRewardTipsView", UIBaseView)
local base = UIBaseView
local UIPersonalArmsRewardTipItem = require("UI.UIActivityPersonalArms.UIPersonalArmsRewardTip.Component.UIPersonalArmsRewardTipItem")
local Direction = {LEFT = 1, RIGHT = 2}
local ParamData = {
  title = "",
  dir = Direction.LEFT,
  position = Vector2.zero,
  deltaX = 0,
  deltaY = 0,
  totalVal = 0,
  rewardList = {},
  hideCount = false
}
S6MilitaryRewardTipsView.ParamDataClass = DataClass("ParamDataClass", ParamData)
S6MilitaryRewardTipsView.Direction = Direction

function S6MilitaryRewardTipsView:OnCreate()
  base.OnCreate(self)
  self.param = nil
  self:ComponentDefine()
end

function S6MilitaryRewardTipsView:OnDestroy()
  self.param = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function S6MilitaryRewardTipsView:OnEnable()
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
  local longTitleContentDeltaY = self.longTitleContent:GetSizeDelta().y
  local rewardCount = table.count(self.param.rewardList)
  local rewardDeltaY = rewardCount * 82 + (rewardCount - 1) * 4 + 20
  local contentPadding = self.contentVerticalLayout:GetPadding()
  local halfContentSizeDeltaY = (longTitleContentDeltaY + rewardDeltaY + contentPadding.top + contentPadding.bottom) / 2
  local endValue = contentDeltaY < halfContentSizeDeltaY and contentDeltaY or halfContentSizeDeltaY
  contentPosY = arrowY + endValue
  self.content:SetAnchoredPositionXY(contentPosX, contentPosY)
end

function S6MilitaryRewardTipsView:RefreshView()
  self.longTitleText:SetLocalText(self.param.title)
  self.rewardContent:RemoveComponents(UIPersonalArmsRewardTipItem)
  self.item.gameObject:GameObjectRecycleAll()
  local showCount = not self.param.hideCount
  local list = self.param.rewardList
  if list ~= nil then
    self.rewardLayoutElement:SetActive(true)
    for i = 1, table.length(list) do
      local item = self.item.gameObject:GameObjectSpawn(self.rewardContent.transform)
      item.name = tostring(i)
      local cell = self.rewardContent:AddComponent(UIPersonalArmsRewardTipItem, item.name, list[i])
      cell:SetData(list[i], showCount, self.rewardMultiVal)
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rewardContent.rectTransform)
    local height = self.rewardContent.rectTransform.rect.height
    self.rewardLayoutElement:SetPreferredHeight(height + 20)
  else
    self.rewardLayoutElement:SetActive(false)
  end
end

function S6MilitaryRewardTipsView:OnDisable()
end

function S6MilitaryRewardTipsView:ComponentDefine()
  local btnPanel = self:AddComponent(UIButton, "Panel")
  btnPanel:SetOnClick(function()
    self.ctrl.CloseSelf(self.ctrl)
  end)
  self.imgArrow = self:AddComponent(UIBaseContainer, "ImgArrow")
  self.content = self:AddComponent(UIBaseContainer, "content")
  self.contentVerticalLayout = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, "content")
  self.longTitleContent = self:AddComponent(UIBaseContainer, "content/LongTitleContent")
  self.longTitleText = self:AddComponent(UITextMeshProUGUIEx, "content/LongTitleContent/LongTitleText")
  self.rewardContent = self:AddComponent(UIBaseContainer, "content/TextContent/ItemScroll/Viewport/rewardContent")
  self.rewardLayoutElement = self:AddComponent(UILayoutElement, "content/TextContent")
  self.item = self:AddComponent(UIBaseContainer, "content/TextContent/ItemScroll/Item")
  self.item.gameObject:GameObjectCreatePool()
  self.touchTrough = btnPanel.rectTransform:GetComponent(typeof(CS.LFTouchThrough))
end

function S6MilitaryRewardTipsView:ComponentDestroy()
  self.imgArrow = nil
  self.content = nil
  self.longTitleContent = nil
  self.longTitleText = nil
  self.rewardContent:RemoveComponents(UIPersonalArmsRewardTipItem)
  self.rewardContent = nil
  self.rewardLayoutElement = nil
  self.item.gameObject:GameObjectRecycleAll()
  self.item = nil
end

return S6MilitaryRewardTipsView
