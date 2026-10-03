local SeasonDeclareInfo = require("UI.LWSeason.LWSeasonMain.Component.DeclareCity.SeasonDeclareInfo")
local SeasonDeclareList = BaseClass("SeasonDeclareList", UIBaseContainer)
local base = UIBaseContainer
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")
local scroll_view_path = "ScrollView"
local content_path = "ScrollView/Viewport/Content"
local switch_arrows_path = "SwitchArrows"
local left_arrow_path = "SwitchArrows/LeftArrow"
local right_arrow_path = "SwitchArrows/RightArrow"
local red_point_path = "SwitchArrows/RightArrow/RedPoint"

function SeasonDeclareList:OnCreate()
  base.OnCreate(self)
  self.scroll_view = self:AddComponent(UIScrollPage, scroll_view_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.switch_arrows = self:AddComponent(UIBaseContainer, switch_arrows_path)
  self.left_arrow = self:AddComponent(UIButton, left_arrow_path)
  self.right_arrow = self:AddComponent(UIButton, right_arrow_path)
  self.red_point = self:AddComponent(UIImage, red_point_path)
  self.scroll_view:SetPageChangedCallback(BindCallback(self, self.OnUpdateScroll))
  self.left_arrow:SetOnClick(function()
    if self.scroll_view.currentPageIndex > 1 then
      self.scroll_view:SmoothScrollToPage(self.scroll_view.currentPageIndex - 1)
    end
    self:OnUpdateScroll(self.scroll_view.currentPageIndex)
  end)
  self.right_arrow:SetOnClick(function()
    if self.scroll_view.currentPageIndex < self.scroll_view.cell_count then
      self.scroll_view:SmoothScrollToPage(self.scroll_view.currentPageIndex + 1)
    end
    self.red_point:SetActive(false)
    self:OnUpdateScroll(self.scroll_view.currentPageIndex)
  end)
  self.PageList = nil
  self.dataCount = 0
end

function SeasonDeclareList:OnDestroy()
  self.content:RemoveComponents(SeasonDeclareInfo)
  base.OnDestroy(self)
end

function SeasonDeclareList:cleanData()
  self.content:RemoveComponents(SeasonDeclareInfo)
end

function SeasonDeclareList:ReInit(view, declareList, thePageItem, redPointKey)
  self.content:RemoveComponents(SeasonDeclareInfo)
  self.thePageItem = thePageItem
  if self.PageList then
    for k, v in ipairs(self.PageList) do
      if v and not IsNull(v.gameObject) then
        v.gameObject:GameObjectRecycle()
      end
    end
  end
  if declareList and 0 < #declareList then
    local dataCount = #declareList
    local PageList = {}
    self.dataCount = dataCount
    self.scroll_view:SetActive(true)
    local goItem, theItem
    for k, v in ipairs(declareList) do
      NameCount = NameCount + 1
      goItem = self.thePageItem:GameObjectSpawn(self.content.transform)
      goItem.name = "item_" .. NameCount
      goItem:SetActive(true)
      theItem = self.content:AddComponent(SeasonDeclareInfo, goItem.name)
      theItem:ReInit(v)
      table.insert(PageList, theItem)
    end
    self.PageList = PageList
    self.scroll_view:SetPageCount(dataCount)
    self.scroll_view:PageTo(1)
    self.switch_arrows:SetActive(1 < dataCount)
    self.left_arrow:SetActive(1 < dataCount)
    self.right_arrow:SetActive(1 < dataCount)
    if 1 < dataCount then
      local count = SeasonRedPointUtils.GetCrossDeclareWarRedPoint(redPointKey)
      self.red_point:SetActive(1 < count)
    else
      self.red_point:SetActive(false)
    end
  else
    self.PageList = {}
    self.scroll_view:SetActive(false)
    self.switch_arrows:SetActive(false)
    self.left_arrow:SetActive(false)
    self.right_arrow:SetActive(false)
    self.red_point:SetActive(false)
  end
end

function SeasonDeclareList:UpdateRedPoint(index)
  if self.PageList then
    local page = self.PageList[index or 1]
    if page then
      page:RemoveRedPoint()
    end
  end
end

function SeasonDeclareList:OnUpdateScroll(index)
  self.left_arrow:SetActive(index ~= 1)
  self.right_arrow:SetActive(index ~= self.scroll_view.cell_count)
  self:UpdateRedPoint(index)
end

function SeasonDeclareList:OnBtnClickGotoCity()
  if self.PageList then
    local page = self.PageList[self.scroll_view.currentPageIndex]
    if page then
      page:JumpTo()
    end
  end
end

return SeasonDeclareList
