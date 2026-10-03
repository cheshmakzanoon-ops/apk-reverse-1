local EncourageView = BaseClass("EncourageView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local EncourageItem = require("UI.UIGovernment.Encourage.Component.EncourageItem")
local TabName = {
  [ThroneType.Native] = "zone_war_government_16",
  [ThroneType.Cross] = "zone_war_government_17"
}
local TipStr = {
  [ThroneType.Native] = "457088",
  [ThroneType.Cross] = "zone_war_government_15"
}
local RewardType = {
  President = 1,
  Core = 2,
  Cream = 3,
  Common = 4
}
local btn_back_path = "Root/BottomBar/BtnBack"
local text_title_path = "Root/TopBar/TextTitle"
local reward_item_path = "Root/Bg/RewardItem"
local content_path = "Root/Bg/ScrollView/Viewport/Content"
local btn_effect_path = "Root/BottomBar/BtnEffect"
local info_btn_path = "Root/TopBar/InfoBtn"

function EncourageView:OnCreate()
  base.OnCreate(self)
  self.serverId = LuaEntry.Player:GetSourceServerId()
  self:ComponentDefine()
  self:Init()
end

function EncourageView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function EncourageView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GovernmentPresentRefresh, self.UpdateData)
end

function EncourageView:OnRemoveListener()
  self:RemoveUIListener(EventId.GovernmentPresentRefresh, self.UpdateData)
  base.OnRemoveListener(self)
end

function EncourageView:ComponentDefine()
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetLocalText("457007")
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.btn_effect = self:AddComponent(UIButton, btn_effect_path)
  self.theItem = self.transform:Find(reward_item_path).gameObject
  self.theItem:GameObjectCreatePool()
  local theItem
  self.ItemList = {}
  for i = 1, 4 do
    theItem = self:AddComponent(EncourageItem, "Root/Bg/ScrollView/Viewport/Content/cell" .. i)
    table.insert(self.ItemList, theItem)
  end
  self.btn_effect:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentEncourageHistory, {anim = true}, self.throneType)
  end)
  self.info_btn:SetOnClick(function()
    local param = {}
    param.activityRulesStr = Localization:GetString(TipStr[self.throneType])
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end)
  self.togglesTbN = {}
  for i = 1, 2 do
    local tempPath = "Root/Bg/tabsSv/Viewport/Content/Toggle" .. i
    local toggle = self:AddComponent(UIButton, tempPath)
    toggle:SetOnClick(function()
      self:ChangeShowType(i)
    end)
    local newTog = {}
    newTog.toggleN = toggle
    newTog.chooseN = toggle:AddComponent(UIBaseContainer, "select")
    newTog.redN = toggle:AddComponent(UIBaseContainer, "RedPoint")
    newTog.redNumN = toggle:AddComponent(UIText, "RedPoint/RedNum")
    local nameN = toggle:AddComponent(UIText, "activityName")
    nameN:SetLocalText(TabName[i])
    newTog.showNewN = toggle:AddComponent(UIBaseContainer, "NewDot")
    newTog.showNewN:SetActive(false)
    newTog.ShowNewTxtN = toggle:AddComponent(UIText, "NewDot/Bg/Text")
    table.insert(self.togglesTbN, newTog)
  end
end

function EncourageView:ComponentDestroy()
  self.content:RemoveComponents(EncourageItem)
  self.theItem:GameObjectRecycleAll()
  self.content = nil
  self.btn_back = nil
end

function EncourageView:Init()
  local isConqueror = LuaEntry.Player:IsInSourceServer() and DataCenter.GovernmentManager:IsConqueror(LuaEntry.Player:GetSourceServerId())
  self.togglesTbN[ThroneType.Cross].toggleN:SetActive(DataCenter.GovernmentManager:IsCrossActivityOpen() or isConqueror)
  self:ChangeShowType(ThroneType.Native)
end

function EncourageView:UpdateData()
  for i, v in ipairs(self.ItemList) do
    v:UpdateData()
  end
end

function EncourageView:ChangeShowType(tab)
  self.throneType = tab
  for i = 1, #self.togglesTbN do
    self.togglesTbN[i].chooseN:SetActive(i == tab)
  end
  for i, v in ipairs(self.ItemList) do
    v:ReInit(i, self.throneType, self.serverId)
  end
end

return EncourageView
