local KeyFrame = DataClass("KeyFrame")

function KeyFrame:__init(ts, type, point, pos, dir)
  self.ts = ts
  self.type = type
  self.point = point
  self.pos = pos
  self.dir = dir
  self.rot = nil
end

function KeyFrame:__delete()
  self.ts = nil
  self.type = nil
  self.point = nil
  self.pos = nil
  self.dir = nil
  self.rot = nil
end

function KeyFrame:Init()
end

function KeyFrame:GetRot()
end

return KeyFrame
