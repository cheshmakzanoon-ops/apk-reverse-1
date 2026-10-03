local Recruit100OpeningAniCard = BaseClass("Recruit100OpeningAniCard")
local SEGMENT_COUNT = 20
local CARD_MESH_HEIGHT = 0.225
local CARD_UI_PIXEL = 288
local paths = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Vector3), SEGMENT_COUNT)
local Localization = CS.GameEntry.Localization

local function __init()
end

local function __delete()
  self:StopAllTween()
  self.cardObj = nil
  self.transform = nil
  self.index = nil
  self.sceneCamera = nil
  self.cardScreenPos = nil
end

function Recruit100OpeningAniCard:Init(cardObj)
  self.cardObj = cardObj
  self.transform = self.cardObj.transform
end

function Recruit100OpeningAniCard:SetData(cardScreenPos, sceneCamera)
  self.sceneCamera = sceneCamera
  self.cardScreenPos = Vector3(cardScreenPos.x, cardScreenPos.y, 0.1)
  self.transform.localRotation = Quaternion.Euler(0, 0, 0)
  self.transform:Set_localScale(1, 1, 1)
  self.transform.localPosition = Vector3(0, 0, 0)
end

function Recruit100OpeningAniCard:FlyToTargetPos()
  local cardTargetWorldPos = self:GetCardFlyWroldTarget()
  local startPos = self.transform.position
  local destPos = cardTargetWorldPos
  local controlPos = (startPos + destPos) * 0.5
  local pathVec = self:Bezier2Path(startPos, controlPos, destPos)
  self.pathTween = self.transform:DOPath(pathVec, RECRUIT_100_CARD_FLY_TIME):SetEase(CS.DG.Tweening.Ease.OutQuart)
  self.rotateTween = self.transform:DORotate(Vector3(self.sceneCamera.transform.eulerAngles.x, 0, 0), 1)
end

function Recruit100OpeningAniCard:GetCardFlyWroldTarget()
  local canvasWidth = UIManager:GetInstance():GetUIContainerRect().sizeDelta.x
  local canvasHeight = UIManager:GetInstance():GetUIContainerRect().sizeDelta.y
  local convertCanvasPosX = self.cardScreenPos.x / Screen.width * canvasWidth
  local convertCanvasPosY = self.cardScreenPos.y / Screen.height * canvasHeight
  local sceneCameraFOV = self.sceneCamera.fieldOfView
  local cameraDepth = canvasHeight * CARD_MESH_HEIGHT / CARD_UI_PIXEL / 2 / math.tan(sceneCameraFOV / 2 * math.pi / 180)
  local cardTargetWorldPos = self.sceneCamera:ScreenToWorldPoint(Vector3(convertCanvasPosX, convertCanvasPosY, cameraDepth))
  return cardTargetWorldPos
end

function Recruit100OpeningAniCard:StopAllTween()
  if self.scaleTween then
    self.scaleTween:Kill()
    self.scaleTween = nil
  end
  if self.pathTween then
    self.pathTween:Kill()
    self.pathTween = nil
  end
  if self.rotateTween then
    self.rotateTween:Kill()
    self.rotateTween = nil
  end
end

function Recruit100OpeningAniCard:CalculateCubicBezierPointFor2C(t, p0, p1, p2)
  local u = 1 - t
  local tt = t * t
  local uu = u * u
  local p = uu * p0
  p = p + 2 * u * t * p1
  p = p + tt * p2
  return p
end

function Recruit100OpeningAniCard:Bezier2Path(startPos, controlPos, endPos)
  for i = 1, SEGMENT_COUNT do
    local t = i / SEGMENT_COUNT
    local pixel = self:CalculateCubicBezierPointFor2C(t, startPos, controlPos, endPos)
    paths[i - 1] = pixel
  end
  return paths
end

Recruit100OpeningAniCard.__init = __init
Recruit100OpeningAniCard.__delete = __delete
return Recruit100OpeningAniCard
