local base = require("Scene.LWRailway.PlaneTrain.PlaneCarriage")
local PlaneCoach = BaseClass("PlaneCoach", base)
local BodyBubble = require("Scene.LWRailway.PlaneTrain.BodyBubble")

function PlaneCoach:ComponentDefine()
  base.ComponentDefine(self)
  if self.onlyShow then
    return
  end
  local carriageCount = self.train.trainData.carriageCount
  if self.index and carriageCount then
    self.bubbleReq = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/LWRailway/BodyBubble.prefab")
    self.bubbleReq:completed("+", function(request)
      if not self.transform then
        return
      end
      local bubble = BodyBubble.New(request.gameObject.transform, self.index)
      bubble.transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.World.Name).transform)
      bubble.transform.position = self.transform:Find("BubblePlaceholder").position
      bubble:Refresh(self.index == carriageCount)
      self.bubble = bubble
    end)
  end
end

function PlaneCoach:Destroy()
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

function PlaneCoach:OnClick()
  RailwayUtil.ClickCityTrain(TrainPreparePage.Passenger)
end

return PlaneCoach
