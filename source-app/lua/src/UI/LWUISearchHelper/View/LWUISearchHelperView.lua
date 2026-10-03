local LWUISearchHelperView = BaseClass("LWUISearchHelperView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local StartPos = Vector3.New(71, -108, 0)
local EndPos = Vector3.New(-162, 214, 0)

function LWUISearchHelperView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Show()
end

function LWUISearchHelperView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUISearchHelperView:ComponentDefine()
  self.btnBlack = self:AddComponent(UIButton, "black")
  self.textTitleTxt = self:AddComponent(UITextMeshProUGUIEx, "window/TitleTxt")
  self.textDescTxt = self:AddComponent(UITextMeshProUGUIEx, "window/DescTxt")
  self.textDescCanvas = self:AddComponent(UICanvasGroup, "window/DescTxt")
  self.rawImgBase = self:AddComponent(UIRawImage, "window/Base")
  self.imgTarget = self:AddComponent(UIImage, "window/Target")
  self.line = self:AddComponent(UICanvasGroup, "window/Line")
  self.center = self:AddComponent(UICanvasGroup, "window/Line/Center")
  self.timeCounter = self:AddComponent(UITextMeshProUGUIEx, "window/TimeCounter")
  self.timeCounterCanvas = self:AddComponent(UICanvasGroup, "window/TimeCounter")
  self.battleCircle = self:AddComponent(UIImage, "window/BattleCircle")
  self.closeBtn = self:AddComponent(UIButton, "window/closeBtn")
  self.closeBtn:SetOnClick(function()
    self:OnBtnBlackClick()
  end)
end

function LWUISearchHelperView:ComponentDestroy()
  self.btnBlack = nil
  self.textTitleTxt = nil
  self.textDescTxt = nil
  self.textDescCanvas = nil
  self.rawImgBase = nil
  self.imgTarget = nil
  self.line = nil
  self.center = nil
  self.timeCounter = nil
  self.timeCounterCanvas = nil
  self.battleCircle = nil
  self.closeBtn = nil
end

function LWUISearchHelperView:DataDefine()
  self.param = self:GetUserData()
  if self.param.targetType == 1 then
    local temp = DataCenter.MonsterTemplateManager:GetMonsterTemplate(self.param.monsterId)
    local iconName = "world_monster_boss_iron"
    if temp.pic == "world_monster_boss_coin" or temp.pic == "world_monster_boss_bread" then
      iconName = temp.pic
    end
    self.imgTarget:LoadSpriteAsyncWithCallback(LoadPath.HeroIconsBigPath .. iconName, function(texture)
      if self and self.imgTarget then
        self.imgTarget:SetNativeSize()
      end
    end)
    local lp = self.imgTarget.transform.localPosition
    lp.y = 288
    self.imgTarget.transform:Set_localPosition(lp.x, lp.y, lp.z)
    self.battleCircle.gameObject:SetActive(true)
    self.textTitleTxt:SetLocalText("newbies_world_description_desc1")
    self.textDescTxt:SetLocalText("newbies_world_description_desc2")
    CS.GameEntry.Setting:SetPrivateInt(SettingKeys.HAS_ATTACKMONSTER_MARCH_HELPER, 1)
  elseif self.param.targetType == 2 then
    local temp = DataCenter.GatherResourceTemplateManager:GetTemplate(self.param.gatherId)
    self.imgTarget:LoadSpriteAsyncWithCallback(temp.pic, function(texture)
      if self and self.imgTarget then
        self.imgTarget:SetNativeSize()
      end
    end)
    local lp = self.imgTarget.transform.localPosition
    lp.y = 250
    self.imgTarget.transform:Set_localPosition(lp.x, lp.y, lp.z)
    self.battleCircle.gameObject:SetActive(false)
    self.textTitleTxt:SetLocalText("newbies_world_description_desc3")
    self.textDescTxt:SetLocalText("newbies_world_description_desc4")
    CS.GameEntry.Setting:SetPrivateInt(SettingKeys.HAS_COLLECT_MARCH_HELPER, 1)
  end
end

function LWUISearchHelperView:Show()
  self:OneLoop()
end

function LWUISearchHelperView:OneLoop()
  self.textDescCanvas:SetAlpha(0)
  self.descTween = self.textDescTxt.rectTransform:GetComponent(typeof(CS.UnityEngine.CanvasGroup)):DOFade(1, 0.5):SetDelay(2)
  self.line:SetAlpha(0)
  self.center:SetAlpha(0)
  self.center.gameObject.transform:Set_localPosition(StartPos.x, StartPos.y, 0)
  self.timeCounter:SetText("")
  self.timeCounterCanvas:SetAlpha(0)
  local totalDis = Vector3.Distance(StartPos, EndPos)
  self.tweenSeq = DOTween.Sequence()
  self.tweenSeq:AppendInterval(1.5)
  self.tweenSeq:Append(self.line.rectTransform:GetComponent(typeof(CS.UnityEngine.CanvasGroup)):DOFade(1, 0.2))
  self.tweenSeq:AppendInterval(0.5)
  self.tweenSeq:Append(self.center.rectTransform:GetComponent(typeof(CS.UnityEngine.CanvasGroup)):DOFade(1, 0.2))
  self.tweenSeq:AppendCallback(function()
    local t = 2
    local time = UITimeManager:GetInstance():SecondToFmtString(t)
    self.timeCounter:SetLocalText("newbies_march_time_tips1", time)
  end)
  self.tweenSeq:Append(self.timeCounter.rectTransform:GetComponent(typeof(CS.UnityEngine.CanvasGroup)):DOFade(1, 0.2))
  local move = self.center.gameObject.transform:DOLocalMove(EndPos, 2)
  move:SetEase(CS.DG.Tweening.Ease.Linear)
  move:OnUpdate(function()
    local dis = Vector3.Distance(self.center.gameObject.transform.localPosition, EndPos)
    if dis < totalDis then
      local remaining = dis / totalDis * 2
      local t = math.ceil(remaining)
      local time = UITimeManager:GetInstance():SecondToFmtString(t)
      self.timeCounter:SetLocalText("newbies_march_time_tips1", time)
    end
  end)
  self.tweenSeq:Append(move)
  self.tweenSeq:AppendInterval(0.5)
  self.tweenSeq:AppendCallback(function()
    self.timeCounter:SetText("")
    self.center:SetAlpha(0)
    self.timeCounterCanvas:SetAlpha(0)
    self.line:SetAlpha(0)
    self.center.gameObject.transform:Set_localPosition(StartPos.x, StartPos.y, 0)
  end)
  self.tweenSeq:SetLoops(-1, CS.DG.Tweening.LoopType.Restart)
end

function LWUISearchHelperView:DataDestroy()
  self.param = nil
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
  if self.descTween then
    self.descTween:Kill()
    self.descTween = nil
  end
end

function LWUISearchHelperView:OnBtnBlackClick()
  self.param.callback()
  self.ctrl:CloseSelf()
end

return LWUISearchHelperView
