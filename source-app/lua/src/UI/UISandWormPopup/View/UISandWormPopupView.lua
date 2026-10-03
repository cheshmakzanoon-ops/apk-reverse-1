local UISandWormPopupView = BaseClass("UISandWormPopupView", UIBaseView)
local base = UIBaseView
local panel_path = "panel"
local bg_path = "bg"
local theme_path = "bg/theme"
local btn_go_path = "bg/BtnGo"
local go_text_path = "bg/BtnGo/GoText"
local AllyMoveCityGoodsId = 200008

function UISandWormPopupView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:Init()
end

function UISandWormPopupView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISandWormPopupView:ComponentDefine()
  self.btnClose = self:AddComponent(UIButton, "bg/BtnClose")
  self.btnClose:SetOnClick(function()
    self:OnClickGo()
  end)
  self.btn_go = self:AddComponent(UIButton, btn_go_path)
  self.btn_go:SetOnClick(function()
    self:OnClickGo()
  end)
  self.bg_new = self:AddComponent(UIBaseComponent, "bg/bg_new")
  self.rawImgBgFly = self:AddComponent(UIRawImage, "bg/bgFly")
  self.go_text = self:AddComponent(UITextMeshProUGUIEx, go_text_path)
  self.compUICommonResItem = self:AddComponent(UICommonResItem, "bg/layout/UICommonResItem")
  self.textTheme = self:AddComponent(UITextMeshProUGUIEx, "bg/layout/theme")
  self.textDesc = self:AddComponent(UITextMeshProUGUIEx, "bg/layout/desc")
  self.textDesc:OnPointerClick(function(eventData)
    if CS.SceneManager.World then
      self:PlayFlyAnim()
      self.anim:Play("V_ui_UISandWormPopup_out", 0, 0)
      UIUtil.UseJumpLink(self.textDesc, eventData)
    end
  end)
  self.layout = self:AddComponent(UIBaseContainer, "bg/layout")
  self.anim = self:AddComponent(UIAnimator, "")
end

function UISandWormPopupView:ComponentDestroy()
  self.compUICommonResItem = nil
  self.textTheme = nil
  self.textDesc = nil
  self.btnClose = nil
  self.btn_go = nil
  self.go_text = nil
  self.rawImgBgFly = nil
  self.layout = nil
  self.anim = nil
end

function UISandWormPopupView:Init()
  local monsterId, oldPointId = self:GetUserData()
  local monsterMeta = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
  if not monsterMeta then
    return
  end
  local isWrap = monsterMeta.special == WorldMonsterSpecialType.SmallSandWorm
  self.isWrap = isWrap
  self.bg_new:SetActive(not isWrap)
  self.compUICommonResItem:SetActive(not isWrap)
  if isWrap then
    self.rawImgBgFly:LoadSprite("Assets/Main/SeasonRes/S3/Textures/WormPopup/mjc_S3_sc_pailian01.png")
    self.textDesc:SetLocalText("season_s3_sandworm_attack_bannertips02")
    self.go_text:SetLocalText(393010)
  else
    self.rawImgBgFly:LoadSprite("Assets/Main/SeasonRes/S3/Textures/WormPopup/mjc_S3_sc_new_01.png")
    if oldPointId and 0 < oldPointId then
      local strLink = UIUtil.MakeJumpLink(oldPointId)
      self.textDesc:SetLocalText("season_s3_sandworm_attack_bannertips01", strLink)
    else
      self.textDesc:SetLocalText("season_s3_sandworm_attack_bannertips03")
    end
    self.go_text:SetLocalText(129054)
    local rewardParam = {}
    rewardParam.rewardType = RewardType.GOODS
    rewardParam.itemId = AllyMoveCityGoodsId
    rewardParam.count = 1
    self.compUICommonResItem:ReInit(rewardParam)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layout.transform)
  self.anim:Play("V_ui_UISandWormPopup_in", 0, 0)
end

function UISandWormPopupView:OnClickGo()
  if not self.isWrap then
    self:PlayFlyAnim()
  end
  self.anim:Play("V_ui_UISandWormPopup_out", 0, 0)
  TimerManager:GetInstance():DelayInvoke(function()
    self.ctrl:CloseSelf()
  end, 0.3)
end

function UISandWormPopupView:PlayFlyAnim()
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

return UISandWormPopupView
