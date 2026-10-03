local UIActSlotMachineRewardGetCell = BaseClass("UIActSlotMachineRewardGetCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local reward_icon_path = "rewardContent/rewardIcon/UICommonResItem"
local mulit_path = "rewardContent/mulit"
local num_txt_path = "rewardContent/numTxt"
local eff_ui_actslotmachinemain_x5_path = "rewardContent/mulit/Eff_ui_actslotmachinemain_x5"

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
  self.reward_icon = self:AddComponent(UICommonResItem, reward_icon_path)
  self.mulit = self:AddComponent(UIImage, mulit_path)
  self.mulitAni = self:AddComponent(UIAnimator, mulit_path)
  self.mulitEff = self.transform:Find(eff_ui_actslotmachinemain_x5_path).gameObject
  self.mulitEff:SetActive(false)
  self.num_txt = self:AddComponent(UITextMeshProUGUIEx, num_txt_path)
end

local function ComponentDestroy(self)
  self.reward_icon = nil
  self.mulit = nil
  self.num_txt = nil
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function ReInit(self, param, isMultiple)
  self.param = param
  self.isMultiple = isMultiple
  local num = self.param.count
  if self.isMultiple then
    num = math.floor(num / 5)
  end
  self.param.count = nil
  self.reward_icon:ReInit(self.param)
  self.reward_icon:SetActive(true)
  self.num_txt:SetText(num)
  self.mulitEff:SetActive(false)
  self.mulit:SetActive(false)
  if self.isMultiple then
    if self.timer ~= nil then
      self.timer:Stop()
      self.timer = nil
    end
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      self.mulit:SetActive(true)
      self.mulitAni:Play("Eff_ui_ActSlotMachineMain_5times")
      self.mulitEff:SetActive(true)
    end, 0.5)
  end
end

local function OnBtnClick(self)
end

UIActSlotMachineRewardGetCell.OnCreate = OnCreate
UIActSlotMachineRewardGetCell.OnDestroy = OnDestroy
UIActSlotMachineRewardGetCell.OnBtnClick = OnBtnClick
UIActSlotMachineRewardGetCell.OnEnable = OnEnable
UIActSlotMachineRewardGetCell.OnDisable = OnDisable
UIActSlotMachineRewardGetCell.ComponentDefine = ComponentDefine
UIActSlotMachineRewardGetCell.ComponentDestroy = ComponentDestroy
UIActSlotMachineRewardGetCell.DataDefine = DataDefine
UIActSlotMachineRewardGetCell.DataDestroy = DataDestroy
UIActSlotMachineRewardGetCell.ReInit = ReInit
return UIActSlotMachineRewardGetCell
