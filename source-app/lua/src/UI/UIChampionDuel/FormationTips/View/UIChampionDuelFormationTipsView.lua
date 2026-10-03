local UIChampionDuelFormationTipsView = BaseClass("UIChampionDuelFormationTipsView", UIBaseView)
local base = UIBaseView
local UICD_FormationLvGroup_Cls = "UI.UIChampionDuel.FormationTips.Component.UICD_FormationLvGroup"
local UICD_FormationLvGroup_Prefab = "Assets/Main/Prefabs/UI/UIChampionDuel/UIChampionDuelFormationTipsLv.prefab"
local UICD_FormationEmptyGroup_Cls = "UI.UIChampionDuel.FormationTips.Component.UICD_FormationEmptyGroup"
local UICD_FormationEmptyGroup_Prefab = "Assets/Main/Prefabs/UI/UIChampionDuel/UIChampionDuelFormationTipsEmpty.prefab"
local close_btn_path = "Common_bg_orange/CloseBtn"
local closeBg_path = "panel"
local title_path = "Common_bg_orange/Common_img_title/titleText"
local content = "Common_bg_orange/Common_bg_orange2/ScrollView/Content"
local text_tip_path = "Common_bg_orange/Common_bg_orange2/ScrollView/Content/Tip/TipText"

function UIChampionDuelFormationTipsView:OnCreate()
  base.OnCreate(self)
  self.title = self:AddComponent(UIText, title_path)
  self.title:SetLocalText("champion_duel_tips1174")
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closeBg = self:AddComponent(UIButton, closeBg_path)
  self.closeBg:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIBaseComponent, content)
  self.text_tip = self:AddComponent(UIText, text_tip_path)
  self.text_tip:SetLocalText("champion_duel_tips1175")
  self:CheckShow()
end

function UIChampionDuelFormationTipsView:OnDestroy()
  self.title = nil
  self.close_btn = nil
  self.closeBg = nil
  self.content = nil
  self.text_tip = nil
  self.lvGroup = nil
  self.emptyGroup = nil
  base.OnDestroy(self)
end

function UIChampionDuelFormationTipsView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChampionDuelSquadChoose, self.OnSquadChoose)
end

function UIChampionDuelFormationTipsView:OnRemoveListener()
  self:RemoveUIListener(EventId.ChampionDuelSquadChoose, self.OnSquadChoose)
  base.OnRemoveListener(self)
end

function UIChampionDuelFormationTipsView:CheckShow()
  local haveEmpty, notBeastUuids, view = self:GetUserData()
  self.targetView = view
  local idx = 0
  if not table.IsNullOrEmpty(notBeastUuids) then
    if self.lvGroup == nil then
      idx = idx + 1
      self.lvGroup = self:LoadComponentAsync(UICD_FormationLvGroup_Cls, UICD_FormationLvGroup_Prefab, self.content)
      self.lvGroup:SetSiblingIndex(idx)
      self.lvGroup:SetName("Lv")
    end
    self.lvGroup:SetActive(true)
    self.lvGroup:SetData(notBeastUuids)
  elseif self.lvGroup ~= nil then
    self.lvGroup:SetActive(false)
  end
  if haveEmpty then
    if self.emptyGroup == nil then
      idx = idx + 1
      self.emptyGroup = self:LoadComponentAsync(UICD_FormationEmptyGroup_Cls, UICD_FormationEmptyGroup_Prefab, self.content)
      self.emptyGroup:SetSiblingIndex(idx)
      self.emptyGroup:SetName("Empty")
    end
    self.emptyGroup:SetActive(true)
  elseif self.emptyGroup ~= nil then
    self.emptyGroup:SetActive(false)
  end
end

function UIChampionDuelFormationTipsView:OnSquadChoose(order)
  if self.targetView and self.targetView.OnClickSquadChooseBtn then
    self.targetView.ChangeSquadIndex(self.targetView, order)
    self.ctrl:CloseSelf()
  end
end

return UIChampionDuelFormationTipsView
