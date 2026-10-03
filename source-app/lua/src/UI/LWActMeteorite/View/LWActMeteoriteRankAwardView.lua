local LWActMeteoriteRankAwardView = BaseClass("LWActMeteoriteRankAwardView", UIBaseView)
local base = UIBaseView
local LWActMeteoriteRankAwardItem = require("UI.LWActMeteorite.Component.Rank.LWActMeteoriteRankAwardItem")
local closeBtn_path = "Common_bg_orange/CloseBtn"
local closeBg_path = "panel"
local base_toggle_path = "Common_bg_orange/Common_bg_orange2/TogView/Toggle"
local scroll_view_path = "Common_bg_orange/Common_bg_orange2/ScrollView"
local content_path = "Common_bg_orange/Common_bg_orange2/ScrollView/Viewport/Content"
local tip_text_path = "Common_bg_orange/Common_bg_orange2/TipText"

function LWActMeteoriteRankAwardView:OnCreate()
  base.OnCreate(self)
  self.close_btn = self:AddComponent(UIButton, closeBtn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closeBg = self:AddComponent(UIButton, closeBg_path)
  self.closeBg:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.items = {}
  self.dataList = {}
  self.toggles = {}
  local bPerson = self:GetUserData()
  local idx = bPerson == true and 2 or 1
  for i = 1, 2 do
    local toggle = self:AddComponent(UIToggle, base_toggle_path .. i)
    if i == idx then
      toggle:SetIsOn(true)
    end
    toggle:SetOnValueChanged(function(action)
      if action then
        self:SetToggle(i)
      end
    end)
    self.toggles[i] = toggle
  end
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.tip_text = self:AddComponent(UITextMeshProUGUIEx, tip_text_path)
  self:SetToggle(idx)
end

function LWActMeteoriteRankAwardView:OnDestroy()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(LWActMeteoriteRankAwardItem)
  self.close_btn = nil
  self.closeBg = nil
  self.scroll_view = nil
  self.content = nil
  self.tip_text = nil
  self.items = {}
  self.dataList = {}
  self.toggles = {}
  base.OnDestroy(self)
end

function LWActMeteoriteRankAwardView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local item = self.scroll_view:AddComponent(LWActMeteoriteRankAwardItem, itemObj)
  item:SetData(self.dataList[index], self.bPerson)
  self.items[index] = item
end

function LWActMeteoriteRankAwardView:OnItemMoveOut(itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, LWActMeteoriteRankAwardItem)
  self.items[index] = nil
end

function LWActMeteoriteRankAwardView:SetToggle(index)
  self.curIdx = index
  self.bPerson = index == 2
  local type = index == 1 and 3 or 2
  self.dataList = DataCenter.ActMeteoriteBattleManager:GetRewardBoxes(type)
  local cnt = #self.dataList
  self.scroll_view:SetTotalCount(cnt)
  self.scroll_view:RefillCells()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.transform)
  self.scroll_view:SetVerticalNormalizedPosition(1)
  self.scroll_view:ScrollToCell(1, 10 * cnt)
  local actInfo = DataCenter.ActMeteoriteBattleManager:GetActInfo()
  local meteorites = actInfo ~= nil and actInfo.meteorites or {}
  local grabs = actInfo.grabTimes or 0
  local ranks = string.string2array_i_oneSep(self.dataList[cnt].para, ";")
  local maxRank = ranks[2] or 0
  local tipStr = {}
  for i, v in ipairs(meteorites) do
    if i <= grabs then
      local checkRank = self.bPerson and v.personRank or v.allianceRank
      if checkRank == 0 or maxRank < checkRank then
        table.insert(tipStr, i)
      end
    end
  end
  local notStart = {}
  for k = 1, 2 do
    if k > grabs then
      table.insert(notStart, k)
    end
  end
  local flag = 0 < #tipStr or 0 < #notStart
  self.tip_text:SetActive(flag)
  if not flag then
    return
  end
  if 2 <= #notStart then
    self.tip_text:SetLocalText("yuntieBattle_interface_1051", notStart[1])
  elseif #notStart == 1 then
    if 0 < #tipStr then
      self.tip_text:SetLocalText("yuntieBattle_interface_1049", tipStr[1])
    else
      self.tip_text:SetLocalText("yuntieBattle_interface_1051", notStart[1])
    end
  else
    self.tip_text:SetLocalText("yuntieBattle_interface_1049", table.concat(tipStr, "/"))
  end
end

return LWActMeteoriteRankAwardView
