local AllianceScienceAutoDonate = BaseClass("AllianceScienceAutoDonate", UIBaseContainer)
local base = UIBaseContainer
local autoBtn_path = "autoBtn"
local selectImg_path = "autoBtn/selectImg"
local tipText_path = "tipText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:OnAllianceAutoDinateMessage(DataCenter.AllianceBaseDataManager:GetAllianceBaseData().autoScienceResearch and 1 or 0)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.autoBtn = self:AddComponent(UIButton, autoBtn_path)
  self.autoBtn:SetOnClick(function()
    self.view.ctrl:ChangeAutoDonteState(not self.selectImg:GetActive())
  end)
  self.selectImg = self:AddComponent(UIImage, selectImg_path)
  self.tipText = self:AddComponent(UIText, tipText_path)
  self.tipText:SetLocalText("auto_science_1")
end

local function ComponentDestroy(self)
  self.autoBtn = nil
  self.selectImg = nil
  self.tipText = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceAutoDinate, self.OnAllianceAutoDinateMessage)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceAutoDinate, self.OnAllianceAutoDinateMessage)
  base.OnRemoveListener(self)
end

local function OnAllianceAutoDinateMessage(self, data)
  self.selectImg:SetActive(data == 1)
end

AllianceScienceAutoDonate.OnCreate = OnCreate
AllianceScienceAutoDonate.OnDestroy = OnDestroy
AllianceScienceAutoDonate.OnEnable = OnEnable
AllianceScienceAutoDonate.OnDisable = OnDisable
AllianceScienceAutoDonate.ComponentDefine = ComponentDefine
AllianceScienceAutoDonate.ComponentDestroy = ComponentDestroy
AllianceScienceAutoDonate.OnAddListener = OnAddListener
AllianceScienceAutoDonate.OnRemoveListener = OnRemoveListener
AllianceScienceAutoDonate.OnAllianceAutoDinateMessage = OnAllianceAutoDinateMessage
return AllianceScienceAutoDonate
