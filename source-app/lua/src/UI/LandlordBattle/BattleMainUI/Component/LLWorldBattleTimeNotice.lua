local base = UIAsyncContainer
local LLWorldBattleTimeNotice = BaseClass("LLWorldBattleTimeNotice", UIAsyncContainer)
local Localization = CS.GameEntry.Localization

function LLWorldBattleTimeNotice:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLWorldBattleTimeNotice:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLWorldBattleTimeNotice:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.bg = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.left_tip = self.viewSkin:AddComponent(self, UIImage, 2)
  self.text_tip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.text_end = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.bg2 = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.right = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.right_tip = self.viewSkin:AddComponent(self, UIImage, 7)
  self.text_time = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
end

function LLWorldBattleTimeNotice:ComponentDestroy()
  self.viewSkin = nil
  self.bg = nil
  self.left_tip = nil
  self.text_tip = nil
  self.text_end = nil
  self.bg2 = nil
  self.right = nil
  self.right_tip = nil
  self.text_time = nil
end

function LLWorldBattleTimeNotice:DataDefine()
  self.lodCache = -1
  self.bg:SetActive(false)
  self.bg2:SetActive(false)
  self.right:SetActive(false)
end

function LLWorldBattleTimeNotice:DataDestroy()
end

function LLWorldBattleTimeNotice:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChangeCameraLod, self.OnLodChange)
  self:AddUIListener(EventId.LandlordBattleTimeCtrlNotice, self.SetShow)
end

function LLWorldBattleTimeNotice:OnRemoveListener()
  self:RemoveUIListener(EventId.ChangeCameraLod, self.OnLodChange)
  self:RemoveUIListener(EventId.LandlordBattleTimeCtrlNotice, self.SetShow)
  base.OnRemoveListener(self)
end

function LLWorldBattleTimeNotice:OnEnable()
  base.OnEnable(self)
  self:OnLodChange(CS.SceneManager.World:GetLodLevel())
end

function LLWorldBattleTimeNotice:OnLodChange(lod)
  if self.lodCache == lod then
    return
  end
  self.lodCache = lod
  local y = lod < 3 and -350 or -450
  local x = self.right:GetAnchoredPositionX()
  self.right:SetAnchoredPositionXY(x, y)
end

function LLWorldBattleTimeNotice:CleanSeq()
  self:CleanSeqOpen()
  self:CleanSeqEnd()
end

function LLWorldBattleTimeNotice:CleanSeqEnd()
  if self.seqEnd ~= nil then
    self.seqEnd:Pause()
    self.seqEnd:Kill()
    self.seqEnd = nil
  end
  if self.bg2 ~= nil then
    self.bg2:SetActive(false)
  end
end

function LLWorldBattleTimeNotice:CleanSeqOpen()
  if self.seqOpen ~= nil then
    self.seqOpen:Pause()
    self.seqOpen:Kill()
    self.seqOpen = nil
  end
  if self.bg ~= nil then
    self.bg:SetActive(false)
  end
end

function LLWorldBattleTimeNotice:SetShow(data)
  local config = data ~= nil and data.config or nil
  if config == nil or self.right == nil or not SceneUtils.GetIsInWorld() then
    self:CleanSeq()
    if self.right ~= nil then
      self.right:SetActive(false)
    end
    return
  end
  local isFly = data.isFly
  if isFly then
    if config.type == 5 then
      self:ShowEnd(config, 2, 0)
    else
      self:ShowOpen(config, 2)
    end
  else
    self.right:SetActive(true)
    local curSec = UITimeManager:GetInstance():GetServerSeconds()
    local curWeek = DataCenter.LandlordMgr:GetCurWeek()
    local sTime = DataCenter.LandlordMgr:GetWeekBattleStartTime(curWeek)
    curWeek = tostring(curWeek)
    local rTime = sTime + config.trigger_time
    local remainTime = rTime - curSec
    self.text_time:SetText(remainTime)
    if self.curId ~= config.id then
      self.curId = config.id
      if string.IsNullOrEmpty(config.icon) then
        self.right_tip:SetActive(false)
      else
        self.right_tip:SetActive(true)
        self.right_tip:LoadSpriteAuto(config.icon)
        self.right_tip:SetAspectSize(120)
      end
    end
  end
end

function LLWorldBattleTimeNotice:ShowOpen(config, actTime)
  if self.bg == nil or config == nil or self.curIdx == config.id then
    return
  end
  self.curIdx = config.id
  self:CleanSeqOpen()
  self.bg:SetActive(true)
  self.bg:SetAnchoredPositionXY(-Screen.width, 0)
  if string.IsNullOrEmpty(config.icon) then
    self.left_tip:SetActive(false)
  else
    self.left_tip:SetActive(true)
    self.left_tip:LoadSpriteAuto(config.icon)
    self.left_tip:SetAspectSize(200)
  end
  self.text_tip:SetLocalText(config.alert_tips)
  
  local function cb()
    self.seqOpen = nil
    self.bg:SetActive(false)
    self.curIdx = nil
  end
  
  self.seqOpen = self:DoAction(self.bg.transform, actTime, cb)
end

function LLWorldBattleTimeNotice:ShowEnd(config, actTime, time)
  if self.bg2 == nil or config == nil or self.curIdx2 == config.id or time <= 0 then
    return
  end
  self.curIdx2 = config.id
  self:CleanSeqEnd()
  self.bg2:SetActive(true)
  self.bg2:SetAnchoredPositionXY(-Screen.width, 0)
  self.text_end:SetLocalText(config.alert_tips, time)
  
  local function cb()
    self.seqEnd = nil
    self.bg2:SetActive(false)
    self.curIdx2 = nil
  end
  
  self.seqEnd = self:DoAction(self.bg2.transform, actTime, cb)
end

function LLWorldBattleTimeNotice:DoAction(transform, actTime, cb)
  local fly_time = 0.5
  local delayTime = actTime - fly_time
  local seq = DOTween.Sequence()
  seq:Append(transform:DOLocalMoveX(0, fly_time))
  seq:AppendInterval(delayTime)
  seq.onComplete = cb
  return seq
end

return LLWorldBattleTimeNotice
