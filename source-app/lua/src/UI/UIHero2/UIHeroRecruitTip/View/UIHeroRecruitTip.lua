local UIHeroRecruitTip = BaseClass("UIHeroRecruitTip", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIDropCell = require("UI.UIHero2.UIHeroRecruitTip.Component.UIDropCell")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

local function OnDestroy(self)
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  local btnPanel = self:AddComponent(UIButton, "Panel")
  btnPanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.textTitle = self:AddComponent(UIText, "Root/TextTitle")
  self.textTip1 = self:AddComponent(UIText, "Root/TextTip1")
  self.textSubTitle = self:AddComponent(UIText, "Root/TextSubTitle")
  self.btnChange = self:AddComponent(UIButton, "Root/BtnChange")
  self.nodeCamps = {}
  for i = 0, 3 do
    local camp = self:AddComponent(UIBaseContainer, "Root/CampContent/Camp" .. i)
    camp:SetActive(false)
    self.nodeCamps[i] = camp
  end
  self.nodePanel1 = self:AddComponent(UIBaseContainer, "Root/ImgContentBg/NodePanel1")
  self.nodePanel2 = self:AddComponent(UIBaseContainer, "Root/ImgContentBg/NodePanel2")
  self.scrollView = self:AddComponent(UIScrollView, "Root/ImgContentBg/NodePanel1")
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  local textRateTitleKey = {
    [0] = "110169",
    [1] = "110122",
    [2] = "110121",
    [3] = "110120",
    [4] = "110167"
  }
  self.nodeRateList = {}
  for i = 0, 4 do
    local nodeAttr = self:AddComponent(UIText, "Root/ImgContentBg/NodePanel2/NodeAttr" .. i)
    local textTitle = self:AddComponent(UIText, "Root/ImgContentBg/NodePanel2/NodeAttr" .. i .. "/TextTitle" .. i)
    local textValue = self:AddComponent(UIText, "Root/ImgContentBg/NodePanel2/NodeAttr" .. i .. "/TextValue" .. i)
    textTitle:SetLocalText(textRateTitleKey[i])
    self.nodeRateList[i] = {node = nodeAttr, textValue = textValue}
  end
  self.textTitle:SetLocalText(110117)
  self.textTip1:SetLocalText(110118)
  self.btnChange:SetOnClick(BindCallback(self, self.OnBtnChangeClick))
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(UIDropCell, itemObj)
  cellItem:SetData(self.dataList[index])
end

local function OnDeleteCell(self, itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, UIDropCell)
end

local function ComponentDestroy(self)
  self.textTitle = nil
  self.textTip1 = nil
  self.textSubTitle = nil
  self.btnChange = nil
  self.nodePanel1 = nil
  self.nodePanel2 = nil
  self.scrollView = nil
  self.tabCamps = nil
end

local function DataDefine(self)
  self.panelIndex = 1
  self.lotteryId = nil
  self.dataList = nil
end

local function DataDestroy(self)
  self.panelIndex = nil
  self.lotteryId = nil
  self.dataList = nil
end

local function OnOpen(self)
  self.lotteryId = self:GetUserData()
  self:UpdateView()
  self:SwitchPanel(1)
end

local function UpdateView(self)
  self.isSpecialCampLotteryId = DataCenter.LotteryDataManager:IsSpecialCampLottery(self.lotteryId)
  if self.isSpecialCampLotteryId then
    self.lotteryId = DataCenter.LotteryDataManager:GetSpecialCampCurLotteryId()
  end
  self.lotteryData = DataCenter.LotteryDataManager:GetLotteryDataById(self.lotteryId)
  local dropCampStrList = self.ctrl:GetDropCampInfo(self.lotteryId)
  for _, v in pairs(dropCampStrList) do
    local camp = tonumber(v)
    if self.nodeCamps[camp] ~= nil then
      self.nodeCamps[camp]:SetActive(true)
    end
  end
  local dropRateInfo = self.ctrl:GetDropRateInfo(self.lotteryId)
  for rarityId, t in pairs(self.nodeRateList) do
    local rate = tonumber(dropRateInfo[rarityId])
    t.node:SetActive(rate ~= nil and rate ~= 0)
    if rate ~= nil then
      t.textValue:SetText(rate .. "%")
    end
  end
  self:UpdateCampShow()
  self:ShowCells()
end

local function UpdateCampShow(self)
  if self.isSpecialCampLotteryId then
    local displayConfig = DataCenter.LotteryDataManager:GetDisplayConfig()
    local curCamp = displayConfig:GetCampId(self.lotteryId)
    local curCampName = HeroUtils.GetCampNameAndDesc(curCamp)
    local nextCampId = displayConfig:GetCampId(DataCenter.LotteryDataManager.nextCampLotteryId)
    local nextCampName = nextCampId and HeroUtils.GetCampNameAndDesc(nextCampId) or ""
    self.curCampName = curCampName
    self.nextCampName = nextCampName
  else
    self.textTip1:SetLocalText(110118)
  end
end

local function SwitchPanel(self, index)
  self.nodePanel1:SetActive(index == 1)
  self.nodePanel2:SetActive(index == 2)
  self.textSubTitle:SetLocalText(110119)
  self.panelIndex = index
end

local function ShowCells(self)
  self:ClearScroll()
  self.dataList = self.ctrl:GetDropHeroList(self.lotteryId)
  local dataCount = table.count(self.dataList)
  if dataCount <= 0 then
    return
  end
  self.scrollView:SetTotalCount(dataCount)
  self.scrollView:RefillCells(1)
end

local function ClearScroll(self)
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UIDropCell)
end

local function OnBtnChangeClick(self)
  self:SwitchPanel(self.panelIndex == 1 and 2 or 1)
end

local function Update(self)
  if not self.isSpecialCampLotteryId then
    return
  end
  local curCampName = self.curCampName
  local nextCampName = self.nextCampName
  local leftTime = math.max(0, self.lotteryData.endTime - UITimeManager:GetInstance():GetServerTime())
  if leftTime == 0 then
    self:UpdateView()
    return
  end
  local leftTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.textTip1:SetText(Localization:GetString("110130", curCampName) .. "\n" .. Localization:GetString("110131", leftTimeStr, nextCampName))
end

UIHeroRecruitTip.OnCreate = OnCreate
UIHeroRecruitTip.OnDestroy = OnDestroy
UIHeroRecruitTip.ComponentDefine = ComponentDefine
UIHeroRecruitTip.ComponentDestroy = ComponentDestroy
UIHeroRecruitTip.DataDefine = DataDefine
UIHeroRecruitTip.DataDestroy = DataDestroy
UIHeroRecruitTip.OnOpen = OnOpen
UIHeroRecruitTip.UpdateView = UpdateView
UIHeroRecruitTip.UpdateCampShow = UpdateCampShow
UIHeroRecruitTip.SwitchPanel = SwitchPanel
UIHeroRecruitTip.ShowCells = ShowCells
UIHeroRecruitTip.ClearScroll = ClearScroll
UIHeroRecruitTip.OnCreateCell = OnCreateCell
UIHeroRecruitTip.OnDeleteCell = OnDeleteCell
UIHeroRecruitTip.OnBtnChangeClick = OnBtnChangeClick
UIHeroRecruitTip.Update = Update
return UIHeroRecruitTip
