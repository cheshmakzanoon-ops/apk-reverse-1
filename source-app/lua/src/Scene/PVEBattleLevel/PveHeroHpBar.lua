local PveHeroHpBar = BaseClass("PveHeroHpBar")
local bar_path = "HpBar"
local hp_back_path = "HpBar/HpBack"
local hp_front_path = "HpBar/HpFront"
local val_path = "HpBar/Val"
local icon_path = "HpBar/Icon"
local change_path = "Other/Change"
local HP_WIDTH = 1.125
local HP_HEIGHT = 0.145
local HP_BACK_SPEED = 0.2
local SUB_DURATION = 1.5
local ChangeRed = Color32.New(255, 63, 31, 255)
local ChangeGreen = Color32.New(63, 255, 31, 255)

local function __init(self, gameObject)
  self.gameObject = gameObject
  self.transform = gameObject.transform
  self.bar_go = self.transform:Find(bar_path).gameObject
  self.bar_go.transform.localPosition = Vector3.zero
  self.hp_back_sprite = self.transform:Find(hp_back_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.hp_back_sprite.size = Vector2.New(0, HP_HEIGHT)
  self.hp_front_sprite = self.transform:Find(hp_front_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.hp_front_sprite.size = Vector2.New(0, HP_HEIGHT)
  self.val_text = self.transform:Find(val_path):GetComponent((typeof(CS.SuperTextMesh)))
  self.icon_sprite = self.transform:Find(icon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.change_text = self.transform:Find(change_path):GetComponent((typeof(CS.SuperTextMesh)))
  self.cur = 0
  self.max = 0
end

local function __delete(self)
  self.gameObject = nil
  self.transform = nil
  self.bar_go = nil
  self.hp_back_sprite = nil
  self.hp_front_sprite = nil
  self.val_text = nil
  self.icon_sprite = nil
  self.change_text = nil
  self.cur = nil
  self.max = nil
end

local function SetActive(self, active)
  self.gameObject:SetActive(active)
end

local function SetVal(self, cur, max, showChange)
  if showChange then
    self:ShowChange(cur - self.cur, SUB_DURATION)
  end
  self.cur = cur or self.cur
  self.max = max or self.max
  local percent = 0
  if self.max ~= 0 then
    percent = Mathf.Clamp(self.cur / self.max, 0, 1)
  end
  self.hp_front_sprite.size = Vector2.New(HP_WIDTH * percent, HP_HEIGHT)
  self.val_text.text = string.GetFormattedSeperatorNum(self.cur)
end

local function SetIcon(self, iconPath)
  self.hp_front_sprite:LoadSprite(iconPath)
end

local function ShowChange(self, change, duration)
  if 0 < change then
    self.change_text.text = "+" .. string.GetFormattedSeperatorNum(change)
    self.change_text.color = ChangeGreen
  elseif change < 0 then
    self.bar_go.transform:DOShakePosition(duration, Vector3.New(0.4, 0, 0), 45)
    self.change_text.text = string.GetFormattedSeperatorNum(change)
    self.change_text.color = ChangeRed
  else
    return
  end
  self.change_text.gameObject:SetActive(true)
  self.change_text.transform.localPosition = Vector3.zero
  self.change_text.transform:DOLocalMove(Vector3.New(0, 1, 0), duration):OnComplete(function()
    if self.change_text ~= nil and not IsNull(self.change_text.gameObject) then
      self.change_text.gameObject:SetActive(false)
    end
  end)
end

local function OnUpdate(self)
  local targetX = self.hp_front_sprite.size.x
  local curX = self.hp_back_sprite.size.x
  if targetX > curX then
    self.hp_back_sprite.size = Vector2.New(targetX, HP_HEIGHT)
  elseif targetX < curX then
    self.hp_back_sprite.size = Vector2.New(targetX * HP_BACK_SPEED + curX * (1 - HP_BACK_SPEED), HP_HEIGHT)
  end
end

PveHeroHpBar.__init = __init
PveHeroHpBar.__delete = __delete
PveHeroHpBar.SetActive = SetActive
PveHeroHpBar.SetVal = SetVal
PveHeroHpBar.SetIcon = SetIcon
PveHeroHpBar.ShowChange = ShowChange
PveHeroHpBar.Shake = Shake
PveHeroHpBar.OnUpdate = OnUpdate
return PveHeroHpBar
