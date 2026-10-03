local UIJungleTrialPopupView = BaseClass("UIJungleTrialPopupView", UIBaseView)
local base = UIBaseView
local panel_path = "panel"
local bg_path = "bg"
local theme_path = "bg/theme"
local btn_go_path = "bg/BtnGo"
local go_text_path = "bg/BtnGo/GoText"
local AllyMoveCityGoodsId = 200008

function UIJungleTrialPopupView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:Init()
end

function UIJungleTrialPopupView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIJungleTrialPopupView:ComponentDefine()
  self.btnClose = self:AddComponent(UIButton, "bg/BtnClose")
  self.btnClose:SetOnClick(function()
    self:OnClickGo()
  end)
  self.btn_go = self:AddComponent(UIButton, btn_go_path)
  self.btn_go:SetOnClick(function()
    self:OnClickGo()
  end)
  self.go_text = self:AddComponent(UITextMeshProUGUIEx, go_text_path)
  self.compUICommonResItem = self:AddComponent(UICommonResItem, "bg/layout/UICommonResItem")
  self.textDesc = self:AddComponent(UITextMeshProUGUIEx, "bg/layout/desc")
  self.textDesc:OnPointerClick(function(eventData)
    if CS.SceneManager.World then
      self:PlayFlyAnim()
      UIUtil.UseJumpLink(self.textDesc, eventData)
    end
  end)
  self.layout = self:AddComponent(UIBaseContainer, "bg/layout")
end

function UIJungleTrialPopupView:ComponentDestroy()
  self.compUICommonResItem = nil
  self.textDesc = nil
  self.btnClose = nil
  self.btn_go = nil
  self.go_text = nil
  self.layout = nil
end

function UIJungleTrialPopupView:Init()
  local monsterId, oldPointId = self:GetUserData()
  local monsterMeta = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
  if not monsterMeta then
    return
  end
  self.textDesc:SetLocalText("season6_piranha_swallow_warn")
  self.go_text:SetLocalText(393010)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layout.transform)
end

function UIJungleTrialPopupView:OnClickGo()
  TimerManager:GetInstance():DelayInvoke(function()
    self.ctrl:CloseSelf()
  end, 0.3)
end

function UIJungleTrialPopupView:PlayFlyAnim()
  local cfg = {
    self.compUICommonResItem.transform.position,
    {
      count = 1,
      itemId = AllyMoveCityGoodsId,
      rewardType = RewardType.GOODS
    }
  }
  EventManager:GetInstance():Broadcast(EventId.UIMainFlyReward, {cfg})
end

return UIJungleTrialPopupView
