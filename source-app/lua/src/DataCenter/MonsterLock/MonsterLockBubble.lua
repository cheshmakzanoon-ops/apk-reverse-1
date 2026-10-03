local MonsterLockBubble = BaseClass("MonsterLockBubble")
local Localization = CS.GameEntry.Localization
local root_path = "Root"
local icon_path = "Root/Icon"
local btn_path = "Root/Btn"
local btn_text_path = "Root/Btn/BtnText"
local cost_icon_path = "Root/Btn/CostIcon"
local cost_count_path = "Root/Btn/CostCount"
local top_bg_path = "Root/TopBg"
local top_text_path = "Root/TopBg/TopText"
local bottom_bg_path = "Root/BottomBg"
local bottom_text_path = "Root/BottomBg/BottomText"
local bottom_arrow_path = "Root/BottomBg/BottomArrow"
local bottom_underline_path = "Root/BottomBg/BottomUnderline"
local ground_path = "Ground"
local ground_green_path = "Ground/VFX_kaidige_shanshuo"
local ground_yellow_path = "Ground/VFX_kaidige_huangse"
local GroundSizeScale = 0.2
local GroundPosScale = 1.0
local time_path = "Root/Time"
local time_text_path = "Root/Time/TimeText"
local BtnTextPosHigh = Vector3.New(0, 0.4, 0)
local BtnTextPosLow = Vector3.New(0, 0.0092, 0)
local Brown = Color.New(0.5568628, 0.2470588, 0.09411766, 1)

local function __init(self)
  self.id = 0
  self.data = nil
  self.req = nil
  self.onClick = nil
  self.state = LandLockBubbleState.None
end

local function __delete(self)
  self.id = nil
  self.data = nil
  self.req = nil
  self.onClick = nil
  self.state = nil
end

local function OnCreate(self)
  self.gameObject = self.req.gameObject
  self.transform = self.gameObject.transform
  self.root_anim = self.transform:Find(root_path):GetComponent(typeof(CS.UnityEngine.Animator))
  self.icon_sprite = self.transform:Find(icon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.btn_sprite = self.transform:Find(btn_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.btn_text = self.transform:Find(btn_text_path):GetComponent(typeof(CS.SuperTextMesh))
  self.cost_sprite = self.transform:Find(cost_icon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.cost_text = self.transform:Find(cost_count_path):GetComponent(typeof(CS.SuperTextMesh))
  self.top_bg_sprite = self.transform:Find(top_bg_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.top_text = self.transform:Find(top_text_path):GetComponent(typeof(CS.SuperTextMesh))
  self.bottom_bg_sprite = self.transform:Find(bottom_bg_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.bottom_text = self.transform:Find(bottom_text_path):GetComponent(typeof(CS.SuperTextMesh))
  self.bottom_arrow_go = self.transform:Find(bottom_arrow_path).gameObject
  self.bottom_underline_go = self.transform:Find(bottom_underline_path).gameObject
  self.time_go = self.transform:Find(time_path).gameObject
  self.time_text = self.transform:Find(time_text_path):GetComponent(typeof(CS.SuperTextMesh))
  self.icon_trigger = self.transform:Find(icon_path):GetComponent(typeof(CS.UIEventTrigger))
  
  function self.icon_trigger.onPointerClick()
    self:OnClick()
  end
  
  self.btn_trigger = self.transform:Find(btn_path):GetComponent(typeof(CS.UIEventTrigger))
  
  function self.btn_trigger.onPointerClick()
    self:OnClick()
  end
  
  self.ground_go = self.transform:Find(ground_path).gameObject
  self.ground_green_go = self.transform:Find(ground_green_path).gameObject
  self.ground_yellow_go = self.transform:Find(ground_yellow_path).gameObject
  
  function self.TimeCallBack()
    self:UpdateTimeText()
  end
end

local function OnDestroy(self)
  self.gameObject = nil
  self.transform = nil
  self.root_anim = nil
  self.icon_sprite = nil
  self.btn_sprite = nil
  self.btn_text = nil
  self.cost_sprite = nil
  self.cost_text = nil
  self.top_bg_sprite = nil
  self.top_text = nil
  self.bottom_bg_sprite = nil
  self.bottom_text = nil
  self.bottom_arrow_go = nil
  self.bottom_underline_go = nil
  if self.icon_trigger then
    self.icon_trigger.onPointerClick = nil
    self.icon_trigger = nil
  end
  if self.btn_trigger then
    self.btn_trigger.onPointerClick = nil
    self.btn_trigger = nil
  end
  self.ground_go = nil
  self.ground_green_go = nil
  self.ground_yellow_go = nil
  if self.req ~= nil then
    self.req:Destroy()
    self.req = nil
  end
  self:RemoveTimer()
end

local function Init(self, id)
  self.id = id
  self.data = DataCenter.MonsterLockDataManager:GetMonsterData(id)
  if self.data.state == MonsterLockState.NOT_BUY then
    self:SetBubbleState(MonsterLockBubbleState.Unlocked)
  elseif self.data.state == MonsterLockState.BUY then
    self:SetBubbleState(MonsterLockBubbleState.Unlocked)
  elseif self.data.state == MonsterLockState.Finished then
    self:SetBubbleState(MonsterLockBubbleState.Pve)
  end
  self:RefreshPosition()
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1.0, self.TimeCallBack, nil, false, false, false)
    self.timer:Start()
  end
end

local function RemoveTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function SetBubbleState(self, state)
  self.top_bg_sprite.gameObject:SetActive(false)
  self.bottom_bg_sprite.gameObject:SetActive(false)
  local needShowTime = self:NeedShowTime()
  self.time_go.gameObject:SetActive(needShowTime)
  if needShowTime then
    self:AddTimer()
  else
    self:RemoveTimer()
  end
  self.state = state
  if state == MonsterLockBubbleState.Unlocked then
    local template = DataCenter.MonsterLockTemplateManager:GetTemplate(self.id)
    self.icon_sprite.gameObject:SetActive(true)
    if template.duration > 0 then
      self.icon_sprite:LoadSprite(string.format(LoadPath.UIBuildBubble, "bubble_bg_landlock_locked2"))
    else
      self.icon_sprite:LoadSprite(string.format(LoadPath.UIBuildBubble, "bubble_bg_landlock_locked3"))
    end
    self.btn_sprite.gameObject:SetActive(false)
    self.ground_yellow_go:SetActive(true)
    self.ground_green_go:SetActive(false)
  elseif state == MonsterLockBubbleState.Pay then
    self.icon_sprite.gameObject:SetActive(false)
    self.btn_sprite.gameObject:SetActive(true)
    self.btn_sprite:LoadSprite(string.format(LoadPath.UILandLock, "UILandLock_yellow_btn"))
    self.btn_text.outlineColor = Brown
    self.cost_text.outlineColor = Brown
    self.btn_text.text = Localization:GetString(130056)
    self.ground_yellow_go:SetActive(false)
    self.ground_green_go:SetActive(true)
    self:RefreshCost()
    self:RefreshDesc()
  elseif state == MonsterLockBubbleState.Pve then
    self.icon_sprite.gameObject:SetActive(false)
    self.btn_sprite.gameObject:SetActive(true)
    self.btn_sprite:LoadSprite(string.format(LoadPath.UILandLock, "UILandLock_yellow_btn"))
    self.btn_text.outlineColor = Brown
    self.cost_text.outlineColor = Brown
    self.btn_text.text = Localization:GetString(395127)
    self.ground_yellow_go:SetActive(false)
    self.ground_green_go:SetActive(true)
    self:RefreshCost()
    self:RefreshDesc()
  end
  self.root_anim:Play("V_ui_UILandLock_chuxian", 0, 0)
end

local function RefreshCost(self)
  local showCost = false
  if self.data.needPay and not self.data.paid then
    local template = DataCenter.MonsterLockTemplateManager:GetTemplate(self.id)
    local icon, count, haveCount = template:GetCost()
    if 0 < count then
      if count <= haveCount then
        self.cost_text.color32 = Color32.New(255, 255, 255, 255)
      else
        self.cost_text.color32 = Color32.New(255, 0, 0, 255)
      end
      local costStr = haveCount .. "/" .. count
      self.btn_text.transform.localPosition = BtnTextPosHigh
      self.cost_sprite.gameObject:SetActive(true)
      self.cost_sprite:LoadSprite(icon)
      local localPos = self.cost_sprite.transform.localPosition
      self.cost_sprite.transform.localPosition = Vector3.New(-0.6 - #costStr * 0.1, localPos.y, localPos.z)
      self.cost_text.gameObject:SetActive(true)
      self.cost_text.text = tostring(costStr)
      showCost = true
    end
  end
  if not showCost then
    self.btn_text.transform.localPosition = BtnTextPosLow
    self.cost_sprite.gameObject:SetActive(false)
    self.cost_text.gameObject:SetActive(false)
  end
end

local function RefreshDesc(self)
  local topDescList = {}
  local pveTemplate = DataCenter.PveLevelTemplateManager:GetTemplate(self.data.pve)
  if self.state == LandLockBubbleState.Pve then
    local needArmy = pveTemplate.needArmy
    if needArmy.level == 1 then
      local desc = Localization:GetString("400018", needArmy.count)
      table.insert(topDescList, desc)
    elseif needArmy.level > 1 then
      local desc = Localization:GetString("400019", needArmy.level, needArmy.count)
      table.insert(topDescList, desc)
    end
  end
end

local function RefreshPosition(self)
  local pos = SceneUtils.TileIndexToWorld(self.data.pointId)
  local template = DataCenter.MonsterLockTemplateManager:GetTemplate(self.id)
  self.transform.position = pos
  self.root_anim.transform.localPosition = Vector3.New(0, template.height, 0)
  local scaleX = (template.rect.right - template.rect.left + 1) * GroundSizeScale
  local scaleZ = (template.rect.top - template.rect.bottom + 1) * GroundSizeScale
  self.ground_go.transform.localScale = Vector3.New(scaleX, 1, scaleZ)
  local posX = (template.rect.left + template.rect.right) / 2 * GroundPosScale
  local posZ = (template.rect.bottom + template.rect.top) / 2 * GroundPosScale
  self.ground_go.transform.localPosition = Vector3.New(posX, 0, posZ)
  self.icon_sprite.transform.localPosition = Vector3.New(posX, self.icon_sprite.transform.localPosition.y, posZ)
  self.time_text.transform.localPosition = Vector3.New(posX, self.time_text.transform.localPosition.y, posZ)
end

local function SetReq(self, req)
  self.req = req
end

local function SetOnClick(self, onClick)
  self.onClick = onClick
end

local function OnClick(self)
  if self.onClick then
    self.onClick()
  end
end

local function SetActive(self, active)
  if self.gameObject ~= nil then
    self.gameObject:SetActive(active)
  end
end

local function GetGuideNode(self)
  return self.icon_sprite
end

local function NeedShowTime(self)
  if self.data == nil then
    return false
  end
  if self.data.expireTime == nil or self.data.expireTime <= 0 then
    return false
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  return now < self.data.expireTime
end

local function UpdateTimeText(self)
  if self.data == nil or self.data.expireTime == nil or self.data.expireTime <= 0 then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local left = self.data.expireTime - now
  if left <= 0 then
    DataCenter.MonsterLockDataManager:RemoveLockData(self.data.monsterId)
    return
  else
    local restTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(left)
    self.time_text.text = restTimeStr
  end
end

MonsterLockBubble.__init = __init
MonsterLockBubble.__delete = __delete
MonsterLockBubble.OnCreate = OnCreate
MonsterLockBubble.OnDestroy = OnDestroy
MonsterLockBubble.Init = Init
MonsterLockBubble.SetBubbleState = SetBubbleState
MonsterLockBubble.RefreshCost = RefreshCost
MonsterLockBubble.RefreshDesc = RefreshDesc
MonsterLockBubble.RefreshPosition = RefreshPosition
MonsterLockBubble.SetReq = SetReq
MonsterLockBubble.SetOnClick = SetOnClick
MonsterLockBubble.OnClick = OnClick
MonsterLockBubble.SetActive = SetActive
MonsterLockBubble.GetGuideNode = GetGuideNode
MonsterLockBubble.NeedShowTime = NeedShowTime
MonsterLockBubble.UpdateTimeText = UpdateTimeText
MonsterLockBubble.AddTimer = AddTimer
MonsterLockBubble.RemoveTimer = RemoveTimer
return MonsterLockBubble
