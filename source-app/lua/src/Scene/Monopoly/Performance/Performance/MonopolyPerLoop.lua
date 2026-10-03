local base = require("Scene.Monopoly.Performance.Performance.MonopolyPerBase")
local MonopolyPerLoop = BaseClass("MonopolyPerLoop", base)

function MonopolyPerLoop:__init(mgr, id, lineData)
  self.director = nil
end

function MonopolyPerLoop:__delete()
  self.director = nil
end

function MonopolyPerLoop:OnDestroy()
  base.OnDestroy(self)
end

function MonopolyPerLoop:Begin()
  base.Begin(self)
end

function MonopolyPerLoop:OnResLoaded(handle)
  base.OnResLoaded(self, handle)
  self.director = handle.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Playables.PlayableDirector))
  handle.gameObject.transform.position = Vector3.zero
end

function MonopolyPerLoop:End()
  base.End(self)
end

return MonopolyPerLoop
