local base = require("Scene.LWRailway.Train.Carriage.Carriage")
local Locomotive = BaseClass("Locomotive", base)

function Locomotive:ComponentDefine()
  base.ComponentDefine(self)
  self.selectRing = self.transform:Find("Model/TroopSelect").gameObject
  self.selectRing:SetActive(false)
end

function Locomotive:Destroy()
  base.Destroy(self)
end

function Locomotive:ShowSelectRing(bool)
  if self.selectRing then
    self.selectRing:SetActive(bool)
  end
end

return Locomotive
