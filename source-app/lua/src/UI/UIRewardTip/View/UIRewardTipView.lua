local UIRewardTipView = BaseClass("UIRewardTipView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UIRewardTipItem = require("UI.UIRewardTip.Component.UIRewardTipItem")
local Direction = {LEFT = 1, RIGHT = 2}
local ParamData = {
  dir = Direction.LEFT,
  position = Vector2.zero,
  deltaX = 0,
  deltaY = 0,
  totalVal = 0,
  rewardList = {}
}
local ParamDataClass = DataClass("ParamDataClass", ParamData)

function UIRewardTipView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  if CommonUtil.IsArabicAutoMirrorOpen() then
    self.param.deltaX = -self.param.deltaX
    if self.param.dir == Direction.LEFT then
      self.param.dir = Direction.RIGHT
    elseif self.param.dir == Direction.RIGHT then
      self.param.dir = Direction.LEFT
    end
  end
  self:ComponentDefine()
end

function UIRewardTipView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIRewardTipView:ComponentDefine()
  local btnPanel = self:AddComponent(UIButton, "Panel")
  btnPanel:SetOnClick(function()
    self.ctrl.CloseSelf(self.ctrl)
  end)
  self.imgArrow = self:AddComponent(UIBaseContainer, "ImgArrow")
  self.content = self:AddComponent(UIBaseContainer, "content")
  self.titleContent = self:AddComponent(UIBaseContainer, "content/TitleContent")
  self.titleText = self:AddComponent(UIText, "content/TitleContent/TitleText")
  self.rewardContent = self:AddComponent(UIBaseContainer, "content/TextContent/ItemScroll/Viewport/rewardContent")
  self.item = self:AddComponent(UIBaseContainer, "content/TextContent/ItemScroll/Item")
  self.item.gameObject:GameObjectCreatePool()
  self:UpdateData()
end

function UIRewardTipView:ComponentDestroy()
  self.imgArrow = nil
  self.content = nil
  self.titleContent = nil
  self.titleText = nil
  self.rewardContent:RemoveComponents(UIRewardTipItem)
  self.rewardContent = nil
  self.item.gameObject:GameObjectRecycleAll()
  self.item = nil
end

function UIRewardTipView:UpdateData()
  local contentDeltaX = 177
  local contentDeltaY = 175
  local arrowX = self.param.position.x
  local arrowY = self.param.position.y
  self.imgArrow:SetPositionXYZ(arrowX, arrowY, 0)
  local anchoredPosition = self.imgArrow:GetAnchoredPosition()
  local contentPosX = 0
  local contentPosY = 0
  arrowX = anchoredPosition.x + self.param.deltaX
  arrowY = anchoredPosition.y + self.param.deltaY
  self.imgArrow:SetAnchoredPositionXY(arrowX, arrowY)
  self.imgArrow:SetEulerAnglesXYZ(0, 0, 0)
  if self.param.dir == Direction.LEFT then
    self.imgArrow.transform:Set_localScale(-1, 1, 1)
    contentPosX = arrowX + contentDeltaX
  else
    self.imgArrow.transform:Set_localScale(1, 1, 1)
    contentPosX = arrowX - contentDeltaX
  end
  contentPosY = arrowY + contentDeltaY
  if self.param.screenPos then
    local screenPos = self.param.screenPos
    if screenPos.x and screenPos.y then
      local ScreenSize = CS.UnityEngine.Screen
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
      local size = self.content:GetSizeDelta()
      local showTopOrDown = false
      if screenPos.y < size.y - contentDeltaY - 88 then
        arrowX = anchoredPosition.x
        arrowY = anchoredPosition.y + 30
        contentPosY = arrowY + size.y - 7
        showTopOrDown = true
        self.imgArrow.transform:Set_localScale(1, 1, 1)
        self.imgArrow:SetAnchoredPositionXY(arrowX, arrowY)
        self.imgArrow:SetEulerAnglesXYZ(0, 0, -90)
      elseif screenPos.y + contentDeltaY + 128 > ScreenSize.height then
        arrowX = anchoredPosition.x
        arrowY = anchoredPosition.y - 30
        contentPosY = arrowY + 3
        showTopOrDown = true
        self.imgArrow.transform:Set_localScale(1, 1, 1)
        self.imgArrow:SetAnchoredPositionXY(arrowX, arrowY)
        self.imgArrow:SetEulerAnglesXYZ(0, 0, 90)
      elseif screenPos.y + contentDeltaY < size.y then
        contentPosY = arrowY + size.y - screenPos.y + 14
      end
      if showTopOrDown then
        local halfWidth = size.x / 2 + 15
        if halfWidth > screenPos.x then
          contentPosX = arrowX + halfWidth - screenPos.x
        elseif screenPos.x + halfWidth >= ScreenSize.width then
          contentPosX = arrowX - (halfWidth - (ScreenSize.width - screenPos.x))
        else
          contentPosX = arrowX
        end
      end
    end
  end
  self.content:SetAnchoredPositionXY(contentPosX, contentPosY)
  self:RefreshView()
end

function UIRewardTipView:RefreshView()
  if self.param.totalVal > 0 then
    self.titleContent:SetActive(true)
    self.titleText:SetLocalText(2000384, self.param.totalVal)
  else
    self.titleContent:SetActive(false)
  end
  self.rewardContent:RemoveComponents(UIRewardTipItem)
  self.item.gameObject:GameObjectRecycleAll()
  local goItem, theItem
  local list = self.param.rewardList
  if list ~= nil then
    for i = 1, table.length(list) do
      goItem = self.item.gameObject:GameObjectSpawn(self.rewardContent.transform)
      goItem.name = tostring(i)
      theItem = self.rewardContent:AddComponent(UIRewardTipItem, goItem.name)
      theItem:ReInit(list[i])
    end
  end
end

UIRewardTipView.ParamDataClass = ParamDataClass
UIRewardTipView.Direction = Direction
return UIRewardTipView
