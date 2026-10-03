local UIGMSwitchView = BaseClass("UIGMSwitchView", UIBaseView)
local UIGMSwitchViewItem = require("UI.UIGMPanel.Misc.GMSwitchView.UIGMSwitchViewItem")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIGMSwitchView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIGMSwitchView:OnDestroy()
  self:ClearItems()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGMSwitchView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnImgBg = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnImgBg:SetOnClick(function()
    self:OnBtnImgBgClick()
  end)
  self.gridInfinityScrollViewContent = self.viewSkin:AddComponent(self, GridInfinityScrollView, 2)
  self.textTmpTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compUIGMSwitchView = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.textTmpInfo = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.inputFieldInputField = self.viewSkin:AddComponent(self, UIInput, 6)
  self.btnAdd = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnAdd:SetOnClick(function()
    self:OnBtnAddClick()
  end)
  self.textTmpTitle:SetText("\229\188\128\229\133\179\229\136\151\232\161\168")
  self.listGO = {}
  self.itemList = {}
  self.keyword = self.inputFieldInputField:GetText()
  self.inputFieldInputField:SetOnValueChange(function(val)
    self.keyword = val
    self:RefreshView()
  end)
  self.gridInfinityScrollViewContent:Init(BindCallback(self, self.OnInitCell), BindCallback(self, self.OnUpdateCell), BindCallback(self, self.OnDestroyCell))
  self:RefreshView()
end

function UIGMSwitchView:ComponentDestroy()
  self.viewSkin = nil
  self.btnImgBg = nil
  self.gridInfinityScrollViewContent = nil
  self.textTmpTitle = nil
  self.compUIGMSwitchView = nil
  self.textTmpInfo = nil
  self.inputFieldInputField = nil
  self.btnAdd = nil
end

function UIGMSwitchView:DataDefine()
end

function UIGMSwitchView:DataDestroy()
end

function UIGMSwitchView:OnAddListener()
  base.OnAddListener(self)
end

function UIGMSwitchView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIGMSwitchView:OnBtnImgBgClick()
  self.ctrl:CloseSelf()
end

function UIGMSwitchView:RefreshView()
  local showAddBtn = false
  if not string.IsNullOrEmpty(self.keyword) then
    local hasKey = LuaEntry.DataConfig:CheckSwitchSafe(self.keyword)
    if hasKey == nil then
      showAddBtn = true
    end
  end
  self.btnAdd:SetActive(showAddBtn)
  self.itemData = self.ctrl:GetSwitchArray(self.keyword)
  self.gridInfinityScrollViewContent:SetItemCount(#self.itemData)
  self.textTmpInfo:SetText(string.format("\229\188\128\229\133\179\230\149\176\233\135\143:%s", #self.itemData))
end

function UIGMSwitchView:ClearItems()
  self.compUIGMSwitchView:RemoveComponents(UIGMSwitchViewItem)
  self.gridInfinityScrollViewContent:DestroyChildNode()
  self.listGO = {}
  self.itemList = {}
end

function UIGMSwitchView:OnInitCell(go, index)
  local item = self.compUIGMSwitchView:AddComponent(UIGMSwitchViewItem, go)
  item:SetActive(false)
  self.listGO[go] = item
end

function UIGMSwitchView:OnUpdateCell(go, index)
  local cellItem = self.listGO[go]
  if cellItem then
    local theIndex = index + 1
    cellItem:SetActive(true)
    cellItem:ReInit(theIndex, self.itemData[theIndex])
    self.itemList[theIndex] = cellItem
  end
end

function UIGMSwitchView:OnDestroyCell(go, index)
end

function UIGMSwitchView:OnBtnAddClick()
  if string.IsNullOrEmpty(self.keyword) then
    UIUtil.ShowTips("\228\189\160\229\183\165\228\189\156\229\129\154\229\174\140\228\186\134\228\185\136\239\188\159")
    return
  end
  local hasKey = LuaEntry.DataConfig:CheckSwitchSafe(self.keyword)
  if hasKey ~= nil then
    UIUtil.ShowTips("\229\189\147\229\137\141\230\156\137\232\191\153\228\184\170key\239\188\140\230\151\160\233\156\128\230\183\187\229\138\160\229\145\162~")
    return
  end
  UIUtil.ShowMessage(string.format("\228\189\160\231\161\174\229\174\154\232\166\129\228\184\180\230\151\182\230\183\187\229\138\160\229\188\128\229\133\179%s\228\185\136\239\188\159", self.keyword), 2, "\229\189\147\231\132\182", "\231\174\151\228\186\134...", function()
    LuaEntry.DataConfig:GMManualSetSwitch(self.keyword, true)
    self:RefreshView()
  end, function()
    UIUtil.ShowTips("\229\152\191\229\152\191\239\188\140\230\136\145\229\176\177\229\138\160\239\188\129!")
    TimerManager:GetInstance():DelayInvoke(function()
      LuaEntry.DataConfig:GMManualSetSwitch(self.keyword, true)
      self:RefreshView()
    end, 0.5)
  end, nil)
end

return UIGMSwitchView
