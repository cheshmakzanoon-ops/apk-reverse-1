local LWUISeasonTowerRankAllArmyInfoView = BaseClass("LWUISeasonTowerRankAllArmyInfoView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWUISeasonTowerRankAllArmyInfoItem = require("UI.LWUISeasonTower.UISeasonTowerRankAllArmyInfo.Component.LWUISeasonTowerRankAllArmyInfoItem")
local close_btn_path = "UICommonPopUpTitle/safearea/BtnClose"
local return_btn_path = "UICommonPopUpTitle/panel"
local UIPlayerHead_path = "bossRankObj/UIPlayerHead/HeadIcon"
local content_path = "bossRankObj/ScrollView/Viewport/Content"
local player_name_text_path = "bossRankObj/PlayerNameText"
local power_text_path = "bossRankObj/PowerText"

function LWUISeasonTowerRankAllArmyInfoView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.uid = param.uid
  self.stageId = param.stageId
  self.playerInfo = param.info
  SFSNetwork.SendMessage(MsgDefines.SeasonTowerStageRecord, {
    uid = param.uid,
    stageId = param.stageId
  })
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.scrollView = self:AddComponent(UIScrollView, "bossRankObj/ScrollView")
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.playerHeadIcon = self:AddComponent(UIPlayerHead, UIPlayerHead_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.player_name_text = self:AddComponent(UIText, player_name_text_path)
  self.power_text = self:AddComponent(UIText, power_text_path)
end

function LWUISeasonTowerRankAllArmyInfoView:OnDestroy()
  self:ClearScroll()
  self.close_btn = nil
  self.return_btn = nil
  self.playerHeadIcon = nil
  self.content = nil
  self.player_name_text = nil
  self.power_text = nil
  base.OnDestroy(self)
end

function LWUISeasonTowerRankAllArmyInfoView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonTowerStageRecord, self.RefreshView)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.ShowPlayerInfo)
end

function LWUISeasonTowerRankAllArmyInfoView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonTowerStageRecord, self.RefreshView)
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.ShowPlayerInfo)
  base.OnRemoveListener(self)
end

function LWUISeasonTowerRankAllArmyInfoView:RefreshView(t)
  if self.uid ~= t.uid then
    return
  end
  self.records = t.records or {}
  self:ShowPlayerInfo(self.uid)
  self:ShowHeroList()
  self.playerHeadIcon:ParseHeadInfo(self.playerInfo)
end

function LWUISeasonTowerRankAllArmyInfoView:ShowPlayerInfo(uid)
  if uid ~= self.uid then
    return
  end
  local user = UIUtil.GetPlayerInfoShowByUid(uid)
  if user == nil then
    return
  end
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(user.uid, user.name)
  self.player_name_text:SetText(UIUtil.FormatAllianceAndName(user.alAbbr, showName))
  self.power_text:SetText(user.power)
end

function LWUISeasonTowerRankAllArmyInfoView:ParseAllArmyInfo()
  self.showRecords = {}
  local stageList = DataCenter.LWSeasonTowerManager.stageList
  for _, v in ipairs(stageList) do
    local found = false
    for _, record in pairs(self.records) do
      if v.stageId == record.stageId then
        found = true
        table.insert(self.showRecords, record)
      end
    end
    if not found then
      table.insert(self.showRecords, {
        stageId = v.stageId,
        floor = 0,
        heroes = {}
      })
    end
  end
end

function LWUISeasonTowerRankAllArmyInfoView:ShowHeroList()
  self:ParseAllArmyInfo()
  self.scrollView:SetTotalCount(#self.showRecords)
  self.scrollView:RefillCells()
end

function LWUISeasonTowerRankAllArmyInfoView:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(LWUISeasonTowerRankAllArmyInfoItem)
end

function LWUISeasonTowerRankAllArmyInfoView:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local item = self.scrollView:AddComponent(LWUISeasonTowerRankAllArmyInfoItem, itemObj)
  item:SetData(self.showRecords[index])
end

function LWUISeasonTowerRankAllArmyInfoView:OnDeleteCell(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, LWUISeasonTowerRankAllArmyInfoItem)
end

return LWUISeasonTowerRankAllArmyInfoView
