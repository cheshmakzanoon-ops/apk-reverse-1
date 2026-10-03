local AircraftBubbleTip = BaseClass("AircraftBubbleTip")
local path = "Assets/Main/Prefabs/UI/State/BuildStateIcon.prefab"
local Resource = CS.GameEntry.Resource

function AircraftBubbleTip:__init()
  self.transform = nil
  self.icon = nil
  self.bg = nil
  self.req = nil
end

function AircraftBubbleTip:Init(data)
  self.data = data
  self:CreateModel()
end

function AircraftBubbleTip:CreateModel()
  self.req = Resource:InstantiateAsync(path)
  self.req:completed("+", function(req)
    self.transform = req.gameObject.transform
    self.gameObject = req.gameObject
    req.gameObject.name = "AircraftBubbleTip"
    self.icon = self.transform:Find("Go/Bg/Icon").gameObject:GetComponent(typeof(CS.SpriteMeshRenderer))
    self.bg = self.transform:Find("Go/Bg").gameObject:GetComponent(typeof(CS.SpriteMeshRenderer))
    self:RefreshIcon(WorkerUtil.GetWorkerIconPath(self.data.modelId))
    self:RefreshBg(string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1))
    self:RefreshPosition(self.data.pos)
    self.simpleAnimation = self.transform:Find("Go").gameObject:GetComponent(typeof(CS.SimpleAnimation))
    self.simpleAnimation:Play("EnterBubble")
    req.gameObject.transform:SetParent(CS.SceneManager.World.BuildBubbleNode)
    self.simpleAnimation.playAutomatically = false
    self:SetActive(DataCenter.GainWorkerManager:GetIsShowAllBubble())
  end)
end

function AircraftBubbleTip:RefreshIcon(iconPath)
  if self.icon and iconPath then
    UIUtil.LoadSpriteRenderAuto(self.icon, iconPath)
  end
end

function AircraftBubbleTip:RefreshBg(bgPath)
  if self.bg and bgPath then
    self.bg:LoadSprite(bgPath)
  end
end

function AircraftBubbleTip:RefreshPosition(pos)
  if self.transform and pos then
    self.transform.position = pos
  end
end

function AircraftBubbleTip:SetActive(isOn)
  if self.gameObject then
    self.gameObject:SetActive(isOn)
  end
end

function AircraftBubbleTip:__delete()
  if self.req then
    self.req:Destroy()
    self.req = nil
  end
  self.transform = nil
  self.icon = nil
  self.bg = nil
end

return AircraftBubbleTip
