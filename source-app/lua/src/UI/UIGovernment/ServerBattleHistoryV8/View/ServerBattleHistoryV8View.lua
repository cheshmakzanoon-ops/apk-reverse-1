local ServerBattleHistoryV8View = BaseClass("ServerBattleHistoryV8View", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local ServerBattleHistoryV8Item = require("UI.UIGovernment.ServerBattleHistoryV8.Component.ServerBattleHistoryV8Item")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local week1_path = "PopUpTitle/select/week1"
local week2_path = "PopUpTitle/select/week2"
local week3_path = "PopUpTitle/select/week3"
local info_btn_path = "PopUpTitle/Common_img_title/infoBtn"
local rank_list_item_path = "PopUpTitle/ScrollView/Viewport/RankListItem"
local content_path = "PopUpTitle/ScrollView/Viewport/Content"

function ServerBattleHistoryV8View:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  SFSNetwork.SendMessage(MsgDefines.CrossKingRoundInfoALL)
end

function ServerBattleHistoryV8View:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ServerBattleHistoryV8View:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CrossKingScheduleRefresh, self.UpdateData)
  self:AddUIListener(EventId.CrossKingRoundInfoALLRefresh, self.UpdateData)
end

function ServerBattleHistoryV8View:OnRemoveListener()
  self:RemoveUIListener(EventId.CrossKingScheduleRefresh, self.UpdateData)
  self:RemoveUIListener(EventId.CrossKingRoundInfoALLRefresh, self.UpdateData)
  base.OnRemoveListener(self)
end

function ServerBattleHistoryV8View:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText(801423)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.week1 = self:AddComponent(UIText, week1_path)
  self.week2 = self:AddComponent(UIText, week2_path)
  self.week3 = self:AddComponent(UIText, week3_path)
  self.week1:SetLocalText("801425", 1)
  self.week2:SetLocalText("801425", 2)
  self.week3:SetLocalText("801425", 3)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    local param = {}
    param.title = "801428"
    param.activityRulesStr = Localization:GetString("801429")
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.theItem = self.transform:Find(rank_list_item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self:UpdateData()
end

function ServerBattleHistoryV8View:ComponentDestroy()
  self.content:RemoveComponents(ServerBattleHistoryV8Item)
  self.theItem:GameObjectRecycleAll()
  self.btn_back = nil
end

function ServerBattleHistoryV8View:UpdateData()
  self.content:RemoveComponents(ServerBattleHistoryV8Item)
  self.theItem:GameObjectRecycleAll()
  local goItem, theItem
  local roundInfo = DataCenter.ZoneWarManager:GetCrossKingRoundInfoALL()
  if roundInfo and roundInfo.rankScore and roundInfo.allRoundInfo then
    local rankScore = {}
    for k, v in pairs(roundInfo.rankScore) do
      table.insert(rankScore, {
        serverId = toInt(k),
        score = v,
        battleList = {}
      })
    end
    table.sort(rankScore, function(a, b)
      return a.score > b.score
    end)
    for _, d in pairs(rankScore) do
      for _, v in ipairs(roundInfo.allRoundInfo) do
        if v.serverId == d.serverId and v.scoreSettled == 1 and v.win ~= 0 then
          table.insert(d.battleList, v)
        end
      end
    end
    for i, v in pairs(rankScore) do
      local theName = "item_" .. i
      goItem = self.theItem:GameObjectSpawn(self.content.transform)
      goItem.name = theName
      goItem:SetActive(true)
      theItem = self.content:AddComponent(ServerBattleHistoryV8Item, theName)
      theItem:ReInit(roundInfo.curRound, i, v, roundInfo.serverInfo[tostring(v.serverId)] or {cfgId = 511001})
    end
  end
end

return ServerBattleHistoryV8View
