local base = UIAsyncContainer
local LLNineBoxList = BaseClass("LLNineBoxList", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local LLNineBoxItem = require("UI.LandlordBattle.NineBoxes.Component.LLNineBoxItem")
local ActMgr = DataCenter.LandlordMgr
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

function LLNineBoxList:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLNineBoxList:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLNineBoxList:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compToggle = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.compBox3 = self.viewSkin:AddComponent(self, LLNineBoxItem, 2)
  self.compBox2 = self.viewSkin:AddComponent(self, LLNineBoxItem, 3)
  self.compBox1 = self.viewSkin:AddComponent(self, LLNineBoxItem, 4)
  self.slider = self.viewSkin:AddComponent(self, UISlider, 5)
  self.textNum3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textNum1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textNum2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.compToggleGroup = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.textCurScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.btnLeft = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnLeft:SetOnClick(function()
    self:OnBtnLeftClick()
  end)
  self.btnRight = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnRight:SetOnClick(function()
    self:OnBtnRightClick()
  end)
  self.compBoxList = {
    self.compBox1,
    self.compBox2,
    self.compBox3
  }
  self.textNumList = {
    self.textNum1,
    self.textNum2,
    self.textNum3
  }
end

function LLNineBoxList:ComponentDestroy()
  self.viewSkin = nil
  self.compToggle = nil
  self.compBox3 = nil
  self.compBox2 = nil
  self.compBox1 = nil
  self.slider = nil
  self.textNum3 = nil
  self.textNum1 = nil
  self.textNum2 = nil
  self.compToggleGroup = nil
  self.textCurScore = nil
  self.btnLeft = nil
  self.btnRight = nil
  self.compBoxList = nil
  self.textNumList = nil
end

function LLNineBoxList:DataDefine()
  self.toggles = {}
  self.toggleItem = self.compToggle.gameObject
  self.toggleItem:GameObjectCreatePool()
  self.toggleItem:SetActive(false)
  self:InitToggle()
  self:UpdateCurPageNum()
end

function LLNineBoxList:DataDestroy()
  self.compToggleGroup:RemoveComponents(UIToggle)
  self.toggleItem:GameObjectRecycleAll()
  self.toggleItem = nil
  self.toggles = nil
end

function LLNineBoxList:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LandlordNineBoxRefresh, self.UpdateScore)
end

function LLNineBoxList:OnRemoveListener()
  self:RemoveUIListener(EventId.LandlordNineBoxRefresh, self.UpdateScore)
  base.OnRemoveListener(self)
end

function LLNineBoxList:OnBtnLeftClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.curPage <= 1 then
    return
  end
  self:ToggleOn(self.curPage - 1)
  self:RefreshToggles()
end

function LLNineBoxList:OnBtnRightClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.curPage >= self.pageNum then
    return
  end
  self:ToggleOn(self.curPage + 1)
  self:RefreshToggles()
end

function LLNineBoxList:InitToggle()
  self.boxesConfig = ActMgr:GetNieBoxConfig()
  self.pageNum = math.ceil(#self.boxesConfig / PAGE_PER_NUM)
  for i = 1, self.pageNum do
    local go = self.toggleItem:GameObjectSpawn(self.compToggleGroup.transform)
    go.name = "Toggle_" .. i
    self.toggles[i] = self.compToggleGroup:AddComponent(UIToggle, go.name)
    self.toggles[i]:SetOnValueChanged(function(bool)
      if bool then
        self:ToggleOn(i)
      end
    end)
  end
end

function LLNineBoxList:ToggleOn(index, bForce)
  if not bForce and self.curPage == index then
    return
  end
  self.curPage = index
  self.btnLeft:SetActive(self.curPage > 1)
  self.btnRight:SetActive(self.curPage < self.pageNum)
  self:RefreshGroupBoxes()
  self:SetProgress()
end

function LLNineBoxList:UpdateCurPageNum()
  local curIdx = 1
  for i, _ in ipairs(self.boxesConfig) do
    if ActMgr:GetNineBoxState(i) == 2 then
      curIdx = i
      break
    end
  end
  self.curPage = math.ceil(curIdx / PAGE_PER_NUM)
  self:RefreshToggles()
  self:UpdateCurPage()
end

function LLNineBoxList:UpdateCurPage()
  self:ToggleOn(self.curPage, true)
end

function LLNineBoxList:UpdateScore()
  self:RefreshGroupBoxes()
  self:SetProgress()
end

function LLNineBoxList:RefreshGroupBoxes()
  for i = 1, PAGE_PER_NUM do
    local index = (self.curPage - 1) * PAGE_PER_NUM + i
    local config = self.boxesConfig[index]
    self.compBoxList[i]:SetBoxInfo(index, config)
  end
end

function LLNineBoxList:RefreshToggles()
  self.toggles[self.curPage]:SetIsOnWithoutNotify(true)
end

function LLNineBoxList:SetProgress()
  local curScore = ActMgr:GetNineBoxScore()
  self.textCurScore:SetText(string.GetFormattedSeparatorNum(curScore))
  local lastEndScore = 0
  local configIdx = (self.curPage - 1) * PAGE_PER_NUM
  if self.curPage > 1 then
    local config = self.boxesConfig[configIdx]
    lastEndScore = config.target or 0
  end
  sliderDataTb[1].num = lastEndScore
  local config = self.boxesConfig[configIdx + 1]
  sliderDataTb[2].num = config.target or 0
  config = self.boxesConfig[configIdx + 2]
  sliderDataTb[3].num = config.target or 0
  config = self.boxesConfig[configIdx + 3]
  sliderDataTb[4].num = config.target or 0
  for i, v in ipairs(self.textNumList) do
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

return LLNineBoxList
