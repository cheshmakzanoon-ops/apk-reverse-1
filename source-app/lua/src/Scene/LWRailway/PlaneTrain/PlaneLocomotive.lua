local base = require("Scene.LWRailway.PlaneTrain.PlaneCarriage")
local PlaneLocomotive = BaseClass("PlaneLocomotive", base)
local HeadBubble = require("Scene.LWRailway.PlaneTrain.HeadBubble")

function PlaneLocomotive:ComponentDefine()
  base.ComponentDefine(self)
  if self.onlyShow then
    return
  end
  self.bubbleReq = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/LWRailway/HeadBubble.prefab")
  self.bubbleReq:completed("+", function(request)
    if not self.transform then
      return
    end
    local bubble = HeadBubble.New(request.gameObject.transform, self.index)
    bubble.transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.World.Name).transform)
    bubble.transform.position = self.transform:Find("BubblePlaceholder").position
    bubble:Refresh()
    self.bubble = bubble
  end)
end

function PlaneLocomotive:Destroy()
  if self.bubble then
    self.bubble:Delete()
    self.bubble = nil
  end
  if self.bubbleReq then
    self.bubbleReq:Destroy()
    self.bubbleReq = nil
  end
  base.Destroy(self)
end

function PlaneLocomotive:OnClick()
  RailwayUtil.ClickCityTrain(TrainPreparePage.Driver)
end

return PlaneLocomotive
