local DigTreasureBlockInfo = BaseClass("DigTreasureBlockInfo", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local testPos = {
  [1] = {x = 0, y = 100},
  [2] = {x = 0, y = -100},
  [3] = {x = 100, y = 0},
  [4] = {x = -100, y = 0},
  [5] = {x = 0, y = 0}
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
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
  self.imgBg = self:AddComponent(UIImage, "imgBg")
  self.imgIcon = self:AddComponent(UIImage, "imgIcon")
  self.trans = self:AddComponent(UIBaseContainer, "")
  self.FinishedEffect = self:AddComponent(UIVfx, "FinishedEffect", VfxAssets.DigTreasureBlockFinished)
end

local function ComponentDestroy(self)
  self.imgBg = nil
  self.imgIcon = nil
  self.trans = nil
  self.FinishedEffect = nil
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.DiggingGetBlockAnim, self.OnGetBlockAnim)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.DiggingGetBlockAnim, self.OnGetBlockAnim)
  base.OnRemoveListener(self)
end

local function ReInit(self, nIndex, nBlockId, tblockInfo, tBlockPosInfo)
  self.nIndex = nIndex
  self.nBlockId = nBlockId
  self.tblockInfo = tblockInfo
  self.tBlockPosInfo = tBlockPosInfo
  local bHasGet = tblockInfo and tblockInfo.get
  local blockConfig = DataCenter.DiggingDataTemplateManager:GetConfigDataBlock(nBlockId)
  if not blockConfig then
    return
  end
  self.imgBg:LoadSprite(blockConfig.appearance_shadow)
  self.imgBg:SetNativeSize()
  local nBgScale = tBlockPosInfo.scaleBg or 1
  self.imgBg:SetLocalScaleXYZ(nBgScale, nBgScale, nBgScale)
  if bHasGet then
    self.imgIcon:LoadSprite(blockConfig.appearance)
    self.imgIcon:SetNativeSize()
    local nBlockScale = tBlockPosInfo.scaleBlock or 1
    self.imgIcon:SetLocalScaleXYZ(nBlockScale, nBlockScale, nBlockScale)
    self.imgIcon:SetActive(true)
  else
    self.imgIcon:SetActive(false)
  end
end

local function OnGetBlockAnim(self, param)
  if not (param and param.blockInfo and param.blockInfo.get) or self.nBlockId ~= param.blockInfo.bid then
    return
  end
  local blockConfig = DataCenter.DiggingDataTemplateManager:GetConfigDataBlock(self.nBlockId)
  if not blockConfig then
    return
  end
  local nBlockScale = self.tBlockPosInfo.scaleBlock or 1
  self.tweenSeq = DOTween.Sequence()
  self.tweenSeq:AppendInterval(0.5)
  if param.fly and param.fly.transform then
    self.tweenSeq:AppendCallback(function()
      param.fly:SetActive(true)
    end)
    self.tweenSeq:Append(param.fly.transform:DOMove(self.imgIcon.transform.position, 0.6)):SetEase(CS.DG.Tweening.Ease.OutCubic)
    self.tweenSeq:Join(param.fly.transform:DOScale(Vector3.New(nBlockScale, nBlockScale, nBlockScale), 0.6))
  end
  TimerManager:GetInstance():DelayInvoke(function()
    if self.FinishedEffect then
      self.FinishedEffect:Replay()
    end
  end, 0.55)
  self.tweenSeq:AppendCallback(function()
    if not self.imgIcon then
      return
    end
    self.imgIcon:LoadSprite(blockConfig.appearance)
    self.imgIcon:SetNativeSize()
    self.imgIcon:SetLocalScaleXYZ(nBlockScale, nBlockScale, nBlockScale)
    self.imgIcon:SetActive(true)
    if param.fly then
      param.fly:SetActive(false)
    end
  end)
end

DigTreasureBlockInfo.OnCreate = OnCreate
DigTreasureBlockInfo.OnDestroy = OnDestroy
DigTreasureBlockInfo.OnEnable = OnEnable
DigTreasureBlockInfo.OnDisable = OnDisable
DigTreasureBlockInfo.ComponentDefine = ComponentDefine
DigTreasureBlockInfo.ComponentDestroy = ComponentDestroy
DigTreasureBlockInfo.DataDefine = DataDefine
DigTreasureBlockInfo.DataDestroy = DataDestroy
DigTreasureBlockInfo.OnAddListener = OnAddListener
DigTreasureBlockInfo.OnRemoveListener = OnRemoveListener
DigTreasureBlockInfo.ReInit = ReInit
DigTreasureBlockInfo.OnGetBlockAnim = OnGetBlockAnim
return DigTreasureBlockInfo
