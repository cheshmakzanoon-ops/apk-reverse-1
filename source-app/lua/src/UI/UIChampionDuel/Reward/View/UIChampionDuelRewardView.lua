local UIChampionDuelRewardView = BaseClass("UIChampionDuelRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIDecorationHeadFrame = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationHeadFrame")

function UIChampionDuelRewardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:UpdateUI()
end

function UIChampionDuelRewardView:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChampionDuelRewardView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChampionDuelRewardHeartFinish, self.OnRewardHeartFinish)
end

function UIChampionDuelRewardView:OnRemoveListener()
  self:RemoveUIListener(EventId.ChampionDuelRewardHeartFinish, self.OnRewardHeartFinish)
  base.OnRemoveListener(self)
end

function UIChampionDuelRewardView:ComponentDefine()
  self.textTitle = self:AddComponent(UIText, "SpecialBg/OtherTitleBg/OtherTitleText")
  self.textTitle:SetLocalText("320320")
  self.textDesc = self:AddComponent(UIText, "layout/DescText")
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
  self.text_word = self:AddComponent(UIText, "layout/WordBg/WordText")
  self.icon_praise = self:AddComponent(UIImage, "layout/WordBg/PraiseIcon")
  self.icon_praise:SetActive(true)
  self.btn_word = self:AddComponent(UIButton, "layout/WordBg")
  self.btn_word:SetOnClick(BindCallback(self, self.OnBtnWordClick))
  self.btn_word:SetInteractable(self.icon_praise:GetActive())
  self.textTip = self:AddComponent(UIText, "layout/TipsText")
  self.btnClaim = self:AddComponent(UIButton, "BtnClaim")
  self.btnClaim:SetOnClick(function()
    if self.bRankReward then
      self:OnBtnWordClick()
    end
    self.ctrl:CloseSelf()
  end)
  self.textClaim = self:AddComponent(UIText, "BtnClaim/Btn/TextClaim")
  self.btnSkipAnimButton = self:AddComponent(UIButton, "SkipAnimButton")
  self.btnSkipAnimButton:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
end

function UIChampionDuelRewardView:ComponentDestroy()
  self.textTitle = nil
  self.textDesc = nil
  self.compScrollView = nil
  self.player_content:RemoveComponents(UIDecorationHeadFrame)
  self.player_content = nil
  self.theItem:GameObjectRecycleAll()
  self.theItem = nil
  self.btn_word = nil
  self.text_word = nil
  self.textTip = nil
  self.btnClaim = nil
  self.textClaim = nil
  self.btnSkipAnimButton = nil
end

function UIChampionDuelRewardView:OnRewardHeartFinish()
  self.icon_praise:SetActive(false)
  self.btn_word:SetInteractable(false)
  local str = Localization:GetString("champion_duel_tips1168", self.count)
  UIUtil.ShowTips(str)
end

function UIChampionDuelRewardView:OnBtnWordClick()
  if not self.icon_praise:GetActive() then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.lastBtnClickTime == nil or curTime - self.lastBtnClickTime > 3000 then
    SFSNetwork.SendMessage(MsgDefines.ChampionDuelRewardHeart, self.rewardId)
    self.lastBtnClickTime = curTime
  end
end

function UIChampionDuelRewardView:UpdateUI()
  self.param = self:GetUserData()
  if self.param == nil then
    return
  end
  local param = self.param
  self.rewardId = param.id or 0
  local key = LocalController:instance():getStrValue(TableName.LW_Champion_Duel_Reward, self.rewardId, "task_desc")
  if string.IsNullOrEmpty(key) then
    self.textDesc:SetActive(false)
  else
    local para = LocalController:instance():getStrValue(TableName.LW_Champion_Duel_Reward, self.rewardId, "para")
    local paras = string.split(para, ",")
    local needNum = tonumber(paras[2]) or 1
    self.textDesc:SetLocalText(key, needNum)
    self.textDesc:SetActive(true)
  end
  local reward = param.reward or {}
  self.compScrollView:SetTotalCount(#reward)
  self.compScrollView:RefillCells()
  self.bRankReward = param.type == 1
  self.textClaim:SetLocalText(self.bRankReward and "activity_sports_uitips_016" or GameDialogDefine.CONFIRM)
  self:UpdateHelpUser(param)
end

function UIChampionDuelRewardView:UpdateHelpUser(param)
  local helpUser = param.helpUser
  self.helpUser = helpUser
  self.count = param.count or 0
  if table.IsNullOrEmpty(helpUser) or self.count <= 0 then
    self.player_content:SetActive(false)
    self.btn_word:SetActive(false)
    self.textTip:SetActive(false)
    return
  end
  self.player_content:SetActive(true)
  if self.count < 5 then
    self.player_content:SetSpacing(0)
  else
    self.player_content:SetSpacing(-100)
  end
  local msg, goItem, headIcon
  for k, v in ipairs(helpUser) do
    if msg == nil then
      msg = UIUtil.FormatAllianceAndName(v.abbr, v.name, v.uid)
    else
      msg = msg .. " , " .. UIUtil.FormatAllianceAndName(v.abbr, v.name, v.uid)
    end
    goItem = self.theItem:GameObjectSpawn(self.player_content.transform)
    goItem.name = "item_" .. k
    goItem:SetActive(true)
    headIcon = self.player_content:AddComponent(UIDecorationHeadFrame, goItem.name)
    v:SetFrameShow(headIcon)
  end
  local dialogKey = LocalController:instance():getStrValue(TableName.LW_Champion_Duel_Reward, param.id or 0, "dialog")
  if string.IsNullOrEmpty(dialogKey) then
    Logger.Log("[UIChampionDuelRewardView] dialog is null, id=", param.id)
    self.btn_word:SetActive(false)
  else
    self.text_word:SetLocalText(dialogKey)
    self.btn_word:SetActive(true)
  end
  self.textTip:SetLocalText("champion_duel_tips1020", msg, self.count, self.count)
  self.textTip:SetActive(true)
end

function UIChampionDuelRewardView:ClearScroll()
  self.compScrollView:ClearCells()
  self.compScrollView:RemoveComponents(UICommonResItem)
end

function UIChampionDuelRewardView:OnCellMoveIn(itemObj, index)
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

function UIChampionDuelRewardView:OnCellMoveOut(itemObj, index)
  self.compScrollView:RemoveComponent(itemObj.name, UICommonResItem)
end

return UIChampionDuelRewardView
