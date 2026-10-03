local UIWinterStormBattleScoreView = BaseClass("UIWinterStormBattleScoreView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIWS_BattleScoreCell = require("UI.UIActivityCenterTable.Component.ActWinterStorm.BattleScore.Component.UIWS_BattleScoreCell")

function UIWinterStormBattleScoreView:OnCreate()
  base.OnCreate(self)
  self.curPlayers = {}
  self.curIdx = 1
  self.textTitle = self:AddComponent(UIText, "Common_bg_orange/Common_img_title/titleText")
  self.textTitle:SetLocalText("winter_battlefield_tips1044")
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closeBtn = self:AddComponent(UIButton, "Common_bg_orange/CloseBtn")
  self.closeBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.mainPanel = self:AddComponent(UIBaseContainer, "Common_bg_orange/Common_bg_orange2")
  self.battle_info = DataCenter.ActWinterStormManager:CreateBattleInfoAsync(self, self.mainPanel, -25, function()
    self.battle_info:SetLocalScaleXYZ(0.9, 0.9, 0.9)
    local resultInfo = DataCenter.ActWinterStormManager:GetResult()
    if resultInfo then
      local battleScore = resultInfo.battleScore
      if battleScore ~= nil then
        local numCL, numCR = 0, 0
        local mySide = DataCenter.ActWinterStormManager:GetMySide()
        local otherSide = 0
        if mySide ~= 0 then
          otherSide = mySide == 2 and 1 or 2
        end
        for side, score in pairs(battleScore) do
          if side == mySide then
            numCL = numCL + score
          elseif side == otherSide then
            numCR = numCR + score
          end
        end
        self.battle_info:UpdateNum(numCL, numCR, mySide)
      end
    end
  end)
  local basePath = "Common_bg_orange/Common_bg_orange2/SecView/Content/ToggleType"
  local textSecKeys = {
    "winter_battlefield_tips1045",
    "winter_battlefield_tips1046"
  }
  for i = 1, 2 do
    local keyStr = basePath .. i
    local toggleSec = self:AddComponent(UIToggle, keyStr)
    toggleSec:SetOnValueChanged(function(tf)
      self:SetOnValueChanged(i, tf)
    end)
    if i == 1 then
      toggleSec:SetIsOn(true)
    end
    local langKey = textSecKeys[i]
    local textSec1 = self:AddComponent(UIText, keyStr .. "/tabType_text" .. i)
    textSec1:SetLocalText(langKey)
    local textSec2 = self:AddComponent(UIText, keyStr .. "/Choose/tabType_text" .. i .. 2)
    textSec2:SetLocalText(langKey)
  end
  basePath = "Common_bg_orange/Common_bg_orange2/TitleGroup/TitleText"
  textSecKeys = {
    "winter_battlefield_tips1047",
    "winter_battlefield_tips1048",
    "winter_battlefield_tips1049",
    "winter_battlefield_tips1050",
    "winter_battlefield_tips1051"
  }
  for i = 1, 5 do
    local textTitle = self:AddComponent(UIText, basePath .. i)
    local langKey = textSecKeys[i]
    textTitle:SetLocalText(langKey)
  end
  self.scroll_view = self:AddComponent(UIScrollView, "Common_bg_orange/Common_bg_orange2/ScrollView")
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCellMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnCellMoveOut(itemObj, index)
  end)
  self.btn_tip = self:AddComponent(UIButton, "Common_bg_orange/TipBtn")
  self.btn_tip:SetOnClick(BindCallback(self, self.OnClickTip))
  self.text_btn_tip = self:AddComponent(UIText, "Common_bg_orange/TipBtn/TipBtnText")
  self.text_btn_tip:SetLocalText("winter_battlefield_tips1052")
  self:RefreshList()
end

function UIWinterStormBattleScoreView:OnDestroy()
  self.curPlayers = {}
  if self.scroll_view then
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(UIWS_BattleScoreCell)
  end
  self.scroll_view = nil
  self.battle_info = nil
  self.btn_tip = nil
  self.text_btn_tip = nil
  base.OnDestroy(self)
end

function UIWinterStormBattleScoreView:OnClickTip()
  UIUtil.ShowIntro(Localization:GetString("winter_battlefield_tips1052"), nil, Localization:GetString("winter_battlefield_tips1057"))
end

function UIWinterStormBattleScoreView:SetOnValueChanged(idx, tf)
  if not tf then
    return
  end
  self.curIdx = idx
  self:RefreshList()
end

function UIWinterStormBattleScoreView:RefreshList()
  local curPlayers = {}
  local mr = DataCenter.ActWinterStormManager:GetMarchResult()
  if mr then
    local mySide = DataCenter.ActWinterStormManager:GetMySide()
    if self.curIdx == 1 then
      curPlayers = mr:GetTeamListSortByScore(mySide == 1) or {}
    else
      curPlayers = mr:GetTeamListSortByScore(mySide ~= 1) or {}
    end
  end
  self.curPlayers = curPlayers
  local cnt = #curPlayers
  if self.scroll_view then
    self.scroll_view:SetTotalCount(cnt)
    self.scroll_view:RefillCells()
  end
end

function UIWinterStormBattleScoreView:OnCellMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(UIWS_BattleScoreCell, itemObj)
  local teamArr = self.curPlayers[index]
  cellItem:ReInit(teamArr, index)
end

function UIWinterStormBattleScoreView:OnCellMoveOut(itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UIWS_BattleScoreCell)
end

return UIWinterStormBattleScoreView
