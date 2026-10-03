local base = UIBaseContainer
local UIMainCureBtnItem = BaseClass("UIMainCureBtnItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local LWMainCureBtnText_Path = "Assets/Main/Prefabs/UI/LWMainUI/LWMainCureBtnText.prefab"

function UIMainCureBtnItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMainCureBtnItem:OnDestroy()
  self:ClearCureBtnTextTween()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMainCureBtnItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnCure = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnCure:SetOnClick(function()
    self:OnBtnCureClick()
  end)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 2)
end

function UIMainCureBtnItem:ComponentDestroy()
  self.viewSkin = nil
  self.btnCure = nil
  self.imgIcon = nil
end

function UIMainCureBtnItem:DataDefine()
end

function UIMainCureBtnItem:DataDestroy()
  self.cureBtnTextReq = nil
  self.cureBtnText = nil
end

function UIMainCureBtnItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.HospitalUpdate, self.RefreshCure)
  self:AddUIListener(EventId.HospitaiStart, self.RefreshCure)
  self:AddUIListener(EventId.HospitalFinish, self.RefreshCure)
  self:AddUIListener(EventId.RefreshHospitalMaxEffect, self.RefreshCure)
  self:AddUIListener(EventId.AllianceQueueHelpNew, self.OnQueueTimeEnd)
  self:AddUIListener(EventId.QUEUE_TIME_END, self.OnQueueTimeEnd)
end

function UIMainCureBtnItem:OnRemoveListener()
  self:RemoveUIListener(EventId.HospitalUpdate, self.RefreshCure)
  self:RemoveUIListener(EventId.HospitaiStart, self.RefreshCure)
  self:RemoveUIListener(EventId.HospitalFinish, self.RefreshCure)
  self:RemoveUIListener(EventId.RefreshHospitalMaxEffect, self.RefreshCure)
  self:RemoveUIListener(EventId.AllianceQueueHelpNew, self.OnQueueTimeEnd)
  self:RemoveUIListener(EventId.QUEUE_TIME_END, self.OnQueueTimeEnd)
  base.OnRemoveListener(self)
end

function UIMainCureBtnItem:OnBtnCureClick()
  if self.cureCallBack then
    self.cureCallBack()
  end
end

function UIMainCureBtnItem:ReInit()
  self:RefreshCure()
end

function UIMainCureBtnItem:RefreshCure()
  self.btnCure:SetActive(false)
  if self.cureBtnText then
    self.cureBtnText:SetActive(false)
  end
  if SceneUtils.GetIsInWorld() then
    local data = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(BuildingTypes.LW_BUILD_HOSPITL)
    local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Hospital)
    self.cureCallBack = nil
    if data and queue then
      local state = queue:GetQueueState()
      if data.level > 0 and queue ~= nil and state then
        local info = self:GetCureBtnInfo(data, state, queue)
        if info.iconPatch then
          self.imgIcon:SetActive(true)
          self.imgIcon:LoadSprite(info.iconPatch)
          self.imgIcon:SetSizeDelta(info.iconSize)
        else
          self.imgIcon:SetActive(false)
        end
        if info.bgPatch then
          self.btnCure:LoadSprite(info.bgPatch)
          self.btnCure:SetActive(true)
        else
          self.btnCure:SetActive(false)
        end
        self:RefreshCureBtnText(state)
        if info.callBack then
          self.cureCallBack = info.callBack
        end
      end
    end
  end
end

function UIMainCureBtnItem:RefreshCureBtnText(state)
  if DataCenter.HospitalManager:IsHaveInjuredSolider() and state == NewQueueState.Free and DataCenter.HospitalManager:GetHospitalMaxVolume() > 0 then
    local progress = DataCenter.HospitalManager:GetMaxDeadSoldier() / DataCenter.HospitalManager:GetHospitalMaxVolume()
    progress = math.floor(math.min(progress, 1) * 100)
    local setting = self.view.ctrl:GetCureBtnTextSetting(progress)
    if setting then
      if self.cureBtnTextReq == nil then
        self.cureBtnTextReq = self:GameObjectInstantiateAsync(LWMainCureBtnText_Path, function(request)
          if request.isError then
            self:GameObjectDestroy(self.cureBtnTextReq)
            self.cureBtnTextReq = nil
            return
          end
          local go = request.gameObject
          go:SetActive(true)
          go.transform:SetParent(self.btnCure.transform)
          go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          self.cureBtnText = self.btnCure:AddComponent(UIText, go)
          self.cureBtnText:SetAnchoredPositionXY(0, 39)
          self:RefreshCureBtnTextByProgress(progress, setting)
        end)
      elseif self.cureBtnText then
        self:RefreshCureBtnTextByProgress(progress, setting)
      end
    elseif self.cureBtnText then
      self.cureBtnText:SetActive(false)
    end
  elseif self.cureBtnText then
    self.cureBtnText:SetActive(false)
  end
end

function UIMainCureBtnItem:RefreshCureBtnTextByProgress(progress, setting)
  self.cureBtnText:SetActive(true)
  self.cureBtnText:SetText(progress .. "%")
  self.cureBtnText:SetColorHex(setting.color)
  if setting.showAnim then
    if self.cureBtnTextTween == nil then
      self.cureBtnText:SetLocalScaleXYZ(0.8, 0.8, 0.8)
      self.cureBtnTextTween = self.cureBtnText.transform:DOScale(Vector3.New(1.2, 1.2, 1.2), 1):SetLoops(-1, CS.DG.Tweening.LoopType.Yoyo):SetEase(CS.DG.Tweening.Ease.OutQuad)
    end
  else
    self:ClearCureBtnTextTween()
  end
end

function UIMainCureBtnItem:ClearCureBtnTextTween()
  if self.cureBtnTextTween then
    self.cureBtnTextTween:Kill()
    self.cureBtnTextTween = nil
    self.cureBtnText:SetLocalScaleXYZ(1, 1, 1)
  end
end

function UIMainCureBtnItem:OnQueueTimeEnd(state)
  if state == NewQueueType.Hospital then
    self:RefreshCure()
  end
end

function UIMainCureBtnItem:GetCureBtnInfo(data, state, queue)
  local info = {}
  local sameDay = false
  if queue.lastHelpTime > 0 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    sameDay = UITimeManager:GetInstance():IsSameDayForServer(queue.lastHelpTime // 1000, curTime // 1000)
  end
  local maxCount = LuaEntry.DataConfig:TryGetNum("medical_assist_daily_limit", "k1")
  if DataCenter.HospitalManager:IsHaveInjuredSolider() and state == NewQueueState.Free then
    info.iconPatch = "Assets/Main/Sprites/UI/UIBuildBubble/zyf_zhuchengyiyuan_zhuyeqipao.png"
    info.bgPatch = "Assets/Main/Sprites/UI/UIMain/UIMainBubble/cfm_zhujiemian_diquan.png"
    info.iconSize = Vector2.New(55, 55)
    
    function info.callBack()
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIHospital)
    end
  elseif 0 < data.level and LuaEntry.Player:IsInAlliance() and state == NewQueueState.Work and queue.isHelped == 0 and (maxCount > queue.helpNum or not sameDay) then
    info.iconPatch = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.HospitalAllianceHelp)
    info.bgPatch = "Assets/Main/Sprites/UI/UIMain/UIMainBubble/cfm_zhujiemian_diquan.png"
    info.iconSize = Vector2.New(55, 55)
    
    function info.callBack()
      local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Hospital)
      local sameDay = false
      local maxCount = LuaEntry.DataConfig:TryGetNum("medical_assist_daily_limit", "k1")
      if queue.lastHelpTime > 0 then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        sameDay = UITimeManager:GetInstance():IsSameDayForServer(queue.lastHelpTime // 1000, curTime // 1000)
      end
      if maxCount > queue.helpNum or not sameDay then
        SFSNetwork.SendMessage(MsgDefines.AllianceCallHelp, queue.uuid, AllianceHelpType.Queue, NewQueueType.Hospital, queue.itemId)
      end
      self:RefreshCure()
    end
  elseif state == NewQueueState.Work then
    info.iconPatch = "Assets/Main/Sprites/UI/UIMain/UIMainBubble/cfm_zhujiemian_diquan_1.png"
    info.bgPatch = "Assets/Main/Sprites/UI/UIMain/UIMainBubble/cfm_zhujiemian_diquan.png"
    info.iconSize = Vector2.New(82, 82)
    
    function info.callBack()
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIHospital)
    end
  elseif state == NewQueueState.Finish then
    local template = DataCenter.HospitalManager:GetMaxSoldierInTreating()
    if template ~= nil then
      if T11Util.IsSuperSoldier(template.lv, template.type) then
        info.iconPatch = T11Util.GetSoldierBubblePath()
      else
        info.iconPatch = string.format(LoadPath.UIMainBubble, template.bubble_icon)
      end
      info.bgPatch = "Assets/Main/Sprites/UI/UIMain/UIMainBubble/cfm_zhujiemian_diquan_huang.png"
      info.iconSize = Vector2.New(75, 75)
    end
    
    function info.callBack()
      DataCenter.HospitalManager:CheckSendFinish(data.itemId)
    end
  end
  return info
end

function UIMainCureBtnItem:SetActiveEx(value)
  self:SetActive(value)
  if self.btnCure then
    self.btnCure:SetActive(value)
  end
end

return UIMainCureBtnItem
