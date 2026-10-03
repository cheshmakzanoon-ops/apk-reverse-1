local UIDetectCaveExplorationRewardGet = BaseClass("UIDetectCaveExplorationRewardGet", UIBaseView)
local base = UIBaseView
local panel_path = "UICommonRewardPopUp/Panel"
local banner_path = "UICommonRewardPopUp/Panel/Banner"
local img_title_bg_path = "UICommonRewardPopUp/Panel/ImgTitleBg"
local title_name_path = "UICommonRewardPopUp/Panel/ImgTitleBg/TextTitle"
local layout_path = "layout"
local scroll_view_path = "layout/CellList"
local down_scroll_view_path = "layout/CellListDown"
local tmp_middle_tips_path = "layout/tmpMiddleTips"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local param = self:GetUserData()
  self.param = param
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layout.rectTransform)
end

local function OnDestroy(self)
  if DataCenter.GuideManager:GetGuideType() == GuideType.ShowFakeHero then
    DataCenter.GuideManager:DoNext()
  end
  if self.param and self.param.CloseFunc then
    self.param.CloseFunc()
  end
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, panel_path)
  self.banner = self:AddComponent(UIBaseContainer, banner_path)
  self.img_title_bg = self:AddComponent(UIImage, img_title_bg_path)
  self.title_name = self:AddComponent(UIText, title_name_path)
  self.layout = self:AddComponent(UIBaseContainer, layout_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.down_scroll_view = self:AddComponent(UIScrollView, down_scroll_view_path)
  self.down_scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateDownCell(itemObj, index)
  end)
  self.down_scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteDownCell(itemObj, index)
  end)
  self.btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.middleText = self:AddComponent(UIText, tmp_middle_tips_path)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.banner = nil
  self.img_title_bg = nil
  self.title_name = nil
  self.scroll_view = nil
  self.down_scroll_view = nil
  self.other_title_text = nil
  self.middleText = nil
end

local function DataDefine(self)
  self.param = nil
  self.nameText = nil
  self.cells = {}
  self.showAnim = true
end

local function DataDestroy(self)
  self.param = nil
  self.nameText = nil
  self.cells = nil
  self.showAnim = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self:ReInit()
end

local function OnDisable(self)
  EventManager:GetInstance():Broadcast(EventId.UIDetectCaveRewardsGetViewClose)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function CheckIsExertFun(self)
end

local function ReInit(self)
  self.middleText:SetLocalText(self.param.middle)
  self.title_name:SetLocalText(self.param.title)
  self:ShowCells()
  self.showAnim = true
end

local function ClearScroll(self)
  self.cells = {}
  if self.scroll_view then
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(UICommonResItem)
  end
  if self.down_scroll_view then
    self.down_scroll_view:ClearCells()
    self.down_scroll_view:RemoveComponents(UICommonResItem)
  end
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem
  cellItem = self.scroll_view:AddComponent(UICommonResItem, itemObj)
  local rewardParam = self.param.rewardList_0[index]
  local param = UICommonResItem.Param.New()
  param.rewardType = rewardParam.rewardType
  param.itemId = rewardParam.itemId
  param.count = self.param.detectEventIsBigReward and rewardParam.count / 2 or rewardParam.count
  param.heroUuid = rewardParam.heroUuid
  param.isHeroBox = rewardParam.isHeroBox
  param.bUuid = rewardParam.bUuid
  param.isShowDoubleMark = self.param.detectEventIsBigReward
  cellItem.name_text:SetActive(true)
  cellItem:ReInit(param)
  if self.showAnim then
    self.cells[index] = cellItem
  end
end

local function OnDeleteCell(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UICommonResItem)
end

local function OnCreateDownCell(self, itemObj, index)
  itemObj.name = string.format("down_%d", index)
  local cellItem
  cellItem = self.down_scroll_view:AddComponent(UICommonResItem, itemObj)
  local rewardParam = self.param.rewardList_1[index]
  local param = UICommonResItem.Param.New()
  param.rewardType = rewardParam.rewardType
  param.itemId = rewardParam.itemId
  param.count = self.param.detectEventIsBigReward and rewardParam.count / 2 or rewardParam.count
  param.heroUuid = rewardParam.heroUuid
  param.isHeroBox = rewardParam.isHeroBox
  param.bUuid = rewardParam.bUuid
  param.isShowDoubleMark = self.param.detectEventIsBigReward
  cellItem.name_text:SetActive(true)
  cellItem:ReInit(param)
  if self.showAnim then
    self.cells[index] = cellItem
  end
end

local function OnDeleteDownCell(self, itemObj, index)
  self.down_scroll_view:RemoveComponent(itemObj.name, UICommonResItem)
end

local function ShowCells(self)
  self:ClearScroll()
  if #self.param.rewardList_0 > 0 then
    self.scroll_view.gameObject:SetActive(true)
    self.scroll_view:SetTotalCount(#self.param.rewardList_0)
    self.scroll_view:RefillCells()
  else
    self.scroll_view.gameObject:SetActive(false)
  end
  if 0 < #self.param.rewardList_1 then
    self.down_scroll_view.gameObject:SetActive(true)
    self.down_scroll_view:SetTotalCount(#self.param.rewardList_1)
    self.down_scroll_view:RefillCells()
  else
    self.down_scroll_view.gameObject:SetActive(false)
  end
end

UIDetectCaveExplorationRewardGet.OnCreate = OnCreate
UIDetectCaveExplorationRewardGet.OnDestroy = OnDestroy
UIDetectCaveExplorationRewardGet.OnEnable = OnEnable
UIDetectCaveExplorationRewardGet.OnDisable = OnDisable
UIDetectCaveExplorationRewardGet.ComponentDefine = ComponentDefine
UIDetectCaveExplorationRewardGet.ComponentDestroy = ComponentDestroy
UIDetectCaveExplorationRewardGet.DataDefine = DataDefine
UIDetectCaveExplorationRewardGet.DataDestroy = DataDestroy
UIDetectCaveExplorationRewardGet.OnAddListener = OnAddListener
UIDetectCaveExplorationRewardGet.OnRemoveListener = OnRemoveListener
UIDetectCaveExplorationRewardGet.CheckIsExertFun = CheckIsExertFun
UIDetectCaveExplorationRewardGet.ReInit = ReInit
UIDetectCaveExplorationRewardGet.OnDeleteCell = OnDeleteCell
UIDetectCaveExplorationRewardGet.OnDeleteDownCell = OnDeleteDownCell
UIDetectCaveExplorationRewardGet.ShowCells = ShowCells
UIDetectCaveExplorationRewardGet.OnCreateCell = OnCreateCell
UIDetectCaveExplorationRewardGet.OnCreateDownCell = OnCreateDownCell
UIDetectCaveExplorationRewardGet.ClearScroll = ClearScroll
return UIDetectCaveExplorationRewardGet
