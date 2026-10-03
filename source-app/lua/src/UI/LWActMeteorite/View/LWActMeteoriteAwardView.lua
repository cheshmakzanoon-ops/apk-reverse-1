local LWActMeteoriteAwardView = BaseClass("LWActMeteoriteAwardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local MyInt = toInt
local LWActMeteoriteAwardBox = require("UI.LWActMeteorite.Component.LWActMeteoriteAwardBox")
local LWUIActMeteoriteAwardItemRenderer = require("UI.LWActMeteorite.Component.LWUIActMeteoriteAwardItemRenderer")
local closeBtn_path = "Common_bg_orange/CloseBtn"
local closeBg_path = "panel"
local t_info_btn_path = "Common_bg_orange/Common_bg_orange2/Up/TInfoBtn"
local coin_text_path = "Common_bg_orange/Common_bg_orange2/Up/CoinText"
local c_info_btn_path = "Common_bg_orange/Common_bg_orange2/Mid/CInfoBtn"
local jump_base_path = "Common_bg_orange/Common_bg_orange2/Down/Item"
local box_base_path = "Common_bg_orange/Common_bg_orange2/Up/Boxes/Box"
local slider_path = "Common_bg_orange/Common_bg_orange2/Up/Slider"
local point_base_path = "Common_bg_orange/Common_bg_orange2/Up/Slider/Point_%d/Num_%d"
local toggle_group_path = "Common_bg_orange/Common_bg_orange2/Up/ToggleGroup"
local toggle_item_path = "Common_bg_orange/Common_bg_orange2/Up/ToggleGroup/Toggle"
local left_btn_path = "Common_bg_orange/Common_bg_orange2/Up/leftBtn"
local right_btn_path = "Common_bg_orange/Common_bg_orange2/Up/rightBtn"
local PAGE_PER_NUM = 3
local sliderDataTb = {
  {
    num = 0,
    percent = 0,
    isHide = true
  },
  {num = 20, percent = 0.15},
  {num = 50, percent = 0.5},
  {num = 100, percent = 0.85}
}

function LWActMeteoriteAwardView:OnCreate()
  base.OnCreate(self)
  self.curPage = 1
  self.pageNum = 1
  self.close_btn = self:AddComponent(UIButton, closeBtn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closeBg = self:AddComponent(UIButton, closeBg_path)
  self.closeBg:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.t_info_btn = self:AddComponent(UIButton, t_info_btn_path)
  self.t_info_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    local actInfo = DataCenter.ActMeteoriteBattleManager:GetActInfo() or {}
    local strTip = Localization:GetString("yuntieBattle_tips_1004", actInfo.count or 0)
    local counts = actInfo.counts or {}
    local max = actInfo.grabLimit or 0
    local cur = actInfo.grabTimes or 0
    local stage = actInfo.stage or MeteoriteState.SHOW
    for i = 1, max do
      if i <= cur + 1 or stage == MeteoriteState.SHOW then
        strTip = strTip .. "\n" .. Localization:GetString("yuntieBattle_tips_1005", i, counts[i] or 0)
      else
        strTip = strTip .. "\n" .. Localization:GetString("yuntieBattle_tips_1006", i)
      end
    end
    UIUtil.ShowBubbleTips(strTip, self.t_info_btn.transform.position, 23 * CommonUtil.ArabicAutoMirrorFactor(), -30, 0)
  end)
  self.coin_text = self:AddComponent(UITextMeshProUGUIEx, coin_text_path)
  self.c_info_btn = self:AddComponent(UIButton, c_info_btn_path)
  self.c_info_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    local strTip = Localization:GetString("yuntieBattle_interface_1030")
    UIUtil.ShowBubbleTips(strTip, self.c_info_btn.transform.position, 0, -30, 0)
  end)
  self.rewardItemRenderers = {}
  for i = 1, 4 do
    local ir = self:AddComponent(LWUIActMeteoriteAwardItemRenderer, self.transform:Find(jump_base_path .. i).gameObject)
    if ir then
      table.insert(self.rewardItemRenderers, ir)
      ir:Setup({index = i, view = self})
    end
  end
  self.boxes = {}
  self.points = {}
  for i = 1, PAGE_PER_NUM do
    self.boxes[i] = self:AddComponent(LWActMeteoriteAwardBox, box_base_path .. i)
    self.points[i] = self:AddComponent(UITextMeshProUGUIEx, string.format(point_base_path, i, i))
  end
  self.toggle_group = self:AddComponent(UIBaseContainer, toggle_group_path)
  self.toggleItem = self.transform:Find(toggle_item_path).gameObject
  self.toggleItem:GameObjectCreatePool()
  self.toggleItem:SetActive(false)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.left_btn = self:AddComponent(UIButton, left_btn_path)
  self.left_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickLeftBtn()
  end)
  self.right_btn = self:AddComponent(UIButton, right_btn_path)
  self.right_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickRightBtn()
  end)
  self:InitToggle()
  self:UpdateCurPageNum()
end

function LWActMeteoriteAwardView:OnDestroy()
  self:RemoveToggle()
  self.close_btn = nil
  self.closeBg = nil
  self.t_info_btn = nil
  self.coin_text = nil
  self.c_info_btn = nil
  self.item1 = nil
  self.slider = nil
  self.toggle_group = nil
  self.toggleItem = nil
  self.left_btn = nil
  self.right_btn = nil
  self.boxes = {}
  self.points = {}
  self.toggles = {}
  base.OnDestroy(self)
end

function LWActMeteoriteAwardView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MeteoriteBattleRewardsRefresh, self.UpdateCurPage)
  self:AddUIListener(EventId.MeteoriteBattleScoreUpdate, self.UpdateScore)
end

function LWActMeteoriteAwardView:OnRemoveListener()
  self:RemoveUIListener(EventId.MeteoriteBattleRewardsRefresh, self.UpdateCurPage)
  self:RemoveUIListener(EventId.MeteoriteBattleScoreUpdate, self.UpdateScore)
  base.OnRemoveListener(self)
end

function LWActMeteoriteAwardView:JumpTo(idx)
  if idx == 1 then
    DataCenter.ActMeteoriteBattleManager:DoPointJump(nil, true)
  else
    DataCenter.ActMeteoriteBattleManager:ReqRandomPoint(98 + idx)
  end
end

function LWActMeteoriteAwardView:OnClickLeftBtn()
  if self.curPage <= 1 then
    return
  end
  self:ToggleOn(self.curPage - 1)
  self:RefreshToggles()
end

function LWActMeteoriteAwardView:OnClickRightBtn()
  if self.curPage >= self.pageNum then
    return
  end
  self:ToggleOn(self.curPage + 1)
  self:RefreshToggles()
end

function LWActMeteoriteAwardView:RemoveToggle()
  self.toggle_group:RemoveComponents(UIToggle)
  self.toggleItem:GameObjectRecycleAll()
  self.toggles = {}
end

function LWActMeteoriteAwardView:InitToggle()
  self:RemoveToggle()
  local mgr = DataCenter.ActMeteoriteBattleManager
  self.boxesConfig = mgr:GetRewardBoxes(1)
  self.pageNum = math.ceil(#self.boxesConfig / PAGE_PER_NUM)
  for i = 1, self.pageNum do
    local go = self.toggleItem:GameObjectSpawn(self.toggle_group.transform)
    go.name = "Toggle_" .. i
    self.toggles[i] = self.toggle_group:AddComponent(UIToggle, go.name)
    self.toggles[i]:SetOnValueChanged(function(bool)
      if bool then
        self:ToggleOn(i)
      end
    end)
  end
end

function LWActMeteoriteAwardView:ToggleOn(index, bForce)
  if not bForce and self.curPage == index then
    return
  end
  self.curPage = index
  self:RefreshGroupBoxes()
  self:RefreshLeftRightBtn()
  self:SetProgress()
end

function LWActMeteoriteAwardView:UpdateCurPageNum()
  local mgr = DataCenter.ActMeteoriteBattleManager
  local curIdx = 1
  for i, _ in ipairs(self.boxesConfig) do
    if mgr:GetBoxState(i) == 2 then
      curIdx = i
      break
    end
  end
  self.curPage = math.ceil(curIdx / PAGE_PER_NUM)
  self:RefreshToggles()
  self:UpdateCurPage()
end

function LWActMeteoriteAwardView:UpdateCurPage()
  self:ToggleOn(self.curPage, true)
end

function LWActMeteoriteAwardView:UpdateScore()
  self:RefreshGroupBoxes()
  self:SetProgress()
end

function LWActMeteoriteAwardView:RefreshGroupBoxes()
  for i = 1, PAGE_PER_NUM do
    local index = (self.curPage - 1) * PAGE_PER_NUM + i
    local config = self.boxesConfig[index]
    self.boxes[i]:SetBoxInfo(i, index, config)
  end
end

function LWActMeteoriteAwardView:RefreshLeftRightBtn()
  self.left_btn:SetActive(self.curPage > 1)
  self.right_btn:SetActive(self.curPage < self.pageNum)
end

function LWActMeteoriteAwardView:RefreshToggles()
  self.toggles[self.curPage]:SetIsOn(true)
end

function LWActMeteoriteAwardView:SetProgress()
  local actInfo = DataCenter.ActMeteoriteBattleManager:GetActInfo() or {}
  local curScore = actInfo.count or 0
  self.coin_text:SetText(string.GetFormattedSeparatorNum(curScore))
  local lastEndScore = 0
  local configIdx = (self.curPage - 1) * PAGE_PER_NUM
  if self.curPage > 1 then
    local config = self.boxesConfig[configIdx]
    lastEndScore = MyInt(config.para)
  end
  sliderDataTb[1].num = lastEndScore
  local config = self.boxesConfig[configIdx + 1]
  sliderDataTb[2].num = MyInt(config.para)
  config = self.boxesConfig[configIdx + 2]
  sliderDataTb[3].num = MyInt(config.para)
  config = self.boxesConfig[configIdx + 3]
  sliderDataTb[4].num = MyInt(config.para)
  for i, v in ipairs(self.points) do
    local data = sliderDataTb[i + 1]
    v:SetText(string.GetFormattedSeperatorNum(data.num) or "Err")
  end
  if curScore >= lastEndScore then
    local cnt = #sliderDataTb
    for i = cnt, 1, -1 do
      local cur = sliderDataTb[i]
      if curScore >= cur.num then
        if i == #sliderDataTb then
          self.slider:SetValue(1)
          do return end
          break
        end
        do
          local extraNum = curScore - cur.num
          local next = sliderDataTb[i + 1]
          local extraPercent = extraNum / (next.num - cur.num) * (next.percent - cur.percent)
          self.slider:SetValue(cur.percent + extraPercent)
        end
        break
      end
    end
  else
    self.slider:SetValue(0)
  end
end

function LWActMeteoriteAwardView:OpenRewardTips(index)
  if IsNull(self.gameObject) then
    return
  end
  local mgr = DataCenter.ActMeteoriteBattleManager
  local state = mgr:GetBoxState(index)
  if state ~= 2 then
    self:ShowRewardTips(index)
    return
  end
  local config = self.boxesConfig[index]
  mgr:ReqGetReward(config.id)
end

function LWActMeteoriteAwardView:ShowRewardTips(index)
  local newIndex = (index - 1) % PAGE_PER_NUM + 1
  DataCenter.ActMeteoriteBattleManager:ShowRewardTips(self.boxes[newIndex], self.boxesConfig[index], index, newIndex == 1)
end

return LWActMeteoriteAwardView
