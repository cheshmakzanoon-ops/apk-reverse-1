local UIWinterStormTaskS0View = BaseClass("UIWinterStormTaskS0View", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIWinterStormTaskS0Box = require("UI.UIActivityCenterTable.Component.ActWinterStorm.Task.Component.UIWinterStormTaskS0Box")
local ActMgr = DataCenter.ActWinterStormManager
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

function UIWinterStormTaskS0View:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIWinterStormTaskS0View:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWinterStormTaskS0View:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compBox1 = self.viewSkin:AddComponent(self, UIWinterStormTaskS0Box, 4)
  self.compBox2 = self.viewSkin:AddComponent(self, UIWinterStormTaskS0Box, 5)
  self.compBox3 = self.viewSkin:AddComponent(self, UIWinterStormTaskS0Box, 6)
  self.slider = self.viewSkin:AddComponent(self, UISlider, 7)
  self.textNum1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textNum2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textNum3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.compPoint1 = self.viewSkin:AddComponent(self, UIBaseComponent, 11)
  self.compPoint2 = self.viewSkin:AddComponent(self, UIBaseComponent, 12)
  self.compPoint3 = self.viewSkin:AddComponent(self, UIBaseComponent, 13)
  self.compToggle = self.viewSkin:AddComponent(self, UIBaseComponent, 14)
  self.compList = self.viewSkin:AddComponent(self, UIBaseComponent, 15)
  self.compToggleGroup = self.viewSkin:AddComponent(self, UIBaseContainer, 16)
  self.btnLeft = self.viewSkin:AddComponent(self, UIButton, 17)
  self.btnLeft:SetOnClick(function()
    self:OnBtnLeftClick()
  end)
  self.btnRight = self.viewSkin:AddComponent(self, UIButton, 18)
  self.btnRight:SetOnClick(function()
    self:OnBtnRightClick()
  end)
  self.btnMid = self.viewSkin:AddComponent(self, UIButton, 19)
  self.btnMid:SetOnClick(function()
    self:OnBtnMidClick()
  end)
  self.textBoxDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 20)
  self.textTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 21)
  self.textInfo = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 22)
end

function UIWinterStormTaskS0View:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.btnClose = nil
  self.textScore = nil
  self.compBox1 = nil
  self.compBox2 = nil
  self.compBox3 = nil
  self.slider = nil
  self.textNum1 = nil
  self.textNum2 = nil
  self.textNum3 = nil
  self.compPoint1 = nil
  self.compPoint2 = nil
  self.compPoint3 = nil
  self.compToggle = nil
  self.compList = nil
  self.compToggleGroup = nil
  self.btnLeft = nil
  self.btnRight = nil
  self.btnMid = nil
  self.textBoxDesc = nil
  self.textTip = nil
  self.textInfo = nil
end

function UIWinterStormTaskS0View:DataDefine()
  local num = LuaEntry.DataConfig:GetValue("winter_bf_S0", "k2", 0)
  self.textTip:SetLocalText("winter_s0_win_rate_tips", "<sprite=0>", "\195\151" .. num)
  self.textInfo:SetLocalText("winter_s0_tips_3", "<sprite=0>")
  self.taskList = ActMgr:CreateTaskListAsync(self, self.compList, function()
    if self.taskList ~= nil then
      self.taskList:SetAnchoredPositionXY(0, 0)
      self.taskList:ShowBase()
    end
  end)
  self.boxes = {
    self.compBox1,
    self.compBox2,
    self.compBox3
  }
  self.points = {
    self.compPoint1,
    self.compPoint2,
    self.compPoint3
  }
  self.texts = {
    self.textNum1,
    self.textNum2,
    self.textNum3
  }
  local _, _, _, btnKey = RaceEntranceUtil.GetOpenShow(EnumActivity.ActWinterStorm.Type)
  local canFlag = btnKey == "winter_battlefield_interface_tips1011"
  CS.UIGray.SetGray(self.btnMid.transform, not canFlag, canFlag)
  self.roundMax = LuaEntry.DataConfig:TryGetNum("winter_bf_S0", "k1", 0)
  local configList, roundScore = ActMgr:GetRewardTemplates()
  self.boxesConfig = configList
  self.textBoxDesc:SetLocalText("winter_s0_tips_4", roundScore)
  self.curPage = 1
  self.pageNum = math.ceil(#configList / PAGE_PER_NUM)
  self.toggles = {}
  self.compToggle.gameObject:GameObjectCreatePool()
  self.compToggle:SetActive(false)
  for i = 1, self.pageNum do
    local go = self.compToggle.gameObject:GameObjectSpawn(self.compToggleGroup.transform)
    go.name = "Toggle_" .. i
    local toggle = self.compToggleGroup:AddComponent(UIToggle, go.name)
    toggle:SetOnValueChanged(function(bool)
      if bool then
        self:ToggleOn(i)
      end
    end)
    self.toggles[i] = toggle
  end
  local curIdx = 1
  for i, _ in ipairs(self.boxesConfig) do
    if self:GetBoxState(i) == 2 then
      curIdx = i
      break
    end
  end
  self.curPage = math.ceil(curIdx / PAGE_PER_NUM)
  self:RefreshToggles()
  self:UpdateCurPage()
  DataCenter.ActWinterStormManager:ReqRewardInfo()
end

function UIWinterStormTaskS0View:DataDestroy()
  self.taskList = nil
  self.taskDetailList = nil
  if self.delayRefresh then
    self.delayRefresh:Stop()
    self.delayRefresh = nil
  end
  self.compToggleGroup:RemoveComponents(UIToggle)
  self.compToggle.gameObject:GameObjectRecycleAll()
  self.toggles = nil
  self.curPage = 1
  self.pageNum = 1
end

function UIWinterStormTaskS0View:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.WinterStormTaskDetailShow, self.ShowTaskDetail)
  self:AddUIListener(EventId.WinterStormRewardInfo, self.UpdateCurPage)
end

function UIWinterStormTaskS0View:OnRemoveListener()
  self:RemoveUIListener(EventId.WinterStormTaskDetailShow, self.ShowTaskDetail)
  self:RemoveUIListener(EventId.WinterStormRewardInfo, self.UpdateCurPage)
  base.OnRemoveListener(self)
end

function UIWinterStormTaskS0View:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIWinterStormTaskS0View:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIWinterStormTaskS0View:OnBtnLeftClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.curPage <= 1 then
    return
  end
  self:ToggleOn(self.curPage - 1)
  self:RefreshToggles()
end

function UIWinterStormTaskS0View:OnBtnRightClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.curPage >= self.pageNum then
    return
  end
  self:ToggleOn(self.curPage + 1)
  self:RefreshToggles()
end

function UIWinterStormTaskS0View:OnBtnMidClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  ActMgr:SendMatch()
  self.ctrl:CloseSelf()
end

function UIWinterStormTaskS0View:RefreshToggles()
  self.toggles[self.curPage]:SetIsOn(true)
end

function UIWinterStormTaskS0View:UpdateCurPage()
  self:ToggleOn(self.curPage, true)
end

function UIWinterStormTaskS0View:UpdateScore()
  self:RefreshGroupBoxes()
  self:SetProgress()
end

function UIWinterStormTaskS0View:RefreshGroupBoxes()
  local haveEmpty = false
  for i = 1, PAGE_PER_NUM do
    local box = self.boxes[i]
    local index = (self.curPage - 1) * PAGE_PER_NUM + i
    local config = self.boxesConfig[index]
    if config == nil then
      box:SetActive(false)
      haveEmpty = true
    else
      box:SetActive(true)
      box:SetBoxInfo(self, i, index, config)
    end
  end
  self.textBoxDesc:SetActive(haveEmpty)
end

function UIWinterStormTaskS0View:RefreshLeftRightBtn()
  self.btnLeft:SetActive(self.curPage > 1)
  self.btnRight:SetActive(self.curPage < self.pageNum)
end

function UIWinterStormTaskS0View:SetProgress()
  local curScore = self:GetCurScore()
  self.textScore:SetText(string.GetFormattedSeparatorNum(curScore))
  local lastEndScore = 0
  local index = (self.curPage - 1) * PAGE_PER_NUM
  local lastConfig = self.boxesConfig[index]
  local config = self.boxesConfig[index + 1]
  if ActMgr:IsRoundBox(config) then
    local round = ActMgr:GetRound()
    lastEndScore = lastConfig.score + round * config.score
    sliderDataTb[1].num = lastEndScore
    sliderDataTb[2].num = -1
    sliderDataTb[3].num = -1
    sliderDataTb[4].num = config.score
  else
    if self.curPage > 1 then
      lastEndScore = lastConfig.score
    end
    sliderDataTb[1].num = lastEndScore
    sliderDataTb[2].num = config.score
    config = self.boxesConfig[index + 2]
    sliderDataTb[3].num = config ~= nil and config.score or -1
    config = self.boxesConfig[index + 3]
    sliderDataTb[4].num = config ~= nil and config.score or -1
  end
  for i, v in ipairs(self.points) do
    local realI = i + 1
    local data = sliderDataTb[realI]
    local num = data ~= nil and data.num or 0
    v:SetActive(0 <= num)
    if 0 <= num then
      local text = self.texts[i]
      text:SetText(string.GetFormattedSeperatorNum(data.num))
    end
  end
  if curScore >= lastEndScore then
    local cnt = #sliderDataTb
    for i = cnt, 1, -1 do
      local cur = sliderDataTb[i]
      if curScore >= cur.num and 0 <= cur.num then
        if i == #sliderDataTb then
          self.slider:SetValue(1)
          do return end
          break
        end
        do
          local extraNum = curScore - cur.num
          local next
          local nextIdx = i + 1
          while true do
            next = sliderDataTb[nextIdx]
            if next == nil or 0 <= next.num then
              break
            end
            nextIdx = nextIdx + 1
          end
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

function UIWinterStormTaskS0View:OpenRewardTips(index)
  if IsNull(self.gameObject) then
    return
  end
  local state = self:GetBoxState(index)
  if state ~= 2 then
    self:ShowRewardTips(index)
    return
  end
  local config = self.boxesConfig[index]
  ActMgr:ReqGetReward(config.id)
end

function UIWinterStormTaskS0View:ShowRewardTips(index)
  local newIndex = (index - 1) % PAGE_PER_NUM + 1
  local target = self.boxes[newIndex]
  local config = self.boxesConfig[index]
  local x = target.transform.position.x
  local y = target.transform.position.y
  local width = target.rectTransform.rect.width
  local bLeft = newIndex == 1 and not ActMgr:IsRoundBox(config)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityRewardTip, Localization:GetString("370101", config.value), EnumActivity.ActWinterStorm.Type, x, y, bLeft, index, width)
end

function UIWinterStormTaskS0View:ToggleOn(index, bForce)
  if not bForce and self.curPage == index then
    return
  end
  self.curPage = index
  self:RefreshGroupBoxes()
  self:RefreshLeftRightBtn()
  self:SetProgress()
end

function UIWinterStormTaskS0View:GetBoxState(index)
  return ActMgr:GetBoxState(self.boxesConfig[index], self:GetCurScore(), 0)
end

function UIWinterStormTaskS0View:GetCurScore()
  local info = ActMgr:GetRewardInfo()
  return info.score or 0
end

function UIWinterStormTaskS0View:GetRoundCanGetCnt()
  return ActMgr:GetRoundCanGetCnt(self:GetCurScore())
end

function UIWinterStormTaskS0View:ShowTaskDetail(pointType)
  if pointType == nil or pointType == BF_RewardPointType.None then
    if self.taskDetailList then
      self.taskDetailList:SetActive(false)
    end
    return
  end
  if self.taskDetailList == nil then
    self.taskDetailList = ActMgr:CreateTaskDetailListAsync(self, self.compList, function()
      if self.taskDetailList ~= nil then
        self.taskDetailList:SetAnchoredPositionXY(0, 0)
      end
    end)
  end
  self.taskDetailList:ShowDetail(pointType)
end

return UIWinterStormTaskS0View
