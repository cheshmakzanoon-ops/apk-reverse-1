local base = UIAsyncContainer
local LLRuleCommonItem = BaseClass("LLRuleCommonItem", UIAsyncContainer)
local Localization = CS.GameEntry.Localization

function LLRuleCommonItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLRuleCommonItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLRuleCommonItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 3)
end

function LLRuleCommonItem:ComponentDestroy()
  self.viewSkin = nil
  self.textDesc = nil
  self.textName = nil
  self.imgIcon = nil
end

function LLRuleCommonItem:DataDefine()
end

function LLRuleCommonItem:DataDestroy()
end

function LLRuleCommonItem:OnAddListener()
  base.OnAddListener(self)
end

function LLRuleCommonItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLRuleCommonItem:SetData(data)
  self.data = data
  self:RefreshView()
end

function LLRuleCommonItem:UpdateData()
  if self.data == nil then
    return
  end
  self.imgIcon:LoadSpriteAsyncWithCallback(self.data.pic, function()
    self.imgIcon:SetAspectSize(150)
  end)
  if self.data.num ~= nil then
    self.textName:SetText(string.format("%s\195\151%d", Localization:GetString(self.data.tittle), self.data.num))
  else
    self.textName:SetLocalText(self.data.tittle)
  end
  self.textDesc:SetLocalText(self.data.desc)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.textDesc.transform)
end

return LLRuleCommonItem
