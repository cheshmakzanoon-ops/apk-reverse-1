local UIPVEBuyAttackShop = BaseClass("UIPVEBuyAttackShop", UIBaseContainer)
local base = UIBaseContainer
local Const = require("Scene.PVEBattleLevel.Const")
local UIGray = CS.UIGray
local this_path = ""
local title_text_path = "BuyAttackShopTitle"
local attack_text_path = "CurAttackText"
local cost_num_text_path = "CostBg/CostNumText"
local cost_img_path = "CostBg/CostImage"
local guide_arrow_path = "UIGuideArrowFingerType1"
local ShowArrowTime = 2

function UIPVEBuyAttackShop:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  local trigger = DataCenter.BattleLevel:GetTriggerByTriggerType(Const.TriggerType.BuyAttack)
  if trigger ~= nil then
    self:ReInit(trigger.config.selectBuff)
  else
    self:SetVisible(false)
  end
end

function UIPVEBuyAttackShop:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIPVEBuyAttackShop:ComponentDefine()
  self.btn = self:AddComponent(UIButton, this_path)
  self.btn_img = self:AddComponent(UIImage, this_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.attack_text = self:AddComponent(UIText, attack_text_path)
  self.cost_num_text = self:AddComponent(UIText, cost_num_text_path)
  self.cost_img = self:AddComponent(UIImage, cost_img_path)
  self.guide_arrow = self:AddComponent(UIBaseContainer, guide_arrow_path)
  self.btn:SetOnClick(function()
    self:OnBuyBtnClick()
  end)
end

function UIPVEBuyAttackShop:ComponentDestroy()
  self.btn = nil
  self.btn_img = nil
  self.title_text = nil
  self.attack_text = nil
  self.cost_num_text = nil
  self.cost_img = nil
  self.guide_arrow = nil
end

function UIPVEBuyAttackShop:DataDefine()
  self.visible = nil
  self.curNum = 0
  self.resType = nil
  self.rayCastEnable = nil
  self.buffTriggerList = {}
  self.needCount = 0
  self.enough = nil
  self.trigger = nil
  self.isMax = false
end

function UIPVEBuyAttackShop:DataDestroy()
  self.visible = nil
  self.curNum = 0
  self.resType = nil
  self.rayCastEnable = nil
  self.buffTriggerList = {}
  self.needCount = 0
  self.enough = nil
  self.trigger = nil
  self.isMax = false
end

function UIPVEBuyAttackShop:OnEnable()
  base.OnEnable(self)
end

function UIPVEBuyAttackShop:OnDisable()
  base.OnDisable(self)
end

function UIPVEBuyAttackShop:OnAddListener()
  base.OnAddListener(self)
end

function UIPVEBuyAttackShop:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIPVEBuyAttackShop:ReInit(list)
  DataCenter.GuideManager:SendSaveGuideMessage(PveBuyAttackShopArrowShowTime, "")
  self.buffTriggerList = list
  if list ~= nil then
    self:SetVisible(true)
    self.title_text:SetLocalText(tonumber(GameDialogDefine.ATTACK))
    self:RefreshAttack()
    self:ShowShop()
  end
end

function UIPVEBuyAttackShop:RefreshAttack()
  local curNum = DataCenter.BattleLevel:GetAttack()
  if self.curNum ~= curNum then
    self.curNum = curNum
    self.attack_text:SetText(tostring(curNum))
  end
end

function UIPVEBuyAttackShop:SetVisible(visible)
  if self.visible ~= visible then
    self.visible = visible
    self.gameObject:SetActive(visible)
  end
end

function UIPVEBuyAttackShop:OnBuyBtnClick()
  if not self.trigger:IsTriggerOK() and DataCenter.BattleLevel:GetResTypeCount(self.resType) >= self.needCount then
    local num = 0
    local value = DataCenter.GuideManager:GetSaveGuideValue(PveBuyAttackShopArrowShowTime)
    if value ~= nil and value ~= "" then
      num = tonumber(value)
    end
    if num < ShowArrowTime then
      DataCenter.GuideManager:SendSaveGuideMessage(PveBuyAttackShopArrowShowTime, tostring(num + 1))
    end
    for k, v in ipairs(self.trigger.config.needCostRes) do
      DataCenter.BattleLevel:ChangeResTypeCount(v.resType, -v.count)
    end
    DataCenter.BattleLevel:RefreshCarryResourceText()
    if self.trigger.config.buffId ~= nil then
      DataCenter.BattleLevel:DoTrigger(self.trigger, true)
    end
    self:ShowShop()
  end
end

function UIPVEBuyAttackShop:SetRayEnable(enable)
  if self.rayCastEnable ~= enable then
    self.rayCastEnable = enable
    self.btn_img:SetRaycastTarget(enable)
  end
end

function UIPVEBuyAttackShop:RefreshBuff()
  if self.visible then
    self:RefreshAttack()
  end
end

function UIPVEBuyAttackShop:GetShowTrigger()
  if self.buffTriggerList ~= nil then
    for k, v in ipairs(self.buffTriggerList) do
      local trigger = DataCenter.BattleLevel:GetTriggerByTriggerId(v)
      if trigger ~= nil and not trigger:IsTriggerOK() then
        return trigger
      end
    end
  end
end

function UIPVEBuyAttackShop:ShowShop()
  local trigger = self:GetShowTrigger()
  if trigger == nil then
    self.isMax = true
    self.cost_num_text:SetLocalText(tonumber(GameDialogDefine.MAX))
    self:SetRayEnable(false)
    self:CheckShowArrow()
  else
    self.isMax = false
    if self.trigger ~= trigger then
      self.trigger = trigger
      if trigger.config.needCostRes ~= nil and trigger.config.needCostRes[1] ~= nil then
        local resType = trigger.config.needCostRes[1].resType
        if self.resType ~= resType then
          self.resType = resType
          self.cost_img:LoadSprite(Const.ResTypeIconPath[resType])
        end
        local needCount = trigger.config.needCostRes[1].count
        if self.needCount ~= needCount then
          self.needCount = needCount
          self.cost_num_text:SetText(tostring(needCount))
        end
        self:RefreshCount()
      end
    end
  end
end

function UIPVEBuyAttackShop:RefreshCount()
  if self.visible and not self.isMax then
    if DataCenter.BattleLevel:GetResTypeCount(self.resType) >= self.needCount then
      self:ShowTextColor(true)
    else
      self:ShowTextColor(false)
    end
    self:CheckShowArrow()
  end
end

function UIPVEBuyAttackShop:ShowTextColor(enough)
  if self.enough ~= enough then
    self.enough = enough
    if enough then
      self.cost_num_text:SetColor(WhiteColor)
      self:SetRayEnable(true)
      UIGray.SetGray(self.btn.transform, false, true)
    else
      self.cost_num_text:SetColor(RedColor)
      self:SetRayEnable(false)
      UIGray.SetGray(self.btn.transform, true, true)
    end
  end
end

function UIPVEBuyAttackShop:CheckShowArrow()
  local isShow = false
  if self.enough and DataCenter.GuideManager:GetSaveGuideValue(PveBuyAttackShopArrowShowTime) ~= ShowArrowTime then
    local num = 0
    local value = DataCenter.GuideManager:GetSaveGuideValue(PveBuyAttackShopArrowShowTime)
    if value ~= nil and value ~= "" then
      num = tonumber(value)
    end
    if num < ShowArrowTime then
      isShow = true
    end
  end
  self.guide_arrow:SetActive(isShow)
end

return UIPVEBuyAttackShop
