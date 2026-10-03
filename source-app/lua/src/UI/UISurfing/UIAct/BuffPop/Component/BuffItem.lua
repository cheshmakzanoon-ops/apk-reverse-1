local base = UIBaseContainer
local BuffItem = BaseClass("BuffItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function BuffItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function BuffItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function BuffItem:ComponentDefine()
  self.textBuffTitle = self:AddComponent(UITextMeshProUGUIEx, "buffTitle")
  self.textLevel = self:AddComponent(UITextMeshProUGUIEx, "rect_unlock/imgLevel/levelText")
  self.imgBuffFrame = self:AddComponent(UIImage, "buffFrame")
  self.imgLevel = self:AddComponent(UIImage, "rect_unlock/imgLevel")
  self.imgBuffLock = self:AddComponent(UIImage, "rect_lock/buffLock")
  self.unlockEffect = self:AddComponent(UIBaseContainer, "rect_unlock/unlockEffect")
  self.imgBuff = self:AddComponent(UIImage, "buffImg")
  self.textBuffDesc = self:AddComponent(UITextMeshProUGUIEx, "buffDesc")
  self.btnGo = self:AddComponent(UIButton, "rect_unlock/GoBtn")
  self.btnGo:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.btnUnlock = self:AddComponent(UIButton, "rect_lock/unlockBtn")
  self.imgGray = self:AddComponent(UIButton, "rect_lock/unlockBtn/imgGray")
  self.btnUnlock:SetOnClick(function()
    self:OnBtnUnlockClick()
  end)
  self.textBtn = self:AddComponent(UITextMeshProUGUIEx, "rect_unlock/GoBtn/BtnText")
  self.textMax = self:AddComponent(UITextMeshProUGUIEx, "rect_unlock/maxText")
  self.progressRect = self:AddComponent(UIBaseContainer, "progress")
  self.resourceRect = self:AddComponent(UIBaseContainer, "rect_unlock/resource")
  self.textResourceNum = self:AddComponent(UITextMeshProUGUIEx, "rect_unlock/resource/resourceNum")
  self.textRemain = self:AddComponent(UITextMeshProUGUIEx, "rect_lock/remainText")
  self.unlockRect = self:AddComponent(UIBaseContainer, "rect_unlock")
  self.lockRect = self:AddComponent(UIBaseContainer, "rect_lock")
  self.compCell = self:AddComponent(UIBaseContainer, "progress/cell")
  self.imgBg = self:AddComponent(UIImage, "progress/cell/bg")
  self.imgFill = self:AddComponent(UIImage, "progress/cell/fill")
  self.compCell.gameObject:SetActive(false)
  self.compCellPool = self.compCell.gameObject
  self.compCellPool:GameObjectCreatePool()
  self.compCells = {}
end

function BuffItem:ComponentDestroy()
  self.textBuffTitle = nil
  self.textLevel = nil
  self.imgBuffFrame = nil
  self.imgLevel = nil
  self.imgBuffLock = nil
  self.imgBuff = nil
  self.textBuffDesc = nil
  self.btnGo = nil
  self.textBtn = nil
  self.textMax = nil
  self.progressRect = nil
  self.compCell = nil
  self.imgBg = nil
  self.imgFill = nil
  self.resourceRect = nil
  self.textResourceNum = nil
  self.textRemain = nil
  self.imgGray = nil
  self.unlockEffect = nil
end

function BuffItem:DataDefine()
  self.redColor = Color32.New(0.9098039215686274, 0.25882352941176473, 0.25882352941176473, 1)
end

function BuffItem:DataDestroy()
  self:ClearContent()
  self.buffData = nil
  self.buffDetailInfo = nil
  self.maxLevel = nil
  self.curLevel = nil
  self.isLock = nil
  self.isGrayBool = nil
end

function BuffItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SurfingLevelUpBuffSkillInfo, self.LevelUpBuff)
  self:AddUIListener(EventId.SurfingUnlockBuffSkillInfo, self.UnlockBuff)
end

function BuffItem:OnRemoveListener()
  self:RemoveUIListener(EventId.SurfingLevelUpBuffSkillInfo, self.LevelUpBuff)
  self:RemoveUIListener(EventId.SurfingUnlockBuffSkillInfo, self.UnlockBuff)
  base.OnRemoveListener(self)
end

function BuffItem:OnBtnGoClick()
  local cost = tonumber(self.buffDetailInfo.cost)
  if cost ~= -1 then
    if cost <= DataCenter.LWSurfingDataManager:GetCoinNum() then
      DataCenter.LWSurfingDataManager:SendUpgradeParkourBuffMessage(self.buffData.id)
    else
      UIUtil.ShowTipsId("parkour_buff_no_enough")
      self.view.ctrl:CloseSelf()
      EventManager:GetInstance():Broadcast(EventId.SurfingShowArrowGuide)
    end
  else
    DataCenter.LWSurfingDataManager:SendUpgradeParkourBuffMessage(self.buffData.id)
  end
end

function BuffItem:OnBtnUnlockClick()
  local now = UITimeManager:GetInstance():GetServerTime()
  if now > self.buffData.unlockTime then
    DataCenter.LWSurfingDataManager:SendUnlockParkourBuffMessage(self.buffData.id)
  end
end

function BuffItem:ReInit(data)
  self.buffData = data
  self.buffDetailInfo = DataCenter.LWSurfingDataManager:GetBuffDetailInfo(self.buffData.id)
  self.imgBuff:LoadSprite(self.buffDetailInfo.buff_icon)
  self.textBuffTitle:SetLocalText(self.buffDetailInfo.buff_name)
  self:UpdateBuffInfo()
end

function BuffItem:LevelUpBuff(param)
  self.unlockEffect.gameObject:SetActive(false)
  local num = DataCenter.LWSurfingDataManager:GetCoinNum()
  self.textResourceNum:SetColor(num < tonumber(self.buffDetailInfo.cost) and self.redColor or Color32.black)
  if self.buffData.id == param.id or self.buffData.id == param.newId then
    self.buffData.id = param.newId
    self.buffDetailInfo = DataCenter.LWSurfingDataManager:GetBuffDetailInfo(self.buffData.id)
    self:UpdateBuffInfo(true)
  end
end

function BuffItem:UnlockBuff(id)
  if self.buffData.id == id then
    self.buffData.unlockTime = nil
    self:UpdateBuffInfo(true, true)
  end
end

function BuffItem:UpdateBuffInfo(effect, unlockEffect)
  self.curLevel = self.buffDetailInfo.level
  self.maxLevel = self.buffDetailInfo.max_level
  if self.buffData.unlockTime then
    self.isLock = true
  else
    self.isLock = false
  end
  self:RefreshProgress(effect)
  self.textBuffDesc:SetLocalText(self.buffDetailInfo.buff_desc, self.buffDetailInfo.para1)
  if self.isLock then
    self.unlockRect.gameObject:SetActive(false)
    self.lockRect.gameObject:SetActive(true)
    self.unlockEffect.gameObject:SetActive(false)
    self.isGrayBool = true
    self:Update1000MS()
  else
    self.unlockRect.gameObject:SetActive(true)
    self.lockRect.gameObject:SetActive(false)
    if effect and unlockEffect then
      self.unlockEffect.gameObject:SetActive(true)
    else
      self.unlockEffect.gameObject:SetActive(false)
    end
    self:UpdateUnlockBuffInfo()
  end
end

function BuffItem:UpdateUnlockBuffInfo()
  self.textLevel:SetLocalText("parkour_buff_progress", self.curLevel, self.maxLevel)
  if self.curLevel == self.maxLevel then
    self.btnGo.gameObject:SetActive(false)
    self.textMax.gameObject:SetActive(true)
    self.resourceRect.gameObject:SetActive(false)
  else
    self.btnGo.gameObject:SetActive(true)
    self.textMax.gameObject:SetActive(false)
    self.resourceRect.gameObject:SetActive(true)
    if tonumber(self.buffDetailInfo.cost) ~= -1 then
      self.textResourceNum:SetText(self.buffDetailInfo.cost)
      local num = DataCenter.LWSurfingDataManager:GetCoinNum()
      self.textResourceNum:SetColor(num < tonumber(self.buffDetailInfo.cost) and self.redColor or Color32.black)
    else
      self.resourceRect.gameObject:SetActive(false)
    end
  end
end

function BuffItem:Update1000MS()
  if not self.isLock then
    return
  end
  if not self.isGrayBool then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if now < self.buffData.unlockTime then
    local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(self.buffData.unlockTime - now)
    self.textRemain.gameObject:SetActive(true)
    self.textRemain:SetText(timeStr)
    self.imgGray.gameObject:SetActive(true)
  else
    self.imgGray.gameObject:SetActive(false)
    self.textRemain.gameObject:SetActive(false)
    self.isGrayBool = false
  end
end

function BuffItem:RefreshProgress(effect)
  self:ClearContent()
  self.compCells = {}
  if self.maxLevel then
    local count = self.maxLevel
    for i = 1, count do
      local item = self.compCells[i]
      if item == nil then
        local go = self.compCellPool:GameObjectSpawn(self.progressRect.transform)
        go.name = "item" .. i
        item = self.progressRect:AddComponent(UIBaseContainer, go.name)
        item.black = item:AddComponent(UIBaseContainer, "bg")
        item.fill = item:AddComponent(UIBaseContainer, "fill")
        item.effect = item:AddComponent(UIBaseContainer, "fill/effect")
        self.compCells[i] = item
      else
        item.gameObject.transform:SetParent(self.progressRect.transform)
      end
      item:SetActive(true)
      if self.isLock or i > self.curLevel then
        item.fill.gameObject:SetActive(false)
      else
        item.fill.gameObject:SetActive(true)
        if effect and self.curLevel == i then
          item.effect.gameObject:SetActive(true)
        else
          item.effect.gameObject:SetActive(false)
        end
      end
    end
    for i = count + 1, #self.compCells do
      local item = self.compCells[i]
      if item then
        item:SetActive(false)
      end
    end
  end
end

function BuffItem:ClearContent()
  self.progressRect:RemoveComponents(UIBaseContainer)
  self.compCellPool:GameObjectRecycleAll()
  self.compCells = nil
end

return BuffItem
