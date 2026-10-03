local base = UIAsyncContainer
local LLMainNews = BaseClass("LLMainNews", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.LandlordMgr
local ROLL_SPEED = 60

function LLMainNews:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLMainNews:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLMainNews:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.root = self.viewSkin:AddComponent(self, UISimpleAnimation, 1)
  self.desc_text = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.t_r_text = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.l_text2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.r_content = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.compRText = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.btn = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.textTimeTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.compBg = self.viewSkin:AddComponent(self, UIBaseContainer, 11)
  self.compGoTips = self.viewSkin:AddComponent(self, UIBaseComponent, 12)
end

function LLMainNews:ComponentDestroy()
  self.viewSkin = nil
  self.root = nil
  self.desc_text = nil
  self.t_r_text = nil
  self.l_text2 = nil
  self.r_content = nil
  self.compRText = nil
  self.btn = nil
  self.textTime = nil
  self.btnInfo = nil
  self.textTimeTip = nil
  self.compBg = nil
  self.compGoTips = nil
end

function LLMainNews:DataDefine()
  self.r_text = self.compRText.gameObject
  self.r_text:GameObjectCreatePool()
  self.rTexts = {}
  self.qTexts = {}
  self.effComps = {}
  self.eTime = 0
  self.compGoTips:SetActive(false)
  self:Update1000MS()
end

function LLMainNews:DataDestroy()
  self:CleanTween()
  if self.goTipDelay ~= nil then
    self.goTipDelay:Stop()
    self.goTipDelay = nil
  end
  for _, v in pairs(self.qTexts) do
    v:Kill()
  end
  if self.tweenTimer then
    self.tweenTimer:Stop()
  end
  self.tweenTimer = nil
  if self.nextTimer then
    self.nextTimer:Stop()
  end
  self.nextTimer = nil
  self.r_content:RemoveComponents(UITextMeshProUGUIEx)
  self.r_text:GameObjectRecycleAll()
  self.r_text = nil
  self.rTexts = {}
  self.qTexts = {}
  self.effComps = {}
  self.baseRoot = nil
end

function LLMainNews:OnAddListener()
  base.OnAddListener(self)
end

function LLMainNews:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLMainNews:OnBtnClick()
  if self.tween ~= nil then
    self:RefreshCurIdx(false)
    return
  end
  self.curIdx = self.curIdx + 1
  if self.curIdx > #self.news then
    self:CleanTween()
    local curStage = ActMgr:GetActCurStage()
    if curStage <= LLConst.LandlordStage.PREVIEW then
    else
      ActMgr:SignGroupNewsFlag()
      self.baseRoot:OnToggleChanged(self.baseRoot.curIdx, true)
    end
  else
    self:RefreshCurIdx(true)
    if self.curIdx == #self.news then
      self:ShowGoTip()
    end
  end
end

function LLMainNews:OnBtnInfoClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  ActMgr:JumpToCity()
end

function LLMainNews:TimeEnd()
  self.textTimeTip:SetActive(false)
  if CommonUtil.IsDebug() and ActMgr.TEST_LL_NEWS ~= nil then
    return
  end
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  self.baseRoot:TyrReqActInfo(curSec)
end

function LLMainNews:Update1000MS()
  if self.baseRoot ~= nil and self.textTimeTip and self.textTimeTip:GetActive() then
    local stage = self.curStageInfo ~= nil and self.curStageInfo.stage or LLConst.LandlordStage.PREVIEW
    if stage <= LLConst.LandlordStage.PREVIEW then
      local curSec = UITimeManager:GetInstance():GetServerSeconds()
      local endSec = self.curStageInfo ~= nil and self.curStageInfo.eTime or 0
      local value = math.max(endSec - curSec, 0)
      self.textTime:SetText(UITimeManager:GetInstance():SecondToFmtString(value))
      if value == 0 then
        self:TimeEnd()
      end
    else
      self:TimeEnd()
    end
  end
end

function LLMainNews:SetView(view)
  self.baseRoot = view
  self:SetActive(true)
  self:RefreshView()
end

function LLMainNews:UpdateData()
  if self.baseRoot == nil then
    return
  end
  if self.goTipDelay ~= nil then
    self.goTipDelay:Stop()
    self.goTipDelay = nil
    self.compGoTips:SetActive(false)
  end
  local info
  if CommonUtil.IsDebug() and ActMgr.TEST_LL_NEWS ~= nil then
    info = ActMgr:GetActStageInfo(ActMgr.TEST_LL_NEWS)
  else
    info = ActMgr:GetActCurStageInfo()
  end
  local stage = info ~= nil and info.stage or LLConst.LandlordStage.PREVIEW
  local sTime = info ~= nil and info.sTime or 0
  local tStr = UITimeManager:GetInstance():TimeStampToTimeForServerMinute(sTime * 1000)
  self.l_text2:SetText(tStr)
  self.curStageInfo = info
  self.initFlag = false
  self.curIdx = 1
  self.curNIdx = 1
  self.news = ActMgr:GetNews(stage)
  local newsInfo = self.news[1]
  self.fakeNews = newsInfo ~= nil and newsInfo.breaking_news or {}
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
  if stage <= LLConst.LandlordStage.PREVIEW then
    self.textTimeTip:SetActive(true)
    self:Update1000MS()
  else
    self.textTimeTip:SetActive(false)
  end
end

function LLMainNews:ShowGoTip()
  if self.goTipDelay ~= nil then
    self.goTipDelay:Stop()
  end
  self.compGoTips:SetActive(true)
  self.goTipDelay = TimerManager:GetInstance():DelayInvoke(function()
    self.goTipDelay = nil
    self.compGoTips:SetActive(false)
  end, 5)
end

function LLMainNews:CleanTween()
  if self.tween ~= nil then
    self.tween:Kill()
  end
  self.tween = nil
end

function LLMainNews:RefreshCurIdx(bAnim)
  self:CleanTween()
  local info = self.news[self.curIdx] or {}
  if info == nil then
    return
  end
  local dialogStr = Localization:GetString(info.dialog or "")
  self.t_r_text:SetLocalText(info.dialog_title)
  for id, comp in pairs(self.effComps) do
    if id ~= info.id then
      comp:SetActive(false)
    end
  end
  local effComp = self.effComps[info.id]
  if effComp == nil and not string.IsNullOrEmpty(info.pic) then
    self.effComps[info.id] = self:LoadComponentAsync(UIAsyncContainer, info.pic, self.compBg, function(_, go, comp)
      if CommonUtil and CommonUtil.IsArabicAutoMirrorOpen() then
        CS.ArabicMirror.MirrorEntry(false, true, go)
      end
      comp:SetName("Eff_" .. info.id)
      local w = comp:GetOffsetMinXY()
      comp:SetOffsetMinXY(w, 0)
      w = comp:GetOffsetMaxXY()
      comp:SetOffsetMaxXY(w, 0)
      local _info = self.news[self.curIdx] or {}
      comp:SetActive(_info.id == info.id)
    end)
  elseif effComp ~= nil then
    effComp:SetActive(true)
  end
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

function LLMainNews:GetOneText(idx)
  local key = self.fakeNews[idx]
  if string.IsNullOrEmpty(key) then
    return nil
  end
  local text = self.rTexts[idx]
  if text == nil then
    local goItem = self.r_text:GameObjectSpawn(self.r_content.transform)
    goItem.name = "r_text_" .. key
    text = self.r_content:AddComponent(UITextMeshProUGUIEx, goItem.name)
    text:SetLocalText(key)
    text:SetActive(true)
    text:ForceUpdate()
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(text.transform)
    self.rTexts[idx] = text
  end
  return text
end

function LLMainNews:RefreshNews()
  if self.nextTimer ~= nil then
    self.nextTimer:Stop()
  end
  self.nextTimer = nil
  local curIdx = self.curNIdx
  local cWidth = self.r_content.rectTransform.rect.width
  local text = self:GetOneText(curIdx)
  if text == nil then
    return
  end
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
    if self.curNIdx > #self.fakeNews then
      self.curNIdx = 1
    end
    self:RefreshNews()
  end, delayT)
end

return LLMainNews
