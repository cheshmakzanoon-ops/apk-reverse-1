local UITCCardInfoPanelView = BaseClass("UITCCardInfoPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local DetailPanelType = {Core = 1, Normal = 2}
local DetailPanelConfig = {
  [DetailPanelType.Normal] = {
    prefabPath = "Assets/Main/Prefabs/UI/UILWTC/CardInfo/UITCNormalCardInfo.prefab",
    scriptPath = "UI.LWUITC.UITCCardInfoPanel.Component.NormalCardInfo"
  },
  [DetailPanelType.Core] = {
    prefabPath = "Assets/Main/Prefabs/UI/UILWTC/CardInfo/UITCCoreCardInfo.prefab",
    scriptPath = "UI.LWUITC.UITCCardInfoPanel.Component.CoreCardInfo"
  }
}

function UITCCardInfoPanelView:CreateFakeCardData(cardId, level, star, randomAttr)
  local random
  if randomAttr then
    random = {}
    for k, v in pairs(randomAttr) do
      local id = v.id
      id = id or v.effectId
      if id then
        local val = v.val
        val = val or v.value
        if val then
          table.insert(random, {effectId = id, val = val})
        end
      end
    end
  end
  local cardData = TacticalCardUtil.CreateFakeCardData(cardId, level, star, random)
  return cardData
end

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local windowParam = self:GetUserData()
  self:OnOpenWindow(windowParam)
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
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnMask_btnClick(self)
  self.ctrl:CloseSelf()
end

function UITCCardInfoPanelView:RefreshView(cardData)
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
      self.detailPanelComp:UpdateView(self.cardData)
    end)
  elseif self.detailPanelComp then
    self.detailPanelComp:UpdateView(self.cardData)
  end
  self.curDetailPanelType = detailPanelType
end

function UITCCardInfoPanelView:ReopenWithoutCreate()
  base.ReopenWithoutCreate(self)
  local windowParam = self:GetUserData()
  self:OnOpenWindow(windowParam)
end

function UITCCardInfoPanelView:OnOpenWindow(windowParam)
  if windowParam then
    local cardData = self:CreateFakeCardData(windowParam.id, windowParam.level, windowParam.star, windowParam.randomAttr)
    self:RefreshView(cardData)
  else
    self.ctrl:CloseSelf()
  end
end

UITCCardInfoPanelView.OnCreate = OnCreate
UITCCardInfoPanelView.OnDestroy = OnDestroy
UITCCardInfoPanelView.OnEnable = OnEnable
UITCCardInfoPanelView.OnDisable = OnDisable
UITCCardInfoPanelView.ComponentDefine = ComponentDefine
UITCCardInfoPanelView.ComponentDestroy = ComponentDestroy
UITCCardInfoPanelView.DataDefine = DataDefine
UITCCardInfoPanelView.DataDestroy = DataDestroy
UITCCardInfoPanelView.OnAddListener = OnAddListener
UITCCardInfoPanelView.OnRemoveListener = OnRemoveListener
UITCCardInfoPanelView.OnMask_btnClick = OnMask_btnClick
return UITCCardInfoPanelView
