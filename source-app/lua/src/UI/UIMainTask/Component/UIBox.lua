local UIBox = BaseClass("UIBox", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local this_path = ""
local des_text_path = "ActiveNum"
local icon_path = "icon"
local ReceImg_path = "ReceImg"
local effectGo_path = "EffectGo"
local Param = DataClass("Param", ParamData)
local ParamData = {
  callBack,
  index,
  state,
  count
}

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
  self.des_text = self:AddComponent(UIText, des_text_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.icon = self:AddComponent(UIAnimator, icon_path)
  self.receimg = self:AddComponent(UIImage, ReceImg_path)
  self.btn = self:AddComponent(UIButton, this_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
  self.effectTab = self.transform:Find(effectGo_path).transform:GetChild(0).gameObject
end

local function ComponentDestroy(self)
  self.des_text = nil
  self.icon = nil
  self.gray = nil
  self.btn = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
  self.isSend = nil
end

local function ReInit(self, param)
  self.param = param
  if param.count ~= nil then
    self.des_text:SetText(param.count)
  end
  self:RefreshState(param.state)
  self.isSend = false
end

local function RefreshState(self, state)
  self.param.state = state
  if state == TaskState.NoComplete then
    self.icon:SetActive(true)
    self.receimg:SetActive(false)
    self.effectTab:SetActive(false)
    self.icon:Play("NoComplete", 0, 0)
  elseif state == TaskState.CanReceive then
    self.icon:SetActive(true)
    self.receimg:SetActive(false)
    self.effectTab:SetActive(true)
    self.icon:Play("CanReceive", 0, 0)
  elseif state == TaskState.Received then
    self.icon:SetActive(false)
    self.receimg:SetActive(true)
    self.effectTab:SetActive(false)
    self.icon:Enable(false)
  end
end

local function OnBtnClick(self)
  if self.param.state == TaskState.CanReceive then
    if self.isSend then
      return
    end
    self.isSend = true
    DataCenter.DailyTaskManager:SetCurReward(self.param.index)
    SFSNetwork.SendMessage(MsgDefines.DailyQuestReward, self.param.index)
  elseif self.param.callBack ~= nil then
    self.param.callBack(self.param.index, self.transform.position, self.btn.rectTransform.rect.width)
  end
end

UIBox.OnCreate = OnCreate
UIBox.OnDestroy = OnDestroy
UIBox.Param = Param
UIBox.OnEnable = OnEnable
UIBox.OnDisable = OnDisable
UIBox.ComponentDefine = ComponentDefine
UIBox.ComponentDestroy = ComponentDestroy
UIBox.DataDefine = DataDefine
UIBox.DataDestroy = DataDestroy
UIBox.ReInit = ReInit
UIBox.RefreshState = RefreshState
UIBox.OnBtnClick = OnBtnClick
return UIBox
