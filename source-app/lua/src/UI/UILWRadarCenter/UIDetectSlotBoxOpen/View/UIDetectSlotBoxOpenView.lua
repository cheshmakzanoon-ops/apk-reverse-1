local base = UIBaseView
local UIDetectSlotBoxOpenView = BaseClass("UIDetectSlotBoxOpenView", base)
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UIDetectSlotBoxItem = require("UI.UILWRadarCenter.UIDetectSlotBoxOpen.Component.UIDetectSlotBoxItem")
local panel_path = "Panel"
local bg_content1_path = "bgContent1"
local bg_content2_path = "bgContent2"
local have_num_path = "bgContent2/haveNum"
local confirm_btn_path = "bgContent2/confirmBtn"
local btn_txt_path = "bgContent2/confirmBtn/btnTxt"
local box_title_txt_path = "bgContent2/bg_1/bg_3/BoxTitleTxt"
local confirm_btn_img_path = "bgContent2/confirmBtn/confirmBtnImg"
local panel_ani_path = ""
local box_item1_path = "infoContent/boxItem1"
local box_item2_path = "infoContent/boxItem2"
local box_item3_path = "infoContent/boxItem3"
local background_path = "bgContent2/bg_1/background"
local maxBox = 3
local waitOpenAni = 0
local waitSendTime = 0

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.configId, self.panelType, self.userParam = self:GetUserData()
  self:RefreshView()
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
  if self.rewards or self.pathRewards then
    DataCenter.RewardManager:ShowTwoLinesRewards(self.rewards, self.pathRewards, "128027", self.showTip)
  end
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.bg_content1 = self:AddComponent(UIBaseContainer, bg_content1_path)
  self.bg_content2 = self:AddComponent(UIBaseContainer, bg_content2_path)
  self.have_num = self:AddComponent(UIText, have_num_path)
  self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
  self.btn_txt = self:AddComponent(UIText, btn_txt_path)
  self.box_title_txt = self:AddComponent(UIText, box_title_txt_path)
  self.confirm_btn_img = self:AddComponent(UIImage, confirm_btn_img_path)
  self.panel_ani = self:AddComponent(UIAnimator, panel_ani_path)
  self.box_item1 = self:AddComponent(UIDetectSlotBoxItem, box_item1_path)
  self.box_item2 = self:AddComponent(UIDetectSlotBoxItem, box_item2_path)
  self.box_item3 = self:AddComponent(UIDetectSlotBoxItem, box_item3_path)
  self.background = self:AddComponent(UIRawImage, background_path)
  self.box_item1_btn = self:AddComponent(UIButton, box_item1_path)
  self.box_item2_btn = self:AddComponent(UIButton, box_item2_path)
  self.box_item3_btn = self:AddComponent(UIButton, box_item3_path)
  self.panel:SetOnClick(function()
    self:OnPanelClick()
  end)
  self.isOpenBox = false
  self.confirm_btn:SetActive(false)
  self.box_item1_btn:SetOnClick(function()
    if self:CheckCanOpenBox(1, true) then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      waitSendTime = curTime + 5000
      self.box_item1:PlayOpenEffect(function()
        waitSendTime = 0
        self:OnBoxClick(1)
      end)
    end
  end)
  self.box_item2_btn:SetOnClick(function()
    if self:CheckCanOpenBox(2, true) then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      waitSendTime = curTime + 5000
      self.box_item2:PlayOpenEffect(function()
        waitSendTime = 0
        self:OnBoxClick(2)
      end)
    end
  end)
  self.box_item3_btn:SetOnClick(function()
    if self:CheckCanOpenBox(3, true) then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      waitSendTime = curTime + 5000
      self.box_item3:PlayOpenEffect(function()
        waitSendTime = 0
        self:OnBoxClick(3)
      end)
    end
  end)
  self.boxItemList = {
    self.box_item1,
    self.box_item2,
    self.box_item3
  }
  self.btn_txt:SetLocalText("393108")
  self.confirm_btn:SetOnClick(function()
    self:OnConfirmBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.panel = nil
  self.bg_content1 = nil
  self.bg_content2 = nil
  self.have_num = nil
  self.confirm_btn = nil
  self.btn_txt = nil
  self.box_title_txt = nil
  self.confirm_btn_img = nil
  self.panel_ani = nil
  self.box_item1 = nil
  self.box_item2 = nil
  self.box_item3 = nil
  self.background = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.rewards = nil
  self.pathRewards = nil
  self.showTip = nil
end

function UIDetectSlotBoxOpenView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DetectCaveExplorationFinish, self.FinishEvent)
end

function UIDetectSlotBoxOpenView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.DetectCaveExplorationFinish, self.FinishEvent)
end

function UIDetectSlotBoxOpenView:RefreshView()
  local t = LocalController:instance():getLine(TableName.CaveExplorationBox, self.configId)
  for i, v in ipairs(self.boxItemList) do
    v:SetData(t, i)
  end
  self.bg_content1:SetActive(true)
  self.bg_content2:SetActive(true)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.panel_ani:Enable(true)
  local _, aniTime = self.panel_ani:PlayAnimationReturnTime("movein")
  waitOpenAni = curTime + aniTime * 1000
  for i = 1, #self.boxItemList do
    self.boxItemList[i].reward_content:SetActive(true)
  end
  self.bg_content2:SetActive(true)
end

function UIDetectSlotBoxOpenView:CheckCanOpenBox(index)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < waitOpenAni then
    return
  end
  if curTime < waitSendTime then
    return
  end
  if self.isOpenBox then
    return
  end
  return true
end

function UIDetectSlotBoxOpenView:OnBoxClick(index)
  if self:CheckCanOpenBox(index) then
    self.isOpenBox = true
    self.openIndex = index
    self.ctrl:BoxClickHandler(index, self.panelType, self.userParam)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    waitSendTime = curTime + 5000
  end
end

function UIDetectSlotBoxOpenView:OnConfirmBtnClick()
  if self.isOpenBox then
    self.ctrl.CloseSelf()
  end
end

function UIDetectSlotBoxOpenView:OnPanelClick()
  self.ctrl:CloseSelf()
end

function UIDetectSlotBoxOpenView:FinishEvent(t)
  local rewardIndex = t.index
  self.panel_ani:Enable(false)
  self.confirm_btn:SetActive(true)
  self.rewards = t.reward
  self.pathRewards = t.pathReward
  self.showTip = t.showTip
  local firstReward = self.rewards and self.rewards[1]
  if firstReward then
    self.boxItemList[self.openIndex]:SetOpen(firstReward)
  end
end

UIDetectSlotBoxOpenView.OnCreate = OnCreate
UIDetectSlotBoxOpenView.OnDestroy = OnDestroy
UIDetectSlotBoxOpenView.OnEnable = OnEnable
UIDetectSlotBoxOpenView.OnDisable = OnDisable
UIDetectSlotBoxOpenView.ComponentDefine = ComponentDefine
UIDetectSlotBoxOpenView.ComponentDestroy = ComponentDestroy
UIDetectSlotBoxOpenView.DataDefine = DataDefine
UIDetectSlotBoxOpenView.DataDestroy = DataDestroy
return UIDetectSlotBoxOpenView
