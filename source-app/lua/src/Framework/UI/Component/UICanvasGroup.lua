local UICanvasGroup = BaseClass("UICanvasGroup", UIBaseContainer)
local base = UIBaseContainer
local UnityCanvasGroup = typeof(CS.UnityEngine.CanvasGroup)

local function OnCreate(self, ...)
  base.OnCreate(self)
  self.unity_canvas_group = self.gameObject:GetComponent(UnityCanvasGroup)
end

local function OnDestroy(self)
  self.unity_canvas_group = nil
  base.OnDestroy(self)
end

local function Play(self, name, layer, normalizedTime)
  if IsNotNull(self.unity_canvas_group) then
    self.unity_canvas_group:Play(name, layer, normalizedTime)
  end
end

local function SetAlpha(self, value)
  if IsNotNull(self.unity_canvas_group) then
    self.unity_canvas_group.alpha = value
  end
end

local function SetInteractable(self, value)
  if IsNotNull(self.unity_canvas_group) then
    self.unity_canvas_group.interactable = value
  end
end

local function SetBlocksRaycasts(self, value)
  if IsNotNull(self.unity_canvas_group) then
    self.unity_canvas_group.blocksRaycasts = value
  end
end

local function GetAlpha(self)
  if IsNotNull(self.unity_canvas_group) then
    return self.unity_canvas_group.alpha
  end
end

local function FadeIn(self, fadeInDuration)
  if IsNotNull(self.unity_canvas_group) then
    return self.unity_canvas_group:DOFade(1, fadeInDuration)
  end
end

local function FadeOut(self, fadeOutDuration)
  if IsNotNull(self.unity_canvas_group) then
    return self.unity_canvas_group:DOFade(0, fadeOutDuration)
  end
end

local function SetShow(self, isShow)
  if IsNotNull(self.unity_canvas_group) then
    self.unity_canvas_group.alpha = isShow and 1 or 0
    self.unity_canvas_group.interactable = isShow
    self.unity_canvas_group.blocksRaycasts = isShow
  end
end

UICanvasGroup.OnCreate = OnCreate
UICanvasGroup.OnDestroy = OnDestroy
UICanvasGroup.SetAlpha = SetAlpha
UICanvasGroup.GetAlpha = GetAlpha
UICanvasGroup.SetInteractable = SetInteractable
UICanvasGroup.SetBlocksRaycasts = SetBlocksRaycasts
UICanvasGroup.FadeOut = FadeOut
UICanvasGroup.FadeIn = FadeIn
UICanvasGroup.SetShow = SetShow
return UICanvasGroup
