local UIAllianceStarBookSessionPanel = BaseClass("UIAllianceStarBookSessionPanel", UIBaseContainer)
local UIAllianceStarBookSessionItem = require("UI.UIAllianceStarBook.Component.UIAllianceStarBookSessionItem")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UICommonHead = require("Framework.UI.Component.UICommonHead")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.textTitle = self:AddComponent(UIText, "TitleText")
  self.textTitle:SetLocalText("alliance_weeklyStar_book_title_catalogue")
  self.btnRight = self:AddComponent(UIButton, "PagePanel/RightBtn")
  self.btnRight:SetOnClick(function()
    self:OnBtnRightClick()
  end)
  self.btnLeft = self:AddComponent(UIButton, "PagePanel/leftBtn")
  self.btnLeft:SetOnClick(function()
    self:OnBtnLeftClick()
  end)
  self.inputPageNum = self:AddComponent(UIInput, "PagePanel/PageNumInput")
  self.inputPageNum:SetOnEndEdit(function(value)
    if IsNumber(value) then
      local num = tonumber(value)
      if 0 < num and num <= self.maxPageNum then
        self:OnPageNumValueChange(num)
      else
        self.inputPageNum:SetText(self.pageId)
      end
    else
      self.inputPageNum:SetText(self.pageId)
    end
  end)
  self.textMax = self:AddComponent(UIText, "PagePanel/MaxText")
  self.compSessionLayout = self:AddComponent(UIBaseContainer, "SessionLayout")
  local childCount = self.compSessionLayout.transform.childCount
  self.sessionItems = {}
  for i = 0, childCount - 1 do
    local child = self.compSessionLayout.transform:GetChild(i).gameObject
    child.name = "SessionItem" .. i
    local comp = self.compSessionLayout:AddComponent(UIAllianceStarBookSessionItem, child.name)
    comp:SetActive(false)
    table.insert(self.sessionItems, comp)
  end
  self.img = self:AddComponent(UIImage, "Image")
  if CommonUtil.IsArabicAutoMirrorOpen() then
    self.img:SetAnchoredPositionXY(self.img:GetAnchoredPositionX(), -604.6)
  else
    self.img:SetAnchoredPositionXY(self.img:GetAnchoredPositionX(), -601.7)
  end
end

local function ComponentDestroy(self)
  self.sessionItems = nil
  self.btnRight = nil
  self.btnLeft = nil
  self.inputPageNum = nil
  self.textMax = nil
  self.compSessionLayout = nil
end

local function DataDefine(self)
  self.pageId = 1
end

local function DataDestroy(self)
  self.pageId = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnPageNumValueChange(self, value, isLeft)
  if self.historyInfoList and 0 < value and value <= self.maxPageNum then
    self.view:ShowSessionPanelChangeAnim(value, isLeft)
  end
end

local function OnBtnRightClick(self)
  self:OnPageNumValueChange(self.pageId + 1, false)
end

local function OnBtnLeftClick(self)
  self:OnPageNumValueChange(self.pageId - 1, true)
end

local function Refresh(self, pageId)
  self.historyInfoList = DataCenter.AllianceStarManager.historyInfoList
  self.maxPageNum = math.ceil(#self.historyInfoList / #self.sessionItems)
  if pageId == nil then
    self.pageId = self.pageId or 1
  else
    self.pageId = pageId
  end
  local onePageNum = #self.sessionItems
  local beginNum = #self.sessionItems * (self.pageId - 1)
  for i = 1, onePageNum do
    if self.historyInfoList and self.historyInfoList[beginNum + i] then
      self.sessionItems[i]:SetActive(true)
      self.sessionItems[i]:SetData(self.historyInfoList[beginNum + i])
    else
      self.sessionItems[i]:SetActive(false)
    end
  end
  self.textMax:SetText("/ " .. self.maxPageNum)
  self.inputPageNum:SetText(self.pageId)
  self.btnLeft:SetActive(self.pageId > 1)
  self.btnRight:SetActive(self.pageId < self.maxPageNum)
end

UIAllianceStarBookSessionPanel.OnCreate = OnCreate
UIAllianceStarBookSessionPanel.OnDestroy = OnDestroy
UIAllianceStarBookSessionPanel.OnEnable = OnEnable
UIAllianceStarBookSessionPanel.OnDisable = OnDisable
UIAllianceStarBookSessionPanel.ComponentDefine = ComponentDefine
UIAllianceStarBookSessionPanel.ComponentDestroy = ComponentDestroy
UIAllianceStarBookSessionPanel.DataDefine = DataDefine
UIAllianceStarBookSessionPanel.DataDestroy = DataDestroy
UIAllianceStarBookSessionPanel.OnAddListener = OnAddListener
UIAllianceStarBookSessionPanel.OnRemoveListener = OnRemoveListener
UIAllianceStarBookSessionPanel.OnPageNumValueChange = OnPageNumValueChange
UIAllianceStarBookSessionPanel.OnBtnLeftClick = OnBtnLeftClick
UIAllianceStarBookSessionPanel.OnBtnRightClick = OnBtnRightClick
UIAllianceStarBookSessionPanel.Refresh = Refresh
return UIAllianceStarBookSessionPanel
