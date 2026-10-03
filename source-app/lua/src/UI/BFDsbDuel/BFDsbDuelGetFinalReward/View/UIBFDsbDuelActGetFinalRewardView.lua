local UIBFDsbDuelActGetFinalRewardView = BaseClass("UIBFDsbDuelActGetFinalRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIBFDsbDuelActGetFinalRewardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:UpdateUI()
end

function UIBFDsbDuelActGetFinalRewardView:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActGetFinalRewardView:OnAddListener()
  base.OnAddListener(self)
end

function UIBFDsbDuelActGetFinalRewardView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActGetFinalRewardView:ComponentDefine()
  self.textTitle = self:AddComponent(UIText, "SpecialBg/OtherTitleBg/OtherTitleText")
  self.textTitle:SetLocalText("320320")
  self.compScrollView = self:AddComponent(UIScrollView, "layout/CellList")
  self.compScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnCellMoveIn(itemObj, index)
  end)
  self.compScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnCellMoveOut(itemObj, index)
  end)
  self.player_content = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, "layout/PlayerContent")
  self.theItem = self.transform:Find("layout/Head").gameObject
  self.theItem:GameObjectCreatePool()
  self.textTip = self:AddComponent(UIText, "layout/TipsText")
  self.btnClaim = self:AddComponent(UIButton, "BtnClaim")
  self.btnClaim:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.textClaim = self:AddComponent(UIText, "BtnClaim/Btn/TextClaim")
  self.btnSkipAnimButton = self:AddComponent(UIButton, "SkipAnimButton")
  self.btnSkipAnimButton:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
end

function UIBFDsbDuelActGetFinalRewardView:ComponentDestroy()
  self.textTitle = nil
  self.compScrollView = nil
  self.player_content = nil
  self.theItem:GameObjectRecycleAll()
  self.theItem = nil
  self.textTip = nil
  self.btnClaim = nil
  self.textClaim = nil
  self.btnSkipAnimButton = nil
end

function UIBFDsbDuelActGetFinalRewardView:OnBtnWordClick()
end

function UIBFDsbDuelActGetFinalRewardView:UpdateUI()
  self.param = self:GetUserData()
  if self.param == nil then
    return
  end
  local param = self.param
  self.rewardId = param.id or 0
  local reward = param.reward or {}
  self.compScrollView:SetTotalCount(#reward)
  self.compScrollView:RefillCells()
  self.textClaim:SetLocalText(GameDialogDefine.CONFIRM)
  self:UpdateHelpAlliance(param)
end

function UIBFDsbDuelActGetFinalRewardView:UpdateHelpAlliance(param)
  local helpAlliance = param.helpAlliance
  self.helpAlliance = helpAlliance
  if table.IsNullOrEmpty(helpAlliance) then
    self.player_content:SetActive(false)
    self.textTip:SetActive(false)
    return
  end
  self.player_content:SetActive(true)
  self.player_content:SetSpacing(-100)
  local msg, goItem
  for k, v in ipairs(helpAlliance) do
    if msg == nil then
      msg = UIUtil.FormatAllianceAndName(v.abbr)
    else
      msg = msg .. " , " .. UIUtil.FormatAllianceAndName(v.abbr)
    end
    goItem = self.theItem:GameObjectSpawn(self.player_content.transform)
    goItem.name = "item_" .. k
    goItem:SetActive(true)
    local csIcon = goItem.transform:Find("Icon"):GetComponent(typeof(CS.UnityEngine.UI.Image))
    if IsNotNull(csIcon) then
      csIcon:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, v.icon))
    end
  end
  self.textTip:SetText(msg .. Localization:GetString("dsb_duel_tips_1004", #helpAlliance))
  self.textTip:SetActive(true)
end

function UIBFDsbDuelActGetFinalRewardView:ClearScroll()
  self.compScrollView:ClearCells()
  self.compScrollView:RemoveComponents(UICommonResItem)
end

function UIBFDsbDuelActGetFinalRewardView:OnCellMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.compScrollView:AddComponent(UICommonResItem, itemObj)
  local rewards = self.param ~= nil and self.param.reward or nil
  if table.IsNullOrEmpty(rewards) then
  end
  local reward = rewards[index]
  if reward ~= nil then
    cellItem:ReInit(reward)
  end
end

function UIBFDsbDuelActGetFinalRewardView:OnCellMoveOut(itemObj, index)
  self.compScrollView:RemoveComponent(itemObj.name, UICommonResItem)
end

return UIBFDsbDuelActGetFinalRewardView
