local UITreasureChestRewardTip = BaseClass("UITreasureChestRewardTip", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UITreasureChestRewardTipItem = require("UI.LWTreasureChest.UITreasureChestRewardTipItem")
local Direction = {
  LEFT = 1,
  MIDDLE = 2,
  RIGHT = 3
}
local AnchoredX = {
  [Direction.LEFT] = -170,
  [Direction.MIDDLE] = 0,
  [Direction.RIGHT] = 170
}
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
  extraRewardList = {},
  hideCount = false
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

local function SetData(self, param)
  self.param = param
  local contentPosX = AnchoredX[self.param.dir]
  local contentPosY = -63
  self.imgArrow:SetAnchoredPositionXY(contentPosX, contentPosY + 7)
  self.rewardMultiVal = self.param.rewardMultiVal or 1
  self.touchTrough:ToggleThrough(not self.param.closePassClick)
  self.content:SetAnchoredPositionXY(contentPosX, contentPosY)
end

local function Show(self)
  self.gameObject:SetActive(true)
  self:RefreshView()
end

local function RefreshView(self)
  if self.param.totalVal > 0 then
    self.longTitleContent:SetActive(false)
    self.titleContent:SetActive(true)
    local value = Localization:GetString("new_detect_tips_17") .. self.param.totalVal
    self.titleText:SetText(value)
    self.titleIcon.gameObject:SetActive(true)
  elseif not string.IsNullOrEmpty(self.param.title) or not string.IsNullOrEmpty(self.param.titleStr) then
    self.longTitleContent:SetActive(true)
    self.titleContent:SetActive(false)
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
  end
  self.rewardContent:RemoveComponents(UITreasureChestRewardTipItem)
  self.extraRewardContent:RemoveComponents(UITreasureChestRewardTipItem)
  self.item.gameObject:GameObjectRecycleAll()
  local showCount = not self.param.hideCount
  local list = self.param.rewardList
  if list ~= nil then
    self.rewardLayoutElement:SetActive(true)
    for i = 1, table.length(list) do
      local item = self.item.gameObject:GameObjectSpawn(self.rewardContent.transform)
      item.name = tostring(i)
      local cell = self.rewardContent:AddComponent(UITreasureChestRewardTipItem, item.name, list[i])
      cell:SetData(list[i], showCount, self.rewardMultiVal)
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rewardContent.rectTransform)
    local height = self.rewardContent.rectTransform.rect.height
    self.rewardLayoutElement:SetPreferredHeight(height + 20)
  else
    self.rewardLayoutElement:SetActive(false)
  end
  local extraRewardList = self.param.extraRewardList
  if extraRewardList ~= nil and 0 < #extraRewardList then
    self.extraRewardLayoutElement:SetActive(true)
    for i = 1, table.length(extraRewardList) do
      local item = self.item.gameObject:GameObjectSpawn(self.extraRewardContent.transform)
      item.name = tostring(i)
      local cell = self.extraRewardContent:AddComponent(UITreasureChestRewardTipItem, item.name, extraRewardList[i])
      cell:SetData(extraRewardList[i], showCount, self.rewardMultiVal)
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.extraRewardContent.rectTransform)
    local height = self.extraRewardContent.rectTransform.rect.height
    self.extraRewardLayoutElement:SetPreferredHeight(height + 50)
  else
    self.extraRewardLayoutElement:SetActive(false)
  end
end

local function ComponentDefine(self)
  local btnPanel = self:AddComponent(UIButton, "Panel")
  btnPanel:SetOnClick(function()
    self.gameObject:SetActive(false)
  end)
  self.imgArrow = self:AddComponent(UIBaseContainer, "ImgArrow")
  self.content = self:AddComponent(UIBaseContainer, "content")
  self.contentVerticalLayout = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, "content")
  self.longTitleContent = self:AddComponent(UIBaseContainer, "content/LongTitleContent")
  self.longTitleText = self:AddComponent(UITextMeshProUGUIEx, "content/LongTitleContent/LongTitleText")
  self.titleContent = self:AddComponent(UIBaseContainer, "content/TitleContent")
  self.titleText = self:AddComponent(UIText, "content/TitleContent/TitleText")
  self.titleIcon = self:AddComponent(UIImage, "content/TitleContent/Icon")
  self.rewardContent = self:AddComponent(UIBaseContainer, "content/TextContent/ItemScroll/Viewport/rewardContent")
  self.normalRewardTitle = self:AddComponent(UITextMeshProUGUIEx, "content/TextContent/NormalRewardTitle")
  self.normalRewardTitle:SetLocalText("new_detect_tips_19")
  self.rewardLayoutElement = self:AddComponent(UILayoutElement, "content/TextContent")
  self.item = self:AddComponent(UIBaseContainer, "content/TextContent/ItemScroll/Item")
  self.item.gameObject:GameObjectCreatePool()
  self.extraRewardLayoutElement = self:AddComponent(UILayoutElement, "content/ExtraRewardContent")
  self.extraRewardContent = self:AddComponent(UIBaseContainer, "content/ExtraRewardContent/ItemScroll/Viewport/extraRewardContent")
  self.extraRewardTitle = self:AddComponent(UITextMeshProUGUIEx, "content/ExtraRewardContent/ExtraRewardTitle")
  self.extraRewardTitle:SetLocalText("new_detect_tips_18")
  self.touchTrough = btnPanel.rectTransform:GetComponent(typeof(CS.LFTouchThrough))
end

local function ComponentDestroy(self)
  self.imgArrow = nil
  self.content = nil
  self.longTitleContent = nil
  self.longTitleText = nil
  self.titleContent = nil
  self.titleText = nil
  self.rewardContent:RemoveComponents(UITreasureChestRewardTipItem)
  self.rewardContent = nil
  self.extraRewardContent:RemoveComponents(UITreasureChestRewardTipItem)
  self.extraRewardContent = nil
  self.extraRewardTitle = nil
  self.extraRewardLayoutElement = nil
  self.rewardLayoutElement = nil
  self.item.gameObject:GameObjectRecycleAll()
  self.item = nil
end

UITreasureChestRewardTip.ParamDataClass = ParamDataClass
UITreasureChestRewardTip.Direction = Direction
UITreasureChestRewardTip.OnCreate = OnCreate
UITreasureChestRewardTip.OnDestroy = OnDestroy
UITreasureChestRewardTip.SetData = SetData
UITreasureChestRewardTip.Show = Show
UITreasureChestRewardTip.ComponentDefine = ComponentDefine
UITreasureChestRewardTip.ComponentDestroy = ComponentDestroy
UITreasureChestRewardTip.RefreshView = RefreshView
return UITreasureChestRewardTip
