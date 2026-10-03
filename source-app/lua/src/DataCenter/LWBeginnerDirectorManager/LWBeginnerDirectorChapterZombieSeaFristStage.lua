local base = require("DataCenter.LWBeginnerDirectorManager.LWBeginnerDirectorChapterBase")
local LWBeginnerDirectorChapterZombieSeaFristStage = BaseClass("LWBeginnerDirectorChapterZombieSeaFristStage", base)

function LWBeginnerDirectorChapterZombieSeaFristStage:__init()
  self.directorScript = {
    {
      Id = 1,
      PointType = BeginnerScriptPointType.GuideFLow,
      Params = {6003},
      Conditions = {
        [BeginnerScriptPointTriggerType.Time] = {0}
      }
    },
    {
      Id = 2,
      PointType = BeginnerScriptPointType.MoveCamera,
      Params = {
        93,
        75,
        1
      },
      Conditions = {
        [BeginnerScriptPointTriggerType.WaitPreDone] = {1}
      }
    },
    {
      Id = 3,
      PointType = BeginnerScriptPointType.SpawnCityZombie,
      Params = {
        {
          {row = 15, col = 6},
          {row = 16, col = 9},
          {row = 15, col = 13}
        },
        {1, 5},
        {1, 4},
        0,
        10
      },
      Conditions = {
        [BeginnerScriptPointTriggerType.WaitPreDone] = {2}
      }
    },
    {
      Id = 4,
      PointType = BeginnerScriptPointType.SpawnCityZombie,
      Params = {
        {
          {row = 15, col = 20},
          {row = 16, col = 26},
          {row = 15, col = 30}
        },
        {1, 5},
        {1, 4},
        0,
        8
      },
      Conditions = {
        [BeginnerScriptPointTriggerType.WaitPreDone] = {2}
      }
    },
    {
      Id = 5,
      PointType = BeginnerScriptPointType.SpawnCityZombie,
      Params = {
        {
          {row = 15, col = 36},
          {row = 15, col = 39}
        },
        {5, 15},
        {1, 1},
        100,
        22
      },
      Conditions = {
        [BeginnerScriptPointTriggerType.WaitPreDone] = {2}
      }
    },
    {
      Id = 6,
      PointType = BeginnerScriptPointType.SpawnCityZombie,
      Params = {
        {
          {row = 15, col = 45},
          {row = 15, col = 48},
          {row = 15, col = 54}
        },
        {1, 3},
        {2, 6},
        0
      },
      Conditions = {
        [BeginnerScriptPointTriggerType.WaitPreDone] = {2}
      }
    },
    {
      Id = 7,
      PointType = BeginnerScriptPointType.SpawnCityZombie,
      Params = {
        {
          {row = 15, col = 56},
          {row = 15, col = 50},
          {row = 15, col = 69}
        },
        {5, 20},
        {1, 1},
        100,
        25
      },
      Conditions = {
        [BeginnerScriptPointTriggerType.WaitPreDone] = {2}
      }
    },
    {
      Id = 8,
      PointType = BeginnerScriptPointType.SpawnCityZombie,
      Params = {
        {
          {row = 15, col = 61},
          {row = 16, col = 68},
          {row = 15, col = 69}
        },
        {1, 3},
        {2, 6},
        0
      },
      Conditions = {
        [BeginnerScriptPointTriggerType.WaitPreDone] = {2}
      }
    },
    {
      Id = 9,
      PointType = BeginnerScriptPointType.SpawnCityZombie,
      Params = {
        {
          {row = 15, col = 26},
          {row = 16, col = 22},
          {row = 15, col = 13}
        },
        {5, 20},
        {1, 1},
        100,
        20
      },
      Conditions = {
        [BeginnerScriptPointTriggerType.WaitPreDone] = {2}
      }
    }
  }
  self.chapterName = "LWBeginnerDirectorChapterZombieSeaFristStage"
end

function LWBeginnerDirectorChapterZombieSeaFristStage:__delete()
  self.directorScript = nil
end

return LWBeginnerDirectorChapterZombieSeaFristStage
