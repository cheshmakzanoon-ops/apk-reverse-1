local UITCCardDetailPanelView = BaseClass("UITCCardDetailPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local DetailPanelType = {Core = 1, Normal = 2}
local DetailPanelConfig = {
  [DetailPanelType.Normal] = {
    prefabPath = "Assets/Main/Prefabs/UI/UILWTC/Component/UITCNormalCardDetail.prefab",
    scriptPath = "UI.LWUITC.UITCCardDetailPanel.Component.UITCNormalCardDetail"
  },
  [DetailPanelType.Core] = {
    prefabPath = "Assets/Main/Prefabs/UI/UILWTC/Component/UITCCoreCardDetail.prefab",
    scriptPath = "UI.LWUITC.UITCCardDetailPanel.Component.UITCCoreCardDetail"
  }
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local cardData, isVisitMode = self:GetUserData()
  self.isVisitMode = isVisitMode
  self:OnOpenWindow(cardData)
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
  self.mask_btn = self:AddComponent(UIButton, "panel")
  self.mask_btn:SetOnClick(function()
    self:OnMask_btnClick()
  end)
  self.container = self:AddComponent(UIBaseContainer, "container")
  self.detailPanelReq = nil
  self.detailPanelComp = nil
end

local function ComponentDestroy(self)
  self.mask_btn = nil
  self.container = nil
end

local function DataDefine(self)
  self.curDetailPanelType = nil
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.TCCardEquipSuccess, self.OnTCCardEquipSuccess)
  self:AddUIListener(EventId.TCCardUnEquipSuccess, self.OnTCCardUnEquipSuccess)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.TCCardEquipSuccess, self.OnTCCardEquipSuccess)
  self:RemoveUIListener(EventId.TCCardUnEquipSuccess, self.OnTCCardUnEquipSuccess)
  base.OnRemoveListener(self)
end

local function OnMask_btnClick(self)
  self.ctrl:CloseSelf()
end

function UITCCardDetailPanelView:RefreshView(cardData)
  self.cardData = cardData
  if not self.cardData then
    Logger.LogError("cardData is nil")
    return
  end
  local isCoreCard = self.cardData:IsCoreCard()
  local detailPanelType = isCoreCard and DetailPanelType.Core or DetailPanelType.Normal
  if self.detailPanelReq and (self.curDetailPanelType == nil or self.curDetailPanelType ~= detailPanelType) then
    self.detailPanelReq:Destroy()
    self.detailPanelReq = nil
    if self.detailPanelComp then
      self:RemoveComponent(self.detailPanelComp:GetName(), self.detailPanelComp.__cname)
      self.detailPanelComp = nil
    end
  end
  if not self.detailPanelReq then
    self.detailPanelReq = self.container:GameObjectInstantiateAsync(DetailPanelConfig[detailPanelType].prefabPath, function(req)
      if req.isError then
        return
      end
      local go = req.gameObject
      go.name = string.format("detailPanel_%s", detailPanelType)
      local transform = go.transform
      transform:SetParent(self.container.transform, false)
      transform:Set_localScale(1, 1, 1)
      transform:Set_localPosition(0, 0, 0)
      transform:Set_pivot(0.5, 0.5)
      local cls = require(DetailPanelConfig[detailPanelType].scriptPath)
      self.detailPanelComp = self.container:AddComponent(cls, go)
      self.detailPanelComp:SetVisitModeState(self.isVisitMode)
      self.detailPanelComp:UpdateView(self.cardData)
    end)
  elseif self.detailPanelComp then
    self.detailPanelComp:SetVisitModeState(self.isVisitMode)
    self.detailPanelComp:UpdateView(self.cardData)
  end
  self.curDetailPanelType = detailPanelType
end

function UITCCardDetailPanelView:ReopenWithoutCreate()
  base.ReopenWithoutCreate(self)
  local cardData, isVisitMode = self:GetUserData()
  self.isVisitMode = isVisitMode
  self:OnOpenWindow(cardData)
end

function UITCCardDetailPanelView:OnTCCardEquipSuccess()
  self.ctrl:CloseSelf()
end

function UITCCardDetailPanelView:OnTCCardUnEquipSuccess()
  self.ctrl:CloseSelf()
end

function UITCCardDetailPanelView:OnOpenWindow(cardData)
  if cardData then
    self:RefreshView(cardData)
  else
    self.ctrl:CloseSelf()
  end
end

UITCCardDetailPanelView.OnCreate = OnCreate
UITCCardDetailPanelView.OnDestroy = OnDestroy
UITCCardDetailPanelView.OnEnable = OnEnable
UITCCardDetailPanelView.OnDisable = OnDisable
UITCCardDetailPanelView.ComponentDefine = ComponentDefine
UITCCardDetailPanelView.ComponentDestroy = ComponentDestroy
UITCCardDetailPanelView.DataDefine = DataDefine
UITCCardDetailPanelView.DataDestroy = DataDestroy
UITCCardDetailPanelView.OnAddListener = OnAddListener
UITCCardDetailPanelView.OnRemoveListener = OnRemoveListener
UITCCardDetailPanelView.OnMask_btnClick = OnMask_btnClick
return UITCCardDetailPanelView
