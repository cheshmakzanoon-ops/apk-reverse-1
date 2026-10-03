local UIDesertBattleStatusView = BaseClass("UIDesertBattleStatusView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIDesertBattleStatusItem = require("UI.UIActivityCenterTable.Component.DesertBattle.BattleStatus.Component.UIDesertBattleStatusItem")
local UIDesertBattleStatusItemAL = require("UI.UIActivityCenterTable.Component.DesertBattle.BattleStatus.Component.UIDesertBattleStatusItemAL")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local btn_leave_path = "PopUpTitle/Common_bg_orange2/BtnList/BtnLeave"
local btn_rules_path = "PopUpTitle/Common_bg_orange2/BtnList/BtnRules"
local user_self_path = "PopUpTitle/Common_bg_orange2/GameObject/UserSelf"
local user_other_path = "PopUpTitle/Common_bg_orange2/GameObject/UserOther"
local toggle1_path = "PopUpTitle/Common_bg_orange2/TabHolder/Tab/toggle1"
local toggle2_path = "PopUpTitle/Common_bg_orange2/TabHolder/Tab/toggle2"
local scroll_view_self_path = "PopUpTitle/Common_bg_orange2/ScrollViewSelf"
local scroll_view_other_path = "PopUpTitle/Common_bg_orange2/ScrollViewOther"
local rank_list_item_path = "PopUpTitle/Common_bg_orange2/ScrollViewSelf/RankListItem"

function UIDesertBattleStatusView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  local group = DataCenter.ActDragonManager:GetCurGroupIdx()
  SFSNetwork.SendMessage(MsgDefines.DragonBattleInfo, group)
  SFSNetwork.SendMessage(MsgDefines.DragonBattleScoreInfo, group)
  self:ComponentDefine()
end

function UIDesertBattleStatusView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDesertBattleStatusView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DragonBattleScoreInfo, self.UpdateData)
  self:AddUIListener(EventId.DesertBattleStatusInfo, self.UpdateData)
end

function UIDesertBattleStatusView:OnRemoveListener()
  self:RemoveUIListener(EventId.DragonBattleScoreInfo, self.UpdateData)
  self:RemoveUIListener(EventId.DesertBattleStatusInfo, self.UpdateData)
  base.OnRemoveListener(self)
end

function UIDesertBattleStatusView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("458031")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btn_leave = self:AddComponent(UIButton, btn_leave_path)
  self.btn_leave:SetActive(not BattleFieldUtil.isObserve)
  self.btn_rules = self:AddComponent(UIButton, btn_rules_path)
  self.user_self = self:AddComponent(UIDesertBattleStatusItemAL, user_self_path)
  self.user_other = self:AddComponent(UIDesertBattleStatusItemAL, user_other_path)
  self.toggle1 = self:AddComponent(UIToggle, toggle1_path)
  self.toggle2 = self:AddComponent(UIToggle, toggle2_path)
  self.selfCellItem = self:AddComponent(UIDesertBattleStatusItem, rank_list_item_path)
  self.ScrollViewSelf = self:AddComponent(UIScrollView, scroll_view_self_path)
  self.ScrollViewSelf:SetOnItemMoveIn(function(itemObj, index)
    self:OnSelfItemMoveIn(itemObj, index)
  end)
  self.ScrollViewSelf:SetOnItemMoveOut(function(itemObj, index)
    self:OnSelfItemMoveOut(itemObj, index)
  end)
  self.ScrollViewOther = self:AddComponent(UIScrollView, scroll_view_other_path)
  self.ScrollViewOther:SetOnItemMoveIn(function(itemObj, index)
    self:OnOtherItemMoveIn(itemObj, index)
  end)
  self.ScrollViewOther:SetOnItemMoveOut(function(itemObj, index)
    self:OnOtherItemMoveOut(itemObj, index)
  end)
  self.btn_leave:SetOnClick(function()
    local str = Localization:GetString("458143")
    UIUtil.ShowMessage(str, 2, "", "", function()
      DataCenter.ActDragonManager:ReqLevelDragonWorld()
      UIUtil.PlayCutSceneAnim(function()
        CrossServerUtil.OnBackSelfServerFromDragonWorld()
        SceneUtils.ChangeToCity(function()
          LuaEntry.Player:SetBattleFieldPointId(-1)
        end)
      end, nil, LuaEntry.Player:GetSelfServerId())
    end)
  end)
  self.btn_rules:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertRules, {anim = true}, BattleFieldType.Desert)
  end)
  self.toggle1:SetIsOn(true)
  self.ScrollViewSelf:SetActive(true)
  self.ScrollViewOther:SetActive(false)
  self.toggle1:SetOnValueChanged(function(tf)
    if tf then
      self.ScrollViewSelf:SetActive(true)
      self.ScrollViewOther:SetActive(false)
    end
  end)
  self.toggle2:SetOnValueChanged(function(tf)
    if tf then
      self.ScrollViewSelf:SetActive(false)
      self.ScrollViewOther:SetActive(true)
    end
  end)
  self:UpdateData()
end

function UIDesertBattleStatusView:ComponentDestroy()
  self:ClearScroll()
  self.btn_back = nil
end

function UIDesertBattleStatusView:UpdateData()
  local myAllianceId = LuaEntry.Player.allianceId
  local battleScoreInfo = DataCenter.ActDragonManager:GetBattleScoreInfo()
  if battleScoreInfo == nil then
    return
  end
  for _, v in ipairs(battleScoreInfo) do
    if v.allianceId == myAllianceId then
      self.user_self:ReInit(v.allianceId, v)
      self.userListSelf = v.userList
    else
      self.user_other:ReInit(v.allianceId, v)
      self.userListOther = v.userList
    end
  end
  self.selfCellItem:ReInit(nil, true)
  self:OnRefreshAlliance(self.userListSelf, self.ScrollViewSelf)
  self:OnRefreshAlliance(self.userListOther, self.ScrollViewOther)
  self.selfCellItem:SetActive(#self.userListSelf > 0)
end

function UIDesertBattleStatusView:OnRefreshAlliance(userList, sv)
  if userList == nil then
    return
  end
  if 0 < #userList then
    sv:SetTotalCount(#userList)
    sv:RefillCells()
  end
  for _, v in ipairs(userList) do
    if v.uid == LuaEntry.Player:GetUid() then
      self.selfCellItem:ReInit(v, true)
      break
    end
  end
end

function UIDesertBattleStatusView:OnSelfItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  self.ScrollViewSelf:RemoveComponent(itemObj.name, UIDesertBattleStatusItem)
  local cellItem = self.ScrollViewSelf:AddComponent(UIDesertBattleStatusItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(self.userListSelf[index], false)
  end
end

function UIDesertBattleStatusView:OnSelfItemMoveOut(itemObj, index)
  self.ScrollViewSelf:RemoveComponent(itemObj.name, UIDesertBattleStatusItem)
end

function UIDesertBattleStatusView:OnOtherItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  self.ScrollViewOther:RemoveComponent(itemObj.name, UIDesertBattleStatusItem)
  local cellItem = self.ScrollViewOther:AddComponent(UIDesertBattleStatusItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(self.userListOther[index], false)
  end
end

function UIDesertBattleStatusView:OnOtherItemMoveOut(itemObj, index)
  self.ScrollViewOther:RemoveComponent(itemObj.name, UIDesertBattleStatusItem)
end

function UIDesertBattleStatusView:ClearScroll()
  self.ScrollViewSelf:ClearCells()
  self.ScrollViewSelf:RemoveComponents(UIDesertBattleStatusItem)
  self.ScrollViewOther:ClearCells()
  self.ScrollViewOther:RemoveComponents(UIDesertBattleStatusItem)
end

return UIDesertBattleStatusView
