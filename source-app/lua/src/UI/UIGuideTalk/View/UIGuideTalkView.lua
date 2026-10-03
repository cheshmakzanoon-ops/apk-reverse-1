local UIGuideTalkView = BaseClass("UIGuideTalkView", UIBaseView)
local base = UIBaseView
local UIGuideTalkSelectBtn = require("UI.UIGuideTalk.Component.UIGuideTalkSelectBtn")
local UIGuideTalkScene = require("Scene.UIGuideTalkScene.UIGuideTalkScene")
local GameQualitySettings = require("Util.GameQualitySettings")
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local panel_path = "GuideTalkBtn"
local talk_bg_path = "TalkBg"
local talk_anim_path = ""
local talk_des_path = "TalkBg/TalkDes"
local btn_content_path = "TalkBg/BtnContent"
local btn_arrow_path = "TalkBg/TalkDes/ArrowGo/UIGuide_talk_arrow_yellow"
local npc_image_path = "NpcImage"
local LeftParam = {
  TalkBgName = "UIGuide_bg_talk_left",
  TalkBgShowAnimName = "UIGuideTalkShowLeft",
  TalkBgHideAnimName = "UIGuideTalkHideLeft",
  TalkShowNoMoveName = "UIGuideTalkShowNoMoveLeft",
  TalkHideNoMoveName = "UIGuideTalkHideNoMoveLeft",
  PaddingLeft = 85
}
local RightParam = {
  TalkBgName = "UIGuide_bg_talk_right",
  TalkBgShowAnimName = "UIGuideTalkShowRight",
  TalkBgHideAnimName = "UIGuideTalkHideRight",
  TalkShowNoMoveName = "UIGuideTalkShowNoMoveRight",
  TalkHideNoMoveName = "UIGuideTalkHideNoMoveRight",
  PaddingLeft = 55
}
local CloseAnimFunction = {Close = 1, Click = 2}
local defaultQuality

function UIGuideTalkView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIGuideTalkView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIGuideTalkView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.talk_bg = self:AddComponent(UIImage, talk_bg_path)
  self.talk_anim = self:AddComponent(UIAnimator, talk_anim_path)
  self.talk_des = self:AddComponent(UIText, talk_des_path)
  self.btn_arrow = self:AddComponent(UIBaseContainer, btn_arrow_path)
  self.btn_content = self:AddComponent(UIBaseContainer, btn_content_path)
  self.npc_image = self:AddComponent(UIRawImage, npc_image_path)
  self.talk_bg_layout = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, talk_bg_path)
  self.panel:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.npc_image:SetEnable(false)
end

function UIGuideTalkView:ComponentDestroy()
  self:DestroyModelScene()
  self.talk_bg_layout = nil
  self.panel = nil
  self.talk_bg = nil
  self.talk_anim = nil
  self.talk_des = nil
  self.btn_arrow = nil
  self.btn_content = nil
  self.npc_image = nil
end

function UIGuideTalkView:DataDefine()
  self.param = nil
  self.freeBtnCells = {}
  self.btnCells = {}
  
  function self.call_back()
    self:OnLoadModelCallBack()
  end
  
  self.modelScene = nil
  self.paramPara = nil
  
  function self.timer_action()
    self:TimerAction()
  end
  
  self.delayCloseTimer = nil
  
  function self.can_close_timer_action()
    self:CanCloseTimerAction()
  end
  
  function self.auto_to_do_next_timer_action()
    self:AutoDoNextTimerAction()
  end
  
  self.canCloseTimer = nil
  self.canClose = true
  self.closeFun = CloseAnimFunction.Close
  self.autoDoNextTimer = nil
  self.modelName = nil
  self.modelReq = nil
  self.selectBtnReq = {}
end

function UIGuideTalkView:DataDestroy()
  self:DeleteAutoDoNextTimer()
  self:DeleteDelayTimer()
  self:DeleteCanCloseTimer()
  self.param = nil
  self.freeBtnCells = {}
  self.btnCells = {}
  self.call_back = nil
  self.modelScene = nil
  self.paramPara = nil
  self.canClose = nil
  self.closeFun = nil
  self.autoDoNextTimer = nil
  self.modelName = nil
  self.modelReq = nil
  self.selectBtnReq = nil
end

function UIGuideTalkView:OnEnable()
  base.OnEnable(self)
end

function UIGuideTalkView:OnDisable()
  base.OnDisable(self)
end

function UIGuideTalkView:ReInit()
  self.param = self:GetUserData()
  self:Refresh()
end

function UIGuideTalkView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
  self:AddUIListener(EventId.RefreshGuideAnim, self.RefreshGuideAnimSignal)
end

function UIGuideTalkView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
  self:RemoveUIListener(EventId.RefreshGuideAnim, self.RefreshGuideAnimSignal)
end

function UIGuideTalkView:Refresh()
  if self.param ~= nil then
    self.gameObject:SetActive(true)
    self:AddAutoDoNextTimer(self.param.time)
    self:LoadScene()
    self.talk_des:SetText(self.param.dialog)
    if self.param.modelPosition == GuideNpcPosition.Left then
      self.paramPara = LeftParam
    else
      self.paramPara = RightParam
    end
    self.talk_bg_layout:SetPaddingLeft(self.paramPara.PaddingLeft)
    self.talk_bg:LoadSprite(string.format(LoadPath.Guide, self.paramPara.TalkBgName))
    if self.param.modelPosition == self.modelPosition and self.modelName == self.param.modelName then
      self.talk_anim:Play(self.paramPara.TalkShowNoMoveName, 0, 0)
    else
      self.modelPosition = self.param.modelPosition
      self.modelName = self.param.modelName
      self.talk_anim:Play(self.paramPara.TalkBgShowAnimName, 0, 0)
    end
    self:ShowCells(self.param.cellParam)
    if self.param.canCloseTime == nil or 0 >= self.param.canCloseTime then
      self.btn_arrow:SetActive(true)
      self.canClose = true
    else
      self.btn_arrow:SetActive(false)
      self.canClose = false
      self:AddCanCloseTimer(self.param.canCloseTime)
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.talk_bg_layout.rectTransform)
  end
end

function UIGuideTalkView:RefreshGuideSignal()
  self:DeleteAutoDoNextTimer()
  local guideType = DataCenter.GuideManager:GetGuideType()
  if guideType == GuideType.ShowTalk then
    self:DeleteDelayTimer()
    self.gameObject:SetActive(false)
  elseif self.paramPara == nil then
    self.ctrl:CloseSelf()
  elseif self.delayCloseTimer == nil then
    self.closeFun = CloseAnimFunction.Close
    self:DoCloseAnim()
  end
end

function UIGuideTalkView:OnBtnClick()
  if self.canClose then
    self.canClose = false
    self:DeleteAutoDoNextTimer()
    self.closeFun = CloseAnimFunction.Click
    local nextType = DataCenter.GuideManager:GetNextGuideTemplateParam("type")
    if nextType == GuideType.ShowTalk then
      local para2 = DataCenter.GuideManager:GetNextGuideTemplateParam("para2")
      if para2 ~= nil and para2 ~= "" then
        local spl = string.split(para2, ",")
        if 3 < #spl then
          local modelposition = tonumber(spl[4])
          local modelName = spl[2]
          if self.modelPosition == modelposition and self.modelName == modelName then
            self:TimerAction()
          else
            self:DoCloseAnim()
          end
        end
      end
    else
      self:TimerAction()
    end
  end
end

function UIGuideTalkView:ShowCells(list)
  self:DestroyBtnReq()
  for k, v in pairs(self.btnCells) do
    v:SetActive(false)
    table.insert(self.freeBtnCells, v)
  end
  self.btnCells = {}
  if list == nil then
    self.btn_content:SetActive(false)
  else
    self.btn_content:SetActive(true)
    for k, v in ipairs(list) do
      self:AddOneBtnCells(v)
    end
  end
end

function UIGuideTalkView:AddOneBtnCells(param)
  if #self.freeBtnCells > 0 then
    local temp = table.remove(self.freeBtnCells)
    if temp ~= nil then
      temp:SetActive(true)
      temp:ReInit(param)
      temp.transform:SetParent(self.btn_content.transform)
      temp.transform:SetAsLastSibling()
      table.insert(self.btnCells, temp)
    end
  else
    local nameStr = tostring(NameCount)
    NameCount = NameCount + 1
    self.selectBtnReq[nameStr] = self:GameObjectInstantiateAsync(UIAssets.UIGuideTalkSelectBtn, function(request)
      if request.isError then
        return
      end
      self.selectBtnReq[nameStr] = nil
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.btn_content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:SetAsLastSibling()
      go.name = nameStr
      local temp = self.btn_content:AddComponent(UIGuideTalkSelectBtn, nameStr)
      temp:ReInit(param)
      table.insert(self.btnCells, temp)
    end)
  end
end

function UIGuideTalkView:LoadScene()
  local param = {}
  param.modelName = self.param.modelName
  param.modelAction = self.param.modelAction
  param.callBack = self.call_back
  if self.modelReq == nil then
    self.modelReq = self:GameObjectInstantiateAsync(UIAssets.UIGuideTalkScene, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(false)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:Set_localPosition(0, -100, 0)
      self.modelScene = UIGuideTalkScene.New()
      self.modelScene:OnCreate(request)
      self.modelScene:ReInit(param)
    end)
  elseif self.modelScene ~= nil then
    self.modelScene:ReInit(param)
  end
end

function UIGuideTalkView:DestroyModelScene()
  self:ReleaseTexture()
  if self.modelScene ~= nil then
    self.modelScene:OnDestroy()
    self.modelScene = nil
  end
  self.modelReq = nil
end

function UIGuideTalkView:AddDelayTimer(time)
  self:DeleteDelayTimer()
  self.delayCloseTimer = TimerManager:GetInstance():GetTimer(time, self.timer_action, self, true, false, false)
  self.delayCloseTimer:Start()
end

function UIGuideTalkView:TimerAction()
  self:DeleteDelayTimer()
  if self.closeFun == CloseAnimFunction.Close then
    self.ctrl:CloseSelf()
  elseif self.closeFun == CloseAnimFunction.Click then
    DataCenter.GuideManager:HasClick(panel_path)
  end
end

function UIGuideTalkView:DeleteDelayTimer()
  if self.delayCloseTimer then
    self.delayCloseTimer:Stop()
    self.delayCloseTimer = nil
  end
end

function UIGuideTalkView:RefreshGuideAnimSignal(param)
  self.param = param
  self:Refresh()
end

function UIGuideTalkView:AddCanCloseTimer(time)
  self:DeleteCanCloseTimer()
  self.canCloseTimer = TimerManager:GetInstance():GetTimer(time, self.can_close_timer_action, self, true, false, false)
  self.canCloseTimer:Start()
end

function UIGuideTalkView:CanCloseTimerAction()
  self:DeleteCanCloseTimer()
  self.canClose = true
  self.btn_arrow:SetActive(true)
end

function UIGuideTalkView:DeleteCanCloseTimer()
  if self.canCloseTimer ~= nil then
    self.canCloseTimer:Stop()
    self.canCloseTimer = nil
  end
end

function UIGuideTalkView:AddAutoDoNextTimer(time)
  self:DeleteAutoDoNextTimer()
  if time ~= nil and 0 < time then
    self.autoDoNextTimer = TimerManager:GetInstance():GetTimer(time, self.auto_to_do_next_timer_action, self, true, false, false)
    self.autoDoNextTimer:Start()
  end
end

function UIGuideTalkView:AutoDoNextTimerAction()
  self.canClose = true
  DataCenter.GuideManager:SetNoGotoTime(true)
  self:DeleteAutoDoNextTimer()
  self:OnBtnClick()
end

function UIGuideTalkView:DeleteAutoDoNextTimer()
  if self.autoDoNextTimer then
    self.autoDoNextTimer:Stop()
    self.autoDoNextTimer = nil
  end
end

function UIGuideTalkView:DoCloseAnim()
  local hideName = self.paramPara.TalkBgHideAnimName
  if self.modelName == nil or self.modelName == "" then
    hideName = self.paramPara.TalkHideNoMoveName
  end
  local ret, time = self.talk_anim:PlayAnimationReturnTime(hideName)
  if ret and 0 < time then
    self:AddDelayTimer(time)
  else
    self:TimerAction()
  end
end

function UIGuideTalkView:OnRenderTexture(go)
  if self.renderTexture == nil then
    local scale = 0.7
    local rtFormat = RenderTextureFormat.ARGB32
    if GameQualitySettings.IsHighGearQuality() then
      rtFormat = RenderTextureFormat.ARGBHalf
    else
      scale = 0.5
      local volume = go.transform:Find("Npc_scene/Global Volume")
      local cameraData = go.transform:Find("Npc_scene/Camera"):GetComponent(typeof(CS.UnityEngine.Rendering.Universal.UniversalAdditionalCameraData))
      if cameraData ~= nil then
        cameraData.renderPostProcessing = false
      end
      if volume ~= nil then
        volume.gameObject:SetActive(false)
      end
    end
    local rtWidth = 1920 * scale
    local rtHeight = 1080 * scale
    self.renderTexture = RenderTexture.GetTemporary(rtWidth, rtHeight, 24, rtFormat)
    self.renderTexture.useMipMap = false
    self.renderTexture.name = "GuideNpc"
    self.npc_image:SetTexture(self.renderTexture)
    self.npc_image:SetEnable(true)
    self.npc_image:SetColor(Color.New(1, 1, 1, 1))
  end
  self.modelScene:OnRenderTexture(self.renderTexture)
end

function UIGuideTalkView:ReleaseTexture()
  self.npc_image:SetTexture(nil)
  if self.modelScene ~= nil then
    self.modelScene:ReleaseTexture()
  end
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

function UIGuideTalkView:DestroyBtnReq()
  if self.selectBtnReq ~= nil then
    for k, v in pairs(self.selectBtnReq) do
      v:Destroy()
    end
    self.selectBtnReq = {}
  end
end

function UIGuideTalkView:OnLoadModelCallBack()
  if self.modelScene ~= nil then
    self:OnRenderTexture(self.modelScene.gameObject)
    self.modelScene.gameObject:SetActive(true)
  end
end

return UIGuideTalkView
