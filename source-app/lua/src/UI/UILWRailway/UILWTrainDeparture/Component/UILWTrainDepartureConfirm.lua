local base = UIBaseContainer
local UILWTrainDepartureConfirm = BaseClass("UILWTrainDepartureConfirm", base)
local closePanel_path = ""
local closeBtn_path = "ConfirmBubble/CloseBtn"
local noBtn_path = "ConfirmBubble/NoBtn"
local yesBtn_path = "ConfirmBubble/YesBtn"
local noBtnText_path = "ConfirmBubble/NoBtn/NoBtnText"
local yesBtnText_path = "ConfirmBubble/YesBtn/YesBtnText"
local tipText_path = "ConfirmBubble/TipTxt"
local checkBoxText_path = "ConfirmBubble/backToggle/Text"
local checkBox_path = "ConfirmBubble/backToggle"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.closePanel = self:AddComponent(UIButton, closePanel_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.noBtn = self:AddComponent(UIButton, noBtn_path)
  self.yesBtn = self:AddComponent(UIButton, yesBtn_path)
  self.noBtnText = self:AddComponent(UIText, noBtnText_path)
  self.yesBtnText = self:AddComponent(UIText, yesBtnText_path)
  self.tipText = self:AddComponent(UIText, tipText_path)
  self.checkBoxText = self:AddComponent(UIText, checkBoxText_path)
  self.checkBox = self:AddComponent(UIToggle, checkBox_path)
  self.closePanel:SetOnClick(BindCallback(self.OnClickNo, self))
  self.closeBtn:SetOnClick(BindCallback(self.OnClickNo, self))
  self.noBtn:SetOnClick(BindCallback(self.OnClickNo, self))
  self.yesBtn:SetOnClick(BindCallback(self.OnClickYes, self))
  self.tipText:SetLocalText("truck_tips10001")
  self.yesBtnText:SetLocalText("truck_tips10002")
  self.noBtnText:SetLocalText("truck_tips10003")
  self.checkBoxText:SetLocalText(120059)
  self.checkBox:SetIsOn(false)
  self.checkBox:SetOnValueChanged(function(isOn)
    if self.todayType then
      DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(self.todayType, not isOn)
    end
  end)
end

local function ComponentDestroy(self)
  self.closePanel = nil
  self.closeBtn = nil
  self.noBtn = nil
  self.yesBtn = nil
  self.noBtnText = nil
  self.yesBtnText = nil
  self.tipText = nil
  self.checkBoxText = nil
  self.checkBox = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.todayType = nil
  self.action1 = nil
  self.action2 = nil
end

local function ShowConfirm(self, todayType, tipTextId, showCheckBox, action1, action2)
  if todayType == nil or DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(todayType) then
    self.todayType = todayType
    self.action1 = action1
    self.action2 = action2
    self.tipText:SetLocalText(tipTextId)
    self.checkBox:SetActive(showCheckBox)
    self:SetActive(true)
  else
    action1()
  end
end

local function OnClickNo(self)
  if self.action2 then
    self.action2()
  end
  self:SetActive(false)
end

local function OnClickYes(self)
  if self.action1 then
    self.action1()
  end
  self:SetActive(false)
end

UILWTrainDepartureConfirm.OnCreate = OnCreate
UILWTrainDepartureConfirm.OnDestroy = OnDestroy
UILWTrainDepartureConfirm.OnEnable = OnEnable
UILWTrainDepartureConfirm.OnDisable = OnDisable
UILWTrainDepartureConfirm.ComponentDefine = ComponentDefine
UILWTrainDepartureConfirm.ComponentDestroy = ComponentDestroy
UILWTrainDepartureConfirm.DataDefine = DataDefine
UILWTrainDepartureConfirm.DataDestroy = DataDestroy
UILWTrainDepartureConfirm.ShowConfirm = ShowConfirm
UILWTrainDepartureConfirm.OnClickNo = OnClickNo
UILWTrainDepartureConfirm.OnClickYes = OnClickYes
return UILWTrainDepartureConfirm
