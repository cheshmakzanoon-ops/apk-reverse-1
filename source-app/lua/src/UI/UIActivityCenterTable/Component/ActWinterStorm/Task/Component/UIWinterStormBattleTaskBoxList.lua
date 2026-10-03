local base = UIAsyncContainer
local UIWinterStormBattleTaskBoxList = BaseClass("UIWinterStormBattleTaskBoxList", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local UIWinterStormBattleTaskBox = require("UI.UIActivityCenterTable.Component.ActWinterStorm.Task.Component.UIWinterStormBattleTaskBox")
local ActMgr = DataCenter.ActWinterStormManager
local BOX_PREFAB = "Assets/Main/Prefabs/UI/ActivityCenter/WinterStorm/S0/UIWinterStormBattleTaskBox.prefab"
local MAX_PAGE = 2

function UIWinterStormBattleTaskBoxList:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIWinterStormBattleTaskBoxList:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWinterStormBattleTaskBoxList:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compBoxesDi = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.slider = self.viewSkin:AddComponent(self, UISlider, 2)
  self.sliderAdd = self.viewSkin:AddComponent(self, UISlider, 3)
  self.compBoxes = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.btnLeft = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnLeft:SetOnClick(function()
    self:OnBtnLeftClick()
  end)
  self.btnRight = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnRight:SetOnClick(function()
    self:OnBtnRightClick()
  end)
  self.compDi = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.compCntBg = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.textNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.btnBox = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnBox:SetOnClick(function()
    self:OnBtnBoxClick()
  end)
  self.compCur = self.viewSkin:AddComponent(self, UIBaseContainer, 11)
  self.textCur = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
end

function UIWinterStormBattleTaskBoxList:ComponentDestroy()
  self.viewSkin = nil
  self.compBoxesDi = nil
  self.slider = nil
  self.sliderAdd = nil
  self.compBoxes = nil
  self.btnLeft = nil
  self.btnRight = nil
  self.compDi = nil
  self.compCntBg = nil
  self.textNum = nil
  self.btnBox = nil
  self.compCur = nil
  self.textCur = nil
end

function UIWinterStormBattleTaskBoxList:DataDefine()
  self.roundMax = LuaEntry.DataConfig:TryGetNum("winter_bf_S0", "k1", 0)
  local configList, roundScore = ActMgr:GetRewardTemplates()
  self.boxesConfig = configList
  self.pageNum = 0 < roundScore and MAX_PAGE or 1
  self.curPage = self.pageNum
  self.diList = {}
  self.boxList = {}
  self.compDi.gameObject:GameObjectCreatePool()
  self.compDi:SetActive(false)
  if self.curPage == MAX_PAGE then
    for _, config in ipairs(self.boxesConfig) do
      if not ActMgr:IsRoundBox(config) and self:GetBoxState(config) ~= 3 then
        self.curPage = 1
        break
      end
    end
  end
end

function UIWinterStormBattleTaskBoxList:DataDestroy()
  if self.tweenAdd then
    self.tweenAdd:Kill()
    self.tweenAdd = nil
  end
  self.compDi.gameObject:GameObjectRecycleAll()
  self.diList = nil
  self.boxList = nil
  self.curPage = 1
  self.pageNum = 1
end

function UIWinterStormBattleTaskBoxList:OnAddListener()
  base.OnAddListener(self)
end

function UIWinterStormBattleTaskBoxList:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIWinterStormBattleTaskBoxList:OnBtnLeftClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.curPage <= 1 then
    return
  end
  self:ToggleOn(self.curPage - 1)
end

function UIWinterStormBattleTaskBoxList:OnBtnRightClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.curPage >= self.pageNum then
    return
  end
  self:ToggleOn(self.curPage + 1)
end

function UIWinterStormBattleTaskBoxList:OnBtnBoxClick()
  UIUtil.ShowTipsId("winter_s0_tips_14")
end

function UIWinterStormBattleTaskBoxList:UpdateCurPage()
  self:ToggleOn(self.curPage, true)
end

function UIWinterStormBattleTaskBoxList:UpdateScore()
  self:RefreshGroupBoxes()
  self:SetProgress()
  self:RefreshLeftRightBtn()
end

function UIWinterStormBattleTaskBoxList:RefreshLeftRightBtn()
  self.btnLeft:SetActive(self.curPage > 1)
  local bMax = 1 <= self.slider:GetValue() or 1 <= self.sliderAdd:GetValue()
  self.btnRight:SetActive(self.curPage < self.pageNum and bMax)
end

function UIWinterStormBattleTaskBoxList:GetConfig(idx)
  local l = #self.boxesConfig
  if self.curPage == 1 then
    return self.boxesConfig[idx]
  else
    return self.boxesConfig[l]
  end
end

function UIWinterStormBattleTaskBoxList:RefreshGroupBoxes()
  local lBox = #self.boxList
  local lConfig = #self.boxesConfig
  local lrc = 1
  if 1 < self.pageNum then
    lrc = self.curPage == 1 and lConfig - 1 or 1
  else
    lrc = lConfig
  end
  local max = math.max(lBox, lrc)
  for i = 1, max do
    local di = self.diList[i]
    local box = self.boxList[i]
    local config = self:GetConfig(i)
    if config ~= nil then
      if not di then
        di = self.compDi.gameObject:GameObjectSpawn(self.compBoxesDi.transform)
        di.name = "Di" .. i
        self.diList[i] = di
      end
      if not box then
        box = self:LoadComponentAsync(UIWinterStormBattleTaskBox, BOX_PREFAB, self.compBoxes)
        self.boxList[i] = box
      end
      local state = self:GetBoxState(config)
      di:SetActive(state == 3)
      box:ReInit(i, config, state)
    else
      if di then
        di:SetActive(false)
      end
      if box then
        box:SetActive(false)
      end
    end
  end
  local textBoxDesc = self.view.textBoxDesc
  if textBoxDesc then
    textBoxDesc:SetActive(lrc == 1)
  end
  if lrc == 1 then
    local config = self:GetConfig(1)
    local cnt, left = self:GetRoundCanGetCnt()
    if textBoxDesc then
      local str = string.format("%s{%s/%s}", Localization:GetString("winter_s0_tips_4", config.score), left, config.score)
      textBoxDesc:SetText(str)
    end
    self.compCntBg:SetActive(0 < cnt)
    if 0 < cnt then
      self.textNum:SetText(cnt)
    end
  else
    self.compCntBg:SetActive(false)
  end
end

function UIWinterStormBattleTaskBoxList:SetProgress()
  local curScore = self:GetCurScore()
  local preAdd = self:GetFakeAdd()
  local textInfo = self.view.textInfo
  if textInfo then
    textInfo:SetLocalText("winter_s0_tips_8", preAdd .. "<sprite=0>")
  end
  local preScore = preAdd + curScore
  local lastEndScore, maxScore, lrc = 0, 0, 0
  local lConfig = #self.boxesConfig
  local config
  if self.curPage == 1 then
    lrc = 1 < self.pageNum and lConfig - 1 or lConfig
    config = self.boxesConfig[lrc] or {}
    maxScore = config.score
    if curScore >= maxScore then
      self.showIdx = -1
      self.slider:SetValue(1)
      self.compCur:SetActive(false)
      return
    end
  else
    self.showIdx = -1
    self.compCur:SetActive(false)
    lrc = 1
    config = self.boxesConfig[lConfig] or {}
    local lastConfig = self.boxesConfig[lConfig - 1] or {}
    local round = ActMgr:GetRound()
    lastEndScore = (lastConfig.score or 0) + round * config.score
    maxScore = config.score
    local left = curScore - lastEndScore
    if maxScore <= left then
      self.slider:SetValue(1)
      self.sliderAdd:SetValue(0)
      return
    end
  end
  local curPer, prePer = 0, -1
  if preScore == curScore then
    prePer = 0
  end
  if lrc == 1 then
    self.showIdx = -1
    curPer = Mathf.Clamp((curScore - lastEndScore) / maxScore, 0, 1)
    if prePer == -1 then
      prePer = Mathf.Clamp((preScore - lastEndScore) / maxScore, 0, 1)
    end
  else
    local percent = 0.167
    for i = lrc, 0, -1 do
      local cur = self.boxesConfig[i]
      local curS = cur ~= nil and cur.score or 0
      local next = self.boxesConfig[i + 1]
      if prePer == -1 and preScore > curS then
        if i == lrc then
          prePer = 1
        else
          local extraNum = preScore - curS
          local extraPercent = extraNum / (next.score - curS) * percent
          prePer = math.min(percent * i + extraPercent, 1)
        end
        self.showIdx = i
      end
      if curScore > curS then
        local extraNum = curScore - curS
        local extraPercent = extraNum / (next.score - curS) * percent
        curPer = math.min(percent * i + extraPercent, 1)
        break
      end
    end
  end
  self.slider:SetValue(curPer)
  self.sliderAdd:SetValue(prePer)
  self.compCur:SetActive(curPer < 1)
  if self.compCur:GetActive() then
    local y = self.compCur:GetAnchoredPositionY()
    local w = self.slider.rectTransform.rect.width
    if prePer == 0 then
      self.compCur:SetAnchoredPositionXY(30 + w * curPer, y)
    else
      self.compCur:SetAnchoredPositionXY(30 + w * prePer, y)
    end
    self.textCur:SetText(string.GetFormattedSeparatorNum(preScore))
  end
end

function UIWinterStormBattleTaskBoxList:ToggleOn(index, bForce)
  if not bForce and self.curPage == index then
    return
  end
  self.curPage = index
  self:UpdateScore()
end

function UIWinterStormBattleTaskBoxList:GetBoxState(config)
  return ActMgr:GetBoxState(config, self:GetCurScore(), self:GetFakeAdd())
end

function UIWinterStormBattleTaskBoxList:GetCurScore()
  if self.data ~= nil then
    return self.data.curScore or 0
  end
  local info = ActMgr:GetRewardInfo()
  return info.score or 0
end

function UIWinterStormBattleTaskBoxList:GetRoundCanGetCnt()
  return ActMgr:GetRoundCanGetCnt(self:GetCurScore())
end

function UIWinterStormBattleTaskBoxList:GetPreAdd()
  if self.data ~= nil then
    return self.data.preAdd or 0
  end
  return 0
end

function UIWinterStormBattleTaskBoxList:GetFakeAdd()
  return self.fakeAdd == nil and self:GetPreAdd() or self.fakeAdd
end

function UIWinterStormBattleTaskBoxList:SetData(data)
  self.data = data
  self.fakeAdd = nil
  self:RefreshView()
end

function UIWinterStormBattleTaskBoxList:UpdateData()
  if self.data == nil then
    return
  end
  local data = self.data
  self.compCur:SetActive(false)
  local preAdd = self:GetPreAdd()
  if self.tweenAdd then
    self.tweenAdd:Kill()
    self.tweenAdd = nil
  end
  if preAdd ~= 0 then
    local sequence = DOTween.Sequence()
    sequence:Append(DOTween.To(function(x)
      self.fakeAdd = math.floor(x)
      self:RefreshGroupBoxes()
      self:SetProgress()
    end, 0, preAdd, 1.2))
    if data.finalAdd then
      sequence:AppendInterval(data.delay or 0.8)
      sequence:Append(DOTween.To(function(x)
        self.fakeAdd = math.floor(x)
        self:RefreshGroupBoxes()
        self:SetProgress()
      end, preAdd, data.finalAdd, 1.2))
    end
    sequence:OnComplete(function()
      local box = self.showIdx and self.boxList[self.showIdx + 1] or nil
      if box ~= nil then
        box:ShowScore()
      end
    end)
    self.tweenAdd = sequence
  else
    self.fakeAdd = 0
  end
  self:UpdateCurPage()
end

return UIWinterStormBattleTaskBoxList
