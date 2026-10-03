local ServerBattleCampDetailView = BaseClass("ServerBattleCampDetailView", UIBaseView)
local base = UIBaseView
local ServerBattleCampDetailItem = require("UI.UIGovernment.ServerBattleCampDetail.Component.ServerBattleCampDetailItem")
local panel_path = "panel"
local close_btn_path = "PopUpTitle/CloseBtn"
local scroll_view_path = "PopUpTitle/ScrollView"
local content_path = "PopUpTitle/ScrollView/Viewport/Content"
local page_cell_path = "PopUpTitle/ScrollView/Viewport/PageCell"
local page_identify_root_path = "PopUpTitle/PageIdentify"
local page_identify_path = "PopUpTitle/PageIdentify/1"
local left_arrow_path = "PopUpTitle/SwitchArrows/LeftArrow"
local right_arrow_path = "PopUpTitle/SwitchArrows/RightArrow"
local pop_up_root_path = "PopUpTitle"

function ServerBattleCampDetailView:OnCreate()
  base.OnCreate(self)
  self.param = self:GetUserData() or {}
  self:ComponentDefine()
end

function ServerBattleCampDetailView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ServerBattleCampDetailView:ComponentDefine()
  self.root = self:AddComponent(UICanvasGroup, pop_up_root_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self, self.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.bg = self:AddComponent(UIImage, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self, self.CloseSelf))
  self.scroll_view = self:AddComponent(UIScrollPage, scroll_view_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.page_identify = self:AddComponent(UIBaseContainer, page_identify_root_path)
  self.left_arrow = self:AddComponent(UIButton, left_arrow_path)
  self.right_arrow = self:AddComponent(UIButton, right_arrow_path)
  self.scroll_view:SetPageChangedCallback(BindCallback(self, self.OnUpdateScroll))
  self.left_arrow:SetOnClick(function()
    self.scroll_view:ToPrevPage()
    self:OnUpdateScroll(self.scroll_view.currentPageIndex)
  end)
  self.right_arrow:SetOnClick(function()
    self.scroll_view:ToNextPage()
    self:OnUpdateScroll(self.scroll_view.currentPageIndex)
  end)
  self.thePageItem = self.transform:Find(page_cell_path).gameObject
  self.thePageItem:GameObjectCreatePool()
  self.thePageIdentifyItem = self.transform:Find(page_identify_path).gameObject
  self.thePageIdentifyItem:GameObjectCreatePool()
  self.scroll_view:SetNormalizedPosition(0)
  local ToggleList = {}
  local GuideList = self.param.guideList
  local listCnt = #GuideList
  self.content:SetSizeDeltaXY(listCnt * 735, 596)
  if 0 < listCnt then
    for index, v in ipairs(GuideList) do
      local theName = "page_" .. index
      local goItem = self.thePageItem:GameObjectSpawn(self.content.transform)
      goItem.name = theName
      goItem:SetActive(true)
      local itemNode = self.content:AddComponent(ServerBattleCampDetailItem, theName)
      itemNode:ReInit(v)
      goItem = self.thePageIdentifyItem:GameObjectSpawn(self.page_identify.transform)
      goItem.name = theName
      goItem:SetActive(true)
      local itemToggle = self.page_identify:AddComponent(UIToggle, theName)
      local theIndex = index
      itemToggle:SetIsOn(false)
      ToggleList[index] = itemToggle
      itemToggle:SetOnValueChanged(function(tf)
        if tf then
          self.scroll_view:PageTo(theIndex)
        end
      end)
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  self.GuideList = GuideList
  self.ToggleList = ToggleList
  self.scroll_view:SetPageCount(listCnt)
  self.bg:SetAlpha(0.88)
  ToggleList[1]:SetIsOn(true)
  self.content:SetLocalPositionXYZ(0, 0, 0)
  if self.param.animShow and self.param.pos then
    self.root:SetAlpha(0)
    self.root:SetLocalScaleXYZ(0, 0, 0)
    self.root.transform.position = self.param.pos
    local sequence = DOTween.Sequence()
    sequence:Append(self.root:FadeIn(0.2))
    sequence:Join(self.root.transform:DOMove(self.transform.position, 0.3))
    sequence:Join(self.root.transform:DOScale(Vector3.New(1, 1, 1), 0.3))
  else
    self.root:SetAlpha(1)
    self.root:SetLocalPositionXYZ(0, 0, 0)
    self.root:SetLocalScaleXYZ(1, 1, 1)
  end
end

function ServerBattleCampDetailView:OnUpdateScroll(index)
  local itemToggle = self.ToggleList[index]
  if itemToggle ~= nil then
    itemToggle:SetIsOn(true)
  end
end

function ServerBattleCampDetailView:ComponentDestroy()
  self.scroll_view:PageTo(1, true)
  self.scroll_view:SetNormalizedPosition(0)
  self.content:RemoveComponents(ServerBattleCampDetailItem)
  self.thePageItem:GameObjectRecycleAll()
  self.page_identify:RemoveComponents(UIToggle)
  self.thePageIdentifyItem:GameObjectRecycleAll()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  self.btn_back = nil
  self.root = nil
end

function ServerBattleCampDetailView:CloseSelf()
  if self.param.animHide and self.param.pos then
    local sequence = DOTween.Sequence()
    sequence:Append(self.root:FadeOut(0.35))
    sequence:Join(self.bg:DOFade(0, 0.35))
    sequence:Join(self.root.transform:DOMove(self.param.pos, 0.3))
    sequence:Join(self.root.transform:DOScale(Vector3.New(0, 0, 0), 0.3))
    sequence:AppendCallback(function()
      UIManager:GetInstance():DestroyWindow(UIWindowNames.ServerBattleCampDetail)
    end)
  else
    self.ctrl:CloseSelf()
  end
end

return ServerBattleCampDetailView
