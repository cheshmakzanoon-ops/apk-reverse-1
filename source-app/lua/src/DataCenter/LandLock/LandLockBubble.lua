local LandLockBubble = BaseClass("LandLockBubble")
local Localization = CS.GameEntry.Localization
local root_path = "Root"
local trigger_path = "Root/Trigger"
local icon_path = "Root/Icon"
local help_path = "Root/Help"
local btn_path = "Root/Btn"
local btn_text_path = "Root/Btn/BtnText"
local cost_icon_path = "Root/Btn/CostIcon"
local cost_count_path = "Root/Btn/CostCount"
local top_bg_path = "Root/TopBg"
local top_text_path = "Root/TopBg/TopText"
local top_icon_path = "Root/TopBg/TopIcon"
local pro_bg_path = "Root/Icon/ProBg"
local pro_text_path = "Root/Icon/ProBg/ProText"
local ground_path = "Ground"
local ground_green_path = "Ground/VFX_kaidige_shanshuo"
local ground_yellow_path = "Ground/VFX_kaidige_huangse"
local GroundSizeScale = 0.225
local BtnTextPosHigh = Vector3.New(0, 0.4, 0)
local BtnTextPosLow = Vector3.New(0, 0.0092, 0)
local Brown = Color.New(0.5568628, 0.2470588, 0.09411766, 1)
local ColliderSize = {Icon = 1, Btn = 2}

local function __init(self)
  self.id = 0
  self.data = nil
  self.req = nil
  self.onClick = nil
  self.state = LandLockBubbleState.None
  self.showIcon = true
end

local function __delete(self)
  self.id = nil
  self.data = nil
  self.req = nil
  self.onClick = nil
  self.state = nil
  self.showIcon = false
end

local function OnCreate(self)
  self.gameObject = self.req.gameObject
  self.transform = self.gameObject.transform
  self.root_anim = self.transform:Find(root_path):GetComponent(typeof(CS.UnityEngine.Animator))
  self.icon_sprite = self.transform:Find(icon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.help_go = self.transform:Find(help_path).gameObject
  self.btn_sprite = self.transform:Find(btn_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.btn_text = self.transform:Find(btn_text_path):GetComponent(typeof(CS.SuperTextMesh))
  self.cost_sprite = self.transform:Find(cost_icon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.cost_text = self.transform:Find(cost_count_path):GetComponent(typeof(CS.SuperTextMesh))
  self.top_bg_sprite = self.transform:Find(top_bg_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.top_text = self.transform:Find(top_text_path):GetComponent(typeof(CS.SuperTextMesh))
  self.top_icon_go = self.transform:Find(top_icon_path).gameObject
  self.pro_bg_sprite = self.transform:Find(pro_bg_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.pro_text = self.transform:Find(pro_text_path):GetComponent(typeof(CS.SuperTextMesh))
  self.trigger = self.transform:Find(trigger_path):GetComponent(typeof(CS.TouchObjectEventTrigger))
  
  function self.trigger.onPointerClick()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_enter_pve, false)
    self:OnClick()
  end
  
  function self.trigger.onPointerDoubleClick()
    self:OnClick()
  end
  
  function self.trigger.onPointerDown()
    self:Shrink(true)
  end
  
  function self.trigger.onPointerUp()
    self:Shrink(false)
  end
  
  self.collider = self.transform:Find(trigger_path):GetComponent(typeof(CS.UnityEngine.BoxCollider))
  self.ground_go = self.transform:Find(ground_path).gameObject
  self.ground_green_go = self.transform:Find(ground_green_path).gameObject
  self.ground_yellow_go = self.transform:Find(ground_yellow_path).gameObject
  self.created = true
end

local function OnDestroy(self)
  self.gameObject = nil
  self.transform = nil
  self.root_anim = nil
  self.icon_sprite = nil
  self.help_go = nil
  self.btn_sprite = nil
  self.btn_text = nil
  self.cost_sprite = nil
  self.cost_text = nil
  self.top_bg_sprite = nil
  self.top_text = nil
  self.top_icon_go = nil
  self.pro_bg_sprite = nil
  self.pro_text = nil
  if self.trigger ~= nil then
    self.trigger.onPointerClick = nil
    self.trigger.onPointerDoubleClick = nil
    self.trigger.onPointerDown = nil
    self.trigger.onPointerUp = nil
    self.trigger = nil
  end
  self.ground_go = nil
  self.ground_green_go = nil
  self.ground_yellow_go = nil
  if self.req ~= nil then
    self.req:Destroy()
    self.req = nil
  end
  self.created = nil
end

local function Init(self, id)
  self.id = id
  self.data = DataCenter.LandLockManager:GetLandLockDataById(id)
  if self.data.state == LandLockState.Hide then
    self:SetBubbleState(LandLockBubbleState.Hide)
  elseif self.data.state == LandLockState.Locked then
    self:SetBubbleState(LandLockBubbleState.Locked)
  elseif self.data.state == LandLockState.Unlocked then
    self:SetBubbleState(LandLockBubbleState.Unlocked)
  end
  self:RefreshPosition()
  self:Shrink(false)
end

local function SetBubbleState(self, state)
  self.state = state
  if not self.created then
    return
  end
  local template = DataCenter.LandLockManager:GetTemplate(self.id)
  if state == LandLockBubbleState.Hide then
    self.icon_sprite.gameObject:SetActive(self.showIcon)
    self:SetTriggerActive(self.showIcon)
    self.icon_sprite:LoadSprite(string.format(LoadPath.UIBuildBubble, "bubble_bg_landlock_hide"))
    self.help_go:SetActive(false)
    self.pro_bg_sprite.gameObject:SetActive(false)
    self.btn_sprite.gameObject:SetActive(false)
    self.ground_yellow_go:SetActive(self.showIcon)
    self.ground_green_go:SetActive(false)
    self:RefreshDesc()
    self:SetColliderSize(ColliderSize.Icon)
    self.root_anim:Play("V_ui_UILandLock_chuxian", 0, 0)
  elseif state == LandLockBubbleState.Unlocked then
    self.icon_sprite.gameObject:SetActive(self.showIcon)
    self:SetTriggerActive(self.showIcon)
    self.icon_sprite:LoadSprite(string.format(LoadPath.UIBuildBubble, "bubble_bg_landlock_unlocked"))
    self.help_go:SetActive(false)
    self.pro_bg_sprite.gameObject:SetActive(false)
    self.btn_sprite.gameObject:SetActive(false)
    self.top_bg_sprite.gameObject:SetActive(false)
    self.ground_yellow_go:SetActive(self.showIcon)
    self.ground_green_go:SetActive(false)
    self:SetColliderSize(ColliderSize.Icon)
    self.root_anim:Play("V_ui_UILandLock_chuxian", 0, 0)
  elseif state == LandLockBubbleState.Locked then
    self:SetTriggerActive(self.showIcon)
    if self.data:CheckNeedQuest() then
      if template.bubbleType == LandLockBubbleType.Help then
        self.icon_sprite.gameObject:SetActive(false)
        self.help_go:SetActive(self.showIcon)
      else
        local oldActive = self.icon_sprite.gameObject.activeSelf
        self.icon_sprite.gameObject:SetActive(self.showIcon)
        if not oldActive and self.showIcon then
          self.root_anim:Play("V_ui_UILandLock_chuxian", 0, 0)
        end
        self.help_go:SetActive(false)
        local bubbleType
        local pveTemplate = DataCenter.PveLevelTemplateManager:GetTemplate(self.data:GetCurPve())
        if pveTemplate then
          local monsterTemplate = pveTemplate:GetFirstBattleMonsterTemplate()
          if monsterTemplate then
            if 0 < monsterTemplate.needHero.level then
              bubbleType = LandLockBubbleType.Yellow
            elseif 0 < monsterTemplate.recommend_power then
              if DataCenter.LandLockManager:IsLandLockNeedLowestPower(self.id) then
                bubbleType = LandLockBubbleType.Yellow
              else
                bubbleType = LandLockBubbleType.Red
              end
            end
          end
        end
        local iconPath = self:GetBubbleIconPath(bubbleType or template.bubbleType)
        self.icon_sprite:LoadSprite(iconPath)
      end
      self:RefreshPro()
      self.btn_sprite.gameObject:SetActive(false)
      self.top_bg_sprite.gameObject:SetActive(false)
      self.ground_yellow_go:SetActive(self.showIcon)
      self.ground_green_go:SetActive(false)
      self:SetColliderSize(ColliderSize.Icon)
    else
      self.icon_sprite.gameObject:SetActive(false)
      self.help_go:SetActive(false)
      self.pro_bg_sprite.gameObject:SetActive(false)
      self.btn_sprite.gameObject:SetActive(false)
      self.top_bg_sprite.gameObject:SetActive(false)
      self.ground_yellow_go:SetActive(false)
      self.ground_green_go:SetActive(false)
    end
  elseif state == LandLockBubbleState.Pay then
    self.icon_sprite.gameObject:SetActive(false)
    self.help_go:SetActive(false)
    self.pro_bg_sprite.gameObject:SetActive(false)
    self.btn_sprite.gameObject:SetActive(true)
    self.btn_sprite:LoadSprite(string.format(LoadPath.UILandLock, "UILandLock_yellow_btn"))
    self.btn_text.outlineColor = Brown
    self.cost_text.outlineColor = Brown
    self.btn_text.text = Localization:GetString(130056)
    self.ground_yellow_go:SetActive(false)
    self.ground_green_go:SetActive(true)
    self:RefreshCost()
    self:RefreshDesc()
    self:SetTriggerActive(true)
    self:SetColliderSize(ColliderSize.Btn)
    self.root_anim:Play("V_ui_UILandLock_chuxian", 0, 0)
  elseif state == LandLockBubbleState.Pve then
    self.icon_sprite.gameObject:SetActive(false)
    self.help_go:SetActive(false)
    self.btn_sprite.gameObject:SetActive(true)
    self.btn_sprite:LoadSprite(string.format(LoadPath.UILandLock, "UILandLock_yellow_btn"))
    self.btn_text.outlineColor = Brown
    self.cost_text.outlineColor = Brown
    if template.bubbleType == LandLockBubbleType.Axe then
      self.btn_text.text = Localization:GetString(121449)
    elseif template.bubbleType == LandLockBubbleType.Red then
      self.btn_text.text = Localization:GetString(400006)
    else
      self.btn_text.text = Localization:GetString(395127)
    end
    self.ground_yellow_go:SetActive(false)
    self.ground_green_go:SetActive(true)
    self:RefreshCost()
    self:RefreshDesc()
    self:RefreshPro()
    self:SetTriggerActive(true)
    self:SetColliderSize(ColliderSize.Btn)
    self.root_anim:Play("V_ui_UILandLock_chuxian", 0, 0)
  end
end

local function RefreshCost(self)
  local showCost = false
  if self.data.needPay and not self.data.paid then
    local template = DataCenter.LandLockManager:GetTemplate(self.id)
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
  local template = DataCenter.LandLockManager:GetTemplate(self.id)
  local iconType = LandLockTopIcon.None
  local pveTemplate = DataCenter.PveLevelTemplateManager:GetTemplate(self.data:GetCurPve())
  if pveTemplate then
    local monsterTemplate = pveTemplate:GetFirstBattleMonsterTemplate()
    if monsterTemplate then
      if monsterTemplate.recommend_power > 0 then
        local desc = Localization:GetString("300644", string.GetFormattedSeperatorNum(monsterTemplate.recommend_power))
        table.insert(topDescList, desc)
        if self.data.state == LandLockState.Locked then
          if DataCenter.LandLockManager:IsLandLockNeedLowestPower(self.id) then
            iconType = LandLockTopIcon.Yellow
          else
            iconType = LandLockTopIcon.Red
          end
        end
      end
      if 0 < monsterTemplate.needArmy.level then
        local desc = Localization:GetString("400019", monsterTemplate.needArmy.level, monsterTemplate.needArmy.count)
        table.insert(topDescList, desc)
      end
      if 0 < monsterTemplate.needHero.level then
        local desc = Localization:GetString("121460", monsterTemplate.needHero.level, monsterTemplate.needHero.count)
        table.insert(topDescList, desc)
        if self.data.state == LandLockState.Locked then
          iconType = LandLockTopIcon.Yellow
        end
      end
    end
  end
  if self.state == LandLockBubbleState.Hide and not self.data:CheckNeedBuild() then
    local needBuild = template.needBuild
    for _, v in ipairs(needBuild) do
      local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(v.buildId)
      local buildName = Localization:GetString(buildTemplate.name)
      local desc = Localization:GetString("130041", buildName, v.level)
      table.insert(topDescList, desc)
    end
  end
  if self.state == LandLockBubbleState.Hide and not self.data:CheckNeedChapter() then
    local desc = Localization:GetString("121356", template.needChapter)
    table.insert(topDescList, desc)
  end
  if table.IsNullOrEmpty(topDescList) then
    self.top_bg_sprite.gameObject:SetActive(false)
  else
    self.top_bg_sprite.gameObject:SetActive(self.showIcon)
    self.top_text.text = string.join(topDescList, "\n")
    local sizeX = self.top_text:GetWidth() + 1
    local sizeY = #topDescList * 0.5 + 0.5
    self.top_bg_sprite:Set_size(sizeX, sizeY)
  end
  if iconType ~= LandLockTopIcon.None then
    local x = -(self.top_text:GetWidth() / 2 + 0.55)
    self.top_icon_go.transform.localPosition = Vector3.New(x, 0.025, 0)
    self.top_icon_go:SetActive(true)
    local tfCount = self.top_icon_go.transform.childCount
    if 0 < tfCount then
      for i = 0, tfCount - 1 do
        local tf = self.top_icon_go.transform:GetChild(i)
        tf.gameObject:SetActive(tf.name == iconType)
      end
    end
  else
    self.top_icon_go:SetActive(false)
  end
end

local function RefreshPro(self)
  if #self.data.pveList > 1 then
    self.pro_bg_sprite.gameObject:SetActive(true)
    self.pro_text.text = string.format("%s/%s", self.data:GetPveFinishCount(), #self.data.pveList)
  else
    self.pro_bg_sprite.gameObject:SetActive(false)
  end
end

local function RefreshPosition(self)
  local template = DataCenter.LandLockManager:GetTemplate(self.id)
  local pos = self.data:GetCenterWorldPos()
  self.transform.position = pos
  self.root_anim.transform.localPosition = Vector3.New(0, template.height, 0)
  local scaleX = (template.rect.right - template.rect.left + 1) * GroundSizeScale
  local scaleZ = (template.rect.top - template.rect.bottom + 1) * GroundSizeScale
  self.ground_go.transform.localScale = Vector3.New(scaleX, 1, scaleZ)
  self.ground_go.transform.localPosition = Vector3.New(0, 0, 0)
end

local function SetColliderSize(self, type)
  if type == ColliderSize.Icon then
    self.collider.size = Vector3.New(2, 2, 0.2)
    self.collider.center = Vector3.New(0, -0.05, 0)
  elseif type == ColliderSize.Btn then
    self.collider.size = Vector3.New(4, 2, 0.2)
    self.collider.center = Vector3.New(0, 0.15, 0)
  end
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
    EventManager:GetInstance():Broadcast(EventId.ResetQuestArrow)
  end
end

local function SetActive(self, active)
  if not IsNull(self.gameObject) then
    self.gameObject:SetActive(active)
  end
end

local function ShowIcon(self, showIcon)
  self.showIcon = showIcon
  self:SetBubbleState(self.state)
end

local function GetGuideNode(self)
  return self.trigger
end

local function GetBubbleState(self)
  return self.state
end

local function Shrink(self, shrink)
  if shrink then
    self.btn_sprite.transform.localScale = Vector3.New(1.1, 1.1, 1.1)
  else
    self.btn_sprite.transform.localScale = Vector3.New(1.25, 1.25, 1.25)
  end
end

local function SetTriggerActive(self, active)
  if self.trigger ~= nil then
    self.trigger.gameObject:SetActive(active)
  end
end

local function GetBubbleIconPath(self, bubbleType)
  if bubbleType == LandLockBubbleType.Green then
    return string.format(LoadPath.UIBuildBubble, "bubble_bg_landlock_locked")
  elseif bubbleType == LandLockBubbleType.Axe then
    return string.format(LoadPath.UIBuildBubble, "bubble_bg_axe")
  elseif bubbleType == LandLockBubbleType.Red then
    return string.format(LoadPath.UIBuildBubble, "bubble_bg_landlock_locked2")
  elseif bubbleType == LandLockBubbleType.Yellow then
    return string.format(LoadPath.UIBuildBubble, "bubble_bg_landlock_locked4")
  elseif bubbleType == LandLockBubbleType.Wood then
    return string.format(LoadPath.UIBuildBubble, "bubble_bg_wood")
  else
    return ""
  end
end

LandLockBubble.__init = __init
LandLockBubble.__delete = __delete
LandLockBubble.OnCreate = OnCreate
LandLockBubble.OnDestroy = OnDestroy
LandLockBubble.Init = Init
LandLockBubble.SetBubbleState = SetBubbleState
LandLockBubble.RefreshCost = RefreshCost
LandLockBubble.RefreshDesc = RefreshDesc
LandLockBubble.RefreshPro = RefreshPro
LandLockBubble.RefreshPosition = RefreshPosition
LandLockBubble.SetColliderSize = SetColliderSize
LandLockBubble.SetReq = SetReq
LandLockBubble.SetOnClick = SetOnClick
LandLockBubble.OnClick = OnClick
LandLockBubble.SetActive = SetActive
LandLockBubble.ShowIcon = ShowIcon
LandLockBubble.GetGuideNode = GetGuideNode
LandLockBubble.GetBubbleState = GetBubbleState
LandLockBubble.Shrink = Shrink
LandLockBubble.SetTriggerActive = SetTriggerActive
LandLockBubble.GetBubbleIconPath = GetBubbleIconPath
LandLockBubble.GetTopIconPath = GetTopIconPath
return LandLockBubble
