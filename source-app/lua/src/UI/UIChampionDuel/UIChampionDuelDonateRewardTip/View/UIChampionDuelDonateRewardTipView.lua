local UIChampionDuelDonateRewardTipView = BaseClass("UIChampionDuelDonateRewardTipView", UIBaseView)
local base = UIBaseView
local ParamData = {
  titleStr = "",
  position = Vector2.zero,
  deltaY = 0,
  rewardList = {}
}
local ParamDataClass = DataClass("ParamDataClass", ParamData)

local function OnCreate(self)
  base.OnCreate(self)
  self.param = nil
  self:ComponentDefine()
  self:RefreshView()
end

local function OnDestroy(self)
  self.param = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  local btnPanel = self:AddComponent(UIButton, "Panel")
  btnPanel:SetOnClick(function()
    self.ctrl.CloseSelf(self.ctrl)
  end)
  self.imgArrow = self:AddComponent(UIBaseContainer, "ImgArrow")
  self.content = self:AddComponent(UIBaseContainer, "content")
  self.longTitleText = self:AddComponent(UITextMeshProUGUIEx, "content/LongTitleContent/LongTitleText")
  self.rewardContent = self:AddComponent(UIBaseContainer, "content/TextContent/rewardContent")
  self.touchTrough = btnPanel.rectTransform:GetComponent(typeof(CS.LFTouchThrough))
  self.theItem = self.transform:Find("Item").gameObject
  self.theItem:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self:ClearContent()
  self.theItem = nil
  self.imgArrow = nil
  self.content = nil
  self.longTitleText = nil
  self.rewardContent = nil
end

local function RefreshView(self)
  self.param = self:GetUserData()
  local arrowX = self.param.position.x
  local arrowY = self.param.position.y
  self.imgArrow:SetPositionXYZ(arrowX, arrowY, 0)
  local anchoredPosition = self.imgArrow:GetAnchoredPosition()
  arrowX = anchoredPosition.x
  arrowY = anchoredPosition.y + self.param.deltaY
  self.imgArrow:SetAnchoredPositionXY(arrowX, arrowY)
  local contentW = 530
  local contentX = arrowX
  local contentMaxX = 390
  if contentX - contentW / 2 < -1 * contentMaxX then
    contentX = -1 * contentMaxX + contentW / 2
  elseif contentMaxX < contentX + contentW / 2 then
    contentX = contentMaxX - contentW / 2
  end
  self.content:SetAnchoredPositionXY(contentX, arrowY + 3)
  self.longTitleText:SetText(self.param.titleStr)
  self:ClearContent()
  local showData = self.param.rewardList
  if not table.IsNullOrEmpty(showData) then
    for i, data in pairs(showData) do
      local goItem = self.theItem:GameObjectSpawn(self.rewardContent.transform)
      goItem.name = "Item" .. i
      goItem:SetActive(true)
      local item = self.rewardContent:AddComponent(UIBaseContainer, goItem.name)
      local cell = item:AddComponent(UICommonResItem, "UICommonResItem")
      cell:ReInit(data)
    end
  end
end

local function ClearContent(self)
  self.rewardContent:RemoveComponents(UIBaseContainer)
  self.theItem:GameObjectRecycleAll()
end

UIChampionDuelDonateRewardTipView.ParamDataClass = ParamDataClass
UIChampionDuelDonateRewardTipView.OnCreate = OnCreate
UIChampionDuelDonateRewardTipView.OnDestroy = OnDestroy
UIChampionDuelDonateRewardTipView.ComponentDefine = ComponentDefine
UIChampionDuelDonateRewardTipView.ComponentDestroy = ComponentDestroy
UIChampionDuelDonateRewardTipView.RefreshView = RefreshView
UIChampionDuelDonateRewardTipView.ClearContent = ClearContent
return UIChampionDuelDonateRewardTipView
