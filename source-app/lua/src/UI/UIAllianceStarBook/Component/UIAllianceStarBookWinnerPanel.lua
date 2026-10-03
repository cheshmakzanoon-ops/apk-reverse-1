local UIAllianceStarBookWinnerPanel = BaseClass("UIAllianceStarBookWinnerPanel", UIBaseContainer)
local UIAllianceStarBookWinnerItem = require("UI.UIAllianceStarBook.Component.UIAllianceStarBookWinnerItem")
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
  self.textTime = self:AddComponent(UIText, "TimeText")
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
  self.btnBackSession = self:AddComponent(UIButton, "BackSessionBtn")
  self.btnBackSession:SetOnClick(function()
    self:OnBtnBackSessionClick()
  end)
  self.compWinnerLayout = self:AddComponent(UIBaseContainer, "WinnerLayout")
  local childCount = self.compWinnerLayout.transform.childCount
  self.winnerItems = {}
  for i = 0, childCount - 1 do
    local child = self.compWinnerLayout.transform:GetChild(i).gameObject
    child.name = "WinnerItem" .. i
    local comp = self.compWinnerLayout:AddComponent(UIAllianceStarBookWinnerItem, child.name)
    comp:SetActive(false)
    table.insert(self.winnerItems, comp)
  end
  self.line1 = self:AddComponent(UIBaseContainer, "Line1")
  self.line2 = self:AddComponent(UIBaseContainer, "Line2")
  if CommonUtil.IsArabicAutoMirrorOpen() then
    self.btnBackSession:SetAnchoredPositionXY(self.btnBackSession:GetAnchoredPositionX(), -579.7)
  else
    self.btnBackSession:SetAnchoredPositionXY(self.btnBackSession:GetAnchoredPositionX(), -576)
  end
end

local function ComponentDestroy(self)
  self.winnerItems = nil
  self.btnRight = nil
  self.btnLeft = nil
  self.inputPageNum = nil
  self.textMax = nil
  self.compWinnerLayout = nil
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

local function OnBtnBackSessionClick(self)
  self.view:ShowWinnerToSessionAnim()
end

local function OnPageNumValueChange(self, value, isLeft)
  if 0 < value and value <= self.maxPageNum then
    self.view:ShowWinnerPanelChangeAnim(self.ceremonyEdition, value, isLeft)
  end
end

local function OnBtnRightClick(self)
  self:OnPageNumValueChange(self.pageId + 1, false)
end

local function OnBtnLeftClick(self)
  self:OnPageNumValueChange(self.pageId - 1, true)
end

local function Refresh(self, ceremonyEdition, pageNum)
  pageNum = pageNum or 1
  self.textTitle:SetLocalText("alliance_weeklyStar_book_title_inner", ceremonyEdition)
  self.ceremonyEdition = ceremonyEdition
  self.historyInfoList = DataCenter.AllianceStarManager.historyInfoList
  local data
  if self.historyInfoList then
    for i, v in ipairs(self.historyInfoList) do
      if v.ceremonyEdition == ceremonyEdition then
        data = v
        break
      end
    end
  end
  if data and data.detailData then
    self.textTime:SetText(UITimeManager:GetInstance():GetTimeToMD(math.modf(data.startTimeStamp / 1000)))
    local roleInfoList = data.detailData.roleInfo
    local ceremonyEditionInfo = data.detailData.ceremonyEditionInfo
    self.pageId = pageNum
    local onePageNum = #self.winnerItems
    local beginNum = #self.winnerItems * (self.pageId - 1)
    self.maxPageNum = math.ceil(#ceremonyEditionInfo / onePageNum)
    self.line1:SetActive(false)
    self.line2:SetActive(false)
    for i = 1, onePageNum do
      if ceremonyEditionInfo then
        local ceremonyInfo = ceremonyEditionInfo[beginNum + i]
        local roleInfo = roleInfoList[beginNum + i]
        if ceremonyInfo and roleInfo then
          self.winnerItems[i]:SetActive(true)
          self.winnerItems[i]:SetData(ceremonyInfo, roleInfo)
          if 0 < i then
            self.line1:SetActive(true)
          end
          if 2 < i then
            self.line2:SetActive(true)
          end
        else
          self.winnerItems[i]:SetActive(false)
        end
      end
    end
    self.textMax:SetText("/ " .. self.maxPageNum)
    self.inputPageNum:SetText(self.pageId)
    self.btnLeft:SetActive(1 < self.pageId)
    self.btnRight:SetActive(self.pageId < self.maxPageNum)
  else
    self.maxPageNum = 1
    self.pageId = 1
    self.textMax:SetText("/ " .. self.maxPageNum)
    self.inputPageNum:SetText(self.pageId)
    self.line1:SetActive(false)
    self.line2:SetActive(false)
    for i = 1, #self.winnerItems do
      self.winnerItems[i]:SetActive(false)
    end
    self.btnLeft:SetActive(1 < self.pageId)
    self.btnRight:SetActive(self.pageId < self.maxPageNum)
  end
end

UIAllianceStarBookWinnerPanel.OnCreate = OnCreate
UIAllianceStarBookWinnerPanel.OnDestroy = OnDestroy
UIAllianceStarBookWinnerPanel.OnEnable = OnEnable
UIAllianceStarBookWinnerPanel.OnDisable = OnDisable
UIAllianceStarBookWinnerPanel.ComponentDefine = ComponentDefine
UIAllianceStarBookWinnerPanel.ComponentDestroy = ComponentDestroy
UIAllianceStarBookWinnerPanel.DataDefine = DataDefine
UIAllianceStarBookWinnerPanel.DataDestroy = DataDestroy
UIAllianceStarBookWinnerPanel.OnAddListener = OnAddListener
UIAllianceStarBookWinnerPanel.OnRemoveListener = OnRemoveListener
UIAllianceStarBookWinnerPanel.OnPageNumValueChange = OnPageNumValueChange
UIAllianceStarBookWinnerPanel.OnBtnLeftClick = OnBtnLeftClick
UIAllianceStarBookWinnerPanel.OnBtnRightClick = OnBtnRightClick
UIAllianceStarBookWinnerPanel.OnBtnBackSessionClick = OnBtnBackSessionClick
UIAllianceStarBookWinnerPanel.Refresh = Refresh
return UIAllianceStarBookWinnerPanel
