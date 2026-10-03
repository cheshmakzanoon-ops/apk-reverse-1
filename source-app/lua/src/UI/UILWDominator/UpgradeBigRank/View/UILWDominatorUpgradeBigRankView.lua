local UILWDominatorUpgradeBigRankView = BaseClass("UILWDominatorUpgradeBigRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local ResourceManager = CS.GameEntry.Resource
local Camera = CS.UnityEngine.Camera
local Screen = CS.UnityEngine.Screen
UILWDominatorUpgradeBigRankView.defaultScenePos = Vector3.New(0, 0, 0)
UILWDominatorUpgradeBigRankView.rtWidth = 810
UILWDominatorUpgradeBigRankView.rtHeight = 1440

function UILWDominatorUpgradeBigRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
  EventManager:GetInstance():Broadcast(EventId.DominatorHideMainModelScene)
end

function UILWDominatorUpgradeBigRankView:OnDestroy()
  self:OnClose()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
  EventManager:GetInstance():Broadcast(EventId.DominatorShowMainModelScene)
end

function UILWDominatorUpgradeBigRankView:ComponentDefine()
  self.rawImgSkillPreviewRT = self:AddComponent(UIRawImage, "Root/SkillPreviewRT")
  self.textTitleText = self:AddComponent(UIText, "Root/RightTopInfo/TitleText")
  self.textTitleText:SetLocalText("dominator_rank_dec_1")
  self.textTitleText1 = self:AddComponent(UIText, "Root/RightTopInfo/TitleText1")
  self.textTitleText1:SetLocalText("")
  self.textTitleText2 = self:AddComponent(UIText, "Root/RightTopInfo/TitleText2")
  self.textTitleText2:SetLocalText("")
  self.textPreName = self:AddComponent(UIText, "Root/RightTopInfo/Layout/PreNameText")
  self.textCurName = self:AddComponent(UIText, "Root/RightTopInfo/Layout/CurNameText")
  self.compArrow = self:AddComponent(UIBaseContainer, "Root/RightTopInfo/Layout/Arrow")
  self.btnBack = self:AddComponent(UIButton, "Root/BtnBack")
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.btnBack:SetActive(false)
  self.textInit = self:AddComponent(UIText, "Root/RightTopInfo/InitText")
  self.textInit:SetLocalText("dominator_rank_dec_2")
  self.compLayout = self:AddComponent(UIBaseContainer, "Root/RightTopInfo/Layout")
end

function UILWDominatorUpgradeBigRankView:ComponentDestroy()
  self.rawImgSkillPreviewRT = nil
  self.textTitleText = nil
  self.textTitleText1 = nil
  self.textTitleText2 = nil
  self.textPreName = nil
  self.textCurName = nil
  self.btnBack = nil
  self.compArrow = nil
  self.textInit = nil
  self.compLayout = nil
end

function UILWDominatorUpgradeBigRankView:DataDefine()
end

function UILWDominatorUpgradeBigRankView:DataDestroy()
  self.param = nil
end

function UILWDominatorUpgradeBigRankView:OnOpen()
  self.rawImgSkillPreviewRT:SetEnable(false)
  self.param = self:GetUserData()
  if self.param == nil then
    return
  end
  if self.param.preRankShowTemplate ~= nil then
    self.textPreName:SetActive(true)
    self.compArrow:SetActive(true)
    self.textPreName:SetText(self.param.preRankShowTemplate:GetName())
    self.textInit:SetActive(false)
    self.compLayout:SetActive(true)
  else
    self.textPreName:SetActive(false)
    self.compArrow:SetActive(false)
    self.textInit:SetActive(true)
    self.compLayout:SetActive(false)
  end
  if self.param.curRankShowTemplate then
    self.textCurName:SetText(self.param.curRankShowTemplate:GetName())
    self:ReleaseModel()
    if not string.IsNullOrEmpty(self.param.curRankShowTemplate.timeline_path) then
      self:LoadModel(self.param.curRankShowTemplate.timeline_path)
    end
  end
end

function UILWDominatorUpgradeBigRankView:OnClose()
  self:ReleaseTexture()
  if self.param and self.param.closeCallback then
    self.param.closeCallback()
  end
  if self.request ~= nil then
    self.request:Destroy()
  end
  self.request = nil
end

function UILWDominatorUpgradeBigRankView:LoadModel(prefabPath)
  local request = ResourceManager:InstantiateAsync(prefabPath)
  self.request = request
  self.request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    request.gameObject.transform:Set_position(self.defaultScenePos.x, self.defaultScenePos.y, self.defaultScenePos.z)
    self.camera = request.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Camera))
    self:SetSceneCameraActive(true)
    local director = request.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Playables.PlayableDirector))
    director:stopped("+", function()
      if self.btnBack then
        self.btnBack:SetActive(true)
      end
      if self.param and self.param.timelineCompleteCallback then
        self.param.timelineCompleteCallback()
      end
    end)
  end)
end

function UILWDominatorUpgradeBigRankView:SetSceneCameraActive(isActive)
  local sceneCamera = self.camera
  if sceneCamera ~= nil then
    sceneCamera.gameObject:SetActive(isActive)
    if isActive then
      self:SetRenderTexture(sceneCamera)
    else
      sceneCamera.targetTexture = nil
    end
  end
end

function UILWDominatorUpgradeBigRankView:SetRenderTexture(camera)
  if camera == nil then
    DataCenter.DominatorManager:PrintRealErrorLog("model camera is null")
    return
  end
  if self.renderTexture == nil and self.rawImgSkillPreviewRT then
    if Config.IsPC() then
      self.rtWidth = DefaultScreenWidth
      self.rtHeight = DefaultScreenHeight
    else
      local uiContainerRect = UIManager:GetInstance():GetUIContainerRect()
      local parentWidth = uiContainerRect.sizeDelta.x
      local parentHeight = uiContainerRect.sizeDelta.y
      self.rtWidth = math.floor(parentWidth)
      self.rtHeight = math.floor(parentHeight)
    end
    local rtFormat = RenderTextureFormat.ARGB32
    self.renderTexture = RenderTexture.GetTemporary(self.rtWidth, self.rtHeight, 24, rtFormat)
    self.renderTexture.name = "DominatorSimpleShow"
    self.rawImgSkillPreviewRT:SetTexture(self.renderTexture)
    self.rawImgSkillPreviewRT:SetEnable(true)
    self.rawImgSkillPreviewRT:SetColor(Color.New(1, 1, 1, 1))
  end
  camera.targetTexture = self.renderTexture
end

function UILWDominatorUpgradeBigRankView:ReleaseTexture()
  self.rawImgSkillPreviewRT:SetTexture(nil)
  if self.camera ~= nil then
    self.camera.targetTexture = nil
  end
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

function UILWDominatorUpgradeBigRankView:ReleaseModel()
  self.model = nil
  self.modelAnim = nil
  if self.modelRequest ~= nil then
    if not IsNull(self.modelRequest.gameObject) then
      self.modelRequest.gameObject.transform:DOKill()
    end
    self.modelRequest:Destroy()
    self.modelRequest = nil
  end
  self.modelAppearanceTemplate = nil
  self.isModelLoaded = false
end

function UILWDominatorUpgradeBigRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
end

function UILWDominatorUpgradeBigRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
  base.OnRemoveListener(self)
end

function UILWDominatorUpgradeBigRankView:OnPlotGroupDone(plotGroupId)
  if plotGroupId == DominatorGorillaTreatmentFinishPlotGroupId.Two then
    self.ctrl:CloseSelf()
  end
end

function UILWDominatorUpgradeBigRankView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

return UILWDominatorUpgradeBigRankView
