local base = UIBaseContainer
local LWUIActBountyHunterRulesDropDetailItemComponent = BaseClass("LWUIActBountyHunterRulesDropDetailItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local Const = require("UI/LWUIActBountyHunter/LWUIActBountyHunterRules/LWUIActBountyHunterRulesConstant")

function LWUIActBountyHunterRulesDropDetailItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActBountyHunterRulesDropDetailItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActBountyHunterRulesDropDetailItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compDrop = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.textDrop = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compEvent = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.imgEventBg = self.viewSkin:AddComponent(self, UIImage, 4)
  self.imgEventIcon = self.viewSkin:AddComponent(self, UIImage, 5)
  self.compFreeTag = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.textFree = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.compItem = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.compUICommonResItem = self.viewSkin:AddComponent(self, UICommonResItem, 9)
  self.btnDrop = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnDrop:SetOnClick(function()
  end)
  self.btnEvent = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnEvent:SetOnClick(function()
    self:OnBtnEventClick()
  end)
end

function LWUIActBountyHunterRulesDropDetailItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compDrop = nil
  self.textDrop = nil
  self.compEvent = nil
  self.imgEventBg = nil
  self.imgEventIcon = nil
  self.compFreeTag = nil
  self.textFree = nil
  self.compItem = nil
  self.compUICommonResItem = nil
  self.btnDrop = nil
  self.btnEvent = nil
end

function LWUIActBountyHunterRulesDropDetailItemComponent:DataDefine()
end

function LWUIActBountyHunterRulesDropDetailItemComponent:DataDestroy()
end

function LWUIActBountyHunterRulesDropDetailItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActBountyHunterRulesDropDetailItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActBountyHunterRulesDropDetailItemComponent:ReInit(template, data, type)
  self.template = template
  self.data = data
  self.type = type
  if self.type == Const.Type.Monster_Refresh then
    self:Refresh_MonsterRefresh()
  elseif self.type == Const.Type.Event_Refresh then
    self:Refresh_EventRefresh()
  elseif self.type == Const.Type.Minion_Reward or self.type == Const.Type.Elite_Reward or self.type == Const.Type.Fly_Reward or self.type == Const.Type.Boss_Reward or self.type == Const.Type.Box_Reward then
    self:Refresh_Reward()
  end
end

function LWUIActBountyHunterRulesDropDetailItemComponent:Refresh_MonsterRefresh()
  if not self.template or not self.data then
    return
  end
  self.compItem:SetActive(false)
  self.compEvent:SetActive(true)
  self.compFreeTag:SetActive(false)
  local icon = self.template:GetIconPath(self.data.id)
  if not string.IsNullOrEmpty(icon) then
    self.imgEventIcon:LoadSprite(icon)
  end
  local bg = self.template:GetIconBgPath(self.data.id)
  if not string.IsNullOrEmpty(bg) then
    self.imgEventBg:LoadSprite(bg)
  end
  local probability = checknumber(self.data.probability)
  local isShowProbability = 0 < probability
  self.compDrop:SetActive(isShowProbability)
  if isShowProbability then
    self.textDrop:SetText(string.formatDecimalDown(probability / 10000 * 100, 1) .. "%")
  end
end

function LWUIActBountyHunterRulesDropDetailItemComponent:Refresh_EventRefresh()
  if not self.template or not self.data then
    return
  end
  self.compItem:SetActive(false)
  self.compEvent:SetActive(true)
  local isShowFree = false
  local lineData = LocalController:instance():getLine(TableName.Bounty_Hunter_Event, self.data.id)
  if lineData then
    isShowFree = checknumber(lineData.event) == 3
  end
  self.compFreeTag:SetActive(isShowFree)
  local icon = self.template:GetIconPath(self.data.id)
  if not string.IsNullOrEmpty(icon) then
    self.imgEventIcon:LoadSprite(icon)
  end
  local bg = self.template:GetIconBgPath(self.data.id)
  if not string.IsNullOrEmpty(bg) then
    self.imgEventBg:LoadSprite(bg)
  end
  local probability = checknumber(self.data.probability)
  local isShowProbability = 0 < probability
  self.compDrop:SetActive(isShowProbability)
  if isShowProbability then
    self.textDrop:SetText(string.formatDecimalDown(probability / 10000 * 100, 1) .. "%")
  end
end

function LWUIActBountyHunterRulesDropDetailItemComponent:Refresh_Reward()
  if not self.template or not self.data then
    return
  end
  self.compItem:SetActive(true)
  self.compEvent:SetActive(false)
  self.compFreeTag:SetActive(false)
  self.compUICommonResItem:ReInit(self.data.reward)
  local probability = checknumber(self.data.probability)
  local isShowProbability = 0 < probability
  self.compDrop:SetActive(isShowProbability)
  if isShowProbability then
    self.textDrop:SetText(string.formatDecimalDown(probability * 100 / 10000, 1) .. "%")
  end
end

function LWUIActBountyHunterRulesDropDetailItemComponent:OnBtnEventClick()
  if self.template then
    local param = {}
    param.alignObject = self.btnEvent.transform
    param.yPosFix = 30
    param.xPosFix = 230
    param.title = self.template:GetTipsTitle(self.data.id)
    param.desc = self.template:GetTipsDesc(self.data.id)
    param.showArrow = false
    param.preferTop = true
    if not string.IsNullOrEmpty(param.title) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActBountyHunterEventInfoTip, {anim = true}, param)
    end
  end
end

return LWUIActBountyHunterRulesDropDetailItemComponent
