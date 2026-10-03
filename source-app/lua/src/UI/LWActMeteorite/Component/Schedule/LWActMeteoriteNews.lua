local base = UIBaseContainer
local LWActMeteoriteNews = BaseClass("LWActMeteoriteNews", base)
local Localization = CS.GameEntry.Localization
local root_path = "Root"
local bg_path = "Root/Bg"
local eff_path = "Root/Bg/Eff_UI_LWActMeteoriteNews_BG0"
local desc_text_path = "Root/NewsTitle/Tips/DescText"
local t_r_text_path = "Root/NewsTitle/Top/R/TRText"
local l_text2_path = "Root/NewsTitle/Top/Live/LText2"
local r_content_path = "Root/NewsTitle/Di/R/RContent"
local r_text_path = "Root/NewsTitle/RText"
local btn_path = "Root/Btn"
local NEWS_DIALOGS = {
  "yuntieBattle_news_dialog_1009",
  "yuntieBattle_news_dialog_1010",
  "yuntieBattle_news_dialog_1011"
}
local ROLL_SPEED = 60

function LWActMeteoriteNews:OnCreate()
  base.OnCreate(self)
  self.root = self:AddComponent(UISimpleAnimation, root_path)
  self.bg = self:AddComponent(UIRawImage, bg_path)
  self.effs = {}
  for i = 1, 3 do
    self.effs[i] = self:AddComponent(UIBaseComponent, eff_path .. i)
  end
  self.desc_text = self:AddComponent(UIText, desc_text_path)
  self.t_r_text = self:AddComponent(UITextMeshProUGUIEx, t_r_text_path)
  local meteorite = DataCenter.ActMeteoriteBattleManager:GetCurMeteoriteInfo()
  local sId = meteorite ~= nil and meteorite.serverId or 0
  local actInfo = DataCenter.ActMeteoriteBattleManager:GetActInfo()
  local eTime = actInfo ~= nil and actInfo.stageEndTime or 0
  local tStr = UITimeManager:GetInstance():TimeStampToTimeForServerMinute(eTime * 1000)
  self.t_r_text:SetLocalText("yuntieBattle_news_dialog_1009", tStr, sId)
  self.l_text2 = self:AddComponent(UITextMeshProUGUIEx, l_text2_path)
  local sTime = actInfo ~= nil and actInfo.beginTime or 0
  tStr = UITimeManager:GetInstance():TimeStampToTimeForServerMinute(sTime * 1000)
  self.l_text2:SetText(tStr)
  self.r_content = self:AddComponent(UIBaseContainer, r_content_path)
  self.r_text = self.transform:Find(r_text_path).gameObject
  self.rTexts = {}
  self.qTexts = {}
  self.r_text:GameObjectCreatePool()
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    if self.tween ~= nil then
      self:RefreshCurIdx(false)
      return
    end
    self.curIdx = self.curIdx + 1
    if self.curIdx > #NEWS_DIALOGS then
      self:CleanTween()
      DataCenter.ActMeteoriteBattleManager:SignNewFlag()
      self.schedule:SetData()
    else
      self:RefreshCurIdx(true)
    end
  end)
end

function LWActMeteoriteNews:OnDestroy()
  self:CleanTween()
  for _, v in pairs(self.qTexts) do
    v:Kill()
  end
  self.qTexts = {}
  if self.nextTimer then
    self.nextTimer:Stop()
  end
  self.nextTimer = nil
  if self.tweenTimer then
    self.tweenTimer:Stop()
  end
  if self.nextTimer then
    self.nextTimer:Stop()
  end
  self.nextTimer = nil
  self.tweenTimer = nil
  self.r_content:RemoveComponents(UIText)
  self.r_text:GameObjectRecycleAll()
  self.rTexts = {}
  self.root = nil
  self.bg = nil
  self.effs = {}
  self.tips = nil
  self.desc_text = nil
  self.t_r_text = nil
  self.l_text2 = nil
  self.r_text = nil
  self.btn = nil
  base.OnDestroy(self)
end

function LWActMeteoriteNews:CleanTween()
  if self.tween ~= nil then
    self.tween:Kill()
  end
  self.tween = nil
end

function LWActMeteoriteNews:SetData(schedule)
  self.initFlag = false
  self.curIdx = 1
  self.curNIdx = 1
  self.schedule = schedule
  local dialogStr = self:RefreshCurIdx(true)
  if self.tweenTimer then
    self.tweenTimer:Stop()
  end
  local flag, time = self.root:GetAnimationReturnTime("Default")
  if flag then
    self.tweenTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.tweenTimer = nil
      self.initFlag = true
      self.tween = self.desc_text:DOText(dialogStr, 3):OnComplete(function()
        self.tween = nil
      end)
      if self.nextTimer == nil then
        self:RefreshNews()
      end
    end, time)
  end
end

function LWActMeteoriteNews:RefreshCurIdx(bAnim)
  self:CleanTween()
  local dialogStr = NEWS_DIALOGS[self.curIdx]
  if self.curIdx == 1 then
    local actInfo = DataCenter.ActMeteoriteBattleManager:GetActInfo()
    local eTime = actInfo ~= nil and actInfo.stageEndTime or 0
    local tStr = UITimeManager:GetInstance():TimeStampToTimeForServerMinute(eTime * 1000)
    local meteorite = DataCenter.ActMeteoriteBattleManager:GetCurMeteoriteInfo()
    local sId = meteorite ~= nil and meteorite.serverId or 0
    dialogStr = Localization:GetString(dialogStr, tStr, sId)
  elseif self.curIdx == 2 then
    dialogStr = Localization:GetString(dialogStr)
  elseif self.curIdx == 3 then
    local actInfo = DataCenter.ActMeteoriteBattleManager:GetActInfo() or {}
    local sIds = actInfo.servers or {}
    local sIdStr = table.concat(sIds, " #")
    dialogStr = Localization:GetString(dialogStr, sIdStr)
  end
  for i, eff in ipairs(self.effs) do
    eff:SetActive(i == self.curIdx)
  end
  self.bg:LoadSpriteAuto(string.format("Assets/Main/TextureEx/LWActMeteorite/lrb_ZLHD_bobao_0%d_banner.png", self.curIdx))
  if bAnim then
    if self.initFlag then
      self.tween = self.desc_text:DOText(dialogStr, 3):OnComplete(function()
        self.tween = nil
      end)
    else
      self.desc_text:SetText("")
    end
  else
    self.desc_text:SetText(dialogStr)
  end
  return dialogStr
end

function LWActMeteoriteNews:GetOneText(idx)
  local key = "yuntieBattle_news_dialog_100" .. 3 + idx
  local text = self.rTexts[idx]
  if text == nil then
    local goItem = self.r_text:GameObjectSpawn(self.r_content.transform)
    goItem.name = "r_text_" .. key
    text = self.r_content:AddComponent(UIText, goItem.name)
    text:SetLocalText(key)
    text:SetActive(true)
    text:ForceUpdate()
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(text.transform)
    self.rTexts[idx] = text
  end
  return text
end

function LWActMeteoriteNews:RefreshNews()
  if self.nextTimer ~= nil then
    self.nextTimer:Stop()
  end
  self.nextTimer = nil
  local curIdx = self.curNIdx
  local cWidth = self.r_content.rectTransform.rect.width
  local text = self:GetOneText(curIdx)
  text:SetActive(true)
  local width = text.rectTransform.rect.width
  local rawWidth = cWidth + width
  local time = rawWidth / ROLL_SPEED
  local isArabic = CommonUtil.IsArabic()
  local bMirror = CommonUtil.IsArabicAutoMirrorOpen()
  local startPox = cWidth
  local endPox = 0 - width
  if isArabic then
    if bMirror then
      startPox = cWidth
      endPox = width
    else
      startPox = -width
      endPox = cWidth
    end
  end
  text:SetAnchoredPositionXY(startPox, 0)
  local tweenSeq = self.qTexts[curIdx]
  if tweenSeq ~= nil then
    tweenSeq:Kill()
  end
  tweenSeq = DOTween.Sequence()
  tweenSeq:Append(text.transform:DOAnchorPosX(endPox, time):SetEase(CS.DG.Tweening.Ease.Linear))
  tweenSeq:AppendCallback(function()
    text:SetActive(false)
  end)
  self.qTexts[curIdx] = tweenSeq
  local delayT = width / ROLL_SPEED + 1
  self.nextTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.curNIdx = curIdx + 1
    self.nextTimer = nil
    if self.curNIdx > 4 then
      self.curNIdx = 1
    end
    self:RefreshNews()
  end, delayT)
end

return LWActMeteoriteNews
