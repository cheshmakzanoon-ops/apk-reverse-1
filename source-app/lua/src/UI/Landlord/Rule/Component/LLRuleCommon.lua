local base = UIAsyncContainer
local LLRuleCommon = BaseClass("LLRuleCommon", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.LandlordMgr
local CLS = "UI.Landlord.Rule.Component.LLRuleCommonItem"
local PREFAB = "Assets/Main/Prefabs/UI/Landlord/Rule/LLRuleCommonItem.prefab"

function LLRuleCommon:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLRuleCommon:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLRuleCommon:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
end

function LLRuleCommon:ComponentDestroy()
  self.viewSkin = nil
  self.compContent = nil
end

function LLRuleCommon:DataDefine()
  self.items = {}
end

function LLRuleCommon:DataDestroy()
  self.items = nil
  self.guideList = nil
end

function LLRuleCommon:OnAddListener()
  base.OnAddListener(self)
end

function LLRuleCommon:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLRuleCommon:SetInfo(idx, subIdx)
  self.idx = idx
  self.subIdx = subIdx
  self.guideList = ActMgr:GetGuide(self.idx)
  self:RefreshView()
end

function LLRuleCommon:UpdateData()
  if self.guideList == nil then
    return
  end
  for i, guide in ipairs(self.guideList) do
    local item = self.items[i]
    if item == nil then
      item = self:LoadComponentAsync(CLS, PREFAB, self.compContent)
      self.items[i] = item
    end
    item:SetActive(true)
    item:SetData(guide)
  end
end

return LLRuleCommon
