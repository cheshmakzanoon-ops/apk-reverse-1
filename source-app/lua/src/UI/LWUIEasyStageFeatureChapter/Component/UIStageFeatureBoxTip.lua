local UIStageFeatureBoxTip = BaseClass("UIStageFeatureBoxTip", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIStageFeatureRewardTipItem = require("UI.LWUIEasyStageFeatureChapter.Component.UIStageFeatureRewardTipItem")
local AnchoredX = {
  [1] = -157,
  [2] = 0,
  [3] = 155,
  [4] = 220
}
local ArrowAnchoredX = {
  [1] = -157,
  [2] = 0,
  [3] = 155,
  [4] = 310
}
local ParamData = {
  title = "",
  titleStr = "",
  titleFontSize = 32,
  titleAlignment = CS.TMPro.TextAlignmentOptions.Midline,
  index = 1,
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
  local contentPosX = AnchoredX[self.param.index]
  local contentPosY = -383.6
  self.content:SetAnchoredPositionXY(contentPosX, contentPosY)
  local arrowPosX = ArrowAnchoredX[self.param.index]
  self.imgArrow:SetAnchoredPositionXY(arrowPosX, contentPosY + 7)
  self.rewardMultiVal = self.param.rewardMultiVal or 1
  self.touchTrough:ToggleThrough(not self.param.closePassClick)
end

local function Show(self)
  self.gameObject:SetActive(true)
  self:RefreshView()
end

local function RefreshView(self)
  self.rewardContent:RemoveComponents(UIStageFeatureRewardTipItem)
  self.item.gameObject:GameObjectRecycleAll()
  local showCount = not self.param.hideCount
  local list = self.param.rewardList
  if list ~= nil then
    self.rewardLayoutElement:SetActive(true)
    for i = 1, table.length(list) do
      local item = self.item.gameObject:GameObjectSpawn(self.rewardContent.transform)
      item.name = tostring(i)
      local cell = self.rewardContent:AddComponent(UIStageFeatureRewardTipItem, item.name, list[i])
      cell:SetData(list[i], showCount, self.rewardMultiVal)
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rewardContent.rectTransform)
    local height = self.rewardContent.rectTransform.rect.height
    self.rewardLayoutElement:SetPreferredHeight(height + 20)
  else
    self.rewardLayoutElement:SetActive(false)
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
  self.rewardContent = self:AddComponent(UIBaseContainer, "content/TextContent/ItemScroll/Viewport/rewardContent")
  self.rewardLayoutElement = self:AddComponent(UILayoutElement, "content/TextContent")
  self.item = self:AddComponent(UIBaseContainer, "content/TextContent/ItemScroll/Item")
  self.item.gameObject:GameObjectCreatePool()
  self.touchTrough = btnPanel.rectTransform:GetComponent(typeof(CS.LFTouchThrough))
end

local function ComponentDestroy(self)
  self.imgArrow = nil
  self.content = nil
  self.rewardContent:RemoveComponents(UIStageFeatureRewardTipItem)
  self.rewardContent = nil
  self.rewardLayoutElement = nil
  self.item.gameObject:GameObjectRecycleAll()
  self.item = nil
end

UIStageFeatureBoxTip.ParamDataClass = ParamDataClass
UIStageFeatureBoxTip.OnCreate = OnCreate
UIStageFeatureBoxTip.OnDestroy = OnDestroy
UIStageFeatureBoxTip.SetData = SetData
UIStageFeatureBoxTip.Show = Show
UIStageFeatureBoxTip.ComponentDefine = ComponentDefine
UIStageFeatureBoxTip.ComponentDestroy = ComponentDestroy
UIStageFeatureBoxTip.RefreshView = RefreshView
return UIStageFeatureBoxTip
