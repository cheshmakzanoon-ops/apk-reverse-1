local UIExplorerTreasureRewardView = BaseClass("UIExplorerTreasureRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local DISPLAY_SCENE_PATH = "Assets/Main/Prefabs/DispatchTask/ExplorerTreasure/DisplayScene_baoxiang.prefab"
local ResourceManager = CS.GameEntry.Resource
local RenderTexture = CS.UnityEngine.RenderTexture
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local Setting = CS.GameEntry.Setting
local ScaleParam = {
  1.8,
  1.95,
  2.1,
  2.25,
  2.4,
  2.5
}
local Guide_CD = 3
local Anim_Speed = 1.7
local ColorStr = {
  [1] = "#5FEF87",
  [2] = "#70E6F1",
  [3] = "#EB86FF",
  [4] = "#FFB644",
  [5] = "#FB7156"
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
  self:LoadScene()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.rawImgBox = self:AddComponent(UIRawImage, "rawImageBox")
  self.textName = self:AddComponent(UITextMeshProUGUIEx, "textName")
  self.textDes = self:AddComponent(UITextMeshProUGUIEx, "textDes")
  self.effectOpening = self:AddComponent(UIBaseContainer, "effct/mask/Eff_ui_xiangzi_bgopen")
  self.effectNormal = self:AddComponent(UIBaseContainer, "effct2/mask/Eff_ui_xiangzi_update_noraml")
  self.compContent = self:AddComponent(UIBaseContainer, "ItemScroll/Viewport/Content")
  self.compItem = self:AddComponent(UIBaseContainer, "ItemScroll/item")
  self.effectSpecial = self:AddComponent(UIBaseContainer, "effct2/mask/Eff_ui_xiangzi_update_special")
  self.effectOpen = self:AddComponent(UIBaseContainer, "effct2/mask/Eff_ui_xiangzi_open")
  self.effectNormal2 = self:AddComponent(UIBaseContainer, "effct/mask/Eff_ui_xiangzi_update_noramlquan")
  self.effectBg = self:AddComponent(UIBaseContainer, "effct/mask/Eff_ui_xiangzi_bgidle01")
  self.effectRotate = self:AddComponent(UIBaseContainer, "effct2/Eff_ui_xiangzi_xuanzhuanyanwu")
  self.textDes2 = self:AddComponent(UITextMeshProUGUIEx, "textDes2")
  self.effectGuideTemp = self:AddComponent(UIBaseContainer, "tishiquan")
  self.effectQuick = self:AddComponent(UIBaseContainer, "effct2/mask/Eff_ui_xiangzi_update_quick")
  self.rawImgBox:SetEnable(false)
  self.compItem.gameObject:GameObjectCreatePool()
  self.textName:SetLocalText("explorer_treasure_reward_09")
  self.effectGuide = self.effectGuideTemp.gameObject:GameObjectSpawn(self.transform)
  self.effectGuide:SetActive(false)
end

local function ComponentDestroy(self)
  for i = 1, #self.tItemList do
    if IsNotNull(self.tItemList[i].btn) then
      self.tItemList[i].btn.onClick:RemoveAllListeners()
    end
  end
  self.compItem.gameObject:GameObjectRecycleAll()
  self.tItemList = nil
  if self.sceneRequest ~= nil then
    self.sceneRequest:Destroy()
    self.sceneRequest = nil
  end
  self.effectGuide.gameObject:Destroy()
  self:ReleaseTexture()
  self.btnPanel = nil
  self.rawImgBox = nil
  self.textName = nil
  self.textName = nil
  self.textDes = nil
  self.effectOpening = nil
  self.effectNormal = nil
  self.compContent = nil
  self.compItem = nil
  self.effectSpecial = nil
  self.effectOpen = nil
  self.effectNormal2 = nil
  self.effectBg = nil
  self.effectRotate = nil
  self.textDes2 = nil
  self.effectGuideTemp = nil
  self.effectQuick = nil
end

local function DataDefine(self)
  self.bIsShow = true
  self.defaultScenePos = Vector3.New(-1000, 1000, -1000)
  self.tMessage = self:GetUserData()
  self.nNeedItemNum = DataCenter.ExplorerTreasureManager:GetTreasureOpenNeedItemNum()
  self.nMaxLevel = self.nNeedItemNum + 1
  self.nLeftOpenNum = self.nNeedItemNum
  self.textDes:SetLocalText("explorer_treasure_open_02", self.nLeftOpenNum)
  self.textDes2:SetLocalText("explorer_treasure_open_01")
  self.nQuality = self.tMessage.quality or 1
  self.tResult = self:RandomSelectShuffle(self.nNeedItemNum, self.nQuality)
  self.bIsAutoOpen = Setting:GetBool("ExplorerTreasureAutoOpen", false)
  self.nGuideTime = 0
end

local function RandomSelectShuffle(self, nMax, nUpgradeTimes)
  math.randomseed(SafeLocalOsTime())
  local tIndices = {}
  for i = 1, nMax do
    tIndices[i] = i
  end
  local nLength = #tIndices
  for i = nLength, 2, -1 do
    local j = math.random(i)
    tIndices[i], tIndices[j] = tIndices[j], tIndices[i]
  end
  local tResult = {}
  for i = 1, nUpgradeTimes do
    tResult[tIndices[i]] = true
  end
  return tResult
end

local function DataDestroy(self)
  self.bIsShow = nil
  self.nNeedItemNum = 0
  self.nLeftOpenNum = 0
  self.defaultScenePos = nil
  self.tBoxList = nil
  self.tMessage = nil
  self.nQuality = 0
  self.tResult = nil
  self.bIsAutoOpen = false
  self.nCurBoxLevel = 0
  self.curBox = nil
  self.tOpenRecord = nil
  self.nMaxLevel = 0
  self.nGuideTime = 0
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnRewardGetPanelClose, self.OnRewardGetPanelClose)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnRewardGetPanelClose, self.OnRewardGetPanelClose)
  base.OnRemoveListener(self)
end

local function OnBtnPanelClick(self)
end

local function InitView(self)
  self.compItem.gameObject:GameObjectRecycleAll()
  self.tItemList = {}
  for i = 1, self.nNeedItemNum do
    local item = self.compItem.gameObject:GameObjectSpawn(self.compContent.transform)
    item.gameObject:SetActive(true)
    item.name = i
    self.tItemList[i] = {}
    self.tItemList[i].trans = item.transform
    self.tItemList[i].img = item.transform:Find("imgKey"):GetComponent(typeof(CS.UnityEngine.UI.Image))
    self.tItemList[i].img.gameObject:SetActive(false)
    self.tItemList[i].transQuestion = item.transform:Find("Image")
    self.tItemList[i].transQuestion.gameObject:SetActive(true)
    self.tItemList[i].animator = item:GetComponent(typeof(CS.UnityEngine.Animator))
    self.tItemList[i].animator:Play("UIExplorerTreasureRewardGenerate", 0, 0)
    self.tItemList[i].transEffectPoint = item.transform:Find("effectPoint")
    self.tItemList[i].btn = item.transform:Find("imgEmpty"):GetComponent(typeof(CS.UnityEngine.UI.Button))
    self.tItemList[i].btn.onClick:RemoveAllListeners()
    self.tItemList[i].btn.onClick:AddListener(function()
      if not self.bIsAutoOpen then
        self:OnBtnItemClick(i)
      end
    end)
  end
  self.textDes:SetActive(not self.bIsAutoOpen)
  self.textDes2:SetActive(not self.bIsAutoOpen)
  self.effectNormal:SetActive(false)
  self.effectNormal2:SetActive(false)
  self.effectSpecial:SetActive(false)
  self.effectOpening:SetActive(false)
  self.effectOpen:SetActive(false)
  self.effectRotate:SetActive(false)
  self.effectQuick:SetActive(false)
  local nScale = ScaleParam[1]
  self.effectRotate.transform:Set_localScale(nScale, nScale, nScale)
  self.effectBg:SetActive(true)
end

local function LoadScene(self)
  local request = ResourceManager:InstantiateAsync(DISPLAY_SCENE_PATH)
  self.sceneRequest = request
  self.sceneRequest:completed("+", function()
    if request.isError then
      return
    end
    self.sceneObj = request.gameObject
    self.sceneObj:SetActive(true)
    self.sceneObj.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.sceneObj.transform:Set_position(self.defaultScenePos.x, self.defaultScenePos.y, self.defaultScenePos.z)
    local rtWidth = DefaultScreenWidth
    local rtHeight = DefaultScreenHeight
    local rtFormat = RenderTextureFormat.ARGB32
    self.renderTexture = RenderTexture.GetTemporary(rtWidth, rtHeight, 24, rtFormat)
    self.renderTexture.name = "TreasureReward"
    self.rawImgBox:SetTexture(self.renderTexture)
    self.rawImgBox:SetEnable(true)
    self.rawImgBox:SetColor(Color.New(1, 1, 1, 1))
    local camera = self.sceneObj.transform:Find("Camera"):GetComponentInChildren(typeof(CS.UnityEngine.Camera))
    camera.targetTexture = self.renderTexture
    self.sceneCamera = camera
    self.tBoxList = {}
    local nTotal = self.nNeedItemNum + 1
    for i = 1, nTotal do
      self.tBoxList[i] = {}
      local trans = self.sceneObj.transform:Find("HeroSlot/O_env_baoxiang_lv0" .. i)
      self.tBoxList[i].trans = trans
      self.tBoxList[i].trans.gameObject:SetActive(false)
      self.tBoxList[i].simpleAnim = trans:GetComponentInChildren(typeof(CS.SimpleAnimation))
    end
    self.nCurBoxLevel = 1
    self.curBox = self.tBoxList[1]
    self.curBox.trans.gameObject:SetActive(true)
    self.tOpenRecord = {}
    if self.bIsAutoOpen then
      self:DoAutoOpen()
    end
  end)
end

local function Update1000MS(self)
  if not self.bIsShow then
    return
  end
  self.nGuideTime = self.nGuideTime + 1
  if self.nGuideTime >= Guide_CD then
    self:ShowGuideToClick()
  end
end

local function ShowGuideToClick(self)
  if IsNull(self.effectGuide) or self.effectGuide.gameObject.activeSelf then
    return
  end
  for i = 1, self.nNeedItemNum do
    if not self.tOpenRecord[i] then
      self.effectGuide:SetActive(true)
      self.effectGuide.transform:SetParent(self.tItemList[i].transEffectPoint)
      self.effectGuide.transform:Set_localPosition(0, 0, 0)
      self.effectGuide.transform:Set_localRotation(0, 0, 0, 0)
      break
    end
  end
end

local function OnBtnItemClick(self, index)
  if self.tBoxList == nil or self.tOpenRecord == nil or self.tOpenRecord[index] then
    return
  end
  self.tOpenRecord[index] = true
  self.nLeftOpenNum = self.nLeftOpenNum - 1
  self.tItemList[index].transQuestion.gameObject:SetActive(false)
  self.textDes:SetLocalText("explorer_treasure_open_02", self.nLeftOpenNum)
  self.tItemList[index].img.gameObject:SetActive(true)
  self.tItemList[index].animator:Play("UIExplorerTreasureRewardItemIn", 0, 0)
  self.nGuideTime = 0
  self.effectGuide:SetActive(false)
  if self.tResult[index] then
    self.nCurBoxLevel = self.nCurBoxLevel + 1
    local nScale = ScaleParam[self.nCurBoxLevel]
    self.effectRotate.transform:Set_localScale(nScale, nScale, nScale)
    self.curBox.trans.gameObject:SetActive(false)
    self.curBox = self.tBoxList[self.nCurBoxLevel]
    self.curBox.trans.gameObject:SetActive(true)
    if self.nMaxLevel == self.nCurBoxLevel then
      self:PlayEffect(self.effectSpecial)
    end
    self:PlayEffect(self.effectNormal)
    self:PlayEffect(self.effectNormal2)
    self:PlayEffect(self.effectRotate)
    self:PlayEffect(self.effectRotate2)
  end
  local nLevel = self.nCurBoxLevel - 1
  if 0 < nLevel then
    local sName = DataCenter.ExplorerTreasureManager:GetRewardBoxName(nLevel)
    local sNameStr = Localization:GetString(sName)
    local sColor = ColorStr[nLevel] or ColorStr[1]
    sName = string.format("<color=%s>%s</color>", sColor, sNameStr)
    self.textName:SetText(sName)
  end
  self.curBox.simpleAnim:SetStateSpeed("upgrade", Anim_Speed)
  self:PlayAnim(self.curBox.simpleAnim, "upgrade")
  if self.nLeftOpenNum <= 0 then
    local bIsMax = self.nCurBoxLevel == 6
    if not bIsMax then
      TimerManager:GetInstance():DelayInvoke(function()
        self.curBox.simpleAnim:Play("quick")
      end, 0.5)
      TimerManager:GetInstance():DelayInvoke(function()
        self:PlayEffect(self.effectQuick)
      end, 0.78)
      TimerManager:GetInstance():DelayInvoke(function()
        if not self.bIsShow then
          return
        end
        DataCenter.RewardManager:ShowCommonReward(self.tMessage)
      end, 1)
      return
    end
    TimerManager:GetInstance():DelayInvoke(function()
      if not self.bIsShow then
        return
      end
      self.effectBg:SetActive(false)
      self:PlayEffect(self.effectOpening)
      self.curBox.simpleAnim:SetStateSpeed("open", Anim_Speed)
      self.curBox.simpleAnim:Play("open")
    end, 0.5)
    TimerManager:GetInstance():DelayInvoke(function()
      if not self.bIsShow then
        return
      end
      self:PlayEffect(self.effectOpen)
    end, 2)
    TimerManager:GetInstance():DelayInvoke(function()
      if not self.bIsShow then
        return
      end
      DataCenter.RewardManager:ShowCommonReward(self.tMessage)
    end, 2.5)
  end
end

local function PlayEffect(self, obj)
  if IsNull(obj) then
    return
  end
  obj:SetActive(false)
  obj:SetActive(true)
end

local function PlayAnim(self, animComp, sAnimName)
  if self:IsPlaying(animComp, sAnimName) then
    animComp:Rewind(sAnimName)
  else
    animComp:Play(sAnimName)
  end
end

local function IsPlaying(self, animComp, animName)
  local anim = animComp:GetState(animName)
  if anim == nil then
    return false
  end
  return animComp:IsPlaying(animName)
end

local function ReleaseTexture(self)
  self.rawImgBox:SetTexture(nil)
  if self.sceneCamera ~= nil then
    self.sceneCamera.targetTexture = nil
  end
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

local function DoAutoOpen(self)
  for i = 1, self.nNeedItemNum do
    TimerManager:GetInstance():DelayInvoke(function()
      if not self.bIsShow then
        return
      end
      self:OnBtnItemClick(i)
    end, 0.5 * i)
  end
end

local function OnRewardGetPanelClose(self)
  self.ctrl.CloseSelf()
end

UIExplorerTreasureRewardView.OnCreate = OnCreate
UIExplorerTreasureRewardView.OnDestroy = OnDestroy
UIExplorerTreasureRewardView.OnEnable = OnEnable
UIExplorerTreasureRewardView.OnDisable = OnDisable
UIExplorerTreasureRewardView.ComponentDefine = ComponentDefine
UIExplorerTreasureRewardView.ComponentDestroy = ComponentDestroy
UIExplorerTreasureRewardView.DataDefine = DataDefine
UIExplorerTreasureRewardView.DataDestroy = DataDestroy
UIExplorerTreasureRewardView.OnAddListener = OnAddListener
UIExplorerTreasureRewardView.OnRemoveListener = OnRemoveListener
UIExplorerTreasureRewardView.OnBtnPanelClick = OnBtnPanelClick
UIExplorerTreasureRewardView.InitView = InitView
UIExplorerTreasureRewardView.OnBtnItemClick = OnBtnItemClick
UIExplorerTreasureRewardView.LoadScene = LoadScene
UIExplorerTreasureRewardView.ReleaseTexture = ReleaseTexture
UIExplorerTreasureRewardView.RandomSelectShuffle = RandomSelectShuffle
UIExplorerTreasureRewardView.PlayAnim = PlayAnim
UIExplorerTreasureRewardView.IsPlaying = IsPlaying
UIExplorerTreasureRewardView.DoAutoOpen = DoAutoOpen
UIExplorerTreasureRewardView.OnRewardGetPanelClose = OnRewardGetPanelClose
UIExplorerTreasureRewardView.PlayEffect = PlayEffect
UIExplorerTreasureRewardView.Update1000MS = Update1000MS
UIExplorerTreasureRewardView.ShowGuideToClick = ShowGuideToClick
return UIExplorerTreasureRewardView
