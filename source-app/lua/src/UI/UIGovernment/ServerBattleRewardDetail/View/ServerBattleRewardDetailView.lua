local ServerBattleRewardDetailView = BaseClass("ServerBattleRewardDetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ServerBattleRewardDetailItem = require("UI.UIGovernment.ServerBattleRewardDetail.Component.ServerBattleRewardDetailItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local scroll_view_path = "PopUpTitle/ScrollView"
local content_path = "PopUpTitle/ScrollView/Viewport/Content"
local reward_item_path = "PopUpTitle/ScrollView/Viewport/RewardItem"
local item_path = "PopUpTitle/ScrollView/Viewport/item"

function ServerBattleRewardDetailView:OnCreate()
  base.OnCreate(self)
  self.configSchedule = DataCenter.ZoneWarManager:GetCrossKingSchedule()
  if self.configSchedule then
    self.config = self.configSchedule.configNow
    self.serverBattleType = self.config and self.config.type or ServerBattleType.VS4
  end
  self.rankRewardInfo = DataCenter.ZoneWarManager.rankRewardInfo
  if self.rankRewardInfo == nil then
    SFSNetwork.SendMessage(MsgDefines.GetCrossKingServerRewardInfo)
  end
  self:ComponentDefine()
end

function ServerBattleRewardDetailView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ServerBattleRewardDetailView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CrossKingServerRewardInfoRefresh, self.UpdateData)
end

function ServerBattleRewardDetailView:OnRemoveListener()
  self:RemoveUIListener(EventId.CrossKingServerRewardInfoRefresh, self.UpdateData)
  base.OnRemoveListener(self)
end

function ServerBattleRewardDetailView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText(801424)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.theItem = self.transform:Find(reward_item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.theRankItem = self.transform:Find(item_path).gameObject
  self.theRankItem:GameObjectCreatePool()
  self.scroll_view:SetVerticalNormalizedPosition(1.0)
  self:ShowRewardContent()
end

function ServerBattleRewardDetailView:ComponentDestroy()
  self.content:RemoveComponents(ServerBattleRewardDetailItem)
  self.theItem:GameObjectRecycleAll()
  self.theRankItem:GameObjectRecycleAll()
  self.btn_back = nil
end

function ServerBattleRewardDetailView:UpdateData()
  self.rankRewardInfo = DataCenter.ZoneWarManager.rankRewardInfo
  if self.rankRewardInfo ~= nil then
    self:ShowRewardContent()
  end
end

function ServerBattleRewardDetailView:ShowRewardContent()
  self.content:RemoveComponents(ServerBattleRewardDetailItem)
  self.theItem:GameObjectRecycleAll()
  self.theRankItem:GameObjectRecycleAll()
  if self.rankRewardInfo ~= nil then
    local goItem, theRankItem
    for rank, data in ipairs(self.rankRewardInfo) do
      local theName = "rank_" .. rank
      goItem = self.theRankItem:GameObjectSpawn(self.content.transform)
      goItem.name = theName
      goItem:SetActive(true)
      theRankItem = self.content:AddComponent(ServerBattleRewardDetailItem, theName)
      theRankItem:ReInit(rank, data, self.theItem, self:GetTitleName(rank, self.serverBattleType))
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  end
end

function ServerBattleRewardDetailView:GetTitleName(rank, serverBattleType)
  if serverBattleType == ServerBattleType.VSCamp then
    if rank == 1 then
      return Localization:GetString("zone_war_ui_desc04")
    else
      return Localization:GetString("zone_war_ui_desc05")
    end
  end
  return Localization:GetString(801430, rank)
end

return ServerBattleRewardDetailView
