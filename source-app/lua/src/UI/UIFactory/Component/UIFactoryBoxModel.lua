local UIFactoryBoxModel = BaseClass("UIFactoryBoxModel")
local Localization = CS.GameEntry.Localization
local box_anim_path = "JGC@Box_Skin"
local box_icon_path = "JGC@Box_Skin/JGC_To_unity/Root01/Root_base/icon"
local trigger_path = "Trigger"
local trigger_icon_path = "TriggerIcon"
local BoxState = {
  None,
  Open,
  Close,
  Work
}

local function OnCreate(self, go, data)
  self.request = go
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self.data = data
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
end

local function ComponentDefine(self)
  self.box_anim = self.transform:Find(box_anim_path):GetComponent(typeof(CS.UnityEngine.Animator))
  self.box_icon = self.transform:Find(box_icon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.box_icon_animator = self.transform:Find(box_icon_path):GetComponent(typeof(CS.UnityEngine.Animator))
  Logger.Log("componeDefine")
  self.curState = BoxState.None
  local clips = self.box_anim.runtimeAnimatorController.animationClips
  for i = 0, clips.Length - 1 do
    if clips[i].name == "Box_End" then
      self.endAnimTime = clips[i].length
    elseif clips[i].name == "Box_Start" then
      self.enterAnimTime = clips[i].length
    elseif clips[i].name == "Box_Close" then
      self.closeAnimTime = clips[i].length
    end
  end
  self.trigger = self.transform:Find(trigger_path):GetComponent(typeof(CS.TouchObjectEventTrigger))
  
  function self.trigger.onPointerClick()
    self:OnCancelClick()
  end
  
  self.cancel_icon = self.transform:Find(trigger_icon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self:SetCancelIconActive()
end

local function OnCancelClick(self)
  if self.data and self.data.cancelIndex ~= nil and self.data.cancelIndex > 0 then
    if DataCenter.ResourceItemDataManager:CheckIsStorageFull(0) then
      UIUtil.ShowTipsId(131012)
      return
    end
    if 0 >= self.data.index then
      return
    end
    UIUtil.ShowMessage(Localization:GetString("131011"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      DataCenter.FactoryDataManager:SendCancelFactoryPanel(self.data.factoryUid, self.data.cancelIndex)
    end, function()
    end)
  end
end

local function ComponentDestroy(self)
  self.endAnimTime = nil
  self.enterAnimTime = nil
  self.curState = nil
  self.box_anim = nil
  self.box_icon = nil
  self.gameObject = nil
  self.transform = nil
end

local function InitAdd(self)
  self.box_anim:Play("Box_Start", 0, 0)
  self.box_icon.gameObject:SetActive(false)
  self.cancel_icon.gameObject:SetActive(false)
  self.curState = BoxState.Open
  self:SetCancelIconActive()
end

local function SetCancelIconActive(self)
  if self.data ~= nil and self.data.index ~= nil then
    self.cancel_icon.gameObject:SetActive(self.data.showCancel)
  else
    self.cancel_icon.gameObject:SetActive(false)
  end
end

local function InitClose(self)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Produce_Box, false)
  if self.data.itemId ~= nil and self.data.itemPic ~= nil then
    self.box_icon.gameObject:SetActive(true)
    self.box_icon:LoadSprite(self.data.itemPic)
  end
  self.box_anim:Play("Box_IdleClose", 0, 0)
  self.curState = BoxState.Close
  self:SetCancelIconActive()
end

local function InitOpen(self)
  self.box_icon.gameObject:SetActive(false)
  self.cancel_icon.gameObject:SetActive(false)
  self.box_anim:Play("Box_IdleOpen", 0, 0)
  self.curState = BoxState.Open
  self:SetCancelIconActive()
end

local function ChangeToOpen(self)
  self.data = {}
  self.box_icon.gameObject:SetActive(false)
  self.cancel_icon.gameObject:SetActive(false)
  self.box_anim:Play("Box_IdleOpen", 0, 0)
  self.curState = BoxState.Open
  self:SetCancelIconActive()
end

local function InitWork(self, isRandomFirst)
  if self.data.itemId ~= nil and self.data.itemPic ~= nil then
    self.box_icon.gameObject:SetActive(true)
    self.box_icon:LoadSprite(self.data.itemPic)
  end
  if isRandomFirst then
    self.box_anim:Play("Box_work_A", 0, 0)
  else
    self.box_anim:Play("Box_work_B", 0, 0)
  end
  self.curState = BoxState.Work
  self:SetCancelIconActive()
end

local function ChangeToClose(self, data)
  self.data = data
  if self.data.itemId ~= nil and self.data.itemPic ~= nil then
    self.box_icon.gameObject:SetActive(true)
    self.box_icon:LoadSprite(self.data.itemPic)
  end
  if self.curState == BoxState.Open then
    self.box_anim:SetTrigger("close")
    self.curState = BoxState.Close
  end
  self:SetCancelIconActive()
end

local function showIcon(self, itemData)
  self.box_icon.gameObject:SetActive(true)
  self:SetCancelIconActive()
  self.box_icon:LoadSprite(itemData.icon)
  self.box_icon_animator.enabled = true
end

local function hideIcon(self, itemData)
  self.box_icon.gameObject:SetActive(false)
  self.cancel_icon.gameObject:SetActive(false)
  self.box_icon:LoadSprite(itemData.icon)
  self.box_icon_animator.enabled = false
  self.box_icon.color = Color.New(1, 1, 1, 1)
end

local function ChangeToWork(self, isRandomFirst, data)
  if data ~= nil then
    self.data = data
  end
  if self.curState == BoxState.Close then
    if self.data.itemId ~= nil and self.data.itemPic ~= nil then
      self.box_icon.gameObject:SetActive(true)
      self.box_icon:LoadSprite(self.data.itemPic)
    end
    self.box_anim:Play("Box_StartOpen", 0, 0)
    if isRandomFirst then
      self.box_anim:SetTrigger("work1")
    else
      self.box_anim:SetTrigger("work2")
    end
    self.curState = BoxState.Work
    self:SetCancelIconActive()
  end
end

local function ChangeToQuit(self)
  self.box_anim:Play("Box_End", 0, 0)
end

local function DestroySelf(self)
  self.request:Destroy()
end

local function UpdatePos(self, pos)
  self.transform.localPosition = pos
end

local function GetEndAnimTime(self)
  return self.endAnimTime
end

local function GetEnterAnimTime(self)
  return self.enterAnimTime
end

local function GetCloseAnimTime(self)
  return self.closeAnimTime
end

local function GetSelfData(self)
  return self.data
end

local function GetCurPos(self)
  return self.transform.localPosition
end

UIFactoryBoxModel.OnCreate = OnCreate
UIFactoryBoxModel.OnDestroy = OnDestroy
UIFactoryBoxModel.ComponentDefine = ComponentDefine
UIFactoryBoxModel.ComponentDestroy = ComponentDestroy
UIFactoryBoxModel.InitAdd = InitAdd
UIFactoryBoxModel.InitClose = InitClose
UIFactoryBoxModel.InitOpen = InitOpen
UIFactoryBoxModel.InitWork = InitWork
UIFactoryBoxModel.ChangeToClose = ChangeToClose
UIFactoryBoxModel.ChangeToWork = ChangeToWork
UIFactoryBoxModel.ChangeToQuit = ChangeToQuit
UIFactoryBoxModel.DestroySelf = DestroySelf
UIFactoryBoxModel.UpdatePos = UpdatePos
UIFactoryBoxModel.GetEndAnimTime = GetEndAnimTime
UIFactoryBoxModel.GetSelfData = GetSelfData
UIFactoryBoxModel.GetCurPos = GetCurPos
UIFactoryBoxModel.GetEnterAnimTime = GetEnterAnimTime
UIFactoryBoxModel.GetCloseAnimTime = GetCloseAnimTime
UIFactoryBoxModel.showIcon = showIcon
UIFactoryBoxModel.hideIcon = hideIcon
UIFactoryBoxModel.ChangeToOpen = ChangeToOpen
UIFactoryBoxModel.OnCancelClick = OnCancelClick
UIFactoryBoxModel.SetCancelIconActive = SetCancelIconActive
return UIFactoryBoxModel
