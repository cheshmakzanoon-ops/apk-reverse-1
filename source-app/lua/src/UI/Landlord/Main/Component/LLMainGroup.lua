local base = UIAsyncContainer
local LLMainGroup = BaseClass("LLMainGroup", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local LLServerItem = require("UI.Landlord.Main.Component.LLServerItem")
local ActMgr = DataCenter.LandlordMgr
local EffBasePath = "Assets/Main/Prefabs/Effect/Landlord/Eff_ui_LLBattle_arrow_%s_%s.prefab"

function LLMainGroup:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLMainGroup:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLMainGroup:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compL1 = self.viewSkin:AddComponent(self, LLServerItem, 1)
  self.compL2 = self.viewSkin:AddComponent(self, LLServerItem, 2)
  self.compL3 = self.viewSkin:AddComponent(self, LLServerItem, 3)
  self.compF1 = self.viewSkin:AddComponent(self, LLServerItem, 4)
  self.compF2 = self.viewSkin:AddComponent(self, LLServerItem, 5)
  self.compF3 = self.viewSkin:AddComponent(self, LLServerItem, 6)
  self.compF4 = self.viewSkin:AddComponent(self, LLServerItem, 7)
  self.compF5 = self.viewSkin:AddComponent(self, LLServerItem, 8)
  self.compDef = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.compAtk = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.compBuffIcon = self.viewSkin:AddComponent(self, UIBaseComponent, 11)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.btnGo = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnGo:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.btnDef = self.viewSkin:AddComponent(self, UIButton, 15)
  self.btnDef:SetOnClick(function()
    self:OnBtnDefClick()
  end)
  self.btnAtk = self.viewSkin:AddComponent(self, UIButton, 16)
  self.btnAtk:SetOnClick(function()
    self:OnBtnAtkClick()
  end)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 17)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.textTipGroup = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.compRed = self.viewSkin:AddComponent(self, UIBaseComponent, 19)
  self.compCenter = self.viewSkin:AddComponent(self, UIBaseContainer, 20)
  self.textTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 21)
  self.compTipGoUp = self.viewSkin:AddComponent(self, UIBaseComponent, 22)
  self.textTipGoUp = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 23)
  self.compTipGoDown = self.viewSkin:AddComponent(self, UIBaseComponent, 24)
  self.textTipGoDown = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 25)
  self.compVU = self.viewSkin:AddComponent(self, UIBaseComponent, 26)
  self.compVD = self.viewSkin:AddComponent(self, UIBaseComponent, 27)
  self.textTimeGoUp = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 28)
  self.textTimeGoDown = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 29)
  self.btnDefIcon = self.viewSkin:AddComponent(self, UIButton, 30)
  self.btnDefIcon:SetOnClick(function()
    self:OnBtnDefIconClick()
  end)
  self.btnAtkIcon = self.viewSkin:AddComponent(self, UIButton, 31)
  self.btnAtkIcon:SetOnClick(function()
    self:OnBtnAtkIconClick()
  end)
  self.compVFXColor = self.viewSkin:AddComponent(self, UIBaseContainer, 32)
  self.compLList = {
    self.compL1,
    self.compL2,
    self.compL3
  }
  self.compFList = {
    self.compF1,
    self.compF2,
    self.compF3,
    self.compF4,
    self.compF5
  }
end

function LLMainGroup:ComponentDestroy()
  self.viewSkin = nil
  self.compL1 = nil
  self.compL2 = nil
  self.compL3 = nil
  self.compF1 = nil
  self.compF2 = nil
  self.compF3 = nil
  self.compF4 = nil
  self.compF5 = nil
  self.compDef = nil
  self.compAtk = nil
  self.compBuffIcon = nil
  self.textTitle = nil
  self.textTime = nil
  self.btnGo = nil
  self.btnDef = nil
  self.btnAtk = nil
  self.btnInfo = nil
  self.textTipGroup = nil
  self.compRed = nil
  self.compCenter = nil
  self.textTip = nil
  self.compTipGoUp = nil
  self.textTipGoUp = nil
  self.compTipGoDown = nil
  self.textTipGoDown = nil
  self.compVU = nil
  self.compVD = nil
  self.textTimeGoUp = nil
  self.textTimeGoDown = nil
  self.btnDefIcon = nil
  self.btnAtkIcon = nil
  self.compVFXColor = nil
  self.compLList = nil
  self.compFList = nil
end

function LLMainGroup:DataDefine()
  self.compTipGoUp:SetActive(false)
  self.compTipGoDown:SetActive(false)
  self.compVU:SetActive(false)
  self.compVD:SetActive(false)
  self.compBuffIcon.gameObject:GameObjectCreatePool()
  self.defBuffItems = {}
  self.atkBuffItems = {}
end

function LLMainGroup:DataDestroy()
  self:StopDelayRefresh()
  if self.effUpReq ~= nil then
    self.effUpReq:Destroy()
    self.effUpReq = nil
  end
  self.effUpGo = nil
  if self.effDownReq ~= nil then
    self.effDownReq:Destroy()
    self.effDownReq = nil
  end
  self.effDownGo = nil
  self.compDef:RemoveAllComponentes()
  self.compAtk:RemoveAllComponentes()
  self.compBuffIcon.gameObject:GameObjectRecycleAll()
  self.defBuffItems = nil
  self.atkBuffItems = nil
  self.baseRoot = nil
end

function LLMainGroup:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LandlordRedRefresh, self.RefreshRed)
end

function LLMainGroup:OnRemoveListener()
  self:RemoveUIListener(EventId.LandlordRedRefresh, self.RefreshRed)
  base.OnRemoveListener(self)
end

function LLMainGroup:OnBtnGoClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILLGroupChoose)
end

function LLMainGroup:OnBtnDefClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILLBuff, {anim = true}, LLConst.LandLordGroup.LORD)
end

function LLMainGroup:OnBtnDefIconClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILLBuff, {anim = true}, LLConst.LandLordGroup.LORD)
end

function LLMainGroup:OnBtnAtkClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILLBuff, {anim = true}, LLConst.LandLordGroup.FARMER)
end

function LLMainGroup:OnBtnAtkIconClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILLBuff, {anim = true}, LLConst.LandLordGroup.FARMER)
end

function LLMainGroup:OnBtnInfoClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILLRule)
end

function LLMainGroup:SetView(view)
  self.baseRoot = view
  self:SetActive(true)
  self:RefreshView()
  self:TyrReqActInfo()
end

function LLMainGroup:UpdateData()
  if self.baseRoot == nil then
    return
  end
  local info = ActMgr:GetActCurStageInfo()
  self.curStageInfo = info
  self.eTime = info ~= nil and info.eTime or 0
  self.groupPartTime = nil
  local stage = info ~= nil and info.stage or LLConst.LandlordStage.PREVIEW
  self.btnGo:SetActive(stage == LLConst.LandlordStage.GROUP)
  self.textTipGroup:SetActive(stage < LLConst.LandlordStage.PREPARE)
  self.textTip:SetActive(stage >= LLConst.LandlordStage.PREPARE)
  if stage < LLConst.LandlordStage.PREPARE then
    self.textTipGroup:SetLocalText("zonewar_landlord_limit_1001")
    self.textTitle:SetLocalText("zonewar_landlord_phase_name_10001")
    if self.effUpGo then
      self.effUpGo:SetActive(false)
    end
    if self.effDownGo then
      self.effDownGo:SetActive(false)
    end
    local partInfo = ActMgr:GetCurGroupPartInfo()
    local camp = partInfo ~= nil and partInfo.camp or LLConst.LandLordGroup.NONE
    self.compTipGoUp:SetActive(camp == LLConst.LandLordGroup.LORD)
    self.compTipGoDown:SetActive(camp == LLConst.LandLordGroup.FARMER)
    self.compVU:SetActive(camp == LLConst.LandLordGroup.LORD)
    self.compVD:SetActive(camp == LLConst.LandLordGroup.FARMER)
    self.groupPartTime = partInfo ~= nil and partInfo.eTime or 0
  else
    self.compTipGoUp:SetActive(false)
    self.compTipGoDown:SetActive(false)
    self.compVU:SetActive(false)
    self.compVD:SetActive(false)
    self.textTip:SetLocalText("zonewar_landlord_limit_1061")
    local curWeek = ActMgr:GetCurWeek() + 1
    if stage == LLConst.LandlordStage.PREPARE then
      self.textTitle:SetLocalText("zonewar_landlord_limit_1046", curWeek)
    elseif stage == LLConst.LandlordStage.BATTLE then
      self.textTitle:SetLocalText("zonewar_landlord_limit_1047", curWeek)
    elseif stage == LLConst.LandlordStage.REST then
      self.textTitle:SetLocalText("zonewar_landlord_limit_1048", curWeek)
    end
    local group = ActMgr:GetMyGroup()
    if self.effUpReq == nil then
      local path = string.format(EffBasePath, "up", group == LLConst.LandLordGroup.LORD and "blue" or "red")
      self.effUpReq = self:GameObjectInstantiateAsync(path, function(req)
        local go = req.gameObject
        if req.isError or IsNull(go) then
          req:Destroy()
          self.effUpReq = nil
          return
        end
        self.effUpGo = go
        go:SetActive(true)
        local tf = go.transform
        tf.parent = self.compVFXColor.transform
        tf:Reset()
      end)
    elseif self.effUpGo ~= nil then
      self.effUpGo:SetActive(true)
    end
    if self.effDownReq == nil then
      local path = string.format(EffBasePath, "bottom", group == LLConst.LandLordGroup.LORD and "red" or "blue")
      self.effDownReq = self:GameObjectInstantiateAsync(path, function(req)
        local go = req.gameObject
        if req.isError or IsNull(go) then
          req:Destroy()
          self.effDownReq = nil
          return
        end
        self.effDownGo = go
        go:SetActive(true)
        local tf = go.transform
        tf.parent = self.compVFXColor.transform
        tf:Reset()
      end)
    elseif self.effDownGo ~= nil then
      self.effDownGo:SetActive(true)
    end
  end
  self:RefreshServers()
  self:UpdateBuff()
  self:RefreshRed()
  self:Update1000MS()
end

function LLMainGroup:StopDelayRefresh()
  if self.delayRefresh ~= nil then
    self.delayRefresh:Stop()
    self.delayRefresh = nil
  end
end

function LLMainGroup:RefreshServers()
  local info = self.curStageInfo
  local stage = info ~= nil and info.stage or LLConst.LandlordStage.PREVIEW
  local lList = ActMgr:GetServersByGroup(LLConst.LandLordGroup.LORD)
  for i, comp in ipairs(self.compLList) do
    if lList[i] then
      comp:SetServer(lList[i], LLConst.LandLordGroup.LORD, stage)
    else
      comp:SetServer(nil, LLConst.LandLordGroup.NONE, stage)
    end
  end
  local fList = ActMgr:GetServersByGroup(LLConst.LandLordGroup.FARMER)
  for i, comp in ipairs(self.compFList) do
    if fList[i] then
      comp:SetServer(fList[i], LLConst.LandLordGroup.FARMER, stage)
    else
      comp:SetServer(nil, LLConst.LandLordGroup.NONE, stage)
    end
  end
  local delayCheck = false
  local gpInfo = ActMgr:GetCurGroupPartInfo()
  local partIdx = gpInfo ~= nil and gpInfo.partIdx or 0
  if partIdx == 0 then
    local limit = ActMgr:GetCampMaxTeammateCount(LLConst.LandLordGroup.LORD, true)
    if limit > #lList then
      delayCheck = true
    end
  else
    local isFarmer = partIdx == 2
    local curBp = gpInfo.curBp
    local defNum = isFarmer and LLConst.INIT_BIG_FARMER_COUNT or LLConst.INIT_BIG_LORD_COUNT
    local totalLimit = gpInfo.totalLimit + defNum
    local cnt, text
    if isFarmer then
      local limit = ActMgr:GetCampCurLimit(LLConst.LandLordGroup.LORD) + LLConst.INIT_BIG_LORD_COUNT
      if limit > #lList then
        delayCheck = true
      end
      cnt = Mathf.Clamp(curBp - (totalLimit - #fList), 0, curBp)
      text = self.textTipGoDown
    else
      local limit = ActMgr:GetCampCurLimit(LLConst.LandLordGroup.FARMER) + LLConst.INIT_BIG_FARMER_COUNT
      if limit > #fList then
        delayCheck = true
      end
      cnt = Mathf.Clamp(curBp - (totalLimit - #lList), 0, curBp)
      text = self.textTipGoUp
    end
    if text ~= nil and cnt ~= nil then
      text:SetLocalText("zonewar_landlord_limit_1090", cnt, curBp)
    end
  end
  if not delayCheck then
    self:StopDelayRefresh()
  elseif self.delayRefresh == nil then
    self.delayRefresh = TimerManager:GetInstance():DelayInvoke(function()
      self.delayRefresh = nil
      self:TyrReqActInfo(nil, true)
    end, 3)
  end
end

function LLMainGroup:UpdateBuff()
  local actData = ActMgr:GetActData()
  local defBuffIds = actData ~= nil and actData.landlordBuffIds or {}
  self:UpdateGroupBuff(defBuffIds, self.defBuffItems, self.compDef)
  local atkBuffIds = actData ~= nil and actData.farmerBuffIds or {}
  self:UpdateGroupBuff(atkBuffIds, self.atkBuffItems, self.compAtk)
end

function LLMainGroup:UpdateGroupBuff(buffIds, buffItems, comp)
  local lBuff = buffIds ~= nil and #buffIds or 0
  comp:SetActive(0 < lBuff)
  local theItem = self.compBuffIcon.gameObject
  if lBuff <= 0 then
    return
  end
  local lItem = #buffItems
  local lMax = math.max(lBuff, lItem)
  for i = 1, lMax do
    local item = buffItems[i]
    local id = buffIds[i]
    if id ~= nil then
      if item == nil then
        local theName = "Buff_" .. id
        local goItem = theItem:GameObjectSpawn(comp.transform)
        goItem.name = theName
        goItem:SetActive(true)
        item = comp:AddComponent(UIImage, theName)
        buffItems[i] = item
      end
      item:SetActive(true)
      local icon = ActMgr:GetBuffIcon(id)
      if not string.IsNullOrEmpty(icon) then
        item:LoadSpriteAuto(icon)
      end
    elseif item ~= nil then
      item:SetActive(false)
    end
  end
end

function LLMainGroup:RefreshRed()
  ActMgr:SignGroupChanged()
  local red = ActMgr:CheckRed(1)
  self.compRed:SetActive(red)
end

function LLMainGroup:Update1000MS()
  if self.baseRoot == nil then
    return
  end
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  if self.eTime ~= nil and self.eTime ~= 0 then
    if self.eTime - curSec > 0 then
      self.textTime:SetText(UITimeManager:GetInstance():SecondToFmtString(math.max(self.eTime - curSec, 0)))
    else
      self.textTime:SetText(UITimeManager:GetInstance():SecondToFmtString(0))
      self:TyrReqActInfo(curSec)
      return
    end
  end
  if self.groupPartTime ~= nil and self.groupPartTime ~= 0 then
    local text = self.compTipGoUp:GetActive() and self.textTimeGoUp or self.textTimeGoDown
    if 0 < self.groupPartTime - curSec then
      text:SetText(UITimeManager:GetInstance():SecondToFmtString(math.max(self.groupPartTime - curSec, 0)))
    else
      text:SetText(UITimeManager:GetInstance():SecondToFmtString(0))
      self:TyrReqActInfo(curSec)
    end
  end
end

function LLMainGroup:TyrReqActInfo(curSec, bForce)
  if self.baseRoot ~= nil then
    self.baseRoot:TyrReqActInfo(curSec or UITimeManager:GetInstance():GetServerSeconds(), bForce)
  end
end

return LLMainGroup
