local UILWT11IdleGameSurpriseBoxView = BaseClass("UILWT11IdleGameSurpriseBoxView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
local ResourceManager = CS.GameEntry.Resource
local Camera = CS.UnityEngine.Camera
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local UILWT11IdleGameSurpriseBoxItemComponent = require("UI/T11IdleGame/T11IdleGameSurpriseBox/Component/UILWT11IdleGameSurpriseBoxItemComponent")
UILWT11IdleGameSurpriseBoxView.TotalItemCount = 100
UILWT11IdleGameSurpriseBoxView.FakeShowIndex = 82
UILWT11IdleGameSurpriseBoxView.FastEndIndex = 60
UILWT11IdleGameSurpriseBoxView.MidEndIndex = 78
UILWT11IdleGameSurpriseBoxView.ItemIndexDelta = 2
UILWT11IdleGameSurpriseBoxView.ScrollSpeedFast = 2500
UILWT11IdleGameSurpriseBoxView.ScrollSpeedMid = 1000
UILWT11IdleGameSurpriseBoxView.ScrollSpeedSlow = 500

function UILWT11IdleGameSurpriseBoxView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
  self.param = self:GetUserData()
end

function UILWT11IdleGameSurpriseBoxView:OnDestroy()
  if self.param and self.param.closeCallback then
    self.param.closeCallback()
  end
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWT11IdleGameSurpriseBoxView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnUICommonBlackMask = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnUICommonBlackMask:SetOnClick(function()
    self:OnBtnUICommonBlackMaskClick()
  end)
  self.btnLWInfo = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnLWInfo:SetOnClick(function()
    self:OnBtnLWInfoClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.rawImgRT = self.viewSkin:AddComponent(self, UIRawImage, 4)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.btnClaim = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnClaim:SetOnClick(function()
    self:OnBtnClaimClick()
  end)
  self.textClaim = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.animatorUILWT11IdleGameSurpriseBox = self.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
  self.dotweenContent = self.transform:Find("Center/Scroll/ScrollView/Viewport/Content"):GetComponent(typeof(CS.DG.Tweening.DOTweenAnimation))
  self.textTitle:SetLocalText("t11_idle_game_desc_24")
  self.textClaim:SetLocalText("t11_idle_game_button_25")
  self.sceneReq = nil
  self.sceneCamera = nil
  self.renderTexture = nil
  self.sceneEffectOpen = nil
  self.sceneEffectIdle = nil
  self.sceneEffectInit = nil
  self.sceneAnim = nil
  self.rawImgRT:SetEnable(false)
  self.items = {}
end

function UILWT11IdleGameSurpriseBoxView:ComponentDestroy()
  self:DestroyScene()
  self.items = nil
  self.dotweenContent = nil
  self.animatorUILWT11IdleGameSurpriseBox = nil
  self.viewSkin = nil
  self.btnUICommonBlackMask = nil
  self.btnLWInfo = nil
  self.textTitle = nil
  self.rawImgRT = nil
  self.compContent = nil
  self.btnClaim = nil
  self.textClaim = nil
end

function UILWT11IdleGameSurpriseBoxView:DataDefine()
  self.curAnimState = 0
  self.realReward = nil
  self.hasPlay = false
  self.hasDoneScene = false
  self.hasDoneItems = false
  self.hasSendClaim = false
  self.param = nil
end

function UILWT11IdleGameSurpriseBoxView:DataDestroy()
  if self.delayShowEffectTimer then
    self.delayShowEffectTimer:Stop()
    self.delayShowEffectTimer = nil
  end
  self.curAnimState = nil
  self.realReward = nil
  self.hasPlay = nil
  self.hasDoneScene = nil
  self.hasDoneItems = nil
  self.hasSendClaim = nil
  self.param = nil
end

function UILWT11IdleGameSurpriseBoxView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.T11IdleGameOnOpenSurpriseBoxMessage, self.OnOpenSurpriseBoxMsg)
end

function UILWT11IdleGameSurpriseBoxView:OnRemoveListener()
  self:RemoveUIListener(EventId.T11IdleGameOnOpenSurpriseBoxMessage, self.OnOpenSurpriseBoxMsg)
  base.OnRemoveListener(self)
end

function UILWT11IdleGameSurpriseBoxView:OnOpen()
  self.btnClaim:SetActive(false)
  self:CreateScene()
  self.compContent:SetActive(false)
  self.rewardList = self.ctrl:GetFakeGetTotalRewardList(self.TotalItemCount)
  local count = #self.rewardList
  for i, v in ipairs(self.rewardList) do
    self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/T11IdleGame/SurpriseBox/UILWT11IdleGameSurpriseBoxItem.prefab", function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.compContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = i
      local cellItem = self.compContent:AddComponent(UILWT11IdleGameSurpriseBoxItemComponent, go.name)
      cellItem:ReInit(v)
      self.items[i] = cellItem
      if i == count then
        self.compContent:SetActive(true)
        self.compContent:SetAnchoredPositionXY(0, 0)
        self.hasDoneItems = true
        self:OnLoadDone()
      end
    end)
  end
  self.animatorUILWT11IdleGameSurpriseBox:Play("V_ui_UILWT11IdleGameSurpriseBox_in", 0, 0)
  self.animatorUILWT11IdleGameSurpriseBox:Update(0)
  self.animatorUILWT11IdleGameSurpriseBox.enabled = false
end

function UILWT11IdleGameSurpriseBoxView:OnLoadDone()
  if self.hasDoneItems == true and self.hasDoneScene == true then
    self.btnClaim:SetActive(true)
  end
end

function UILWT11IdleGameSurpriseBoxView:PlayAnim()
  if self.hasPlay == true then
    return
  end
  self.hasPlay = true
  
  function self.dotweenContent.tween.onComplete()
    self:OnPlayFinish()
  end
  
  self.dotweenContent:DOPlay()
  if IsNotNull(self.sceneEffectOpen) then
    self.sceneEffectOpen:SetActive(true)
  end
  if IsNotNull(self.sceneEffectIdle) then
    self.sceneEffectIdle:SetActive(false)
  end
  if IsNotNull(self.sceneAnim) then
    self.sceneAnim:Play("Open")
  end
  self.animatorUILWT11IdleGameSurpriseBox:Play("V_ui_UILWT11IdleGameSurpriseBox_roll")
end

function UILWT11IdleGameSurpriseBoxView:CreateScene()
  local request = ResourceManager:InstantiateAsync(Const.SurpriseBoxSceneAssetPath)
  self.sceneRootReq = request
  self.sceneRootReq:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    request.gameObject.transform:Set_position(Const.DefaultSurpriseBoxSceneRootPos.x, Const.DefaultSurpriseBoxSceneRootPos.y, Const.DefaultSurpriseBoxSceneRootPos.z)
    self.sceneCamera = request.gameObject.transform:GetComponentInChildren(typeof(Camera), true)
    self.sceneEffectOpen = request.gameObject.transform:Find("A_Prop_choujiangbaoxiang_t11_idle_game_timeline/Model/Eff_T11_Box_Open").gameObject
    self.sceneEffectIdle = request.gameObject.transform:Find("A_Prop_choujiangbaoxiang_t11_idle_game_timeline/Model/Eff_T11_Box_Loop").gameObject
    self.sceneEffectInit = request.gameObject.transform:Find("A_Prop_choujiangbaoxiang_t11_idle_game_timeline/Model/A_Prop_choujiangbaoxiang_t11_idle_game/A_Prop_jingqichoujiangbaoxiang_t11_idle_game_skin/To_unity/DeformationSystem/xiangzi/Root_M/Eff_T11_Box_Start_RootM").gameObject
    self.sceneAnim = request.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    if IsNull(self.sceneCamera) or self.rawImgRT == nil then
      return
    end
    self.sceneEffectOpen:SetActive(false)
    self.sceneEffectIdle:SetActive(false)
    if self.renderTexture == nil then
      local rtWidth = math.floor(self.rawImgRT.rectTransform.rect.width)
      local rtHeight = math.floor(self.rawImgRT.rectTransform.rect.height)
      local rtFormat = RenderTextureFormat.ARGB32
      self.renderTexture = RenderTexture.GetTemporary(rtWidth, rtHeight, 24, rtFormat)
      self.renderTexture.name = "T11IdleGameTexture" .. rtWidth .. "*" .. rtHeight
    end
    self.rawImgRT:SetTexture(self.renderTexture)
    self.rawImgRT:SetEnable(true)
    self.rawImgRT:SetColor(Color.New(1, 1, 1, 1))
    self.sceneCamera.targetTexture = self.renderTexture
    self.sceneAnim:Play("Born")
    self.sceneAnim:PlayQueued("Idle")
    self.sceneEffectInit:SetActive(true)
    local time = self.sceneAnim:GetClipLength("Born")
    self.delayShowEffectTimer = TimerManager:GetInstance():DelayInvoke(function()
      if IsNotNull(self.sceneEffectIdle) then
        self.sceneEffectIdle:SetActive(true)
      end
      if IsNotNull(self.sceneEffectOpen) then
        self.sceneEffectOpen:SetActive(false)
      end
      if self.animatorUILWT11IdleGameSurpriseBox ~= nil then
        self.animatorUILWT11IdleGameSurpriseBox.enabled = true
        self.animatorUILWT11IdleGameSurpriseBox:Play("V_ui_UILWT11IdleGameSurpriseBox_in")
      end
      self.delayShowEffectTimer = nil
    end, time)
    self.hasDoneScene = true
    self:OnLoadDone()
  end)
end

function UILWT11IdleGameSurpriseBoxView:DestroyScene()
  if IsNotNull(self.sceneCamera) then
    self.sceneCamera.targetTexture = nil
  end
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
  if self.sceneRootReq ~= nil then
    self.sceneRootReq:Destroy()
    self.sceneRootReq = nil
  end
  self.sceneCamera = nil
  self.sceneEffectOpen = nil
  self.sceneEffectIdle = nil
  self.sceneEffectInit = nil
  self.sceneAnim = nil
end

function UILWT11IdleGameSurpriseBoxView:OnBtnUICommonBlackMaskClick()
  if self.hasSendClaim then
    self.ctrl:CloseSelf()
  end
end

function UILWT11IdleGameSurpriseBoxView:OnBtnLWInfoClick()
end

function UILWT11IdleGameSurpriseBoxView:OnBtnClaimClick()
  DataCenter.T11IdleGameDataManager:SendOpenSurpriseBoxMessage()
  self.btnClaim:SetActive(false)
  self.hasSendClaim = true
  if self.delayShowEffectTimer then
    self.delayShowEffectTimer:Stop()
    self.delayShowEffectTimer = nil
  end
end

function UILWT11IdleGameSurpriseBoxView:OnOpenSurpriseBoxMsg(msg)
  if msg == nil or msg.surpriseRewards == nil then
    return
  end
  self.realReward = msg.surpriseRewards[1]
  if self.realReward == nil then
    return
  end
  self.rewardList = self.ctrl:GetTotalRewardList(self.realReward, self.TotalItemCount, self.FakeShowIndex)
  for i, v in ipairs(self.rewardList) do
    if self.items and self.items[i] then
      self.items[i]:ReInit(v)
    end
  end
  self:PlayAnim()
end

function UILWT11IdleGameSurpriseBoxView:OnPlayFinish()
  if self.realReward then
    local param = {}
    param.reward = {
      self.realReward
    }
    DataCenter.RewardManager:ShowCommonReward(param, nil, nil, nil, nil, nil, function()
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWT11IdleGameSurpriseBox)
    end)
  end
end

return UILWT11IdleGameSurpriseBoxView
