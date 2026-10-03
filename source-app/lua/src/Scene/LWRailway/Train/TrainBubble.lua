local TrainBubble = BaseClass("TrainBubble")
local ResourceManager = CS.GameEntry.Resource
local bg_path = "Go/Bg"
local trigger_path = "Go/Trigger"
local icon_path = "Go/Bg/Icon"
local icon_go_path = "Go"
local obj_path = ""
local AnimName = {
  Enter = "EnterBubble",
  Hide = "HideBubble",
  Normal = "NormalBubble",
  ResourceItem = "goodsBubble",
  Default = "Default"
}

function TrainBubble:Init(transform)
  self.transform = transform
  self:DataDefine()
  self:ComponentDefine()
end

function TrainBubble:Destroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function TrainBubble:ComponentDefine()
  if not self.defend then
    self.icon_go = self.transform:Find(icon_go_path):GetComponent(typeof(CS.SimpleAnimation))
    self.icon_sprite = self.transform:Find(icon_path):GetComponent(typeof(CS.SpriteMeshRenderer))
    self.bg_color = self.transform:Find(bg_path):GetComponent(typeof(CS.SpriteMeshRenderer))
    self.bg = self.transform:Find(trigger_path):GetComponent(typeof(CS.TouchObjectEventTrigger))
    self.bg_color:Set_color_a(1.0)
    self.icon_sprite:Set_color_a(1.0)
    self.obj = self.transform:Find(obj_path):GetComponent(typeof(typeof(CS.UnityEngine.Transform)))
    
    function self.bg.onPointerClick()
      self:OnClick()
    end
    
    self.defend = true
  end
end

function TrainBubble:ComponentDestroy()
  self.tweenAnimations = nil
  if not IsNull(self.bg) then
    self.bg.onPointerClick = nil
    self.bg = nil
  end
  self.icon_sprite = nil
  self.gameObject = nil
  self.transform = nil
  self.model_go = nil
  self.bg_color = nil
  self.icon_go = nil
  self.obj = nil
end

function TrainBubble:DataDefine()
  self.param = nil
  self.defend = nil
  self.animationAlreadyShow = false
  self.isShow = false
  self.cdTimer = nil
  self.oldParam = nil
  self.tween = nil
  self.state = nil
end

function TrainBubble:DataDestroy()
  self.isShow = nil
  self.param = nil
  self.defend = nil
  self.animationAlreadyShow = nil
  self.cdTimer = nil
  self.oldParam = nil
  self.fix_bug_timer_action = nil
  self.tween = nil
  self.state = nil
  self.buildData = nil
  self.queueData = nil
end

function TrainBubble:Refresh(param)
  self.param = param
  if not param then
    self.icon_go.gameObject:SetActive(false)
    return
  else
    self.icon_go.gameObject:SetActive(true)
  end
  self.icon_sprite:LoadSprite(self.param.iconName)
  local v = self.param.iconScale
  self.icon_sprite.transform:Set_localScale(v.x, v.y, v.z)
  self.bg_color:LoadSprite(self.param.bgName)
  v = self.param.bgScale
  self.bg_color.transform:Set_localScale(v.x, v.y, v.z)
  self.icon_go:Play(AnimName.Normal)
  self.transform:Set_localPosition(0, 0, 0)
end

function TrainBubble:OnClick()
  if self.param.callBack ~= nil then
    self.param.callBack(self.param)
  end
end

return TrainBubble
