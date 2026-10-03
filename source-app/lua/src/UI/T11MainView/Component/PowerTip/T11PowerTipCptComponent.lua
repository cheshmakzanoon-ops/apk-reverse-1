local base = UIBaseContainer
local T11PowerTipCptComponent = BaseClass("T11PowerTipCptComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local T11PowerTipItemComponent = require("UI.T11MainView.Component.PowerTip.T11PowerTipItemComponent")

function T11PowerTipCptComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function T11PowerTipCptComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11PowerTipCptComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnSwitch = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnSwitch:SetOnClick(function()
    self:OnBtnSwitchClick()
  end)
  self.compStatsArrow = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.compItemRoot = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.compT11PowerTipItem = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.compAttributeListNode = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.btnStats = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnStats:SetOnClick(function()
    self:OnBtnStatsClick()
  end)
  self.compBG = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.canvasGroupBG = self.viewSkin:AddComponent(self, UICanvasGroup, 8)
  self.textStatsTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
end

function T11PowerTipCptComponent:ComponentDestroy()
  self.viewSkin = nil
  self.btnSwitch = nil
  self.compStatsArrow = nil
  self.compItemRoot = nil
  self.compT11PowerTipItem = nil
  self.compAttributeListNode = nil
  self.btnStats = nil
  self.compBG = nil
  self.canvasGroupBG = nil
  self.textStatsTitle = nil
end

function T11PowerTipCptComponent:DataDefine()
  self.compItemRoot:SetActive(false)
  self.compT11PowerTipItem.gameObject:GameObjectCreatePool()
  self.allPowerTipItemList = {}
  self.isExpand = true
  self.curAttrMode = T11PowerInfoGetType.ResultVal
end

function T11PowerTipCptComponent:DataDestroy()
  self.compT11PowerTipItem.gameObject:GameObjectRecycleAll()
  self.compAttributeListNode:RemoveComponents(T11PowerTipItemComponent)
  self.allPowerTipItemList = nil
  self.isExpand = nil
  if self.expandSeq then
    self.expandSeq:Kill()
    self.expandSeq = nil
  end
  self.curAttrMode = nil
end

function T11PowerTipCptComponent:OnAddListener()
  base.OnAddListener(self)
end

function T11PowerTipCptComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function T11PowerTipCptComponent:OnBtnSwitchClick()
  if self.curAttrMode == T11PowerInfoGetType.ResultVal then
    self.curAttrMode = T11PowerInfoGetType.BaseVal
  else
    self.curAttrMode = T11PowerInfoGetType.ResultVal
  end
  self:RefreshView()
end

function T11PowerTipCptComponent:OnBtnStatsClick()
  self:SetExpandState(not self.isExpand)
end

function T11PowerTipCptComponent:RefreshView(isFromUpgrade)
  local allPowerTipDataList = T11Util.GetT11PowerMap(self.curAttrMode)
  for index, v in ipairs(allPowerTipDataList) do
    local powerTipItem = self.allPowerTipItemList[index]
    if not powerTipItem then
      local itemObj = self.compT11PowerTipItem.gameObject:GameObjectSpawn(self.compAttributeListNode.transform)
      local name = tostring(NameCount)
      itemObj.name = name
      NameCount = NameCount + 1
      powerTipItem = self.compAttributeListNode:AddComponent(T11PowerTipItemComponent, name)
      self.allPowerTipItemList[index] = powerTipItem
    end
    local params = {}
    params.isDecimalShow = self.curAttrMode == T11PowerInfoGetType.BaseVal
    powerTipItem:RefreshView(v, params)
  end
  local titleKey = self.curAttrMode == T11PowerInfoGetType.ResultVal and "soldier_eleven_buff_hero_out" or "soldier_eleven_buff_soldier_out"
  self.textStatsTitle:SetLocalText(titleKey)
end

function T11PowerTipCptComponent:SetExpandState(isExpand)
  self.isExpand = isExpand
  local yScale = isExpand and 1 or 0
  if self.expandSeq then
    self.expandSeq:Kill()
    self.expandSeq = nil
  end
  self.expandSeq = CS.DG.Tweening.DOTween.Sequence()
  if isExpand then
    self.expandSeq:Join(self.canvasGroupBG:FadeIn(0.2))
  else
    self.expandSeq:Join(self.canvasGroupBG:FadeOut(0.2))
  end
  self.expandSeq:Join(self.compBG.transform:DOScale(Vector3.New(1, yScale, 1), 0.2):SetDelay(isExpand and 0 or 0.2))
  self.expandSeq:Join(self.compStatsArrow.transform:DOLocalRotate(Vector3.New(0, 0, isExpand and 180 or 0), 0.2))
  self.expandSeq:Play()
end

function T11PowerTipCptComponent:SetShowHideState(value)
  self:SetActive(value)
end

return T11PowerTipCptComponent
