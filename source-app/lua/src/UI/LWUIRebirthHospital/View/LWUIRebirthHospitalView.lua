local LWUIRebirthHospitalView = BaseClass("LWUIRebirthHospitalView", UIBaseView)
local SoldierCell = require("UI/LWUIRebirthHospital/Component/LWUIRebirthHospitalSoldierCellComponent")
local UINeedResCell = require("UI.UIBuildUpgrade.Component.UINeedResCell")
local base = UIBaseView
local redImgPath = "Assets/Main/Sprites/UI/LWAllianceZone/Textures/zyf_chengchixinxi_hongse_jindutiao.png"
local greenImgPath = "Assets/Main/Sprites/UI/LWAllianceZone/Textures/lyp_tongmeng_jindutiao_2.png"
local goldIconPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_gold.png"
local timeIconPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/guaji_cfm_tubiao_2.png"
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization

function LWUIRebirthHospitalView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function LWUIRebirthHospitalView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWUIRebirthHospitalView:ComponentDefine()
  self.btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.textTitle = self:AddComponent(UIText, "UICommonPopUpTitle/Common_img_title/titleText")
  self.textTitle:SetLocalText("building_name_10231000")
  self.btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnPanel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.objContentRoot = self:AddComponent(UIBaseContainer, "Root")
  self.textEmpty = self:AddComponent(UIText, "Root/viewText")
  self.textEmpty:SetLocalText("emergency_center_desc_1002")
  self.textProgress = self:AddComponent(UIText, "Root/progressText")
  self.objCellRoot = self:AddComponent(UIBaseContainer, "Root/BG")
  self.sliderCell = self:AddComponent(UISlider, "Root/BG/Slider")
  self.imgSliderCell = self:AddComponent(UIImage, "Root/BG/Slider/FillArea/Fill")
  self.textCellCount = self:AddComponent(UIText, "Root/BG/count")
  self.textCellName = self:AddComponent(UIText, "Root/BG/countName")
  self.textCellName:SetLocalText("emergency_center_desc_1001")
  self.btnTips = self:AddComponent(UIButton, "Root/BG/InfoBtn")
  self.btnTips:SetOnClick(function()
    local param = {}
    param.activityRulesStr = Localization:GetString("emergency_center_desc_1013")
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetail, {anim = true}, param)
  end)
  self.objSoldierTemplate = self:AddComponent(UIBaseContainer, "Root/ScrollView/LWRebirthHospitalSoldierCell")
  self.objSoldierTemplate.gameObject:GameObjectCreatePool()
  self.objContentSoldier = self:AddComponent(UIBaseContainer, "Root/ScrollView/Viewport/Content")
  self.btnTime = self:AddComponent(UIButton, "UICommonPopUpTitle/btnLayout/timeBtn")
  self.btnTime:SetOnClick(function()
    self:OnTimeBtnClick(true)
  end)
  self.objBtnTimeDes = self:AddComponent(UIBaseContainer, "UICommonPopUpTitle/btnLayout/timeBtn/TimeIcon")
  self.textBtnTimeDes = self:AddComponent(UIText, "UICommonPopUpTitle/btnLayout/timeBtn/TimeIcon/timeText")
  self.textBtnTimeTitleCd = self:AddComponent(UIText, "UICommonPopUpTitle/btnLayout/timeBtn/btnCdText")
  self.textBtnTimeTitleNotCd = self:AddComponent(UIText, "UICommonPopUpTitle/btnLayout/timeBtn/btnNotCdText")
  self.btnClaim = self:AddComponent(UIButton, "UICommonPopUpTitle/btnLayout/ClaimBtn")
  self.btnClaim:SetOnClick(function()
    self:OnBtnClaimClick()
  end)
  self.textClaimBtn = self:AddComponent(UIText, "UICommonPopUpTitle/btnLayout/ClaimBtn/Btn/ClaimBtnText")
  self.textClaimBtn:SetText(Localization:GetString("activity_armament_desc5"))
  self.objCostItem = self:AddComponent(UIBaseContainer, "Root/ItemLayout")
  self.btnHistory = self:AddComponent(UIButton, "UICommonPopUpTitle/btnLayout/HistoryBtn")
  self.btnHistory:SetOnClick(function()
    self:OnBtnHistoryClick()
  end)
end

function LWUIRebirthHospitalView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ResourceUpdated, self.UpdateResourceCost)
  self:AddUIListener(EventId.RebirthHospitalUpdate, self.OnRebirthUpdate)
  self:AddUIListener(EventId.UnLockHospitalCureMsg, self.UnLockHospitalCureMsg)
end

function LWUIRebirthHospitalView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ResourceUpdated, self.UpdateResourceCost)
  self:RemoveUIListener(EventId.RebirthHospitalUpdate, self.OnRebirthUpdate)
  self:RemoveUIListener(EventId.UnLockHospitalCureMsg, self.UnLockHospitalCureMsg)
end

function LWUIRebirthHospitalView:Update1000MS()
  self:UpdateInRebirthProgress()
  self:UpdateRebirthBtn()
end

function LWUIRebirthHospitalView:ReInit()
  local uuId = self:GetUserData()
  if uuId then
    DataCenter.RebirthHospitalManager:SetCurRebirthHospitalBuildUuid(uuId)
  end
  self:UpdateAll()
end

function LWUIRebirthHospitalView:UpdateAll()
  self:UpdateTop()
  self:UpdateInRebirthProgress()
  self:UpdateSoldierScroll()
  self:UpdateResourceCost()
  self:UpdateRebirthBtn()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.objContentRoot.rectTransform)
end

function LWUIRebirthHospitalView:UpdateTop()
  local curCount = DataCenter.RebirthHospitalManager:GetSoldierCurCount()
  local maxCount = DataCenter.RebirthHospitalManager:GetSoldierMaxCount()
  local percent = 0
  if 0 < maxCount then
    percent = curCount / maxCount
  end
  if percent <= 0.5 then
    self.imgSliderCell:LoadSprite(greenImgPath)
  else
    self.imgSliderCell:LoadSprite(redImgPath)
  end
  self.sliderCell:SetValue(percent)
  self.textCellCount:SetText(curCount .. "/" .. maxCount)
end

function LWUIRebirthHospitalView:UpdateInRebirthProgress()
  local leftTime = DataCenter.RebirthHospitalManager:GetRebirthQueueLeftTime()
  local isInRebirth = 0 < leftTime
  self.textProgress:SetActive(isInRebirth)
  if isInRebirth then
    local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
    self.textProgress:SetText(Localization:GetString("emergency_center_desc_1003") .. " " .. timeStr)
  end
  if self.isInRebirth and not isInRebirth then
    self.ctrl:CloseSelf()
  end
  self.isInRebirth = isInRebirth
end

function LWUIRebirthHospitalView:UpdateSoldierScroll()
  self:ClearSoldierScroll()
  self.inRebirthSoldierList = DataCenter.RebirthHospitalManager:GetAllInRebirthSoldierList()
  local isInRebirth = #self.inRebirthSoldierList > 0
  local count = 0
  if isInRebirth then
    for i, v in pairs(self.inRebirthSoldierList) do
      v.index = i
      local item = self.objSoldierTemplate.gameObject:GameObjectSpawn(self.objContentSoldier.transform)
      item.name = "item" .. i
      local obj = self.objContentSoldier:AddComponent(SoldierCell, item.name)
      obj:SetActive(true)
      obj:ReInit(v)
    end
    count = #self.inRebirthSoldierList
  else
    self.deadSoldierList = DataCenter.RebirthHospitalManager:GetAllDeadSoldierList()
    count = #self.deadSoldierList
    if not self.hasSetDefaultCount then
      self.hasSetDefaultCount = true
      for _, v in pairs(self.deadSoldierList) do
        v.curCount = v:GetDeadCount()
      end
    end
    if 0 < count then
      for i, v in pairs(self.deadSoldierList) do
        v.index = i
        
        function v.callback(rebirthHospitalInfo, setCount)
          self:ChangeSoldierCurCount(rebirthHospitalInfo, setCount)
        end
        
        local item = self.objSoldierTemplate.gameObject:GameObjectSpawn(self.objContentSoldier.transform)
        item.name = "item" .. i
        local obj = self.objContentSoldier:AddComponent(SoldierCell, item.name)
        obj:SetActive(true)
        obj:ReInit(v)
      end
    end
  end
  self.textEmpty:SetActive(count == 0)
end

function LWUIRebirthHospitalView:ClearSoldierScroll()
  self.inRebirthSoldierList = nil
  self.deadSoldierList = nil
  self.objContentSoldier:RemoveComponents(SoldierCell)
  self.objSoldierTemplate.gameObject:GameObjectRecycleAll()
end

function LWUIRebirthHospitalView:UpdateResourceCost()
  local showResource = not table.IsNullOrEmpty(self.deadSoldierList)
  self.objCostItem:SetActive(showResource)
  if showResource then
    local resourceDic = self.ctrl:GetResourceCostDict(self.deadSoldierList)
    if self.needResourceCells == nil then
      self.needResourceCells = {}
    end
    local needRemoveType = {}
    for resType, resCell in pairs(self.needResourceCells) do
      if resourceDic[resType] == nil or resourceDic[resType] == 0 then
        table.insert(needRemoveType, resType)
      end
    end
    for _, resType in pairs(needRemoveType) do
      local resCell = self.needResourceCells[resType]
      if resCell ~= nil and resCell.inst ~= nil then
        self.objCostItem:RemoveComponent(resCell.objName, UINeedResCell)
        self:GameObjectDestroy(resCell.inst)
        self.needResourceCells[resType] = nil
      end
    end
    for resType, resCount in pairs(resourceDic) do
      local userCount = LuaEntry.Resource:GetCntByResType(resType)
      local param = {}
      param.resourceType = resType
      param.count = resCount
      param.isRed = resCount > userCount
      param.goName = param.resourceType
      if self.needResourceCells[resType] == nil then
        local cell = {}
        cell.param = param
        cell.inst = self:GameObjectInstantiateAsync(UIAssets.NeedResourceCell, function(request)
          if request.isError then
            return
          end
          if self.objCostItem == nil then
            return
          end
          local go = request.gameObject
          go:SetActive(true)
          go.transform:SetParent(self.objCostItem.transform)
          go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          go.transform:SetAsLastSibling()
          local nameStr = tostring(resType)
          go.name = nameStr
          self.needResourceCells[resType].objName = nameStr
          local effect = self.objCostItem:AddComponent(UINeedResCell, nameStr)
          if effect ~= nil and self.needResourceCells[resType] ~= nil then
            effect:ReInit(self.needResourceCells[resType].param)
          end
          self.needResourceCells[resType].comp = effect
        end)
        self.needResourceCells[resType] = cell
      else
        self.needResourceCells[resType].param = param
        if self.needResourceCells[resType].comp ~= nil then
          self.needResourceCells[resType].comp:ReInit(param)
        end
      end
    end
  end
end

function LWUIRebirthHospitalView:UpdateRebirthBtn()
  local isCanClaim = false
  local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.RebirthHospital)
  if queue ~= nil and queue:GetQueueState() == NewQueueState.Finish then
    isCanClaim = true
  end
  self.btnTime:SetActive(not isCanClaim)
  self.btnClaim:SetActive(isCanClaim)
  if not isCanClaim then
    local isInCooldown = DataCenter.RebirthHospitalManager:IsRebirthInCooldown()
    local showBtn = table.IsNullOrEmpty(self.inRebirthSoldierList) and (not table.IsNullOrEmpty(self.deadSoldierList) or not not isInCooldown)
    self.btnTime:SetActive(showBtn)
    if showBtn then
      CS.UIGray.SetGray(self.btnTime.transform, isInCooldown, true)
      self.textBtnTimeTitleCd:SetActive(isInCooldown)
      self.textBtnTimeTitleNotCd:SetActive(not isInCooldown)
      self.objBtnTimeDes:SetActive(isInCooldown)
      if not isInCooldown then
        self.textBtnTimeTitleNotCd:SetLocalText("emergency_center_button_1101")
      else
        self.textBtnTimeTitleCd:SetLocalText("emergency_center_button_1102")
        local leftTime = DataCenter.RebirthHospitalManager:GetRebirthCooldownLeftTime()
        self.textBtnTimeDes:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
      end
    end
  end
end

function LWUIRebirthHospitalView:OnBtnClaimClick()
  local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.RebirthHospital)
  if queue ~= nil and queue:GetQueueState() == NewQueueState.Finish then
    local uuId = self:GetUserData()
    if uuId then
      DataCenter.RebirthHospitalManager:CheckRebirthQueueFinish(uuId)
      self.ctrl:CloseSelf()
    end
  end
end

function LWUIRebirthHospitalView:OnTimeBtnClick(showSecondConfirm)
  if self.deadSoldierList == nil then
    return
  end
  if DataCenter.RebirthHospitalManager:IsRebirthInCooldown() then
    return
  end
  if DataCenter.RebirthHospitalManager:IsInRebirth() then
    return
  end
  local resourceCost = self.ctrl:GetResourceCostDict(self.deadSoldierList)
  local resourceLack = {}
  for resType, resCount in pairs(resourceCost) do
    local userCount = LuaEntry.Resource:GetCntByResType(resType)
    if resCount > userCount then
      local lack = {
        resType = resType,
        need = resCount,
        count = resCount - userCount
      }
      table.insert(resourceLack, lack)
    end
  end
  if not table.IsNullOrEmpty(resourceLack) then
    LWResourceLackUtil:GotoResLack(resourceLack)
    return
  end
  if showSecondConfirm then
    local cooldown = DataCenter.RebirthHospitalManager:GetRebirthCooldownDuration()
    local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(cooldown * 1000)
    local timeDesc = Localization:GetString("emergency_center_desc_1005", timeStr)
    local desc = Localization:GetString("emergency_center_desc_1004") .. "\n" .. timeDesc
    UIUtil.ShowMessage(desc, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      self:OnTimeBtnClick(false)
    end, nil, nil)
  else
    local param = self.ctrl:GetRebirthMessageParam(self.deadSoldierList)
    if not table.IsNullOrEmpty(param) then
      DataCenter.RebirthHospitalManager:SendRebirthMessage(param)
      self.ctrl:CloseSelf()
    end
  end
end

function LWUIRebirthHospitalView:ChangeSoldierCurCount(info, count)
  if info == nil then
    return
  end
  local armyId = info.armyId
  local hasChanged = false
  if self.deadSoldierList ~= nil then
    for i, v in pairs(self.deadSoldierList) do
      if v.armyId == armyId and (v.curCount == nil or v.curCount ~= count) then
        v.curCount = count
        hasChanged = true
      end
    end
  end
  if hasChanged then
    self:UpdateResourceCost()
    self:UpdateRebirthBtn()
  end
end

function LWUIRebirthHospitalView:OnRebirthUpdate()
  self:UpdateAll()
end

function LWUIRebirthHospitalView:DataDefine()
  self.deadSoldierList = {}
  self.inRebirthSoldierList = {}
  self.hasSetDefaultCount = false
  self.isInRebirth = false
end

function LWUIRebirthHospitalView:ComponentDestroy()
  self.btnClose = nil
  self.textTitle = nil
  self.btnPanel = nil
  self.objContentRoot = nil
  self.textEmpty = nil
  self.objCellRoot = nil
  self.sliderCell = nil
  self.imgSliderCell = nil
  self.textCellCount = nil
  self.textCellName = nil
  self.btnTips = nil
  self:ClearSoldierScroll()
  self.objContentSoldier = nil
  self.objSoldierTemplate = nil
  self.btnTime = nil
  self.textBtnTimeDes = nil
  self.textBtnTimeTitleCd = nil
  self.textBtnTimeTitleNotCd = nil
  self.objBtnTimeDes = nil
  self.objCostItem:RemoveComponents(UINeedResCell)
  if self.needResourceCells ~= nil then
    for k, v in pairs(self.needResourceCells) do
      if v.inst ~= nil then
        self:GameObjectDestroy(v.inst)
      end
    end
    self.needResourceCells = nil
  end
  self.objCostItem = nil
  self.btnHistory = nil
  self.textHistoryBtn = nil
end

function LWUIRebirthHospitalView:DataDestroy()
  self.deadSoldierList = nil
  self.inRebirthSoldierList = nil
  self.hasSetDefaultCount = nil
end

function LWUIRebirthHospitalView:OnBtnHistoryClick()
  self.ctrl:OpenHistory()
end

return LWUIRebirthHospitalView
