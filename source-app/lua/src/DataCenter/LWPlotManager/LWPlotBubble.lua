local LWPlotBubble = BaseClass("LWPlotBubble")
local UIHead = require("UI.UILWNewsCenter.Component.UILWNewsUserCell")
local head_group_path = "root/bubble/headGroup"

function LWPlotBubble:__init(params)
  self.bubbleHandle = params[1]
  self.plotData = params[2]
  if self.plotData.left then
    self.plotData.left = CommonUtil.IsArabicAutoMirrorOpen() and 1 - self.plotData.left or self.plotData.left
  end
  self.plotId = self.plotData.id
  self.anchor = params[3]
  self.playerInfo = params[4]
  self.pointUuid = params[5]
  self.headType = params[6] or 0
  self.gameObject = self.bubbleHandle.gameObject
  self.transform = self.gameObject.transform
  self:ComponentDefine()
end

function LWPlotBubble:__delete()
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
  self:ComponentDestroy()
  if not IsNull(self.bubbleHandle) then
    self.bubbleHandle:Destroy()
    self.bubbleHandle = nil
  end
  self.plotData = nil
  self.anchor = nil
  self.playerInfo = nil
  self.gameObject = nil
  self.transform = nil
  self.targetTransform = nil
  self.headType = nil
end

function LWPlotBubble:ComponentDefine()
  self.transRoot = self.transform:Find("root")
  self.transBubble = self.transform:Find("root/bubble")
  self.txtContent = self.transform:Find("root/bubble/txtContent"):GetComponent(typeof(CS.TextMeshProUGUIEx))
  self.objIcon = self.transform:Find("root/bubble/bgIcon").gameObject
  self.imgIcon = self.transform:Find("root/bubble/bgIcon/imgIcon"):GetComponent(typeof(CS.UnityEngine.UI.Image))
  self.frameBg = self.transform:Find("root/bubble/frameBg")
  self.arrow = self.transform:Find("root/arrow")
  self.head_group = self.transform:Find(head_group_path).gameObject
  self.name = self.transform:Find("root/bubble/headGroup/name"):GetComponent(typeof(CS.TextMeshProUGUIEx))
end

function LWPlotBubble:ComponentDestroy()
  self.transRoot = nil
  self.transBubble = nil
  self.txtContent = nil
  self.objIcon = nil
  self.imgIcon = nil
  self.arrow = nil
  self.head_group = nil
  if self.headPlayer then
    self.headPlayer:Delete()
  end
  self.headPlayer = nil
  self.commonHead = nil
end

local function _FillContent(self, layer)
  self.transRoot.gameObject.layer = layer
  self.transBubble.gameObject.layer = layer
  self.txtContent.gameObject.layer = layer
  self.objIcon.gameObject.layer = layer
  self.imgIcon.gameObject.layer = layer
  self.arrow.gameObject.layer = layer
  local bubbleLocalPos = Vector3(self.plotData.left == 1 and 90 or -90, 27, 0)
  self.transBubble.localPosition = bubbleLocalPos
  self.arrow.localScale = Vector3(self.plotData.left == 1 and 1 or -1, 1, 1)
  self.name:Native_SetText("")
  if self.playerInfo then
    self.txtContent.transform.localPosition = Vector3(43, 0, 0)
    self.txtContent.transform.sizeDelta = Vector2(200, 80)
    self.objIcon:SetActive(false)
    self.head_group:SetActive(true)
    if self.headType == 0 then
      self.headPlayer:Refresh(self.playerInfo.uid, self.playerInfo.pic, self.playerInfo.picVer)
      self.headPlayer:SetActive(true)
      if self.commonHead then
        self.commonHead:SetActive(false)
      end
    else
      self.commonHead:SetHead(self.playerInfo.uid, self.playerInfo.pic, self.playerInfo.picVer)
      self.commonHead:SetActive(true)
      if self.headPlayer then
        self.headPlayer:SetActive(false)
      end
    end
    if not string.IsNullOrEmpty(self.playerInfo.name) then
      self.name:Native_SetText(self.playerInfo.name)
    end
  elseif self.plotData.appearance and 0 < self.plotData.appearance then
    self.txtContent.transform.localPosition = Vector3(43, 0, 0)
    self.txtContent.transform.sizeDelta = Vector2(200, 80)
    self.objIcon:SetActive(true)
    self.head_group:SetActive(false)
    local sprite_path = HeroUtils.GetHeroIconPath(self.plotData.appearance)
    if not string.IsNullOrEmpty(sprite_path) then
      local isReady = UIUtil.CheckAssetDownloaded(sprite_path)
      if isReady then
        self.imgIcon:LoadSprite(sprite_path)
      else
        self.imgIcon:LoadSpriteAsync(sprite_path)
      end
    end
  else
    self.txtContent.transform.localPosition = Vector3(0, 0, 0)
    self.txtContent.transform.sizeDelta = Vector2(248, 80)
    self.objIcon:SetActive(false)
    self.head_group:SetActive(false)
  end
  local content
  if not string.IsNullOrEmpty(self.plotData.contentString) then
    content = self.plotData.contentString
  elseif not string.IsNullOrEmpty(self.plotData.content) then
    content = CS.GameEntry.Localization:GetString(self.plotData.content)
  end
  if string.IsNullOrEmpty(content) then
    self.txtContent.text = ""
    self.arrow.gameObject:SetActive(false)
    self.frameBg.gameObject:SetActive(true)
    self.transBubble.sizeDelta = Vector2.zero
    self.objIcon.transform.localPosition = -bubbleLocalPos
    self.head_group.transform.localPosition = -bubbleLocalPos
    self.frameBg.transform.localPosition = Vector3(0, -8, 0) - bubbleLocalPos
  else
    self.txtContent.text = content
    self.arrow.gameObject:SetActive(true)
    self.frameBg.gameObject:SetActive(false)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.txtContent.transform)
    self.transBubble.sizeDelta = Vector2(298, math.max(90, self.txtContent.transform.rect.height + 10))
    self.txtContent.transform.anchoredPosition = Vector2(self.txtContent.transform.anchoredPosition.x, 0)
    self.objIcon.transform.localPosition = Vector3(-100, 57, 0)
    self.head_group.transform.localPosition = Vector3(-100, 57, 0)
  end
  CommonUtil.ProtectCall(function()
    self.transRoot.localScale = Vector3(0.92, 0.92, 1)
    self.tween = self.transRoot:DOScale(Vector3(1.08, 1.08, 1), 0.1):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo)
    if not string.IsNullOrEmpty(self.plotData.dub) then
      local canPlay = true
      if not string.IsNullOrEmpty(self.plotData.dub_condition) then
        local split1 = string.split(self.plotData.dub_condition, "|")
        for i, v in ipairs(split1) do
          local split2 = string.split(v, ";")
          if split2[1] == PlotDubCondition.GuideDone and tonumber(split2[2]) ~= nil then
            canPlay = DataCenter.LWGuideFlowManager:ReadDone(tonumber(split2[2]))
          end
          if not canPlay then
            break
          end
        end
      end
      if canPlay then
        DataCenter.LWSoundManager:PlayDub(self.plotData.dub)
      end
    end
  end, function()
    if IsNotNull(self.transRoot) then
      self.transRoot.localScale = Vector3(0, 0, 0)
    end
  end)
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

function LWPlotBubble:Display2D(screenRatioFix)
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

function LWPlotBubble:Display2DFollow(targetTransform, needTransWorldToScreen)
  self.targetTransform = targetTransform
  self.needTransWorldToScreen = needTransWorldToScreen
  self.transform.localRotation = Quaternion.identity
  self.transform.localScale = Vector3(1, 1, 1)
  _FillContent(self, LayerMask.NameToLayer("UI"))
  __FollowTarget(self)
end

function LWPlotBubble:Display3D()
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

function LWPlotBubble:Display3DFollow(targetTransform)
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

function LWPlotBubble:OnUpdate()
  __FollowTarget(self)
end

function LWPlotBubble:Dispose()
  if not IsNull(self.gameObject) and not IsNull(self.transRoot) then
    CommonUtil.ProtectCall(function()
      self.transRoot.localRotation = Quaternion.identity
      self.tween = self.transRoot:DOLocalRotate(Vector3(0, 0, 2), 0.05):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo):OnComplete(function()
        self:DisposeStep2()
      end)
    end, function()
      if IsNotNull(self.transRoot) then
        self.transRoot.localScale = Vector3(0, 0, 0)
        self:Delete()
      end
    end)
  end
end

function LWPlotBubble:DisposeStep2()
  CommonUtil.ProtectCall(function()
    self.tween = self.transRoot:DOLocalRotate(Vector3(0, 0, -2), 0.05):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo):OnComplete(function()
      self:Delete()
    end)
  end, function()
    if IsNotNull(self.transRoot) then
      self.transRoot.localScale = Vector3(0, 0, 0)
      self:Delete()
    end
  end)
end

local function AddComponent(self, component_target, var_arg, ...)
  assert(component_target.__ctype == ClassType.class)
  local component_inst = component_target.New(self, var_arg)
  component_inst:OnCreate(...)
  if component_inst:GetActiveInHierarchy() then
    component_inst:OnEnable()
  end
  return component_inst
end

local function GetHeadPlayerCom(self)
  self.headPlayer = UIHead.New(nil, self.transform:Find("root/bubble/headGroup/headPlayer").gameObject)
  self.headPlayer:OnCreate()
  return self.headPlayer
end

local function GetCommonHeadCom(self)
  self.commonHead = self:AddComponent(UICommonHead, "root/bubble/headGroup/SpeHead")
  return self.commonHead
end

LWPlotBubble.AddComponent = AddComponent
LWPlotBubble.getters.headPlayer = GetHeadPlayerCom
LWPlotBubble.getters.commonHead = GetCommonHeadCom
return LWPlotBubble
