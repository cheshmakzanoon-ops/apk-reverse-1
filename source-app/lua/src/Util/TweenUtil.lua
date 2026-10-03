local TweenUtil = {}

function TweenUtil.PlayAnimCollectUI(tran, maxScale, minScale, scaleToMaxSec, scaleToMinSec, shakeTime, shakeIntensity)
  if not tran then
    return
  end
  maxScale = maxScale or 1.2
  minScale = minScale or 1
  scaleToMaxSec = scaleToMaxSec or 0.3
  scaleToMinSec = scaleToMinSec or 0.1
  shakeTime = shakeTime or 0.5
  shakeIntensity = shakeIntensity or 0.2
  local sequence = DOTween.Sequence()
  sequence:Append(tran:DOScale(maxScale, scaleToMaxSec))
  sequence:Append(tran:DOScale(minScale, scaleToMinSec))
  sequence:Append(tran:DOShakeScale(shakeTime, shakeIntensity))
  return sequence
end

function TweenUtil.PlayImageFadeLoop(img, minAlpha, maxAlpha, fadeTime, stayTime)
  if not img then
    return
  end
  minAlpha = minAlpha or 0
  maxAlpha = maxAlpha or 1
  fadeTime = fadeTime or 1
  stayTime = stayTime or 0.5
  img:SetAlpha(maxAlpha)
  local sequence = DOTween.Sequence()
  sequence:Append(img:DOFade(minAlpha, fadeTime))
  sequence:AppendInterval(stayTime)
  sequence:Append(img:DOFade(maxAlpha, fadeTime))
  sequence:AppendInterval(stayTime)
  sequence:SetLoops(-1, CS.DG.Tweening.LoopType.Restart)
  return sequence
end

function TweenUtil.Kill(tran)
  if tran then
    DOTween.Kill(tran)
  end
end

return TweenUtil
