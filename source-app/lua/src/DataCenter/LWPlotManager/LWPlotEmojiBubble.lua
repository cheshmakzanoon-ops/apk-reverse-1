local LWPlotEmojiBubble = BaseClass("LWPlotEmojiBubble")

function LWPlotEmojiBubble:__init(params)
  self.bubbleHandle = params[1]
  self.emojiData = params[2]
  self.anchor = params[3]
  self.rotation = params[4]
  self.gameObject = self.bubbleHandle.gameObject
  self.transform = self.gameObject.transform
  self:ComponentDefine()
end

function LWPlotEmojiBubble:__delete()
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
  self:ComponentDestroy()
  if not IsNull(self.bubbleHandle) then
    self.bubbleHandle:Destroy()
    self.bubbleHandle = nil
  end
  self.emojiData = nil
  self.anchor = nil
  self.rotation = nil
  self.gameObject = nil
  self.transform = nil
  self.targetTransform = nil
end

function LWPlotEmojiBubble:ComponentDefine()
  self.transRoot = self.transform:Find("root")
  self.bubble = self.transform:Find("root/bubble")
  self.imgIcon = self.transform:Find("root/img"):GetComponent(typeof(CS.UnityEngine.UI.Image))
end

function LWPlotEmojiBubble:ComponentDestroy()
  self.transRoot = nil
  self.bubble = nil
  self.imgIcon = nil
end

function LWPlotEmojiBubble:SetEmojiData(emojiData)
  self.emojiData = emojiData
end

local function _FillContent(self, layer)
  self.transRoot.gameObject.layer = layer
  self.imgIcon.gameObject.layer = layer
  local path = "Assets/Main/Sprites/UI/LWChatEmoji/Default/" .. self.emojiData.path .. ".png"
  if not string.IsNullOrEmpty(path) then
    self.imgIcon:LoadSprite(path)
  end
  if self.rotation then
    self.bubble.localRotation = Quaternion.New(0, 0, self.rotation, 1)
  else
    self.bubble.localRotation = Quaternion.identity
  end
  self.transRoot.localScale = Vector3(0.92, 0.92, 1)
  self.tween = self.transRoot:DOScale(Vector3(1.08, 1.08, 1), 0.1):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo)
end

local function __FollowTarget(self)
  if IsNull(self.targetTransform) then
    return
  end
  if self.needTransWorldToScreen then
    local screenPos = CS.UnityEngine.Camera.main:WorldToScreenPoint(self.targetTransform.position + self.anchor)
    local screenRatio = math.max(DefaultScreenHeight / Screen.height, DefaultScreenWidth / Screen.width)
    screenPos.x = (screenPos.x - Screen.width * 0.5) * screenRatio
    screenPos.y = (screenPos.y - Screen.height * 0.5) * screenRatio
    screenPos.z = 0
    self.transform.anchoredPosition3D = screenPos
  else
    self.transform.position = self.targetTransform.position + self.anchor
  end
end

function LWPlotEmojiBubble:Display2D(screenRatioFix)
  if screenRatioFix then
    local ratio = DefaultScreenWidth / DefaultScreenHeight / (Screen.width / Screen.height)
    if 1 < ratio then
      self.anchor.y = self.anchor.y * ratio
    else
      self.anchor.x = self.anchor.x * ratio
    end
  end
  self.transform.localPosition = self.anchor
  self.transform.localRotation = Quaternion.identity
  self.transform.localScale = Vector3(1, 1, 1)
  _FillContent(self, LayerMask.NameToLayer("UI"))
end

function LWPlotEmojiBubble:Display2DFollow(targetTransform, needTransWorldToScreen)
  self.targetTransform = targetTransform
  self.needTransWorldToScreen = needTransWorldToScreen
  self.transform.localRotation = Quaternion.identity
  self.transform.localScale = Vector3(1, 1, 1)
  _FillContent(self, LayerMask.NameToLayer("UI"))
  __FollowTarget(self)
end

function LWPlotEmojiBubble:Display3D()
  self.transform.position = self.anchor
  if CS.SceneManager:IsInCity() then
    self.transform.eulerAngles = Vector3(45, -45, 0)
    self.transform.localScale = Vector3(0.03, 0.03, 0.03)
  else
    self.transform.eulerAngles = Vector3(45, 0, 0)
    self.transform.localScale = Vector3(0.02, 0.02, 0.02)
  end
  _FillContent(self, LayerMask.NameToLayer("Hud3D"))
end

function LWPlotEmojiBubble:Display3DFollow(targetTransform)
  self.targetTransform = targetTransform
  if CS.SceneManager:IsInCity() then
    self.transform.eulerAngles = Vector3(45, -45, 0)
    self.transform.localScale = Vector3(0.03, 0.03, 0.03)
  else
    self.transform.eulerAngles = Vector3(45, 0, 0)
    self.transform.localScale = Vector3(0.02, 0.02, 0.02)
  end
  _FillContent(self, LayerMask.NameToLayer("Hud3D"))
  __FollowTarget(self)
end

function LWPlotEmojiBubble:OnUpdate()
  __FollowTarget(self)
end

function LWPlotEmojiBubble:Dispose()
  if not IsNull(self.transRoot) then
    self.transRoot.localRotation = Quaternion.identity
    self.tween = self.transRoot:DOLocalRotate(Vector3(0, 0, 2), 0.05):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo):OnComplete(function()
      self.tween = self.transRoot:DOLocalRotate(Vector3(0, 0, -2), 0.05):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo):OnComplete(function()
        self:Delete()
      end)
    end)
  end
end

return LWPlotEmojiBubble
