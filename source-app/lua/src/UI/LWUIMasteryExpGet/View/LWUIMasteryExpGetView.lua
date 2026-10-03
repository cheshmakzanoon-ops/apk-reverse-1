local LWUIMasteryExpGetView = BaseClass("LWUIMasteryExpGetView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local slider_path = "JumpBtn/Slider"
local progress_path = "JumpBtn/Slider/SliderText"
local fill_img_path = "JumpBtn/Slider/Fill Area/Fill"
local level_txt_path = "JumpBtn/LevelTxt"
local exp_num_txt_path = "JumpBtn/ExpNumTxt"
local exp_rate_txt_path = "JumpBtn/ExpRateTxt"
local fill_base_path = "JumpBtn/Slider/Fill Area/FillBase"
local selectHomeIcon_path = "JumpBtn/CardImg/selectHomeIcon"
local eff_ui_saiji_beijing_faguang_path = "JumpBtn/Eff_ui_saiji_beijing_faguang "
local eff_ui_saiji_jingyantiao_shanshuo_path = "JumpBtn/Slider/Eff_ui_saiji_jingyantiao_shanshuo"
local eff_ui_saiji_shengji_dengji_faguang_path = "JumpBtn/CardImg/Eff_ui_saiji_shengji_dengji_faguang"
local eff_ui_saiji_shengji_levelup_path = "JumpBtn/Eff_ui_saiji_shengji_Levelup"
local eff_ui_saiji_shengji_shuzi_faguang_path = "JumpBtn/Eff_ui_saiji_shengji_shuzi_faguang"
local TWEEN_TIME = 1
local OneLevelTweenNum = 20
local CloseWaiteTime = 3
local aniState = {PlayAni = 1, WaiteClose = 2}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.progress_txt = self:AddComponent(UIText, progress_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.fill_img = self:AddComponent(UIImage, fill_img_path)
  self.level_txt = self:AddComponent(UIText, level_txt_path)
  self.exp_num_txt = self:AddComponent(UIText, exp_num_txt_path)
  self.exp_rate_txt = self:AddComponent(UIText, exp_rate_txt_path)
  self.fill_base = self:AddComponent(UIImage, fill_base_path)
  self.selectHomeIcon = self:AddComponent(UIImage, selectHomeIcon_path)
  self.eff_ui_saiji_beijing_faguang = self:AddComponent(UIBaseContainer, eff_ui_saiji_beijing_faguang_path)
  self.eff_ui_saiji_jingyantiao_shanshuo = self:AddComponent(UIBaseContainer, eff_ui_saiji_jingyantiao_shanshuo_path)
  self.eff_ui_saiji_shengji_shuzi_faguang = self:AddComponent(UIBaseContainer, eff_ui_saiji_shengji_shuzi_faguang_path)
  self.eff_ui_saiji_shengji_dengji_faguang = self:AddComponent(UIBaseContainer, eff_ui_saiji_shengji_dengji_faguang_path)
  self.eff_ui_saiji_shengji_levelup = self:AddComponent(UIBaseContainer, eff_ui_saiji_shengji_levelup_path)
  self.eff_ui_saiji_shengji_dengji_faguang:SetActive(false)
  self.eff_ui_saiji_shengji_levelup:SetActive(false)
end

local function ComponentDestroy(self)
  self.progress_txt = nil
  self.slider = nil
  self.fill_img = nil
  self.level_txt = nil
  self.exp_num_txt = nil
  self.exp_rate_txt = nil
  self.fill_base = nil
  self.selectHomeIcon = nil
  self.eff_ui_saiji_beijing_faguang = nil
  self.eff_ui_saiji_jingyantiao_shanshuo = nil
  self.eff_ui_saiji_shengji_shuzi_faguang = nil
  self.eff_ui_saiji_shengji_dengji_faguang = nil
  self.eff_ui_saiji_shengji_levelup = nil
end

local function DataDefine(self)
  self.aniSeq = nil
  self.closeTimer = nil
end

local function DataDestroy(self)
  self:MoveTimerAndAniSeq()
end

local function ReInit(self)
  self:MoveTimerAndAniSeq()
  self.msgData = self:GetUserData()
  self.curState = aniState.PlayAni
  local maxLevel = DataCenter.MasteryManager:GetMaxLevel()
  local msgData = self.msgData
  local preLv = msgData.oldLevel
  local preExp = msgData.oldExp
  local curLv = msgData.level
  local curExp = msgData.exp
  if maxLevel <= preLv then
    preLv = maxLevel
    preExp = 0
  end
  if maxLevel <= curLv then
    curLv = maxLevel
    curExp = 0
  end
  self.playingLv = preLv
  local baseLvMaxExp = DataCenter.MasteryManager:GetLevelMaxExp(preLv)
  self.progress_txt:SetText(string.GetFormattedSeparatorNum(preExp) .. "/" .. string.GetFormattedSeparatorNum(baseLvMaxExp))
  self.slider:SetValue(preExp / baseLvMaxExp)
  self.level_txt:SetText(preLv)
  local addExp = 0
  local addExprate = 0
  if preLv == curLv then
    addExp = curExp - preExp
    addExprate = addExp / baseLvMaxExp
  else
    for i = preLv, curLv do
      local lvMaxExp = DataCenter.MasteryManager:GetLevelMaxExp(i)
      if i == preLv then
        addExp = addExp + (lvMaxExp - preExp)
        addExprate = addExprate + (1 - preExp / lvMaxExp)
      elseif i == curLv then
        addExp = addExp + curExp
        addExprate = addExprate + curExp / lvMaxExp
      else
        addExp = addExp + lvMaxExp
        addExprate = addExprate + 1
      end
    end
  end
  self.exp_num_txt:SetText("+" .. string.GetFormattedSeparatorNum(msgData.addExp))
  local addExpRate = string.format("%.2f", addExprate * 100)
  self.exp_rate_txt:SetText("+" .. addExpRate .. "%")
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.slider.transform)
  local baseWidth = self.fill_img.rectTransform.rect.width
  local sizedelta = self.fill_base:GetSizeDelta()
  self.fill_base:SetSizeDeltaXY(baseWidth, sizedelta.y)
  self.fill_base:SetActive(true)
  self:RefreshSelectHomeIcon()
  self:TryState()
end

local function RefreshSelectHomeIcon(self)
  local iconPath = string.format(LoadPath.ItemPath, "icon_zhuanjinghuobi")
  local masteryData = DataCenter.MasteryManager:GetData()
  local homeId = masteryData.home_id
  local showTemp = DataCenter.MasteryManager:GetHomeShowTempByHomeId(homeId)
  if showTemp then
    iconPath = showTemp:GetIconFullPath()
  end
  self.selectHomeIcon:LoadSprite(iconPath)
end

local function TryState(self)
  self:MoveTimerAndAniSeq()
  local maxLevel = DataCenter.MasteryManager:GetMaxLevel()
  local msgData = self.msgData
  local preLv = msgData.oldLevel
  local preExp = msgData.oldExp
  local curLv = msgData.level
  local curExp = msgData.exp
  if maxLevel <= preLv then
    preLv = maxLevel
    preExp = 0
  end
  if maxLevel <= curLv then
    curLv = maxLevel
    curExp = 0
  end
  if self.curState == aniState.PlayAni then
    if curLv < self.playingLv then
      self.curState = aniState.WaiteClose
      self.fill_base:SetActive(preLv == curLv)
      local playingLvMaxExp = DataCenter.MasteryManager:GetLevelMaxExp(curLv)
      self.progress_txt:SetText(curExp .. "/" .. playingLvMaxExp)
      self.slider:SetValue(curExp / playingLvMaxExp)
      self.level_txt:SetText(curLv)
      self.closeTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.view.ctrl:CloseSelf(false)
      end, CloseWaiteTime)
    elseif self.playingLv == preLv then
      local playingLvMaxExp = DataCenter.MasteryManager:GetLevelMaxExp(self.playingLv)
      local oneCeil = 1 / OneLevelTweenNum
      local oneCeilTime = oneCeil * TWEEN_TIME
      local startRate = preExp / playingLvMaxExp
      local endRate = 1
      if self.playingLv == curLv then
        endRate = curExp / playingLvMaxExp
      else
        endRate = 1
      end
      local aniNum = math.ceil((endRate - startRate) / oneCeil)
      self.aniSeq = DOTween.Sequence()
      for i = 1, aniNum do
        local targetRate = startRate + i * oneCeil
        if endRate < targetRate then
          targetRate = endRate
        end
        local targetNum = math.floor(playingLvMaxExp * targetRate)
        self.aniSeq:AppendCallback(function()
          self.slider:DOValue(targetRate, oneCeilTime)
        end)
        self.aniSeq:AppendInterval(oneCeilTime)
        self.aniSeq:AppendCallback(function()
          self.progress_txt:SetText(targetNum .. "/" .. playingLvMaxExp)
        end)
      end
      self.aniSeq:OnComplete(function()
        if preLv ~= curLv then
          self.eff_ui_saiji_shengji_dengji_faguang:SetActive(true)
          self.eff_ui_saiji_shengji_levelup:SetActive(true)
        end
        self:TryState()
      end)
      self.fill_base:SetActive(true)
      self.level_txt:SetText(self.playingLv)
      if preLv == curLv then
        self.playingLv = self.playingLv + 1
      else
        self.playingLv = curLv
      end
    elseif self.playingLv == curLv then
      local playingLvMaxExp = DataCenter.MasteryManager:GetLevelMaxExp(self.playingLv)
      local oneCeil = 1 / OneLevelTweenNum
      local oneCeilTime = oneCeil * TWEEN_TIME
      local startRate = 0
      local endRate = curExp / playingLvMaxExp
      self.slider:SetValue(0)
      self.progress_txt:SetText(0 .. "/" .. playingLvMaxExp)
      local aniNum = math.ceil((endRate - startRate) / oneCeil)
      self.aniSeq = DOTween.Sequence()
      for i = 1, aniNum do
        local targetRate = startRate + i * oneCeil
        if endRate < targetRate then
          targetRate = endRate
        end
        local targetNum = math.floor(playingLvMaxExp * targetRate)
        self.aniSeq:AppendCallback(function()
          self.slider:DOValue(targetRate, oneCeilTime)
        end)
        self.aniSeq:AppendInterval(oneCeilTime)
        self.aniSeq:AppendCallback(function()
          self.progress_txt:SetText(targetNum .. "/" .. playingLvMaxExp)
        end)
      end
      self.aniSeq:OnComplete(function()
        self:TryState()
      end)
      self.fill_base:SetActive(false)
      self.level_txt:SetText(self.playingLv)
      self.playingLv = self.playingLv + 1
    else
      local playingLvMaxExp = DataCenter.MasteryManager:GetLevelMaxExp(self.playingLv)
      local oneCeil = 1 / OneLevelTweenNum
      local oneCeilTime = oneCeil * TWEEN_TIME
      local startRate = 0
      local endRate = 1
      self.slider:SetValue(0)
      self.progress_txt:SetText(0 .. "/" .. playingLvMaxExp)
      local aniNum = math.ceil((endRate - startRate) / oneCeil)
      self.aniSeq = DOTween.Sequence()
      for i = 1, aniNum do
        local targetRate = startRate + i * oneCeil
        if endRate < targetRate then
          targetRate = endRate
        end
        local targetNum = math.floor(playingLvMaxExp * targetRate)
        self.aniSeq:AppendCallback(function()
          self.slider:DOValue(targetRate, oneCeilTime)
        end)
        self.aniSeq:AppendInterval(oneCeilTime)
        self.aniSeq:AppendCallback(function()
          self.progress_txt:SetText(targetNum .. "/" .. playingLvMaxExp)
        end)
      end
      self.aniSeq:OnComplete(function()
        self:TryState()
      end)
      self.fill_base:SetActive(false)
      self.level_txt:SetText(self.playingLv)
      self.playingLv = self.playingLv + 1
    end
  elseif self.curState == aniState.WaiteClose then
  end
end

local function MoveTimerAndAniSeq(self)
  if self.closeTimer then
    self.closeTimer:Stop()
    self.closeTimer = nil
  end
  if self.aniSeq ~= nil then
    self.aniSeq:Kill()
    self.aniSeq = nil
  end
end

LWUIMasteryExpGetView.OnCreate = OnCreate
LWUIMasteryExpGetView.OnDestroy = OnDestroy
LWUIMasteryExpGetView.ComponentDefine = ComponentDefine
LWUIMasteryExpGetView.ComponentDestroy = ComponentDestroy
LWUIMasteryExpGetView.DataDefine = DataDefine
LWUIMasteryExpGetView.DataDestroy = DataDestroy
LWUIMasteryExpGetView.ReInit = ReInit
LWUIMasteryExpGetView.TryState = TryState
LWUIMasteryExpGetView.MoveTimerAndAniSeq = MoveTimerAndAniSeq
LWUIMasteryExpGetView.RefreshSelectHomeIcon = RefreshSelectHomeIcon
return LWUIMasteryExpGetView
