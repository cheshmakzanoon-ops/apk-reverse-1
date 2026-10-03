local base = UIAsyncContainer
local LLRuleBattle = BaseClass("LLRuleBattle", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.LandlordMgr
local PREFAB_PATH = "Assets/Main/Prefabs/UI/Landlord/Rule/%s.prefab"
local CLS_PATH = "UI.Landlord.Rule.Component.%s"
local T_INFOS = {
  "LLRuleBattleBomb",
  "LLRuleBattleRate"
}
local CLS = "UI.Landlord.Rule.Component.LLRuleCommonItem"
local PREFAB = "Assets/Main/Prefabs/UI/Landlord/Rule/LLRuleCommonItem.prefab"

function LLRuleBattle:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLRuleBattle:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLRuleBattle:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.toggleT3 = self.viewSkin:AddComponent(self, UIToggle, 1)
  self.toggleT2 = self.viewSkin:AddComponent(self, UIToggle, 2)
  self.toggleT1 = self.viewSkin:AddComponent(self, UIToggle, 3)
  self.compCenter = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.scrollRect = self.viewSkin:AddComponent(self, UIScrollRect, 6)
  self.toggleTList = {
    self.toggleT1,
    self.toggleT2,
    self.toggleT3
  }
end

function LLRuleBattle:ComponentDestroy()
  self.viewSkin = nil
  self.toggleT3 = nil
  self.toggleT2 = nil
  self.toggleT1 = nil
  self.compCenter = nil
  self.compContent = nil
  self.scrollRect = nil
  self.toggleTList = nil
end

function LLRuleBattle:DataDefine()
  self.items = {}
  self.contents = {}
  self.contents[3] = self.scrollRect
  self.scrollRect:SetActive(false)
  for i, tog in ipairs(self.toggleTList) do
    tog:SetOnValueChanged(function(value)
      if value then
        DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
        self:OnToggleClick(i)
      end
    end)
  end
end

function LLRuleBattle:DataDestroy()
  self.contents = nil
  self.guideList = nil
  self.items = nil
end

function LLRuleBattle:OnAddListener()
  base.OnAddListener(self)
end

function LLRuleBattle:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLRuleBattle:SetInfo(idx, subIdx)
  self.idx = idx
  self.subIdx = subIdx
  local list = ActMgr:GetGuide(self.idx)
  self.guideList = {}
  for _, v in ipairs(list) do
    if v.subtype == 3 then
      table.insert(self.guideList, v)
    end
  end
  self:RefreshView()
end

function LLRuleBattle:UpdateData()
  local tab = self.subIdx or 1
  self.toggleTList[tab]:SetIsOn(true)
  self:OnToggleClick(tab, true)
  self.subIdx = nil
end

function LLRuleBattle:OnToggleClick(idx, bForce)
  if not bForce and self.tabIdx == idx then
    return
  end
  local lastContent = self.contents[self.tabIdx]
  if lastContent ~= nil then
    lastContent:SetActive(false)
  end
  self.tabIdx = idx
  local content = self.contents[self.tabIdx]
  if content ~= nil then
    content:SetActive(true)
    if self.tabIdx == 3 then
      self:RefreshGuideList()
    end
    return
  end
  local name = T_INFOS[idx]
  local cls = string.format(CLS_PATH, name)
  local prefab = string.format(PREFAB_PATH, name)
  self.contents[idx] = self:LoadComponentAsync(cls, prefab, self.compCenter, function(_, go)
    go.name = name
    content = self.contents[idx]
    local x = content:GetOffsetMinXY()
    content:SetOffsetMinXY(x, 0)
    x = content:GetOffsetMaxXY()
    content:SetOffsetMaxXY(x, 0)
    if self.tabIdx == idx then
      content:SetActive(true)
    else
      content:SetActive(false)
    end
  end)
end

function LLRuleBattle:RefreshGuideList()
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

return LLRuleBattle
