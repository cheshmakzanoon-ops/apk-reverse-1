local UIActSlotMachineBoxView = BaseClass("UIActSlotMachineBoxView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UIActSlotMachineBoxItem = require("UI.UIActSlotMachine.UIActSlotMachineBox.Component.UIActSlotMachineBoxItem")
local panel_path = "Panel"
local bg_content1_path = "bgContent1"
local bg_content2_path = "bgContent2"
local have_num_path = "bgContent2/haveNum"
local confirm_btn_path = "bgContent2/confirmBtn"
local btn_txt_path = "bgContent2/confirmBtn/btnTxt"
local box_item1_path = "infoContent/boxItem1"
local box_item2_path = "infoContent/boxItem2"
local box_item3_path = "infoContent/boxItem3"
local box_title_txt_path = "bgContent2/bg_1/bg_3/BoxTitleTxt"
local confirm_btn_img_path = "bgContent2/confirmBtn/confirmBtnImg"
local maxBox = 3
local waitOpenAni = 0
local waitSendTime = 0

local function OnCreate(self)
  base.OnCreate(self)
  self.viewOpenTime = nil
  self.activityId, self.boxUuid, self.isBox = self:GetUserData()
  self.activityId = tonumber(self.activityId)
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.activityDetailData = DataCenter.ActSlotMachineDataManager:GetActData(self.activityId)
  self:ComponentDefine()
  waitSendTime = 0
  self:RefreshView()
  if not self.isBox then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    self.panel_ani:Enable(true)
    local _, aniTime = self.panel_ani:PlayAnimationReturnTime("movein")
    waitOpenAni = curTime + aniTime * 1000
    for i = 1, #self.boxItemList do
      self.boxItemList[i].reward_content:SetActive(true)
    end
    self.bg_content2:SetActive(true)
  end
  PostEventLog.Track(PostEventLog.Defines.ActSlotMachineBoxOpen, {})
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.bg_content1 = self:AddComponent(UIBaseContainer, bg_content1_path)
  self.bg_content2 = self:AddComponent(UIBaseContainer, bg_content2_path)
  self.have_num = self:AddComponent(UITextMeshProUGUIEx, have_num_path)
  self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
  self.btn_txt = self:AddComponent(UITextMeshProUGUIEx, btn_txt_path)
  self.box_item1 = self:AddComponent(UIActSlotMachineBoxItem, box_item1_path)
  self.box_item2 = self:AddComponent(UIActSlotMachineBoxItem, box_item2_path)
  self.box_item3 = self:AddComponent(UIActSlotMachineBoxItem, box_item3_path)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self:OnPanelClick()
  end)
  self.boxItemList = {
    self.box_item1,
    self.box_item2,
    self.box_item3
  }
  self.box_item1_btn = self:AddComponent(UIButton, box_item1_path)
  self.box_item2_btn = self:AddComponent(UIButton, box_item2_path)
  self.box_item3_btn = self:AddComponent(UIButton, box_item3_path)
  self.box_item1_btn:SetOnClick(function()
    if self.boxData.boxRewards[1].state == 1 then
      self.box_item1.reward_icon.btn:Click()
    elseif self:CheckCanOpenBox(1, true) then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      waitSendTime = curTime + 5000
      self.box_item1:PlayOpenEffect(function()
        waitSendTime = 0
        self:OnBoxClick(1)
      end)
    end
  end)
  self.box_item2_btn:SetOnClick(function()
    if self.boxData.boxRewards[2].state == 1 then
      self.box_item2.reward_icon.btn:Click()
    elseif self:CheckCanOpenBox(2, true) then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      waitSendTime = curTime + 5000
      self.box_item2:PlayOpenEffect(function()
        waitSendTime = 0
        self:OnBoxClick(2)
      end)
    end
  end)
  self.box_item3_btn:SetOnClick(function()
    if self.boxData.boxRewards[3].state == 1 then
      self.box_item3.reward_icon.btn:Click()
    elseif self:CheckCanOpenBox(3, true) then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      waitSendTime = curTime + 5000
      self.box_item3:PlayOpenEffect(function()
        waitSendTime = 0
        self:OnBoxClick(3)
      end)
    end
  end)
  self.confirm_btn:SetOnClick(function()
    self:OnConfirmBtnClick()
  end)
  self.confirm_btn_img = self:AddComponent(UIImage, confirm_btn_img_path)
  self.box_title_txt = self:AddComponent(UIText, box_title_txt_path)
  self.panel_ani = self:AddComponent(UIAnimator, "")
end

local function ComponentDestroy(self)
  self.bg_content1 = nil
  self.bg_content2 = nil
  self.have_num = nil
  self.confirm_btn = nil
  self.btn_txt = nil
  self.box_item1 = nil
  self.box_item2 = nil
  self.box_item3 = nil
  self.confirm_btn_img = nil
  self.box_title_txt = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActSlotBoxUpdate, self.OnGetUpdateMsg)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActSlotBoxUpdate, self.OnGetUpdateMsg)
end

local function RefreshView(self)
  self.boxData = nil
  for i = 1, #self.activityDetailData.eventBox do
    if self.activityDetailData.eventBox[i].uuid == self.boxUuid then
      self.boxData = self.activityDetailData.eventBox[i]
      break
    end
  end
  if self.isBox then
    self.bg_content1:SetActive(false)
    self.bg_content2:SetActive(true)
  else
    self.bg_content1:SetActive(true)
    self.bg_content2:SetActive(false)
  end
  local canOpenNum = self.boxData.totalTimes
  local curOpenTime = 0
  for i = 1, #self.boxData.boxRewards do
    if self.boxData.boxRewards[i].state == 1 then
      curOpenTime = curOpenTime + 1
    end
  end
  self.have_num:SetLocalText("activity_slots_tips018", canOpenNum, canOpenNum - curOpenTime)
  if canOpenNum > curOpenTime then
    if canOpenNum - curOpenTime == maxBox then
      UIGray.SetGray(self.confirm_btn_img.transform, false, true)
      self.btn_txt:SetLocalText("activity_slots_tips019")
    else
      UIGray.SetGray(self.confirm_btn_img.transform, true, true)
      self.btn_txt:SetLocalText("393108")
    end
  else
    UIGray.SetGray(self.confirm_btn_img.transform, false, true)
    self.btn_txt:SetLocalText("393108")
  end
  local infoTemp = self.activityDetailData.infoTemp
  local groupId = infoTemp.eventid
  local boxTemp = DataCenter.ActSlotMachineDataManager.boxTempDict[groupId][self.boxData.id]
  self.box_title_txt:SetLocalText(boxTemp.name)
  local isOpenFin = canOpenNum <= curOpenTime
  local fakeRIndex = {}
  local fakeRIndexDict = {}
  if isOpenFin then
    for i = 1, #self.boxItemList do
      fakeRIndex[i] = i
    end
    for i = 1, #self.boxItemList do
      local boxIndexData = self.boxData.boxRewards[i]
      if boxIndexData.state == 1 then
        local rIndex = boxIndexData.rewardIndex + 1
        table.removebyvalue(fakeRIndex, rIndex)
      end
    end
    local listSize = #fakeRIndex
    if 0 < listSize then
      for i = 1, listSize do
        local randomNum = math.random(i, listSize)
        if i < randomNum then
          fakeRIndex[i], fakeRIndex[randomNum] = fakeRIndex[randomNum], fakeRIndex[i]
        end
      end
    end
    local addFakeIndex = 1
    for i = 1, #self.boxItemList do
      local boxIndexData = self.boxData.boxRewards[i]
      if boxIndexData.state ~= 1 then
        fakeRIndexDict[i] = fakeRIndex[addFakeIndex]
        addFakeIndex = addFakeIndex + 1
      end
    end
  end
  for i = 1, #self.boxItemList do
    self.boxItemList[i]:SetData(self.activityDetailData, self.boxData, i, isOpenFin, fakeRIndexDict[i])
  end
  if self.isBox then
    self.panel_ani:Enable(false)
  end
end

local function CheckCanOpenBox(self, index, showTips)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < waitOpenAni then
    return
  end
  if curTime < waitSendTime then
    return
  end
  local canOpenNum = self.boxData.totalTimes
  local curOpenTime = 0
  for i = 1, #self.boxData.boxRewards do
    if self.boxData.boxRewards[i].state == 1 then
      curOpenTime = curOpenTime + 1
    end
  end
  if canOpenNum > curOpenTime then
    if self.boxData.boxRewards[index].state == 0 then
      return true
    end
  elseif showTips then
    UIUtil.ShowTipsId("110266")
  end
  return false
end

local function OnBoxClick(self, index)
  if self:CheckCanOpenBox(index) then
    local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    if activityInfo == nil or not activityInfo:IsValid() then
      UIUtil.ShowTipsId(2000409)
      self.ctrl:CloseSelf()
      return
    end
    if self.viewOpenTime == nil then
      self.viewOpenTime = UITimeManager:GetInstance():GetServerSeconds()
    end
    SFSNetwork.SendMessage(MsgDefines.SlotsOpenBox, tonumber(self.activityDetailData.activityId), self.boxData.uuid, false, index - 1, self.viewOpenTime)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    waitSendTime = curTime + 5000
  end
end

local function OnGetUpdateMsg(self)
  self.isBox = true
  waitSendTime = 0
  self:RefreshView()
end

local function OnConfirmBtnClick(self)
  local canOpenNum = self.boxData.totalTimes
  local curOpenTime = 0
  for i = 1, #self.boxData.boxRewards do
    if self.boxData.boxRewards[i].state == 1 then
      curOpenTime = curOpenTime + 1
    end
  end
  if canOpenNum > curOpenTime then
    if canOpenNum == maxBox then
      if self.viewOpenTime == nil then
        self.viewOpenTime = UITimeManager:GetInstance():GetServerSeconds()
      end
      SFSNetwork.SendMessage(MsgDefines.SlotsOpenBox, tonumber(self.activityDetailData.activityId), self.boxData.uuid, true, 0, self.viewOpenTime)
      PostEventLog.Track(PostEventLog.Defines.ActSlotMachineBoxAllGetBtnClick, {})
    end
  else
    self.ctrl:CloseSelf()
    self.activityDetailData:RemoveBoxUuid(self.boxData.uuid)
    EventManager:GetInstance():Broadcast(EventId.ActSlotBoxRemove)
  end
end

local function OnPanelClick(self)
  local canOpenNum = self.boxData.totalTimes
  local curOpenTime = 0
  for i = 1, #self.boxData.boxRewards do
    if self.boxData.boxRewards[i].state == 1 then
      curOpenTime = curOpenTime + 1
    end
  end
  if canOpenNum > curOpenTime then
  else
    self.ctrl:CloseSelf()
    self.activityDetailData:RemoveBoxUuid(self.boxData.uuid)
    EventManager:GetInstance():Broadcast(EventId.ActSlotBoxRemove)
  end
end

UIActSlotMachineBoxView.OnCreate = OnCreate
UIActSlotMachineBoxView.OnDestroy = OnDestroy
UIActSlotMachineBoxView.ComponentDefine = ComponentDefine
UIActSlotMachineBoxView.ComponentDestroy = ComponentDestroy
UIActSlotMachineBoxView.RefreshView = RefreshView
UIActSlotMachineBoxView.OnAddListener = OnAddListener
UIActSlotMachineBoxView.OnRemoveListener = OnRemoveListener
UIActSlotMachineBoxView.OnBoxClick = OnBoxClick
UIActSlotMachineBoxView.OnGetUpdateMsg = OnGetUpdateMsg
UIActSlotMachineBoxView.OnConfirmBtnClick = OnConfirmBtnClick
UIActSlotMachineBoxView.OnPanelClick = OnPanelClick
UIActSlotMachineBoxView.CheckCanOpenBox = CheckCanOpenBox
return UIActSlotMachineBoxView
