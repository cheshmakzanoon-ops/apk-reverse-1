local UIExplorerTreasureIntroduceView = BaseClass("UIExplorerTreasureIntroduceView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

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
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.text2 = self:AddComponent(UITextMeshProUGUIEx, "step2/main/Text2")
  self.text1 = self:AddComponent(UITextMeshProUGUIEx, "step1/main/Text1")
  self.text3 = self:AddComponent(UITextMeshProUGUIEx, "step3/main/Text3")
  self.textIntroduce = self:AddComponent(UITextMeshProUGUIEx, "textIntroduce")
  self.textClose = self:AddComponent(UITextMeshProUGUIEx, "textClose")
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "textTitle")
  self.text1:SetLocalText("explorer_treasure_des_01")
  self.text2:SetLocalText("explorer_treasure_des_02")
  self.text3:SetLocalText("explorer_treasure_des_03")
  self.textIntroduce:SetLocalText("explorer_treasure_des_04")
  self.textClose:SetLocalText("explorer_treasure_des_05")
  self.textTitle:SetLocalText("explorer_treasure_activity_name_01")
end

local function ComponentDestroy(self)
  self.btnPanel = nil
  self.text2 = nil
  self.text1 = nil
  self.text3 = nil
  self.textIntroduce = nil
  self.textClose = nil
  self.textTitle = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnBtnPanelClick(self)
  self.ctrl:CloseSelf()
end

UIExplorerTreasureIntroduceView.OnCreate = OnCreate
UIExplorerTreasureIntroduceView.OnDestroy = OnDestroy
UIExplorerTreasureIntroduceView.OnEnable = OnEnable
UIExplorerTreasureIntroduceView.OnDisable = OnDisable
UIExplorerTreasureIntroduceView.ComponentDefine = ComponentDefine
UIExplorerTreasureIntroduceView.ComponentDestroy = ComponentDestroy
UIExplorerTreasureIntroduceView.DataDefine = DataDefine
UIExplorerTreasureIntroduceView.DataDestroy = DataDestroy
UIExplorerTreasureIntroduceView.OnAddListener = OnAddListener
UIExplorerTreasureIntroduceView.OnRemoveListener = OnRemoveListener
UIExplorerTreasureIntroduceView.OnBtnPanelClick = OnBtnPanelClick
return UIExplorerTreasureIntroduceView
