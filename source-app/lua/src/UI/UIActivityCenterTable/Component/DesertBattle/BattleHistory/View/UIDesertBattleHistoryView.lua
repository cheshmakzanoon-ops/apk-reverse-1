local UIDesertBattleHistoryView = BaseClass("UIDesertBattleHistoryView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIDesertBattleHistoryItem = require("UI.UIActivityCenterTable.Component.DesertBattle.BattleHistory.Component.UIDesertBattleHistoryItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local empty_path = "PopUpTitle/empty"
local common_bg_orange2_path = "PopUpTitle/Common_bg_orange2"
local item_path = "PopUpTitle/Common_bg_orange2/Item"
local content_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content"
local scroll_view_path = "PopUpTitle/Common_bg_orange2/ScrollView"
local rank_des_path = "PopUpTitle/Common_bg_orange2/ScrollView/select/rankDes"
local name_des_path = "PopUpTitle/Common_bg_orange2/ScrollView/select/nameDes"
local power_des_path = "PopUpTitle/Common_bg_orange2/ScrollView/select/powerDes"

function UIDesertBattleHistoryView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self:ComponentDefine()
  DataCenter.ActDragonManager:SendBattleHistory()
end

function UIDesertBattleHistoryView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDesertBattleHistoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DragonBattleHistory, self.UpdateData)
end

function UIDesertBattleHistoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.DragonBattleHistory, self.UpdateData)
  base.OnRemoveListener(self)
end

function UIDesertBattleHistoryView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("458022")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.emptyNode = self:AddComponent(UIImage, empty_path)
  self.dataNode = self:AddComponent(UIImage, common_bg_orange2_path)
  self.item = self:AddComponent(UIBaseContainer, item_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.win_des = self:AddComponent(UIText, rank_des_path)
  self.total_des = self:AddComponent(UIText, name_des_path)
  self.fail_des = self:AddComponent(UIText, power_des_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function UIDesertBattleHistoryView:ComponentDestroy()
  self:ClearItemCell()
end

function UIDesertBattleHistoryView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(UIDesertBattleHistoryItem, itemObj)
  cellItem:ReInit(index, self.theHistoryList[index])
end

function UIDesertBattleHistoryView:OnItemMoveOut(itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UIDesertBattleHistoryItem)
end

function UIDesertBattleHistoryView:ClearItemCell()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIDesertBattleHistoryItem)
end

function UIDesertBattleHistoryView:UpdateData()
  local myAllianceId = LuaEntry.Player.allianceId
  local BattleHistory = DataCenter.ActDragonManager:GetBattleHistory()
  local battleCount = 0
  local winCount = 0
  local failCount = 0
  for i, v in ipairs(BattleHistory) do
    if v.allianceId == myAllianceId or v.enemyAllianceId == myAllianceId then
      if v.state == 2 then
        winCount = winCount + 1
      elseif v.state == 3 then
        failCount = failCount + 1
      end
      battleCount = battleCount + 1
    end
  end
  self.emptyNode:SetActive(battleCount == 0)
  self.dataNode:SetActive(0 < battleCount)
  self.theHistoryList = BattleHistory
  self.win_des:SetText(Localization:GetString("302122") .. ": " .. winCount)
  self.total_des:SetText(Localization:GetString("458024") .. ": " .. battleCount)
  self.fail_des:SetText(Localization:GetString("302123") .. ": " .. failCount)
  if 0 < battleCount then
    self.scroll_view:SetTotalCount(battleCount)
    self.scroll_view:RefillCells()
  end
end

return UIDesertBattleHistoryView
