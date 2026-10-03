local LWUIEffectNumAdd = BaseClass("LWUIEffectNumAdd", UIAsyncContainer)
local base = UIAsyncContainer

function LWUIEffectNumAdd:OnCreate()
  base.OnCreate(self)
  self.effectText = self:AddComponent(UITextMeshProUGUIEx, "EffectNum")
  self.animRoot = self:AddComponent(UICanvasGroup, "EffectNum")
end

function LWUIEffectNumAdd:OnDestroy()
  if self.animSequence then
    self.animSequence:Kill()
    self.animSequence = nil
  end
  base.OnDestroy(self)
end

function LWUIEffectNumAdd:UpdateData()
  if IsNull(self.gameObject) or IsNull(self.effectText) or self.moveDelta == nil or self.moveTime == nil or self.animStarted == true then
    return
  end
  self.animStarted = true
  self.effectText:SetText(self.str)
  self.effectText:SetColor(self.color)
  self.effectText:SetFontSize(self.fontSize)
  self.animRoot:SetActive(true)
  self.animRoot:SetLocalPositionXYZ(0, 0, 0)
  self.animRoot:SetAlpha(1)
  local sequence = DOTween.Sequence()
  sequence:Append(self.animRoot:FadeOut(self.moveTime):SetEase(CS.DG.Tweening.Ease.InQuad))
  sequence:Join(self.animRoot.transform:DOLocalMoveY(self.moveDelta, self.moveTime):SetEase(CS.DG.Tweening.Ease.InQuad))
  sequence:OnComplete(function()
    if self.animSequence ~= nil then
      self.animSequence = nil
    end
  end)
  self.animSequence = sequence
end

function LWUIEffectNumAdd:SetParam(str, color, fontSize, moveDelta, moveTime)
  self.str = str
  self.fontSize = fontSize or 32
  self.color = color or Color.New(1, 1, 1, 1)
  self.moveDelta = moveDelta or 100
  self.moveTime = moveTime or 1.5
  if self.animStarted ~= true then
    self:UpdateData()
  end
end

function LWUIEffectNumAdd.CreateNewEffect(transform, str, color, fontSize, moveDelta, moveTime)
  local prefabPath = "Assets/Main/Prefabs/UI/Common/UIEffectNumAdd.prefab"
  local obj = LWUIEffectNumAdd.New(nil, transform, prefabPath, nil, nil)
  CommonUtil.ProtectCall(function()
    obj:SetParam(str, color, fontSize, moveDelta, moveTime)
    TimerManager:GetInstance():DelayInvoke(function()
      if obj and type(obj.Delete) == "function" then
        pcall(obj.Delete, obj)
      end
    end, moveTime or 1.6)
  end)
  return obj
end

return LWUIEffectNumAdd
