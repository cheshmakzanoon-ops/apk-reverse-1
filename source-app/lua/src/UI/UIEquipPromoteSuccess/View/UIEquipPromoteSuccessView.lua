local UIBuildUpgradeSuccessView = BaseClass("UIBuildUpgradeSuccessView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIEquipPromoteSuccessLine = require("UI.UIEquipPromoteSuccess.Component.UIEquipPromoteSuccessLine")
local BaseUIEquipItem = require("UI.UILWHero.UIHeroEquipListPanel.Component.BaseUIEquipItem")
local title_path = "UIGarageRefitUpgrade/UICommonRewardPopUp/Panel/ImgTitleBg/TextTitle"
local next_path = "UIGarageRefitUpgrade/UICommonRewardPopUp/Panel"
local root_path = "UIGarageRefitUpgrade/Root"
local content_path = "UIGarageRefitUpgrade/Root/Content"
local equipItem_path = "UIGarageRefitUpgrade/Root/EquipItem"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.title_text = self:AddComponent(UIText, title_path)
  self.next_btn = self:AddComponent(UIButton, next_path)
  self.next_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.root_anim = self:AddComponent(UIAnimator, root_path)
  self.content_go = self:AddComponent(UIBaseContainer, content_path)
  self.equipItem = self:AddComponent(BaseUIEquipItem, equipItem_path)
end

local function ComponentDestroy(self)
  self:ClearItems()
  self.title_text = nil
  self.next_btn = nil
  self.root_anim = nil
  self.item_anim = nil
  self.content_go = nil
  self.equipItem = nil
end

local function DataDefine(self)
  self.reqs = {}
  self.active = false
  self.onClose = nil
  self.rewardReqs = {}
end

local function DataDestroy(self)
  self.reqs = nil
  self.active = nil
  self.onClose = nil
  self.rewardReqs = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  self.active = false
  base.OnDisable(self)
end

local function ReInit(self)
  self.equipUuid, self.showData = self:GetUserData()
  self.equipData = DataCenter.EquipDataManager:GetEquipByUuid(self.equipUuid)
  self:Show()
end

local function Show(self)
  if self.root_anim ~= nil then
    self.root_anim:SampleAnimationAtTime("V_ui_bujianshengji_01_anim", 0, 0)
    self.root_anim:Play("V_ui_bujianshengji_01_anim", 0, 0)
  end
  if self.equipData then
    self.equipItem:SetActive(true)
    self.equipItem:SetData(self.equipData, nil, false, false, true)
  else
    self.equipItem:SetActive(false)
  end
  if self.showData ~= nil then
    for i, data in pairs(self.showData) do
      local index = i
      local req = Resource:InstantiateAsync(UIAssets.UIEquipPromoteSuccessCell)
      req:completed("+", function()
        if req.isError then
          return
        end
        if not self.gameObject or not self.active then
          req:Destroy()
          return
        end
        CommonUtil.CallAutoArabicMirrorManually(req)
        local go = req.gameObject
        go:SetActive(true)
        go.name = "Line_" .. tostring(i)
        local tf = go.transform
        tf:SetParent(self.content_go.transform)
        tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local item = self.content_go:AddComponent(UIEquipPromoteSuccessLine, go)
        item:SetData(data.id, data.prevValue, data.value, data.isAddition)
        item:DelayPlayShowAnim(index * 0.05)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content_go.transform)
        self.reqs[i] = req
      end)
    end
  end
end

local function ClearItems(self)
  if self.content_go then
    self.content_go:RemoveComponents(UIEquipPromoteSuccessLine)
  end
  if self.reqs then
    for _, req in pairs(self.reqs) do
      req:Destroy()
    end
  end
end

UIBuildUpgradeSuccessView.OnCreate = OnCreate
UIBuildUpgradeSuccessView.OnDestroy = OnDestroy
UIBuildUpgradeSuccessView.ComponentDefine = ComponentDefine
UIBuildUpgradeSuccessView.ComponentDestroy = ComponentDestroy
UIBuildUpgradeSuccessView.DataDefine = DataDefine
UIBuildUpgradeSuccessView.DataDestroy = DataDestroy
UIBuildUpgradeSuccessView.OnEnable = OnEnable
UIBuildUpgradeSuccessView.OnDisable = OnDisable
UIBuildUpgradeSuccessView.ReInit = ReInit
UIBuildUpgradeSuccessView.ClearItems = ClearItems
UIBuildUpgradeSuccessView.Show = Show
return UIBuildUpgradeSuccessView
